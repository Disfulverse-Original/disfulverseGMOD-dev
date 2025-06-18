-- Add client files to download
local clientFiles = {
	"easychat/networking.lua",
	"easychat/server_config.lua",
	"easychat/migrations.lua",
	"easychat/unicode_transliterator.lua",
	"easychat/chathud.lua",
	"easychat/markup.lua",
	"easychat/easychat.lua",
	"easychat/autoloader.lua",
	"easychat/engine_chat_hack.lua",
	"easychat/client/font_extensions.lua",
	"easychat/client/blur_panel.lua",
	"easychat/client/translator.lua",
	"easychat/client/expressions.lua",
	"easychat/client/macro_processor.lua",
	"easychat/client/settings.lua",
	"easychat/client/vgui/chatbox_panel.lua",
	"easychat/client/vgui/richtextx.lua",
	"easychat/client/vgui/richtext_legacy.lua",
	"easychat/client/vgui/textentryx.lua",
	"easychat/client/vgui/textentry_legacy.lua",
	"easychat/client/vgui/emote_picker.lua",
	"easychat/client/vgui/color_picker.lua",
	"easychat/client/vgui/chat_tab.lua",
	"easychat/client/vgui/settings_menu.lua",
	"easychat/client/vgui/chathud_font_editor_panel.lua"
}

for _, filePath in ipairs(clientFiles) do
	if file.Exists(filePath, "LUA") then
		AddCSLuaFile(filePath)
	else
		print("[EASYCHAT] ERROR: Client file not found - " .. filePath)
	end
end

-- Load shared files
local sharedFiles = {
	"easychat/client/font_extensions.lua",
	"easychat/migrations.lua",
	"easychat/easychat.lua",
	"easychat/engine_chat_hack.lua"
}

for _, filePath in ipairs(sharedFiles) do
	if file.Exists(filePath, "LUA") then
		include(filePath)
	else
		print("[EASYCHAT] ERROR: Shared file not found - " .. filePath)
	end
end

if SERVER then
	local serverPath = "easychat/server/stats.lua"
	if file.Exists(serverPath, "LUA") then
		include(serverPath)
		print("[EASYCHAT] Server stats loaded")
	else
		print("[EASYCHAT] ERROR: Server file not found - " .. serverPath)
	end
end

Msg("Easy ", "Chat ", "Loaded!")