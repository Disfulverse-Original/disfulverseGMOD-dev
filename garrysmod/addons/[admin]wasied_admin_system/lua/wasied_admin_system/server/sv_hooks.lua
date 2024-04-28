--[[ Hooks ]]--
hook.Add("PlayerSay", "Wasied:AdminSystem:PlayerSay", function(ply, text)
    if not IsValid(ply) or not ply:Alive() then return end
    text = string.lower(text)

    if text == WasiedAdminSystem.Config.AdminModeCommand then
        if WasiedAdminSystem:CheckStaff(ply) then
        
            WasiedAdminSystem:UpdateAdminMod(ply)
            if WasiedAdminSystem.Config.HideCommands then return "" end

        end
    elseif text == WasiedAdminSystem.Config.AdminMenuCommand and WasiedAdminSystem.Config.AdminMenuEnabled then
        if WasiedAdminSystem:CheckStaff(ply) then
            
            net.Start("AdminSystem:AdminMenu:Open")
            net.Send(ply)

            if WasiedAdminSystem.Config.HideCommands then return "" end

        end
    elseif (text == WasiedAdminSystem.Config.TicketMenuCommand or string.StartWith(text, "///")) and WasiedAdminSystem.Config.TicketEnabled then
    
        net.Start("AdminSystem:Tickets:Open")
        net.Send(ply)

        if WasiedAdminSystem.Config.HideCommands then return "" end

    elseif text == WasiedAdminSystem.Config.PlayerManagMenuCommand and WasiedAdminSystem.Config.PlayerManagmentEnabled then
        if WasiedAdminSystem:CheckStaff(ply) then
            
            net.Start("AdminSystem:PlayerManag:Open")
            net.Send(ply)

            if WasiedAdminSystem.Config.HideCommands then return "" end

        end
    elseif text == WasiedAdminSystem.Config.RefundMenuCommand and WasiedAdminSystem.Config.RefundMenuEnabled then
        if WasiedAdminSystem:CheckStaff(ply) then
            
            net.Start("AdminSystem:RefundMenu:Open")
            net.Send(ply)

            if WasiedAdminSystem.Config.HideCommands then return "" end

        end
    end
end)

hook.Add("PlayerNoClip", "Wasied:AdminSystem:Noclip", function(ply)
    
    if not IsValid(ply) or not ply:Alive() then return end
    if ply:GetMoveType() == MOVETYPE_NOCLIP then return end
    if not WasiedAdminSystem.Config.AdminOnNoclip then return end
    if not WasiedAdminSystem.Config.AdminSystemEnabled then return end
    if ply:GetNWInt(WasiedAdminSystem.Constants["strings"][12]) > 0 then return end

    WasiedAdminSystem:UpdateAdminMod(ply)
    return false
    
end)

hook.Add("PlayerSpawn", "Wasied:AdminSystem:Spawn", function(ply)
    if not IsValid(ply) then return end

    ply:SetNWInt(WasiedAdminSystem.Constants["strings"][12], 0) -- set disabled by default

    -- Freeze physgun
    if WasiedAdminSystem:ULXorFAdmin() then
        if ply._ulx_physgun then
            if ply._ulx_physgun.b and ply._ulx_physgun.p then
                timer.Simple(0.001, function()
                    ply:SetPos(ply._ulx_physgun.p)
                    ply:SetMoveType(MOVETYPE_NONE)
                end)
            end
        end
    end
end)

hook.Add("DoPlayerDeath", "Wasied:AdminSystem:RefundSystem", function(ply)
    if not IsValid(ply) then return end

    if WasiedAdminSystem:CheckStaff(ply) and ply:GetNWInt(WasiedAdminSystem.Constants["strings"][12]) == 1 then
        WasiedAdminSystem:UpdateAdminMod(ply)
    end

    local save = {}
    if WasiedAdminSystem.Config.RefundWeapons then
        save.weapons = {}
        for k,v in pairs(ply:GetWeapons()) do
            table.insert(save.weapons, v:GetClass())
        end
    end -- get a table with all the weapons
    if WasiedAdminSystem.Config.RefundMoney then save.money = ply:getDarkRPVar("money") or 0 end
    if WasiedAdminSystem.Config.RefundPM then save.pm = ply:GetModel() end
    if WasiedAdminSystem.Config.RefundJob then save.job = ply:Team() end

    if save then
        net.Start("AdminSystem:RefundMenu:SendToAdmins")
            net.WriteBool(true)
            net.WriteEntity(ply)
            net.WriteTable(save)
        net.Send(WasiedAdminSystem:AdminTable())
        ply.saves = save
    end

end)
