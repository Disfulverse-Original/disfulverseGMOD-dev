function Slawer.Mayor:ShowNews(pnlContent)
	local pnlBox = vgui.Create("DPanel", pnlContent)
	pnlBox:SetSize(pnlContent:GetWide() - 40, 40)
	pnlBox:SetPos(20, 20)
	pnlBox:NoClipping(true)
	pnlBox.Paint = nil

	local txtMessage = vgui.Create("Slawer.Mayor:DTextEntry", pnlBox)
	txtMessage:SetSize(pnlContent:GetWide() - 40, 40)
	txtMessage:SetPos(0, 0)
	txtMessage:SetPlaceholder(GetGlobalString("SMayor:News") == "" && Slawer.Mayor:L("News") || GetGlobalString("SMayor:News"))

	local txtLength = vgui.Create("Slawer.Mayor:DTextEntry", pnlContent)
	txtLength:SetSize(pnlContent:GetWide() - 40, 40)
	txtLength:SetPos(20, 80)
	txtLength:SetPlaceholder(Slawer.Mayor:L("NewsDuration"))

	local btnUpdate = vgui.Create("Slawer.Mayor:DButton", pnlContent)
	btnUpdate:SetSize(pnlContent:GetWide() - 40, 40)
	btnUpdate:SetPos(20, 140)
	btnUpdate:SetText(Slawer.Mayor:L("Save"))
	function btnUpdate:DoClick()
		Slawer.Mayor:NetStart("UpdateNews", {message = txtMessage:GetText(), duration = tonumber(txtLength:GetValue())})
	end
end