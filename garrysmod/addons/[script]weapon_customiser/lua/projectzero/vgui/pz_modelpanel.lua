--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

local PANEL = {}

function PANEL:Init()

end

function PANEL:LayoutEntity()

end

function PANEL:ChangeModel( model )
    self:SetModel( model )
    if( not IsValid( self.Entity ) ) then return end

    local mn, mx = self.Entity:GetRenderBounds()
    local size = 0
    size = math.max( size, math.abs(mn.x) + math.abs(mx.x) )
    size = math.max( size, math.abs(mn.y) + math.abs(mx.y) )
    size = math.max( size, math.abs(mn.z) + math.abs(mx.z) )

    self:SetCamPos( Vector( size, size, size ) )
    self:SetLookAt( (mn + mx) * 0.5 )
end

vgui.Register( "pz_modelpanel", PANEL, "DModelPanel" )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
