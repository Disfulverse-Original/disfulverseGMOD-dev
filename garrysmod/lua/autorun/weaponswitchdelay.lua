-- SETTINGS

-- Time to equip the weapon in seconds.
local EquipTime = 1.5

-- Show the count down timer next to the progress bar.
local ShowCountdownTimer = true
-- How many decimals you want to show (default = 2 so it will be this: 1.59)
local CountdownTimerDecimals = 1.5

-- View model when player is switching weapons.
local ShouldViewModel = true
-- If ShouldViewModel is true then it will show this model.
local WeaponSwitchModel = "models/weapons/w_defuser.mdl"

-- Key to cancel the switching. If you want to disable this change it to nil.
local SwitchingCancelKey = IN_RELOAD
-- First reload will tell the player how to cancel the switching, this will need a name. To disable this change it to nil.
local SwitchingCancelKeyName = "Reload"

-- Allow the player to switch to a white listed weapon while switching. (This will not stop the switching to the other weapon)
local CanSwitchToWsWhileSwitching = false

-- Send a chat message to the player when the weapon is switched.
local EnableSendChatMessage = true
local function SendChatMessage( ply, weaponName )
	-- If you do not know what this does, leave it as it is.
	-- Feel free to change this to anything you'd like.
	-- Server side, so make sure to use server sided stuff only.
	
	if DarkRP then
		ply:ConCommand( "say /me достал " .. weaponName .. "!" )
	else
		ply:ChatPrint( "Сменил на " .. weaponName .. "!" )
	end
	
end

-- This is a temporary fix for the FAS weapons.
-- Only use this if you really need to.
local FAS_Temp_Fix = false

-- Weapons that will skip the timer.
local Whitelist = {
	""
}

local DifferentTimeWeapons = {
	-- Weapon, Changed time (This value will override the default time)
	-- Make sure the weapon is not white listed.
	{"EXAMPLEWEAPON1", 10},
	{"EXAMPLEWEAPON2", 3}
}

local ReducedTimeGroups = {
	-- Group, Reduced time (e.g. 0.5 makes it half the normal time, Reduced time times the normal time)
	-- This will also reduce the time of different time weapons.
	{"EXAMPLEGROUP1", 2},
	{"superadmin", 0.2}
}

-- Color of the text.
local TextColor = Color(255, 255, 255, 255)

-- Change the color of the text to black or white depending on the pixel color of the screen.
-- This lags a lot, so do not enable this.
local ChangeColorText = false

-- Size of the delay bar.
local barWidth = 200
local barHeight = 6

-- If you find any bugs or encounter any problems feel free to contact me.
-- http://steamcommunity.com/id/ikefi

-- END OF SETTINGS

local WeaponSwitch = {}

if SERVER then

	local function GetEquipTime(ply, NewWeapon)
		
		local NewEquipTime = EquipTime
	
		for _, weapon in pairs(DifferentTimeWeapons) do
			if NewWeapon:GetClass() == weapon[1] then
				NewEquipTime = weapon[2]
			end
		end
		
		for _, group in pairs(ReducedTimeGroups) do
			if group[1] == ply:GetUserGroup() then
				return NewEquipTime * group[2]
			end
		end
		
		return NewEquipTime
	end

	util.AddNetworkString("WepSwitch_EnableSwitch")
	util.AddNetworkString("WepSwitch_DisableSwitch")
	util.AddNetworkString("WepSwitch_Switching")
	util.AddNetworkString("WepSwitch_EnableSwitch_received")
	util.AddNetworkString("WepSwitch_SendSwitchingPly")

	function WeaponSwitch:DelayEquip(ply, weapon, oldweapon)
	
		ply.IsSwitchingWeapons = true -- Player is switching weapon.
		ply.CantSwitch = true -- Player can't switch weapon now.
		ply.SwitchingToWeapon = weapon
		ply.SwitchingFromWeapon = oldweapon
		
		local NewEquipTime = GetEquipTime(ply, weapon)
		
		net.Start("WepSwitch_Switching")
			net.WriteString(weapon:GetClass())
			net.WriteString(tostring(NewEquipTime))
		net.Send(ply)
		
		if ShouldViewModel then
			net.Start("WepSwitch_SendSwitchingPly")
				net.WriteString(ply:SteamID())
				net.WriteBit(true)
			net.Broadcast()
		end
	
		timer.Create("Wep_Equip_Timer" .. ply:SteamID(), NewEquipTime, 1, function()
		
			if IsValid(ply) then
				
				if ShouldViewModel then
					net.Start("WepSwitch_SendSwitchingPly")
						net.WriteString(ply:SteamID())
						net.WriteBit(false)
					net.Broadcast()
				end
			
				net.Start("WepSwitch_EnableSwitch")
					if not IsValid(weapon) then
						-- Weapon doesn't exist anymore, tell the client to do nothing.
						net.WriteString("NULL")
						-- We want the player to be able to switch again ofcourse.
						ply.IsSwitchingWeapons = false
						ply.CantSwitch = false
					else
						-- Tell the client to enable weaponswitch.
					end
				net.Send(ply)
				
			end
			
		end)
	end
	
	net.Receive("WepSwitch_EnableSwitch_received", function(len, ply)
	
		ply.weaponName = net.ReadString() or ""

		-- Now switch the weapon.
		if IsValid(ply) and ply:Alive() then
			if IsValid(ply.SwitchingToWeapon) and ply:HasWeapon(ply.SwitchingToWeapon:GetClass()) then
				ply.CantSwitch = false
				ply:SelectWeapon(ply.SwitchingToWeapon:GetClass())
				
				--ply.SwitchingFromWeapon:CallOnClient("Holster", ply.SwitchingToWeapon)
				
				if FAS_Temp_Fix then
				
					ply.WepSwitchAttempts = 0
					
					local function HasSwitched()
					
						if ply.SwitchingToWeapon ~= ply:GetActiveWeapon() then
						
							ply.IsSwitchingWeapons = true
							ply.CantSwitch = true
							
							ply.WepSwitchAttempts = ply.WepSwitchAttempts + 1
						
							timer.Simple(0.02, function()
							
								ply.CantSwitch = false
									
								ply:SelectWeapon(ply.SwitchingToWeapon:GetClass())
							
								-- We don't want it to get stuck in an infinite loop.
								if ply.WepSwitchAttempts < 100 then
									HasSwitched()
								else
									ply.CantSwitch = false
									ply.IsSwitchingWeapons = false
									
									-- Tell client to disable CanSwitch
									net.Start("WepSwitch_DisableSwitch")
									net.Send(ply)
								end
								
							end)
							
						else

							-- Tell client to disable CanSwitch
							net.Start("WepSwitch_DisableSwitch")
							net.Send(ply)
						
						end
					
					end
					
					HasSwitched()
					
				else
				
					-- Tell client to disable CanSwitch
					net.Start("WepSwitch_DisableSwitch")
					net.Send(ply)
				
				end
			
			else
			
				-- Tell client to disable CanSwitch
				net.Start("WepSwitch_DisableSwitch")
				net.Send(ply)
				
			end
			
		else
		
			-- Tell client to disable CanSwitch
			net.Start("WepSwitch_DisableSwitch")
			net.Send(ply)
			
		end
		
	end)
	
	local function KeyPressed(ply, key)
		if key ~= SwitchingCancelKey then return end
		if ply.IsSwitchingWeapons then
		
			if timer.Exists("Wep_Equip_Timer" .. ply:SteamID()) then
				timer.Destroy("Wep_Equip_Timer" .. ply:SteamID())
			end
			
			ply.CantSwitch = false
			ply.IsSwitchingWeapons = false
		
			net.Start("WepSwitch_DisableSwitch")
			net.Send(ply)
			
			if ShouldViewModel then
				net.Start("WepSwitch_SendSwitchingPly")
					net.WriteString(ply:SteamID())
					net.WriteBit(false)
				net.Broadcast()
			end
			
		end
	end
	hook.Add("KeyPress", "WeaponSwitch_CancelSwitch", KeyPressed)
	
end

local CanSwitch, Switching, SwitchingToWeapon

if CLIENT then

	local NewEquipTime = EquipTime
	local TimerW = 0
	local FirstSwitch = true
	local WeaponName = ""

	CanSwitch, Switching = false, false
	SwitchingToWeapon = ""
	
	net.Receive("WepSwitch_Switching", function()
		SwitchingToWeapon = net.ReadString()
		NewEquipTime = tonumber(net.ReadString())
		
		-- Get the print name of the weapon.
		WeaponName = SwitchingToWeapon -- If there is no weapon found, just in case.
		for _, weapon in pairs(ents.FindByClass(SwitchingToWeapon)) do
			WeaponName = weapon:GetPrintName() or weapon.PrintName or WeaponName
		end
		if not WeaponName then
			WeaponName = "undefined"
		end
		
		Switching = true
		
		-- Reset the width of the timer bar.
		TimerW = 0
	end)

	net.Receive("WepSwitch_EnableSwitch", function()
		
		local weapon = net.ReadString()
		
		if weapon == "NULL" then
			CanSwitch = false
			Switching = false
			return
		end
		
		CanSwitch = true
		
		net.Start("WepSwitch_EnableSwitch_received")
			net.WriteString( WeaponName or "" )
		net.SendToServer()
	end)

	net.Receive("WepSwitch_DisableSwitch", function()
		CanSwitch = false
		Switching = false
		FirstSwitch = false
		
	end)
	
	net.Receive("WepSwitch_SendSwitchingPly", function()
		local SteamID = net.ReadString()
		local bool = net.ReadBit()
		
		for _, ply in pairs(player.GetAll()) do
			if ply:SteamID() == SteamID then
				if bool == 1 then
					ply.SwitchingWeapon = true
				else
					ply.SwitchingWeapon = false
				end
			end
		end
		
	end)
	
	local CanChangeColor = 1
	
	local function PaintTimer()
	
		if Switching then
		
			local bw = barWidth
			local bh = barHeight
		
			local mbw = (bw*TimerW)
		
			if TimerW < 1 then
				TimerW = TimerW + (FrameTime()/NewEquipTime)
			else
				TimerW = 1
			end
			
			draw.RoundedBox(0, (ScrW()/2)-(bw/2), (ScrH()/2) + 12, bw + 4, bh + 4, Color(0, 0, 0, 200))	
			draw.RoundedBox(0, (ScrW()/2)-(bw/2) + 2, (ScrH()/2) + 14, mbw, bh, Color(255, 255, 255, 80))
			
			-- Is there a way to change every pixel to the opposite color of the rendered pixel?? D:
			if ChangeColorText then
				render.CapturePixels()
				local ColorPixel = Color(render.ReadPixel((ScrW()/2), (ScrH()/2) + 20))
				
				if CanChangeColor < 1.1 then
					CanChangeColor = CanChangeColor + 0.05
				end
				
				if ColorPixel.r + ColorPixel.g + ColorPixel.b < 100 and CanChangeColor > 1 then
					TextColor = Color(255, 255, 255, 255)
					CanChangeColor = 0
				elseif CanChangeColor > 1 then
					TextColor = Color(0, 0, 0, 255)
					CanChangeColor = 0
				end
			end
			
			if ShowCountdownTimer then
				draw.SimpleText(math.Round(NewEquipTime - (TimerW*NewEquipTime), CountdownTimerDecimals), "Default", (ScrW()/2) + (bw/2) + 10, (ScrH()/2) + 10, TextColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
			end
			
			draw.SimpleText("Switching to " .. WeaponName, "Default", (ScrW()/2), (ScrH()/2) + bh + 18, TextColor, TEXT_ALIGN_CENTER)
			if SwitchingCancelKeyName and FirstSwitch then
				draw.SimpleText("Cancel by pressing " .. SwitchingCancelKeyName, "Default", (ScrW()/2), (ScrH()/2) + bh + 30, TextColor, TEXT_ALIGN_CENTER)
			end
		end
		
	end
	hook.Add("DrawOverlay", "WeaponSwitch_Paint", PaintTimer)
	
	local angle = Angle(0, 0, 0)
	
	local function DrawSwitching()
		if not ShouldViewModel then return end
		
		for _, ply in pairs(player.GetAll()) do
			
			if ply.SwitchingWeapon then
			
				local pos = ply:GetPos()
				
				if ply:Crouching() and ply:IsOnGround() then
					pos.z = pos.z + 65
				else
					pos.z = pos.z + 80
				end
				
				angle.yaw = angle.yaw + FrameTime()*150
				angle.roll = angle.roll + FrameTime()*150
				
				render.Model({model = WeaponSwitchModel, pos = pos, angle = angle})
			
			end
		
		end
		
	end
	hook.Add("PreDrawOpaqueRenderables", "WeaponSwitch_DrawSwitch", DrawSwitching)
	
end

local function IsWhitelisted(weapon)
	if table.HasValue(Whitelist, weapon:GetClass()) then return true end
	return false
end

local function OnWeaponSwitch(ply, old, new)

	if IsWhitelisted(new) then -- Skip the weapon switch.
		
		if not CanSwitchToWsWhileSwitching then
		
			if SERVER then
				
				if ply.IsSwitchingWeapons then
					return true
				end
				
			else
			
				if Switching then
					return true
				end
				
			end
		end
		
	else
	
		if SERVER then
			
			-- If player isn't switching these should both be false.
			if not ply.CantSwitch and not ply.IsSwitchingWeapons then
				WeaponSwitch:DelayEquip(ply, new, old)
			end

			-- Will be true after the timer succeeded, so we can switch the weapon.
			if not ply.CantSwitch then
			
				if EnableSendChatMessage then
					if ply.weaponName and ply.weaponName != "" then
						SendChatMessage( ply, ply.weaponName )
						ply.weaponName = ""
					end
				end
				
				ply.IsSwitchingWeapons = false
				return false
			else
				return true
			end
			
		else
		
			if not CanSwitch then
				return true
			end

			if SwitchingToWeapon == new:GetClass() then -- Should be, just to make sure.
				
				SwitchingToWeapon = ""
				CanSwitch = false
				return false
			else
				return true
			end
			
		end
	end
	
end
hook.Add("PlayerSwitchWeapon", "WeaponSwitch_Hook", OnWeaponSwitch)