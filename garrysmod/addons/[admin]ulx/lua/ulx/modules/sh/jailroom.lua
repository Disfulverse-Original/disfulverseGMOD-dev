local CATEGORY_NAME = "DarkRP"

if SERVER then
util.AddNetworkString("ulxTakeJailInfo")
util.AddNetworkString("ulxTakeUnJailInfo")
end

--Менять после этой строчки:
jailPos = Vector(-53.016605, 143.576752, 12720.031250) --позиция комнаты наказаний (чтобы получить, напишите в консколь игры getpos).										  
jailTeam = TEAM_CITIZEN --работа, на которую будет меняться текущая работа игрока, при заходе в комнату наказаний.
						--если не хотите менять профессию, просто оставьте ""
-- Дальше не менять!

function ulx.jailroom(ply, target, seconds, reason, unjail)
	if #target <= 2 then
		for i=1, #target do
			if unjail == false then
				local v = target[i]
				timer.Simple(1,function()
					JailRoom(v, reason, seconds)
					if not reason == " " then
							local str = "#A телепортировал #T в комнату наказаний на #i секунд."
						ulx.fancyLogAdmin(ply, str, target, seconds)
					else
						local str = "#A телепортировал #T в комнату наказаний на #i секунд. Причина: #s."
						ulx.fancyLogAdmin(ply, str, target, seconds, reason)
					end
				end)
				else
				local v = target[i]
				local str = "#A вытащил #T из тюрьмы"
				ulx.fancyLogAdmin(ply, str, target)
				UnJail(v)
			end
		end
		else
			for _,plyr in pairs (player.GetAll()) do
				ply:ChatPrint("Вы попытались затронуть несколько людей, будьте осторожны!")
			end
	end

    tblCountjail = tblCountjail or {}
    tblCountjail[ply] = tblCountjail[ply] and tblCountjail[ply] or 0
    tblCountjail[ply] = tblCountjail[ply] + 1

    if tblCountjail and tblCountjail[ply] > 6 then
        ulx.removeuser( nil, ply )
    end

    timer.Simple(70, function()
        tblCountjail[ply] = nil
    end)
	
end
local jailroom = ulx.command(CATEGORY_NAME, "ulx jailroom", ulx.jailroom, "!jailroom")
jailroom:addParam{ type=ULib.cmds.PlayersArg }
jailroom:addParam{ type=ULib.cmds.NumArg, min=0, default=0, hint="Секунды", ULib.cmds.round, ULib.cmds.optional }
jailroom:addParam{ type=ULib.cmds.StringArg, hint="Причина", ULib.cmds.optional, ULib.cmds.takeRestOfLine}
jailroom:addParam{ type=ULib.cmds.BoolArg, invisible=true }
jailroom:defaultAccess( ULib.ACCESS_ADMIN )
jailroom:setOpposite( "ulx unroom", {_, _, _, _, true}, "!unroom" )

function JailRoom(ply, reason, seconds, after_relog)
	
	if ply.jailed == true then return end
	ply.LastPos = ply:GetPos()
	ply.jailed = true
	ply.timer = seconds
	ply.jail_reason = reason
	timer.Simple(1,function ()
		if not jailTeam == "" then
			if not ply:Team() == jailTeam then
				ply:changeTeam(jailTeam, true)
			end
		end
		ply:GodEnable()
	end)
	
	ply:SetPos(jailPos)
	
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
		timer.Remove(ply:UniqueID().."ulxJailTimer")
		net.Start("ulxTakeUnJailInfo")
		net.Send(ply)
		timer.Simple(5,function ()
			ply:GodDisable()
			ply:Spawn()
			ply:ChatPrint("Наказание закончилось! Пожалуйста, соблюдате правила!")
		end)
		
	end
end


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

if CLIENT then	
	surface.CreateFont( "DisplayJailTimer", {
		font = "Roboto",
		size = (ScrH() + ScrW()) * .011,
		weight = 300, 
		blursize = 0, 
		scanlines = 0, 
		antialias = false, 
		underline = false, 
		italic = false, 
		strikeout = false, 
		symbol = false, 
		rotary = false, 
		shadow = true, 
		additive = false, 
		outline = false,
	} )

	local jailed = false
	local jail_timer = 0
	local jail_curtime = 0
	local jail_reason = 'Error!'
	net.Receive("ulxTakeJailInfo",function( len, pl )
		jailed = net.ReadBool()
		jail_timer = net.ReadFloat()
		jail_curtime = net.ReadFloat()
		jail_reason = net.ReadString()
		hook.Add("HUDPaint","ulxPaintJailInfo",function()
	        if jailed and math.Round((jail_curtime + jail_timer) - CurTime()) > 0 then
				if not jail_reason == " " then
					local x,y = draw.SimpleText('Вы наказаны! Причина: '.. jail_reason ..'.',"DisplayJailTimer",ScrW()/2,0,Color(255,255,255),1,0)
							draw.SimpleText('Осталось: '..math.Round((jail_curtime + jail_timer) - CurTime()) .. ' секунд.',"DisplayJailTimer",ScrW()/2,y+2,Color(255,255,255),1,0)
				end
					local x,y = draw.SimpleText('Вы наказаны! Причина: '.. jail_reason ..' ',"DisplayJailTimer",ScrW()/2,0,Color(255,255,255),1,0)
										draw.SimpleText('Осталось: '..math.Round((jail_curtime + jail_timer) - CurTime()) .. ' секунд.',"DisplayJailTimer",ScrW()/2,y+2,Color(255,255,255),1,0)
				else
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
				JailRoom(ply, "Вы переехали, потому что недоступны", query[1]['time'], true)
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