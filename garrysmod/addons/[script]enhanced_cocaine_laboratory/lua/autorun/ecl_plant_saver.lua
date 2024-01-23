--[[Enhanced Cocaine Laboratory 1.2]]
--[[Leaked by High Leaker          ]]
--[[Enjoy !                        ]]

if SERVER then
timer.Simple(5,
	function()
		if !file.IsDir("jb", "DATA") then
			file.CreateDir("jb", "DATA");
		end;

		if !file.IsDir("jb/ecl_plants", "DATA") then
			file.CreateDir("jb/ecl_plants", "DATA");
		end;
		   
		if !file.IsDir("jb/ecl_plants/"..string.lower(game.GetMap()).."", "DATA") then
			file.CreateDir("jb/ecl_plants/"..string.lower(game.GetMap()).."", "DATA");
		end;
	 
		for k, v in pairs(file.Find("jb/ecl_plants/"..string.lower(game.GetMap()).."/*.txt", "DATA")) do
			local treePosFile = file.Read("jb/ecl_plants/"..string.lower(game.GetMap()).."/"..v, "DATA");
			 
			local spawnNumber = string.Explode(" ", treePosFile);         
				   
			local npc = ents.Create("ecl_plant");
			npc:SetPos(Vector(spawnNumber[1], spawnNumber[2], spawnNumber[3]));
			npc:SetAngles(Angle(tonumber(spawnNumber[4]), spawnNumber[5], spawnNumber[6]));
			npc:Spawn();
			npc:SetModel("models/srcocainelab/cocaplant_nopot.mdl");
			npc:SetBodygroup(1, 2)
		end;
		ECL:Log("All plants have been successfully spawned.")
	end
	);
	
	if !ECL.ConCommands then
    if ECL.Logs and ECL.Logs.Enabled then 
        ECL:Log("ConCommands have been successfully loaded.")
    else
        print("[ECL]: ConCommands have been successfully loaded.") 
    end
    ECL.ConCommands = true;
end
    
local function spawnPlantPos(ply, cmd, args)
		if (ply:IsAdmin() or ply:IsSuperAdmin()) then
			local fileNpcName = args[1];
               
            if !fileNpcName then
                ply:SendLua("local text = string.Replace(ECL.Language.Spawn.ChooseID, '<%donttouch%>', 'Plant'); local tab = {Color(255,165,0,255), ECL.Language.Spawn.ECL..[[ - ]], Color(255,255,255), [[]]..text..[[]] } chat.AddText(unpack(tab))");
                return;
            end;
		
			if file.Exists( "jb/ecl_plants/"..string.lower(game.GetMap()).."/ecl_plant_".. fileNpcName ..".txt", "DATA") then
				ply:SendLua("local text = string.Replace(ECL.Language.Spawn.AlreadyInUseID, '<%donttouch%>', '"..fileNpcName.."'); local tab = {Color(255,165,0,255), ECL.Language.Spawn.ECL..[[ - ]], Color(255,255,255), [[]]..text..[[]] } chat.AddText(unpack(tab))");
				return;
			end;
				
			local vect = ply:GetEyeTrace().HitPos;	   
		    if (ECL.CustomModels) and (ECL.CustomModels.Plant) then
		        vect = ply:GetEyeTrace().HitPos + Vector(0,0,10);
		    end;
			local npcVector = string.Explode(" ", tostring(vect));
			local npcAngles = string.Explode(" ", tostring(ply:GetAngles()+Angle(0, -180, 0)));
					
			local npc = ents.Create("ecl_plant");
			npc:SetPos(vect);
			npc:SetAngles(ply:GetAngles()+Angle(0, -180, 0));
			npc:Spawn();
			if (ECL.CustomModels) and (ECL.CustomModels.Plant) then 
			    npc:SetModel("models/srcocainelab/cocaplant_nopot.mdl");
			    npc:SetBodygroup(1, 2)
			end;
			npc:SetMoveType(MOVETYPE_NONE)
					
			file.Write("jb/ecl_plants/"..string.lower(game.GetMap()).."/ecl_plant_".. fileNpcName ..".txt", ""..(npcVector[1]).." "..(npcVector[2]).." "..(npcVector[3]).." "..(npcAngles[1]).." "..(npcAngles[2]).." "..(npcAngles[3]).."", "DATA");
			ply:SendLua("local text = string.Replace(ECL.Language.Spawn.NewPosSet, '<%donttouch%>', 'Plant'); local tab = {Color(255,165,0,255), ECL.Language.Spawn.ECL..[[ - ]], Color(255,255,255), [[]]..text..[[]] } chat.AddText(unpack(tab))");
			if ECL.Logs and ECL.Logs.Enabled then 
			    local nick = ply:Nick();
			    ECL:Log(nick.." has set spawn of plant. ID: "..args[1])
			end;
		else
			ply:SendLua("local tab = {Color(255,165,0,255), ECL.Language.Spawn.ECL..[[ - ]], Color(255,255,255), [[]]..ECL.Language.Spawn.OnlyAdmins..[[]] } chat.AddText(unpack(tab))");
		end;
end;

	concommand.Add("ecl_plant_spawn", spawnPlantPos);

	local function spawnNpcPos(ply, cmd, args)
		if (ply:IsAdmin() or ply:IsSuperAdmin()) then
			local fileNpcName = args[1];
               
            if !fileNpcName then
                ply:SendLua("local text = string.Replace(ECL.Language.Spawn.ChooseID, '<%donttouch%>', 'NPC'); local tab = {Color(255,165,0,255), ECL.Language.Spawn.ECL..[[ - ]], Color(255,255,255), [[]]..text..[[]] } chat.AddText(unpack(tab))");
                return;
            end;
		
			if file.Exists( "jb/ecl/"..string.lower(game.GetMap()).."/ecl_npc_".. fileNpcName ..".txt", "DATA") then
				ply:SendLua("local text = string.Replace(ECL.Language.Spawn.AlreadyInUseID, '<%donttouch%>', '"..fileNpcName.."'); local tab = {Color(255,165,0,255), ECL.Language.Spawn.ECL..[[ - ]], Color(255,255,255), [[]]..text..[[]] } chat.AddText(unpack(tab))");
				return;
			end;
				   
			local npcVector = string.Explode(" ", tostring(ply:GetEyeTrace().HitPos));
			local npcAngles = string.Explode(" ", tostring(ply:GetAngles()+Angle(0, -180, 0)));
					
			local npc = ents.Create("ecl_npc");
			npc:SetPos(ply:GetEyeTrace().HitPos);
			npc:SetAngles(ply:GetAngles()+Angle(0, -180, 0));
			npc:Spawn();
			npc:SetMoveType(MOVETYPE_NONE)
					
			file.Write("jb/ecl/"..string.lower(game.GetMap()).."/ecl_npc_".. fileNpcName ..".txt", ""..(npcVector[1]).." "..(npcVector[2]).." "..(npcVector[3]).." "..(npcAngles[1]).." "..(npcAngles[2]).." "..(npcAngles[3]).."", "DATA");
			ply:SendLua("local text = string.Replace(ECL.Language.Spawn.NewPosSet, '<%donttouch%>', 'NPC'); local tab = {Color(255,165,0,255), ECL.Language.Spawn.ECL..[[ - ]], Color(255,255,255), [[]]..text..[[]] } chat.AddText(unpack(tab))");
			if ECL.Logs and ECL.Logs.Enabled then
			    local nick = ply:Nick();
			    ECL:Log(nick.." has set spawn of NPC. ID: "..args[1])
		    end;
		else
			ply:SendLua("local tab = {Color(255,165,0,255), ECL.Language.Spawn.ECL..[[ - ]], Color(255,255,255), [[]]..ECL.Language.Spawn.OnlyAdmins..[[]] } chat.AddText(unpack(tab))");
		end;
	end;
	concommand.Add("ecl_npc_spawn", spawnNpcPos);
	
	local function saveECLSpawns(ply, cmd, args)
		if (ply:IsAdmin() or ply:IsSuperAdmin()) then
			for k, v in pairs(file.Find("jb/ecl/"..string.lower(game.GetMap()).."/*.txt", "DATA")) do
				file.Delete("jb/ecl/"..string.lower(game.GetMap()).."/"..v);
			end;

			for k, v in pairs(file.Find("jb/ecl_plants/"..string.lower(game.GetMap()).."/*.txt", "DATA")) do
				file.Delete("jb/ecl_plants/"..string.lower(game.GetMap()).."/"..v);
			end;

			local pinc = 0;
			local plants = ents.FindByClass("ecl_plant")
			for k, v in pairs(plants) do 
				local fileNpcName = pinc;
				local npcVector = string.Explode(" ", tostring(v:GetPos()));
				if (ECL.CustomModels) and (ECL.CustomModels.Plant) then
				    npcVector = string.Explode(" ", tostring(v:GetPos()+Vector(0,0,10)));
				end;
				local npcAngles = string.Explode(" ", tostring(v:GetAngles()));
				pinc = pinc + 1;

				file.Write("jb/ecl_plants/"..string.lower(game.GetMap()).."/ecl_plant_".. fileNpcName ..".txt", ""..(npcVector[1]).." "..(npcVector[2]).." "..(npcVector[3]).." "..(npcAngles[1]).." "..(npcAngles[2]).." "..(npcAngles[3]).."", "DATA");
			end;

			local pnpc = 0;
			local npcs = ents.FindByClass("ecl_npc")
			for k, v in pairs(npcs) do
				local fileNpcName = pnpc;
				local npcVector = string.Explode(" ", tostring(v:GetPos()));
				local npcAngles = string.Explode(" ", tostring(v:GetAngles()));
				pnpc = pnpc + 1;

				file.Write("jb/ecl/"..string.lower(game.GetMap()).."/ecl_npc_".. fileNpcName ..".txt", ""..(npcVector[1]).." "..(npcVector[2]).." "..(npcVector[3]).." "..(npcAngles[1]).." "..(npcAngles[2]).." "..(npcAngles[3]).."", "DATA");
			end

			local nick = ply:Nick()
			local savedNPC = table.Count(file.Find("jb/ecl/"..string.lower(game.GetMap()).."/*.txt", "DATA"));
			local savedPlants = table.Count(file.Find("jb/ecl_plants/"..string.lower(game.GetMap()).."/*.txt", "DATA"))
			local count = savedNPC + savedPlants;

			ply:SendLua("local tab = {Color(255,165,0,255), ECL.Language.Spawn.ECL..[[ - ]], Color(255,255,255), [[Spawnpoints have been successfully saved.]] } chat.AddText(unpack(tab))");
			if ECL.Logs and ECL.Logs.Enabled then
			    ECL:Log(nick.." has saved spawnposes for entities. Count of spawnposes: "..count)
		    end;
		else
			ply:SendLua("local tab = {Color(255,165,0,255), ECL.Language.Spawn.ECL..[[ - ]], Color(255,255,255), [[]]..ECL.Language.Spawn.OnlyAdmins..[[]] } chat.AddText(unpack(tab))");                       
		end;
	end;
	concommand.Add("ecl_save_spawns", saveECLSpawns);

	local function removePlantPos(ply, cmd, args)
		if (ply:IsAdmin() or ply:IsSuperAdmin()) then
			local fileNpcName = args[1];
				   
			if !fileNpcName then
				ply:SendLua("local tab = {Color(255,165,0,255), ECL.Language.Spawn.ECL..[[ - ]], Color(255,255,255), [[]]..ECL.Language.Spawn.EnterUniqueID..[[]] } chat.AddText(unpack(tab))");
				return;
			end;
					   
			if file.Exists("jb/ecl_plants/"..string.lower(game.GetMap()).."/ecl_plant_"..fileNpcName..".txt", "DATA") then
				local nick = ply:Nick()
				ECL:Log(nick.." has removed spawn of plant. ID: "..args[1])
				file.Delete("jb/ecl_plants/"..string.lower(game.GetMap()).."/ecl_plant_"..fileNpcName..".txt");
				ply:SendLua("local text = string.Replace(ECL.Language.Spawn.Remove, '<%donttouch%>', 'Plant'); local tab = {Color(255,165,0,255), ECL.Language.Spawn.ECL..[[ - ]], Color(255,255,255), [[]]..text..[[]] } chat.AddText(unpack(tab))");
				return;
			end;
				   
		else
			ply:SendLua("local tab = {Color(255,165,0,255), ECL.Language.Spawn.ECL..[[ - ]], Color(255,255,255), [[]]..ECL.Language.Spawn.OnlyAdmins..[[]] } chat.AddText(unpack(tab))");                       
		end;
	end;
	concommand.Add("ecl_plant_remove", removePlantPos);
end