local THEME = Slawer.Jobs.CFG["Theme"]

local color_red = Color(255, 0, 0)

local function addTextInput(dParent, sTitle, bNecessary)
    local dInput = dParent:Add("Slawer.Jobs:DTextEntry")
    dInput:SetTitle(sTitle .. (bNecessary and " *" or ""))
    dInput:SetSize(dParent:GetWide() * 0.48, dParent:GetTall() * 0.1)
    dInput.dEntry.customMargin = 0
    dInput.dValidator:Remove()

    return dInput
end

local function addChoiceInput(dParent, sTitle, bNecessary)
    local dInput = dParent:Add("Slawer.Jobs:DComboBox")
    dInput:SetTitle(sTitle .. (bNecessary and " *" or ""))
    dInput:SetSize(dParent:GetWide() * 0.48, dParent:GetTall() * 0.1)

    return dInput
end

local function addCheckBoxInput(dParent, sTitle, bNecessary)
    local dInput = dParent:Add("Slawer.Jobs:DCheckLabel")
    dInput:SetSize(dParent:GetWide() * 0.305, dParent:GetTall() * 0.05)
    dInput.dLabel:SetText(sTitle)

    return dInput
end

local function addTitle(dParent, sTitle)
    local dTitle = dParent:Add("DLabel")
    dTitle:SetText(sTitle)
    dTitle:SetFont("Slawer.Jobs:R20")
    dTitle:SetSize(dParent:GetWide(), dParent:GetTall() * 0.03)
    dTitle:SetTextColor(color_white)
end

local PANEL = {}

function PANEL:Init()
    self:SetSize(ScrH() * 1, ScrH() * 0.7)
    self:Center()

    self:SetTitle(Slawer.Jobs:L("darkRPJobs"))

    self.dActualJobs = vgui.Create("Slawer.Jobs:DScrollPanel", self)
    self.dActualJobs:SetSize(self:GetWide() * 0.34, self:GetTall() * 0.75)
    self.dActualJobs:SetPos(self:GetWide() * 0.02, self:GetTall() * 0.12)

    self.dRightPanel = vgui.Create("Slawer.Jobs:DScrollPanel", self)
    self.dRightPanel:SetSize(self:GetWide() * 0.6, self:GetTall() * 0.75)
    self.dRightPanel:SetPos(self:GetWide() * 0.38, self:GetTall() * 0.12)

    self.dRightLayout = vgui.Create("DIconLayout", self.dRightPanel)
    self.dRightLayout:SetSize(self:GetWide() * 0.6 - 15, self:GetTall() * 0.75)
    self.dRightLayout:SetSpaceX(self.dRightLayout:GetWide() * 0.04)
    self.dRightLayout:SetSpaceY(self.dRightLayout:GetTall() * 0.02)

    self.tJob = {}

    local tJob = self.tJob

    // Name
    tJob.name = addTextInput(self.dRightLayout, Slawer.Jobs:L("name"), true)
    // TeamID
    tJob.teamID = addTextInput(self.dRightLayout, Slawer.Jobs:L("teamID"), true)
    // Command
    tJob.command = addTextInput(self.dRightLayout, Slawer.Jobs:L("command"), true)

    // Category
    tJob.category = addChoiceInput(self.dRightLayout, Slawer.Jobs:L("category"))
    tJob.category:AddChoice(Slawer.Jobs:L("none"), nil, true)
    for k, v in pairs(DarkRP.getCategories().jobs) do
        tJob.category:AddChoice(v.name, v.name)
    end

    // Need To Change From
    tJob.NeedToChangeFrom = addTextInput(self.dRightLayout, Slawer.Jobs:L("needToChangeFrom"))

    // Admin
    tJob.admin = addChoiceInput(self.dRightLayout, Slawer.Jobs:L("adminRank"), true)
    tJob.admin:AddChoice(Slawer.Jobs:L("none"), 0, true)
    tJob.admin:AddChoice("admin", 1)
    tJob.admin:AddChoice("superadmin", 2)

    // Salary
    tJob.salary = addTextInput(self.dRightLayout, Slawer.Jobs:L("salary"), true)
    // Max
    tJob.max = addTextInput(self.dRightLayout, Slawer.Jobs:L("max"), true)

    // Description
    tJob.description = addTextInput(self.dRightLayout, Slawer.Jobs:L("description"), true)
    tJob.description:SetWide(self.dRightLayout:GetWide())

    // Color
    tJob.colorDisplay = addTextInput(self.dRightLayout, Slawer.Jobs:L("color"), true)
    tJob.colorDisplay:SetWide(self.dRightLayout:GetWide())
    tJob.colorDisplay.dEntry:SetEditable(false)
    tJob.colorDisplay.dEntry.cBackground = Color(255, 0, 0)

    tJob.color = self.dRightLayout:Add("DColorMixer")
    tJob.color:SetWide(self.dRightLayout:GetWide())
    tJob.color:SetTall(self.dRightLayout:GetTall() * 0.2)
    tJob.color:SetPalette(false)
    tJob.color:SetAlphaBar(false)
    tJob.color:SetWangs(true)
    tJob.color.ValueChanged = function(_, col)
        tJob.colorDisplay.dEntry.cBackground = col
    end


    // Model
    addTitle(self.dRightLayout, Slawer.Jobs:L("model"))

    tJob.dModelsScroll = self.dRightLayout:Add("Slawer.Jobs:DScrollPanel")
    tJob.dModelsScroll:SetSize(self.dRightLayout:GetWide(), self.dRightLayout:GetTall() * 0.4)

    tJob.dModelsList = vgui.Create("DIconLayout", tJob.dModelsScroll)
    tJob.dModelsList:SetSize(tJob.dModelsScroll:GetWide() - 15, tJob.dModelsScroll:GetTall() * 0.75)

    tJob.model = {}

    for k, v in pairs(player_manager.AllValidModels()) do
        local dMdl = tJob.dModelsList:Add("SpawnIcon")
        dMdl:SetSize(tJob.dModelsScroll:GetTall() * 0.25, tJob.dModelsScroll:GetTall() * 0.25)
        dMdl:SetModel(v)
        dMdl:SetTooltip(v)
        function dMdl:PaintOver(iW, iH)
            if tJob.model[v] then
                surface.SetDrawColor(THEME.Blue)
                surface.DrawLine(0, iH - 1, iW, iH - 1)
            else
                surface.SetDrawColor(ColorAlpha(THEME.Primary, 200))
                surface.DrawRect(0, 0, iW, iH)
            end
        end
        function dMdl:OnMousePressed()
            if tJob.model[v] then tJob.model[v] = nil else tJob.model[v] = true end
        end
    end

    // Weapons
    addTitle(self.dRightLayout, Slawer.Jobs:L("weapons"))

    tJob.dWeaponsScroll = self.dRightLayout:Add("Slawer.Jobs:DScrollPanel")
    tJob.dWeaponsScroll:SetSize(self.dRightLayout:GetWide(), self.dRightLayout:GetTall() * 0.4)

    tJob.dWeaponsList = vgui.Create("DIconLayout", tJob.dWeaponsScroll)
    tJob.dWeaponsList:SetSize(tJob.dWeaponsScroll:GetWide() - 15, tJob.dWeaponsScroll:GetTall() * 0.75)

    tJob.weapons = {}

    for k, v in pairs(list.Get("Weapon")) do
        local tWeap = weapons.Get(k)

        if not tWeap then continue end

        local sModel = ""
        if tWeap then
            if tWeap.WorldModel then
                sModel = tWeap.WorldModel
            elseif tWeap.Base then
                if tWeap.Base.WorldModel then
                    sModel = tWeap.Base.WorldModel
                end
            end
        end

        local dMdl = tJob.dWeaponsList:Add("SpawnIcon")
        dMdl:SetSize(tJob.dWeaponsScroll:GetTall() * 0.25, tJob.dWeaponsScroll:GetTall() * 0.25)
        dMdl:SetModel(sModel)
        dMdl:SetTooltip(k)
        function dMdl:Paint(iW, iH)
            if tJob.weapons[k] then
                surface.SetDrawColor(ColorAlpha(THEME.Primary, 150))
                surface.DrawRect(4, 4, iW - 8, iH - 8)

                surface.SetDrawColor(THEME.Blue)
                surface.DrawLine(4, iH - 4, iW - 4, iH - 4)
            end
        end
        function dMdl:PaintOver() end
        function dMdl:OnMousePressed()
            if tJob.weapons[k] then tJob.weapons[k] = nil else tJob.weapons[k] = true end
        end
    end

    tJob.customCheck = addTextInput(self.dRightLayout, Slawer.Jobs:L("customCheck"))
    tJob.CustomCheckFailMsg = addTextInput(self.dRightLayout, Slawer.Jobs:L("customCheckFailMessage"))

    tJob.mayor = addCheckBoxInput(self.dRightLayout, Slawer.Jobs:L("mayor"))
    tJob.chief = addCheckBoxInput(self.dRightLayout, Slawer.Jobs:L("chief"))
    tJob.medic = addCheckBoxInput(self.dRightLayout, Slawer.Jobs:L("medic"))
    tJob.cook = addCheckBoxInput(self.dRightLayout, Slawer.Jobs:L("cook"))
    tJob.hobo = addCheckBoxInput(self.dRightLayout, Slawer.Jobs:L("hobo"))
    tJob.hitman = addCheckBoxInput(self.dRightLayout, Slawer.Jobs:L("hitman"))

    tJob.vote = addCheckBoxInput(self.dRightLayout, Slawer.Jobs:L("vote"), true)
    tJob.hasLicense = addCheckBoxInput(self.dRightLayout, Slawer.Jobs:L("hasGunLicense"), true)
    tJob.candemote = addCheckBoxInput(self.dRightLayout, Slawer.Jobs:L("canDemote"), true)

    tJob.icon = addTextInput(self.dRightLayout, Slawer.Jobs:L("icon"))
    tJob.icon:SetWide(self.dRightLayout:GetWide())

    if Utime then
        tJob.utime = addTextInput(self.dRightLayout, "UTime (" .. Slawer.Jobs:L("seconds") .. ")")
    end

    if LevelSystemConfiguration then
        tJob.level = addTextInput(self.dRightLayout, "DarkRP Leveling System")
    end

    for k, v in pairs(Slawer.Jobs.List or {}) do
        local dJob = vgui.Create("DPanel", self.dActualJobs)
        dJob:Dock(TOP)
        dJob:SetTall(self.dActualJobs:GetTall() * 0.118)
        dJob:DockMargin(0, 0, 0, self.dActualJobs:GetTall() * 0.03)
        function dJob:Paint(iW, iH)
            surface.SetDrawColor(THEME.Primary)
            surface.DrawRect(0, 0, iW, iH)
        end

        local dIcon = vgui.Create("SpawnIcon", dJob)
        dIcon:Dock(LEFT)
        dIcon:SetWide(self.dActualJobs:GetTall() * 0.118)
        dIcon:SetModel(istable(v.model) and v.model[1] or v.model)
        dIcon:SetTooltip()
        function dIcon:PaintOver()end        
        function dIcon:OnMousePressed()end 

        local dName = Label(v.name, dJob)
        dName:SetPos(self.dActualJobs:GetTall() * 0.14, 0)
        dName:SetFont("Slawer.Jobs:SB30")
        dName:SetSize(self.dActualJobs:GetWide() * 0.72, dJob:GetTall() * 0.6)

        local dEdit = vgui.Create("DImageButton", dJob)
        dEdit:SetImage("materials/slawer/jobs/pen.png")
        dEdit:SetSize(dJob:GetTall() * 0.3, dJob:GetTall() * 0.3)
        dEdit:SetPos(self.dActualJobs:GetTall() * 0.14, dJob:GetTall() * 0.6)
        dEdit:SetTooltip(Slawer.Jobs:L("edit"))
        dEdit:SetColor(THEME.Texts2)
        dEdit.DoClick = function()
            self:SetCurrentJob(k)
        end

        local dDelete = vgui.Create("DImageButton", dJob)
        dDelete:SetImage("materials/slawer/jobs/cross.png")
        dDelete:SetSize(dJob:GetTall() * 0.22, dJob:GetTall() * 0.22)
        dDelete:SetPos(self.dActualJobs:GetTall() * 0.14 + dJob:GetTall() * 0.4, dJob:GetTall() * 0.65)
        dDelete:SetTooltip(Slawer.Jobs:L("delete"))
        dDelete:SetColor(THEME.Texts2)
        dDelete.DoClick = function()
            Slawer.Jobs:NetStart("AskForDeleteDarkRPJob", {sTeam = k})
            self:Delete()
        end
    end

    self.dNew = vgui.Create("Slawer.Jobs:DButton", self)
    self.dNew:SetSize(self:GetWide() * 0.34, self:GetTall() * 0.07)
    self.dNew:SetPos(self:GetWide() * 0.02, self:GetTall() * 0.9)
    self.dNew:SetText(Slawer.Jobs:L("createANewJob"))
    self.dNew:SetFont("Slawer.Jobs:SB22")
    self.dNew:SetBackgroundColor(THEME.Primary)
    self.dNew.DoClick = function()
        self:SetCurrentJob("")
    end

    self.dSubmitBtn = vgui.Create("Slawer.Jobs:DButton", self)
    self.dSubmitBtn:SetSize(self:GetWide() * 0.6, self:GetTall() * 0.07)
    self.dSubmitBtn:SetPos(self:GetWide() * 0.38, self:GetTall() * 0.9)
    self.dSubmitBtn:SetText(Slawer.Jobs:L("createSaveJob"))
    self.dSubmitBtn:SetFont("Slawer.Jobs:SB22")
    self.dSubmitBtn.DoClick = function()
        self:SaveCurrent()
    end
end

function PANEL:SetCurrentJob(sTeam)
    local tJob = self.tJob
    local tDRPJob = Slawer.Jobs.List[sTeam] or {}

    tJob.name:SetText(tDRPJob.name or "")
    tJob.teamID:SetText(sTeam or "")
    tJob.command:SetText(tDRPJob.command or "")

    if tDRPJob.category then
        for k, v in pairs(tJob.category.dCombo.Choices) do
           if v ==  tDRPJob.category then
                tJob.category.dCombo:ChooseOptionID(k)
                break
           end
        end
    else
        tJob.category.dCombo:ChooseOptionID(1)
    end

    tJob.NeedToChangeFrom:SetText(tDRPJob.NeedToChangeFrom or "")

    tJob.admin.dCombo:ChooseOptionID((tDRPJob.admin or 0) + 1)
    tJob.salary:SetText(tDRPJob.salary or "")
    tJob.max:SetText(tDRPJob.max or "")
    tJob.description:SetText(tDRPJob.description or "")
    tJob.color:SetColor(tDRPJob.color or color_red)

    local tNewModel = {}
    tDRPJob.model = istable(tDRPJob.model) and tDRPJob.model or {tDRPJob.model}
    for k, v in pairs(tDRPJob.model or {}) do
        tNewModel[v] = true
    end

    tJob.model = tNewModel
    
    local tNewWeapons = {}
    for k, v in pairs(tDRPJob.weapons or {}) do
        tNewWeapons[v] = true
    end

    tJob.weapons = tNewWeapons

    tJob.customCheck:SetText(tDRPJob.customCheck or "")
    tJob.CustomCheckFailMsg:SetText(tDRPJob.CustomCheckFailMsg or "")

    tJob.mayor:SetChecked(tDRPJob.mayor or false)
    tJob.chief:SetChecked(tDRPJob.chief or false)
    tJob.medic:SetChecked(tDRPJob.medic or false)
    tJob.cook:SetChecked(tDRPJob.cook or false)
    tJob.hobo:SetChecked(tDRPJob.hobo or false)
    tJob.hitman:SetChecked(tDRPJob.hitman or false)
    tJob.vote:SetChecked(tDRPJob.vote or false)
    tJob.hasLicense:SetChecked(tDRPJob.hasLicense or false)
    tJob.candemote:SetChecked(tDRPJob.candemote or false)

    tJob.icon:SetText(tDRPJob.icon or "")
    if IsValid(tJob.utime) and tDRPJob.utime then tJob.utime:SetText(tDRPJob.utime) end
    if IsValid(tJob.level) and tDRPJob.level then tJob.level:SetText(tDRPJob.level) end
end

function PANEL:SaveCurrent()
    local tJob = self.tJob

    local tModel = {}
    for k, v in pairs(tJob.model) do
        table.insert(tModel, k)
    end

    local tWeapons = {}
    for k, v in pairs(tJob.weapons) do
        table.insert(tWeapons, k)
    end

    // Generate Final Table
    local tJob = {
        name = tJob.name:GetText(),
        command = tJob.command:GetText(),
        salary = tJob.salary:GetText(),
        max = tJob.max:GetText(),
        color = tJob.color:GetColor(),
        description = tJob.description:GetText(),
        category = select(2, tJob.category:GetSelected()),
        admin = select(2, tJob.admin:GetSelected()),
        NeedToChangeFrom = tJob.NeedToChangeFrom:GetText() == "" and nil or tJob.NeedToChangeFrom:GetText(),
        model = tModel,
        weapons = tWeapons,
        
        mayor = tJob.mayor:GetChecked(),
        chief = tJob.chief:GetChecked(),
        medic = tJob.medic:GetChecked(),
        cook = tJob.cook:GetChecked(),
        hobo = tJob.hobo:GetChecked(),
        hitman = tJob.hitman:GetChecked(),

        vote = tJob.vote:GetChecked(),
        hasLicense = tJob.hasLicense:GetChecked(),
        candemote = tJob.candemote:GetChecked(),
        
        customCheck = tJob.customCheck:GetText(),
        CustomCheckFailMsg = tJob.CustomCheckFailMsg:GetText(),

        utime = (IsValid(tJob.utime) and tJob.utime:GetText() ~= "") and tJob.utime:GetText() or nil,
        level = (IsValid(tJob.level) and tJob.utime:GetText() ~= "") and tJob.level:GetText() or nil,
        icon = tJob.icon:GetText(),
    }


    Slawer.Jobs:NetStart("SaveDarkRPJob", { sTeam = self.tJob.teamID:GetText(), tJob = tJob })

    self:Delete()
end

function PANEL:PerformLayout2(iW, iH)
end

vgui.Register("Slawer.Jobs:DarkRPJobs", PANEL, "Slawer.Jobs:EditablePanel")