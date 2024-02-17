local CATEGORY_NAME = "JailRoom"

if SERVER then
    util.AddNetworkString("ulxTakeJailInfo")
    util.AddNetworkString("ulxTakeUnJailInfo")
end

-- Позиция где человека будет кидать в джайл
local jailPos = Vector(-4450.176270, 5917.729004, 50.639374)
-- Работу которую он будет менять когда его будут кидать в джайл
local jailTeam = TEAM_CITIZEN

local function sendJail(ply, targets, seconds, reason, unjail)
    if #targets <= 2 then
        for i = 1, #targets do
            local v = targets[i]
            if unjail == false then
                timer.Simple(1, function()
                    JailRoom(v, reason, seconds)
                    local str = unjail and "#A разджайлил #T" or "#A заджайлил #T на #i секунд" .. (reason == " " and "." or ". Причина: #s.")
                    ulx.fancyLogAdmin(ply, str, targets, seconds, reason)
                end)
            else
                ulx.fancyLogAdmin(ply, "#A разджайлил #T", targets)
                UnJail(v)
            end
        end
    else
        ply:ChatPrint("Вы попытались затронуть несколько людей, будьте осторожны!")
    end
end

-- Команда ulx jail
local function ulxJailroomCmd(ply, target, seconds, reason, unjail)
    sendJail(ply, target, seconds, reason, unjail)
end
local jailroom = ulx.command(CATEGORY_NAME, "ulx jailroom", ulxJailroomCmd, "!jailroom")
jailroom:addParam{ type = ULib.cmds.PlayersArg }
jailroom:addParam{ type = ULib.cmds.NumArg, min = 0, default = 0, hint = "Секунды", ULib.cmds.round, ULib.cmds.optional }
jailroom:addParam{ type = ULib.cmds.StringArg, hint = "Причина", ULib.cmds.optional, ULib.cmds.takeRestOfLine }
jailroom:addParam{ type = ULib.cmds.BoolArg, invisible = true }
jailroom:defaultAccess(ULib.ACCESS_ADMIN)
jailroom:setOpposite("ulx unjailroom", { _, _, _, _, true }, "!unjailroom")

function JailRoom(ply, reason, seconds, after_relog)
	
	if ply.jailed == true then return end
	ply.__switchTeam = false
	ply.LastPos = ply:GetPos()
	ply.jailed = true
	ply.timer = seconds
	ply.jail_reason = reason

	ply:SetPos(jailPos)
	timer.Simple(1,function ()
		if not (ply:Team() == jailTeam) then
			ply:changeTeam(jailTeam, true)
			ply:Spawn()
			ply:SetPos(jailPos)
			timer.Simple(1,function ()
				ply.__switchTeam = true
			end)
		end
		ply:SetMoveType(MOVETYPE_WALK)
	end)
	
	timer.Simple(1,function ()
		ply:GodEnable()
	end)
	
	ply:StripWeapons()
	if timer.Exists(ply:UniqueID().."ulxJailTimer") then
		timer.Remove(ply:UniqueID().."ulxJailTimer")
	end
	net.Start("ulxTakeJailInfo")
		net.WriteBool(true)
		net.WriteFloat(seconds)
		net.WriteFloat(CurTime())
		net.WriteString(reason)
	net.Send(ply)
	timer.Create(ply:UniqueID().."ulxJailTimer",seconds,1,function ()
		if ply:IsValid() and after_relog == true then
			UnJail(ply, true)
			elseif ply:IsValid() then
			UnJail(ply)
		end
	end)
end

function UnJail(ply, after_relog)
	if ply.jailed == true then
		if after_relog == true then
			ply.jailed = false
			ply.LastPos = nil
		else
			ply.jailed = false
			ply.LastPos = nil
		end

		hook.Run("ulxPlayerUnjailed", ply)
	end
	
		timer.Remove(ply:UniqueID().."ulxJailTimer")
		net.Start("ulxTakeUnJailInfo")
		net.Send(ply)
		timer.Simple(5,function ()
			ply:Spawn()
			ply:GodDisable()
			ply:ChatPrint("Ваше наказание закончилось!")
		end)
		
	end

	
hook.Add("OnPlayerChangedTeam", "ulxForceJailAfterJobChange", function (ply, oldTeam, newTeam)
    if ply.jailed == true then
        timer.Simple(0.1, function ()
            ply:SetPos(jailPos)
        end)
    end
end)

hook.Add("PlayerSpawn","ulxSpawnInJailIfDead",function (ply)
	if ply.jailed == true then
		timer.Simple(1,function ()
			ply:SetPos(jailPos)
		end)
	end
end)

hook.Add("CanPlayerSuicide","ulxSuicedeCheck",function (ply)
	if ply.jailed == true then
		return false
	end
end)

hook.Add("canBuyCustomEntity", "ulxBlockEntityPurchaseInJail", function(ply)
    if ply.jailed == true then
        return false, "Вы не можете покупать предметы, пока находитесь в тюрьме!"
    end
end)

hook.Add("canBuyAmmo", "ulxBlockAmmoPurchaseInJail", function(ply)
	if ply.jailed == true then
		return false, "Вы не можете покупать боеприпасы, пока находитесь в тюрьме!"
	end
end)
	
hook.Add("canBuyShipment", "ulxBlockShipmentPurchaseInJail", function(ply)
	if ply.jailed == true then
		return false, "Вы не можете покупать оружие, пока находитесь в тюрьме!"
	end
end)
	
hook.Add("canBuyPistol", "ulxBlockPistolPurchaseInJail", function(ply)
	if ply.jailed == true then
		return false, "Вы не можете покупать пистолеты, пока находитесь в тюрьме!"
	end
end)
	
hook.Add("canBuyVehicle", "ulxBlockVehiclePurchaseInJail", function(ply)
	if ply.jailed == true then
		return false, "Вы не можете покупать транспортные средства, пока находитесь в тюрьме!"
	end
end)

hook.Add("EntityTakeDamage", "ulxNoDamageInJail", function(target, dmgInfo)
	if target:IsPlayer() and target.jailed == true then
		return true
	end
end)
	
hook.Add("playerCanChangeTeam", "ulxBlockJobSwitchInJail", function(ply)
	if ply.__switchTeam == true then
		if ply.jailed == true then
			return false, "Вы не можете сменить профессию, пока находитесь в тюрьме!"
		end
	end
end)

hook.Add("PlayerSpawnSWEP", "ulxNoSpawnSWEPsInJail", function(ply)
    if ply.jailed == true then
        return false
    end
end)

hook.Add("PlayerSpawnVehicle", "ulxNoSpawnVehiclesInJail", function(ply)
    if ply.jailed == true then
        return false
    end
end)

hook.Add("CanOwnDoor", "ulxNoPurchaseDoorsInJail", function(ply)
    if ply.jailed == true then
        return false
    end
end)

hook.Add("PlayerSpawnProp","ulxBlockSpawnIfInJail",function (ply)
	if ply.jailed == true then
		return false
	end
end)

hook.Add("PlayerCanPickupWeapon","ulxJailPickUpWeapon",function (ply)
	if ply.jailed == true then
		return false
	end
end)

hook.Add("PlayerCanPickupItem","ulxPickUpRest",function (ply)
	if ply.jailed == true then
		return false
	end
end)

hook.Add("OnSpawnMenuOpen", "ulxDisableSpawnMenuInJail", function()
    if LocalPlayer().jailed == true then
        return false
    end
end)

-- Запретить No-Clip в jail:
hook.Add("PlayerNoClip", "ulxJailDisableNoclip", function(ply, desiredState)
    if ply.jailed == true then
        return false
    end
end)

if CLIENT then	
	surface.CreateFont( "DisplayJailTimer", {
		font = "Roboto",
		size = (ScrH() + ScrW()) * .011,
		weight = 1000, 
		blursize = 0, 
		scanlines = 0, 
		antialias = true,
		extended = true,
	} )

	local jailed = false
	local jail_timer = 0
	local jail_curtime = 0
	local jail_reason = 'Error!'
	net.Receive("ulxTakeJailInfo", function(len, pl)
    jailed = net.ReadBool()
    jail_timer = net.ReadFloat()
    jail_curtime = net.ReadFloat()
    jail_reason = net.ReadString()

    hook.Add("HUDPaint", "ulxPaintJailInfo", function()
        if jailed and math.Round((jail_curtime + jail_timer) - CurTime()) > 0 then
            local text1 = 'Вы забанены! Причина: ' .. jail_reason .. '.'
            local text2 = 'Осталось: ' .. math.Round((jail_curtime + jail_timer) - CurTime()) .. ' секунд.'

            surface.SetFont("DisplayJailTimer")
            local w1, h1 = surface.GetTextSize(text1)
            local w2, h2 = surface.GetTextSize(text2)

            local x, y = ScrW() / 2, ScrH() / 3

            draw.SimpleText(text1, "DisplayJailTimer", x, y - h1 / 2, Color(255, 255, 255), 1, 0)
            draw.SimpleText(text2, "DisplayJailTimer", x, y + h1 / 2 + 2, Color(255, 255, 255), 1, 0)
        	end
    	end)
	end)

	net.Receive("ulxTakeUnJailInfo",function( len, pl )
		jailed = false
		jail_timer = 0
		jail_curtime = 0
		jail_reason = 'error!'
		hook.Remove("HUDPaint","ulxPaintJailInfo")
	end)
end

if SERVER then
	hook.Add("OnGamemodeLoaded","ulxDataLoad",function ()
		sql.Query("CREATE TABLE IF NOT EXISTS jailed(steamid VARCHAR(20) PRIMARY KEY, time BIGINT)")
	end)
	
	hook.Add("PlayerInitialSpawn","ulxDataLoadToPlayer",function (ply)
		if ply:IsValid() then
			local query = sql.Query("SELECT * FROM jailed WHERE steamid = "..sql.SQLStr(ply:SteamID()))
			if query then
				JailRoom(ply, "Вы вышли с сервера.", query[1]['time'], true)
				sql.Query("DELETE FROM jailed WHERE steamid = '"..ply:SteamID().."'")
				timer.Simple(5,function ()
					ply:GodEnable()
					ply:ChatPrint("Вы вышли с сервера во время действующего наказания. Вы возвращены в комнату наказаний.")
				end)
			end
		end
	end)
			
	hook.Add("PlayerDisconnected","ulxColumntIfNeed",function (ply)
		if ply.jailed == true then
			sql.Query( "INSERT INTO jailed ( steamid, time ) VALUES ( '" .. ply:SteamID() .. "', '"..ply.timer.."' )" )
				DarkRP.notifyAll(0,4,ply:Nick().." вышел с сервера во время наказания.")
		end
	end)
end

hook.Add("PlayerSpawnSENT", "ulxNoSpawnPropsInJail", function(ply)
    if ply.jailed == true then
        return false
    end
end)