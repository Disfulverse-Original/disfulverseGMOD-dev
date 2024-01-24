local maindirectory = "namechange"
local AddonName = "NC"
local version = "VERSION"
if SERVER then
	MsgC(Color( 255, 179, 3 ), "\n--------------------------------[ "..AddonName.." ]-------------------------------\n")
	MsgC(Color( 255, 179, 3 ), "\n---------[ RP Name Change System by BC BEST on ScriptFodder ]--------\n")
	MsgC(Color( 255, 179, 3 ), "\n---------------------------[ Version "..version.." ]---------------------------\n\n")
	AddCSLuaFile()
	local folder = maindirectory .. "/shared"
	local files = file.Find( folder .. "/" .. "*.lua", "LUA" )
	for _, file in ipairs( files ) do
		AddCSLuaFile( folder .. "/" .. file )
	end

	folder = maindirectory .."/client"
	files = file.Find( folder .. "/" .. "*.lua", "LUA" )
	for _, file in ipairs( files ) do
		AddCSLuaFile( folder .. "/" .. file )
	end

	--Shared modules
	local files = file.Find( maindirectory .."/shared/*.lua", "LUA" )
	if #files > 0 then
		for _, file in ipairs( files ) do
			MsgC(Color( 255, 179, 3), "[" .. AddonName .. "] Loading SHARED file: " .. file .. "\n")
			include( maindirectory .. "/shared/" .. file )
			AddCSLuaFile( maindirectory .. "/shared/" .. file )
		end
	end

	--Server modules
	local files = file.Find( maindirectory .."/server/*.lua", "LUA" )
	if #files > 0 then
		for _, file in ipairs( files ) do
			MsgC(Color( 255, 179, 3 ), "[" .. AddonName .. "] Loading SERVER file: " .. file .. "\n")
			include( maindirectory .. "/server/" .. file )
		end
	end

	MsgC(Color( 255, 179, 3 ), "\n----------------------------[ Load Complete ]------------------------\n")
end

if CLIENT then
	MsgC(Color( 255, 179, 3 ), "\n--------------------------------[ "..AddonName.." ]-------------------------------\n")
	MsgC(Color( 255, 179, 3 ), "\n---------[ RP Name Change System by BC BEST on ScriptFodder ]--------\n")
	MsgC(Color( 255, 179, 3 ), "\n---------------------------[ Version "..version.." ]---------------------------\n\n")
	--Shared modules
	local files = file.Find( maindirectory .."/shared/*.lua", "LUA" )
	if #files > 0 then
		for _, file in ipairs( files ) do
			MsgC(Color( 255, 179, 3 ), "[" .. AddonName .. "] Loading SHARED file: " .. file .. "\n")
			include( maindirectory .. "/shared/" .. file )
		end
	end

	--Client modules
	local files = file.Find( maindirectory .."/client/*.lua", "LUA" )
	if #files > 0 then
		for _, file in ipairs( files ) do
			MsgC(Color( 255, 179, 3 ), "[" .. AddonName .. "] Loading CLIENT file: " .. file .. "\n")
			include( maindirectory .."/client/" .. file )
		end
	end
	MsgC(Color( 255, 179, 3 ), "\n----------------------------[ Load Complete ]------------------------\n")
end 