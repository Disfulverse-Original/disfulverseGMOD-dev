surface.CreateFont( "RCNPC_TitleText", {
	font = "Roboto",
	size = 19,
	extended = true,
	antialias = true,
	weight = 500
} )
surface.CreateFont( "RCNPC_WelcomeText", {
	font = "Roboto",
	size = 25,
	extended = true,
	antialias = true,
	weight = 500
} )
surface.CreateFont( "RCNPC_InfoText", {
	font = "Roboto",
	size = 20,
	extended = true,
	antialias = true,
	weight = 500
} )
surface.CreateFont( "RCNPC_InvalidText", {
	font = "Roboto",
	size = 16,
	extended = true,
	antialias = true,
	weight = 500
} )
surface.CreateFont( "RCNPC_AdminText", {
	font = "Roboto",
	size = 15,
	extended = true,
	weight = 500
} )
surface.CreateFont( "RCNPC_EntryTitle", {
	font = "Roboto",
	size = 20,
	extended = true,
	weight = 500
} )

surface.CreateFont( "RCNPC_EntryText", {
	font = "Roboto",
	size = 19,
	extended = true,
	antialias = true,
	weight = 550
} )

local blur = Material("pp/blurscreen")
local function drawBlur( x, y, w, h, amount )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( blur )

	for i = 1, 6 do
		blur:SetFloat( "$blur", ( i / 3 ) * ( amount or 6 ) )
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		render.SetScissorRect( x, y, x + w, y + h, true )
			surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
		render.SetScissorRect( 0, 0, 0, 0, false )
	end
end



net.Receive("NC_OpenNCMenu", function()
	local ply = net.ReadEntity()
	if (!IsValid(NameChangePanel)) then
		local FirstName
		local LastName
		local OnlyOne
		local Prefix
		local NameChangePanel = vgui.Create( "DFrame" )
		NameChangePanel:SetSize( 525, 350 )
		NameChangePanel:Center()
		NameChangePanel:SetTitle( " " )
		NameChangePanel:SetVisible( true )
		NameChangePanel:SetDraggable( false )
		NameChangePanel:ShowCloseButton( false )
		NameChangePanel:SetBackgroundBlur( true )
		NameChangePanel:MakePopup()
		NameChangePanel.Paint = function(self, w, h)
			Derma_DrawBackgroundBlur(self, self.startTime)
			draw.RoundedBoxEx( 4, 0, 0, w, 30, NC.Color.Header, true, true, false, false )
			draw.RoundedBoxEx( 4, 0, 30, w, h-30, NC.Color.MainPage, false, false, true, true )
			draw.SimpleText( NC.Language.MainTitle, "RCNPC_TitleText", NameChangePanel:GetWide()/2, 3, NC.Color.HeaderText, TEXT_ALIGN_CENTER )
			draw.SimpleText( NC.Language.WelcomeMessage..LocalPlayer():getDarkRPVar("rpname")..",", "RCNPC_WelcomeText", NameChangePanel:GetWide()/2, 35, NC.Color.MainPageText, TEXT_ALIGN_CENTER )
			draw.SimpleText( NC.Language.InfoText, "RCNPC_InfoText", NameChangePanel:GetWide()/2, 67, NC.Color.MainPageText, TEXT_ALIGN_CENTER )
			if NC.EntryType == "two" then
				draw.SimpleText( NC.Language.FirstName, "RCNPC_EntryTitle", NameChangePanel:GetWide()/2, 103, NC.Color.HeaderText, TEXT_ALIGN_CENTER )
				if NC.UseWhiteList then
					if not CheckIfNameHasRightChar(FirstName:GetValue()) then
						draw.SimpleText( NC.Language.InvalidCharacter..GetInvalidChar(FirstName:GetValue()), "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 160, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif TooLongName("first", FirstName:GetValue()) then
						draw.SimpleText( NC.Language.ExceedsAmount, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 160, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif TooShortName("first", FirstName:GetValue()) then
						draw.SimpleText( NC.Language.NotEnoughAmount, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 160, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif not AppropriateCheck(FirstName:GetValue()) then
						draw.SimpleText( NC.Language.BadWord, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 160, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					else
						draw.SimpleText( NC.Language.GoodName, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 160, Color(0, 204, 0, 255), TEXT_ALIGN_CENTER )
					end
				else
					if not CheckIfValidName(FirstName:GetValue()) then
						draw.SimpleText( NC.Language.InvalidCharacter..GetInvalidChar(FirstName:GetValue()), "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 160, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif TooLongName("first", FirstName:GetValue()) then
						draw.SimpleText( NC.Language.ExceedsAmount, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 160, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif TooShortName("first", FirstName:GetValue()) then
						draw.SimpleText( NC.Language.NotEnoughAmount, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 160, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif not AppropriateCheck(FirstName:GetValue()) then
						draw.SimpleText( NC.Language.BadWord, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 160, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					else
						draw.SimpleText( NC.Language.GoodName, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 160, Color(0, 204, 0, 255), TEXT_ALIGN_CENTER )
					end
				end
				draw.SimpleText( NC.Language.LastName, "RCNPC_EntryTitle", NameChangePanel:GetWide()/2, 188, NC.Color.HeaderText, TEXT_ALIGN_CENTER )
				if NC.UseWhiteList then
					if not CheckIfNameHasRightChar(LastName:GetValue()) then
						draw.SimpleText( NC.Language.InvalidCharacter..GetInvalidChar(FirstName:GetValue()), "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 243, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif TooLongName("last", LastName:GetValue()) then
						draw.SimpleText( NC.Language.ExceedsAmount, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 243, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif TooShortName("last", LastName:GetValue()) then
						draw.SimpleText( NC.Language.NotEnoughAmount, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 243, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif not AppropriateCheck(LastName:GetValue()) then
						draw.SimpleText( NC.Language.BadWord, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 243, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					else
						draw.SimpleText( NC.Language.GoodName, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 243, Color(0, 204, 0, 255), TEXT_ALIGN_CENTER )
					end
				else
					if not CheckIfValidName(LastName:GetValue()) then
						draw.SimpleText( NC.Language.InvalidCharacter..GetInvalidChar(FirstName:GetValue()), "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 243, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif TooLongName("last", LastName:GetValue()) then
						draw.SimpleText( NC.Language.ExceedsAmount, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 243, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif TooShortName("last", LastName:GetValue()) then
						draw.SimpleText( NC.Language.NotEnoughAmount, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 243, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif not AppropriateCheck(LastName:GetValue()) then
						draw.SimpleText( NC.Language.BadWord, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 243, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					else
						draw.SimpleText( NC.Language.GoodName, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 243, Color(0, 204, 0, 255), TEXT_ALIGN_CENTER )
					end
				end
			elseif NC.EntryType == "one" then
				draw.SimpleText( "Name", "RCNPC_EntryTitle", NameChangePanel:GetWide()/2, NameChangePanel:GetTall()/2-40, NC.Color.HeaderText, TEXT_ALIGN_CENTER )
				if NC.UseWhiteList then
					if not CheckIfNameHasRightChar(OnlyOne:GetValue()) then
						draw.SimpleText( NC.Language.InvalidCharacter..GetInvalidChar(FirstName:GetValue()), "RCNPC_InvalidText", NameChangePanel:GetWide()/2, NameChangePanel:GetTall()/2+16, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif TooLongName("first", OnlyOne:GetValue()) then
						draw.SimpleText( NC.Language.ExceedsAmount, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, NameChangePanel:GetTall()/2+16, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif TooShortName("first", OnlyOne:GetValue()) then
						draw.SimpleText( NC.Language.NotEnoughAmount, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, NameChangePanel:GetTall()/2+16, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif not AppropriateCheck(OnlyOne:GetValue()) then
						draw.SimpleText( NC.Language.BadWord, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, NameChangePanel:GetTall()/2+16, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif not CheckOneSpace(OnlyOne:GetValue()) then
						draw.SimpleText( NC.Language.OneSpace, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, NameChangePanel:GetTall()/2+16, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					else
						draw.SimpleText( NC.Language.GoodName, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, NameChangePanel:GetTall()/2+16, Color(0, 204, 0, 255), TEXT_ALIGN_CENTER )
					end
				else
					if not CheckIfValidName(OnlyOne:GetValue()) then
						draw.SimpleText( NC.Language.InvalidCharacter..GetInvalidChar(FirstName:GetValue()), "RCNPC_InvalidText", NameChangePanel:GetWide()/2, NameChangePanel:GetTall()/2+16, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif TooLongName("first", OnlyOne:GetValue()) then
						draw.SimpleText( NC.Language.ExceedsAmount, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, NameChangePanel:GetTall()/2+16, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif TooShortName("first", OnlyOne:GetValue()) then
						draw.SimpleText( NC.Language.NotEnoughAmount, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, NameChangePanel:GetTall()/2+16, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif not AppropriateCheck(OnlyOne:GetValue()) then
						draw.SimpleText( NC.Language.BadWord, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, NameChangePanel:GetTall()/2+16, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif not CheckOneSpace(OnlyOne:GetValue()) then
						draw.SimpleText( NC.Language.OneSpace, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, NameChangePanel:GetTall()/2+16, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					else
						draw.SimpleText( NC.Language.GoodName, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, NameChangePanel:GetTall()/2+16, Color(0, 204, 0, 255), TEXT_ALIGN_CENTER )
					end
				end
			elseif NC.EntryType == "prefix" then
				draw.SimpleText( NC.Language.Prefix, "RCNPC_EntryTitle", NameChangePanel:GetWide()/2, 103, NC.Color.EntryText, TEXT_ALIGN_CENTER )
				if NC.UseWhiteList then
					if Prefix:GetValue() == NC.Language.Selection then
						draw.SimpleText( NC.Language.PrefixInfo, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 160, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					else
						draw.SimpleText( NC.Language.PrefixGood, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 160, Color(0, 204, 0, 255), TEXT_ALIGN_CENTER )
					end
				else
					if not CheckIfValidName(FirstName:GetValue()) then
						draw.SimpleText( NC.Language.InvalidCharacter..GetInvalidChar(FirstName:GetValue()), "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 160, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif TooLongName("first", FirstName:GetValue()) then
						draw.SimpleText( NC.Language.ExceedsAmount, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 160, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif TooShortName("first", FirstName:GetValue()) then
						draw.SimpleText( NC.Language.NotEnoughAmount, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 160, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif not AppropriateCheck(FirstName:GetValue()) then
						draw.SimpleText( NC.Language.BadWord, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 160, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					else
						draw.SimpleText( NC.Language.GoodName, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 160, Color(0, 204, 0, 255), TEXT_ALIGN_CENTER )
					end
				end
				draw.SimpleText( NC.Language.OneEntry, "RCNPC_EntryTitle", NameChangePanel:GetWide()/2, 188, NC.Color.EntryText, TEXT_ALIGN_CENTER )
				if NC.UseWhiteList then
					if not CheckIfNameHasRightChar(LastName:GetValue()) then
						draw.SimpleText( NC.Language.InvalidCharacter..GetInvalidChar(FirstName:GetValue()), "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 243, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif TooLongName("last", LastName:GetValue()) then
						draw.SimpleText( NC.Language.ExceedsAmount, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 243, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif TooShortName("last", LastName:GetValue()) then
						draw.SimpleText( NC.Language.NotEnoughAmount, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 243, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif not AppropriateCheck(LastName:GetValue()) then
						draw.SimpleText( NC.Language.BadWord, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 243, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif not CheckOneSpace(LastName:GetValue()) then
						draw.SimpleText( NC.Language.OneSpace, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 243, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					else
						draw.SimpleText( NC.Language.GoodName, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 243, Color(0, 204, 0, 255), TEXT_ALIGN_CENTER )
					end
				else
					if not CheckIfValidName(LastName:GetValue()) then
						draw.SimpleText( NC.Language.InvalidCharacter..GetInvalidChar(FirstName:GetValue()), "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 243, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif TooLongName("last", LastName:GetValue()) then
						draw.SimpleText( NC.Language.ExceedsAmount, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 243, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif TooShortName("last", LastName:GetValue()) then
						draw.SimpleText( NC.Language.NotEnoughAmount, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 243, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif not AppropriateCheck(LastName:GetValue()) then
						draw.SimpleText( NC.Language.BadWord, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 243, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif not CheckOneSpace(LastName:GetValue()) then
						draw.SimpleText( NC.Language.OneSpace, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 243, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					else
						draw.SimpleText( NC.Language.GoodName, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 243, Color(0, 204, 0, 255), TEXT_ALIGN_CENTER )
					end
				end
			end
		end

		if NC.EntryType == "two" then
			FirstName = vgui.Create( "DTextEntry", NameChangePanel )
			FirstName:SetSize( 200, 28 )
			FirstName:SetPos( (NameChangePanel:GetWide()/2)-(FirstName:GetWide()/2), 128 )
			FirstName:SetFont("RCNPC_EntryText")
			FirstName:SetTextColor(NC.Color.EntryText)
		end

		if NC.EntryType == "prefix" then
			Prefix = vgui.Create( "DComboBox", NameChangePanel )
			Prefix:SetSize( 200, 28 )
			Prefix:SetPos( (NameChangePanel:GetWide()/2)-(Prefix:GetWide()/2), 128 )
			Prefix:SetValue( NC.Language.Selection )
			for k, v in pairs(NC.Prefix) do
				Prefix:AddChoice( v )
			end
		end

		if NC.EntryType == "two" or NC.EntryType == "prefix" then
			LastName = vgui.Create( "DTextEntry", NameChangePanel )
			LastName:SetSize( 200, 28 )
			LastName:SetPos( (NameChangePanel:GetWide()/2)-(LastName:GetWide()/2), 213 )
			LastName:SetFont("RCNPC_EntryText")
			LastName:SetTextColor(NC.Color.EntryText)
		end

		if NC.EntryType == "one" then
			OnlyOne = vgui.Create( "DTextEntry", NameChangePanel )
			OnlyOne:SetSize( 200, 28 )
			OnlyOne:SetPos( (NameChangePanel:GetWide()/2)-(OnlyOne:GetWide()/2), NameChangePanel:GetTall()/2-14 )
			OnlyOne:SetFont("RCNPC_EntryText")
			OnlyOne:SetTextColor(NC.Color.EntryText)
		end

		local ChangeButton = vgui.Create( "DButton", NameChangePanel )
		ChangeButton:SetSize( 180, 50 )
		ChangeButton:SetPos( NameChangePanel:GetWide()/2-190,NameChangePanel:GetTall()-65 )
		ChangeButton:SetText( "" )
		ChangeButton:SetTextColor( NC.Color.CloseButton )
		ChangeButton.Paint = function(self, w, h)
			draw.RoundedBox( 0, 0, 0, w, h, NC.Color.AcceptButton )
			draw.SimpleText( NC.Language.ChangeButton, "RCNPC_EntryTitle", w/2, 15, NC.Color.HeaderText, TEXT_ALIGN_CENTER )
		end
		ChangeButton.DoClick = function()
			if ply:canAfford(NC.NameChangeCost) then
				if NC.EntryType == "two" then
					if NC.AutoCapital then
						firstn = AutoCap(FirstName:GetValue())
						lastn = AutoCap(LastName:GetValue())
					else
						firstn = FirstName:GetValue()
						lastn = LastName:GetValue()
					end
					if firstn.." "..lastn != LocalPlayer():getDarkRPVar("rpname") then
						if firstn != "" and lastn != "" then
							if not TooLongName("first", firstn) and not TooLongName("last", lastn) then
								if not TooShortName("first", firstn) and not TooShortName("last", lastn) then
									if NC.UseWhiteList then
										if CheckIfNameHasRightChar(firstn) and CheckIfNameHasRightChar(lastn) then
											if AppropriateCheck(firstn) and AppropriateCheck(lastn) then
												NCRequestBox(NC.Language.CheckChange, "'"..firstn.." "..lastn.."' for $"..string.Comma(NC.NameChangeCost).."?", NC.Language.CheckChangeAnswer1, function()
													net.Start("NC_GetNameChange")
														net.WriteString(firstn)
														net.WriteString(lastn)
													net.SendToServer()
													NameChangePanel:Remove()
												end, NC.Language.CheckChangeAnswer2, function() return end)
											else
												NCRequestBox(NC.Language.ErrorInappropriate1, NC.Language.ErrorInappropriate2, NC.Language.ErrorOk, function() return end)
											end
										else
											NCRequestBox(NC.Language.ErrorUnauthorized1, NC.Language.ErrorUnauthorized2, NC.Language.ErrorOk, function() return end)
										end
									else
										if CheckIfValidName(firstn) and CheckIfValidName(lastn) then
											if AppropriateCheck(firstn) and AppropriateCheck(lastn) then
												NCRequestBox(NC.Language.CheckChange, "'"..firstn.." "..lastn.."' for $"..string.Comma(NC.NameChangeCost).."?", NC.Language.CheckChangeAnswer1, function()
													net.Start("NC_GetNameChange")
														net.WriteString(firstn)
														net.WriteString(lastn)
													net.SendToServer()
													NameChangePanel:Remove()
												end, NC.Language.CheckChangeAnswer2, function() return end)
											else
												NCRequestBox(NC.Language.ErrorInappropriate1, NC.Language.ErrorInappropriate2, NC.Language.ErrorOk, function() return end)
											end
										else
											NCRequestBox(NC.Language.ErrorUnauthorized1, NC.Language.ErrorUnauthorized2, NC.Language.ErrorOk, function() return end)
										end
									end
								else
									NCRequestBox(NC.Language.ErrorNotEnoughCharacter1, NC.Language.ErrorNotEnoughCharacter2, NC.Language.ErrorOk, function() return end)
								end
							else
								NCRequestBox(NC.Language.ErrorTooManyCharacter1, NC.Language.ErrorTooManyCharacter2, NC.Language.ErrorOk, function() return end)
							end
						else
							NCRequestBox(NC.Language.ErrorNonValidName, "", NC.Language.ErrorOk, function() return end)
						end
					else
						NCRequestBox(NC.Language.ErrorNameExists, "", NC.Language.ErrorOk, function() return end)
					end
				elseif NC.EntryType == "one" then
					if OnlyOne:GetValue() != LocalPlayer():getDarkRPVar("rpname") then
						if OnlyOne:GetValue() != "" then
							if not TooLongName("first", OnlyOne:GetValue()) then
								if not TooShortName("first", OnlyOne:GetValue()) then
									if CheckOneSpace(OnlyOne:GetValue()) then
										if NC.UseWhiteList then
											if CheckIfNameHasRightChar(OnlyOne:GetValue()) then
												if AppropriateCheck(OnlyOne:GetValue()) then
													NCRequestBox(NC.Language.OneCheckChange1, "'"..OnlyOne:GetValue().."' for $"..string.Comma(NC.NameChangeCost).."?", NC.Language.CheckChangeAnswer1, function()
														net.Start("NC_GetNameChange")
															net.WriteString(OnlyOne:GetValue())
														net.SendToServer()
														NameChangePanel:Remove()
													end, NC.Language.CheckChangeAnswer2, function() return end)
												else
													NCRequestBox(NC.Language.ErrorInappropriate1, NC.Language.ErrorInappropriate2, NC.Language.ErrorOk, function() return end)
												end
											else
												NCRequestBox(NC.Language.ErrorUnauthorized1, NC.Language.ErrorUnauthorized2, NC.Language.ErrorOk, function() return end)
											end
										else
											if CheckIfValidName(OnlyOne:GetValue()) then
												if AppropriateCheck(OnlyOne:GetValue()) then
													NCRequestBox(NC.Language.OneCheckChange1, "'"..OnlyOne:GetValue().."' for $"..string.Comma(NC.NameChangeCost).."?", NC.Language.CheckChangeAnswer1, function()
														net.Start("NC_GetNameChange")
															net.WriteString(OnlyOne:GetValue())
														net.SendToServer()
														NameChangePanel:Remove()
													end, NC.Language.CheckChangeAnswer2, function() return end)
												else
													NCRequestBox(NC.Language.ErrorInappropriate1, NC.Language.ErrorInappropriate2, NC.Language.ErrorOk, function() return end)
												end
											else
												NCRequestBox(NC.Language.ErrorUnauthorized1, NC.Language.ErrorUnauthorized2, NC.Language.ErrorOk, function() return end)
											end
										end
									else
										NCRequestBox(NC.Language.ErrorTooManySpaces1, NC.Language.ErrorTooManySpaces2, NC.Language.ErrorOk, function() return end)
									end
								else
									NCRequestBox(NC.Language.ErrorNotEnoughCharacter1, NC.Language.ErrorNotEnoughCharacter2, NC.Language.ErrorOk, function() return end)
								end
							else
								NCRequestBox(NC.Language.ErrorTooManyCharacter1, NC.Language.ErrorTooManyCharacter2, NC.Language.ErrorOk, function() return end)
							end
						else
							NCRequestBox(NC.Language.ErrorNonValidName, "", NC.Language.ErrorOk, function() return end)
						end
					else
						NCRequestBox(NC.Language.ErrorNameExists, "", NC.Language.ErrorOk, function() return end)
					end
				elseif NC.EntryType == "prefix" then
					if LastName:GetValue() != LocalPlayer():getDarkRPVar("rpname") then
						if Prefix:GetValue() != NC.Language.Selection then
							if LastName:GetValue() != "" and CheckIfPrefix(Prefix:GetValue()) then
								if not TooLongName("first", LastName:GetValue()) then
									if not TooShortName("first", LastName:GetValue()) then
										if CheckOneSpace(LastName:GetValue()) then
											if NC.UseWhiteList then
												if CheckIfNameHasRightChar(LastName:GetValue()) then
													if AppropriateCheck(LastName:GetValue()) then
														NCRequestBox(NC.Language.PreCheckChange1,"'"..Prefix:GetValue().." "..LastName:GetValue().."' for $"..string.Comma(NC.NameChangeCost).."?", NC.Language.CheckChangeAnswer1, function()
															net.Start("NC_GetNameChange")
																net.WriteString(Prefix:GetValue())
																net.WriteString(LastName:GetValue())
															net.SendToServer()
															NameChangePanel:Remove()
														end, NC.Language.CheckChangeAnswer2, function() return end)
													else
														NCRequestBox(NC.Language.ErrorInappropriate1, NC.Language.ErrorInappropriate2, NC.Language.ErrorOk, function() return end)
													end
												else
													NCRequestBox(NC.Language.ErrorUnauthorized1, NC.Language.ErrorUnauthorized2, NC.Language.ErrorOk, function() return end)
												end
											else
												if CheckIfValidName(LastName:GetValue()) then
													if AppropriateCheck(LastName:GetValue()) then
														NCRequestBox(NC.Language.PreCheckChange1, "'"..Prefix:GetValue().." "..LastName:GetValue().."' for $"..string.Comma(NC.NameChangeCost).."?", NC.Language.CheckChangeAnswer1, function()
															net.Start("NC_GetNameChange")
																net.WriteString(Prefix:GetValue())
																net.WriteString(LastName:GetValue())
															net.SendToServer()
															NameChangePanel:Remove()
														end, NC.Language.CheckChangeAnswer2, function() return end)
													else
														NCRequestBox(NC.Language.ErrorInappropriate1, NC.Language.ErrorInappropriate2, NC.Language.ErrorOk, function() return end)
													end
												else
													NCRequestBox(NC.Language.ErrorUnauthorized1, NC.Language.ErrorUnauthorized2, NC.Language.ErrorOk, function() return end)
												end
											end
										else
											NCRequestBox(NC.Language.ErrorTooManySpaces1, NC.Language.ErrorTooManySpaces2, NC.Language.ErrorOk, function() return end)
										end
									else
										NCRequestBox(NC.Language.ErrorNotEnoughCharacter1, NC.Language.ErrorNotEnoughCharacter2, NC.Language.ErrorOk, function() return end)
									end
								else
									NCRequestBox(NC.Language.ErrorTooManyCharacter1, NC.Language.ErrorTooManyCharacter2, NC.Language.ErrorOk, function() return end)
								end
							else
								NCRequestBox(NC.Language.ErrorNonValidName, "", NC.Language.ErrorOk, function() return end)
							end
						else
							NCRequestBox(NC.Language.ErrorPrefix, "", NC.Language.ErrorOk, function() return end)
						end
					else
						NCRequestBox(NC.Language.ErrorNameExists, "", NC.Language.ErrorOk, function() return end)
					end
				end
			else
				NCRequestBox(NC.Language.ErrorCantAfford, NC.Language.ErrorCantAfford, NC.Language.ErrorOk, function() return end)
			end
		end

		local CancelButton = vgui.Create( "DButton", NameChangePanel )
		CancelButton:SetSize( 180, 50 )
		CancelButton:SetPos( NameChangePanel:GetWide()/2+10,NameChangePanel:GetTall()-65 )
		CancelButton:SetText( "" )
		CancelButton:SetTextColor( NC.Color.CloseButton )
		CancelButton.Paint = function(self, w, h)
			draw.RoundedBox( 0, 0, 0, w, h, NC.Color.CloseButton )
			draw.SimpleText( NC.Language.CancelButton, "RCNPC_EntryTitle", w/2, 15, NC.Color.HeaderText, TEXT_ALIGN_CENTER )
		end
		CancelButton.DoClick = function()
			NameChangePanel:Remove()
		end
	end
end)

net.Receive("NotifyAllOfChange", function()
	local ply = net.ReadEntity()
	local bname = net.ReadString()
	local name = net.ReadString()
	chat.AddText(Color(10, 150, 255), NC.Language.NameChangePrefixChat, Color(255, 255, 255, 255), bname, Color(255, 255, 255, 255), NC.Language.NameChanged..name..".")
end)

net.Receive("NotifyTaken", function()
	local name = net.ReadString()
	chat.AddText(Color(10, 150, 255), NC.Language.NameChangePrefixChat, Color(255, 255, 255, 255), NC.Language.NameTaken..name..NC.Language.NameTaken1)
end)

local BGBlur



net.Receive("NC_OpenJoinMenu", function()
	local ply = net.ReadEntity()
	if (!IsValid(BGBlur)) then
		BGBlur = vgui.Create( "DPanel" )
		BGBlur:SetPos( 0, 0 )
		BGBlur:SetSize( ScrW(), ScrH() )
		BGBlur.Paint = function(self, w, h)
			drawBlur( 0, 0, w, h, 2 )
			draw.RoundedBox( 0, 0, 0, w, h, Color(0, 0, 0, 175) )
		end
	end
	local FirstName
	local LastName
	local OnlyOne
	local Prefix
	if (!IsValid(NameChangePanel)) then
		local NameChangePanel = vgui.Create( "DFrame" )
		NameChangePanel:SetSize( 525, 350 )
		NameChangePanel:Center()
		NameChangePanel:SetTitle( " " )
		NameChangePanel:SetVisible( true )
		NameChangePanel:SetDraggable( false )
		NameChangePanel:ShowCloseButton( false )
		NameChangePanel:MakePopup()
		NameChangePanel.Paint = function(self, w, h)
			draw.RoundedBoxEx( 4, 0, 0, w, 30, NC.Color.Header, true, true, false, false )
			draw.RoundedBoxEx( 4, 0, 30, w, h-30, NC.Color.MainPage, false, false, true, true )
			draw.SimpleText( NC.Language.NameSetupTitle, "RCNPC_TitleText", NameChangePanel:GetWide()/2, 3, NC.Color.HeaderText, TEXT_ALIGN_CENTER )
			draw.SimpleText( NC.Language.NameSetupWelcome, "RCNPC_WelcomeText", NameChangePanel:GetWide()/2, 35, NC.Color.MainPageText, TEXT_ALIGN_CENTER )
			draw.SimpleText( NC.Language.NameSetupInfo, "RCNPC_InfoText", NameChangePanel:GetWide()/2, 67, NC.Color.MainPageText, TEXT_ALIGN_CENTER )
			if NC.EntryType == "two" then
				draw.SimpleText( NC.Language.FirstName, "RCNPC_EntryTitle", NameChangePanel:GetWide()/2, 103, NC.Color.HeaderText, TEXT_ALIGN_CENTER )
				if NC.UseWhiteList then
					if not CheckIfNameHasRightChar(FirstName:GetValue()) then
						draw.SimpleText( NC.Language.InvalidCharacter..GetInvalidChar(FirstName:GetValue()), "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 160, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif TooLongName("first", FirstName:GetValue()) then
						draw.SimpleText( NC.Language.ExceedsAmount, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 160, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif TooShortName("first", FirstName:GetValue()) then
						draw.SimpleText( NC.Language.NotEnoughAmount, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 160, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif not AppropriateCheck(FirstName:GetValue()) then
						draw.SimpleText( NC.Language.BadWord, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 160, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					else
						draw.SimpleText( NC.Language.GoodName, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 160, Color(0, 204, 0, 255), TEXT_ALIGN_CENTER )
					end
				else
					if not CheckIfValidName(FirstName:GetValue()) then
						draw.SimpleText( NC.Language.InvalidCharacter..GetInvalidChar(FirstName:GetValue()), "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 160, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif TooLongName("first", FirstName:GetValue()) then
						draw.SimpleText( NC.Language.ExceedsAmount, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 160, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif TooShortName("first", FirstName:GetValue()) then
						draw.SimpleText( NC.Language.NotEnoughAmount, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 160, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif not AppropriateCheck(FirstName:GetValue()) then
						draw.SimpleText( NC.Language.BadWord, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 160, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					else
						draw.SimpleText( NC.Language.GoodName, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 160, Color(0, 204, 0, 255), TEXT_ALIGN_CENTER )
					end
				end
				draw.SimpleText( NC.Language.LastName, "RCNPC_EntryTitle", NameChangePanel:GetWide()/2, 188, NC.Color.HeaderText, TEXT_ALIGN_CENTER )
				if NC.UseWhiteList then
					if not CheckIfNameHasRightChar(LastName:GetValue()) then
						draw.SimpleText( NC.Language.InvalidCharacter..GetInvalidChar(LastName:GetValue()), "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 243, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif TooLongName("last", LastName:GetValue()) then
						draw.SimpleText( NC.Language.ExceedsAmount, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 243, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif TooShortName("last", LastName:GetValue()) then
						draw.SimpleText( NC.Language.NotEnoughAmount, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 243, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif not AppropriateCheck(LastName:GetValue()) then
						draw.SimpleText( NC.Language.BadWord, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 243, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					else
						draw.SimpleText( NC.Language.GoodName, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 243, Color(0, 204, 0, 255), TEXT_ALIGN_CENTER )
					end
				else
					if not CheckIfValidName(LastName:GetValue()) then
						draw.SimpleText( NC.Language.InvalidCharacter..GetInvalidChar(FirstName:GetValue()), "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 243, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif TooLongName("last", LastName:GetValue()) then
						draw.SimpleText( NC.Language.ExceedsAmount, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 243, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif TooShortName("last", LastName:GetValue()) then
						draw.SimpleText( NC.Language.NotEnoughAmount, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 243, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif not AppropriateCheck(LastName:GetValue()) then
						draw.SimpleText( NC.Language.BadWord, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 243, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					else
						draw.SimpleText( NC.Language.GoodName, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 243, Color(0, 204, 0, 255), TEXT_ALIGN_CENTER )
					end
				end
			elseif NC.EntryType == "one" then
				draw.SimpleText( "Name", "RCNPC_EntryTitle", NameChangePanel:GetWide()/2, NameChangePanel:GetTall()/2-40, NC.Color.HeaderText, TEXT_ALIGN_CENTER )
				if NC.UseWhiteList then
					if not CheckIfNameHasRightChar(OnlyOne:GetValue()) then
						draw.SimpleText( NC.Language.InvalidCharacter..GetInvalidChar(FirstName:GetValue()), "RCNPC_InvalidText", NameChangePanel:GetWide()/2, NameChangePanel:GetTall()/2+16, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif TooLongName("first", OnlyOne:GetValue()) then
						draw.SimpleText( NC.Language.ExceedsAmount, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, NameChangePanel:GetTall()/2+16, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif TooShortName("first", OnlyOne:GetValue()) then
						draw.SimpleText( NC.Language.NotEnoughAmount, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, NameChangePanel:GetTall()/2+16, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif not AppropriateCheck(OnlyOne:GetValue()) then
						draw.SimpleText( NC.Language.BadWord, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, NameChangePanel:GetTall()/2+16, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif not CheckOneSpace(OnlyOne:GetValue()) then
						draw.SimpleText( NC.Language.OneSpace, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, NameChangePanel:GetTall()/2+16, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					else
						draw.SimpleText( NC.Language.GoodName, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, NameChangePanel:GetTall()/2+16, Color(0, 204, 0, 255), TEXT_ALIGN_CENTER )
					end
				else
					if not CheckIfValidName(OnlyOne:GetValue()) then
						draw.SimpleText( NC.Language.InvalidCharacter..GetInvalidChar(FirstName:GetValue()), "RCNPC_InvalidText", NameChangePanel:GetWide()/2, NameChangePanel:GetTall()/2+16, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif TooLongName("first", OnlyOne:GetValue()) then
						draw.SimpleText( NC.Language.ExceedsAmount, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, NameChangePanel:GetTall()/2+16, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif TooShortName("first", OnlyOne:GetValue()) then
						draw.SimpleText( NC.Language.NotEnoughAmount, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, NameChangePanel:GetTall()/2+16, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif not AppropriateCheck(OnlyOne:GetValue()) then
						draw.SimpleText( NC.Language.BadWord, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, NameChangePanel:GetTall()/2+16, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif not CheckOneSpace(OnlyOne:GetValue()) then
						draw.SimpleText( NC.Language.OneSpace, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, NameChangePanel:GetTall()/2+16, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					else
						draw.SimpleText( NC.Language.GoodName, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, NameChangePanel:GetTall()/2+16, Color(0, 204, 0, 255), TEXT_ALIGN_CENTER )
					end
				end
			elseif NC.EntryType == "prefix" then
				draw.SimpleText( NC.Language.Prefix, "RCNPC_EntryTitle", NameChangePanel:GetWide()/2, 103, NC.Color.EntryText, TEXT_ALIGN_CENTER )
				if NC.UseWhiteList then
					if Prefix:GetValue() == NC.Language.Selection then
						draw.SimpleText( NC.Language.PrefixInfo, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 160, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					else
						draw.SimpleText( NC.Language.PrefixGood, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 160, Color(0, 204, 0, 255), TEXT_ALIGN_CENTER )
					end
				else
					if not CheckIfValidName(FirstName:GetValue()) then
						draw.SimpleText( NC.Language.InvalidCharacter..GetInvalidChar(FirstName:GetValue()), "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 160, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif TooLongName("first", FirstName:GetValue()) then
						draw.SimpleText( NC.Language.ExceedsAmount, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 160, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif TooShortName("first", FirstName:GetValue()) then
						draw.SimpleText( NC.Language.NotEnoughAmount, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 160, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif not AppropriateCheck(FirstName:GetValue()) then
						draw.SimpleText( NC.Language.BadWord, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 160, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					else
						draw.SimpleText( NC.Language.GoodName, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 160, Color(0, 204, 0, 255), TEXT_ALIGN_CENTER )
					end
				end
				draw.SimpleText( NC.Language.OneEntry, "RCNPC_EntryTitle", NameChangePanel:GetWide()/2, 188, NC.Color.EntryText, TEXT_ALIGN_CENTER )
				if NC.UseWhiteList then
					if not CheckIfNameHasRightChar(LastName:GetValue()) then
						draw.SimpleText( NC.Language.InvalidCharacter..GetInvalidChar(FirstName:GetValue()), "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 243, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif TooLongName("last", LastName:GetValue()) then
						draw.SimpleText( NC.Language.ExceedsAmount, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 243, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif TooShortName("last", LastName:GetValue()) then
						draw.SimpleText( NC.Language.NotEnoughAmount, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 243, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif not AppropriateCheck(LastName:GetValue()) then
						draw.SimpleText( NC.Language.BadWord, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 243, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif not CheckOneSpace(LastName:GetValue()) then
						draw.SimpleText( NC.Language.OneSpace, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 243, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					else
						draw.SimpleText( NC.Language.GoodName, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 243, Color(0, 204, 0, 255), TEXT_ALIGN_CENTER )
					end
				else
					if not CheckIfValidName(LastName:GetValue()) then
						draw.SimpleText( NC.Language.InvalidCharacter..GetInvalidChar(FirstName:GetValue()), "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 243, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif TooLongName("last", LastName:GetValue()) then
						draw.SimpleText( NC.Language.ExceedsAmount, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 243, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif TooShortName("last", LastName:GetValue()) then
						draw.SimpleText( NC.Language.NotEnoughAmount, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 243, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif not AppropriateCheck(LastName:GetValue()) then
						draw.SimpleText( NC.Language.BadWord, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 243, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					elseif not CheckOneSpace(LastName:GetValue()) then
						draw.SimpleText( NC.Language.OneSpace, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 243, Color(255, 20, 10, 255), TEXT_ALIGN_CENTER )
					else
						draw.SimpleText( NC.Language.GoodName, "RCNPC_InvalidText", NameChangePanel:GetWide()/2, 243, Color(0, 204, 0, 255), TEXT_ALIGN_CENTER )
					end
				end
			end
		end

		if NC.EntryType == "two" then
			FirstName = vgui.Create( "DTextEntry", NameChangePanel )
			FirstName:SetSize( 200, 28 )
			FirstName:SetPos( (NameChangePanel:GetWide()/2)-(FirstName:GetWide()/2), 128 )
			FirstName:SetFont("RCNPC_EntryText")
			FirstName:SetTextColor(RCNPC_EntryText)
		end

		if NC.EntryType == "prefix" then
			Prefix = vgui.Create( "DComboBox", NameChangePanel )
			Prefix:SetSize( 200, 28 )
			Prefix:SetPos( (NameChangePanel:GetWide()/2)-(Prefix:GetWide()/2), 128 )
			Prefix:SetValue( NC.Language.Selection )
			for k, v in pairs(NC.Prefix) do
				Prefix:AddChoice( v )
			end
		end

		if NC.EntryType == "two" or NC.EntryType == "prefix" then
			LastName = vgui.Create( "DTextEntry", NameChangePanel )
			LastName:SetSize( 200, 28 )
			LastName:SetPos( (NameChangePanel:GetWide()/2)-(LastName:GetWide()/2), 213 )
			LastName:SetFont("RCNPC_EntryText")
			LastName:SetTextColor(RCNPC_EntryText)
		end

		if NC.EntryType == "one" then
			OnlyOne = vgui.Create( "DTextEntry", NameChangePanel )
			OnlyOne:SetSize( 200, 28 )
			OnlyOne:SetPos( (NameChangePanel:GetWide()/2)-(OnlyOne:GetWide()/2), NameChangePanel:GetTall()/2-14 )
			OnlyOne:SetFont("RCNPC_EntryText")
			OnlyOne:SetTextColor(RCNPC_EntryText)
		end

		local ChangeButton = vgui.Create( "DButton", NameChangePanel )
		ChangeButton:SetSize( 180, 50 )
		ChangeButton:SetPos( NameChangePanel:GetWide()/2-(ChangeButton:GetWide()/2),NameChangePanel:GetTall()-65 )
		ChangeButton:SetText( "" )
		ChangeButton:SetTextColor( NC.Color.CloseButton )
		ChangeButton.Paint = function(self, w, h)
			draw.RoundedBox( 0, 0, 0, w, h, NC.Color.AcceptButton )
			draw.SimpleText( NC.Language.ChangeButton, "RCNPC_EntryTitle", w/2, 15, NC.Color.HeaderText, TEXT_ALIGN_CENTER )
		end
		ChangeButton.DoClick = function()
			if NC.EntryType == "two" then
				if (FirstName:GetValue() != "" and LastName:GetValue() != "") then
					if not TooLongName("first", FirstName:GetValue()) and not TooLongName("last", LastName:GetValue()) then
						if not TooShortName("first", FirstName:GetValue()) and not TooShortName("last", LastName:GetValue()) then
							if NC.UseWhiteList then
								if CheckIfNameHasRightChar(FirstName:GetValue()) and CheckIfNameHasRightChar(LastName:GetValue()) then
									if AppropriateCheck(FirstName:GetValue()) and AppropriateCheck(LastName:GetValue()) then
										NCRequestBox(NC.Language.NameSetupConfirmation, "'"..FirstName:GetValue().." "..LastName:GetValue().."'?", NC.Language.CheckChangeAnswer1, function()
											net.Start("NC_SetInitialName")
												net.WriteString(FirstName:GetValue())
												net.WriteString(LastName:GetValue())
											net.SendToServer()
											NameChangePanel:Remove()
											if IsValid(BGBlur) then
												BGBlur:Remove()
											end
										end, NC.Language.CheckChangeAnswer2, function() return end)
									else
										NCRequestBox(NC.Language.ErrorInappropriate1, NC.Language.ErrorInappropriate2, NC.Language.ErrorOk, function() return end)
									end
								else
									NCRequestBox(NC.Language.ErrorUnauthorized1, NC.Language.ErrorUnauthorized2, NC.Language.ErrorOk, function() return end)
								end
							else
								if CheckIfValidName(FirstName:GetValue()) and CheckIfValidName(LastName:GetValue()) then
									if AppropriateCheck(FirstName:GetValue()) and AppropriateCheck(LastName:GetValue()) then
										NCRequestBox(NC.Language.NameSetupConfirmation, "'"..FirstName:GetValue().." "..LastName:GetValue().."'?", NC.Language.CheckChangeAnswer1, function()
											net.Start("NC_SetInitialName")
												net.WriteString(FirstName:GetValue())
												net.WriteString(LastName:GetValue())
											net.SendToServer()
											NameChangePanel:Remove()
											if IsValid(BGBlur) then
												BGBlur:Remove()
											end
										end, NC.Language.CheckChangeAnswer2, function() return end)
									else
										NCRequestBox(NC.Language.ErrorInappropriate1, NC.Language.ErrorInappropriate2, NC.Language.ErrorOk, function() return end)
									end
								else
									NCRequestBox(NC.Language.ErrorUnauthorized1, NC.Language.ErrorUnauthorized2, NC.Language.ErrorOk, function() return end)
								end
							end
						else
							NCRequestBox(NC.Language.ErrorNotEnoughCharacter1, NC.Language.ErrorNotEnoughCharacter2, NC.Language.ErrorOk, function() return end)
						end
					else
						NCRequestBox(NC.Language.ErrorTooManyCharacter1, NC.Language.ErrorTooManyCharacter2, NC.Language.ErrorOk, function() return end)
					end
				else
					NCRequestBox(NC.Language.ErrorNonValidName, "", NC.Language.ErrorOk, function() return end)
				end
			elseif NC.EntryType == "one" then
				if (OnlyOne:GetValue() != "") then
					if not TooLongName("first", OnlyOne:GetValue()) then
						if not TooShortName("first", OnlyOne:GetValue()) then
							if NC.UseWhiteList then
								if CheckIfNameHasRightChar(OnlyOne:GetValue()) then
									if AppropriateCheck(OnlyOne:GetValue()) then
										NCRequestBox(NC.Language.NameSetupConfirmation, "'"..OnlyOne:GetValue().."'?", NC.Language.CheckChangeAnswer1, function()
											net.Start("NC_SetInitialName")
												net.WriteString(OnlyOne:GetValue())
											net.SendToServer()
											NameChangePanel:Remove()
											if IsValid(BGBlur) then
												BGBlur:Remove()
											end
										end, NC.Language.CheckChangeAnswer2, function() return end)
									else
										NCRequestBox(NC.Language.ErrorInappropriate1, NC.Language.ErrorInappropriate2, NC.Language.ErrorOk, function() return end)
									end
								else
									NCRequestBox(NC.Language.ErrorUnauthorized1, NC.Language.ErrorUnauthorized2, NC.Language.ErrorOk, function() return end)
								end
							else
								if CheckIfValidName(OnlyOne:GetValue()) then
									if AppropriateCheck(OnlyOne:GetValue()) then
										NCRequestBox(NC.Language.NameSetupConfirmation, "'"..OnlyOne:GetValue().."'?", NC.Language.CheckChangeAnswer1, function()
											net.Start("NC_SetInitialName")
												net.WriteString(OnlyOne:GetValue())
											net.SendToServer()
											NameChangePanel:Remove()
											if IsValid(BGBlur) then
												BGBlur:Remove()
											end
										end, NC.Language.CheckChangeAnswer2, function() return end)
									else
										NCRequestBox(NC.Language.ErrorInappropriate1, NC.Language.ErrorInappropriate2, NC.Language.ErrorOk, function() return end)
									end
								else
									NCRequestBox(NC.Language.ErrorUnauthorized1, NC.Language.ErrorUnauthorized2, NC.Language.ErrorOk, function() return end)
								end
							end
						else
							NCRequestBox(NC.Language.ErrorNotEnoughCharacter1, NC.Language.ErrorNotEnoughCharacter2, NC.Language.ErrorOk, function() return end)
						end
					else
						NCRequestBox(NC.Language.ErrorTooManyCharacter1, NC.Language.ErrorTooManyCharacter2, NC.Language.ErrorOk, function() return end)
					end
				else
					NCRequestBox(NC.Language.ErrorNonValidName, "", NC.Language.ErrorOk, function() return end)
				end
			elseif NC.EntryType == "prefix" then
				if Prefix:GetValue() != NC.Language.Selection then
					if LastName:GetValue() != "" and CheckIfPrefix(Prefix:GetValue()) then
						if not TooLongName("first", LastName:GetValue()) then
							if not TooShortName("first", LastName:GetValue()) then
								if NC.UseWhiteList then
									if CheckIfNameHasRightChar(LastName:GetValue()) then
										if AppropriateCheck(LastName:GetValue()) then
											NCRequestBox(NC.Language.NameSetupConfirmation, "'"..Prefix:GetValue().." "..LastName:GetValue().."'?", NC.Language.CheckChangeAnswer1, function()
												net.Start("NC_SetInitialName")
													net.WriteString(Prefix:GetValue())
													net.WriteString(LastName:GetValue())
												net.SendToServer()
												NameChangePanel:Remove()
												if IsValid(BGBlur) then
													BGBlur:Remove()
												end
											end, NC.Language.CheckChangeAnswer2, function() return end)
										else
											NCRequestBox(NC.Language.ErrorInappropriate1, NC.Language.ErrorInappropriate2, NC.Language.ErrorOk, function() return end)
										end
									else
										NCRequestBox(NC.Language.ErrorUnauthorized1, NC.Language.ErrorUnauthorized2, NC.Language.ErrorOk, function() return end)
									end
								else
									if CheckIfValidName(LastName:GetValue()) then
										if AppropriateCheck(LastName:GetValue()) then
											NCRequestBox(NC.Language.NameSetupConfirmation, "'"..Prefix:GetValue().." "..LastName:GetValue().."'?", NC.Language.CheckChangeAnswer1, function()
												net.Start("NC_SetInitialName")
													net.WriteString(Prefix:GetValue())
													net.WriteString(LastName:GetValue())
												net.SendToServer()
												NameChangePanel:Remove()
												if IsValid(BGBlur) then
													BGBlur:Remove()
												end
											end, NC.Language.CheckChangeAnswer2, function() return end)
										else
											NCRequestBox(NC.Language.ErrorInappropriate1, NC.Language.ErrorInappropriate2, NC.Language.ErrorOk, function() return end)
										end
									else
										NCRequestBox(NC.Language.ErrorUnauthorized1, NC.Language.ErrorUnauthorized2, NC.Language.ErrorOk, function() return end)
									end
								end
							else
								NCRequestBox(NC.Language.ErrorNotEnoughCharacter1, NC.Language.ErrorNotEnoughCharacter2, NC.Language.ErrorOk, function() return end)
							end
						else
							NCRequestBox(NC.Language.ErrorTooManyCharacter1, NC.Language.ErrorTooManyCharacter2, NC.Language.ErrorOk, function() return end)
						end
					else
						NCRequestBox(NC.Language.ErrorNonValidName, "", NC.Language.ErrorOk, function() return end)
					end
				else
					NCRequestBox(NC.Language.ErrorPrefix, "", NC.Language.ErrorOk, function() return end)
				end
			end
		end
	end
end)

local function NameInputWindow(selected)
	NC.Language.AdminChangeInfo = "Please enter a valid name for this player."
	NC.Language.AdminButton1 = "Change"
	if (!IsValid(RequestInput)) then
		local RequestInput = vgui.Create( "DFrame" )
		RequestInput:SetSize( 400, 140 )
		RequestInput:Center()
		RequestInput:SetTitle( " " )
		RequestInput:SetVisible( true )
		RequestInput:SetDraggable( false )
		RequestInput:ShowCloseButton( false )
		RequestInput:MakePopup()
		RequestInput.Paint = function(self, w, h)
			draw.RoundedBoxEx( 4, 0, 0, w, 30, NC.Color.Header, true, true, false, false )
			draw.RoundedBoxEx( 4, 0, 30, w, h-30, NC.Color.MainPage, false, false, true, true )
			draw.SimpleText( NC.Language.AdminChangeInfo, "RCNPC_InfoText", RequestInput:GetWide()/2, 35, NC.Color.MainPageText, TEXT_ALIGN_CENTER )
		end

		local name = vgui.Create( "DTextEntry", RequestInput )
		name:SetSize( 200, 28 )
		name:SetPos( (RequestInput:GetWide()/2)-(name:GetWide()/2), 60 )
		name:SetFont("RCNPC_EntryText")
		name:SetTextColor(RCNPC_EntryText)

		local Button1 = vgui.Create( "DButton", RequestInput )
		Button1:SetSize( 76, 30 )
		Button1:SetPos( RequestInput:GetWide()/2-38,RequestInput:GetTall()-40 )
		Button1:SetText( "" )
		Button1:SetTextColor( NC.Color.CloseButton )
		Button1.Paint = function(self, w, h)
			draw.RoundedBox( 0, 0, 0, w, h, NC.Color.AcceptButton )
			draw.SimpleText( NC.Language.AdminButton1, "RCNPC_EntryTitle", Button1:GetWide()/2, 5, NC.Color.HeaderText, TEXT_ALIGN_CENTER )
		end
		Button1.DoClick = function()
			LocalPlayer():ConCommand("darkrp forcerpname "..string.Explode(" ", selected:Nick())[1].." "..name:GetValue())
			RequestInput:Remove()
		end

		local CloseButton = vgui.Create( "DButton", RequestInput )
		CloseButton:SetSize( 25, 30 )
		CloseButton:SetPos( RequestInput:GetWide() - 25,0 )
		CloseButton:SetText( "r" )
		CloseButton:SetFont( "Marlett" )
		CloseButton:SetTextColor( NC.Color.CloseButton )
		CloseButton.Paint = function(self, w, h)
			--draw.RoundedBoxEx( 4, 0, 0, w, h, Color(10,150,255, 255), false, false, true, true )
			--draw.SimpleText( "ADMIN", "RCNPC_AdminText", w/2, 3, NC.Color.HeaderText, TEXT_ALIGN_CENTER )
		end
		CloseButton.DoClick = function()
			RequestInput:Remove()
		end
	end
end

net.Receive("OpenNCAdmin", function()
	NC.Language.AdminPanelTitle = "RP Name Admin Panel"
	NC.Language.AdminPanelInfo = "Welcome to the adminastrative panel. Here you can edit a players name."
	NC.Language.AdminPanelInfo2 = "Select a player and use one of the commands on him/her!"
	NC.Language.AdminPanelColumn = "Players"
	NC.Language.AdminPanelColumn2 = "Commands"
	NC.Language.CommandName = "Force Change Name"
	NC.Language.PlayerSelect = "You must select a "
	NC.Language.PlayerSelect2 = "player!"
	if LocalPlayer():IsNCAdmin() then
		if !IsValid(NameChangePanel) then
			local FirstName
			local LastName
			local OnlyOne
			local Prefix
			local NameChangePanel = vgui.Create( "DFrame" )
			NameChangePanel:SetSize( 575, 375 )
			NameChangePanel:Center()
			NameChangePanel:SetTitle( " " )
			NameChangePanel:SetVisible( true )
			NameChangePanel:SetDraggable( false )
			NameChangePanel:ShowCloseButton( false )
			NameChangePanel:MakePopup()
			NameChangePanel.Paint = function(self, w, h)
				draw.RoundedBoxEx( 4, 0, 0, w, 30, NC.Color.Header, true, true, false, false )
				draw.RoundedBoxEx( 4, 0, 30, w, h-30, NC.Color.MainPage, false, false, true, true )
				draw.SimpleText( NC.Language.AdminPanelTitle, "RCNPC_TitleText", NameChangePanel:GetWide()/2, 3, NC.Color.HeaderText, TEXT_ALIGN_CENTER )
				draw.SimpleText( NC.Language.AdminPanelInfo, "RCNPC_InfoText", NameChangePanel:GetWide()/2, 35, NC.Color.MainPageText, TEXT_ALIGN_CENTER )
				draw.SimpleText( NC.Language.AdminPanelInfo2, "RCNPC_InfoText", NameChangePanel:GetWide()/2, 55, NC.Color.MainPageText, TEXT_ALIGN_CENTER )
				draw.RoundedBox( 4, 10, 80, w/2-15, h-90, NC.Color.MainPageSecondary)
				draw.RoundedBox( 4, w/2+5, 80, w/2-15, h-90, NC.Color.MainPageSecondary)
				draw.SimpleText( NC.Language.AdminPanelColumn, "RCNPC_WelcomeText", 10+((w/2-15)/2), 82, NC.Color.MainPageText, TEXT_ALIGN_CENTER )
				draw.SimpleText( NC.Language.AdminPanelColumn2, "RCNPC_WelcomeText", (w/2+5)+((w/2-15)/2), 82, NC.Color.MainPageText, TEXT_ALIGN_CENTER )
			end
			NameChangePanel.Selected = nil

			local MemberScrollPanel = vgui.Create( "DScrollPanel", NameChangePanel )
			MemberScrollPanel:SetSize( NameChangePanel:GetWide()/2-23, NameChangePanel:GetTall()-123 )
			MemberScrollPanel:SetPos( 14, 113 )
			MemberScrollPanel.VBar.Paint = function(self, w, h)
				draw.RoundedBox( 0, 5, 0, w-5, h, NC.Color.MainPageSecondary )
			end
			MemberScrollPanel.VBar.btnUp.Paint = function(self, w, h)
			end
			MemberScrollPanel.VBar.btnDown.Paint = function(self, w, h)
			end
			MemberScrollPanel.VBar.btnGrip.Paint = function(self, w, h)
				draw.RoundedBox( 0, 5, 0, w-5, h, NC.Color.Header )
			end

			local MemberList = vgui.Create( "DIconLayout", MemberScrollPanel )
			MemberList:SetSize( MemberScrollPanel:GetWide(), MemberScrollPanel:GetTall() )
			MemberList:SetPos( 0, 0 )
			MemberList:SetSpaceX( 0 )
			MemberList:SetSpaceY( 1 )

			for k, v in pairs(player.GetAll()) do
				if not v:IsValid() then return end
				local playerbut = vgui.Create( "DButton" )
				playerbut:SetSize( NameChangePanel:GetWide()/2-23, 30 )
				playerbut:SetText( "" )
				playerbut:SetFont( "Marlett" )
				playerbut:SetTextColor( NC.Color.CloseButton )
				playerbut.Paint = function(self, w, h)
					if not v:IsValid() then return end
					if NameChangePanel.Selected == v then
						draw.RoundedBoxEx( 4, 0, 0, w, h, Color(130,175,255, 255), true, true, true, true )
					else
						draw.RoundedBoxEx( 4, 0, 0, w, h, Color(10,150,255, 255), true, true, true, true )
					end
					draw.SimpleText( v:Nick(), "RCNPC_AdminText", w/2, 7, NC.Color.HeaderText, TEXT_ALIGN_CENTER )
				end
				playerbut.DoClick = function()
					NameChangePanel.Selected = v
				end
				MemberList:Add(playerbut)
			end

			local Commands = {
				{title = NC.Language.CommandName, func = function(selected) NameInputWindow(selected) end}
			}

			local CommandScrollPanel = vgui.Create( "DScrollPanel", NameChangePanel )
			CommandScrollPanel:SetSize( NameChangePanel:GetWide()/2-23, NameChangePanel:GetTall()-123 )
			CommandScrollPanel:SetPos( NameChangePanel:GetWide()/2+10, 113 )
			CommandScrollPanel.VBar.Paint = function(self, w, h)
				draw.RoundedBox( 0, 5, 0, w-5, h, NC.Color.MainPageSecondary )
			end
			CommandScrollPanel.VBar.btnUp.Paint = function(self, w, h)
			end
			CommandScrollPanel.VBar.btnDown.Paint = function(self, w, h)
			end
			CommandScrollPanel.VBar.btnGrip.Paint = function(self, w, h)
				draw.RoundedBox( 0, 5, 0, w-5, h, NC.Color.Header )
			end

			local CommandList = vgui.Create( "DIconLayout", CommandScrollPanel )
			CommandList:SetSize( CommandScrollPanel:GetWide(), CommandScrollPanel:GetTall() )
			CommandList:SetPos( 0, 0 )
			CommandList:SetSpaceX( 0 )
			CommandList:SetSpaceY( 1 )

			for k, v in pairs(Commands) do
				local command = vgui.Create( "DButton", NameChangePanel )
				command:SetSize( NameChangePanel:GetWide()/2-23, 30 )
				command:SetText( "" )
				command:SetFont( "Marlett" )
				command:SetTextColor( NC.Color.CloseButton )
				command.Paint = function(self, w, h)
					draw.RoundedBoxEx( 4, 0, 0, w, h, Color(255,153,51, 255), true, true, true, true )
					draw.SimpleText( v.title, "RCNPC_AdminText", w/2, 7, NC.Color.HeaderText, TEXT_ALIGN_CENTER )
				end
				command.DoClick = function()
					if NameChangePanel.Selected != nil then
						v.func(NameChangePanel.Selected)
					else
						NCRequestBox(NC.Language.PlayerSelect, NC.Language.PlayerSelect2, NC.Language.ErrorOk, function() return end)
					end
				end
				CommandList:Add(command)
			end

			local CloseButton = vgui.Create( "DButton", NameChangePanel )
			CloseButton:SetSize( 25, 30 )
			CloseButton:SetPos( NameChangePanel:GetWide() - 25,0 )
			CloseButton:SetText( "r" )
			CloseButton:SetFont( "Marlett" )
			CloseButton:SetTextColor( NC.Color.CloseButton )
			CloseButton.Paint = function(self, w, h)
				--draw.RoundedBoxEx( 4, 0, 0, w, h, Color(10,150,255, 255), false, false, true, true )
				--draw.SimpleText( "ADMIN", "RCNPC_AdminText", w/2, 3, NC.Color.HeaderText, TEXT_ALIGN_CENTER )
			end
			CloseButton.DoClick = function()
				NameChangePanel:Remove()
			end
		end
	end
end)
 