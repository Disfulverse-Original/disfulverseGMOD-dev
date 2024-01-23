function DarkRP.DoTRYtalkToPerson(receiver, col1, text1, col2, text2, sender)
    net.Start("DarkRP_Chat")
        net.WriteUInt(255, 8)
        net.WriteUInt(255, 8)
        net.WriteUInt(0 , 8)
        net.WriteString(text1)

        sender = sender or Entity(0)
        net.WriteEntity(sender)

        col2 = col2 or Color(0, 0, 0)
        net.WriteUInt(255, 8)
        net.WriteUInt(255, 8)
        net.WriteUInt(0, 8)
        net.WriteString(text2 or "")
    net.Send(receiver)
end

function DarkRP.DoTRYtalkToRange(ply, PlayerName, Message, size)
    local ents = ents.FindInSphere(ply:EyePos(), size)
    local col = team.GetColor(ply:Team())
    local filter = {}

    for _, v in ipairs(ents) do
        if v:IsPlayer() then
            table.insert(filter, v)
        end
    end

    if PlayerName == ply:Nick() then PlayerName = "" end -- If it's just normal chat, why not cut down on networking and get the name on the client

    net.Start("DarkRP_Chat")
        net.WriteUInt(255, 8) --R
        net.WriteUInt(255, 8) --G
        net.WriteUInt(0, 8)   --B
        net.WriteString(PlayerName)
        net.WriteEntity(ply)
        net.WriteUInt(255, 8)
        net.WriteUInt(255, 8)
        net.WriteUInt(255, 8)
        net.WriteString(Message)
    net.Send(filter)
end

local function TryME(ply, args)
    if args == "" then
        DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", "argument", ""))
        return ""
    end

    local DoSay = function(text)
        if text == "" then
            DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", "argument", ""))
            return ""
        end
        local dice = math.random( 1, 2 )
        local tbl = {}
        tbl[1] = "Удачно"
        tbl[2] = "Неудачно"
        if GAMEMODE.Config.alltalk then
            local col = team.GetColor(ply:Team())
            local name = ply:Nick()
            for _, target in ipairs(player.GetAll()) do
                DarkRP.DoTRYtalkToPerson(target, team.GetColor(ply:Team()), conf.tchatmsg ..  text .. " " .. name)
            end
        else
            DarkRP.DoTRYtalkToRange(ply,ply:Nick() .. " | " .. text .. " | " .. tbl[dice], "", GAMEMODE.Config.meDistance)
        end
    end
    return args, DoSay
end
DarkRP.defineChatCommand("try", TryME, 1.5)


--Анонсируем наши новые команды в список игрового режима.
DarkRP.declareChatCommand({
	command = "try",
	description = "Использует рандомные варианты значений из серии 'успешно' или 'не успешно'",
	delay = 1.5
})