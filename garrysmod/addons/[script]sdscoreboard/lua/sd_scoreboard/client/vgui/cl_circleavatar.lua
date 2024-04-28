local PANEL = {}

function PANEL:Init()
	self.avatar = vgui.Create( "AvatarImage", self )
	self.avatar:Dock(FILL)
	self.avatar:SetPaintedManually(true)
end
function PANEL:SetData(ply, quality, seg)
	self.avatar:SetPlayer(ply, quality)
	self.seg = seg
	self.color = Color(0,0,0)
end
function PANEL:Paint(w, h)
	render.ClearStencil()
	render.SetStencilEnable(true)

	render.SetStencilWriteMask( 1 )
	render.SetStencilTestMask( 1 )
	render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
	render.SetStencilPassOperation( STENCILOPERATION_ZERO )
	render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
	render.SetStencilReferenceValue( 1 )

	SD_SCOREBOARD_GMS.Circle(w/2, h/2, w/2, self.seg, self.color)

	render.SetStencilFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
	render.SetStencilReferenceValue( 1 )

	self.avatar:SetPaintedManually(false)
	self.avatar:PaintManual()
	self.avatar:SetPaintedManually(true)

	render.SetStencilEnable(false)
	render.ClearStencil()
end

vgui.Register("sd_circleavatar", PANEL)