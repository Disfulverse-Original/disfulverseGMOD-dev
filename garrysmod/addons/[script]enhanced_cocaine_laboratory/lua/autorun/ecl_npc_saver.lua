--[[Enhanced Cocaine Laboratory 1.2]]
--[[Leaked by High Leaker          ]]
--[[Enjoy !                        ]]

if SERVER then
timer.Simple(1,
	function()
		if !file.IsDir("jb", "DATA") then
			file.CreateDir("jb", "DATA");
		end;

		if !file.IsDir("jb/ecl", "DATA") then
			file.CreateDir("jb/ecl", "DATA");
		end;
		   
		if !file.IsDir("jb/ecl/"..string.lower(game.GetMap()).."", "DATA") then
			file.CreateDir("jb/ecl/"..string.lower(game.GetMap()).."", "DATA");
		end;
	 
		for k, v in pairs(file.Find("jb/ecl/"..string.lower(game.GetMap()).."/*.txt", "DATA")) do
			local treePosFile = file.Read("jb/ecl/"..string.lower(game.GetMap()).."/"..v, "DATA");
			 
			local spawnNumber = string.Explode(" ", treePosFile);         
				   
			local npc = ents.Create("ecl_npc");
			npc:SetPos(Vector(spawnNumber[1], spawnNumber[2], spawnNumber[3]));
			npc:SetAngles(Angle(tonumber(spawnNumber[4]), spawnNumber[5], spawnNumber[6]));
			npc:Spawn();
		end;

		ECL:Log("All NPCs have been successfully spawned.")
	end
	);
	 
	function removeNpcPos(ply, cmd, args)
		if (ply:IsAdmin() or ply:IsSuperAdmin()) then
			local fileNpcName = args[1];
				   
			if !fileNpcName then
				ply:SendLua("local tab = {Color(255,165,0,255), ECL.Language.Spawn.ECL..[[ - ]], Color(255,255,255), [[]]..ECL.Language.Spawn.EnterUniqueID..[[]] } chat.AddText(unpack(tab))");
				return;
			end;
					   
			if file.Exists("jb/ecl/"..string.lower(game.GetMap()).."/ecl_npc_"..fileNpcName..".txt", "DATA") then
				local nick = ply:Nick();
				ECL:Log(nick.." has removed spawn of NPC. ID: "..args[1])
				file.Delete("jb/ecl/"..string.lower(game.GetMap()).."/ecl_npc_"..fileNpcName..".txt");
				ply:SendLua("local text = string.Replace(ECL.Language.Spawn.Remove, '<%donttouch%>', 'NPC'); local tab = {Color(255,165,0,255), ECL.Language.Spawn.ECL..[[ - ]], Color(255,255,255), [[]]..text..[[]] } chat.AddText(unpack(tab))");
				return;
			end;
				   
		else
			ply:SendLua("local tab = {Color(255,165,0,255), ECL.Language.Spawn.ECL..[[ - ]], Color(255,255,255), [[]]..ECL.Language.Spawn.OnlyAdmins..[[]] } chat.AddText(unpack(tab))");                       
		end;
	end;
	concommand.Add("ecl_npc_remove", removeNpcPos);
end