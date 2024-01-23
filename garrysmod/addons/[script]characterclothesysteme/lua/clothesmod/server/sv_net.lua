util.AddNetworkString("ClothesMod:CharacterCreationMenu")
util.AddNetworkString("ClothesMod:BroadcastPlayersInfos")
util.AddNetworkString("ClothesMod:BroadcastPlayerInfos")
util.AddNetworkString("ClothesMod:ReceiveCharacterCreated")
util.AddNetworkString("ClothesMod:BroadcastShopsInfo")
util.AddNetworkString("ClothesMod:PlayerHasLoaded")
util.AddNetworkString("ClothesMod:ChangeNameMenu")
util.AddNetworkString("ClothesMod:ChangeName")
util.AddNetworkString("ClothesMod:ClothesShop")
util.AddNetworkString("ClothesMod:ClothesArmory")
util.AddNetworkString("ClothesMod:ChangeClothes")
util.AddNetworkString("ClothesMod:ClothesCreation")
util.AddNetworkString("ClothesMod:CustomTeeCreation")
util.AddNetworkString("ClothesMod:BroadcastTextureInfo")
util.AddNetworkString("ClothesMod:BuyClothes")
util.AddNetworkString("ClothesMod:CustomTeeCreationShop")
util.AddNetworkString("ClothesMod:OpenAdminMenu")
util.AddNetworkString("ClothesMod:DropClothesMenu")
util.AddNetworkString("ClothesMod:DropCloth")
util.AddNetworkString("ClothesMod:SurgeryMenu")
util.AddNetworkString("ClothesMod:Surgery")
util.AddNetworkString("ClothesMod:RemoveCloth")

local spamCooldowns = {}
local interval = .1

local function spamCheck(pl, name)
    if spamCooldowns[pl:SteamID()] then
        if spamCooldowns[pl:SteamID()][name] then
            if spamCooldowns[pl:SteamID()][name] > CurTime() then
                return false
            else
                spamCooldowns[pl:SteamID()][name] = CurTime() + interval
                return true
            end
        else
            spamCooldowns[pl:SteamID()][name] = CurTime() + interval
            return true
        end
    else
        spamCooldowns[pl:SteamID()] = {}
        spamCooldowns[pl:SteamID()][name] = CurTime() + interval

        return true
    end
end

local defMaleInfos = {
	model = "models/kerry/player/citizen/male_01.mdl",
	name = "Julien",
	surname = "Smith",
	sex = 1,
	playerColor = Vector(1,1,1),
	bodygroups = {
		top = "polo",
		pant = "pant",
	},
	skin = 0,
	eyestexture = {
		basetexture = {
			["r"] = "eyes/eyes/amber_r",
			["l"] = "eyes/eyes/amber_l",
		},
	},
	hasCostume = false, -- disable tee and pant and shoes texture
	teetexture = {
		basetexture = "models/citizen/body/citizen_sheet", -- name of the tee Choosen in the first part of the menu
		hasCustomThings = false, -- if has custom things or not, if true then basetexture should be an id
	},
	panttexture = {
		basetexture = "models/citizen/body/citizen_sheet",
	},
}

local defFemaleInfos = {
	model = "models/kerry/player/citizen/female_01.mdl",
	name = "Julien",
	surname = "Smith",
	sex = 0,
	playerColor = Vector(1,1,1),
	bodygroups = {
		top = "polo",
		pant = "pant",
	},
	skin = 0,
	eyestexture = {
		basetexture = {
			["r"] = "eyes/eyes/amber_r",
			["l"] = "eyes/eyes/amber_l",
		},
	},
	hasCostume = false, -- disable tee and pant and shoes texture
	teetexture = {
		basetexture = "models/humans/modern/female/sheet_01", -- name of the tee Choosen in the first part of the menu
		hasCustomThings = false, -- if has custom things or not, if true then basetexture should be an id
	},
	panttexture = {
		basetexture = "models/humans/modern/female/sheet_01",
	},
}

net.Receive("ClothesMod:RemoveCloth", function(len, ply)
	
	if not spamCheck( ply, "ClothesMod:RemoveCloth" ) then return end

	-- currently this net is used only for the remove button in the wardrobe
	-- if you want to use it for something else, find an alternative to that :
	if not CLOTHESMOD.Config.CanRemoveClothesInWardrobe then return end

	local ent = net.ReadEntity() or NULL

	if not IsValid( ent ) then return end
	if ent:GetClass() ~= "cm_armory" then return end
	if ent:GetPos():Distance( ply:GetPos() ) > 250 then return end

	ply:CM_RemoveCloth( net.ReadInt(32), net.ReadString(), net.ReadBool() )

end)

net.Receive("ClothesMod:Surgery", function(len, ply)
	
	if not spamCheck( ply, "ClothesMod:Surgery" ) then return end
	
	local ent = net.ReadEntity()
		
	if not IsValid( ent ) then return end
	if ent:GetClass() ~= "cm_medic" then return end
	if ent:GetPos():Distance( ply:GetPos() ) > 250 then return end
	
	local beds = CLOTHESMOD.Beds or {}
	
	local freebed = NULL
	
	for bed, v in pairs( beds ) do
		
		if bed and IsValid( bed ) and bed.Free then
			
			freebed = bed
			break
			
		end
		
	end
	
	if not IsValid( freebed ) then
		ply:CM_Notif(CLOTHESMOD.Config.Sentences[69][CLOTHESMOD.Config.Lang])
		return
	end
	
	local pos = ply:GetPos()
    local ang = ply:GetAngles()
 
    local hbed = ents.Create("prop_vehicle_prisoner_pod")
    hbed:SetModel("models/vehicles/prisoner_pod_inner.mdl")
    hbed:SetPos( freebed:GetPos() + freebed:GetAngles():Up() * 22 + freebed:GetAngles():Right() * -30   )
    hbed:SetAngles( freebed:GetAngles() + Angle(-90,0,90))
    hbed:SetNoDraw(true)
    hbed:SetCollisionGroup(COLLISION_GROUP_WORLD)
    hbed:SetSolid(SOLID_NONE)
    hbed.locked = true
   
    freebed.ragdoll = hbed
    freebed.Free = false
   
    ply:EnterVehicle(hbed)
	
    ply:Freeze( true )
	
	hook.Run( "onPlayerStartsOperation", ply )
	
	local infos = net.ReadTable()

    timer.Simple( 10, function()
   
        if not IsValid(ply) or not ply:Alive() or not IsValid(freebed) or not IsValid(hbed) then return end
           
        ply:Freeze( false )
              
		if ply:CM_HasForbiddenJob() then
			ply:CM_Notif(CLOTHESMOD.Config.Sentences[36][CLOTHESMOD.Config.Lang])
		return end
		
		
		local model = infos.model
		local sex = infos.sex
		local skin = infos.skin
		local eyestextures = infos.eyestexture or {}
		local eyestexture_r = eyestextures.basetexture["r"]
		local eyestexture_l = eyestextures.basetexture["l"]
		
		local pinf = ply:CM_GetInfos()
		local newInf = table.Copy(ply:CM_GetInfos())
		
		local price = 0

		if sex and pinf.sex ~= sex then
			
			price = price + CLOTHESMOD.Config.PriceToChangeSex
			
			if infos.sex == 1 then
				
				newInf = defMaleInfos
				newInf.name = pinf.name
				
			elseif infos.sex == 0 then
				
				newInf = defFemaleInfos
				newInf.name = pinf.name
				
			else
				return
			end
			
		end
		
		if (model and skin) and (model ~= pinf.model or skin ~= pinf.skin) then
			
			price = price + CLOTHESMOD.Config.PriceToChangeHead
			
			local data
			
			if infos.sex == 1 then
				data = CLOTHESMOD.Male
			else
				data = CLOTHESMOD.Female
			end
			
			if not data.ListDefaultPM[model] then return end
			if not table.HasValue(data.ListDefaultPM[model].skins, skin) then return end
			
			newInf.model = model
			newInf.skin = skin
			
		end
		
		local eyestexturesA = newInf.eyestexture or {}
		local eyestexture_rA = eyestexturesA.basetexture["r"]
		local eyestexture_lA = eyestexturesA.basetexture["l"]
		
		local eyestexturesAp = pinf.eyestexture or {}
		local eyestexture_rAp = eyestexturesAp.basetexture["r"]
		local eyestexture_lAp = eyestexturesAp.basetexture["l"]
		
		if eyestexture_r and eyestexture_l and eyestexture_r ~= eyestexture_rA and eyestexture_l ~= eyestexture_lA then
			
			if eyestexture_r ~= eyestexture_rAp and eyestexture_l ~= eyestexture_lAp then
				price = price + CLOTHESMOD.Config.PriceToChangeEyes
			end
			
			local data
			
			if infos.sex == 1 then
				data = CLOTHESMOD.Male
			else
				data = CLOTHESMOD.Female
			end
			
			local valid = false
			
			for k, v in pairs( data.ListEyesTextures ) do
				
				if v["r"] == eyestexture_r and v["l"] == eyestexture_l then
					
					valid = true
					break
					
				end
				
			end
			
			if not valid then return end
			
			newInf.eyestexture = {
				basetexture = {
					["r"] = eyestexture_r,
					["l"] = eyestexture_l,
				},
			}
			
		end
		
		if not ply:canAfford(price) then
			ply:CM_Notif(CLOTHESMOD.Config.Sentences[41][CLOTHESMOD.Config.Lang])
			return
		end
		
		local steamid = ply:SteamID64() or "novalue"
		
		CLOTHESMOD.PlayerInfos = CLOTHESMOD.PlayerInfos or {}
		CLOTHESMOD.PlayerInfos[steamid] = newInf
		
		local tee = newInf.teetexture or {}
		local teetexture = tee.basetexture or ""

		local pant = newInf.panttexture or {}
		local panttexture = pant.basetexture or ""
		
		if sex and pinf.sex ~= sex then
			CLOTHESMOD.PlayerTops[steamid]["customs"] = {}
			CLOTHESMOD.PlayerTops[steamid]["ncustoms"] = {}
			CLOTHESMOD.PlayerBottoms[steamid] = {}
			
			ply:CM_AddTop( { texture = teetexture, bodygroup = newInf.bodygroups.top  }, false )
			ply:CM_AddBottom( { texture = panttexture, bodygroup = newInf.bodygroups.pant  } )
		end
		
		ply:addMoney(-price)
		
		ply:CM_SavePlayerInfos()
		ply:CM_NetworkTableInfos()
		
		ply:CM_Notif(CLOTHESMOD.Config.Sentences[42][CLOTHESMOD.Config.Lang])
       
        hbed:Remove()
		
		timer.Simple(0.2, function()
			ply:SetPos( pos )
			ply:SetEyeAngles( ang )
		end)
        freebed.ragdoll = nil
        freebed.Free = true
       
    end)
	
end)

net.Receive("ClothesMod:DropCloth", function(len, ply)
	
	if not spamCheck( ply, "ClothesMod:DropCloth" ) then return end
	
	-- currently this net is used only for the inventory
	-- if you want to use it for something else, find an alternative to that :
	if not CLOTHESMOD.Config.CanOpenInventory then return end

	if ply:CM_HasForbiddenJob() then
		ply:CM_Notif(CLOTHESMOD.Config.Sentences[36][CLOTHESMOD.Config.Lang])
	return end

	if net.ReadBool() then
		ply:CM_DropCloth( 1, true )
	else
		ply:CM_DropCloth( 2, true )
	end
end)

net.Receive("ClothesMod:BuyClothes", function(len, ply)
	
	if not spamCheck( ply, "ClothesMod:BuyClothes" ) then return end
	
	if ply:CM_HasForbiddenJob() then
		ply:CM_Notif(CLOTHESMOD.Config.Sentences[36][CLOTHESMOD.Config.Lang])
	return end
	
	local cart = net.ReadTable()
	local ent = net.ReadEntity() or NULL
		
	local ntb = {}
	
	if not IsValid( ent ) then return end
	if ent:GetClass() ~= "cm_clothing_display" then return end
	if ent:GetPos():Distance( ply:GetPos() ) > 250 then return end

	local ttprice = 0
	
	for key, val in pairs(cart) do
		if val.iscustom then
			if not val.id or not CLOTHESMOD.ShopTextures[val.id] then continue end
			val = CLOTHESMOD.ShopTextures[val.id]
			val.type = "top"
			val.iscustom = true
			
			for k, v in pairs( ply:CM_GetCustomTops() ) do
				if v.id == val.id then
					continue
				end
			end
			
			ntb[key] = val
			ttprice = ttprice + val.price
		else
			
			local i 
			if ply:CM_GetInfos().sex == 1 then
				i = CLOTHESMOD.Male
			else
				i = CLOTHESMOD.Female
			end
			
			
			if val.type == "top" then
				
				local valid = true

				for k, v in pairs( i.ListTops ) do

					if v.texture and v.texture == val.texture and val.bodygroup == v.bodygroup and val.price == v.price then
						valid = false
					end
				end
				
				if valid then
					continue
				else
					ntb[key] = val
					ttprice = ttprice + val.price
				end
				
			elseif val.type == "bottom" then
				
				local valid = true
				
				for k, v in pairs( i.ListBottoms ) do
					if v.texture and v.texture == val.texture and val.bodygroup == v.bodygroup and val.price == v.price then
						valid = false
					end
				end
				
				if valid then
					continue
				else
					ntb[key] = val
					ttprice = ttprice + val.price
				end
			
			else
				continue
			end
		end
	end
	
	-- for k, v in pairs(cart) do
		
		-- local price = v.price
		
		-- if not price then continue end
		
		-- ttprice = ttprice + price
	-- end
	
	if not ply:canAfford(ttprice) then
		ply:CM_Notif(CLOTHESMOD.Config.Sentences[41][CLOTHESMOD.Config.Lang])
		return
	end
	
	ply:addMoney(-ttprice)
	
	for key, val in pairs(ntb) do

		if val.iscustom then
			local i 
			if ply:CM_GetInfos().sex == 1 then
				i = CLOTHESMOD.Male
			else
				i = CLOTHESMOD.Female
			end
			
			val.bodygroup = i.EditableTop[val.baseTexture]
			ply:CM_AddTop(val,true)
			
			net.Start("ClothesMod:BroadcastTextureInfo")
				net.WriteTable( CLOTHESMOD.Textures[val.id] ) 
			net.Broadcast()
		else
			
			if val.type == "top" then
				
				ply:CM_AddTop(val,false)
				
			elseif val.type == "bottom" then
				
				ply:CM_AddBottom(val)

			end
		end
	end
	
	ply:CM_SavePlayerInfos()
	ply:CM_NetworkTableInfos()
	
	ply:CM_Notif(CLOTHESMOD.Config.Sentences[43][CLOTHESMOD.Config.Lang])
	
	
end)

net.Receive("ClothesMod:CustomTeeCreation", function(len, ply)
	
	if not spamCheck( ply, "ClothesMod:CustomTeeCreation" ) then return end
	
	if ply:CM_HasForbiddenJob() then
		ply:CM_Notif(CLOTHESMOD.Config.Sentences[36][CLOTHESMOD.Config.Lang])
	return end
	
	local ent = net.ReadEntity()
	local tab = net.ReadTable() or {}
	local nbtextures = #CLOTHESMOD.Textures
	tab.id = nbtextures + 1
	tab.isInShop = false
	tab.allowPlayerColor = false
	local infos,iss = CM_CheckTextureInfos(tab)
	iss = iss or "no error"
	if not infos then print("1:"..iss) return end
	if not ent or not IsValid( ent ) then print("2") return end
	if ent:GetPos():Distance( ply:GetPos() ) > 200 or ent:GetClass() ~= "cm_stylist" then return end

	local nbtxt = #infos.customThings.Texts
	local nbimg = #infos.customThings.Images
	
	local price = CLOTHESMOD.Config.EditableTop + nbtxt * CLOTHESMOD.Config.PricePerText + nbimg * CLOTHESMOD.Config.PricePerImg
	
	if not ply:canAfford(price) then
		ply:CM_Notif(CLOTHESMOD.Config.Sentences[41][CLOTHESMOD.Config.Lang])
		return
	end
	
	ply:addMoney(-price)
	CM_SaveTextureInfos( infos )
	ply:CM_AddTop( infos, true )
	
	net.Start("ClothesMod:BroadcastTextureInfo")
		net.WriteTable( infos ) 
	net.Broadcast()
	
	ply:CM_SavePlayerInfos()
	ply:CM_NetworkTableInfos()
	
	ply:CM_Notif(CLOTHESMOD.Config.Sentences[44][CLOTHESMOD.Config.Lang])

end)

net.Receive("ClothesMod:CustomTeeCreationShop", function(len, ply)
	
	if not spamCheck( ply, "ClothesMod:CustomTeeCreationShop" ) then return end
	
	if ply:CM_HasForbiddenJob() then
		ply:CM_Notif(CLOTHESMOD.Config.Sentences[36][CLOTHESMOD.Config.Lang])
	return end
	
	if not ply:IsSuperAdmin() then return end
	
	local tab = net.ReadTable() or {}
	local nbtextures = #CLOTHESMOD.Textures
	tab.id = nbtextures + 1
	tab.allowPlayerColor = false
	tab.isInShop = true
	
	local infos,iss = CM_CheckTextureInfos(tab)
	iss = iss or "no error"
	if not infos then print("1:"..iss) return end
	
	CM_SaveTextureInfos( infos )
	-- ply:CM_AddTop( infos, true )
	
	-- net.Start("ClothesMod:BroadcastTextureInfo")
		-- net.WriteTable( infos ) 
	-- net.Broadcast()
	
	-- ply:CM_SavePlayerInfos()
	-- ply:CM_NetworkTableInfos()
	
	ply:CM_Notif(CLOTHESMOD.Config.Sentences[44][CLOTHESMOD.Config.Lang])
	
	if file.Exists( "clothesmod", "DATA" ) then
		
		if file.Exists( "clothesmod/customclothes", "DATA" ) then
			
			local files, directories = file.Find( "clothesmod/customclothes/*", "DATA" )
			
			for k, v in pairs (directories) do
				
				local json = file.Read( "clothesmod/customclothes/"..v.."/clothes_infos.txt", "DATA" )
				
				local tab = util.JSONToTable( util.Decompress(json) )
				
				CLOTHESMOD.Textures[ tonumber(v) ] = tab
				
				if tab.isInShop then
					CLOTHESMOD.ShopTextures[ tonumber(v) ] = tab
				end
				
			end
			
		end
	
	end
	
	net.Start("ClothesMod:BroadcastShopsInfo")
		net.WriteTable(CLOTHESMOD.ShopTextures)
	net.Send( ply )
	
end)

net.Receive("ClothesMod:ChangeClothes", function(len, ply)

	if not spamCheck( ply, "ClothesMod:ChangeClothes" ) then return end
	
	if ply:CM_HasForbiddenJob() then
		ply:CM_Notif(CLOTHESMOD.Config.Sentences[36][CLOTHESMOD.Config.Lang])
	return end
	
	local top = net.ReadString()
	local bottom = net.ReadString()
	local iscustom = net.ReadBool()
	local steamid = ply:SteamID64() or "novalue"
	local ent = net.ReadEntity() or NULL

	if not IsValid( ent ) then return end
	if ent:GetClass() ~= "cm_armory" then return end
	if ent:GetPos():Distance( ply:GetPos() ) > 250 then return end
	
	local infos = ply:CM_GetInfos()
	
	if not iscustom then
		if ply:CM_GetTopList()["ncustoms"][top] then
			infos.teetexture.basetexture = top
			infos.teetexture.hasCustomThings = false
			infos.bodygroups.top = ply:CM_GetTopList()["ncustoms"][top].bodygroup
		end
	else
		for k, v in pairs( ply:CM_GetTopList()["customs"] ) do

			if tonumber(v.id) ~= tonumber(top) then continue end

			infos.teetexture.basetexture = "!CM_"..top
			infos.teetexture.id = tonumber(top)
			infos.teetexture.hasCustomThings = true

			infos.bodygroups.top = v.bodygroup
			
			break
			
		end
	end

	if ply:CM_GetBottomList()[bottom] then
		infos.panttexture.basetexture = bottom
		infos.bodygroups.pant = ply:CM_GetBottomList()[bottom].bodygroup
	end
		
	CLOTHESMOD.PlayerInfos = CLOTHESMOD.PlayerInfos or {}
	CLOTHESMOD.PlayerInfos[steamid] = infos
	
	ply:CM_Notif(CLOTHESMOD.Config.Sentences[45][CLOTHESMOD.Config.Lang])
	
	ply:CM_NetworkTableInfos()
	ply:CM_SavePlayerInfos()
	
end)

net.Receive("ClothesMod:ChangeName", function(len, ply)
	
	if not spamCheck( ply, "ClothesMod:ChangeName" ) then return end
	
	local name = net.ReadString()
	local surname = net.ReadString()
	local ent = net.ReadEntity()
	
	if not ent or not IsValid( ent ) or not ent:GetClass() == "cm_npc_name" or ent:GetPos():Distance(ply:GetPos()) > 200 then return end
	if not name or not surname or not isstring( name ) or not isstring( surname ) or #surname > 15 or #name > 15 or #surname < 3 or #name < 3 then return end
	
	if ply:CM_GetInfos().name == name and ply:CM_GetInfos().surname == surname then
		ply:CM_Notif(CLOTHESMOD.Config.Sentences[46][CLOTHESMOD.Config.Lang])
		return
	end
	
	if ply:getDarkRPVar( "money" ) < CLOTHESMOD.Config.PriceChangingName then 
		ply:CM_Notif(CLOTHESMOD.Config.Sentences[41][CLOTHESMOD.Config.Lang])
		return
	end
	
	ply:addMoney( -CLOTHESMOD.Config.PriceChangingName )
	
	local steamid = ply:SteamID64()
	
	CLOTHESMOD.PlayerInfos[steamid].name = name
	CLOTHESMOD.PlayerInfos[steamid].surname = surname
	
	ply:CM_SavePlayerInfos()
	ply:CM_NetworkTableInfos()
	
	ply:CM_ApplyModel()
	
	ply:CM_Notif(CLOTHESMOD.Config.Sentences[47][CLOTHESMOD.Config.Lang])
	
	
end)

net.Receive("ClothesMod:PlayerHasLoaded", function(len, ply)

	if not spamCheck( ply, "ClothesMod:PlayerHasLoaded" ) then return end
	
	if not VoidChar then
		CM_PlayerHasLoaded( ply )
	end
end)

net.Receive("ClothesMod:ReceiveCharacterCreated", function( len, ply )
	
	if not spamCheck( ply, "ClothesMod:ReceiveCharacterCreated" ) then return end
	
	if not ply.CanCreateCharacter then ply:CM_Notif("A problem has happened, please retry (0)") return end

	infos = net.ReadTable()
	
	local model = infos.model or ""
	local sex = infos.sex or 1
	local skin = infos.skin or -1
	infos.playerColor = infos.playerColor or Vector( 1,1,1 )
	
	if not isvector( infos.playerColor ) then ply:CM_Notif("A problem has happened, please retry (C)") return end
	
	local tab 
	if sex == 1 then
		tab = CLOTHESMOD.Male
	else
		tab = CLOTHESMOD.Female
	end
	
	if not tab.ListDefaultPM[model] then ply:CM_Notif("A problem has happened, please retry (1)") return end
	if sex ~= tab.ListDefaultPM[model].sex then ply:CM_Notif("A problem has happened, please retry (2)") return end
	if not tab.ListDefaultPM[model].skins or not table.HasValue( tab.ListDefaultPM[model].skins , skin ) then ply:CM_Notif("A problem has happened, please retry (3)") return end
	
	if not infos.name or not infos.surname or not isstring( infos.name ) or not isstring( infos.surname ) or #infos.surname < 3 or #infos.name < 3 or #infos.surname > 15 or #infos.name > 15 then ply:CM_Notif("A problem has happened, please retry (N)") return end
	
	if not infos.bodygroups or not infos.bodygroups.top or not infos.bodygroups.pant then ply:CM_Notif("A problem has happened, please retry (BG)") return end
	
	if not infos.eyestexture or not infos.eyestexture.basetexture or not infos.eyestexture.basetexture["r"] or not infos.eyestexture.basetexture["l"] then ply:CM_Notif("A problem has happened, please retry (EYE)") return end
	local eyesr, eyesl = infos.eyestexture.basetexture["r"],infos.eyestexture.basetexture["l"]
	-- local eyestext = eyes.basetexture or {}
	
	-- local stop = false
	
	-- for k, v in pairs(eyestext) do
		-- for key, val in pairs(CLOTHESMOD.ListEyesTextures) do
			-- if not table.HasValue(val, v) then stop = true end
		-- end
	-- end
	
	if stop then ply:CM_Notif("A problem has happened, please retry (4)") return end
	if infos.hasCostume then ply:CM_Notif("A problem has happened, please retry (5)") return end
	
	local tee = infos.teetexture or {}
	local teetexture = tee.basetexture or ""

	local pant = infos.panttexture or {}
	local panttexture = pant.basetexture or ""
	
	local valid1,valid2,valid3 = true,true,true
	
	if sex == 1 then
		
		for k, v in pairs( CLOTHESMOD.Male.ListTops ) do
			if v.texture and v.texture == teetexture and infos.bodygroups.top == v.bodygroup  and v.default then
				valid1 = false
			end
		end
		
		for k, v in pairs( CLOTHESMOD.Male.ListBottoms ) do
			if v.texture and v.texture == panttexture and infos.bodygroups.pant == v.bodygroup then
				valid3 = false
			end
		end
		
			
		for k, v in pairs( CLOTHESMOD.Male.ListEyesTextures ) do
			
			if v["r"] == eyesr and v["l"]== eyesl then
				valid2 = false
			end
			
		end
		
	elseif sex == 0 then
		
		for k, v in pairs( CLOTHESMOD.Female.ListTops ) do
			if v.texture and v.texture == teetexture and infos.bodygroups.top == v.bodygroup  and v.default then
				valid1 = false
			end
		end	
		for k, v in pairs( CLOTHESMOD.Female.ListBottoms ) do
			if v.texture and v.texture == panttexture and infos.bodygroups.pant == v.bodygroup then
				valid3 = false
			end
		end
		
		for k, v in pairs( CLOTHESMOD.Female.ListEyesTextures ) do
			
			if v["r"] == eyesr and v["l"]== eyesl then
				valid2 = false
			end
			
		end
	
	end

	if valid1 then ply:CM_Notif("A problem has happened, please retry (6.1)") return end
	if valid2 then ply:CM_Notif("A problem has happened, please retry (6.2)") return end
	if valid3 then ply:CM_Notif("A problem has happened, please retry (6.3)") return end
	
	if tee.hasCustomThings then ply:CM_Notif("A problem has happened, please retry (7)") return end
	
	-- local pant = infos.panttexture or {}
	-- local panttexture = pant.basetexture or ""
	
	-- if not table.HasValue( CLOTHESMOD.ListPantTextures, panttexture ) then ply:CM_Notif("A problem has happened, please retry (8)") return end
	
	local steamid = ply:SteamID64()
	
	CLOTHESMOD.PlayerInfos[steamid] = infos
	
	ply:CM_AddTop( { texture = teetexture, bodygroup = infos.bodygroups.top  }, false )
	ply:CM_AddBottom( { texture = panttexture, bodygroup = infos.bodygroups.pant  } )
	
	ply:CM_SavePlayerInfos()
	ply:CM_NetworkTableInfos()
	
	ply:CM_Notif(CLOTHESMOD.Config.Sentences[48][CLOTHESMOD.Config.Lang])

	ply.CanCreateCharacter = false
	
end)