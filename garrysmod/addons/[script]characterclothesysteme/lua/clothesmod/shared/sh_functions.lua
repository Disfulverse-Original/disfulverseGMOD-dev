local meta = FindMetaTable( "Player" )

CLOTHESMOD.PlayerInfos = CLOTHESMOD.PlayerInfos or {}

function meta:CM_ResetMaterials()
	for i=0, 31 do
		self:SetSubMaterial( i )
	end
end

function meta:CM_HasForbiddenJob()
	local player_team = self:Team()
	local player_jobinfos = RPExtraTeams[player_team] or {}
	local player_tname = player_jobinfos.name or "No name"

	return (CLOTHESMOD.Config.ForbiddenJobs[string.lower(player_tname)] or CLOTHESMOD.Config.ForbiddenJobsWithHeads[string.lower(player_tname)])
end


function meta:CM_GetInfos()
	local steamid = self:SteamID64()
	return CLOTHESMOD.PlayerInfos[steamid] or {
			model = "models/kerry/player/citizen/male_01.mdl",
			name = self:SteamName() or "No name", -- DarkRP function
			surname = "",
			sex = 1,
			playerColor = Vector(1,1,1),
			bodygroups = {
				top = "polo",
				pant = "pant",
			},
			skin = 0,
			eyestexture = {
				basetexture = {
					["r"] = "models/bloo_itcom_zel/citizens/facemaps/eyeball_r_blue",
					["l"] = "models/bloo_itcom_zel/citizens/facemaps/eyeball_l_blue",
				},
			},
			hasCostume = false, -- disable tee and pant and shoes texture
			teetexture = {
				basetexture = "models/bloo_itcom_zel/citizens/citizen_sheet2", -- name of the tee Choosen in the first part of the menu
				hasCustomThings = false, -- if has custom things or not, if true then basetexture should be an id
				id = 1,
			},
			panttexture = {
				basetexture = "models/bloo_itcom_zel/citizens/citizen_sheet2",
			},
		}
end

function meta:CM_GetSex()
	
	local steamid = self:SteamID64()
	return CLOTHESMOD.PlayerInfos[steamid].sex or 1
	
end

function CM_GetInfos()
	return CLOTHESMOD.PlayerInfos
end

-- local getName = function( name, ply )
	-- local nameIsFree = false
	-- local nb = 2
	-- while not nameIsFree do
		-- nameIsFree = true
		-- for k,v in pairs( player.GetAll() ) do
			-- if v:CM_GetInfos().name == name and v ~= ply then
				-- nameIsFree = false
				-- name = name.." "..nb
			-- end
		-- end
		-- nb = nb +1
	-- end
	-- return name
-- end

function meta:CM_ApplyModel()

	self:CM_ResetMaterials()

	local infos = self:CM_GetInfos()
	
	if SERVER and self:getDarkRPVar( "rpname" ) ~= infos.name.." "..infos.surname and not VoidChar then
		
		local name = infos.name.." "..infos.surname
		self:setDarkRPVar( "rpname", name )

	end

	if not CLOTHESMOD or not CLOTHESMOD.Config or not CLOTHESMOD.Config.ForbiddenJobs or not CLOTHESMOD.Config.ForbiddenJobsWithHeads then
		error("Character & Clothes : There is an issue in your configuration file")
	end

	local player_team = self:Team()
	local player_jobinfos = RPExtraTeams[player_team] or {}
	local player_tname = player_jobinfos.name or "No name"

	if CLOTHESMOD.Config.ForbiddenJobs[string.lower(player_tname)] then
		return 
	end	
	
	if CLOTHESMOD.Config.ForbiddenJobsWithHeads[string.lower(player_tname)] then		
		local tab 
		if infos.sex == 1 then
			tab = CLOTHESMOD.Male
		else
			tab = CLOTHESMOD.Female
		end
					
		local minfos = tab.ListDefaultPM[infos.model]
		
		if not minfos then return end
		local name = minfos.name or ""
		
		local models = CLOTHESMOD.Config.ForbiddenJobsWithHeads[string.lower(player_tname)]
		
		local mhead = models[name] or table.Random( models )
		
		self:SetModel( mhead )

		return
	end
	
	if infos.hasCostume then
		self:SetModel( infos.model )
		return
	end
	
	local tab 
	if infos.sex == 1 then
		tab = CLOTHESMOD.Male
	else
		tab = CLOTHESMOD.Female
	end
	
	if not tab.ListDefaultPM or not tab.ListDefaultPM[infos.model] then print("returned") return end

	local mdli = tab.ListDefaultPM[infos.model]
	
	self:SetModel(infos.model)

	local bodygroups = {
		mdli.bodygroupstop[infos.bodygroups.top].group,
		mdli.bodygroupsbottom[infos.bodygroups.pant].group
	}
		
	for k, v in pairs( bodygroups ) do
		self:SetBodygroup( unpack( v ) )
	end
	
	self:SetSkin( infos.skin )

	self:SetSubMaterial( mdli.eyes["r"], infos.eyestexture.basetexture["r"] )
	self:SetSubMaterial( mdli.eyes["l"], infos.eyestexture.basetexture["l"] )
	
	local topgroup = self:CM_GetInfos().bodygroups.top or "polo"
	local teeindex = mdli.bodygroupstop[topgroup].tee or -1

	if teeindex == -1 then return end
	
	for k, v in pairs( teeindex ) do
		
		if not infos.teetexture.hasCustomThings then
			
			self:SetSubMaterial( v, infos.teetexture.basetexture )

		elseif SERVER then

			local id = infos.teetexture.id
			local datas = CM_GetTextureInfos( id )

			if not datas then return end
			
			self:CM_ApplyCustomTee( datas )

		end
		
	end
	
	self:SetPlayerColor( infos.playerColor )
	
	local botgroup = self:CM_GetInfos().bodygroups.pant or "pant"
	local pantindex = mdli.bodygroupsbottom[botgroup].pant or -1
	if pantindex == -1 then return end
	
	for k, v in pairs( pantindex ) do
		
		self:SetSubMaterial( v, infos.panttexture.basetexture )

	end

end

function meta:CM_ApplyRagModel( rag )

	self:CM_ResetMaterials()
	
	if self:CM_HasForbiddenJob() then 
		return 
	end	

	local infos = self:CM_GetInfos()
	
	if infos.hasCostume then
		rag:SetModel( infos.model )
		return
	end

	local tab 
	if infos.sex == 1 then
		tab = CLOTHESMOD.Male
	else
		tab = CLOTHESMOD.Female
	end
	
	if not tab.ListDefaultPM or not tab.ListDefaultPM[infos.model] then print("returned") return end

	local mdli = tab.ListDefaultPM[infos.model]
	
	rag:SetModel(infos.model)

	local bodygroups = {
		mdli.bodygroupstop[infos.bodygroups.top].group,
		mdli.bodygroupsbottom[infos.bodygroups.pant].group
	}
		
	for k, v in pairs( bodygroups ) do
		rag:SetBodygroup( unpack( v ) )
	end
	
	rag:SetSkin( infos.skin )

	rag:SetSubMaterial( mdli.eyes["r"], infos.eyestexture.basetexture["r"] )
	rag:SetSubMaterial( mdli.eyes["l"], infos.eyestexture.basetexture["l"] )
	
	local topgroup = self:CM_GetInfos().bodygroups.top or "polo"
	local teeindex = mdli.bodygroupstop[topgroup].tee or -1
	if teeindex == -1 then return end
	
	for k, v in pairs( teeindex ) do
		
		if not infos.teetexture.hasCustomThings then
			rag:SetSubMaterial( v, infos.teetexture.basetexture )
		else
			if SERVER then
				local id = infos.teetexture.id
				-- print("custom tee id: "..id)
				local datas = CM_GetTextureInfos( id )

				if not datas then return end
				
				self:CM_ApplyRagCustomTee( datas, rag )
			end

		end
		
	end
		
	local botgroup = self:CM_GetInfos().bodygroups.pant or "pant"
	local pantindex = mdli.bodygroupsbottom[botgroup].pant or -1
	if pantindex == -1 then return end
	
	for k, v in pairs( pantindex ) do
		
		rag:SetSubMaterial( v, infos.panttexture.basetexture )

	end
	
end