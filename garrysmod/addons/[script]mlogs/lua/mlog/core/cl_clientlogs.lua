--[[
	mLogs (M4D Logs)
	Created by M4D | http://m4d.one/ | http://steamcommunity.com/id/m4dhead | legal@m4d.one
	Copyright © 2016 M4D.one All Rights Reserved
	All 3rd party content is public domain or used with permission
	M4D.one is the copyright holder of all code below. Do not distribute in any circumstances.
--]]

function mLog.getFolderName(Type)
	local fol = mLog.root .. Type
	if not file.Exists(fol, "DATA") then
		file.CreateDir(fol)
	end
	local fol2 = fol .. "/" .. os.date( "%d-%m-%Y" , os.time() ) .. "/"
	if not file.Exists(fol2, "DATA") then
		file.CreateDir(fol2)
	end
	return string.lower(fol2)
end
function mLog.getFileName(category, Type)
	local File = mLog.getFolderName(Type) .. category .. ".txt"
	File = string.lower(File)
	if not file.Exists(File, "DATA") then
			file.Write(File,
[[-----------------------------------------------------
This is the readable mLogs log for ]] .. category .. [[
-----------------------------------------------------

]])
	end
	return File
end

function mLog.ClientInit()
	if not file.Exists("mlog", "DATA") then
		file.CreateDir("mlog")
	end
	if not file.Exists("mlog/human_logs/", "DATA") then
		file.CreateDir("mlog/human_logs/")
	end
end
mLog.ClientInit()

hook.Add("Think", "mLog_updateFile", function()
	if mLog.last_savetime then
		if mLog.last_savetime < CurTime() and table.Count(mLog.cluster) > 1 then
			local saveTab = table.Copy(mLog.cluster)
			mLog.cluster = {}
			for k,v in pairs(saveTab) do
				file.Append(mLog.getFileName(k, "human_logs"), table.concat(v, "\n") .. "\n" )
			end
			mLog.last_savetime = CurTime() + 5
		end
	else
		mLog.last_savetime = CurTime() + 5
	end
end)

mLog.cluster = {}
local localName = "330a33e76412884efbd0e37e03b6aba15451e02e86c70b83ad873bec9db5be43"
net.Receive("mLog_sendData", function()
	local ld = net.ReadTable()
	
	if not (ld.time and ld.category and ld.log) then return end
	if not mLog.cluster[ld.category] then
		mLog.cluster[ld.category] = {}
	end
	table.insert(mLog.cluster[ld.category], "[".. os.date( "%X" , ld.time ) .."] " .. ld.log)
	
end)

