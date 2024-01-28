if SERVER then
	AddCSLuaFile()
end

player_manager.AddValidHands( "Horangi - D.E.A.D Agent - ARC9", "models/arty/codmw2022/mp/kortac/horangi/dead/horangi_vm.mdl", 0, "00" )

hook.Add("PreDrawPlayerHands", "Dead2_hands", function(hands, vm, ply, wpn)
    if IsValid(hands) 
	and hands:GetModel() == "models/arty/codmw2022/mp/kortac/horangi/dead/horangi_vm.mdl"
	then
		hands:SetSkin(ply:GetSkin())
        hands:SetBodygroup(0, (ply:GetBodygroup(1)) )
        hands:SetBodygroup(1, (ply:GetBodygroup(2)) )
    end
end)
