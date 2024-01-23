local THEME = Slawer.Jobs.CFG["Theme"]

local PANEL = {}

function PANEL:Init()
    self:SetSize(ScrH() * 1.3, ScrH() * 0.73)
    self:Center()

    self.dSidebar = vgui.Create("Slawer.Jobs:DScrollPanel", self)
    self.dSidebar:Dock(LEFT)
    self.dSidebar:SetWide(self:GetWide() * 0.25)
    self.dSidebar.VBar:SetWide(0)
    self.dSidebar.iY = -self:GetTall() * 0.1
    function self.dSidebar:Paint(iW, iH)
        draw.RoundedBoxEx(16, 0, 0, iW, iH, THEME.Primary, false, false, true, false)
    end

    self.dSidebar.pnlCanvas.iLerp = self.dSidebar.iY
    function self.dSidebar.pnlCanvas:Paint(iW, iH)
        self.iLerp = Lerp(RealFrameTime() * 10, self.iLerp, self:GetParent().iY)

        surface.SetDrawColor(THEME.Secondary)
        surface.DrawRect(0, self.iLerp, iW, self:GetParent():GetTall() * 0.11)

        surface.SetDrawColor(THEME.Blue)
        surface.DrawRect(0, self.iLerp, iW * 0.02, self:GetParent():GetTall() * 0.11)

    end

    self.dContent = vgui.Create("DPanel", self)
    local dContent = self.dContent
    dContent:SetSize(self:GetWide() * 0.75, 0)
    dContent:SetVisible(false)
    dContent.iModel = 1
    dContent.tModels = {}
    function dContent:Paint(iW, iH)
        draw.RoundedBoxEx(16, 0, 0, iW, iH, THEME.Secondary, false, false, false, true)
    end

    dContent.dModel = vgui.Create("DModelPanel", dContent)
    dContent.dModel:SetSize(self:GetWide() * 0.3, self:GetTall() * 0.91)
    dContent.dModel:SetPos(self:GetWide() * 0.02, 0)
    dContent.dModel:SetFOV(35)
    dContent.dModel:SetCamPos(Vector(85, 0, 50))
    dContent.dModel:SetLookAt(Vector(0, 0, 37.5))
    dContent.dModel:SetAnimated(true)
    dContent.dModel:SetDirectionalLight(BOX_LEFT, color_white)
    dContent.dModel:SetDirectionalLight(BOX_RIGHT, color_white)
    dContent.dModel:SetDirectionalLight(BOX_FRONT, THEME.Secondary)
    dContent.dModel.LerpPos = 0
    function dContent.dModel:LayoutEntity(ent)
        self.LerpPos = Lerp(RealFrameTime()*6, self.LerpPos, self:IsDown() and (self:CursorPos() - 180) or 0)

        ent:SetAngles(Angle(0, self.LerpPos, 0))

        local iSeq = ent:LookupSequence("pose_standing_01")

        if not iSeq then return end

        ent:SetSequence(iSeq)
        if ent:GetCycle() >= 0.98 then ent:SetCycle(0.02) end
        self:RunAnimation()
    end

    local xArrowIcon = Material("materials/slawer/jobs/arrow.png", "smooth")

    dContent.leftArrow = vgui.Create("DButton", dContent)
    dContent.leftArrow:SetSize(self:GetTall() * 0.05, self:GetTall() * 0.05)
    dContent.leftArrow:SetPos(self:GetWide() * 0.025, self:GetTall() * 0.91 * 0.5 - dContent.leftArrow:GetTall() * 0.5 )
    dContent.leftArrow:SetText("")
    function dContent.leftArrow:Paint(iW, iH)
        surface.SetDrawColor(THEME.Texts)
        surface.SetMaterial(xArrowIcon)
        surface.DrawTexturedRectRotated(iW * 0.5, iH * 0.5, iH, iH, 0)
    end
    function dContent.leftArrow:DoClick()
        local dParent = self:GetParent()

        if #dParent.tModels <= 1 then return end
    
        dParent.iModel = dParent.iModel - 1

        if not dParent.tModels[dParent.iModel] then dParent.iModel = #dParent.tModels end

        dParent.dModel:SetModel(dParent.tModels[dParent.iModel])
    end

    dContent.rightArrow = vgui.Create("DButton", dContent)
    dContent.rightArrow:SetSize(self:GetTall() * 0.05, self:GetTall() * 0.05)
    dContent.rightArrow:SetPos(self:GetWide() * 0.278, self:GetTall() * 0.91 * 0.5 - dContent.rightArrow:GetTall() * 0.5 )
    dContent.rightArrow:SetText("")
    function dContent.rightArrow:Paint(iW, iH)
        surface.SetDrawColor(THEME.Texts)
        surface.SetMaterial(xArrowIcon)
        surface.DrawTexturedRectRotated(iW * 0.5, iH * 0.5, iH, iH, 180)
    end
    function dContent.rightArrow:DoClick()
        local dParent = self:GetParent()

        if #dParent.tModels <= 1 then return end
    
        dParent.iModel = dParent.iModel + 1

        if not dParent.tModels[dParent.iModel] then dParent.iModel = 1 end

        dParent.dModel:SetModel(dParent.tModels[dParent.iModel])
    end

    dContent.dInfo = vgui.Create("DPanel", dContent)
    dContent.dInfo:SetSize(self:GetWide() * 0.375, self:GetTall() * 0.90) --Русский Текст
    dContent.dInfo:SetPos(self:GetWide() * 0.71 - dContent.dInfo:GetWide(), self:GetTall() * 0.05)
    dContent.dInfo:DockPadding(0, self:GetTall() * 0.105, 0, 0)
    function dContent.dInfo:Paint(iW, iH)
    end

    local dInfo = dContent.dInfo

    dInfo.dCategory = Label("", dInfo)
    dInfo.dCategory:SetFont("Slawer.Jobs:R20")
    dInfo.dCategory:SetTextColor(THEME.Texts)
    dInfo.dCategory:SetSize(dInfo:GetWide() * 0.75, dInfo:GetTall() * 0.0275)

    dInfo.dSlots = Label("", dInfo)
    dInfo.dSlots:SetFont("Slawer.Jobs:R20")
    dInfo.dSlots:SetTextColor(THEME.Texts)
    dInfo.dSlots:SetContentAlignment(6)
    dInfo.dSlots:SetSize(dInfo:GetWide() * 0.25, dInfo:GetTall() * 0.0275)
    dInfo.dSlots:SetPos(dInfo:GetWide() * 0.75, 0)
    
    dInfo.dName = Label("", dInfo)
    dInfo.dName:SetFont("Slawer.Jobs:SB35")
    dInfo.dName:SetTextColor(THEME.Texts)
    dInfo.dName:SetSize(dInfo:GetWide() * 0.75, dInfo:GetTall() * 0.045)
    dInfo.dName:SetPos(0, dInfo:GetTall() * 0.04)
    
    dInfo.dSalary = Label("", dInfo)
    dInfo.dSalary:SetFont("Slawer.Jobs:SB35")
    dInfo.dSalary:SetTextColor(THEME.Texts)
    dInfo.dSalary:SetContentAlignment(6)
    dInfo.dSalary:SetSize(dInfo:GetWide() * 0.25, dInfo:GetTall() * 0.045)
    dInfo.dSalary:SetPos(dInfo:GetWide() * 0.75, dInfo:GetTall() * 0.04)

    local dInfoScroll = vgui.Create("Slawer.Jobs:DScrollPanel", dInfo)
    dInfoScroll:SetSize(dInfo:GetWide(), dInfo:GetTall() * 0.8)
    dInfoScroll:SetPos(0, dInfo:GetTall() * 0.15)

    dInfo.dWeapons = self:AddInfoField(dInfoScroll, string.upper(Slawer.Jobs:L("weapons")), "materials/slawer/jobs/pistol.png", "")
    dInfo.dRestrictions = self:AddInfoField(dInfoScroll, Slawer.Jobs:L("restrictions"), "materials/slawer/jobs/cross.png", "")
    dInfo.dDescription = self:AddInfoField(dInfoScroll, string.upper(Slawer.Jobs:L("description")), "materials/slawer/jobs/notepad.png", "")

    dContent.dBecome = vgui.Create("Slawer.Jobs:DButton", dContent)
    dContent.dBecome:SetSize(self:GetWide() * 0.375, self:GetTall() * 0.075)
    dContent.dBecome:SetPos(self:GetWide() * 0.335, self:GetTall() * 0.775)
    dContent.dBecome:SetText(Slawer.Jobs:L("become"))
    dContent.dBecome:SetRoundness(0)
    dContent.dBecome:SetFont("Slawer.Jobs:SB35")
    dContent.dBecome.sCmd = -1
    local this = self
    function dContent.dBecome:DoClick()
        if self.sCmd == -1 then return end

        DarkRP.setPreferredJobModel(self.sCmd, dContent.dModel:GetModel())
        Slawer.Jobs:NetStart("ChangeJob", {sCmd = (RPExtraTeams[self.sCmd] or {}).command})
    
        this:Delete()
    end

end

function PANEL:ShowJob(iJob)
    local dContent = self.dContent
    local tJob = RPExtraTeams[iJob]

    if istable(tJob.model) and #tJob.model == 1 then tJob.model = tJob.model[1] end

    local bMultipleModels = istable(tJob.model)


    local tModels = bMultipleModels and tJob.model or {tJob.model}
    local dInfo = dContent.dInfo


    dContent.leftArrow:SetVisible(bMultipleModels)
    dContent.rightArrow:SetVisible(bMultipleModels)

    dContent.tModels = tModels
    dContent.iJob = iJob
    // Model
    dContent.dModel:SetModel(DarkRP.getPreferredJobModel(iJob) or tModels[1])
    // Category
    dInfo.dCategory:SetText(string.upper(tJob.category))
    // Slots
    dInfo.dSlots:SetText(team.NumPlayers(iJob) .. "/" .. (tJob.max == 0 and "∞" or tJob.max))
    // Name
    dInfo.dName:SetText(string.upper(tJob.name))
    // Salary
    dInfo.dSalary:SetText(DarkRP.formatMoney(tJob.salary))

    dInfo.dDescription:SetText(tJob.description)

    // Weapons
    local tWeapons = tJob.weapons
    local sWeapons = ""

    if #tWeapons == 0 then
        sWeapons = Slawer.Jobs:L("none")
    else
        for k, v in pairs(tWeapons) do
            sWeapons = sWeapons .. ", " .. (weapons.Get(v) and weapons.Get(v).PrintName or v)
        end
        sWeapons = string.sub(sWeapons, 3)
    end
    
    dInfo.dWeapons:SetText(sWeapons)


    // Restrictions
    local sRestrict = ""

    // - customCheck
    if tJob.customCheck and not tJob.customCheck(LocalPlayer()) then
        sRestrict = sRestrict .. (tJob.CustomCheckFailMsg or Slawer.Jobs:L("noAccess")) .. "\n"
    end

    // Whitelisting systems
    // TODO : Implement compatibilities

    // - Admin
    if tJob.admin then
        if tJob.admin == 2 and not LocalPlayer():IsSuperAdmin() then 
            sRestrict = sRestrict .. Slawer.Jobs:L("needSuperadmin") .. "\n"
        elseif tJob.admin == 1 and not LocalPlayer():IsAdmin() then
            sRestrict = sRestrict .. Slawer.Jobs:L("needAdmin") .. "\n"
        end
    end

    // - Utime
    if Utime and tJob.utime then
        if tJob.utime > tonumber(LocalPlayer():GetUTime()) then
            sRestrict = sRestrict .. Slawer.Jobs:L("needTime"):format(os.date(Slawer.Jobs.CFG["TimeFormat"], tJob.utime)) .. "\n"
        end
    end

    // - Level
    if LevelSystemConfiguration and tJob.level then
        if tJob.level > LocalPlayer():getDarkRPVar("level") then
            sRestrict = sRestrict .. Slawer.Jobs:L("needLevel"):format(tJob.level) .. "\n"
        end
    end

    // - NeedToChangeFrom
    if tJob.NeedToChangeFrom and tJob.NeedToChangeFrom ~= LocalPlayer():Team()  then
        sRestrict = sRestrict .. Slawer.Jobs:L("needJob"):format(team.GetName(tJob.NeedToChangeFrom)) .. "\n"
    end

    if sRestrict == "" then sRestrict = Slawer.Jobs:L("none") else sRestrict = string.sub(sRestrict, 0, -2) end

    dInfo.dRestrictions:SetText(sRestrict)

    dContent.dBecome.sCmd = iJob

    dContent:SetVisible(true)
end

function PANEL:SetUp(tInfo)
    self:SetTitle(tInfo.sName)

    local tJobs = tInfo.tJobs
    local dActive = nil

    for k, v in pairs(RPExtraTeams) do
        if not tJobs[v.command] then continue end

        local dPanel = vgui.Create("DButton", self.dSidebar)
        dPanel:Dock(TOP)
        dPanel:SetTall(self:GetTall() * 0.1)
        dPanel:SetText("")
        dPanel.xIcon = v.icon and Material(v.icon) or Material("materials/slawer/jobs/person.png", "smooth")
        function dPanel:Paint(iW, iH)
            if dActive ~= self and self.dName:GetTextColor() == THEME.Texts then
                self.dName:SetTextColor(THEME.Texts2)
            end

            surface.SetDrawColor(dActive == self and THEME.Texts or THEME.Texts2)
            surface.SetMaterial(self.xIcon)
            surface.DrawTexturedRect(iW * 0.06, iH * 0.3, iH * 0.4, iH * 0.4)
        end

        dPanel:InvalidateParent(true)

        local dName = Label(v.name, dPanel)
        dPanel.dName = dName
        dName:Dock(FILL)
        dName:DockMargin(self:GetWide() * 0.0525, 0, self:GetWide() * 0.01, 0)
        dName:SetFont("Slawer.Jobs:SB22")
        dName:SetTextColor(THEME.Texts2)

        dPanel.DoClick = function()
            dActive = dPanel

            local iX, iY = dPanel:GetPos()

            self.dSidebar.iY = iY

            dName:SetTextColor(THEME.Texts)

            self:ShowJob(k)        
        end
    end
end

function PANEL:AddInfoField(dPanel, sName, sIcon, sContent)
    local xMat = Material(sIcon, "smooth")

    local dHeader = vgui.Create("DPanel", dPanel)
    dHeader:Dock(TOP)
    dHeader:SetTall(dPanel:GetTall() * 0.05)
    function dHeader:Paint(iW, iH)
        surface.SetDrawColor(THEME.Texts2)
        surface.SetMaterial(xMat)
        surface.DrawTexturedRect(0, 0, iH, iH)

        draw.SimpleText(sName, "Slawer.Jobs:SB22", iH + iH * 0.5, iH * 0.5, THEME.Texts2, 0, 1)
    end

    local dLbl = Label(sContent, dPanel)
    dLbl:Dock(TOP)
    dLbl:DockMargin(0, dHeader:GetTall() * 0.5, 0, dHeader:GetTall() * 1.5)
    dLbl:SetAutoStretchVertical(true)
    dLbl:SetWrap(true)
    dLbl:SetFont("Slawer.Jobs:R22")
    dLbl:SetTextColor(THEME.Texts)

    return dLbl
end

function PANEL:PerformLayout2(iW, iH)
    self:DockPadding(0, self.iHeaderH, 0, 0)
    self.dContent:SetTall(iH - self.iHeaderH)
    self.dContent:SetPos(iW * 0.25, self.iHeaderH)
end

vgui.Register("Slawer.Jobs:NPCMenu", PANEL, "Slawer.Jobs:EditablePanel")