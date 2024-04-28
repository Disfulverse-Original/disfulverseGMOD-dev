util.AddNetworkString( "BRS.Net.OpenMarketplace" )

local playerMeta = FindMetaTable("Player")

util.AddNetworkString( "BRS.Net.UpdateMarketplace" )
function playerMeta:UpdateMarketplace()
	net.Start( "BRS.Net.UpdateMarketplace" )
		net.WriteTable( BRS_MARKETPLACE or {} )
	net.Send( self )
end

function BRICKS_SERVER.Func.UpdateMarketplaceEntry( marketKey, key, value, insert )
	if( BRS_MARKETPLACE[marketKey] ) then
		if( not insert ) then
			BRS_MARKETPLACE[marketKey][key] = value
		end

		if( BRICKS_SERVER.ESSENTIALS.LUACFG.UseMySQL != true ) then
			if( not file.Exists( "bricks_server/marketplace", "DATA" ) ) then
				file.CreateDir( "bricks_server/marketplace" )
			end

			file.Write( "bricks_server/marketplace/" .. marketKey .. ".txt", util.TableToJSON( BRS_MARKETPLACE[marketKey] ) )
		else
			if( not insert ) then
				local keysToKeys = { "amount", "currentbid", "time", "starttime", "itemdata", "owner", "bidders", "ownercollected", "winnercollected" }
				if( not keysToKeys[key] ) then return end
				BRS_UpdateMarketDBValue( "bricks_server_marketplace", marketKey, keysToKeys[key], value )
			else
				BRS_InsertMarketDBValue( "bricks_server_marketplace", marketKey, BRS_MARKETPLACE[marketKey] )
			end
		end
	end
end

function BRICKS_SERVER.Func.DeleteMarketplaceEntry( marketKey )
	if( BRS_MARKETPLACE[marketKey] ) then
		BRS_MARKETPLACE[marketKey] = nil

		if( BRICKS_SERVER.ESSENTIALS.LUACFG.UseMySQL != true ) then
			if( file.Exists( "bricks_server/marketplace/" .. marketKey .. ".txt", "DATA" ) ) then
				file.Delete( "bricks_server/marketplace/" .. marketKey .. ".txt" )
			end
		else
			BRS_DeleteMarketDBValue( "bricks_server_marketplace", marketKey )
		end
	end
end

function BRICKS_SERVER.Func.UpdateMarketplace()
	for k, v in pairs( BRS_PLYSIN_MARKETPLACE or {} ) do
		if( IsValid( k ) ) then
			k:UpdateMarketplace()
		else
			BRS_PLYSIN_MARKETPLACE[k] = nil
		end
	end
end

util.AddNetworkString( "BRS.Net.MarketplaceClose" )
net.Receive( "BRS.Net.MarketplaceClose", function( len, ply )
	if( not BRS_PLYSIN_MARKETPLACE or not BRS_PLYSIN_MARKETPLACE[ply] ) then return end

	BRS_PLYSIN_MARKETPLACE[ply] = nil
end )

util.AddNetworkString( "BRS.Net.MarketplaceAdd" )
net.Receive( "BRS.Net.MarketplaceAdd", function( len, ply )
	local inventoryKey = net.ReadUInt( 10 )
	local amount = net.ReadUInt( 10 )
	local auctionPrice = net.ReadUInt( 32 )
	local auctionTime = net.ReadUInt( 32 )
	local buyoutPrice = net.ReadUInt( 32 )
	local isbought = net.ReadBool()
	if( not inventoryKey or not amount or not auctionPrice or not auctionTime ) then return end

	local plyInventory = ply:BRS():GetInventory()

	if( not plyInventory or not plyInventory[inventoryKey] ) then return end

	if( amount > (plyInventory[inventoryKey][1] or 1) ) then
		DarkRP.notify( ply, 1, 5, "У вас недостаточно предметов!" )
		return
	end

	if( auctionTime < (BRICKS_SERVER.CONFIG.MARKETPLACE["Minimum Auction Time"] or 300) or auctionTime > (BRICKS_SERVER.CONFIG.MARKETPLACE["Maximum Auction Time"] or 86400) ) then
		DarkRP.notify( ply, 1, 5, "Minimum time is " .. (BRICKS_SERVER.CONFIG.MARKETPLACE["Minimum Auction Time"] or 300) .. ", maximum is " .. (BRICKS_SERVER.CONFIG.MARKETPLACE["Maximum Auction Time"] or 86400) .. "!" )
		return
	end

	if( auctionPrice < (BRICKS_SERVER.CONFIG.MARKETPLACE["Minimum Starting Price"] or 1000) ) then
		DarkRP.notify( ply, 1, 5, "Minimum price is " .. (BRICKS_SERVER.CONFIG.MARKETPLACE["Minimum Starting Price"] or 1000) .. "!" )
		return
	end

	if( not ply:SteamID64() ) then return end
	
	local newAuction = { 
	    amount,        -- Amount of items
	    auctionPrice,  -- Starting bid price
	    auctionTime,   -- Auction duration
	    os.time(),     -- Start time
	    (plyInventory[inventoryKey][2] or {}),      -- Item data
	    ply:SteamID64(), -- Owner's SteamID
	    ply:Nick(),    -- Owner's nickname
	    buyoutPrice,   -- Buyout price
	    false          -- Flag for buyout status
	}

	--local newAuction = { amount, auctionPrice, auctionTime, os.time(), (plyInventory[inventoryKey][2] or {}), ply:SteamID64(), ply:Nick() }

	plyInventory[inventoryKey][1] = (plyInventory[inventoryKey][1] or 1)-amount

	if( plyInventory[inventoryKey][1] < 1 ) then
		plyInventory[inventoryKey] = nil
	end

	ply:BRS():SetInventory( plyInventory )

	if( not BRS_MARKETPLACE ) then
		BRS_MARKETPLACE = {}
	end

	local marketKey = table.insert( BRS_MARKETPLACE, newAuction )

	BRICKS_SERVER.Func.UpdateMarketplaceEntry( marketKey, "", "", true )
	BRICKS_SERVER.Func.UpdateMarketplace()
	--PrintTable(newAuction)

	DarkRP.notify( ply, 1, 5, "Ваш аукцион создан!" )
end )

util.AddNetworkString( "BRS.Net.MarketplaceCancel" )
net.Receive( "BRS.Net.MarketplaceCancel", function( len, ply )
	local marketKey = net.ReadUInt( 16 )
	local ownerSteamID64 = net.ReadString()

	if( not marketKey or not ownerSteamID64 or not BRS_MARKETPLACE or not BRS_MARKETPLACE[marketKey] or BRS_MARKETPLACE[marketKey][6] != ownerSteamID64 ) then return end

	local marketItem = BRS_MARKETPLACE[marketKey]
	if( os.time() >= ((marketItem[4] or 0)+(marketItem[3] or 0)) ) then
		DarkRP.notify( ply, 1, 5, "The auction has already ended for this item!" )
		return
	end

	if( (ownerSteamID64 == ply:SteamID64() and marketItem[6] == ply:SteamID64()) or BRICKS_SERVER.Func.HasAdminAccess( ply ) ) then
		BRS_MARKETPLACE[marketKey][3] = 0
		BRICKS_SERVER.Func.UpdateMarketplaceEntry( marketKey, 3, 0 )

		BRICKS_SERVER.Func.UpdateMarketplace()	

		if( ownerSteamID64 == ply:SteamID64() and marketItem[6] == ply:SteamID64() ) then
			DarkRP.notify( ply, 1, 5, "Аукцион отменен!" )
		elseif( BRICKS_SERVER.Func.HasAdminAccess( ply ) ) then
			DarkRP.notify( ply, 1, 5, "Auction cancelled by admin!" )
		end
	end
end )

util.AddNetworkString( "BRS.Net.MarketplaceBid" )
net.Receive( "BRS.Net.MarketplaceBid", function( len, ply )
	local marketKey = net.ReadUInt( 16 )
	local bidAmount = net.ReadUInt( 32 )
	local ownerSteamID64 = net.ReadString() -- Confirm same item

	if( not marketKey or not bidAmount or not ownerSteamID64 or ownerSteamID64 == ply:SteamID64() ) then return end

	if( not BRS_MARKETPLACE or not BRS_MARKETPLACE[marketKey] or (BRS_MARKETPLACE[marketKey][6] or "") != ownerSteamID64 ) then
		DarkRP.notify( ply, 1, 5, "BRICKS SERVER ERROR: Invalid item!" )
		return
	end

	local marketItem = BRS_MARKETPLACE[marketKey]

	if( (table.GetWinningKey( marketItem[10] or {} ) or "") == ply:SteamID() ) then
		DarkRP.notify( ply, 1, 5, "У вас уже наивысшая ставка!" )
		return
	end

	if( bidAmount < math.floor( (marketItem[2] or 1000)*(BRICKS_SERVER.CONFIG.MARKETPLACE["Minimum Bid Increment"] or 1.1) ) ) then
		DarkRP.notify( ply, 1, 5, "Вы должны поставить хотя бы на 10% больше чем текущее значение!" )
		return
	end

	if( os.time() >= ((marketItem[4] or 0)+(marketItem[3] or 0)) ) then
		DarkRP.notify( ply, 1, 5, "Аукцион за этот предмет уже закончился!" )
		return
	end

	local currencyTable
    if( BRICKS_SERVER.DEVCONFIG.Currencies[(BRICKS_SERVER.CONFIG.MARKETPLACE or {})["Currency"] or ""] ) then
        currencyTable = BRICKS_SERVER.DEVCONFIG.Currencies[(BRICKS_SERVER.CONFIG.MARKETPLACE or {})["Currency"] or ""]
    end

    if( not currencyTable ) then 
        DarkRP.notify( ply, 1, 5, "BRICKS SERVER ERROR: Invalid Currency" )
        return 
    end

	local moneyToTake = bidAmount
	if( (BRS_MARKETPLACE[marketKey][10] or {})[ply:SteamID()] ) then
		moneyToTake = bidAmount-((BRS_MARKETPLACE[marketKey][10] or {})[ply:SteamID()] or 0)
	end

	if( currencyTable.getFunction( ply ) >= moneyToTake ) then
		currencyTable.addFunction( ply, -moneyToTake )

		if( not BRS_MARKETPLACE[marketKey][10] ) then
			BRS_MARKETPLACE[marketKey][10] = {}
		end

		BRS_MARKETPLACE[marketKey][2] = bidAmount
		BRS_MARKETPLACE[marketKey][10][ply:SteamID()] = bidAmount

		BRICKS_SERVER.Func.UpdateMarketplaceEntry( marketKey, 2, bidAmount )
		BRICKS_SERVER.Func.UpdateMarketplaceEntry( marketKey, 10, BRS_MARKETPLACE[marketKey][10] )
		BRICKS_SERVER.Func.UpdateMarketplace()
		--PrintTable(marketItem)
		DarkRP.notify( ply, 1, 5, "Ставка в размере " .. currencyTable.formatFunction( bidAmount ) .. " поставлена!" )
	else
		DarkRP.notify( ply, 1, 5, "У вас недостаточно денег для этой ставки!" )
	end
	--PrintTable(marketItem)
end )

--
util.AddNetworkString("BRS.Net.MarketplaceBuyout")
net.Receive("BRS.Net.MarketplaceBuyout", function(len, ply)
    local marketKey = net.ReadUInt(16)
    local ownerSteamID64 = net.ReadString() -- Confirm same item
    local ownerply = player.GetBySteamID64(ownerSteamID64)
    --print("owner is " .. ownerply:Name() )

    if not marketKey or not BRS_MARKETPLACE[marketKey] then return end

	if( not BRS_MARKETPLACE or not BRS_MARKETPLACE[marketKey] or (BRS_MARKETPLACE[marketKey][6] or "") != ownerSteamID64 ) then
		DarkRP.notify( ply, 1, 5, "BRICKS SERVER ERROR: Неправильный предмет!" )
		return
	end

    local marketItem = BRS_MARKETPLACE[marketKey]
    if marketItem[9] then
        DarkRP.notify(ply, 1, 5, "This item has already been sold!")
        return
    end

    local buyoutPrice = marketItem[8] -- Assuming buyout price is stored at index 8
    if not buyoutPrice then return end

    -- Check if player has enough money
    local currencyTable = BRICKS_SERVER.DEVCONFIG.Currencies[BRICKS_SERVER.CONFIG.MARKETPLACE.Currency] or nil
    if not currencyTable then return end

    if (currencyTable.getFunction(ply) >= buyoutPrice) then
        currencyTable.addFunction(ply, -buyoutPrice)
		DarkRP.notify( ply, 1, 5, "Вы потратили: " .. currencyTable.formatFunction( (marketItem[8] or 0) ) .. " на выкуп этого предмета!" )
        -- Set item as bought out

		if( not BRS_MARKETPLACE[marketKey][13] ) then
			BRS_MARKETPLACE[marketKey][13] = {}
		end

		BRS_MARKETPLACE[marketKey][13] = ply:SteamID()
        BRS_MARKETPLACE[marketKey][9] = true
		BRS_MARKETPLACE[marketKey][3] = -1
		BRICKS_SERVER.Func.UpdateMarketplaceEntry( marketKey, 13, BRS_MARKETPLACE[marketKey][13] )
        BRICKS_SERVER.Func.UpdateMarketplaceEntry(marketKey, 9, true)
        BRICKS_SERVER.Func.UpdateMarketplaceEntry( marketKey, 3, -1 )
		BRICKS_SERVER.Func.UpdateMarketplace()

        --local infoTable = BRICKS_SERVER.Func.GetEntTypeField( ((marketItem[5] or {})[1] or ""), "GetInfo" )( marketItem[5] or {} )
        
		--BRS_MARKETPLACE[marketKey][3] = 0
		--BRICKS_SERVER.Func.UpdateMarketplaceEntry( marketKey, 3, 0 )



        --BRICKS_SERVER.Func.UpdateMarketplace()

        --ply:BRS():AddInventoryItem( (marketItem[5] or {}), (marketItem[1] or 1) )
        --DarkRP.notify( ply, 1, 5, "Собрано " .. infoTable[1] .. " с аукциона!" )
        --print("купил " .. ply:Name())

        

		--currencyTable.addFunction( ownerply, (marketItem[8] or 0) )
		--DarkRP.notify( ownerply, 1, 5, "Собрано " .. currencyTable.formatFunction( (marketItem[8] or 0) ) .. " с аукциона!" )
		--print("получил деньги: " ..ownerply:Name())
        --PrintTable(marketItem)
        --print(BRS_MARKETPLACE[marketKey][13])

        
        --BRICKS_SERVER.Func.DeleteMarketplaceEntry( marketKey )
        --BRICKS_SERVER.Func.UpdateMarketplace() 
    --[[
	elseif( BRS_MARKETPLACE[marketKey][10] and BRS_MARKETPLACE[marketKey][10][ply:SteamID()] ) then -- losers get money back
		local moneyBack = (BRS_MARKETPLACE[marketKey][10] or {})[ply:SteamID()]
		BRS_MARKETPLACE[marketKey][10][ply:SteamID()] = nil
		BRICKS_SERVER.Func.UpdateMarketplaceEntry( marketKey, 10, BRS_MARKETPLACE[marketKey][10] )
		currencyTable.addFunction( ply, moneyBack )
		DarkRP.notify( ply, 1, 5, "Собрано " .. currencyTable.formatFunction( moneyBack ) .. " с аукциона!" )
	--]]
    else
        DarkRP.notify(ply, 1, 5, "У вас не хватает денег на выкуп этого предмета!")
    end
    --BRICKS_SERVER.Func.UpdateMarketplace()
end)
--

util.AddNetworkString( "BRS.Net.MarketplaceCollect" )
net.Receive( "BRS.Net.MarketplaceCollect", function( len, ply )
	local marketKey = net.ReadUInt( 16 )
	local ownerSteamID64 = net.ReadString() -- Confirm same item

	if( not marketKey or not ownerSteamID64 ) then return end

	if( not BRS_MARKETPLACE or not BRS_MARKETPLACE[marketKey] or (BRS_MARKETPLACE[marketKey][6] or "") != ownerSteamID64 ) then
		DarkRP.notify( ply, 1, 5, "BRICKS SERVER ERROR: Invalid item!" )
		return
	end

	local marketItem = BRS_MARKETPLACE[marketKey]

	if( os.time() < ((marketItem[4] or 0)+(marketItem[3] or 0)) ) then
		DarkRP.notify( ply, 1, 5, "The auction is still on going!" )
		return
	elseif not marketItem[9] and not marketItem[10] and not (BRS_MARKETPLACE[marketKey][6] or "") == ply:SteamID64() then
		DarkRP.notify( ply, 1, 5, "Item was not bought!" )
		return
	end

	local currencyTable
    if( BRICKS_SERVER.DEVCONFIG.Currencies[(BRICKS_SERVER.CONFIG.MARKETPLACE or {})["Currency"] or ""] ) then
        currencyTable = BRICKS_SERVER.DEVCONFIG.Currencies[(BRICKS_SERVER.CONFIG.MARKETPLACE or {})["Currency"] or ""]
    end

    if( not currencyTable ) then 
        DarkRP.notify( ply, 1, 5, "BRICKS SERVER ERROR: Invalid Currency" )
        return 
	end
	
	local changed = false
	if marketItem[9] and (marketItem[13] == ply:SteamID()) then

		changed = true

		
		if( not marketItem[14] ) then
			BRS_MARKETPLACE[marketKey][14] = true
			BRICKS_SERVER.Func.UpdateMarketplaceEntry( marketKey, 14, true )
		end
		
		ply:BRS():AddInventoryItem( (marketItem[5] or {}), (marketItem[1] or 1) )

		local infoTable = BRICKS_SERVER.Func.GetEntTypeField( ((marketItem[5] or {})[1] or ""), "GetInfo" )( marketItem[5] or {} )
		DarkRP.notify( ply, 1, 5, "Вы получили " .. infoTable[1] .. " с аукциона!" )

	elseif( (table.GetWinningKey( marketItem[10] or {} ) or "") == ply:SteamID() and ( (marketItem[3] or 0) > 0 ) and ( not marketItem[13] and not marketItem[9] and not marketItem[14] ) ) then -- winner gets item
		if( not marketItem[11] ) then
			changed = true
			BRS_MARKETPLACE[marketKey][11] = true
			BRICKS_SERVER.Func.UpdateMarketplaceEntry( marketKey, 11, true )

			ply:BRS():AddInventoryItem( (marketItem[5] or {}), (marketItem[1] or 1) )

			local infoTable = BRICKS_SERVER.Func.GetEntTypeField( ((marketItem[5] or {})[1] or ""), "GetInfo" )( marketItem[5] or {} )

			DarkRP.notify( ply, 1, 5, "Вы выиграли " .. infoTable[1] .. " с аукциона!" )
		end
	elseif( BRS_MARKETPLACE[marketKey][10] and BRS_MARKETPLACE[marketKey][10][ply:SteamID()] ) then -- losers get money back
		changed = true
		local moneyBack = (BRS_MARKETPLACE[marketKey][10] or {})[ply:SteamID()]
		BRS_MARKETPLACE[marketKey][10][ply:SteamID()] = nil
		BRICKS_SERVER.Func.UpdateMarketplaceEntry( marketKey, 10, BRS_MARKETPLACE[marketKey][10] )
		currencyTable.addFunction( ply, moneyBack )
		DarkRP.notify( ply, 1, 5, "Возвращено " .. currencyTable.formatFunction( moneyBack ) .. " с аукциона!" )
	end
		
	if( (BRS_MARKETPLACE[marketKey][6] or "") == ply:SteamID64() and not marketItem[12] ) then -- owner gets item/money

		if( marketItem[10] and (table.Count( marketItem[10] ) or 0) > 0 and (marketItem[3] or 0) > 0 ) then
			currencyTable.addFunction( ply, (marketItem[2] or 0) )
			DarkRP.notify( ply, 1, 5, "Вы собрали " .. currencyTable.formatFunction( (marketItem[2] or 0) ) .. " с аукциона!" )

		elseif marketItem[13] and marketItem[9] then
			currencyTable.addFunction( ply, (marketItem[2] or 0) )
			DarkRP.notify( ply, 1, 5, "Вы собрали " .. currencyTable.formatFunction( (marketItem[8] or 0) ) .. " с аукциона!" )

		else
			ply:BRS():AddInventoryItem( (marketItem[5] or {}), (marketItem[1] or 1) )

			local infoTable = BRICKS_SERVER.Func.GetEntTypeField( ((marketItem[5] or {})[1] or ""), "GetInfo" )( marketItem[5] or {} )

			DarkRP.notify( ply, 1, 5, "Вы вернули " .. infoTable[1] .. " с аукциона!" )
		end
		BRS_MARKETPLACE[marketKey][12] = true
		BRICKS_SERVER.Func.UpdateMarketplaceEntry( marketKey, 12, true )
		changed = true
	end

	if( changed ) then 
		if( BRS_MARKETPLACE[marketKey][12] and (BRS_MARKETPLACE[marketKey][11] and (table.Count( BRS_MARKETPLACE[marketKey][10] or {} ) <= 0) ) ) then
			local bidders = BRS_MARKETPLACE[marketKey][10] or {}
			if( table.Count( bidders ) <= 0 or (table.Count( bidders ) == 1 and bidders[(marketItem[6] or "")]) ) then
				BRICKS_SERVER.Func.DeleteMarketplaceEntry( marketKey )
			end
		elseif( BRS_MARKETPLACE[marketKey][14] and (BRS_MARKETPLACE[marketKey][12] and (table.Count( BRS_MARKETPLACE[marketKey][10] or {} ) <= 0) ) ) then
			local bidders = BRS_MARKETPLACE[marketKey][10] or {}
			if( table.Count( bidders ) <= 0 or (table.Count( bidders ) == 1 and bidders[(marketItem[6] or "")]) ) then
				BRICKS_SERVER.Func.DeleteMarketplaceEntry( marketKey )
			end
		end

		BRICKS_SERVER.Func.UpdateMarketplace() 
	end

	--PrintTable(marketItem)
end )

util.AddNetworkString( "BRS.Net.MarketplaceAdminRemove" )
net.Receive( "BRS.Net.MarketplaceAdminRemove", function( len, ply )
	local marketKey = net.ReadUInt( 16 )
	local ownerSteamID64 = net.ReadString()

	if( not marketKey or not ownerSteamID64 or not BRS_MARKETPLACE or not BRS_MARKETPLACE[marketKey] or BRS_MARKETPLACE[marketKey][6] != ownerSteamID64 ) then return end

	local marketItem = BRS_MARKETPLACE[marketKey]

	if( BRICKS_SERVER.Func.HasAdminAccess( ply ) ) then
		BRICKS_SERVER.Func.DeleteMarketplaceEntry( marketKey )
		BRICKS_SERVER.Func.UpdateMarketplace()	

		DarkRP.notify( ply, 1, 5, "Auction removed by admin!" )
	end
end )

hook.Add( "Initialize", "BRS.Initialize_Marketplace", function()	
	timer.Create( "BRS_TIMER_EXPIREDREMOVE", 300, 0, function()
		if( BRS_MARKETPLACE ) then
			for k, v in pairs( BRS_MARKETPLACE ) do
				local endTime = (v[4] or 0)+(v[3] or 0)+(BRICKS_SERVER.CONFIG.MARKETPLACE["Remove After Auction End Time"] or 86400)
				if( os.time() >= endTime ) then
					BRICKS_SERVER.Func.DeleteMarketplaceEntry( k )
				end
			end
		end
	end )

	BRS_MARKETPLACE = {}
	if( BRICKS_SERVER.ESSENTIALS.LUACFG.UseMySQL != true ) then
		if( not file.Exists( "bricks_server/marketplace", "DATA" ) ) then
			file.CreateDir( "bricks_server/marketplace" )
		end

		local files, directories = file.Find( "bricks_server/marketplace/*", "DATA" )
		for k, v in pairs( files ) do
			local marketItem = util.JSONToTable( file.Read( "bricks_server/marketplace/" .. v, "DATA" ) )
			local marketKey = tonumber( string.Replace( v, ".txt", "" ) )
			if( marketKey and isnumber( marketKey ) and marketItem and istable( marketItem ) ) then
				local endTime = (marketItem[4] or 0)+(marketItem[3] or 0)+(BRICKS_SERVER.CONFIG.MARKETPLACE["Remove After Auction End Time"] or 86400)
				if( os.time() >= endTime ) then
					BRICKS_SERVER.Func.DeleteMarketplaceEntry( marketKey )
				else
					BRS_MARKETPLACE[marketKey] = marketItem
				end
			elseif( marketKey and isnumber( marketKey ) ) then
				BRICKS_SERVER.Func.DeleteMarketplaceEntry( marketKey )
			end
		end
	else
		BRS_FetchMarketDBValues( "bricks_server_marketplace", function( data ) 
			if( not data ) then return end

			for k, v in pairs( data ) do
				local marketItem = { (v.amount or 0), (v.currentbid or 0), (v.time or 0), (v.starttime or 0), util.JSONToTable( v.itemdata or "" ), (v.owner or "") }
				if( v.bidders ) then marketItem[8] = util.JSONToTable( v.bidders or "" ) end
				if( v.ownercollected ) then marketItem[9] = tobool( v.ownercollected ) end
				if( v.winnercollected ) then marketItem[10] = tobool( v.winnercollected ) end
				local marketKey = tonumber( v.marketkey or 0 )
				if( marketKey and isnumber( marketKey ) and marketKey > 0 and marketItem and istable( marketItem ) ) then
					local endTime = (marketItem[4] or 0)+(marketItem[3] or 0)+(BRICKS_SERVER.CONFIG.MARKETPLACE["Remove After Auction End Time"] or 86400)
					if( os.time() >= endTime ) then
						BRICKS_SERVER.Func.DeleteMarketplaceEntry( marketKey )
					else
						BRS_MARKETPLACE[marketKey] = marketItem
					end
				elseif( marketKey and isnumber( marketKey ) ) then
					BRICKS_SERVER.Func.DeleteMarketplaceEntry( marketKey )
				end
			end
		end )
	end
end )