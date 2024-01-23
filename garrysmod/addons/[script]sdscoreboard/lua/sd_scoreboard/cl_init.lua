SD_SCOREBOARD_GMS = SD_SCOREBOARD_GMS or {}
SD_SCOREBOARD_GMS.Config = SD_SCOREBOARD_GMS.Config or {}

SD_SCOREBOARD_GMS.Focus = false
SD_SCOREBOARD_GMS.AllowHide = true

SD_SCOREBOARD_GMS.ActiveTab = 1
SD_SCOREBOARD_GMS.ActiveSettings = 1
SD_SCOREBOARD_GMS.ActiveLanguage = 1

SD_SCOREBOARD_GMS.LeftSide  = false
--------------
-- Includes --
--------------
include("sd_scoreboard/client/cl_colors.lua")
include("sd_scoreboard/client/cl_languages.lua")

include("sd_scoreboard/client/cl_utils.lua")
include("sd_scoreboard/client/cl_config.lua")

include("sd_scoreboard/client/vgui/cl_circleavatar.lua")
include("sd_scoreboard/client/vgui/cl_grid.lua")
include("sd_scoreboard/client/vgui/cl_scroll.lua")

include("sd_scoreboard/client/panels/cl_base.lua")
include("sd_scoreboard/client/panels/cl_players.lua")
include("sd_scoreboard/client/panels/cl_profile.lua")
include("sd_scoreboard/client/panels/cl_settings.lua")
include("sd_scoreboard/client/panels/cl_admin_settings.lua")
include("sd_scoreboard/client/panels/cl_web.lua")