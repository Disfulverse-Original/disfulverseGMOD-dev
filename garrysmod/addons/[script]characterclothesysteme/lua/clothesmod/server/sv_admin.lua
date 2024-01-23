local addonname = "clothesmod"

local configtable = CLOTHESMOD.Config

-- Save entities
local CMSavedEntities = {
    ["cm_armory"] = true,
    ["cm_stylist"] = true,
    ["cm_clothing_display"] = true,
    ["cm_npc_name"] = true,
    ["cm_bed"] = true,
    ["cm_medic"] = true,
}

local function InitializeTableSavedEnts()
	
	if not file.Exists(addonname.."/savedents/"..game.GetMap()..".txt", "DATA") then configtable.SavedEnts = {} return end
   
    local filecontent = util.Decompress(file.Read(addonname.."/savedents/"..game.GetMap()..".txt", "DATA"))
   
    configtable.SavedEnts =  util.JSONToTable(filecontent)

end

-- Commands
hook.Add("PlayerSay", "PlayerSay.ClothesModADMIN", function(ply, text)
           
    if text == "!save_"..addonname and ply:IsSuperAdmin() then
       
        local savedpos = {}
       
        for k, v in pairs(ents.GetAll()) do
           
            if not CMSavedEntities[v:GetClass()] then continue end
           
            savedpos[#savedpos + 1] = {
                pos = v:GetPos(),
                ang = v:GetAngles(),
                class = v:GetClass()
            }
           
            file.CreateDir(addonname.."/savedents")
           
            file.Write(addonname.."/savedents/"..game.GetMap()..".txt", util.Compress(util.TableToJSON(savedpos)))
       
        end
       
	    ply:CM_Notif("[Admin Tool] Entities saved! ("..addonname..")")
		
		InitializeTableSavedEnts()
		
    end
   
    if text == "!remove_"..addonname and ply:IsSuperAdmin() then
   
        if file.Exists(addonname.."/savedents/"..game.GetMap()..".txt", "DATA") then
       
            file.Delete( addonname.."/savedents/"..game.GetMap()..".txt" )
           
            ply:CM_Notif("[Admin Tool] Entities removed! ("..addonname..")")
			
			InitializeTableSavedEnts()
       
        end
		
    end
	
end)
 
-- Init the list of ents to spawn
hook.Add("Initialize", "Initialize."..addonname, function()
 
   InitializeTableSavedEnts()
 
end)
 
-- spawn ents
hook.Add("InitPostEntity", "InitPostEntity."..addonname, function()
 
    if not configtable.SavedEnts then return end
   
   timer.Simple(1, function()
		for k, v in pairs(configtable.SavedEnts) do
			local ent = ents.Create(v.class)
			ent:SetPos( v.pos )
			ent:SetAngles( v.ang )
			ent:SetPersistent( true )
			ent:Spawn()
			ent:SetMoveType( MOVETYPE_NONE )
		end
	end)
	
end)
 
hook.Add("PostCleanupMap", "PostCleanupMap."..addonname, function()
 
    if not configtable.SavedEnts then return end
   
    for k, v in pairs(configtable.SavedEnts) do
        local ent = ents.Create(v.class)
        ent:SetPos( v.pos )
        ent:SetAngles( v.ang )
        ent:SetPersistent( true )
        ent:Spawn()
        ent:SetMoveType( MOVETYPE_NONE )
    end
 
end)