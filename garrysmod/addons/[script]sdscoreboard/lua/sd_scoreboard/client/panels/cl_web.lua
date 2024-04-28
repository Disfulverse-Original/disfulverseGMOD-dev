local PANEL = {}

function PANEL:Init()
	self.Paint = function(this, w, h)
		draw.RoundedBox(0, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.panel)
	end
end

function PANEL:SetLink(link) 
	if not (string.find(link,"http://") or string.find(link,"https://")) then link = "http://"..link end
	self:Web(link)
end

function PANEL:Web(link)
	local panel = vgui.Create("DPanel", self )
	panel:SetText("")
	panel:Dock(TOP)
	panel:SetSize(0,30)
	panel:SetZPos(2)
	panel.Paint = function(this, w, h) end
	SD_SCOREBOARD_GMS.Shadow(panel, 10, true)

	local button = vgui.Create("DButton", panel)
	button:SetText("")
	button:Dock(LEFT)
	button:DockMargin(1, 1, 1, 0)
	button:SetSize(180,30)
	SD_SCOREBOARD_GMS.ButtonAnim(button)
	button.Paint = function(this, w, h)
		draw.RoundedBox(2, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.panel)
		draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(SD_SCOREBOARD_GMS.Colors.buttonHovered, this.anim.pos))

		draw.DrawText( SD_SCOREBOARD_GMS.Language.openoverlay , "sd_scoreboard_14_100", w/2 , 8, SD_SCOREBOARD_GMS.Colors.mainText, TEXT_ALIGN_CENTER)
	end
	button.DoClick = function(this)
		gui.OpenURL(link)
	end

	local button = vgui.Create("DButton", panel)
	button:SetText("")
	button:Dock(LEFT)
	button:DockMargin(0, 1, 1, 0)
	button:SetSize(210,30)
	SD_SCOREBOARD_GMS.ButtonAnim(button)
	button.Paint = function(this, w, h)
		draw.RoundedBox(2, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.panel)
		draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(SD_SCOREBOARD_GMS.Colors.buttonHovered, this.anim.pos))
		draw.DrawText(SD_SCOREBOARD_GMS.Language.clipboard , "sd_scoreboard_14_100", w/2 , 8, SD_SCOREBOARD_GMS.Colors.mainText, TEXT_ALIGN_CENTER)
	end
	button.DoClick = function(this)
		SetClipboardText( link )
	end

	local panel = vgui.Create("DPanel", panel)
	panel:SetText("")
	panel:Dock(FILL)
	panel:DockMargin(0, 1, 1, 0)
	panel:SetSize(180,30)
	panel.Paint = function(this, w, h)
		draw.RoundedBox(2, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.panel)
		draw.DrawText(link , "sd_scoreboard_14_100", w/2 , 8, SD_SCOREBOARD_GMS.Colors.mainText, TEXT_ALIGN_CENTER)
	end

	local webPanel = vgui.Create("DHTML", self)
	webPanel:Dock(FILL)
	webPanel:OpenURL(link)
end


vgui.Register("sd_scoreboard_web", PANEL)