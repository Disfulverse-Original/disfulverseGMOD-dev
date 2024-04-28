--------------
-- Antispam --
--------------
local function Antispam(ply, time, max)
	SD_SCOREBOARD_GMS.Antispam = SD_SCOREBOARD_GMS.Antispam or {}

	local id = ply:SteamID()
	if SD_SCOREBOARD_GMS.Antispam[id] == max then return true end

	SD_SCOREBOARD_GMS.Antispam[id] = SD_SCOREBOARD_GMS.Antispam[id] and SD_SCOREBOARD_GMS.Antispam[id]+1 or 1 

	if SD_SCOREBOARD_GMS.Antispam[id] == 1 then
		timer.Simple(time, function() SD_SCOREBOARD_GMS.Antispam[id] = nil end)
	end
	return false
end

file.CreateDir("sd_scoreboard")
-------------------------------------------------------------
-- Send text to the player and translate into his language --
-------------------------------------------------------------
util.AddNetworkString("sd_scoreboard_cp")
local function SendToChat(ply, ...)
	net.Start("sd_scoreboard_cp")
	net.WriteTable({...})
	net.Send(ply)
end
---------------
-- reporting --
---------------
util.AddNetworkString("sd_scoreboard_rp")
net.Receive("sd_scoreboard_rp", function(_, ply)
	if Antispam(ply, 0.5, 2) then return end

	local selectPly = net.ReadEntity()

	if IsValid(selectPly) and selectPly:IsPlayer() then
		local selectPlySteamID = selectPly:SteamID()
		local plySteamID = ply:SteamID()

		SD_SCOREBOARD_GMS.Reporting = SD_SCOREBOARD_GMS.Reporting or {}
		SD_SCOREBOARD_GMS.Reporting[plySteamID] = SD_SCOREBOARD_GMS.Reporting[plySteamID] or {}
		SD_SCOREBOARD_GMS.Reporting[plySteamID][selectPlySteamID] = SD_SCOREBOARD_GMS.Reporting[plySteamID][selectPlySteamID] or false

		if SD_SCOREBOARD_GMS.Reporting[plySteamID][selectPlySteamID] then 
			SendToChat(ply, "wait") 
		return else
			SD_SCOREBOARD_GMS.Reporting[plySteamID][selectPlySteamID] = true
			timer.Simple( 60, function() SD_SCOREBOARD_GMS.Reporting[plySteamID][selectPlySteamID] = nil end)
		end

		local adminCount = 0
		local reason = net.ReadString()

		for _, v in ipairs(player.GetAll()) do
			if v:IsSuperAdmin() or v:IsAdmin() then 
				SendToChat(v, "reporting", ply:Nick(), selectPly:Nick(), reason)
				adminCount = adminCount + 1 
			end
		end	
		SendToChat(ply, "reported", adminCount)
	else
		SendToChat(ply, "plyNotFound")
	end
end)
---------------
-- Send data --
---------------
util.AddNetworkString("sd_scoreboard_sdtc")
local function SendData(ply, index)
	local data = SD_SCOREBOARD_GMS.Config[index]

	net.Start("sd_scoreboard_sdtc")
	net.WriteString(index)

	if istable(data) then
		net.WriteTable(data)
	elseif isstring(data) then
		net.WriteString(data)
	end

	net.Send(ply)
end

local function SendDataToAll(index)
	for _, v in ipairs(player.GetAll()) do
		SendData(v, index)
	end
end
---------------
-- Read data --
---------------
local function ReadData(index)
	local json = file.Read("sd_scoreboard/config.json", "DATA") 
	local tbl = json and util.JSONToTable(json) or nil

	if tbl then SD_SCOREBOARD_GMS.Config = tbl SD_SCOREBOARD_GMS.Config.by = "server" end
	if index then SendDataToAll(index) end
end
----------------
-- Write data --
----------------
local function WriteData(index)
	local tbl = SD_SCOREBOARD_GMS.Config
	file.Write("sd_scoreboard/config.json", util.TableToJSON(tbl))

	ReadData(index)
end
-------------
-- Logging --
-------------
local function Log(ply, str)
	if !IsValid(ply) then return end
	print("Player "..ply:Nick().." changes the sd_scoreboard parameters: "..str)
end
--------------------------
-- Get data from client --
--------------------------
util.AddNetworkString("sd_scoreboard_gd")
net.Receive("sd_scoreboard_gd", function(_, ply)

	if !ply:IsSuperAdmin() then 
		ply:Kick("Trying to change the server settings of sd_scoreboard") 
	return end

	local class = net.ReadString()
	local arg1 = net.ReadString()
	local arg2 = net.ReadString()
	local arg3 = net.ReadString()
	local index = net.ReadUInt(10)

	Log(ply, class)

	if index != 0 then 
		SD_SCOREBOARD_GMS.Config[class][index] = {arg1, arg2, arg3}
		WriteData(class)
	return end

	table.insert(SD_SCOREBOARD_GMS.Config[class], 1, {arg1, arg2, arg3})
	WriteData(class)
end)
-----------------
-- Remove data --
-----------------
util.AddNetworkString("sd_scoreboard_rd")
net.Receive("sd_scoreboard_rd", function(_, ply)

	if !ply:IsSuperAdmin() then 
		ply:Kick("Trying to change the server settings of sd_scoreboard") 
	return end

	local class = net.ReadString()
	local index = net.ReadUInt(10)

	Log(ply, class)

	table.remove(SD_SCOREBOARD_GMS.Config[class], index)
	WriteData(class)
end)	
--------------------------
-- Data position change --
--------------------------
util.AddNetworkString("sd_scoreboard_pc")
net.Receive("sd_scoreboard_pc", function(_, ply)
	
	if !ply:IsSuperAdmin() then 
		ply:Kick("Trying to change the server settings of sd_scoreboard") 
	return end
	
	local class = net.ReadString()
	local index = net.ReadUInt(10)
	local pos = net.ReadString()

	Log(ply, class)

	local newIndex = pos == "up" and index-1 or pos == "down" and index+1 or index  

	if SD_SCOREBOARD_GMS.Config[class][newIndex] != nil then 
		SD_SCOREBOARD_GMS.Config[class][index], SD_SCOREBOARD_GMS.Config[class][newIndex] = SD_SCOREBOARD_GMS.Config[class][newIndex], SD_SCOREBOARD_GMS.Config[class][index]
	end

	WriteData(class)
end)
--------------------------
-- Get bool from client --
--------------------------
util.AddNetworkString("sd_scoreboard_gbfc")
net.Receive("sd_scoreboard_gbfc", function(_, ply)

	if !ply:IsSuperAdmin() then 
		ply:Kick("Trying to change the server settings of sd_scoreboard") 
	return end
	
	local str = net.ReadString()
	Log(ply, str)

	if not SD_SCOREBOARD_GMS.Config.boolean[str] then 
		SD_SCOREBOARD_GMS.Config.boolean[str] = false
	end

	SD_SCOREBOARD_GMS.Config.boolean[str] = !SD_SCOREBOARD_GMS.Config.boolean[str]
	WriteData("boolean")
end)
----------------------------
-- Get string from client --
----------------------------
util.AddNetworkString("sd_scoreboard_gsfc")
net.Receive("sd_scoreboard_gsfc", function(_, ply)

	if !ply:IsSuperAdmin() then 
		ply:Kick("Trying to change the server settings of sd_scoreboard") 
	return end

	local id = net.ReadString()
	local str = net.ReadString()

	Log(ply, id.." = "..str)

	SD_SCOREBOARD_GMS.Config[id] = str
	WriteData(id)
end)
---------------------------
-- Return data to player --
---------------------------
util.AddNetworkString("sd_scoreboard_rdtp")
net.Receive("sd_scoreboard_rdtp", function(_, ply)
	if Antispam(ply, 1, 2) then return end

	for k, _ in pairs(SD_SCOREBOARD_GMS.Config) do
		SendData(ply, k)
	end
end)
--------------------
-- First settings --
--------------------
local function SetSettings()
	if !file.Exists("sd_scoreboard/config.json", "DATA") then
		local gmode = engine.ActiveGamemode()

		if string.find(gmode, "rp") then
			SD_SCOREBOARD_GMS.Config.categoriesBy = "ByTeam"
		end
		WriteData("categoriesBy")
	end
	ReadData()
end

SetSettings()
----------------------------------
-- create table "IF NOT EXISTS" --
----------------------------------
local function CreateLikesTable()
	sql.Query([[
		CREATE TABLE IF NOT EXISTS sd_scoreboard_likes(SteamID TEXT, Amount INTEGER);
		CREATE TABLE IF NOT EXISTS sd_scoreboard_tempLikes(FromID TEXT, ToID TEXT, Timestamp DATETIME DEFAULT CURRENT_TIMESTAMP)
	]])
end
--------------------------------------
-- Allows players to set like again --
--------------------------------------
local function CheckTempLikes()
	timer.Create( "sd_scoreboard_clearTempLikes", 3600, 0, function()
		sql.Query("DELETE FROM sd_scoreboard_tempLikes WHERE Timestamp <= DATETIME('now', '-1 day')")
	end)
end
CreateLikesTable()
CheckTempLikes()
---------------
-- Set Likes --
---------------
util.AddNetworkString("sd_scoreboard_sl")
net.Receive("sd_scoreboard_sl", function(_, ply)
	if Antispam(ply, 0.5, 2) then return end

	local selectPly = net.ReadEntity()
	if IsValid(selectPly) and selectPly:IsPlayer() then

		local plyID = ply:SteamID()
		local selectPlyID = selectPly:SteamID()

		if plyID == selectPlyID then 
			SendToChat(ply, "cannotLike")
		return end

		local tbl = sql.Query(string.format("SELECT * FROM sd_scoreboard_tempLikes WHERE FromID = '%s' AND ToID = '%s'", plyID, selectPlyID))
		if tbl then
			SendToChat(ply, "already")
		return else
			sql.Query(string.format("INSERT INTO sd_scoreboard_tempLikes(FromID, ToID) VALUES( '%s', '%s' )", plyID, selectPlyID))
		end

		local plyData = sql.Query(string.format("SELECT * FROM sd_scoreboard_likes WHERE SteamID = '%s'", selectPlyID))
		if plyData then
			sql.Query(string.format("UPDATE sd_scoreboard_likes SET Amount = %s WHERE SteamID = '%s'", plyData[1].Amount+1, selectPlyID))
		else
			sql.Query(string.format("INSERT INTO sd_scoreboard_likes(SteamID, Amount) VALUES( '%s', %s )", selectPlyID, 1))
		end

		SendToChat(ply, "youLiked", selectPly:Nick())
	else
		SendToChat(ply, "plyNotFound")
	end
end)
---------------
-- Get likes --
---------------
util.AddNetworkString("sd_scoreboard_gl")
net.Receive("sd_scoreboard_gl", function(_, ply)
	if Antispam(ply, 0.5, 2) then return end

	local selectPly = net.ReadEntity()
	if IsValid(selectPly) and selectPly:IsPlayer() then

		local plyData = sql.Query(string.format("SELECT * FROM sd_scoreboard_likes WHERE SteamID = '%s'", selectPly:SteamID()))
		local amount = plyData and plyData[1].Amount or 0

		local bool = sql.Query(string.format("SELECT * FROM sd_scoreboard_tempLikes WHERE FromID = '%s' AND ToID = '%s'", ply:SteamID(), selectPly:SteamID()))

		net.Start("sd_scoreboard_gl")
		net.WriteUInt(amount, 31)
		net.WriteBool(bool)
		net.Send(ply)
	else
		SendToChat(ply, "plyNotFound")
	end
end)