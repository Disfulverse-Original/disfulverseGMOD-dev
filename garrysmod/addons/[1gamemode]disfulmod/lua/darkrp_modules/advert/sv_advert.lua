local function initshit()
	local billboardfunction = DarkRP.getChatCommand("advert")
	billboardfunction = billboardfunction.callback
	DarkRP.removeChatCommand("advert")

	local function PlayerAdvertise(ply, args)
		if args == "" then
			DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", "argument", ""))
			return ""
		end
		local DoSay = function(text)
			if text == "" then
				DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", "argument", ""))
				return
			end
			for k,v in pairs(player.GetAll()) do
				local col = team.GetColor(ply:Team())
				DarkRP.talkToPerson(v, col, DarkRP.getPhrase("advert") .. " " .. ply:Nick(), Color(255, 255, 0, 255), text, ply)
			end
		end
		return args, DoSay
	end

	DarkRP.defineChatCommand("advert", PlayerAdvertise, 1.5)
	DarkRP.defineChatCommand("billboard", billboardfunction)
end

timer.Simple(.1, initshit)