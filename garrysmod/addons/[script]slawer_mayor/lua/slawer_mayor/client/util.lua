surface.CreateFont("Slawer.Mayor:B16", { font = "Calibri", extended  = true, italic = true, antialias = true, shadow = false, weight = 1000, size = 17 })
surface.CreateFont("Slawer.Mayor:B20", { font = "Calibri", extended  = true, italic = true, antialias = true, shadow = false, weight = 1000, size = 22 })
surface.CreateFont("Slawer.Mayor:B30", { font = "Calibri", extended  = true, italic = true, antialias = true, shadow = false, weight = 1000, size = 30 })
surface.CreateFont("Slawer.Mayor:B50", { font = "Calibri", extended  = true, italic = true, antialias = true, shadow = false, weight = 1000, size = 40 })
surface.CreateFont("Slawer.Mayor:B65", { font = "Calibri", extended  = true, italic = true, antialias = true, shadow = false, weight = 1000, size = 66 })
surface.CreateFont("Slawer.Mayor:B80", { font = "Calibri", extended  = true, italic = true, antialias = true, shadow = false, weight = 1000, size = 81 })
surface.CreateFont("Slawer.Mayor:B125", { font = "Calibri", extended  = true, italic = true, antialias = true, shadow = false, weight = 1000, size = 126 })
surface.CreateFont("Slawer.Mayor:R20", { font = "Calibri", extended  = true, italic = true, antialias = true, shadow = false, weight = 1000, size = 21 })
surface.CreateFont("Slawer.Mayor:R22", { font = "Calibri", extended  = true, italic = true, antialias = true, shadow = false, weight = 1000, size = 21 })
surface.CreateFont("Slawer.Mayor:R30", { font = "Calibri", extended  = true, italic = true, antialias = true, shadow = false, weight = 1000, size = 22 })

function Slawer.Mayor:WrapText(strText, strFont, intMaxSize)
	local tblWords = string.Explode(" ", strText)
	local intSize = 0
	local tblLines = {""}
	local intLine = 1

	surface.SetFont(strFont)
	for k, v in pairs(tblWords) do
		intSize = intSize + surface.GetTextSize(v .. " ")

		if intSize <= intMaxSize then
			tblLines[intLine] = tblLines[intLine] .. (k == 1 && "" || " ") .. v
		else
			intSize = 0
			intLine = intLine + 1
			tblLines[intLine] = v
		end
	end

	return tblLines
end

function Slawer.Mayor:DrawCard(x, y, w, h, title, desc)
	surface.SetDrawColor(Slawer.Mayor.Colors.DarkGrey)
	surface.DrawRect(x, y, w, h)

	draw.SimpleText(title, "Slawer.Mayor:B50", x + w * 0.5, h * 0.5 - 15, color_white, 1, 1)
	draw.SimpleText(desc, "Slawer.Mayor:R20", x + w * 0.5, h * 0.5 + 25, color_white, 1, 1)
end

function Slawer.Mayor:DrawBigCard(x, y, w, h, title, desc)
	surface.SetDrawColor(Slawer.Mayor.Colors.DarkGrey)
	surface.DrawRect(x, y, w, h)

	draw.SimpleText(title, "Slawer.Mayor:B125", x + w * 0.5, y + h * 0.5 - 40, color_white, 1, 1)
	draw.SimpleText(desc, "Slawer.Mayor:B65", x + w * 0.5, y + h * 0.5 + 60, Slawer.Mayor.Colors.LightGrey, 1, 1)
end

function Slawer.Mayor:RefreshPanel(strPanel)
	if IsValid(Slawer.Mayor.Menu) then
		if IsValid(Slawer.Mayor.pnlActive) && Slawer.Mayor.pnlActive.strLinked == Slawer.Mayor:L(strPanel) then
			Slawer.Mayor.pnlActive:DoClick()
		end
	end
end

function Slawer.Mayor:CanUseComp(ent)
	return LocalPlayer():GetPos():DistToSqr(ent:GetPos() + ent:GetForward() * 35) < 5000
end

function Slawer.Mayor:ShowSafeMenu(ent)
	if IsValid(Slawer.Mayor.SafeMenu) then
		Slawer.Mayor.SafeMenu:Remove()
	end

	local Base = vgui.Create("DFrame")
	Base:ShowCloseButton(false)
	Base:SetSize(0, 0)
	Base:Center()
	Base:SizeTo(300, 170, 0.25)
	Base:MoveTo(ScrW() * 0.5 - 300 * 0.5, ScrH() * 0.5 - 170 * 0.5, 0.25)
	Base:SetTitle("")
	Base:MakePopup()
	function Base:Paint(intW, intH)
		if ent:GetSequence() == 2 then
			self:Remove()
			return
		end
		surface.SetDrawColor(Slawer.Mayor.Colors.DarkGrey)
		surface.DrawRect(0, 0, intW, intH)
	end

	local amount = vgui.Create("DTextEntry", Base)
	amount:SetSize(280, 30)
	amount:SetPos(10, 10)
	amount:SetDrawLanguageID(false)
	amount:SetFont("Slawer.Mayor:B20")
	amount:SetNumeric(true)
	amount:SetPlaceholderText(Slawer.Mayor:L("Amount"))

	local deposit = vgui.Create("Slawer.Mayor:DButton", Base)
	deposit:SetSize(135, 30)
	deposit:SetPos(155, 50)
	deposit:SetText(Slawer.Mayor:L("Deposit"))
	function deposit:DoClick()
		Slawer.Mayor:NetStart("WithdrawSafe", {ent = ent, amount = tonumber(amount:GetText()), deposit = true})
		Base:Remove()
	end

	if not (not Slawer.Mayor.CFG.CanMayorWithdrawFromSafe && LocalPlayer():isMayor()) then
		local withdraw = vgui.Create("Slawer.Mayor:DButton", Base)
		withdraw:SetSize(135, 30)
		withdraw:SetPos(10, 50)
		withdraw:SetText(Slawer.Mayor:L("Withdraw"))
		function withdraw:DoClick()
			Slawer.Mayor:NetStart("WithdrawSafe", {ent = ent, amount = tonumber(amount:GetText())})
			Base:Remove()
		end

	else
		deposit:SetPos(10, 50)
		deposit:SetSize(280, 30)
	end

	local closesafe = vgui.Create("Slawer.Mayor:DButton", Base)
	closesafe:SetSize(280, 30)
	closesafe:SetPos(10, 90)
	closesafe:SetText(Slawer.Mayor:L("CloseSafe"))
	closesafe:SetBackgroundColor(Slawer.Mayor.Colors.Grey)
	function closesafe:DoClick()
		Slawer.Mayor:NetStart("CloseSafe", {ent = ent})
		Base:Remove()
	end

	local close = vgui.Create("Slawer.Mayor:DButton", Base)
	close:SetSize(280, 30)
	close:SetPos(10, 130)
	close:SetText(Slawer.Mayor:L("Close"))
	close:SetBackgroundColor(Slawer.Mayor.Colors.Grey)
	function close:DoClick()
		Base:Remove()
	end

	Slawer.Mayor.SafeMenu = Base
end

Slawer.Mayor:NetReceive("OpenSafeMenu", function(tbl)
	Slawer.Mayor:ShowSafeMenu(tbl.ent)
end)

Slawer.Mayor:NetReceive("AllReset", function()
	-- upgrades
	Slawer.Mayor.Upgrades = {}

	-- taxes
	for intID, tbl in pairs(RPExtraTeams) do
		if Slawer.Mayor.CFG.TaxesBlacklist[intID] then continue end
		Slawer.Mayor.JobTaxs[intID] = 0
	end
end)