// Let's not override the whole gestures system
if DarkRP and DarkRP.disabledDefaults["modules"]["animations"] then return end

local function detour()
    if !DarkRP or DarkRP.disabledDefaults["modules"]["animations"] then return end

    if ahud.oldAnimations then
        concommand.Add("_DarkRP_AnimationMenu", function()
            if !ahud.radMenuOpened then
                local v = vgui.Create("ahudRadial")
                v:BuildPanels(ahud.oldAnimations)
            end
        end)
        return
    end

    local name, animTable = debug.getupvalue( concommand.GetTable()._darkrp_animationmenu, 2 )
    if name != "Anims" then return end

    animTable = table.Copy(animTable)
    ahud.oldAnimations = {}

    for k, v in pairs(animTable) do
        table.insert(ahud.oldAnimations, {
            txt = v,
            callback = function()
                RunConsoleCommand("_DarkRP_DoAnimation", k)
            end,
        })
    end

    concommand.Add("_DarkRP_AnimationMenu", function()
        if !ahud.radMenuOpened then
            local v = vgui.Create("ahudRadial")
            v:BuildPanels(ahud.oldAnimations)
        end
    end)
end

detour()
hook.Add("PostGamemodeLoaded", "ahud_GesturesDetour", detour)