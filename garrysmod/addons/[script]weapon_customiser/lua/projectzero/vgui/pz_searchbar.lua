--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

local PANEL = {}

DEFINE_BASECLASS( "pz_textentry" )

function PANEL:Init()
    self:SetTall( PROJECT0.FUNC.ScreenScale( 40 ) )
    self:SetBackText( PROJECT0.L( "search" ) )
end

local search = Material( "project0/icons/search.png", "noclamp smooth" )
function PANEL:Paint( w, h )
    BaseClass.Paint( self, w, h )

    surface.SetDrawColor( 255, 255, 255, 100+(self.alpha or 0) )
    surface.SetMaterial( search )
    local iconSize = PROJECT0.FUNC.ScreenScale( 20 )
    surface.DrawTexturedRect( w-iconSize-(h-iconSize)/2, h/2-iconSize/2, iconSize, iconSize )
end

vgui.Register( "pz_searchbar", PANEL, "pz_textentry" )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
