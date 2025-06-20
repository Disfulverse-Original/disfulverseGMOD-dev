local path = Sublime.GetCurrentPath();

hook.Add("lotteryEnded", path, function(_, chosen)
    if (not IsValid(chosen)) then
        return;
    end

    local experience = Sublime.Settings.Get("darkrp", "lottery_winner", "number")
    chosen:SL_AddExperience(experience, "for winning the lottery!");
end);

hook.Add("onHitCompleted", path, function(hitman, target)
    if (not IsValid(hitman) or not IsValid(target) or hitman == target) then
        return;
    end

    local experience = Sublime.Settings.Get("darkrp", "hitman_completed", "number")
    hitman:SL_AddExperience(experience, "for completing a hit.");
end);

hook.Add("playerArrested", path, function(criminal, _, actor)
    if (not IsValid(actor) or not IsValid(criminal) or not criminal:IsPlayer()) then
        return;
    end

    if (criminal:isWanted() and not criminal:isCP()) then
        local experience = Sublime.Settings.Get("darkrp", "player_arrested", "number")
        actor:SL_AddExperience(experience, "for arresting " .. criminal:Nick());
    end
end);

--[[
hook.Add("onPaidTax", path, function(ply)
    if (not IsValid(ply)) then
        return;
    end

    local experience = Sublime.Settings.Get("darkrp", "player_taxed", "number");
    ply:SL_AddExperience(experience, "for paying tax, like a good person.");
end);
--]]