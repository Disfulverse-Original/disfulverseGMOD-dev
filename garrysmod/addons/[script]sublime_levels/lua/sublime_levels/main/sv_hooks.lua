util.AddNetworkString("Sublime.BroadcastLevelUp");
util.AddNetworkString("Sublime.Interface");
util.AddNetworkString("Sublime.RequestInterface");
util.AddNetworkString("Sublime.PlayerReceivedExperience");

local path  = Sublime.GetCurrentPath();

local to = tonumber;

hook.Add("PlayerDisconnected", path, function(ply)
    if (not ply:IsBot()) then
        ply:SL_Save();
    end
end);

local function openSublimeMenu(ply)
    local total_xp = 0;

    if (not Sublime.MySQL.Enabled) then
        total_xp = sql.QueryValue(Sublime.SQL:FormatSQL("SELECT TotalExperience FROM Sublime_Levels WHERE SteamID = '%s'", ply:SteamID64()));
        local global_data = sql.Query("SELECT ExperienceGained, LevelsGained FROM Sublime_Data");

        net.Start("Sublime.Interface");
            net.WriteUInt(to(total_xp), 32);
            net.WriteUInt(to(global_data[1]["ExperienceGained"]), 32);
            net.WriteUInt(to(global_data[1]["LevelsGained"]), 32);
        net.Send(ply);
    else
        Sublime.GetSQL():Query({"SELECT TotalExperience FROM Sublime_Levels WHERE SteamID = ?", ply:SteamID64()}, function(data)
            total_xp = data[1].TotalExperience;
        end);

        Sublime.GetSQL():Query({"SELECT ExperienceGained, LevelsGained FROM Sublime_Data WHERE ID = 1"}, function(data)
            net.Start("Sublime.Interface");
                net.WriteUInt(to(total_xp), 32);
                net.WriteUInt(to(data[1].ExperienceGained), 32);
                net.WriteUInt(to(data[1].LevelsGained), 32);
            net.Send(ply);
        end);
    end
end

hook.Add("PlayerSay", path, function(ply, text)
    local text = text:lower();
    local cmd = Sublime.Settings.Get("other", "chat_command", "string");

    if (text == "/" .. cmd or text == "!" .. cmd) then
        openSublimeMenu(ply);

        return ""
    end
end);

hook.Add("SL.PlayerLeveledUp", path, function(ply, new, points)
    ply:SL_AddSkillPoint(points);

    local broadcast = Sublime.Settings.Get("other", "should_broadcast_levelup", "boolean");

    if (broadcast) then
        net.Start("Sublime.BroadcastLevelUp");
            net.WriteEntity(ply);
            net.WriteUInt(new, 32);
        net.Broadcast();
    end
end);

hook.Add("SL.PlayerReceivedExperience", path, function(ply, amount)
    net.Start("Sublime.PlayerReceivedExperience");
        net.WriteUInt(amount, 32);
    net.Send(ply);
end);

hook.Add("playerCanChangeTeam", path, function(ply, team, force)
    local job = RPExtraTeams[team];

    if (job and job.level and job.level >= 1) then
        if (ply:SL_GetLevel() < job.level) then
            DarkRP.notify(ply, 1, 5, "You need to be level " .. job.level .. " to become this job.");

            return false, false;
        end
    end
end);

---
--- checkLevel
---
--- Check level function for DarkRP items.
---
local function checkLevel(ply, ent)
    local ent_level = ent.level;

    if (ent_level and ent_level > 0) then
        local player_level = ply:SL_GetLevel();

        if (player_level < ent_level) then
            DarkRP.notify(ply, 1, 2, "You need to be level " .. ent_level .. " in order to buy this.");

            return false, true;
        end
    end
end

hook.Add("canBuyPistol",        path, checkLevel);
hook.Add("canBuyAmmo",          path, checkLevel);
hook.Add("canBuyShipment",      path, checkLevel);
hook.Add("canBuyVehicle",       path, checkLevel);
hook.Add("canBuyCustomEntity",  path, checkLevel);

local nextXP = CurTime() + 600;
hook.Add("Tick", path, function()
    if (nextXP <= CurTime()) then
        local players   = player.GetAll();
        local pCount    = player.GetCount();
        
        for i = 1, pCount do
            local ply = players[i];

            if (IsValid(ply)) then
                ply:SL_AddExperience(Sublime.Settings.Get("other", "xp_for_playing", "number"), "за игру на сервере.");
                --ply:ChatPrint("string message")
                --ply:ChatPrint(Sublime.Settings.Get("other", "xp_for_playing_when", "number"))
            end
        end

        nextXP = CurTime() + Sublime.Settings.Get("other", "xp_for_playing_when", "number");

    end
end);

net.Receive("Sublime.RequestInterface", function(_, ply)
    openSublimeMenu(ply);
end);