

local path  = Sublime.GetCurrentPath();
local SKILL = {};

-- This is the name of the skill.
SKILL.Name              = "Метаболизм";

-- The description of the skill.
SKILL.Description       = "Пока вы не находитесь в бою, вы восстанавливаете\nдо 2%, на макс. уровне, от вашего макс. кол-ва здоровья каждые 60 сек.";

-- If the category of the skill does not exist then we will automatically create it.
SKILL.Category          = "Физика"

-- This is the identifier in the database, needs to be unqiue.
SKILL.Identifier        = "regeneration";

-- The amount of buttons on the skill page.
SKILL.ButtonAmount      = 10;
SKILL.AmountPerPoint    = 0.002;

-- Should we enable this skill?
SKILL.Enabled           = true;

-- Custom variables used by this skill only.

-- How often should the player receive health? These are in seconds.
SKILL.Cooldown = 60;

-- How long does the player need to wait before receiving health after taking damage?
SKILL.Wait = 360;

-- NOTE:
-- If you want to change how much health the player receives then you need to change the SKILL.AmountPerPoint variable.
-- The variable is extremely sensitive towards numbers, the default is 0.002. If you think this is too little then change it to 0.004;
-- The higher the variable number the more health the player will receive.

-- If you change the number then make sure to change the description to match its current number.
if (SERVER and SKILL.Enabled) then
    hook.Add("EntityTakeDamage", path, function(ent, dmg)
        if (not Sublime.Settings.Get("other", "skills_enabled", "boolean")) then
            return;
        end

        if (IsValid(ent) and ent:IsPlayer()) then
            if (dmg:GetDamage() >= 1) then
                local points = ent:SL_GetInteger(SKILL.Identifier, 0) * SKILL.AmountPerPoint;

                if (points > 0) then
                    ent.SublimeLevels_CanRegenerate = CurTime() + SKILL.Wait;
                end
            end
        end
    end);

    -- Just the initial cooldown
    local Cooldown = CurTime() + 2;
    hook.Add("Tick", path, function()
        if (Cooldown > CurTime()) then
            return;
        end

        if (not Sublime.Settings.Get("other", "skills_enabled", "boolean")) then
            Cooldown = CurTime() + SKILL.Cooldown;
            
            return;
        end

        local players = player.GetAll();
        for i = 1, #players do
            local player = players[i];

            if (player.SublimeLevels_CanRegenerate and player.SublimeLevels_CanRegenerate <= CurTime()) then
                local maxHealth = player:GetMaxHealth();
                local points    = player:SL_GetInteger(SKILL.Identifier, 0) * SKILL.AmountPerPoint;

                if (points > 0) then
                    local health = player:Health();

                    if (health >= maxHealth) then
                        continue;
                    end

                    local newHealth = math.Clamp(health + (points * maxHealth), 1, maxHealth);
                    player:SetHealth(newHealth);
                end
            end
        end

        Cooldown = CurTime() + SKILL.Cooldown;
    end);
end

Sublime.AddSkill(SKILL);