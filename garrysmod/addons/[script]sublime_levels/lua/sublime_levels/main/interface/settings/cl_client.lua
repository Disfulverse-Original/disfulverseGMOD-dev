--[[
local panel = {};

local approach = math.Approach;

function panel:CreateCategory(category, data)
    local nextCategory = #self.Categories + 1;
    local dataCount = table.Count(data);

    self.Categories[nextCategory] = self.ScrollPanel:Add("DPanel");
    local cat = self.Categories[nextCategory];

    cat.Items = {};
    cat.Name = category:gsub("^%l", string.upper);
    cat.Dropped = true;
    cat.Tall = 30 + (65 * dataCount);
    cat.FirstTall = cat.Tall;

    cat.Paint = function(panel, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(0, 0, 0, 100));
        
        Sublime:DrawTextOutlined(panel.Name, "Sublime.22", 5, 15, Sublime.Colors.White, Sublime.Colors.Black, TEXT_ALIGN_LEFT, true);
    end

    cat.PerformLayout = function(panel, w, h)
        for i = 1, #panel.Items do
            local item = panel.Items[i];

            if (IsValid(item)) then
                item:SetPos(5, 30 + 65 * (i - 1));
                item:SetSize(w - 10, 60);
            end
        end

        panel.DropDown:SetPos(w - 30, 3);
        panel.DropDown:SetSize(24, 24);
    end

    cat.AddItem = function(name, value)
        local nextItem = #cat.Items + 1;

        cat.Items[nextItem] = cat:Add("DPanel");
        local setting = cat.Items[nextItem];

        setting.Paint = function(panel, w, h)
            draw.RoundedBox(8, 0, 0, w, h, self.CA(self.C.Outline, 100));

            Sublime:DrawTextOutlined(self.L(name), "Sublime.20", 10, 13, Sublime.Colors.White, Sublime.Colors.Black, TEXT_ALIGN_LEFT, true);
        end

        setting.PerformLayout = function(panel, w, h)
            if (IsValid(panel.Edit)) then
                panel.Edit:SetPos(10, h - 35);
                panel.Edit:SetSize(w - 20, 30)
            end
        end

        if (isbool(value) or (category == "interface" and name == "menu_open")) then
            setting.Edit = setting:Add("DButton");
            setting.Edit:SetText("");
            setting.Edit:SetCursor("arrow");

            setting.Edit.Alpha = 100;
            setting.Edit.Enabled = value;
            setting.Edit.Editing = false;

            if (isnumber(value)) then
                self.Key = value;
                self.KeyPanel = setting.Edit;
            end

            setting.Edit.Paint = function(panel, w, h)
                draw.RoundedBox(8, 0, 0, w, h, Color(0, 0, 0, panel.Alpha));

                panel.Alpha = Sublime:DoHoverAnim(panel, panel.Alpha, {150, 2}, {100, 2});

                local str, color = "Unknown", self.C.White;

                if (isnumber(value) and self.Key) then
                    str   = input.GetKeyName(self.Key):upper();
                    color = self.C.White;
                else
                    str   = panel.Enabled and "Yes" or "No";
                    color = panel.Enabled and self.C.Green or self.C.Red;
                end

                if (panel.Editing) then
                    Sublime:DrawTextOutlined("PRESS A KEY", "Sublime.18", w / 2, h / 2, color, Sublime.Colors.Black, TEXT_ALIGN_CENTER, true);
                else
                    Sublime:DrawTextOutlined(str, "Sublime.18", w / 2, h / 2, color, Sublime.Colors.Black, TEXT_ALIGN_CENTER, true);
                end
            end

            setting.Edit.DoClick = function(panel)
                if (isnumber(value)) then
                    input.StartKeyTrapping()

                    panel.Editing = true;
                    self.Trapping = true;
                else
                    panel.Enabled = not panel.Enabled;
                    Sublime.Settings.Set(category, name, panel.Enabled);
                end
            end
        else
            setting.Edit = setting:Add("DTextEntry");
            setting.Edit:SetDrawLanguageID(false);
            setting.Edit:SetFont("Sublime.18");
            setting.Edit.Paint = function(panel, w, h)
                draw.RoundedBox(8, 0, 0, w, h, Color(0, 0, 0, 100));
                panel:DrawTextEntryText(self.C.Grey, self.C.Grey, self.C.Grey);
            end

            setting.Edit.OnEnter = function()
                local value = setting.Edit:GetValue();

                if (not value or value == "" or not isnumber(tonumber(value))) then
                    return;
                end

                Sublime.Settings.Set(category, name, tonumber(value));
            end

            setting.Edit:SetValue(value);
        end
    end

    cat.DropDown = cat:Add("DButton");
    cat.DropDown:SetText("");
    cat.DropDown:SetCursor("arrow");

    cat.DropDown.IconSize = 18;
    cat.DropDown.CurrentRotation = 90;

    cat.DropDown.Paint = function(panel, w, h)
        Sublime:DrawMaterialRotatedOutline(w / 2, h / 2, panel.IconSize, panel.IconSize, Sublime.Materials["SL_LeftArrow"], self.C.Black, self.C.White, panel.CurrentRotation);
        
        if (cat.Dropped) then
            if (panel.CurrentRotation > 90) then
                panel.CurrentRotation = approach(panel.CurrentRotation, 90, 4);
            end
        else
            if (panel.CurrentRotation < 180) then
                panel.CurrentRotation = approach(panel.CurrentRotation, 180, 4);
            end
        end
    end

    cat.DropDown.DoClick = function()
        cat.Dropped = not cat.Dropped;

        self:InvalidateLayout(false);
    end

    for k, v in pairs(data) do
        cat.AddItem(k, v);
    end

    return cat;
end

function panel:CreateCategories(refresh)
    if (refresh) then
        self.ScrollPanel:Clear();
        table.Empty(self.Categories);

        self:AddResetButton();
    end

    local settings = util.JSONToTable(file.Read("sublime_levels_settings.txt", "DATA"));
    for category, data in pairs(settings) do
        self:CreateCategory(category, data)
    end
end

function panel:AddResetButton()
    self.SetDefault = self.ScrollPanel:Add("DButton");
    self.SetDefault.Alpha = 50;
    self.SetDefault:SetText("");
    self.SetDefault.Paint = function(panel, w, h)
        local color1 = self.CA(Sublime:LightenColor(self.C.Red, 50), panel.Alpha);

        draw.RoundedBox(8, 0, 0, w, h, color1);
        Sublime:DrawTextOutlined(self.L("client_default"), "Sublime.20", w / 2, h / 2, Sublime.Colors.White, Sublime.Colors.Black, TEXT_ALIGN_CENTER, true);
    
        panel.Alpha = Sublime:DoHoverAnim(panel, panel.Alpha, {100, 2}, {50, 2});
    end
    
    self.SetDefault.DoClick = function()
        Sublime.Settings.Reset();
        self:CreateCategories(true);
    end
end

---
--- Init
---
function panel:Init()
    self.L  = Sublime.L;
    self.C  = Sublime.Colors;
    self.CA = ColorAlpha;

    self.Key = 0;
    self.KeyPanel = nil;

    self.Categories = {};

    self.ScrollPanel = self:Add("DScrollPanel");
    local vBar = self.ScrollPanel:GetVBar();

    vBar:SetHideButtons(true);
    
    vBar.Color = Color(0, 0, 0, 50);
    vBar.Paint = function(panel, w, h)
        draw.RoundedBox(8, 2, 0, w - 4, h, panel.Color);    
    end

    vBar.btnGrip.Alpha = 25;
    vBar.btnGrip.Paint = function(panel, w, h)
        draw.RoundedBox(8, 2, 0, w - 4, h, self.C.Outline);

        panel.Alpha = Sublime:DoHoverAnim(panel, panel.Alpha, {75, 2}, {25, 2}, panel:GetParent().Dragging); 
    end

    self:CreateCategories();
    self:AddResetButton();
end

---
--- OnKeyCodePressed
---
function panel:Think()
    if (input.IsKeyTrapping() and self.Trapping) then
        local code = input.CheckKeyTrapping();

        if (code) then
            if (code == KEY_ESCAPE) then
                self.Trapping = false;
                self.KeyPanel.Editing = false;
            else
                self.Key = code;

                Sublime.Settings.Set("interface", "menu_open", code);
                self.Trapping = false;
                self.KeyPanel.Editing = false;
            end
        end
    end
end

---
--- OnRemove
---
function panel:OnRemove()
    Sublime.Settings.Save();
end

---
--- PerformLayout
---
function panel:PerformLayout(w, h)
    self.ScrollPanel:SetPos(0, 0);
    self.ScrollPanel:SetSize(w, h - 5);

    local yPos      = 5;
    local size      = self.ScrollPanel:GetVBar().Enabled and 20 or 10
    local padding   = 5;

    for i = 1, #self.Categories do
        local item = self.Categories[i];

        if (IsValid(item)) then
            local count     = table.Count(item.Items);
            local height    = item.Dropped and (30 + (65 * count)) or 30;

            item:SetPos(5, yPos);
            item:SetSize((w - padding) - size, height);

            yPos = yPos + (height + padding);
        end
    end

    self.SetDefault:SetPos(5, yPos);
    self.SetDefault:SetSize((w - padding) - size, 30);
end

---
--- Paint
---
function panel:Paint(w, h)

end
vgui.Register("Sublime.OptionsClient", panel, "EditablePanel");
--]]