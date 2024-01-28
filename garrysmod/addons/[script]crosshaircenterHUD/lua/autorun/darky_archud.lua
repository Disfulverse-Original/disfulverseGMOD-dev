
if CLIENT then
resource.AddFile( "sound/weapons/lowammo_01.wav" )
end



CreateClientConVar("darky_arc_ReloadStyle", 1, true, false, "darky archud convar", 0, 3)
CreateClientConVar("darky_arc_HPStyle", 2, true, false, "darky archud convar", 0, 2)

CreateClientConVar("darky_arc_DynamicHUD", 1, true, false, "darky archud convar", 0, 1)
CreateClientConVar("darky_arc_AmmoSegments", 1, true, false, "darky archud convar", 0, 1)

CreateClientConVar("darky_arc_DrawAmmo", 1, true, false, "darky archud convar", 0, 1)
CreateClientConVar("darky_arc_DrawAmmoReserve", 1, true, false, "darky archud convar", 0, 1)
CreateClientConVar("darky_arc_DrawAmmoOnSingle", 1, true, false, "darky archud convar", 0, 1)
CreateClientConVar("darky_arc_DrawRegen", 1, true, false, "darky archud convar", 0, 1)
CreateClientConVar("darky_arc_DrawHeat", 1, true, false, "darky archud convar", 0, 1)
CreateClientConVar("darky_arc_DrawDraconicHeat", 1, true, false, "darky archud convar", 0, 1)

CreateClientConVar("darky_arc_HPNumbers", 1, true, false, "darky archud convar", 0, 1)
CreateClientConVar("darky_arc_AmmoNumbers", 1, true, false, "darky archud convar", 0, 1)

CreateClientConVar("darky_arc_DrawHud", 0, true, false, "darky archud convar", 0, 1)

CreateClientConVar("darky_arc_WakeUpOnContext", 0, true, false, "darky archud convar", 0, 1)
CreateClientConVar("darky_arc_WakeUpOnZoom", 0, true, false, "darky archud convar", 0, 1)
CreateClientConVar("darky_arc_HideOnWalk", 0, true, false, "darky archud convar", 0, 1)

CreateClientConVar("darky_arc_AmmoColorR", 255, true, false, "darky archud convar", 0, 255)
CreateClientConVar("darky_arc_AmmoColorG", 255, true, false, "darky archud convar", 0, 255)
CreateClientConVar("darky_arc_AmmoColorB", 255, true, false, "darky archud convar", 0, 255)

CreateClientConVar("darky_arc_ArcDistance", 70, true, false, "darky archud convar", 69, 70)
CreateClientConVar("darky_arc_ClickSoundOnLowAmmo", 1, true, false, "darky archud convar", 0, 1)

CreateClientConVar("darky_arc_HPColorR", 100, true, false, "darky archud convar", 0, 255)
CreateClientConVar("darky_arc_HPColorG", 220, true, false, "darky archud convar", 0, 255)
CreateClientConVar("darky_arc_HPColorB", 100, true, false, "darky archud convar", 0, 255)

CreateClientConVar("darky_arc_ARColorR", 100, true, false, "darky archud convar", 0, 255)
CreateClientConVar("darky_arc_ARColorG", 100, true, false, "darky archud convar", 0, 255)
CreateClientConVar("darky_arc_ARColorB", 220, true, false, "darky archud convar", 0, 255)

CreateClientConVar("darky_arc_ReloadR", 50, true, false, "darky archud convar", 0, 255)
CreateClientConVar("darky_arc_ReloadG", 50, true, false, "darky archud convar", 0, 255)
CreateClientConVar("darky_arc_ReloadB", 200, true, false, "darky archud convar", 0, 255)

CreateClientConVar("darky_arc_HeatR", 250, true, false, "darky archud convar", 0, 255)
CreateClientConVar("darky_arc_HeatG", 150, true, false, "darky archud convar", 0, 255)
CreateClientConVar("darky_arc_HeatB", 0, true, false, "darky archud convar", 0, 255)


hook.Add("PopulateToolMenu", "darky_archud", function()
    spawnmenu.AddToolMenuOption("Options", "Darky Arx HUD", "darky_archud", "Arx HUD", "", "", function(panel)
		panel:ClearControls()
        panel:CheckBox("#darky_arc_DynamicHUD", "darky_arc_DynamicHUD")
        panel:NumSlider("#darky_arc_ArcDistance", "darky_arc_ArcDistance", 10, 70, 0)
        panel:CheckBox("#darky_arc_DrawHud", "darky_arc_DrawHud")
        panel:CheckBox("#darky_arc_ClickSoundOnLowAmmo", "darky_arc_ClickSoundOnLowAmmo")

		panel:CheckBox("#darky_arc_DrawAmmo", "darky_arc_DrawAmmo")
		panel:CheckBox("#darky_arc_AmmoSegments", "darky_arc_AmmoSegments")
		panel:CheckBox("#darky_arc_DrawAmmoOnSingle", "darky_arc_DrawAmmoOnSingle")
		panel:CheckBox("#darky_arc_AmmoNumbers", "darky_arc_AmmoNumbers")
        panel:CheckBox("#darky_arc_DrawAmmoReserve", "darky_arc_DrawAmmoReserve")
        if ArcCWInstalled then
            panel:CheckBox("#darky_arc_DrawHeat", "darky_arc_DrawHeat")
        end
        if GetConVar("sv_drc_movement") ~= nil then
            panel:CheckBox("#darky_arc_DrawDraconicHeat", "darky_arc_DrawDraconicHeat")
        end
                
        local DLabel = vgui.Create("DLabel", panel)
        DLabel:SetText("#darky_arc_ReloadStyle")
        DLabel:Dock(TOP)
        DLabel:DockMargin(20, 20, 10, 5)
        DLabel:SetTextColor(Color(0, 0, 0))

        local comboreload, labelreload = panel:ComboBox("", "darky_arc_ReloadStyle")
        comboreload:AddChoice("0: No reload progress", 0)
        comboreload:AddChoice("1: Additional smooth reload indicator", 1)
        comboreload:AddChoice("2: White bar (bad)", 2)
        comboreload:AddChoice("3: Smooth indicator on ammo arch from last ammo in magazine to end", 3)
        labelreload:SetSize(0, 100)

        panel:CheckBox("#darky_arc_DrawRegen", "darky_arc_DrawRegen")
        panel:CheckBox("#darky_arc_HPNumbers", "darky_arc_HPNumbers")
        panel:CheckBox("#darky_arc_WakeUpOnContext", "darky_arc_WakeUpOnContext")
        panel:CheckBox("#darky_arc_WakeUpOnZoom", "darky_arc_WakeUpOnZoom")
        panel:CheckBox("#darky_arc_HideOnWalk", "darky_arc_HideOnWalk")
        local DLabel2 = vgui.Create("DLabel", panel)
        DLabel2:SetText("#darky_arc_HPStyle")
        DLabel2:Dock(TOP)
        DLabel2:DockMargin(20, 20, 10, 5)
        DLabel2:SetTextColor(Color(0, 0, 0))

        local combohp, labelhp = panel:ComboBox("", "darky_arc_HPStyle")
        combohp:AddChoice("0: No health bar", 0)
        combohp:AddChoice("1: Only health bar", 1)
        combohp:AddChoice("2: Health bar with armor bar", 2)
        labelhp:SetSize(0, 0)

        local MixerAmmo = vgui.Create("DColorMixer", panel)
        MixerAmmo:SetLabel("#darky_arc_color_ammo")
        MixerAmmo:SetPalette(false)
        MixerAmmo:SetAlphaBar(false)
        MixerAmmo:SetWangs(false)

        MixerAmmo:SetConVarR("darky_arc_AmmoColorR")
        MixerAmmo:SetConVarG("darky_arc_AmmoColorG")
        MixerAmmo:SetConVarB("darky_arc_AmmoColorB")

        MixerAmmo:GetConVarR("darky_arc_AmmoColorR")
        MixerAmmo:GetConVarG("darky_arc_AmmoColorG")
        MixerAmmo:GetConVarB("darky_arc_AmmoColorB")
        MixerAmmo:Dock(TOP)
        MixerAmmo:DockMargin(20, 20, 10, 5)

        local MixerHP = vgui.Create("DColorMixer", panel)
        MixerHP:SetLabel("#darky_arc_color_hp")
        MixerHP:SetPalette(false)
        MixerHP:SetAlphaBar(false)
        MixerHP:SetWangs(false)

        MixerHP:SetConVarR("darky_arc_HPColorR")
        MixerHP:SetConVarG("darky_arc_HPColorG")
        MixerHP:SetConVarB("darky_arc_HPColorB")

        MixerHP:GetConVarR("darky_arc_HPColorR")
        MixerHP:GetConVarG("darky_arc_HPColorG")
        MixerHP:GetConVarB("darky_arc_HPColorB")
        MixerHP:Dock(TOP)
        MixerHP:DockMargin(20, 20, 10, 5)

        local MixerAR = vgui.Create("DColorMixer", panel)
        MixerAR:SetLabel("#darky_arc_color_armor")
        MixerAR:SetPalette(false)
        MixerAR:SetAlphaBar(false)
        MixerAR:SetWangs(false)

        MixerAR:SetConVarR("darky_arc_ARColorR")
        MixerAR:SetConVarG("darky_arc_ARColorG")
        MixerAR:SetConVarB("darky_arc_ARColorB")

        MixerAR:GetConVarR("darky_arc_ARColorR")
        MixerAR:GetConVarG("darky_arc_ARColorG")
        MixerAR:GetConVarB("darky_arc_ARColorB")
        MixerAR:Dock(TOP)
        MixerAR:DockMargin(20, 20, 10, 5)

        local MixerRe = vgui.Create("DColorMixer", panel)
        MixerRe:SetLabel("#darky_arc_color_reload")
        MixerRe:SetPalette(false)
        MixerRe:SetAlphaBar(false)
        MixerRe:SetWangs(false)

        MixerRe:SetConVarR("darky_arc_ReloadR")
        MixerRe:SetConVarG("darky_arc_ReloadG")
        MixerRe:SetConVarB("darky_arc_ReloadB")

        MixerRe:GetConVarR("darky_arc_ReloadR")
        MixerRe:GetConVarG("darky_arc_ReloadG")
        MixerRe:GetConVarB("darky_arc_ReloadB")
        MixerRe:Dock(TOP)
        MixerRe:DockMargin(20, 20, 10, 5)
	end)
end)

print('arx HUD loaded!')