local PANEL = {}

function PANEL:Init()
	self.cols = 2
	self.colSizeH = 30
	self.colSizeW = nil

	self.verticalMargin = 1
	self.horizontalMargin = 1

	self:SetPaintBackground(false)
	self:SetHeight(0)
end

function PANEL:AddPanel(parent)
	local panel = vgui.Create("DPanel",parent)
	panel:SetPaintBackground(false)

	return panel
end

function PANEL:AddItem(panel)
	if !IsValid(self.line) or (self.line:ChildCount() % self.cols == 0) then
		self.line = self:AddPanel(self)
		self.line:Dock(TOP)
		self.line:DockMargin(0,self:ChildCount() != 1 and self.verticalMargin or 0,0,0)
		self.line:SetHeight(self.colSizeH)

		self:InvalidateLayout(true)
		self:SizeToChildren(false,true)	
	end

	local col = self:AddPanel(self.line)
	col:Dock(LEFT)
	col:DockMargin(self.line:ChildCount() != 1 and self.horizontalMargin or 0,0,0,0)
	col.Think = function(this)
		this:SetWide(self.colSizeW or ((self:GetWide()-(self.line:ChildCount() != 1 and self.horizontalMargin or 0))/self.cols))
	end

	panel:SetParent(col)
end

function PANEL:SetColHeight(size)
	self.colSizeH = size
end

function PANEL:SetColWide(size)
	self.colSizeW = size
end

function PANEL:SetMargin(y, x)
	self.verticalMargin = y
	self.horizontalMargin = x
end

function PANEL:SetCol(col)
	self.cols = col
end

function PANEL:Clear()
	for _, v in ipairs(self:GetChildren()) do
		v:Remove()
	end

	self:InvalidateLayout(true)
	self:SizeToChildren(false,true)
end

derma.DefineControl("sd_scoreboard_grid", "", PANEL, "DPanel")