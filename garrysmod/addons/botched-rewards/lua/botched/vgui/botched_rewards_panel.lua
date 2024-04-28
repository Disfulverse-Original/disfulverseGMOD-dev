local PANEL = {}

function PANEL:Init()

end

function PANEL:FillPanel()
    self.navigation = vgui.Create( "botched_sheet_bottom", self )
    self.navigation:Dock( FILL )
    self.navigation:SetSize( self:GetSize() )
    self.navigation.Paint = function() end

    self.homePanel = vgui.Create( "botched_rewardspage_home", self.navigation )
    self.navigation:AddPage( "Главная", Material( "materials/botched/icons/home.png" ), self.homePanel )

    self.lockerPanel = vgui.Create( "botched_page_locker", self.navigation )
    self.navigation:AddPage( "Инвентарь", Material( "materials/botched/icons/inventory.png" ), self.lockerPanel )

    --self.bannerPanel = vgui.Create( "botched_gachapage_banners", self.navigation )
    --self.navigation:AddPage( "BANNERS", Material( "materials/botched/icons/character.png" ), self.bannerPanel, "banner" )
end

function PANEL:Paint( w, h )

end

vgui.Register( "botched_rewards_panel", PANEL, "DPanel" )