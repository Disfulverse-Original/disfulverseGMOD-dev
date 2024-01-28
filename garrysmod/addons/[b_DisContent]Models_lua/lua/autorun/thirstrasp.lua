
player_manager.AddValidModel( "KorTac - Thirst Rasp", "models/arty/codmw2023/mp/kortac/thirst/rasp/thirst_pm.mdl" )
player_manager.AddValidModel( "KorTac - Thirst Rasp - ARC9", "models/arty/codmw2023/mp/kortac/thirst/rasp/thirst - arc9_pm.mdl" )

player_manager.AddValidHands( "KorTac - Thirst Rasp", "models/arty/codmw2023/mp/kortac/thirst/rasp/thirst_vm.mdl", 0, "00" )
player_manager.AddValidHands( "KorTac - Thirst Rasp - ARC9", "models/arty/codmw2023/mp/kortac/thirst/rasp/thirst_vm.mdl", 0, "00" )

hook.Add("PreDrawPlayerHands", "Rasp1_hands", function(hands, vm, ply, wpn)
    if IsValid(hands) 
	and hands:GetModel() == "models/arty/codmw2023/mp/kortac/thirst/rasp/thirst_vm.mdl" 
	or hands:GetModel() == "models/arty/codmw2023/mp/kortac/thirst/rasp/thirst_vm.mdl" 
	then
		hands:SetSkin(ply:GetSkin())
        hands:SetBodygroup(1, (ply:GetBodygroup(2)) )
        hands:SetBodygroup(2, (ply:GetBodygroup(3)) )
    end
end)

local Category = "KorTac" 

local NPC = {   Name = "Thirst Rasp Hostile", 
                Class = "npc_combine_s",
                Model = "models/arty/codmw2023/mp/kortac/thirst/rasp/thirst_hostile.mdl", 
                Health = "350", 
                Weapons = {"weapon_shotgun","weapon_smg1","weapon_ar2"}, 
                Category = Category }
                               
list.Set( "NPC", "thirstraspmw23_hostile", NPC )

local NPC = {   Name = "Thirst Rasp Friendly", 
                Class = "npc_citizen",
                Model = "models/arty/codmw2023/mp/kortac/thirst/rasp/thirst_friendly.mdl", 
                Health = "350", 
                KeyValues = { citizentype = 4 }, 
                Weapons = {"weapon_shotgun","weapon_smg1","weapon_ar2"}, 
                Category = Category }
                               
list.Set( "NPC", "thirstraspmw23_friendly", NPC )