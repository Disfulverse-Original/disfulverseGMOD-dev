local hideHUDElements = {
    ["DarkRP_HUD"] = true,
    ["DarkRP_EntityDisplay"] = true,
    ["DarkRP_LocalPlayerHUD"] = true,
    ["DarkRP_Hungermod"] = true,
    ["DarkRP_Agenda"] = true,
    ["DarkRP_LockdownHUD"] = true,
    ["DarkRP_ArrestedHUD"] = true,
    //["DarkRP_ChatReceivers"] = false,
    ["CHudAmmo"] = true,
    ["CHudSecondaryAmmo"] = true,

    ["VCMod_Side"] = ahud.DisableModules.Speedometer,
    ["MurderHealthBall"] = true,
    ["MurderPlayerType"] = true,
    ["TTTInfoPanel"] = true
}



hook.Add("HUDShouldDraw", "AHud_OverrideDarkRP", function(name)
    if hideHUDElements[name] then return false end
end)