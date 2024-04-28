--[[ Shared functions ]]--

-- Get language by ID
function WasiedAdminSystem:Lang(id)
    return WasiedAdminSystem.Language[WasiedAdminSystem.Config.ScriptLanguage][id] or WasiedAdminSystem.Constants["strings"][1]
end

-- Should we use FAdmin or ULX ?
function WasiedAdminSystem:ULXorFAdmin()
    local configType = string.upper(WasiedAdminSystem.Config.ULXorFAdmin)
    if configType == WasiedAdminSystem.Constants["strings"][2] then
        if not ULib then Error(WasiedAdminSystem.Constants["strings"][4]..WasiedAdminSystem.Constants["strings"][5]) end
        return true
    elseif configType == WasiedAdminSystem.Constants["strings"][3] then
        return false
    else
        Error(WasiedAdminSystem.Constants["strings"][4]..WasiedAdminSystem.Constants["strings"][6])
    end
end

-- Execute a command with the specified commands system
function WasiedAdminSystem:Command(ply, cmd, args)
    if not IsValid(ply) then return end

    local tbl = WasiedAdminSystem.Constants["cmd"][cmd]
    if not istable(tbl) then return end

    local commandsType = WasiedAdminSystem:ULXorFAdmin()
    commandsType = (commandsType and "ULX" or "FADMIN")
    if isfunction(tbl[commandsType]) then 
        if istable(args) then
            tbl[commandsType](ply, args)
        else
            tbl[commandsType](ply)
        end 
    end
end

-- Logging informations to high-ranks admin
function WasiedAdminSystem:AdminLogging(victim, log)
    if not WasiedAdminSystem.Config.ShowStaffActions then return end

    local victimNick = victim:Nick()
    for _,v in pairs(player.GetAll()) do
        if not IsValid(v) or not isstring(victimNick) then continue end
        if WasiedAdminSystem.Config.HighRanks[v:GetUserGroup()] then
            v:PrintMessage(HUD_PRINTTALK, WasiedAdminSystem.Constants["strings"][4]..victimNick.." ("..victim:SteamID()..") "..log)
        end
    end

end

-- Check if a player is staff
function WasiedAdminSystem:CheckStaff(ply)
    if IsValid(ply) and (WasiedAdminSystem.Config.RanksAllowed[ply:GetUserGroup()] or ply:IsSuperAdmin()) then return true end
    return false 
end