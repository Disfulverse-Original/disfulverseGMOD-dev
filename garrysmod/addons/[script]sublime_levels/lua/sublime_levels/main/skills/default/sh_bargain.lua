

local path  = Sublime.GetCurrentPath();
local SKILL = {};

-- This is the name of the skill.
SKILL.Name              = "Барыга";

-- The description of the skill.
SKILL.Description       = "Предметы в магазине будут дешевле.\nДо 35% на макс. уровне.";

-- If the category of the skill does not exist then we will automatically create it.
SKILL.Category          = "ДаркРП"

-- This is the identifier in the database, needs to be unqiue.
SKILL.Identifier        = "bargain";

-- The amount of buttons on the skill page.
SKILL.ButtonAmount      = 10;
SKILL.AmountPerPoint    = 0.035;

-- Should we enable this skill?
SKILL.Enabled           = true;

if (SERVER and SKILL.Enabled) then
    local hooks = {
        "Ammo",
        "CustomEntity",
        "Pistol",
        "Shipment",
    }

    for i = 1, #hooks do
        hook.Add("canBuy" .. hooks[i], path, function(ply, data)
            local points = ply:SL_GetInteger(SKILL.Identifier, 0);

            if (not Sublime.Settings.Get("other", "skills_enabled", "boolean")) then
                return;
            end

            if (points > 0) then
                local price;

                if (data.separate) then
                    price = math.Round(data.pricesep * (1 - (points * SKILL.AmountPerPoint)))
                else
                    price = math.Round(data.price * (1 - (points * SKILL.AmountPerPoint)));
                end

                return true, false, _, price;
            end
        end);
    end
end
Sublime.AddSkill(SKILL);