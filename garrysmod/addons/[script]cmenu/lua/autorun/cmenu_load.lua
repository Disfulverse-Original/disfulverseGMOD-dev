	PIS = {}

	local function Load()
		if not Nexus or not Nexus.Loader then
			print("[CMENU] ERROR: Nexus framework not found")
			return
		end
		
		local loader = Nexus:Loader()
		if not loader then
			print("[CMENU] ERROR: Failed to create Nexus loader")
			return
		end
		
		loader:SetName("CMenu")
		loader:SetColor(Color(48, 100, 255))
		loader:SetAcronym("PIS")
		loader:RegisterAcronym()
		loader:SetLoadDirectory("infl_cmenu")
		loader:Load("config", "SHARED", true)
		loader:Load("core", "SHARED", true)
		loader:Load("vgui", "CLIENT", true)
		loader:Load("misc", "SHARED", true)
		loader:Load("gamemodes", "SHARED", true)

		if PIS.Gamemodes then
			for i, v in pairs(PIS.Gamemodes) do
				if v and v.GetDetectionCondition and v:GetDetectionCondition() then
					PIS.Gamemode = v
					break
				end
			end

			if (!PIS.Gamemode) then
				for i, v in pairs(PIS.Gamemodes) do
					if v and v.GetID and v:GetID() == "backup" then
						PIS.Gamemode = v
						break
					end
				end
			end
		else
			print("[CMENU] ERROR: PIS.Gamemodes not found")
		end

		loader:Register()
	end

	if (Nexus) then 
		Load()
	else 
		hook.Add("Nexus.PostLoaded", "CMenu", Load) 
	end
