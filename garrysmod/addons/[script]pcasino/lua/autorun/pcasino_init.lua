PerfectCasino = {}
PerfectCasino.Config = {}
PerfectCasino.Log = {}
PerfectCasino.Translation = {}
PerfectCasino.Core = {}
PerfectCasino.Sound = {}
PerfectCasino.UI = {}
PerfectCasino.Database = {}
PerfectCasino.Cooldown = {}
PerfectCasino.Chips = {}
PerfectCasino.Cards = {}
PerfectCasino.MachineLimits = {}
if CLIENT then
	PerfectCasino.Spins = 0
else
	PerfectCasino.Spins = {}
end

print("[PerfectCasino] Loading...")

local path = "PerfectCasino/"
if SERVER then
	local files, folders = file.Find(path .. "*", "LUA")
	
	for _, folder in SortedPairs(folders, true) do
		print("[PerfectCasino] Loading folder: " .. folder)
		
		-- Load shared files
		local sharedFiles = file.Find(path .. folder .. "/sh_*.lua", "LUA")
		for _, fileName in SortedPairs(sharedFiles, true) do
			local filePath = path .. folder .. "/" .. fileName
			if file.Exists(filePath, "LUA") then
				AddCSLuaFile(filePath)
				include(filePath)
				print("[PerfectCasino] Loaded shared: " .. fileName)
			else
				print("[PerfectCasino] ERROR: Shared file not found - " .. fileName)
			end
		end
	
		-- Load server files
		local serverFiles = file.Find(path .. folder .. "/sv_*.lua", "LUA")
		for _, fileName in SortedPairs(serverFiles, true) do
			local filePath = path .. folder .. "/" .. fileName
			if file.Exists(filePath, "LUA") then
				include(filePath)
				print("[PerfectCasino] Loaded server: " .. fileName)
			else
				print("[PerfectCasino] ERROR: Server file not found - " .. fileName)
			end
		end
	
		-- Add client files to download
		local clientFiles = file.Find(path .. folder .. "/cl_*.lua", "LUA")
		for _, fileName in SortedPairs(clientFiles, true) do
			local filePath = path .. folder .. "/" .. fileName
			if file.Exists(filePath, "LUA") then
				AddCSLuaFile(filePath)
				print("[PerfectCasino] Added client: " .. fileName)
			else
				print("[PerfectCasino] ERROR: Client file not found - " .. fileName)
			end
		end
	end
end

if CLIENT then
	local files, folders = file.Find(path .. "*", "LUA")
	
	for _, folder in SortedPairs(folders, true) do
		print("[PerfectCasino] Loading folder: " .. folder)
		
		-- Load shared files
		local sharedFiles = file.Find(path .. folder .. "/sh_*.lua", "LUA")
		for _, fileName in SortedPairs(sharedFiles, true) do
			local filePath = path .. folder .. "/" .. fileName
			if file.Exists(filePath, "LUA") then
				include(filePath)
				print("[PerfectCasino] Loaded shared: " .. fileName)
			else
				print("[PerfectCasino] ERROR: Shared file not found - " .. fileName)
			end
		end

		-- Load client files
		local clientFiles = file.Find(path .. folder .. "/cl_*.lua", "LUA")
		for _, fileName in SortedPairs(clientFiles, true) do
			local filePath = path .. folder .. "/" .. fileName
			if file.Exists(filePath, "LUA") then
				include(filePath)
				print("[PerfectCasino] Loaded client: " .. fileName)
			else
				print("[PerfectCasino] ERROR: Client file not found - " .. fileName)
			end
		end
	end

	-- Load fonts after everything else is loaded
	timer.Simple(0.1, function()
		local fontPath = path .. "derma/cl_fonts.lua"
		if file.Exists(fontPath, "LUA") then
			include(fontPath)
			print("[PerfectCasino] Fonts loaded")
		else
			print("[PerfectCasino] ERROR: Font file not found")
		end
	end)
end

print("[PerfectCasino] Loaded successfully!")