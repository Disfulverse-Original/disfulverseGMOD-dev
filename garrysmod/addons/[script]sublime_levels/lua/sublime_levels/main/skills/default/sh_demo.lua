

local path  = Sublime.GetCurrentPath();
local SKILL = {};

-- This is the name of the skill.
SKILL.Name              = "Взрывоустойчивость";

-- The description of the skill.
SKILL.Description       = "Снижает получаемый урон от взрывов\nдо 20% на макс. уровне.";

-- If the category of the skill does not exist then we will automatically create it.
SKILL.Category          = "Физика"

-- This is the identifier in the database, needs to be unqiue.
SKILL.Identifier        = "explosive_damage_resistance";

-- The amount of buttons on the skill page.
SKILL.ButtonAmount      = 4;
SKILL.AmountPerPoint    = 5;

-- Should we enable this skill?
SKILL.Enabled           = true;

if (SERVER and SKILL.Enabled) then
    hook.Add("EntityTakeDamage", path, function(ent, dmg)
        if (not Sublime.Settings.Get("other", "skills_enabled", "boolean")) then
            return;
        end

        if (IsValid(ent) and ent:IsPlayer()) then
            if (dmg:GetDamage() > 1 and dmg:IsDamageType(DMG_BLAST)) then
                local points = ent:SL_GetInteger(SKILL.Identifier, 0) * SKILL.AmountPerPoint;

                if (points < 1) then
                    return;
                end

                local modifier = 1 - (points / 100);
                
                dmg:ScaleDamage(modifier);
            end
        end
    end);
end

Sublime.AddSkill(SKILL);