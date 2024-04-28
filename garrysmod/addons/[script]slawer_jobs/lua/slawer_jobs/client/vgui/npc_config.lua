local THEME = Slawer.Jobs.CFG["Theme"]

local PANEL = {}

function PANEL:Init()
    self:SetSize(ScrH() * 0.35, ScrH() * 0.5)
    self:Center()
    self:SetTitle(Slawer.Jobs:L("npcConfig"))
end

function PANEL:SetJobs(tInfo)
    self.dContent = vgui.Create("Slawer.Jobs:DScrollPanel", self)
    self.dContent:Dock(FILL)
    self.dContent.Paint = nil

    self.dName = vgui.Create("Slawer.Jobs:DTextEntry", self.dContent)
    self.dName:Dock(TOP)
    self.dName:SetTall(self:GetTall() * 0.1)
    self.dName:DockMargin(0, 0, 0, self:GetTall() * 0.03)
    self.dName:SetTitle(Slawer.Jobs:L("name"))
    function self.dName:Validation(sText)
        if string.Replace(sText, " ", "") == "" then return false end
        if string.len(sText) < 3 then return false end
        if string.len(sText) > 30 then return false end

        return true
    end
    self.dName:SetText(tInfo.sName or "")

    self.dModel = vgui.Create("Slawer.Jobs:DTextEntry", self.dContent)
    self.dModel:Dock(TOP)
    self.dModel:SetTall(self:GetTall() * 0.1)
    self.dModel:DockMargin(0, 0, 0, self:GetTall() * 0.03)
    self.dModel:SetTitle(Slawer.Jobs:L("model"))
    function self.dModel:Validation(sText)
        if string.Replace(sText, " ", "") == "" then return false end
        if not file.Exists(sText, "GAME") or file.IsDir(sText, "GAME") then return false end

        return true
    end
    self.dModel:SetText((LocalPlayer():GetEyeTrace().Entity or LocalPlayer()):GetModel())

    self.dJobsLbl = Label(Slawer.Jobs:L("jobs"), self.dContent)
    self.dJobsLbl:Dock(TOP)
    self.dJobsLbl:SetFont("Slawer.Jobs:R20")
    self.dJobsLbl:DockMargin(0, 0, 0, self:GetTall() * 0.01)

    local tJobs = tJobs or {}

    for k, v in pairs(RPExtraTeams) do
        local dJob = vgui.Create("DButton", self.dContent)
        dJob:Dock(TOP)
        dJob:SetTall(self:GetTall() * 0.05)
        dJob:DockMargin(0, 0, 0, self:GetTall() * 0.01)
        dJob:SetText("")
        dJob.fLerp = 0
        dJob.bChecked = tInfo.tJobs[v.command]

        local dName = Label(v.name, dJob)
        dName:Dock(FILL)
        dName:SetFont("Slawer.Jobs:R20")
        
        function dJob:DoClick()
            self.bChecked = not self.bChecked
            tInfo.tJobs[v.command] = (self.bChecked and true or nil)
        end
        function dJob:Paint(iW, iH)
            self.fLerp = Lerp(RealFrameTime() * 8, self.fLerp, self.bChecked and iW or 0)

            dName:SetTextInset(iW * 0.03 - self.fLerp * 0.015, 0)

            surface.SetDrawColor(THEME.Primary)
            surface.DrawRect(0, 0, iW, iH)

            surface.SetDrawColor(THEME.Quaternary)
            surface.DrawRect(0, 0, iW * 0.01 + self.fLerp, iH)
        end
    end

    self.dSubmit = vgui.Create("Slawer.Jobs:DButton", self)
    self.dSubmit:Dock(BOTTOM)
    self.dSubmit:SetTall(self:GetTall() * 0.07)
    self.dSubmit:SetText(Slawer.Jobs:L("save"))
    function self.dSubmit:DoClick()
        self:GetParent():Delete()

        Slawer.Jobs:NetStart("SaveNPCJobs", {tJobs = tInfo.tJobs, sName = self:GetParent().dName:GetText(), sModel = self:GetParent().dModel:GetText()})
    end

    self.dDelete = vgui.Create("Slawer.Jobs:DButton", self)
    self.dDelete:Dock(BOTTOM)
    self.dDelete:SetTall(self:GetTall() * 0.07)
    self.dDelete:SetText(Slawer.Jobs:L("delete"))
    self.dDelete:SetBackgroundColor(THEME.Primary)
    function self.dDelete:DoClick()
        self:GetParent():Delete()

        Slawer.Jobs:NetStart("DeleteNPCJobs")
    end
end

function PANEL:PerformLayout2(iW, iH)
    self.dContent:DockMargin(iW * 0.05, self.iHeaderH + iH * 0.03, iW * 0.05, iH * 0.03)
end

vgui.Register("Slawer.Jobs:NPCConfigMenu", PANEL, "Slawer.Jobs:EditablePanel")