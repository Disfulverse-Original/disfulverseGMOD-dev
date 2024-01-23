local PANEL = {}

function PANEL:Init()
	self.offset = 0
	self.MaxPos = 0

	self.pos = 0
	self.frame = 0
	self.stopPos = 0
	self.startPos = 0

	self.scrollBarBool = true

	self.base = vgui.Create("DPanel",self)
	self.base:SetPaintBackground(false)

	self:ScrollBar()

	self.base.PerformLayout = function(this)
		self.MaxPos = this:GetTall() > self:GetTall() and this:GetTall() - self:GetTall() or 0
		this:SizeToChildren(false,true)
		self.scrollBar:SetWidth(!self.scrollBarBool and 0 or self.MaxPos == 0 and 0 or 5)
	end

	self:SetPaintBackground(false)
end

function PANEL:ScrollBar()
	self.scrollBar = vgui.Create("DButton", self)
	self.scrollBar:SetText("")
	self.scrollBar:Dock(RIGHT)

	self.scrollBar.OnMousePressed = function(this)
		this.move = true
	end

	self.scrollBar.Think = function(this)
		if !this.move then return end

		if !input.IsMouseDown(107) then this.move = false return end

		local _, y = this:LocalCursorPos()
		self:AnimationTo(-math.Remap(y, 0, this:GetTall(), 0, self.MaxPos))
	end

	self.scrollBar.Paint = function(this, w, h)
		if !self.scrollBarBool then return end

		local size = math.Remap(h/self.base:GetTall(), 0, 1, 0, h)
		local pos = math.Remap(-self.pos, 0, self.MaxPos, 0, h-size)

		draw.RoundedBox(0, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.sliderBg)
		draw.RoundedBox(10, 0, pos, w, size, SD_SCOREBOARD_GMS.Colors.slider)

		SD_SCOREBOARD_GMS.Circle(w/2, pos, w/2, 8, SD_SCOREBOARD_GMS.Colors.slider)
		SD_SCOREBOARD_GMS.Circle(w/2, size+pos, w/2, 8, SD_SCOREBOARD_GMS.Colors.slider)
	end
end

function PANEL:scrollBarEnable(bool)
	self.scrollBarBool = bool
end

function PANEL:AnimationTo(pos)
	self.frame = SysTime()
	self.startPos = self.pos
	self.stopPos = pos
	self.offset = pos
end

function PANEL:EasyInOut(x)
	return 1-math.pow(1-x*2,3)
end

function PANEL:Think()
	self.base:SetWide(self:GetWide() - (!self.scrollBarBool and 0 or self.MaxPos == 0 and 0 or 5))

	if self.offset != self.stopPos then self:AnimationTo(self.offset) end 
	
	if self.pos == self.stopPos then
		if self.offset > 0 then self:AnimationTo(0) elseif self.offset < -self.MaxPos then self:AnimationTo(-self.MaxPos) end 
	else
		self.pos = Lerp(self:EasyInOut((SysTime()-self.frame)*2), self.startPos, self.stopPos)
		self.base:SetPos(0, self.pos)
	end
end

function PANEL:AddItem(panel)
	panel:SetParent(self.base)
end

function PANEL:OnChildAdded(child)
	self:AddItem(child)
end

function PANEL:OnMouseWheeled(offset)
	if self.MaxPos == 0 then return end

	local newOffset = self.offset+offset*100
	self.offset = newOffset > 0 and self.offset+offset*(10-self.offset/5) or newOffset < -self.MaxPos and self.offset + offset*(10-(-self.offset-self.MaxPos)/5) or newOffset
end

derma.DefineControl("sd_scoreboard_scroll", "", PANEL, "DPanel")