--[[

Author: tochnonement
Email: tochnonement@gmail.com

09/05/2023

--]]

file.CreateDir('onyx_creditstore_npcs')

local creditstore = onyx.creditstore

function creditstore:LoadNPCs()
    local map = game.GetMap()
    local fileName = 'onyx_creditstore_npcs/' .. map .. '.dat'
    
    if (file.Exists(fileName, 'DATA')) then
        local content = file.Read(fileName, 'DATA')
        local decoded = pon.decode(content)

        for _, row in ipairs(decoded) do
            local ent = ents.Create('ent_npc_onyx_store')
            ent:SetPos(row.pos)
            ent:SetAngles(row.ang)
            ent:Spawn()
        end
    end
end

function creditstore:SaveNPCs()
    local map = game.GetMap()
    local fileName = 'onyx_creditstore_npcs/' .. map .. '.dat'
    local data = {}

    for _, ent in ipairs(ents.FindByClass('ent_npc_onyx_store')) do
        if (IsValid(ent)) then
            table.insert(data, {
                pos = ent:GetPos(),
                ang = ent:GetAngles()
            })
        end
    end

    file.Write(fileName, pon.encode(data))

    self:Print('Saved NPCs.')
end

hook.Add('InitPostEntity', 'onyx.creditstore.npc', function()
    creditstore:LoadNPCs()
end)

hook.Add('PostCleanupMap', 'onyx.creditstore.npc', function()
    creditstore:LoadNPCs()
end)

hook.Add('onyx.inconfig.OnValueChange', 'onyx.creditstore.npc', function(id, newValue)
    if (id == 'creditstore_npc_model') then
        for _, ent in ipairs(ents.FindByClass('ent_npc_onyx_store')) do
            ent:Remove()
        end

        creditstore:LoadNPCs()
    end
end)

timer.Create('onyx.creditstore.NPCAutoSave', 180, 0, function()
    creditstore:SaveNPCs()
end)

concommand.Add('onyx_creditstore_save_npc', function(ply)
    if (ply ~= NULL and not ply:IsSuperAdmin()) then
        return
    end

    creditstore:SaveNPCs()
end)