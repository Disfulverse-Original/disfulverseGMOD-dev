--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

util.AddNetworkString("Numerix_Open_Menu_Intro")
util.AddNetworkString("Numerix_Start_Intro")
util.AddNetworkString("Numerix_Start_Intro_Menu")
util.AddNetworkString("Numerix_Intro_Start_Stop")

hook.Add("PlayerInitialSpawn", "Numerix_Open_Menu_Intro2", function(ply)
    if not file.Exists("numerix_intro/"..game.GetMap().."/player/"..ply:SteamID64()..".txt", "DATA") or Intro.Settings.AlwaysShow then
        net.Start("Numerix_Open_Menu_Intro")
        net.Send(ply)
    end
end)

hook.Add("PlayerSay", "Numerix_Commande_Start_Intro", function(ply, text)
    if string.sub(text, 1, string.len(Intro.Settings.Commande)) == Intro.Settings.Commande and Intro.Settings.Commande != "" then
        if ply:Alive() then
            StartIntro(ply, true)
        end
        return ""
    end
end)

net.Receive("Numerix_Start_Intro_Menu", function(len, ply)
    if ply:IsValid() and ply:Alive() then
        StartIntro(ply, false)
        ply.InIntro = true
    end
end)

net.Receive("Numerix_Intro_Start_Stop", function(len, ply)
    local start = net.ReadBool()
    
    if ply:IsValid() and ply:Alive() then
        if start then
            StartIntro(ply, false)
            ply.InIntro = true
        else
            StopIntro(ply)
        end
    end
end)


function StartIntro(ply, command)
    if !ply.InIntro then
        ply.Weapons = {}
        
        for k, v in pairs(ply:GetWeapons()) do
            table.insert(ply.Weapons, v:GetClass())
            ply:StripWeapon(v:GetClass())
        end
    
        if command then
            net.Start("Numerix_Start_Intro")
            net.Send(ply)   
        end
    end
end

function StopIntro(ply)
    if ply.InIntro then
        for k, v in pairs(ply.Weapons) do
            ply:Give(v)
        end

        ply:GodDisable()

        ply.InIntro = false

        if not file.Exists("numerix_intro/"..game.GetMap().."/player/"..ply:SteamID64()..".txt", "DATA") then
            file.Write("numerix_intro/"..game.GetMap().."/player/"..ply:SteamID64()..".txt", "true")
        end
    end
end

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
