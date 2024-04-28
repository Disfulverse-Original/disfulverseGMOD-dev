
include("darkrp_modules/rp_looc_cmd/sh_looc.lua")

local conf = LOOCCONF

local function Looc(ply, args)
	if args == "" then
		DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", "argument", ""))
		return ""
	end

	local DoSay = function(text)
		if text == "" then
			DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", "argument", ""))
			return ""
		end
		if GAMEMODE.Config.alltalk then
			for _, target in pairs(player.GetAll()) do
				DarkRP.talkToPerson(target, team.GetColor(ply:Team()), conf.tchatmsg ..ply:Nick() .. " : " .. text)
			end
		else
			DarkRP.talkToRange(ply, conf.tchatmsg ..ply:Nick() .. " : " .. text, "", 250)
		end
	end
	return args, DoSay
end
DarkRP.defineChatCommand(conf.cmd, Looc, 1.5)
DarkRP.defineChatCommand(conf.cmd2, Looc, 1.5)



DarkRP.declareChatCommand{
	command = conf.cmd,
	description = "write an looc",
	delay = 1.5
}

DarkRP.declareChatCommand{
	command = conf.cmd2,
	description = "write an looc",
	delay = 1.5
}