-- This file is for defining custom punishment types. If you don't know what
-- your doing here, make a ticket and I'll help you out with whatever punishment
-- type you want. 
-- Repeat: This file is NOT for defining the actual punishments. That's in-game.
-- This is for the types of punishments, e.g kicking / banning.
-- Feel free to localize these to your local language too, as since they're a
-- customisable part of the addon they can't be.

YAWS.Punishments.Types = {}

-- Ban
YAWS.Punishments.Types['ban'] = {
    name = "Ban", -- The name of the punishment type.
    description = "Ban a player from the server.", -- The description of the punishment. Don't make this too long.
    params = { -- The parameters a admin can use for this.
        ['duration'] = {
            name = "Время",
            description = "Как долго должен длиться бан в часах.",
            type = "number",
            default = "1"
        },
        ['reason'] = {
            name = "Причина",
            description = "Причина бана.",
            type = "string",
            default = "Вы достигли предела предупреждений."
        },
    },
    -- The function to execute. This is where the punishment happens. Returning
    -- true means the punishment was successful. False means it failed, and will
    -- send a failed message to the admin/console.
    -- If it does end up failing, return two values: false, "The message"
    -- e.g return false, "This player is immune to being banned."
    -- Note: This is ran SERVERSIDE. targetSteamID is a SteamID64!
    action = function(admin, targetSteamID, params)
        if(ulx) then 
            ulx.banid(admin, util.SteamIDFrom64(targetSteamID), params.duration * 60, params.reason)
            return true
        end 
        if(sam) then 
            -- sam.player.ban_id(util.SteamIDFrom64(targetSteamID), (params.duration * 24) * 60, params.reason, admin:SteamID())
            -- function(ply, promise, length, reason)
            -- sam.Command.get("banid").OnExecute(util.SteamIDFrom64(targetSteamID), (params.duration * 24) * 60, params.reason)

            -- I WAS TOLD TO DO IT https://upload.livaco.dev/u/1gYParUlZ2.png
            RunConsoleCommand("sam", "banid", targetSteamID, (params.duration * 24) * 60, params.reason)
        end 
        if(xAdmin) then -- https://github.com/TheXYZNetwork/xAdmin not the bad one >:)
            local args = {
                targetSteamID,
                (params.duration * 24) * 60
            }
            local reason = string.Explode(params.reason, " ")
            for k, v in pairs(reason) do
                table.insert(args, v)
            end

            xAdmin.Commands['ban'].func(admin, args)
        end 
        
        return false, "Could not find a supported admin system to ban with."
    end 
}

-- Kick
YAWS.Punishments.Types['kick'] = {
    name = "Kick", -- The name of the punishment type.
    description = "Kicks a player from the server if they are online.", -- The description of the punishment. Don't make this too long.
    params = { -- The parameters a admin can use for this.
        ['reason'] = {
            name = "Reason",
            description = "The reason the target gets kicked.",
            type = "string",
            default = "You reached the warning limit."
        },
    },
    -- The function to execute. This is where the punishment happens. Returning
    -- true means the punishment was successful. False means it failed, and will
    -- send a failed message to the admin/console.
    -- If it does end up failing, return two values: false, "The message"
    -- e.g return false, "This player is immune to being banned."
    -- Note: This is ran SERVERSIDE. targetSteamID is a SteamID64!
    action = function(admin, targetSteamID, params)
        -- no admin mod support needed here
        local player = player.GetBySteamID64(targetSteamID)
        if(!player) then return false,"Player is not online." end
        
        player:Kick(params.reason)
        return true
    end 
}

-- Jail
YAWS.Punishments.Types['jail'] = {
    name = "Jail", -- The name of the punishment type.
    description = "Jails a player on the server.", -- The description of the punishment. Don't make this too long.
    params = { -- The parameters a admin can use for this.
        ['duration'] = {
            name = "Duration",
            description = "How long they should be jailed in seconds.",
            type = "number",
            default = "1"
        },
    },
    -- The function to execute. This is where the punishment happens. Returning
    -- true means the punishment was successful. False means it failed, and will
    -- send a failed message to the admin/console.
    -- If it does end up failing, return two values: false, "The message"
    -- e.g return false, "This player is immune to being banned."
    -- Note: This is ran SERVERSIDE. targetSteamID is a SteamID64!
    action = function(admin, targetSteamID, params)
        local player = player.GetBySteamID64(targetSteamID)
        if(!player) then return false,"Player is not online." end

        if(ulx) then 
            ulx.jail(admin, player, params['duration'], false)
            return true
        end 
        if(sam) then 
            -- I WAS TOLD TO DO IT https://upload.livaco.dev/u/1gYParUlZ2.png
            RunConsoleCommand("sam", "jail", targetSteamID, params.duration)
        end 
        -- and apparently xadmin doesn't support jailing :(
        
        return false, "Could not find a supported admin system to jail with."
    end 
}