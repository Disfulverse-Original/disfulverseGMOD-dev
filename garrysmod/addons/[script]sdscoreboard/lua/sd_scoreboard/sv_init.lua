----------------
-- Main table --
----------------
SD_SCOREBOARD_GMS = SD_SCOREBOARD_GMS or {}
--------------
-- Includes --
--------------
resource.AddFile("resource/fonts/Kanit-Light.ttf")
include("sd_scoreboard/server/sv_config.lua")
include("sd_scoreboard/server/sv_utils.lua")

print("SD Scoreboard ver "..SD_SCOREBOARD_GMS.Ver.." loaded successfully")