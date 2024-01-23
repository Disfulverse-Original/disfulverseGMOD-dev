util.AddNetworkString("ahud_events")

local function sendEvent(target, actor, reason, id)
    net.Start("ahud_events")
        net.WriteUInt(id, 3)
        net.WriteEntity(target)
        net.WriteEntity(actor)
        net.WriteString(reason or "")
    net.Broadcast()
end

hook.Add("playerWarranted", "ahud_sendEvents", function(t, a, reason)
    sendEvent(t, a, reason, 0)
    return true
end)

hook.Add("playerWanted", "ahud_sendEvents", function(t, a, reason)
    sendEvent(t, a, reason, 1)
    return true
end)

hook.Add("playerUnWanted", "ahud_sendEvents", function(t, a, reason)
    sendEvent(t, a, reason, 2)
    return true
end)

hook.Add("playerUnWarranted", "ahud_sendEvents", function(t, a, reason)
    sendEvent(t, a, reason, 3)
    return true
end)

hook.Add("lockdownStarted", "ahud_sendEvents", function()
    sendEvent(t, a, reason, 4)
    return true
end)

util.AddNetworkString("ahud_arrest")
hook.Add("playerArrested", "ahud_sendEvents", function(t, time, a)
    net.Start("ahud_arrest")
        net.WriteUInt(time, 16)
    net.Send(t)

    return true
end)

util.AddNetworkString("ahud_changedteam")
hook.Add("PlayerChangedTeam", "ahud_sendEvents", function(ply, _, n)
    net.Start("ahud_changedteam")
        net.WriteUInt(n, 16)
    net.Send(ply)
end)

// Showcase
/*

concommand.Add("ahud_showcase", function(ply)
    if ply:IsSuperAdmin() then
        if GetGlobalBool("lockdown") then
            DarkRP.unLockdown(ply)
        end
        
        local bot = player.GetBots()[1]
        
        if !bot then
            RunConsoleCommand("bot")
            bot = player.GetBots()[1]
        end
        
        ply:Say("/mayor")
        
        ply:warrant(bot, "Hello world!")
        ply:wanted(bot, "Hello world!", 300)
        ply:setDarkRPVar("HasGunlicense", true)
        ply:setDarkRPVar("Energy", 20)
        ply:setDarkRPVar("agenda", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin nec volutpat augue.")
        DarkRP.createVote("Hello, i'm a vote!", "voteXD", bot, 10, function() end)
        
        DarkRP.lockdown(ply)
        for i=0, 4 do
            DarkRP.notify(ply, i, 5, "Hello, Notification")
        end
    end
end)
        */