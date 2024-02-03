

local path  = Sublime.GetCurrentPath();
local SKILL = {};

-- This is the name of the skill.
SKILL.Name              = "Ловкость рук";

-- The description of the skill.
SKILL.Description       = "Время на взлом дверей сокращается\nдо 50% на макс. уровне.";

-- If the category of the skill does not exist then we will automatically create it.
SKILL.Category          = "ДаркРП"

-- This is the identifier in the database, needs to be unqiue.
SKILL.Identifier        = "master_thief";

-- The amount of buttons on the skill page.
SKILL.ButtonAmount      = 5;
SKILL.AmountPerPoint    = 0.100;

-- Should we enable this skill?
SKILL.Enabled           = true;

if (SERVER and SKILL.Enabled) then
    hook.Add("lockpickTime", path, function(ply, ent)
        if (not Sublime.Settings.Get("other", "skills_enabled", "boolean")) then
            return;
        end
        
        local weapon = ply:GetActiveWeapon();
        
        if (IsValid(weapon)) then
            if (weapon.AdminOnly) then
                return;
            end
        end

        local points = ply:SL_GetInteger(SKILL.Identifier, 0);

        if (points > 0) then
            local time = 15 * (1 - (points * SKILL.AmountPerPoint));

            return time;
        end
    end);
end
Sublime.AddSkill(SKILL);