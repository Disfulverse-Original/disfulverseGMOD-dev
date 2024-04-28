util.AddNetworkString("yaws.core.openui")
util.AddNetworkString("yaws.core.offlineplayersearch")
util.AddNetworkString("yaws.core.offlineplayerresults")
util.AddNetworkString("yaws.core.playerwarndata")
util.AddNetworkString("yaws.core.playerwarndataresults")
util.AddNetworkString("yaws.core.c_viewplayer")
util.AddNetworkString("yaws.core.c_warnplayer")
util.AddNetworkString("yaws.core.c_viewnotes")

function YAWS.Core.ProcessNetCooldown(ply)
    if(!ply:SteamID64()) then return true end -- Not really sure how else to handle this. This can happen on a client joining so idfk
        
    if(YAWS.NetCooldown[ply:SteamID64()]) then
        if(YAWS.NetCooldown[ply:SteamID64()] > CurTime()) then
            YAWS.Core.Message(ply, "net_cooldown")
            YAWS.NetCooldown[ply:SteamID64()] = YAWS.NetCooldown[ply:SteamID64()] + 0.25
            
            return false
        end
    end

    YAWS.NetCooldown[ply:SteamID64()] = CurTime() + 0.25
    return true
end 

hook.Add("PlayerSay", "yaws.core.commands", function(ply, text, team)
    if(string.lower(string.sub(text, 0, #YAWS.ManualConfig.Command)) != string.lower(YAWS.ManualConfig.Command)) then return end 

    if(!YAWS.Permissions.CheckPermissionPly(ply, "view_ui")) then 
        YAWS.Core.Message(ply, "chat_no_permission")
        return 
    end

    local args = string.Explode(" ", string.Trim(text))
    if(#args >= 2) then 
        if(args[2] == "help") then 
            YAWS.Core.Message(ply, "player_warn_help")
            return
        end 
        if(!YAWS.Permissions.CheckPermissionPly(ply, "customise_reason")) then 
            YAWS.Core.Message(ply, "player_warn_ui")
            return
        end

        -- Chat arguments for quicky warning peeps
        local target = args[2]
        local pointCount = tonumber(args[3])
        if(!pointCount) then 
            YAWS.Core.Message(ply, "player_warn_wrongpoints")
            return
        end 
        local reason = args[4]
        if(#args >= 4) then 
            for i=5,#args do 
                reason = reason .. " " .. args[i]
            end
        end

        -- Find our player
        local targetPly
        for k,v in ipairs(player.GetAll()) do 
            if(string.find(string.lower(v:Name()), string.lower(target), nil, true)) then -- nicked from xadmin https://github.com/TheXYZNetwork/xAdmin/blob/master/lua/xadmin/core/sv_core.lua#L77
                targetPly = v
                break
            end
        end
        if(!targetPly) then 
            YAWS.Core.Message(ply, "player_warn_not_found")
            return
        end 

        -- Check Time
        if(!reason or string.Trim(reason) == "") then 
            if(YAWS.Config.GetValue("reason_required")) then 
                YAWS.Core.Message(ply, "player_warn_noreason")
                return 
            end 

            reason = "N/A"
        end

        if(pointCount > YAWS.Config.GetValue("point_max")) then 
            YAWS.Core.Message(ply, "player_warn_maxpoints", YAWS.Config.GetValue("point_max"))
            return 
        end

        -- Immunity List
        if(YAWS.ManualConfig.Immunes[targetPly:SteamID64()] || YAWS.ManualConfig.Immunes[targetPly:SteamID()]) then 
            YAWS.Core.Message(ply, "player_warn_immune")
            return 
        end
        if(YAWS.ManualConfig.Immunes[targetPly:GetUserGroup()]) then 
            YAWS.Core.Message(ply, "player_warn_immune")
            return 
        end

        -- warneeing
        YAWS.Warns.WarnPlayer(targetPly:SteamID64(), ply:SteamID64(), reason, pointCount)
        YAWS.Core.Message(ply, "admin_player_warned", targetPly:Name())
        YAWS.Core.Message(targetPly, "player_warn_notice", ply:Name(), reason)

        if(YAWS.Config.GetValue("broadcast_warns")) then 
            YAWS.Core.Broadcast({targetPly, ply}, "player_warn_broadcast", targetPly:GetName(), ply:Name(), reason)
        end 

        return 
    end 

    YAWS.Core.HandleUIOpen(ply)
    return ""
end)

-- For the C context menu opening UI state thing
net.Receive("yaws.core.c_viewplayer", function(len, ply)
    if(!YAWS.Core.ProcessNetCooldown(ply)) then return end 
    YAWS.NetCooldown[ply:SteamID64()] = 0 -- They're most likely away to send another request for more data.
    YAWS.Core.PayloadDebug("yaws.core.requestopenui", len)
    
    YAWS.Players.GetPlayer64(net.ReadString())
        :next(function(player)
            if(player.invalid) then return end 

            YAWS.Core.HandleUIOpen(ply, {
                state = "viewing_player",
                
                steamid = player.steamid,
                name = player.name,
                usergroup = player.usergroup,
            })
        end)
end)
net.Receive("yaws.core.c_viewnotes", function(len, ply)
    if(!YAWS.Core.ProcessNetCooldown(ply)) then return end 
    YAWS.NetCooldown[ply:SteamID64()] = 0 -- They're most likely away to send another request for more data.
    YAWS.Core.PayloadDebug("yaws.core.requestopenui", len)
    
    YAWS.Players.GetPlayer64(net.ReadString())
        :next(function(player)
            if(player.invalid) then return end 
                
            YAWS.Core.HandleUIOpen(ply, {
                state = "viewing_player_notes",
            
                steamid = player.steamid,
                name = player.name,
                usergroup = player.usergroup,
            })
        end)
end)
net.Receive("yaws.core.c_warnplayer", function(len, ply)
    if(!YAWS.Core.ProcessNetCooldown(ply)) then return end 
    YAWS.NetCooldown[ply:SteamID64()] = 0 -- They're most likely away to send another request for more data.
    YAWS.Core.PayloadDebug("yaws.core.requestopenui", len)

    YAWS.Players.GetPlayer64(net.ReadString())
        :next(function(player)
            if(player.invalid) then return end 
                    
            YAWS.Core.HandleUIOpen(ply, {
                state = "warning_player",
    
                -- steamid = "76561208433573949",
                steamid = player.steamid,
                name = player.name,
                usergroup = player.usergroup,
            })
        end)
end)

-- just an alias of YAWS.Language.SendMessage 
-- to make my fingers less mad at me
function YAWS.Core.Message(ply, key, ...)
    YAWS.Language.SendMessage(ply, key, unpack({...}))
end 

function YAWS.Core.Broadcast(excluded, key, ...) 
    for k,v in ipairs(player.GetAll()) do 
        if(table.HasValue(excluded, v)) then continue end 
        YAWS.Language.SendMessage(v, key, unpack({...}))
    end 
end 

function YAWS.Core.HandleUIOpen(ply, state)
    -- curator how addon works time So, in short what i do here is i send off
    -- the data the client has access to, as well as what the client can access
    -- so the the addon can hide those tabs. E.g if a client can edit the admin
    -- settings and warn players but can't view their own warnings (weird
    -- example i know) i'll write into the data to show the admin and warn
    -- stuff, but when it comes to their own warnings i don't send it and tell
    -- them to not show that tab. The only exception to this currently is other
    -- players data because if your on a server that's had over 500 unique
    -- players that isn't going to end well in terms of raping the net message
    -- limit.
    --
    -- confusing yes, but better then sending net messages to and from the
    -- client and server all the time on a busy server with lots of shit going
    -- about - just send one giant dump over that contains everything they need
    -- from the get go and let any updates be handled by them while sending the
    -- updates off to the server to store that way their both in sync. ez. sorry
    -- for the text wall lol


    -- just to save me calling the functions all the time 
    local permissions = {
        view_self_warns = YAWS.Permissions.CheckPermissionPly(ply, "view_self_warns"),
        view_others_warns = YAWS.Permissions.CheckPermissionPly(ply, "view_others_warns"),
        view_admin_settings = YAWS.Permissions.CheckPermissionPly(ply, "view_admin_settings"),

        create_warns = YAWS.Permissions.CheckPermissionPly(ply, "create_warns"),
        customise_reason = YAWS.Permissions.CheckPermissionPly(ply, "customise_reason"),
        delete_warns = YAWS.Permissions.CheckPermissionPly(ply, "delete_warns")
    }

    local data = {
        can_view = {
            self_warns = permissions['view_self_warns'],
            others_warns = permissions['view_others_warns'],
            admin_settings = permissions['view_admin_settings'],

            warn_players = permissions['create_warns'],
            custom_reasons = permissions['customise_reason'],
            delete_warns = permissions['delete_warns']
        }
    }
    if(state) then 
        data.state = state
    end 

    -- Data that needs to be sent with the UI shit goes here.
    if(permissions['view_admin_settings'] || permissions['create_warns']) then 
        data.current_presets = YAWS.Config.Presets
    end 

    if(permissions['view_admin_settings']) then 
        -- Send off the admin panel shit
        data.admin_settings = {
            current_punishments = YAWS.Punishments.PunishmentCache,
            current_permissions = YAWS.Permissions.Permissions,
        }
    end 

    -- jesus christ async really fucked this code up badly huh
    YAWS.Warns.GetWarnsFromPlayer(ply:SteamID64())
        :next(function(warnings)
            data.self_warn_point_count = 0
            data.self_warn_expired_point_count = 0

            if(permissions['view_self_warns']) then
                data.self_warns = table.Copy(warnings) -- GOD BLESS THIS FUNCTION FUCK YOU LUA
                if(table.Count(data.self_warns) > 0) then
                    -- need to fiddle with it a bit
                    YAWS.Core.ClientsideFormatWarnings(data.self_warns)
                        :next(function(formatted)
                            data.self_warns = formatted

                            YAWS.Warns.GetPoints(ply:SteamID64())
                                :next(function(pointData)
                                    data.self_warn_point_count = pointData[1]
                                    data.self_warn_expired_point_count = pointData[2]
                            
                                    net.Start("yaws.core.openui")
                                    local compressed = util.Compress(util.TableToJSON(data))
                                    net.WriteUInt(#compressed, 16)
                                    net.WriteData(compressed)
                                    net.Send(ply)
                                end)
                        end)
                else 
                    net.Start("yaws.core.openui")
                    local compressed = util.Compress(util.TableToJSON(data))
                    net.WriteUInt(#compressed, 16)
                    net.WriteData(compressed)
                    net.Send(ply)
                end 
            else 
                net.Start("yaws.core.openui")
                local compressed = util.Compress(util.TableToJSON(data))
                net.WriteUInt(#compressed, 16)
                net.WriteData(compressed)
                net.Send(ply)
            end 
        end)
end 

-- Player Searching
net.Receive("yaws.core.offlineplayersearch", function(len, ply)
    if(!YAWS.Core.ProcessNetCooldown(ply)) then return end 
    if(!YAWS.Permissions.CheckPermissionPly(ply, "view_others_warns")) then return end 
    YAWS.Core.PayloadDebug("yaws.core.offlineplayersearch", len)

    local filter = net.ReadString()
    if(#filter <= 0) then return end 
    if(#filter > 75) then return end 
    
    local data = {}
    local i = 0
    YAWS.Database.Query(function(err, q, queryData)
        if(err) then return end 

        -- Offline Players
        for k,v in ipairs(queryData) do
            if(!string.find(string.lower(v.name), string.lower(filter), 1, true) && string.lower(v.steamid) != string.Trim(string.lower(filter)) && v.steamid != string.Trim(filter)) then continue end
            if(i > 60) then continue end -- Max of 60 to prevent bypassing the net message size limit.
                
            i = i + 1;
            data[v.steamid] = {
                name = v.name,
                usergroup = v.usergroup,
            }
        end 

        -- Do the same for online players too
        for k,v in ipairs(player.GetAll()) do
            if(!string.find(string.lower(v:Name()), string.lower(filter), 1, true) && string.lower(v:SteamID()) != string.Trim(string.lower(filter)) && v:SteamID64() != string.Trim(filter)) then continue end
            if(i > 60) then continue end -- Max of 60 to prevent bypassing the net message size limit.
            if(data[v:SteamID64()]) then continue end
                
            i = i + 1;
            data[v:SteamID64()] = {
                name = v:Name(),
                usergroup = v:GetUserGroup(),
            }
        end 

        net.Start("yaws.core.offlineplayerresults")
    
        -- Fucking compression was making the stringed keys into integers, causing
        -- the SteamIDs to be wrong as they weren't precise enough. Ugh :( 
        net.WriteUInt(i, 16)
        for k,v in pairs(data) do 
            net.WriteString(k)
            net.WriteString(v.name)
            net.WriteString(v.usergroup)
        end 
        
        net.Send(ply)
    end, [[
        SELECT * FROM `%splayers`
    ]], YAWS.ManualConfig.Database.TablePrefix)
end)

-- Player warn data - we also chuck in the admin notes here
net.Receive("yaws.core.playerwarndata", function(len, ply)
    if(!YAWS.Core.ProcessNetCooldown(ply)) then return end 
    if(!YAWS.Permissions.CheckPermissionPly(ply, "view_others_warns")) then return end 
    YAWS.Core.PayloadDebug("yaws.core.playerwarndata", len) 
    
    local steamid = net.ReadString()
    local warns = {} 
    -- warns.warnings = table.Copy(YAWS.Warns.GetWarnsFromPlayer(steamid))
    YAWS.Warns.GetWarnsFromPlayer(steamid)
        :next(function(warnings)
            warns.warnings = table.Copy(warnings)
            YAWS.Core.ClientsideFormatWarnings(warns.warnings)
                :next(function(formatted)
                    warns.warnings = formatted

                    YAWS.Warns.GetPoints(steamid)
                        :next(function(pointData)
                            warns.pointCount = pointData[1]
                            warns.expiredPointCount = pointData[2]
    
                            YAWS.Core.GetAdminNote(steamid)
                                :next(function(note)
                                    local compressed = util.Compress(util.TableToJSON(warns))
                                    net.Start("yaws.core.playerwarndataresults")
                                    net.WriteUInt(#compressed, 16)
                                    net.WriteData(compressed)
                                    net.WriteString(note)
                                    net.Send(ply)
                                end)
                        end)
                end)
        end)
end)

function YAWS.Core.ClientsideFormatWarnings(warnings)
    local d = deferred.new()

    local steamids = {}
    for k,v in pairs(warnings) do
        v.adminSteamID = v.admin
        -- v.admin = YAWS.Players.GetPlayer64(v.admin).name
        steamids[k] = v.admin
        v.server_id = YAWS.NiceServerNames[v.server_id]
    end 

    for k,v in pairs(steamids) do 
        YAWS.Database.Query(function(err, q, data)
            if(err) then
                d:reject(err)
                return
            end
            
            warnings[k].admin = data[1].name
        end, [[
            SELECT * FROM `%splayers` WHERE `steamid` = '%s'
        ]], YAWS.ManualConfig.Database.TablePrefix, v)
    end 
    
    d:resolve(warnings)
    return d
end 

-- UUID Function from https://gist.github.com/jrus/3197011 
-- Theres conerns in the comments about it but I ran 100,000 runs of it quickly
-- as a test and never got repeats so it should be fine. 
-- https://upload.livaco.dev/u/FRBw15iyLc.png https://upload.livaco.dev/u/lKFVqT680E.png
-- Huge thanks my dude, you have no idea just how much of a headache it was before :)
function YAWS.Core.GenerateUUID()
    local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function(c)
        local v = (c == 'x') && math.random(0, 0xf) || math.random(8, 0xb)
        return string.format('%x', v)
    end)
end