CLOTHESMOD.Textures = CLOTHESMOD.Textures or {}
CLOTHESMOD.ShopTextures = CLOTHESMOD.ShopTextures or {}

hook.Add("PlayerSay", "ClothesMod:PlayerSay", function(ply, text)
	if text == "!createclothes" and ply:IsSuperAdmin() then
		
		net.Start("ClothesMod:OpenAdminMenu")
		net.Send( ply )
	
	end
	if string.sub(text, 1, 15) == "!resetcharacter" and table.HasValue(CLOTHESMOD.Config.ModGroups, ply:GetUserGroup() ) then
		
		local steamid32 = string.sub(text, 17)
		local steamid64 = util.SteamIDTo64(steamid32)
		
		if not steamid64 or steamid64 == "0" then
			ply:CM_Notif("This steamid doesn't exist")
			return
		end
		
		local files, directories = file.Find( "clothesmod/"..steamid64.."/*", "DATA" )
		
		for k, v in pairs( files ) do
			file.Delete( "clothesmod/"..steamid64.."/"..v )
		end
		
		file.Delete( "clothesmod/"..steamid64 )
		ply:CM_Notif("The character of "..steamid32.."("..steamid64..") has been removed.")
		
	end
	
	if string.sub(text, 1, 14) == "!cm_removeshop" and ply:IsSuperAdmin() then
		local name = string.sub(text, 16)
		local found = 0
		for k, v in pairs( CLOTHESMOD.ShopTextures ) do
			if v.name == name then
				local files, directories = file.Find( "clothesmod/customclothes/"..k.."/*", "DATA" )
		
				for key, val in pairs( files ) do
					file.Delete( "clothesmod/customclothes/"..k.."/"..val )
				end
				
				found = found + 1

				file.Delete( "clothesmod/customclothes/"..k )
				
				CLOTHESMOD.ShopTextures[k] = nil
				
			end
			
			if found == 0 then
				ply:CM_Notif("There is not any clothes with this name.")
			else
				ply:CM_Notif("Success, "..found.." clothes with this name have been removed.")
			end
		end
	end
end)

hook.Add("Initialize", "ClothesMod:InitFolder", function()

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
	
	return end
	
	file.CreateDir("clothesmod")
	
end)

hook.Add("PlayerButtonDown", "ClothesMod:PlayerButtonDown", function( ply, button )
	
	-- if you're not in a job with a character & clothes model or you're not able to open your inventory then don't do anything
	if ply:CM_HasForbiddenJob() or not CLOTHESMOD.Config.CanOpenInventory then
	return end
	
	if button == CLOTHESMOD.Config.KeyInventory then
		
		net.Start("ClothesMod:DropClothesMenu")
		net.Send( ply )
		
	end
	
end)

hook.Add("PlayerDisconnected", "ClothesMod:PlayerDisconnected", function( ply )
	
	local inf = ply:CM_GetInfos()
	if inf.teetexture.hasCustomThings then
	
		ply:CM_RemovePlayerFromTable()
		
	end

	for k, v in pairs( ply.cm_cloth_dropped or {}) do
		if IsValid( v ) then v:Remove() end
	end
end)

hook.Add("PlayerSpawn", "ClothesMod:PlayerSpawn", function( ply )
		
	timer.Simple(0.1, function()
		ply:CM_ApplyModel()
	end)
	
end)

hook.Add("OnPlayerChangedTeam", "ClothesMod:OnPlayerChangedTeam", function( ply, oldteam, newteam )
	
	timer.Simple(0.1, function()
		ply:CM_ApplyModel()
	end)
	
end)

hook.Add( "VoidChar.CharacterSelected", "ClothesMod:VoidChar.CharacterSelected", function( ply )
	CM_PlayerHasLoaded( ply )
end )