local a = "User Management"

if not file.Exists("ulx", "DATA") then
    file.CreateDir("ulx")
end

if not file.Exists("ulx/tempuserdata", "DATA") then
    file.CreateDir("ulx/tempuserdata")
end

ulx.tempuser_group_names = {}

local function b()
    table.Empty(ulx.tempuser_group_names)

    for c, _ in pairs(ULib.ucl.groups) do
        table.insert(ulx.tempuser_group_names, c)
    end
end

hook.Add(ULib.HOOK_UCLCHANGED, "ULXTempAddUesrGroupNamesUpdate", b)
b()

function ulx.CheckExpiration(d)
    local e = d:SteamID64()

    if file.Exists("ulx/tempuserdata/" .. e .. ".txt", "DATA") then
        local f = file.Read("ulx/tempuserdata/" .. e .. ".txt", "DATA")
        local g = string.Explode("|", f)
        local h = tonumber(g[1])
        local i = g[2]

        if os.time() >= h then
            ulx.ExpireGroupChange(d, i)
        else
            if os.time() + 3600 >= h then
                timer.Create("ULXGroupExpire_" .. e, h - os.time(), 1, function()
                    ulx.ExpireGroupChange(d, i)
                end)
            end
        end
    end
end

hook.Add("PlayerAuthed", "CheckExpiration", ulx.CheckExpiration)

function ulx.PeriodicExpirationCheck()
    if CLIENT then return end

    for _, d in pairs(player.GetAll()) do
        if IsValid(d) and d:IsConnected() then
            ulx.CheckExpiration(d)
        end
    end
end

timer.Create("ulx_periodicexpirationcheck", 3600, 0, ulx.PeriodicExpirationCheck)

function ulx.ExpireGroupChange(d, j)
    if not IsValid(d) then return end
    if not d:IsConnected() then return end
    local e = d:SteamID64()

    if j == "user" then
        ULib.ucl.removeUser(d:SteamID())
        BRICKS_SERVER.Func.RecalcInventory(d)
    else
        ULib.ucl.addUser(d:SteamID(), _, _, j)
        BRICKS_SERVER.Func.RecalcInventory(d)
    end

    ulx.fancyLogAdmin(d, "#A had his/her group auto set to #s by a timed group script.", j)
    timer.Remove("ULXGroupExpire_" .. e)

    if file.Exists("ulx/tempuserdata/" .. e .. ".txt", "DATA") then
        file.Delete("ulx/tempuserdata/" .. e .. ".txt")
    end
end

function ulx.CreateExpiration(d, k, l)
    local e = d:SteamID64()
    local m = k * 60 + os.time()
    local g = {}
    g["exptime"] = m
    g["returngroup"] = l
    local n = m .. "|" .. l
    file.Write("ulx/tempuserdata/" .. e .. ".txt", n)
end

function ulx.CreateExpirationByID(o, k, l)
    local e = o
    local m = k * 60 + os.time()
    local g = {}
    g["exptime"] = m
    g["returngroup"] = l
    local n = m .. "|" .. l
    file.Write("ulx/tempuserdata/" .. e .. ".txt", n)
end

function ulx.tempadduser(p, q, c, k, r)
    c = c:lower()
    r = r:lower()
    local s = ULib.ucl.authed[q:UniqueID()]
    local o = ULib.ucl.getUserRegisteredID(q)

    if not o then
        o = q:SteamID()
    end

    ULib.ucl.addUser(o, s.allow, s.deny, c)

    BRICKS_SERVER.Func.RecalcInventory(q)

    ulx.fancyLogAdmin(p, "#A added #T to group #s for " .. k .. " minutes.", q, c)
    ulx.CreateExpiration(q, k, r)

    if k <= 30 then
        timer.Create("ULXGroupExpire_" .. q:SteamID64(), k * 60, 1, function()
            ulx.ExpireGroupChange(q, r)
        end)
    end
end

local t = ulx.command(a, "ulx tempadduser", ulx.tempadduser)

t:addParam{
    type = ULib.cmds.PlayerArg
}

t:addParam{
    type = ULib.cmds.StringArg,
    completes = ulx.tempuser_group_names,
    hint = "Group to place user in temporarily",
    error = "invalid group \"%s\" specified",
ULib.cmds.restrictToCompletes
}

t:addParam{
    type = ULib.cmds.NumArg,
    hint = "Time (Minutes)"
}

t:addParam{
    type = ULib.cmds.StringArg,
    completes = ulx.tempuser_group_names,
    hint = "Group to place user in after time expires",
    error = "invalid group \"%s\" specified",
ULib.cmds.restrictToCompletes
}

t:defaultAccess(ULib.ACCESS_SUPERADMIN)
t:help("Add a user to specified group for a specified time.")

function ulx.tempadduserid(p, u, c, k, r) -- player that perform action, target of the action, usergroupTo, time, usergroupAfter
    c = c:lower()
    r = r:lower()
    new_id_64 = ulx.SteamIDTo64(u:upper())

    if new_id_64 == nil then
        print("Invalid SteamID")

        return
    end

    local q = nil

    for v, w in pairs(player.GetAll()) do
        if w:SteamID() == u then
            q = w
            break
        end
    end

    if q then
        local s = ULib.ucl.authed[q:UniqueID()]
        local o = ULib.ucl.getUserRegisteredID(q)

        if not o then
            o = q:SteamID()
        end

        ULib.ucl.addUser(o, s.allow, s.deny, c)

        local target_ply = player.GetBySteamID(u)
        BRICKS_SERVER.Func.RecalcInventory(target_ply)

        ulx.fancyLogAdmin(p, "#A added #T to group #s for " .. k .. " minutes.", q, c)
        ulx.CreateExpiration(q, k, r)

        if k <= 30 then
            timer.Create("ULXGroupExpire_" .. q:SteamID64(), k * 60, 1, function()
                ulx.ExpireGroupChange(q, r)
            end)
        end
    else
        ulx.fancyLogAdmin(p, "#A added " .. u .. " to group #s for " .. k .. " minutes.", c)
        ulx.CreateExpirationByID(new_id_64, k, r)
    end
end

local x = ulx.command(a, "ulx tempadduserid", ulx.tempadduserid)

x:addParam{
    type = ULib.cmds.StringArg
}

x:addParam{
    type = ULib.cmds.StringArg,
    completes = ulx.tempuser_group_names,
    hint = "Group to place user in temporarily",
    error = "invalid group \"%s\" specified",
ULib.cmds.restrictToCompletes
}

x:addParam{
    type = ULib.cmds.NumArg,
    hint = "Time (Minutes)"
}

x:addParam{
    type = ULib.cmds.StringArg,
    completes = ulx.tempuser_group_names,
    hint = "Group to place user in after time expires",
    error = "invalid group \"%s\" specified",
ULib.cmds.restrictToCompletes
}

x:defaultAccess(ULib.ACCESS_SUPERADMIN)
x:help("Add a user by SteamID to specified group for a specified time.")

function ulx.SteamIDTo64(o)
    o = string.Trim(o)

    if string.sub(o, 1, 6) == 'STEAM_' then
        local y = string.Explode(':', string.sub(o, 7))
        local z = 1197960265728 + tonumber(y[2]) + tonumber(y[3]) * 2
        local A = string.format('%f', z)

        return '7656' .. string.sub(A, 1, string.find(A, '.', 1, true) - 1)
    else
        return nil
    end
end