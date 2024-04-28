--[[ Functions ]]--

-- Get admin table
function WasiedAdminSystem:AdminTable(ticketOnly)
    if not isbool(ticketOnly) then ticketOnly = false end

    local tbl = {}
    for k,v in pairs(player.GetAll()) do
        if not IsValid(v) then continue end
        if not WasiedAdminSystem:CheckStaff(v) then continue end
        if ticketOnly then
            if not WasiedAdminSystem.Config.TicketOnlyAdmin && v:GetNWInt(WasiedAdminSystem.Constants["strings"][12]) == 0 then continue end
        end

        table.insert(tbl, v)
    end
    return tbl
end

-- Update admin mod
function WasiedAdminSystem:UpdateAdminMod(ply)
    if not IsValid(ply) or not ply:Alive() then return end
    if not WasiedAdminSystem:CheckStaff(ply) then return end

    if ply:GetNWInt(WasiedAdminSystem.Constants["strings"][12]) == 0 then
        ply:SetNWInt(WasiedAdminSystem.Constants["strings"][12], 1)

        if WasiedAdminSystem.Config.AdminSystemEnabled then
            
            WasiedAdminSystem:Command(ply, "god")
            WasiedAdminSystem:Command(ply, "cloak")
            if ply:GetMoveType() == MOVETYPE_WALK then ply:SetMoveType(MOVETYPE_NOCLIP) end

            DarkRP.notify(ply, 0, 7, WasiedAdminSystem:Lang(86))
            WasiedAdminSystem:Log(ply, WasiedAdminSystem:Lang(1))
            WasiedAdminSystem:AdminLogging(ply, WasiedAdminSystem:Lang(1))

        end

    else
        ply:SetNWInt(WasiedAdminSystem.Constants["strings"][12], 0)

        if WasiedAdminSystem.Config.AdminSystemEnabled then

            WasiedAdminSystem:Command(ply, "ungod")
            WasiedAdminSystem:Command(ply, "uncloak")
            if ply:GetMoveType() == MOVETYPE_NOCLIP then ply:SetMoveType(MOVETYPE_WALK) end

            DarkRP.notify(ply, 0, 7, WasiedAdminSystem:Lang(87))
            WasiedAdminSystem:Log(ply, WasiedAdminSystem:Lang(2))
            WasiedAdminSystem:AdminLogging(ply, WasiedAdminSystem:Lang(2))
    
        end

    end
    sound.Play(WasiedAdminSystem.Constants["strings"][8], ply:GetPos())
end

-- Get current state
function WasiedAdminSystem:GetAdminMod(ply)
    if not IsValid(ply) or not ply:Alive() then return end
    if not WasiedAdminSystem:CheckStaff(ply) then return end
    return ply:GetNWInt(WasiedAdminSystem.Constants["strings"][12])
end

-- Log something
function WasiedAdminSystem:Log(ply, str)
    if not ply:IsPlayer() then return end
    if not isstring(str) then return end

    local nick = ply:Nick()
    local steamid = ply:SteamID()

    ServerLog(WasiedAdminSystem.Constants["strings"][4]..nick.." ("..steamid..") "..str.."\n")
end