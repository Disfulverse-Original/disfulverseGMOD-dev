

local path  = Sublime.GetCurrentPath();
local SKILL = {};

-- This is the name of the skill.
SKILL.Name              = "Рикошет";

-- The description of the skill.
SKILL.Description       = "Пули которые по вам попали имеют шанс\nдо 5%, на макс. уровне, отрикошетить\nназад во врагов, нанося 50% от полученого урона.";

-- If the category of the skill does not exist then we will automatically create it.
SKILL.Category          = "Другое"

-- This is the identifier in the database, needs to be unqiue.
SKILL.Identifier        = "ricochet";

-- The amount of buttons on the skill page.
SKILL.ButtonAmount      = 5;
SKILL.AmountPerPoint    = 1;

-- Should we enable this skill?
SKILL.Enabled           = true;

if (SERVER and SKILL.Enabled) then
    hook.Add("EntityTakeDamage", path, function(target, data)
        if (IsValid(target) and target:IsPlayer()) then
            if (not Sublime.Settings.Get("other", "skills_enabled", "boolean")) then
                return;
            end

            local attacker = data:GetAttacker();

            if (IsValid(attacker) and attacker:IsPlayer() and data:IsDamageType(DMG_BULLET)) then
                local points = target:SL_GetInteger(SKILL.Identifier, 0);

                if (points > 0) then
                    local modifier  = points * SKILL.AmountPerPoint;
                    local random    = math.random(1, 100);

                    if (random <= modifier) then
                        local damage = data:GetDamage();

                        data:ScaleDamage(0);

                        attacker:TakeDamage(damage/2, attacker);

                        Sublime.Notify(target, "You ricochet " .. damage/2 .. " damage back to " .. attacker:Nick());
                    end
                end
            end
        end
    end);
end

Sublime.AddSkill(SKILL);