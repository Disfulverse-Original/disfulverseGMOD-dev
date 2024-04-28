local PANEL = {}

AccessorFunc(PANEL, "name", "Name")

function PANEL:Init()
    self.name = ""
    self.steamid = ""

    self.avatarPanel = vgui.Create("yaws.round_avatar", self)
    self.avatarPanel:SetMouseInputEnabled(false)

    self:SetText("")
end 

function PANEL:SetPlayer(ply)
    self.name = ply:Name()
    self.steamid = ply:SteamID64()

    self.avatarPanel:SetPlayer(ply, 128)
end 
function PANEL:SetOfflinePlayer(sid, data)
    self.name = data.name
    self.steamid = sid

    self.avatarPanel:SetSteamID(sid, 128)
end 

function PANEL:PerformLayout(w, h)
    self.avatarPanel:Dock(LEFT)
    self.avatarPanel:DockMargin(h * 0.125, h * 0.125, h * 0.125, h * 0.125)
    self.avatarPanel:SetWidth(self.avatarPanel:GetTall())
end 

function PANEL:Paint(w, h)
    local colors = YAWS.UI.ColorScheme()

    draw.RoundedBox(0, 0, 0, w, h, colors['player_card_border'])
    draw.RoundedBox(0, 1, 1, w - 2, h - 2, colors['player_card_bg'])

    -- draw.RoundedBox(0, 0, 0, w, h, Color(255, 0, 0))
    draw.SimpleText(self.name, YAWS.UI.ScaleFont(self.name, (w - h), 7, 9), h, h * 0.39, colors['text_header'], 0, 1)
    draw.SimpleText(util.SteamIDFrom64(self.steamid or ""), "yaws.7", h, h * 0.61, colors["text_main"], 0, 1)
end

vgui.Register("yaws.player_card", PANEL, "DButton")