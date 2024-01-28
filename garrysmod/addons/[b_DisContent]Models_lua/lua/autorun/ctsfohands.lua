if SERVER then
	AddCSLuaFile()
end

player_manager.AddValidHands( "CTSFO", "models/arty/codmw2019/mp/coalition/ctsfo_vm.mdl", 0, "00" )
player_manager.AddValidHands( "CTFSO - ARC9", "models/arty/codmw2019/mp/coalition/ctsfo_vm.mdl", 0, "00" )

hook.Add("PreDrawPlayerHands", "ctsfo1_hands", function(hands, vm, ply, wpn)
    if IsValid(hands) 
	and hands:GetModel() == "models/arty/codmw2019/mp/coalition/ctsfo_vm.mdl" 
	or hands:GetModel() == "models/arty/codmw2019/mp/coalition/ctsfo_vm.mdl" 
	then
		hands:SetSkin(ply:GetSkin())
        hands:SetBodygroup(0, (ply:GetBodygroup(1)) )
        hands:SetBodygroup(1, (ply:GetBodygroup(2)) )
    end
end)
