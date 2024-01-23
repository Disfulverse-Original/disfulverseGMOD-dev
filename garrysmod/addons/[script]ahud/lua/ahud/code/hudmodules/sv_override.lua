local function onRefresh()
    if !ahud.DisableModules.AddYellowIcon then
        RunConsoleCommand("mp_show_voice_icons", 0)
    end
end

hook.Add("PreGamemodeLoaded", "RemoveYellowVoice", onRefresh)
onRefresh()