
if SERVER then
	local col = Color(252, 207, 109)

	local function Event(ply, args)

		if !ply:IsAdmin() then return end

		if args == "" then
			DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", "argument", ""))
			return ""
		end

		local DoSay = function(text)
			if text == "" then
				DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", "argument", ""))
				return ""
			end

			for _, target in ipairs(player.GetAll()) do
				DarkRP.talkToPerson(target, col, "[Событие]" .. " : " .. text)
			end
		end

		return args, DoSay

	end

	DarkRP.defineChatCommand("event", Event)
end


DarkRP.declareChatCommand{
	command = "event",
	description = "Отправка глобального сообщения о каком-либо событии.",
	delay = 1.5
}
