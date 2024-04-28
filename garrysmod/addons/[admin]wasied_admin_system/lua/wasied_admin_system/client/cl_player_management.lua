local function TranslateDate(val, toTranslate)

    if !isnumber(val) then return "0" end

    if toTranslate == WasiedAdminSystem:Lang(19) then
        return val * 365 * 24 * 60
    elseif toTranslate == WasiedAdminSystem:Lang(20) then
        return val * 30 * 24 * 60
    elseif toTranslate == WasiedAdminSystem:Lang(21) then
        return val * 7 * 24 * 60
    elseif toTranslate == WasiedAdminSystem:Lang(22) then
        return val * 24 * 60
    elseif toTranslate == WasiedAdminSystem:Lang(23) then
        return val * 60
    end
    return val

end

local basicFrame
local banFrame
local infoFrame

function WasiedAdminSystem:RemoveManagementPanels()
    if IsValid(basicFrame) then basicFrame:Remove() end
    if IsValid(banFrame) then banFrame:Remove() end
    if IsValid(infoFrame) then infoFrame:Remove() end
end

WasiedAdminSystem.Config.Buttons = {
    [0] = {
        title = WasiedAdminSystem:Lang(24),
        onClick = function(self)
            local ply = basicFrame.selectedPlayer

            -- if ply == LocalPlayer() then return end
            if IsValid(banFrame) then return banFrame:Remove() end

            banFrame = vgui.Create("WASIED_DFrame")
            banFrame:SetRSize(500, 545)
            banFrame:SetRPos(50, 115)
            banFrame:CloseButton(false)
            banFrame:SetLibTitle(WasiedAdminSystem:Lang(25))
            banFrame.PaintOver = function(self, w, h)
                draw.SimpleText(WasiedAdminSystem:Lang(26), WasiedAdminSystem:Font(25), WasiedAdminSystem:RespX(25), WasiedAdminSystem:RespY(98), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
                draw.SimpleText(WasiedAdminSystem:Lang(27), WasiedAdminSystem:Font(25), WasiedAdminSystem:RespX(25), WasiedAdminSystem:RespY(340), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
                draw.SimpleText(WasiedAdminSystem:Lang(28), WasiedAdminSystem:Font(18), WasiedAdminSystem:RespX(25), WasiedAdminSystem:RespY(357), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
            end

            local reasonEntry = vgui.Create("DTextEntry", banFrame)
            reasonEntry:SetSize(WasiedAdminSystem:RespX(450), WasiedAdminSystem:RespY(200))
            reasonEntry:SetPos(WasiedAdminSystem:RespX(25), WasiedAdminSystem:RespY(100))
            reasonEntry:SetMultiline(true)
            reasonEntry:SetDrawLanguageID(false)
            reasonEntry:SetFont(WasiedAdminSystem:Font(20))
            reasonEntry:SetValue(WasiedAdminSystem:Lang(29))
            reasonEntry.IsSendable = true
            function reasonEntry:OnChange()
                local reason = self:GetValue()
                if string.len(reason) > 2 and string.len(reason) < WasiedAdminSystem.Config.PlayerManagMaxLen then
                    self.IsSendable = true
                else
                    self.IsSendable = false
                end
            end

            local timeEntry = vgui.Create("DTextEntry", banFrame)
            timeEntry:SetSize(WasiedAdminSystem:RespX(335), WasiedAdminSystem:RespY(60))
            timeEntry:SetPos(WasiedAdminSystem:RespX(25), WasiedAdminSystem:RespY(362))
            timeEntry:SetMultiline(true)
            timeEntry:SetNumeric(true)
            timeEntry:SetDrawLanguageID(false)
            timeEntry:SetFont(WasiedAdminSystem:Font(50))
            timeEntry:SetValue(0)
            timeEntry.IsSendable = true
            function timeEntry:OnChange()
                local time = tostring(self:GetValue())
                if string.len(time) > 0 and string.len(time) < WasiedAdminSystem.Constants["strings"][17] then
                    self.IsSendable = true
                else
                    self.IsSendable = false
                end
            end

            local timeOption = vgui.Create("WASIED_DComboBox", banFrame)
            timeOption:SetRSize(110, 60)
            timeOption:SetRPos(375, 362)
            timeOption:SetValue(WasiedAdminSystem:Lang(30))
            timeOption:AddChoice(WasiedAdminSystem:Lang(19))
            timeOption:AddChoice(WasiedAdminSystem:Lang(20))
            timeOption:AddChoice(WasiedAdminSystem:Lang(21))
            timeOption:AddChoice(WasiedAdminSystem:Lang(22))
            timeOption:AddChoice(WasiedAdminSystem:Lang(23))
            timeOption:AddChoice(WasiedAdminSystem:Lang(30))
            timeOption:SetFont(WasiedAdminSystem:Font(21))
            timeOption:SetTextColor(color_white)

            local sendButton = vgui.Create("WASIED_DButton", banFrame)
            sendButton:SetRSize(450, 50)
            sendButton:SetRPos(25, 440)
            sendButton:SetLibText(WasiedAdminSystem:Lang(31), color_white)
            sendButton.DoClick = function(self)
                if not IsValid(ply) then return end
                
                local time = TranslateDate(tonumber(timeEntry:GetValue()), timeOption:GetSelected())
                if timeEntry.IsSendable and reasonEntry.IsSendable then
                    local reason = reasonEntry:GetValue()
                    WasiedAdminSystem:Command(ply, "ban", {time = time, reason = reason})
                    WasiedAdminSystem:AdminLogging(LocalPlayer(), WasiedAdminSystem:Lang(32).." "..ply:Nick().." -> "..reason.." "..WasiedAdminSystem:Lang(33).." "..time.." "..WasiedAdminSystem:Lang(30).." !")
                    WasiedAdminSystem:RemoveManagementPanels()
                else
                    chat.AddText(WasiedAdminSystem.Constants["colors"][3], WasiedAdminSystem.Constants["strings"][4]..WasiedAdminSystem.Constants["strings"][18])
                end
            end

        end,
    },
    [1] = {
        title = WasiedAdminSystem:Lang(35),
        onClick = function(self)
            local ply = basicFrame.selectedPlayer

            -- if ply == LocalPlayer() then return end
            if IsValid(banFrame) then return banFrame:Remove() end

            banFrame = vgui.Create("WASIED_DFrame")
            banFrame:SetRSize(500, 425)
            banFrame:SetRPos(50, 115)
            banFrame:CloseButton(false)
            banFrame:SetLibTitle(WasiedAdminSystem:Lang(25))
            banFrame.PaintOver = function(self, w, h)
                draw.SimpleText(WasiedAdminSystem:Lang(26), WasiedAdminSystem:Font(25), WasiedAdminSystem:RespX(25), WasiedAdminSystem:RespY(108), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
            end

            local reasonEntry = vgui.Create("DTextEntry", banFrame)
            reasonEntry:SetSize(WasiedAdminSystem:RespX(450), WasiedAdminSystem:RespY(200))
            reasonEntry:SetPos(WasiedAdminSystem:RespX(25), WasiedAdminSystem:RespY(110))
            reasonEntry:SetMultiline(true)
            reasonEntry:SetDrawLanguageID(false)
            reasonEntry:SetFont(WasiedAdminSystem:Font(20))
            reasonEntry:SetValue("Non-respect des règles")
            reasonEntry.IsSendable = true
            function reasonEntry:OnChange()
                local reason = self:GetValue()
                if string.len(reason) > 2 and string.len(reason) < WasiedAdminSystem.Config.PlayerManagMaxLen then
                    self.IsSendable = true
                else
                    self.IsSendable = false
                end
            end

            local sendButton = vgui.Create("WASIED_DButton", banFrame)
            sendButton:SetRSize(450, 50)
            sendButton:SetRPos(25, 325)
            sendButton:SetLibText("Sanctionner", color_white)
            sendButton.DoClick = function(s)
                if not IsValid(ply) then return end

                if reasonEntry.IsSendable then
                    local reason = reasonEntry:GetValue()
                    WasiedAdminSystem:Command(ply, "kick", {reason = reason})
                    WasiedAdminSystem:AdminLogging(LocalPlayer(), WasiedAdminSystem:Lang(36).." "..ply:Nick().." -> "..reason.." !")
                    WasiedAdminSystem:RemoveManagementPanels()
                else
                    chat.AddText(WasiedAdminSystem.Constants["colors"][3], WasiedAdminSystem.Constants["strings"][4]..WasiedAdminSystem.Constants["strings"][18])
                end
            end

        end,
    },
    [2] = {
        title = WasiedAdminSystem:Lang(37),
        onClick = function()
            local ply = basicFrame.selectedPlayer
            if IsValid(ply) then
                WasiedAdminSystem:Command(ply, "goto")
            end
        end,
    },
    [3] = {
        title = WasiedAdminSystem:Lang(38),
        onClick = function()
            local ply = basicFrame.selectedPlayer
            if IsValid(ply) then
                WasiedAdminSystem:Command(ply, "teleport")
            end
        end,
    },
    [4] = {
        title = WasiedAdminSystem:Lang(39),
        onClick = function()
            local ply = basicFrame.selectedPlayer
            if IsValid(ply) then
                WasiedAdminSystem:Command(ply, "god")
            end
        end,
    },
    [5] = {
        title = WasiedAdminSystem:Lang(40),
        onClick = function()
            local ply = basicFrame.selectedPlayer
            if IsValid(ply) then
                WasiedAdminSystem:Command(ply, "ungod")
            end
        end,
    },
    [6] = {
        title = WasiedAdminSystem:Lang(41),
        onClick = function()
            local ply = basicFrame.selectedPlayer
            if IsValid(ply) then
                WasiedAdminSystem:Command(ply, "freeze")
            end
        end,
    },
    [7] = {
        title = WasiedAdminSystem:Lang(42),
        onClick = function()
            local ply = basicFrame.selectedPlayer
            if IsValid(ply) then
                WasiedAdminSystem:Command(ply, "unfreeze")
            end
        end,
    },
    [8] = {
        title = WasiedAdminSystem:Lang(43),
        onClick = function()
            local ply = basicFrame.selectedPlayer
            if IsValid(ply) then
                SetClipboardText(ply:SteamID())
                chat.AddText(WasiedAdminSystem.Constants["colors"][3], WasiedAdminSystem:Lang(83).." ("..ply:SteamID()..")")
            end
        end,
    },
    [9] = {
        title = WasiedAdminSystem:Lang(44),
        onClick = function()
            local ply = basicFrame.selectedPlayer
            if IsValid(ply) then
                gui.OpenURL(string.Replace(WasiedAdminSystem.Constants["strings"][18], "STEAMID_HERE", ply:SteamID64()))
            end
        end,
    },
}

function WasiedAdminSystem:OpenManagmentMenu()
    if not WasiedAdminSystem.Config.PlayerManagmentEnabled then return end
	if not LocalPlayer():Alive() then return end
    if not WasiedAdminSystem:CheckStaff(LocalPlayer()) then return end

    basicFrame = vgui.Create("WASIED_DFrame")
	basicFrame:SetRSize(800, 850)
	basicFrame:Center()
    basicFrame:CloseButton(false)
    basicFrame:ReturnAdminButton(true)
    basicFrame.selectedPlayer = nil
	basicFrame:SetLibTitle(WasiedAdminSystem:Lang(12).." "..WasiedAdminSystem:Lang(3).." "..WasiedAdminSystem.Config.ServerName)

    local closeButton = vgui.Create("DImageButton", basicFrame)
	closeButton:SetSize(WasiedAdminSystem:RespX(16), WasiedAdminSystem:RespY(16))
	closeButton:SetPos(basicFrame:GetWide()-closeButton:GetWide()-WasiedAdminSystem:RespX(5), WasiedAdminSystem:RespY(2))
	closeButton:SetText("")
	closeButton:SetImage(WasiedAdminSystem.Constants["strings"][9])
	closeButton.DoClick = function()
		WasiedAdminSystem:RemoveManagementPanels()
	end
    
    local rightPanel = vgui.Create("DPanel", basicFrame)
    rightPanel:SetSize(WasiedAdminSystem:RespX(375), WasiedAdminSystem:RespY(700))
    rightPanel:SetPos(WasiedAdminSystem:RespX(400), WasiedAdminSystem:RespY(100))
    function rightPanel:Paint(w, h)
        surface.SetDrawColor(Color(30, 30, 30, 250))
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(color_white)
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    local leftPanel = vgui.Create("DPanel", basicFrame)
    leftPanel:SetSize(WasiedAdminSystem:RespX(350), WasiedAdminSystem:RespY(700))
    leftPanel:SetPos(WasiedAdminSystem:RespX(25), WasiedAdminSystem:RespY(100))
    function leftPanel:Paint(w, h)
        surface.SetDrawColor(Color(30, 30, 30, 250))
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(color_white)
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    local scrollPanel = vgui.Create("DScrollPanel", leftPanel)
    scrollPanel:Dock(FILL)

    local sbar = scrollPanel:GetVBar()
    function sbar:Paint(w, h)
        surface.SetDrawColor(Color(0, 0, 0))
        surface.DrawRect(0, 0, w, h)
    end
    function sbar.btnUp:Paint(w, h)
        surface.SetDrawColor(Color(30, 30, 30))
        surface.DrawRect(0, 0, w, h)
    end
    function sbar.btnDown:Paint(w, h)
        surface.SetDrawColor(Color(30, 30, 30))
        surface.DrawRect(0, 0, w, h)
    end
    function sbar.btnGrip:Paint(w, h)
        surface.SetDrawColor(Color(30, 30, 30))
        surface.DrawRect(0, 0, w, h)
    end

    for k,v in pairs(player.GetAll()) do
        if not IsValid(v) then continue end
        if basicFrame.selectedPlayer == v then continue end
        
        local plyButton = vgui.Create("DButton", scrollPanel)
        plyButton:SetSize(WasiedAdminSystem:RespX(350), WasiedAdminSystem:RespY(45))
        if k > 1 then plyButton:SetPos(0, WasiedAdminSystem:RespX(45)*(k-1)) end
        plyButton:SetText("")
        function plyButton:Paint(w, h)
            if self:IsHovered() or basicFrame.selectedPlayer == v then
                surface.SetDrawColor(Color(70, 70, 70))
            else
                surface.SetDrawColor(Color(60, 60, 60))
            end

            surface.DrawRect(1, 1, w-2, h-2)

            surface.SetDrawColor(color_white)
            surface.DrawLine(0, h-1, w, h-1)
            
            if IsValid(v) then draw.SimpleText(v:Nick(), WasiedAdminSystem:Font(22), w/2, h/2, color_white, 1, 1) end
        end
        
        local bscrollPanel 
        plyButton.DoClick = function(self)
            if not IsValid(v) then return end
            if v == basicFrame.selectedPlayer then

                if IsValid(infoFrame) then
                    infoFrame:Remove()
                end

                if IsValid(banFrame) then
                    banFrame:Remove()
                end

                if IsValid(bscrollPanel) then 
                    bscrollPanel:Clear() 
                end

                basicFrame.selectedPlayer = nil
            
            else
                basicFrame.selectedPlayer = v

                local selectedPlayer = basicFrame.selectedPlayer
                if not IsValid(selectedPlayer) then return end

                local job = team.GetName(selectedPlayer:Team()) or "N/A"
                local rank = selectedPlayer:GetUserGroup() or "user"
                local money = selectedPlayer:getDarkRPVar("money") or 0
                local health, armor = selectedPlayer:Health(), selectedPlayer:Armor()
                if IsValid(infoFrame) then infoFrame:Remove() end

                infoFrame = vgui.Create("WASIED_DFrame")
                infoFrame:SetRSize(500, 850)
                infoFrame:SetRPos(1370, 115)
                infoFrame:CloseButton(false)
                infoFrame:SetLibTitle(selectedPlayer:Nick())
                infoFrame.PaintOver = function(self, w, h)
                    draw.SimpleText(WasiedAdminSystem:Lang(45).." : "..rank, WasiedAdminSystem:Font(30), w/2, WasiedAdminSystem:RespY(560), color_white, 1, 1)
                    draw.SimpleText(WasiedAdminSystem:Lang(46).." : "..job, WasiedAdminSystem:Font(30), w/2, WasiedAdminSystem:RespY(600), color_white, 1, 1)
                    draw.SimpleText(WasiedAdminSystem:Lang(47).." : "..money..WasiedAdminSystem:Lang(17), WasiedAdminSystem:Font(30), w/2, WasiedAdminSystem:RespY(640), color_white, 1, 1)
                    draw.SimpleText(WasiedAdminSystem:Lang(84).." : "..health..WasiedAdminSystem.Constants["strings"][15], WasiedAdminSystem:Font(30), w/2, WasiedAdminSystem:RespY(680), color_white, 1, 1)
                    draw.SimpleText(WasiedAdminSystem:Lang(85).." : "..armor..WasiedAdminSystem.Constants["strings"][15], WasiedAdminSystem:Font(30), w/2, WasiedAdminSystem:RespY(720), color_white, 1, 1)
                end

                if not IsValid(selectedPlayer) then return end
                local plyMdl = LocalPlayer():GetModel() or LocalPlayer():GetModel()

                local playermodel = vgui.Create("DModelPanel", infoFrame)
                playermodel:SetSize(infoFrame:GetWide(), infoFrame:GetWide())
                playermodel:SetPos(0, WasiedAdminSystem:RespY(50))
                playermodel:SetModel(plyMdl)

                --[[ Right panel ]]--
                if IsValid(bscrollPanel) then bscrollPanel:Clear() end
                bscrollPanel = vgui.Create("DScrollPanel", rightPanel)
                bscrollPanel:Dock(FILL)

                local sbar = bscrollPanel:GetVBar()
                function sbar:Paint(w, h)
                end
                function sbar.btnUp:Paint(w, h)
                end
                function sbar.btnDown:Paint(w, h)
                end
                function sbar.btnGrip:Paint(w, h)
                end

                for key,butt in pairs(WasiedAdminSystem.Config.Buttons) do

                    local commandButton = vgui.Create("WASIED_DButton", bscrollPanel)
                    commandButton:SetRSize(325, 45)
                    commandButton:SetRPos(25, 55*key+25)
                    commandButton:SetLibText(butt.title, color_white)
                    commandButton.DoClick = butt.onClick

                end
            end
        end
    end  
end
net.Receive("AdminSystem:PlayerManag:Open", WasiedAdminSystem.OpenManagmentMenu)