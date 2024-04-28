-- Add information
function WasiedAdminSystem:AddInfo()
    local update = net.ReadBool()
    local nooby = net.ReadEntity()
    if not IsValid(nooby) then return end

    if update then
        local tbl = net.ReadTable()
        nooby.refundInformations = tbl
    else
        nooby.refundInformations = nil
    end
end
net.Receive("AdminSystem:RefundMenu:SendToAdmins", WasiedAdminSystem.AddInfo)

function WasiedAdminSystem:OpenRefundMenu() 
    if not WasiedAdminSystem.Config.RefundMenuEnabled then return end
	if not LocalPlayer():Alive() then return end
    if not WasiedAdminSystem:CheckStaff(LocalPlayer()) then return end
    
    local selectedPlayer
    local rightPanel

    local basicFrame = vgui.Create("WASIED_DFrame")
	basicFrame:SetRSize(1400, 800)
	basicFrame:Center()
    basicFrame:CloseButton(true)
    basicFrame:ReturnAdminButton(true)
	basicFrame:SetLibTitle(WasiedAdminSystem:Lang(11).." "..WasiedAdminSystem:Lang(3).." "..WasiedAdminSystem.Config.ServerName)
    basicFrame.PaintOver = function(self, w, h)
        draw.SimpleText(WasiedAdminSystem:Lang(48), WasiedAdminSystem:Font(30), WasiedAdminSystem:RespX(362), WasiedAdminSystem:RespY(95), color_white, 1, 3)
        draw.SimpleText(WasiedAdminSystem:Lang(49), WasiedAdminSystem:Font(30), WasiedAdminSystem:RespX(1051), WasiedAdminSystem:RespY(95), color_white, 1, 3)
    end

    local leftPanel = vgui.Create("DPanel", basicFrame)
    leftPanel:SetSize(WasiedAdminSystem:RespX(675), WasiedAdminSystem:RespY(625))
    leftPanel:SetPos(WasiedAdminSystem:RespX(25), WasiedAdminSystem:RespY(130))
    function leftPanel:Paint(w, h)
        surface.SetDrawColor(WasiedAdminSystem.Constants["colors"][7])
        surface.DrawRect(0, 0, w, h)
    end

    local scrollPanel = vgui.Create("DScrollPanel", leftPanel)
    scrollPanel:Dock(FILL)
    local sbar = scrollPanel:GetVBar()
    function sbar:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20))
    end
    function sbar.btnUp:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(40, 40, 40))
    end
    function sbar.btnDown:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(40, 40, 40))
    end
    function sbar.btnGrip:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(40, 40, 40))
    end

    scrollPanel:Clear()
    local posy = -1
    for k,v in pairs(player.GetAll()) do
        if not IsValid(v) then continue end 
        if not v:Alive() then continue end
        if not v.refundInformations then continue end
        posy = posy + 1

        local plyButton = vgui.Create("WASIED_DButton", scrollPanel)
        plyButton:Dock(TOP)
        plyButton:SetTall(WasiedAdminSystem:RespY(50))
        -- plyButton:SetRPos(0, 55*posy)
        plyButton:SetLibText(v:Nick(), color_white)
        plyButton.DoClick = function(self)
            if not IsValid(v) then return end
            selectedPlayer = v
            if IsValid(rightPanel) then return rightPanel:Remove() end

            rightPanel = vgui.Create("DPanel", basicFrame)
            rightPanel:SetSize(WasiedAdminSystem:RespX(650), WasiedAdminSystem:RespY(625))
            rightPanel:SetPos(WasiedAdminSystem:RespX(725), WasiedAdminSystem:RespY(130))
            function rightPanel:Paint(w, h)
                surface.SetDrawColor(WasiedAdminSystem.Constants["colors"][7])
                surface.DrawRect(0, 0, w, h)
                surface.SetDrawColor(color_white)
                surface.DrawOutlinedRect(0, 0, w, h)

                if IsValid(selectedPlayer) and selectedPlayer.refundInformations then
                    draw.SimpleText(WasiedAdminSystem:Lang(50).." :", WasiedAdminSystem:Font(25), WasiedAdminSystem:RespX(20), WasiedAdminSystem:RespY(100), color_white, 0, 3)
                    draw.SimpleText("("..(selectedPlayer.refundInformations.pm or "NULL")..")", WasiedAdminSystem:Font(15), WasiedAdminSystem:RespX(20), WasiedAdminSystem:RespY(125), color_white, 0, 3)
                    draw.SimpleText((selectedPlayer:Nick() or "NULL"), WasiedAdminSystem:Font(35), w/2, WasiedAdminSystem:RespY(20), color_white, 1, 3)
                    draw.SimpleText(WasiedAdminSystem:Lang(51).." : "..(selectedPlayer.refundInformations.money or "NULL")..WasiedAdminSystem:Lang(17), WasiedAdminSystem:Font(25), WasiedAdminSystem:RespX(20), WasiedAdminSystem:RespY(360), color_white, 0, 3)
                    draw.SimpleText(WasiedAdminSystem:Lang(53).." : "..(team.GetName(selectedPlayer.refundInformations.job) or "NULL"), WasiedAdminSystem:Font(25), WasiedAdminSystem:RespX(20), WasiedAdminSystem:RespY(390), color_white, 0, 3)
                    draw.SimpleText(WasiedAdminSystem:Lang(52).." :", WasiedAdminSystem:Font(25), WasiedAdminSystem:RespX(20), WasiedAdminSystem:RespY(420), color_white, 0, 3)
                    draw.SimpleText(WasiedAdminSystem:Lang(54), WasiedAdminSystem:Font(20), WasiedAdminSystem:RespX(25), WasiedAdminSystem:RespY(510), color_white, 0, 3)
                end
            end

            local pmpanel = vgui.Create("DModelPanel", rightPanel)
            pmpanel:SetSize(rightPanel:GetWide()/2, rightPanel:GetWide()/2)
            pmpanel:SetPos(rightPanel:GetWide()/2-pmpanel:GetWide()/2, WasiedAdminSystem:RespX(40))
            if WasiedAdminSystem.Config.RefundPM then pmpanel:SetModel(selectedPlayer.refundInformations.pm) else pmpanel:SetModel(selectedPlayer:GetModel()) end

            local weap = WasiedAdminSystem:Lang(55)
            if selectedPlayer.refundInformations.weapons then 
                weap = table.concat(selectedPlayer.refundInformations.weapons, ", ")
            end

            local richText = vgui.Create("RichText", rightPanel)
            richText:SetSize(WasiedAdminSystem:RespX(580), WasiedAdminSystem:RespY(50))
            richText:SetPos(WasiedAdminSystem:RespX(20), WasiedAdminSystem:RespY(455))
            richText:SetFontInternal(WasiedAdminSystem:Font(25))
            richText:AppendText(weap)

            local refundWeap = vgui.Create("WASIED_DButton", rightPanel)
            refundWeap:SetSize(WasiedAdminSystem:RespX(150), WasiedAdminSystem:RespY(50))
            refundWeap:SetPos(WasiedAdminSystem:RespX(25), WasiedAdminSystem:RespY(535))
            refundWeap:SetLibText(WasiedAdminSystem:Lang(56), color_white)
            refundWeap.clicked = false
            refundWeap.PaintOver = function(self, w, h)
                if not self.clicked then
                    surface.SetDrawColor(WasiedAdminSystem.Constants["colors"][9])
                    surface.DrawRect(0, 0, w, h)
                end
            end
            refundWeap.DoClick = function(self)
                if self.clicked then self.clicked = false else self.clicked = true end
            end

            local refundMoney = vgui.Create("WASIED_DButton", rightPanel)
            refundMoney:SetSize(WasiedAdminSystem:RespX(150), WasiedAdminSystem:RespY(50))
            refundMoney:SetPos(WasiedAdminSystem:RespX(180), WasiedAdminSystem:RespY(535))
            refundMoney:SetLibText(WasiedAdminSystem:Lang(47), color_white)
            refundMoney.clicked = false
            refundMoney.PaintOver = function(self, w, h)
                if not self.clicked then
                    surface.SetDrawColor(WasiedAdminSystem.Constants["colors"][9])
                    surface.DrawRect(0, 0, w, h)
                end
            end
            refundMoney.DoClick = function(self)
                if self.clicked then self.clicked = false else self.clicked = true end
            end

            local refundJob = vgui.Create("WASIED_DButton", rightPanel)
            refundJob:SetSize(WasiedAdminSystem:RespX(150), WasiedAdminSystem:RespY(50))
            refundJob:SetPos(WasiedAdminSystem:RespX(335), WasiedAdminSystem:RespY(535))
            refundJob:SetLibText(WasiedAdminSystem:Lang(46), color_white)
            refundJob.clicked = false
            refundJob.PaintOver = function(self, w, h)
                if not self.clicked then
                    surface.SetDrawColor(WasiedAdminSystem.Constants["colors"][9])
                    surface.DrawRect(0, 0, w, h)
                end
            end
            refundJob.DoClick = function(self)
                if self.clicked then self.clicked = false else self.clicked = true end
            end

            local refundPM = vgui.Create("WASIED_DButton", rightPanel)
            refundPM:SetSize(WasiedAdminSystem:RespX(150), WasiedAdminSystem:RespY(50))
            refundPM:SetPos(WasiedAdminSystem:RespX(490), WasiedAdminSystem:RespY(535))
            refundPM:SetLibText(WasiedAdminSystem:Lang(58), color_white)
            refundPM.clicked = false
            refundPM.PaintOver = function(self, w, h)
                if not self.clicked then
                    surface.SetDrawColor(WasiedAdminSystem.Constants["colors"][9])
                    surface.DrawRect(0, 0, w, h)
                end
            end
            refundPM.DoClick = function(self)  
                if self.clicked then self.clicked = false else self.clicked = true end
            end

            local send = vgui.Create("DButton", rightPanel)
            send:SetSize(WasiedAdminSystem:RespX(400), WasiedAdminSystem:RespY(35))
            send:SetPos(rightPanel:GetWide()/2-send:GetWide()/2, rightPanel:GetTall()-send:GetTall()-WasiedAdminSystem:RespY(5))
            send:SetText("")
            send.Paint = function(self, w, h)
                draw.SimpleText(WasiedAdminSystem.Constants["strings"][20].." "..WasiedAdminSystem:Lang(57).." "..WasiedAdminSystem.Constants["strings"][20], WasiedAdminSystem:Font(20), w/2, h/2, (self:IsHovered() and WasiedAdminSystem.Constants["colors"][2] or color_white), 1, 1)
            end
            send.DoClick = function(self)
                local selectedTbl = {
                    ["weapon"] = refundWeap.clicked,
                    ["money"] = refundMoney.clicked,
                    ["job"] = refundJob.clicked,
                    ["pm"] = refundPM.clicked
                }

                net.Start("AdminSystem:RefundMenu:RefundThings")
                    net.WriteEntity(selectedPlayer)
                    net.WriteTable(selectedTbl)
                net.SendToServer()
                if IsValid(basicFrame) then basicFrame:Remove() end
            end

        end

        local delete = vgui.Create("DImageButton", plyButton)
        delete:SetSize(WasiedAdminSystem:RespX(15), WasiedAdminSystem:RespY(15))
        delete:SetPos(WasiedAdminSystem:RespX(10), plyButton:GetTall()/2-delete:GetTall()/2)
        delete:SetImage(WasiedAdminSystem.Constants["strings"][9])
        delete.DoClick = function()
            if IsValid(basicFrame) then basicFrame:Remove() end
            if IsValid(selectedPlayer) then selectedPlayer.refundInformations = nil end
        end
    end
end
net.Receive("AdminSystem:RefundMenu:Open", WasiedAdminSystem.OpenRefundMenu)