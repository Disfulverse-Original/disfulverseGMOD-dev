local AllowedGroup = {
	["superadmin"] = true,
	["admin"] = true,
}

hook.Add("PlayerSay", "PlayerSay:AnoCommande", function(ply, txt)
	if string.sub(txt, 1, string.len("/ano")) == "/ano" then
		print(txt)
		for k,v in ipairs(player.GetAll()) do 
			if AllowedGroup[v:GetNWString("usergroup")] then
				--print(v)
				local message = string.Explode( "/ano ", txt )[2]
				DarkRP.talkToPerson(v, Color(0, 0, 0, 255),  "[Инкогнито] ".. ply:Nick() .. " " , Color(61, 0, 0), message, ply)
			else
			DarkRP.talkToPerson(v, Color(0, 0, 0, 255),  "[Инкогнито] " , Color(61, 0, 0), txt)
			end
        end
        return ""
	end
end)