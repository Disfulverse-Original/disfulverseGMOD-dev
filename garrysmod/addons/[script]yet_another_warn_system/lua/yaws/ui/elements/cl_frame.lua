-- woah wtf im not copying and pasting elements directly over from other addons
-- of mine for once? whaa
local PANEL = {}

AccessorFunc(PANEL, "master", "MasterPanel")
AccessorFunc(PANEL, "sidebar", "Sidebar")

function PANEL:SetupSideBar(close)
    self.sidebar = vgui.Create("yaws.sidebar", self)
    -- self.sidebar:NoShadows()
    
    self.master = vgui.Create("DPanel", self)
    self.master.Paint = function() end
    
    if(close) then
        self.close = vgui.Create("yaws.sidebar_button", self.sidebar)
        self.close:SetName(YAWS.Language.GetTranslation("sidebar_close"))
        self.close:SetIcon(YAWS.UI.MaterialCache['close'])
        self.close:SetCallback(function() 
            self:Remove()
        end)
    end
    self:InvalidateLayout()
end 

function PANEL:OnRemove()
    YAWS.UI.LoadingCache = nil
end 

function PANEL:AddSidebarTab(name, icon, selectable, callback)
    self.sidebar:AddTab(name, icon, selectable, callback)
end 
function PANEL:AddSidebarBottomTab(name, icon, selectable, callback)
    self.sidebar:AddBottomTab(name, icon, selectable, callback)
end 
function PANEL:SetSidebarSelected(id)
    -- this is crude but it should be fine
    self.sidebar:UpdateSelected(id)
    self.sidebar.tabs[id].element:DoClick()
end 
function PANEL:SetSidebarSelectedName(name)
    self.sidebar:SetSelectedName(name)
end 

function PANEL:Paint(w, h)
    local colors = YAWS.UI.ColorScheme() 

    draw.RoundedBox(0, 0, 0, w, h, colors['frame_background'])
end 

function PANEL:PerformLayout(w, h)
    if(self.sidebar) then 
        self.sidebar:Dock(LEFT)
        self.sidebar:SetWide(math.min(self:GetWide() * 0.1, 95)) -- i think im too used to web design now

        self.master:Dock(FILL)

        if(self.close) then 
            self.close:Dock(BOTTOM)
            self.close:SetHeight(self.close:GetWide())
        end 
    end 

    self:PostPerformLayout() -- aka once everything is loaded
end
function PANEL:PostPerformLayout() end 

vgui.Register("yaws.frame", PANEL, "EditablePanel")