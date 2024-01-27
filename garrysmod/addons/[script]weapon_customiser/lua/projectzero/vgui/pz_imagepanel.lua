--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

local PANEL = {}

DEFINE_BASECLASS( "DImage" )

function PANEL:Init()

end

function PANEL:SetImagePath( path )
    if( not string.StartWith( path, "http" ) ) then
        self:SetMaterial( path )
        return
    end

    self.loadingImage = true
    
    PROJECT0.FUNC.GetImage( path, function( mat )
        if( not IsValid( self ) ) then return end

        self.loadingImage = false
        if( IsValid( self.loadingPanel ) ) then
            self.loadingPanel:Remove()
        end

        self:SetMaterial( mat )
    end )
end

function PANEL:CreateLoadingPanel( w, h )
    self.loadingPanel = vgui.Create( "pz_loading_square", self )
    self.loadingPanel:SetSize( PROJECT0.FUNC.Repeat( math.min( w, h, PROJECT0.FUNC.ScreenScale( 40 ) ), 2 ) )
    self.loadingPanel:SetPos( w/2-self.loadingPanel:GetWide()/2, h/2-self.loadingPanel:GetTall()/2 )
    self.loadingPanel:BeginAnimation()
end

function PANEL:Paint( w, h )
    if( not self.loadingImage ) then 
        BaseClass.Paint( self, w, h )
        return 
    end

    if( IsValid( self.loadingPanel ) ) then return end
    self:CreateLoadingPanel( w, h )
end

vgui.Register( "pz_imagepanel", PANEL, "DImage" )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
