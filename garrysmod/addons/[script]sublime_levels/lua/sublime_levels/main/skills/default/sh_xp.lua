

local path  = Sublime.GetCurrentPath();
local SKILL = {};

-- This is the name of the skill.
SKILL.Name              = "Опытный";

-- The description of the skill.
SKILL.Description       = "Повышает весь получаемый опыт\nдо 30% на макс. уровне.";

-- If the category of the skill does not exist then we will automatically create it.
SKILL.Category          = "Другое"

-- This is the identifier in the database, needs to be unqiue.
SKILL.Identifier        = "experienced_player";

SKILL.ButtonAmount      = 10;
SKILL.AmountPerPoint    = 3;

-- Should we enable this skill?
SKILL.Enabled           = true;

Sublime.AddSkill(SKILL);