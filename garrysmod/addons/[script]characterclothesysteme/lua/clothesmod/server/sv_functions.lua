local meta = FindMetaTable( "Player" )

CLOTHESMOD.PlayerInfos = CLOTHESMOD.PlayerInfos or {}

function meta:CM_RemoveCloth( type, id, iscustom )
	-- 1 = top, 2 = bottom
	if type ~= 1 and type ~= 2 then return end

	local infos = self:CM_GetInfos()

	if type == 1 then

		if iscustom then
			-- remove the top
			local steamid = self:SteamID64() or "novalue"
			local list = CLOTHESMOD.PlayerTops[steamid]["customs"] or {}
			local key = false
			for k, v in pairs( CLOTHESMOD.PlayerTops[steamid]["customs"] ) do
				print(v.id)
				if v.id and v.id == tonumber(id) then
					
					key = k
					
				end
				
			end

			if not key then
				return
			end
			
			CLOTHESMOD.PlayerTops[steamid]["customs"][key] = nil

			if infos.teetexture.id == tonumber(id) and infos.teetexture.hasCustomThings then

				if infos.sex == 1 then
					
					infos.teetexture.basetexture = nil -- mettre les tons ici, à modifier
					infos.teetexture.id = nil
					infos.teetexture.hasCustomThings = false
					infos.bodygroups.top = "nude"
					
				else -- IF IT IS A FEMALE THEN
					
					infos.teetexture.basetexture = nil -- mettre les tons ici, à modifier
					infos.teetexture.id = nil
					infos.teetexture.hasCustomThings = false
					infos.bodygroups.top = "nude"
					
				end

			end

		else
			local steamid = self:SteamID64() or "novalue"
			local list = CLOTHESMOD.PlayerTops[steamid]["ncustoms"] or {}
			
			if not CLOTHESMOD.PlayerTops[steamid]["ncustoms"][id] then 
			return end
			
			CLOTHESMOD.PlayerTops[steamid]["ncustoms"][id] = nil

			if infos.teetexture.basetexture == id then

				if infos.sex == 1 then
					
					infos.teetexture.basetexture = nil -- mettre les tons ici, à modifier
					infos.teetexture.id = nil
					infos.teetexture.hasCustomThings = false
					infos.bodygroups.top = "nude"
					
				else -- IF IT IS A FEMALE THEN
					
					infos.teetexture.basetexture = nil -- mettre les tons ici, à modifier
					infos.teetexture.id = nil
					infos.teetexture.hasCustomThings = false
					infos.bodygroups.top = "nude"
					
				end

			end
		end

	elseif type == 2 then
		local steamid = self:SteamID64() or "novalue"
		local list = CLOTHESMOD.PlayerBottoms[steamid] or {}
		
		if not CLOTHESMOD.PlayerBottoms[steamid][id] then 
			if notif then
				self:CM_Notif(CLOTHESMOD.Config.Sentences[38][CLOTHESMOD.Config.Lang])
			end
		return end
		
		CLOTHESMOD.PlayerBottoms[steamid][id] = nil

		if infos.panttexture.basetexture == id then
			-- change the PM
			if infos.sex == 1 then
				-- print("changing you clothes")
				infos.panttexture.basetexture = nil -- mettre les tons ici, à modifier
				infos.panttexture.id = nil
				infos.panttexture.hasCustomThings = false
				infos.bodygroups.pant = "nude"
				-- print("that's done")
			else -- IF IT IS A FEMALE THEN
			
				infos.panttexture.basetexture = nil -- mettre les tons ici, à modifier
				infos.panttexture.id = nil
				infos.panttexture.hasCustomThings = false
				infos.bodygroups.pant = "nude"
				
			end
		end
	end

	self:CM_SavePlayerInfos()
	self:CM_NetworkTableInfos()
end


function meta:CM_DropCloth( type, notif )

	if self:CM_HasForbiddenJob() then
		self:CM_Notif(CLOTHESMOD.Config.Sentences[36][CLOTHESMOD.Config.Lang])
	return end

	if type ~= 1 and type ~= 2 then return end
	
	local infos = self:CM_GetInfos()
	
	if type == 1 then -- top
		if infos.teetexture.hasCustomThings then
			
			local id = infos.teetexture.id
			
			-- remove the top
			local steamid = self:SteamID64() or "novalue"
			local list = CLOTHESMOD.PlayerTops[steamid]["customs"] or {}
			local key = false
			for k, v in pairs( CLOTHESMOD.PlayerTops[steamid]["customs"] ) do

				if v.id and v.id == id then
					
					key = k
					
				end
				
			end
			
			if not key then
				if notif then
					self:CM_Notif(CLOTHESMOD.Config.Sentences[37][CLOTHESMOD.Config.Lang])
				end
			return end
			
			CLOTHESMOD.PlayerTops[steamid]["customs"][key] = nil
			
			-- drop to the ground the top
			
			local name = CM_GetTextureInfos( id ).name or "Customized tee-shirt" -- TO TRANSLATE
			
			local ent = ents.Create("cm_cloth")
			ent:SetModel("models/props_c17/suitcase_passenger_physics.mdl")
			ent:SetPos( self:GetPos() + self:GetAngles():Forward()*30 + self:GetAngles():Up()*30 )
			ent:Spawn()
			ent:SetCName(name)
			ent:SetPlayerOwner( self )
			self.cm_cloth_dropped = self.cm_cloth_dropped or {}
			table.insert(self.cm_cloth_dropped, ent)
			ent.Type = 1.1
			ent.Sex = infos.sex
			ent.id = id	
			
			-- change the PM
			if infos.sex == 1 then
				
				infos.teetexture.basetexture = nil -- mettre les tons ici, à modifier
				infos.teetexture.id = nil
				infos.teetexture.hasCustomThings = false
				infos.bodygroups.top = "nude"
				
			else -- IF IT IS A FEMALE THEN
				
				infos.teetexture.basetexture = nil -- mettre les tons ici, à modifier
				infos.teetexture.id = nil
				infos.teetexture.hasCustomThings = false
				infos.bodygroups.top = "nude"
				
			end

			self:CM_SavePlayerInfos()
			self:CM_NetworkTableInfos()
			
			if notif then
				self:CM_Notif(CLOTHESMOD.Config.Sentences[39][CLOTHESMOD.Config.Lang])
			end
			
		else

			local text = infos.teetexture.basetexture
			
			-- remove the top
			local steamid = self:SteamID64() or "novalue"
			local list = CLOTHESMOD.PlayerTops[steamid]["ncustoms"] or {}
			
			if not CLOTHESMOD.PlayerTops[steamid]["ncustoms"][text] then 
				if notif then
					self:CM_Notif(CLOTHESMOD.Config.Sentences[37][CLOTHESMOD.Config.Lang])
				end
			return end
			
			CLOTHESMOD.PlayerTops[steamid]["ncustoms"][text] = nil
			
			-- drop to the ground the top
			local data
			if infos.sex == 1 then
				data = CLOTHESMOD.Male
			else
				data = CLOTHESMOD.Female
			end
			
			local name = "No name"
			
			for k, v in pairs( data.ListTops ) do
				
				if v.texture == text then
					
					name = k
					
					break
					
				end
				
			end
					
			local ent = ents.Create("cm_cloth")
			ent:SetModel("models/props_c17/suitcase_passenger_physics.mdl")
			ent:SetPos( self:GetPos() + self:GetAngles():Forward()*30 + self:GetAngles():Up()*30 )
			ent:Spawn()
			ent:SetCName(name)
			ent:SetPlayerOwner( self )
			
			self.cm_cloth_dropped = self.cm_cloth_dropped or {}
			table.insert(self.cm_cloth_dropped, ent)
			ent.Type = 1.2
			ent.Sex = infos.sex
			ent.Texture = text
			
			-- change the PM
			if infos.sex == 1 then

				infos.teetexture.basetexture = nil -- mettre les tons ici, à modifier
				infos.teetexture.id = nil
				infos.teetexture.hasCustomThings = false
				infos.bodygroups.top = "nude"

			else -- IF IT IS A FEMALE THEN
			
				infos.teetexture.basetexture = nil -- mettre les tons ici, à modifier
				infos.teetexture.id = nil
				infos.teetexture.hasCustomThings = false
				infos.bodygroups.top = "nude"
				
			end
			
			self:CM_SavePlayerInfos()
			self:CM_NetworkTableInfos()
			if notif then
				self:CM_Notif(CLOTHESMOD.Config.Sentences[39][CLOTHESMOD.Config.Lang])
			end
		end
	else -- bottom
		local text = infos.panttexture.basetexture
		
		-- remove the top
		local steamid = self:SteamID64() or "novalue"
		local list = CLOTHESMOD.PlayerBottoms[steamid] or {}
		
		if not CLOTHESMOD.PlayerBottoms[steamid][text] then 
			if notif then
				self:CM_Notif(CLOTHESMOD.Config.Sentences[38][CLOTHESMOD.Config.Lang])
			end
		return end
		
		CLOTHESMOD.PlayerBottoms[steamid][text] = nil
		
		-- drop to the ground the top
		
		local data
		if infos.sex == 1 then
			data = CLOTHESMOD.Male
		else
			data = CLOTHESMOD.Female
		end
		
		local name = "No name"
		
		for k, v in pairs( data.ListBottoms ) do
			
			if v.texture == text then
				
				name = k
				
				break
				
			end
			
		end
				
		local ent = ents.Create("cm_cloth")
		ent:SetModel("models/props_c17/suitcase_passenger_physics.mdl")
		ent:SetPos( self:GetPos() + self:GetAngles():Forward()*30 + self:GetAngles():Up()*30 )
		ent:Spawn()
		ent:SetCName(name)
		ent:SetPlayerOwner( self )
		self.cm_cloth_dropped = self.cm_cloth_dropped or {}
		table.insert(self.cm_cloth_dropped, ent)
		ent.Type = 2
		ent.Sex = infos.sex
		ent.Texture = text
		
		-- change the PM
		if infos.sex == 1 then
			-- print("changing you clothes")
			infos.panttexture.basetexture = nil -- mettre les tons ici, à modifier
			infos.panttexture.id = nil
			infos.panttexture.hasCustomThings = false
			infos.bodygroups.pant = "nude"
			-- print("that's done")
		else -- IF IT IS A FEMALE THEN
		
			infos.panttexture.basetexture = nil -- mettre les tons ici, à modifier
			infos.panttexture.id = nil
			infos.panttexture.hasCustomThings = false
			infos.bodygroups.pant = "nude"
			
		end
		--
		--
		
		self:CM_SavePlayerInfos()
		self:CM_NetworkTableInfos()
		if notif then
			self:CM_Notif(CLOTHESMOD.Config.Sentences[40][CLOTHESMOD.Config.Lang])
		end
	
	end

end

function meta:CM_AddTop( infos, iscustom )

	local steamid = self:SteamID64() or "novalue"
	
	CLOTHESMOD.PlayerTops = CLOTHESMOD.PlayerTops or {}
	CLOTHESMOD.PlayerTops[steamid] = CLOTHESMOD.PlayerTops[steamid] or {}
	CLOTHESMOD.PlayerTops[steamid]["customs"] = CLOTHESMOD.PlayerTops[steamid]["customs"] or {}
	CLOTHESMOD.PlayerTops[steamid]["ncustoms"] = CLOTHESMOD.PlayerTops[steamid]["ncustoms"] or {}
	
	if iscustom then
	
		local id = infos.id or -1
		
		local tab 
		if self:CM_GetInfos().sex == 1 then
			tab = CLOTHESMOD.Male
		else
			tab = CLOTHESMOD.Female
		end
		
		local bodygroupn = tab.EditableTop[CM_GetTextureInfos( id ).baseTexture].bodygroup
		
		CLOTHESMOD.PlayerTops[steamid]["customs"][#CLOTHESMOD.PlayerTops[steamid]["customs"]+1] = {
			bodygroup = bodygroupn or "polo",
			id = id,
			-- id = id,
			-- isInShop = infos.isInShop or false,
			-- price = infos.price or 100,
			-- sex = infos.sex or 1,
			-- allowPlayerColor = infos.allowPlayerColor or false,
			-- baseTexture = infos.baseTexture or "",
			-- customThings = infos.customThings or { Images = {}, Texts = {} }
		}
		
	else
		CLOTHESMOD.PlayerTops[steamid]["ncustoms"][infos.texture] = {
			bodygroup = infos.bodygroup or "polo",
		}
		
	end
		
end

function meta:CM_AddBottom( infos )
	
	local steamid = self:SteamID64() or "novalue"
	
	CLOTHESMOD.PlayerBottoms = CLOTHESMOD.PlayerBottoms or {}
	CLOTHESMOD.PlayerBottoms[steamid] = CLOTHESMOD.PlayerBottoms[steamid] or {}
	
	
	CLOTHESMOD.PlayerBottoms[steamid][infos.texture] = {
		bodygroup = infos.bodygroup or "pant",
	}
			
	local steamid = self:SteamID64() or "novalue"
	
end

function meta:CM_GetBottomList()
	
	local list = CLOTHESMOD.PlayerBottoms or {}
	local steamid = self:SteamID64() or "novalue"
	local list2 = list[steamid] or {}

	return list2
	
end

function meta:CM_GetTopList()
	
	local list = CLOTHESMOD.PlayerTops or {}
	local steamid = self:SteamID64() or "novalue"
	local list2 = list[steamid] or {}

	return list2
	
end

function meta:CM_GetCustomTops()
	
	local list = self:CM_GetTopList()
	local list2 = list["customs"] or {}
	
	return list2
	
end

function meta:CM_GetNCustomTops()
	
	local list = self:CM_GetTopList()
	local list2 = list["ncustoms"] or {}
	
	return list2
	
end

function meta:CM_SavePlayerInfos() 

	local json1 = util.TableToJSON( self:CM_GetInfos() )
	local json2 = util.TableToJSON( self:CM_GetTopList() )
	local json3 = util.TableToJSON( self:CM_GetBottomList() )
	
	local steamid = self:SteamID64() or "novalue"
	
	file.CreateDir( "clothesmod/"..steamid )
	
	file.Write( "clothesmod/"..steamid.."/clothes_infos.txt", util.Compress(json1) )
	file.Write( "clothesmod/"..steamid.."/tops.txt", util.Compress(json2) )
	file.Write( "clothesmod/"..steamid.."/bottoms.txt", util.Compress(json3) )

	hook.Run( "ClothesMod.OnInfosSaved", self )
	
end

function meta:CM_NetworkTableInfos()

	local tab1 = self:CM_GetInfos()
	local tab2 = self:CM_GetTopList()
	local tab3 = self:CM_GetBottomList()
	
	self:CM_ApplyModel()
	
	net.Start("ClothesMod:BroadcastPlayerInfos")
		net.WriteTable(tab1)
		net.WriteTable(tab2)
		net.WriteTable(tab3)
		net.WriteEntity(self)
	net.Broadcast()

end

function CM_NetworkTableInfos()
	net.Start("ClothesMod:BroadcastPlayersInfos")
		net.WriteTable(CLOTHESMOD.PlayerInfos or {})
		net.WriteTable(CLOTHESMOD.PlayerTops or {})
		net.WriteTable(CLOTHESMOD.PlayerBottoms or {})
	net.Broadcast()
end

-- local baseTextures = {}
-- local baseTextures = {
	-- id = 10,
	-- name = "Test",
	-- isInShop = true,
	-- price = 100,
	-- sex = 1,
	-- allowPlayerColor = true,
	-- baseTexture = "",
	-- customThings = {
		-- Texts = {
			-- [1] = {
				-- posx = 10,
				-- posy = 10,
				-- text = "Test",
				-- textsize = 10,
				-- color = Color(255,255,255,255)
			-- },
		-- },
		-- Images = {
			-- [1] = {
				-- posx = 10,
				-- posy = 10,
				-- sizex = 10,
				-- sizey = 10,
				-- link = "",
				-- alpha = 255
			-- },
		-- },
	-- },
-- }

function CM_CheckTextureInfos( infos )

	if infos.isInShop and (not infos.name or not infos.price) then
		return false, "1"
	end

	infos.price = tonumber( infos.price )
	
	if not infos.baseTexture then return false, "2" end
	
	if not infos.sex then return false, "3" end
	
	local bt
	
	if infos.sex == 1 then
		if not CLOTHESMOD.Male.EditableTop[infos.baseTexture] then
			return false, "4"
		else
			bt = CLOTHESMOD.Male.EditableTop[infos.baseTexture]
		end
	elseif infos.sex == 0 then
		if not CLOTHESMOD.Female.EditableTop[infos.baseTexture] then
			return false, "5"
		else
			bt = CLOTHESMOD.Female.EditableTop[infos.baseTexture]
		end
	else
		return false, "6"
	end
	
	if not infos.customThings then return false, "6.1" end
	
	local cust = infos.customThings 
	
	local texts = cust.Texts or {}
	local images = cust.Images or {}
	
	local stop = false
	
	local btsizex = bt.sizex
	local btsizey = bt.sizey
	
	local nbtxt = #texts
	local nbimg = #images
	if nbtxt == 0 and nbimg	== 0 then return false, "6.1.2" end
	
	for key, datas in pairs ( texts ) do
		
		-- max txts
		if key > 10 then stop = true return false, "6.2" end
		if not datas.posx or not datas.posy or not datas.text or not datas.textsize then stop = true return false, "6.3" end
		
		datas.posx = tonumber( datas.posx )
		datas.posy = tonumber( datas.posy )
		
		local posx = datas.posx
		local posy = datas.posy
		local text = datas.text
		local clr = datas.color or Color(255,255,255,255)
		
		if not isstring( text ) then stop = true return false, "6.4" end
		
		local textsize = tonumber(datas.textsize)
		
		-- font sizes
		if textsize < 10 or textsize > 100 then stop = true return false, "6.5" end
		
		if not clr or not clr.r or not clr.g or not clr.b or not clr.a then stop = true return false, "6.6" end
		
		local color = Color(clr.r,clr.g,clr.b,clr.a)
		
		infos.customThings.Texts[key].color = color
		
	end

	if stop then return false, "7" end

	stop = false
	
	for key, datas in pairs ( images ) do
		
		-- max imgs
		if key > 5 then stop = true return false, "8" end
		if not datas.posx or not datas.posy or not datas.sizex or not datas.sizey or not datas.link then stop = true return false, "9" end
		
		datas.posx = tonumber( datas.posx )
		datas.posy = tonumber( datas.posy )
		datas.sizex = tonumber( datas.sizex )
		datas.sizey = tonumber( datas.sizey )
		
		if datas.alpha then
			datas.alpha = tonumber( datas.alpha )
		end
		
		-- local posx = datas.posx
		-- local posy = datas.posy
		-- local sizex = datas.sizex
		-- local sizey = datas.sizey
		local link = datas.link
		
		if not isstring( link ) then stop = true return false, "10" end
		
	end
	
	if stop then return false, "11" end
	
	return infos
	
end

CLOTHESMOD.TopsMakesIds = CLOTHESMOD.TopsMakesIds or {}
function meta:CM_RemovePlayerFromTable()
	local ply = self
	
	for k, v in pairs( CLOTHESMOD.TopsMakesIds ) do
		
		if table.HasValue( v.ply, ply ) then
			
			table.RemoveByValue( v.ply, ply )
			
		end
		
		local count = table.Count( v.ply )
		
		if count <= 0 then
			table.remove( CLOTHESMOD.TopsMakesIds, k )
		end
		
	end
end

function meta:CM_ApplyCustomTee( datas )

	if self:CM_HasForbiddenJob()  then
		self:CM_Notif(CLOTHESMOD.Config.Sentences[36][CLOTHESMOD.Config.Lang])
	return end

	local ply = self
	
	local id = datas.id
	
	local mdl = ply:GetModel()
	
	local tab
	if ply:CM_GetSex() == 1 then
		tab = CLOTHESMOD.Male
	else
		tab = CLOTHESMOD.Female
	end

	local topgroup = ply:CM_GetInfos().bodygroups.top or "polo"
	local teeindex = tab.ListDefaultPM[mdl].bodygroupstop[topgroup].tee or -1
	if teeindex == -1 then return end

	if CLOTHESMOD.ShopTextures[id] then

		for k, v in pairs( teeindex ) do
			ply:SetSubMaterial( v, "!CM_"..id )
		end
		
	else
		
		net.Start("ClothesMod:BroadcastTextureInfo")
			net.WriteTable( datas ) 
		net.Broadcast()
		for k, v in pairs( teeindex ) do
			ply:SetSubMaterial( v, "!CM_"..id )
		end
		
	end

end

function meta:CM_ApplyRagCustomTee( datas, rag )

	if self:CM_HasForbiddenJob() then
		self:CM_Notif(CLOTHESMOD.Config.Sentences[36][CLOTHESMOD.Config.Lang])
	return end

	local ply = self
	
	local id = datas.id
	
	local mdl = ply:GetModel()
	
	local tab
	if ply:CM_GetSex() == 1 then
		tab = CLOTHESMOD.Male
	else
		tab = CLOTHESMOD.Female
	end

	local topgroup = ply:CM_GetInfos().bodygroups.top or "polo"
	local teeindex = tab.ListDefaultPM[mdl].bodygroupstop[topgroup].tee or -1
	if teeindex == -1 then return end

	if CLOTHESMOD.ShopTextures[id] then

		for k, v in pairs( teeindex ) do
			rag:SetSubMaterial( v, "!CM_"..id )
		end
		
	else
		
		net.Start("ClothesMod:BroadcastTextureInfo")
			net.WriteTable( datas ) 
		net.Broadcast()
		for k, v in pairs( teeindex ) do
			rag:SetSubMaterial( v, "!CM_"..id )
		end
		
	end

end

function CM_SaveTextureInfos( infos )
	
	local datas = CM_CheckTextureInfos( infos )
	
	if not datas then return end
		
	local files, directories = file.Find( "clothesmod/customclothes/*", "DATA" )
	
	local id = table.Count( directories ) + 1
	
	datas.id = id
		
	local json = util.TableToJSON( datas )
	
	file.CreateDir( "clothesmod/customclothes/"..id )
	
	file.Write( "clothesmod/customclothes/"..id.."/clothes_infos.txt", util.Compress(json) )
	
	CLOTHESMOD.Textures[id] = datas
	
end

function CM_GetTextureInfos( id )

	-- if not file.Exists( "clothesmod/CustomClothes/"..id.."/clothes_infos.txt", "DATA" ) then return false end
	
	-- local json = file.Read( "clothesmod/CustomClothes/"..id.."/clothes_infos.txt" )
	
	-- local tab = util.JSONToTable( json )
	
	-- return tab
	
	return CLOTHESMOD.Textures[tonumber(id)]

end

function CM_PlayerHasLoaded( ply )
	
	local steamid = ply:SteamID64()

	if steamid == nil then
		steamid = "novalue"
	end
	
	net.Start("ClothesMod:BroadcastShopsInfo")
		net.WriteTable(CLOTHESMOD.ShopTextures)
	net.Send( ply )
			
	if file.Exists("clothesmod/"..steamid.."/clothes_infos.txt", "DATA") then
	
		local json = file.Read( "clothesmod/"..steamid.."/clothes_infos.txt", "DATA" )
		
		CLOTHESMOD.PlayerInfos[steamid] = util.JSONToTable(  util.Decompress(json) )
		
		timer.Simple( 1, function()
			ply:CM_ApplyModel()
		end)
		
		if file.Exists("clothesmod/"..steamid.."/tops.txt", "DATA") then
	
			local json = file.Read( "clothesmod/"..steamid.."/tops.txt", "DATA" )
			
			CLOTHESMOD.PlayerTops = CLOTHESMOD.PlayerTops or {}
			local steamid = ply:SteamID64() or "novalue"
			
			CLOTHESMOD.PlayerTops[steamid] = util.JSONToTable( util.Decompress(json) )
			
			local infos = ply:CM_GetInfos()

			if infos.teetexture.hasCustomThings then
				
				local id = infos.teetexture.id
				
				if CLOTHESMOD.Textures[id] then
				
					net.Start("ClothesMod:BroadcastTextureInfo")
						net.WriteTable( CLOTHESMOD.Textures[id] ) 
					net.Broadcast()
				
				end
				
			end
			
			for k,v in pairs( CLOTHESMOD.PlayerTops[steamid]["customs"] ) do
						
				if not v.id or not CLOTHESMOD.Textures[v.id] then continue end
				net.Start("ClothesMod:BroadcastTextureInfo")
					net.WriteTable( CLOTHESMOD.Textures[v.id] ) 
				net.Send(ply)
				
			end
			
			for k,v in pairs( player.GetAll() ) do
				
				if v:CM_GetInfos().teetexture.hasCustomThings then
					net.Start("ClothesMod:BroadcastTextureInfo")
						local id = v:CM_GetInfos().teetexture.id or 1
						net.WriteTable( CLOTHESMOD.Textures[id] ) 
					net.Send(ply)
				end
				
			end
			
		end
		
		if file.Exists("clothesmod/"..steamid.."/bottoms.txt", "DATA") then
		
			local json = file.Read( "clothesmod/"..steamid.."/bottoms.txt", "DATA" )
			
			CLOTHESMOD.PlayerBottoms = CLOTHESMOD.PlayerBottoms or {}
			local steamid = ply:SteamID64() or "novalue"
			
			CLOTHESMOD.PlayerBottoms[steamid] = util.JSONToTable( util.Decompress(json) )
			
		end

		ply:CM_NetworkTableInfos()
		
		return
		
	end
	
	ply:CM_NetworkTableInfos()
	
	ply.CanCreateCharacter = true
	
	net.Start("ClothesMod:CharacterCreationMenu")
	net.Send(ply)
	
end
