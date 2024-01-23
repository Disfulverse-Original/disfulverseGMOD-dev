sublimeexpmodifier = 1

local path  = Sublime.GetCurrentPath();
SKILLPROMOTION = {};

-- This is the name of the skill.
SKILLPROMOTION.Name              = "Обученность";

-- The description of the skill.
SKILLPROMOTION.Description       = "Ваша зарплата увеличивается\nдо 20% на макс. уровне.";

-- If the category of the skill does not exist then we will automatically create it.
SKILLPROMOTION.Category          = "ДаркРП"

-- This is the identifier in the database, needs to be unqiue.
SKILLPROMOTION.Identifier        = "promotion";

-- The amount of buttons on the skill page.
SKILLPROMOTION.ButtonAmount      = 4;
SKILLPROMOTION.AmountPerPoint    = 5;

-- Should we enable this skill?
SKILLPROMOTION.Enabled           = true;

--[[ Весь мейн код в [script]slawer_mayor\lua\slawer_mayor\modules\taxs\sv.lua:20

if (SERVER and SKILLPROMOTION.Enabled) then
    hook.Add("playerGetSalary", path, function(ply, amount)
        if (not Sublime.Settings.Get("other", "skills_enabled", "boolean")) then
            return;
        end
        
        local points = ply:SL_GetInteger(SKILLPROMOTION.Identifier, 0);

        if (points > 0) then
            sublimeexpmodifier = 1 + ((points * SKILLPROMOTION.AmountPerPoint) / 100); 
            
            --amount = math.Round(amount * sublimeexpmodifier); 500
            --ply:addMoney(amount)
            --return false, DarkRP.getPhrase("payday_message", DarkRP.formatMoney(amount)), amount;
        end
    end);
end
--]]
Sublime.AddSkill(SKILLPROMOTION);