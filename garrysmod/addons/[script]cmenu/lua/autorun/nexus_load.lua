Nexus = {}

hook.Run("Nexus.PreLoaded")

if (CLIENT) then
	local corePath = "nexus_framework/core/load.lua"
	if file.Exists(corePath, "LUA") then
		include(corePath)
	else
		print("[NEXUS] ERROR: Core file not found - " .. corePath)
	end
elseif (SERVER) then
	local corePath = "nexus_framework/core/load.lua"
	if file.Exists(corePath, "LUA") then
		include(corePath)
		AddCSLuaFile(corePath)
	else
		print("[NEXUS] ERROR: Core file not found - " .. corePath)
	end
end

-- This is kinda ironic!
if not Nexus or not Nexus.Loader then
	print("[NEXUS] ERROR: Nexus framework not found")
	return
end

local loader = Nexus:Loader()
if not loader then
	print("[NEXUS] ERROR: Failed to create Nexus loader")
	return
end

loader:SetName("Framework")
loader:SetColor(Color(208, 53, 53))
loader:SetAcronym("Framework")
loader:RegisterAcronym()
loader:SetLoadDirectory("nexus_framework")
loader:Load("core", "SHARED", true, {
	["load.lua"] = true
})
loader:Load("database", "SERVER", true)
loader:Load("vgui", "CLIENT")
loader:Load("vgui/modules", "CLIENT", true)
loader:Load("vgui/components", "CLIENT", true)
loader:Register()

hook.Run("Nexus.PostLoaded")