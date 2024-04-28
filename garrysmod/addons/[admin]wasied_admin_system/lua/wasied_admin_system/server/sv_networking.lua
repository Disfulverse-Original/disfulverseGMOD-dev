--[[ Networking (a lot because the addon is so advanced ^^) ]]--
util.AddNetworkString("AdminSystem:Utils:ModifyVar")
util.AddNetworkString("AdminSystem:AdminMenu:Open")
util.AddNetworkString("AdminSystem:PlayerManag:Open")
util.AddNetworkString("AdminSystem:RefundMenu:Open")
util.AddNetworkString("AdminSystem:RefundMenu:SendToAdmins")
util.AddNetworkString("AdminSystem:RefundMenu:RefundThings")
util.AddNetworkString("AdminSystem:Tickets:Open")
util.AddNetworkString("AdminSystem:Tickets:SendTicket")
util.AddNetworkString("AdminSystem:Tickets:SendToAdmins")
util.AddNetworkString("AdminSystem:Tickets:AdminTaking")

-- Edit a var
net.Receive("AdminSystem:Utils:ModifyVar", function(_, ply)
    if not WasiedAdminSystem:CheckStaff(ply) then return end
    
    ply.varEdit = ply.varEdit or 0
    if ply.varEdit > CurTime() then return end
    ply.varEdit = CurTime() + .5

    WasiedAdminSystem:UpdateAdminMod(ply)
end)

-- Send a ticket
net.Receive("AdminSystem:Tickets:SendTicket", function(_, ply)
    if not WasiedAdminSystem.Config.TicketEnabled then return end
    if not IsValid(ply) then return end

    local subject = net.ReadString()
    if not table.HasValue(WasiedAdminSystem.Config.TicketsReasons, subject) then return end

    ply.ticketCountdown = ply.ticketCountdown or 0
    if ply.ticketCountdown > CurTime() then return end
    ply.ticketCountdown = CurTime() + WasiedAdminSystem.Config.TicketTimer

    local tbl = {}
    tbl.plys = net.ReadTable()
    tbl.sender = ply
    tbl.subject = subject
    tbl.description = net.ReadString()
    net.Start("AdminSystem:Tickets:SendToAdmins")
        net.WriteBool(true)
        net.WriteTable(tbl)
    net.Send(WasiedAdminSystem:AdminTable(true))
end)

-- Admin broadcast
net.Receive("AdminSystem:Tickets:AdminTaking", function(_, ply)
    if not IsValid(ply) then return end
    if not WasiedAdminSystem:CheckStaff(ply) then return end

    local bool = net.ReadBool()
    local sender = net.ReadEntity()

    if not IsValid(sender) then return end

    net.Start("AdminSystem:Tickets:SendToAdmins")
        net.WriteBool(false) -- show or complete
        net.WriteBool(bool) -- delete ?
        net.WriteEntity(ply)
        net.WriteEntity(sender)
    net.Send(WasiedAdminSystem:AdminTable(true))
end)

-- Refund things
net.Receive("AdminSystem:RefundMenu:RefundThings", function(_, ply)
    if not IsValid(ply) then return end
    if not WasiedAdminSystem:CheckStaff(ply) then return end

    local victim = net.ReadEntity()
    local refund = victim.saves
    local weapon = refund.weapons
    local money = refund.money
    local job = refund.job
    local model = refund.PM

    local enabledTbl = net.ReadTable()
    if not IsValid(victim) then return end

    if weapon and enabledTbl["weapon"] then
        for k,v in ipairs(weapon) do
            victim:Give(v)
        end
        WasiedAdminSystem:Log(ply, WasiedAdminSystem:Lang(76).." "..victim:Nick().." (Admin System).")
    end

    if money and enabledTbl["money"] then
        victim:setDarkRPVar("money", money)
        WasiedAdminSystem:Log(ply, WasiedAdminSystem:Lang(77).." "..victim:Nick().." (Admin System).")
    end

    if job and enabledTbl["job"] then
        if DarkRP then
            local canJob = victim:changeTeam(job, false)
            if canJob then
                WasiedAdminSystem:Log(ply, WasiedAdminSystem:Lang(78).." "..victim:Nick().." ne peut pas avoir ce job. Définissez-lui manuellement.")
            end
        else
            victim:SetTeam(job)
            victim:Respawn()
        end
        WasiedAdminSystem:Log(ply, WasiedAdminSystem:Lang(78).." "..victim:Nick().." (Admin System).")
    end

    if model and enabledTbl["pm"] then
        victim:SetModel(model)
        WasiedAdminSystem:Log(ply, WasiedAdminSystem:Lang(79).." "..victim:Nick().." (Admin System).")
    end

    DarkRP.notify(victim, 0, 7, string.Replace(WasiedAdminSystem:Lang(80), ply:Nick()).." !")
    DarkRP.notify(ply, 0, 7, WasiedAdminSystem:Lang(81))
    WasiedAdminSystem:AdminLogging(ply, WasiedAdminSystem:Lang(82).." "..victim:Nick().." !")

    -- update for others admins
    net.Start("AdminSystem:RefundMenu:SendToAdmins")
        net.WriteBool(false)
        net.WriteEntity(victim)
    net.Send(WasiedAdminSystem:AdminTable())

end)