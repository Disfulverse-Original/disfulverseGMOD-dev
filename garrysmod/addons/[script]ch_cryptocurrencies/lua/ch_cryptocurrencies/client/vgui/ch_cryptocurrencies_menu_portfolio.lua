--[[
	PORTFOLIO MENU
--]]
function CH_CryptoCurrencies.PortfolioMenu()
	local TotalBalance = 0
	local ply = LocalPlayer()
	
	local scr_w = ScrW()
	local scr_h = ScrH()
	
	local GUI_PortfolioFrame = vgui.Create( "DFrame" )
	GUI_PortfolioFrame:SetTitle( "" )
	GUI_PortfolioFrame:SetSize( scr_w * 0.37, scr_h * 0.485 )
	GUI_PortfolioFrame:Center()
	GUI_PortfolioFrame.Paint = function( self, w, h )
		-- Draw frame
		draw.RoundedBox( 8, 0, 0, w, h, CH_CryptoCurrencies.Colors.LightGray )
		
		-- Draw top
		draw.RoundedBoxEx( 8, 0, 0, w, scr_h * 0.03, CH_CryptoCurrencies.Colors.DarkGray, true, true, false, false )

		-- Draw the top title.
		draw.SimpleText( CH_CryptoCurrencies.LangString( "Crypto Portfolio" ), "CH_CryptoCurrency_Font_Size8", w / 2, scr_h * 0.015, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_PortfolioFrame:MakePopup()
	GUI_PortfolioFrame:SetDraggable( false )
	GUI_PortfolioFrame:ShowCloseButton( false )
	
	local GUI_CloseMenu = vgui.Create( "DButton", GUI_PortfolioFrame )
	GUI_CloseMenu:SetPos( scr_w * 0.355, scr_h * 0.01 )
	GUI_CloseMenu:SetSize( 16, 16 )
	GUI_CloseMenu:SetText( "" )
	GUI_CloseMenu.Paint = function( self, w, h )
		surface.SetDrawColor( color_white )
		surface.SetMaterial( CH_CryptoCurrencies.Materials.CloseIcon )
		surface.DrawTexturedRect( 0, 0, 16, 16 )
	end
	GUI_CloseMenu.DoClick = function()
		GUI_PortfolioFrame:Remove()
	end
	
	local GUI_BuyCryptoFrameBtn = vgui.Create( "DButton", GUI_PortfolioFrame )
	GUI_BuyCryptoFrameBtn:SetSize( scr_w * 0.1, scr_h * 0.03 )
	GUI_BuyCryptoFrameBtn:SetPos( scr_w * 0.005, scr_h * 0.0375 )
	GUI_BuyCryptoFrameBtn:SetTextColor( Color( 0, 0, 0, 255 ) )
	GUI_BuyCryptoFrameBtn:SetText( "" )
	GUI_BuyCryptoFrameBtn.Paint = function( self, w, h )
		draw.RoundedBox( 8, 0, 0, w, h, CH_CryptoCurrencies.Colors.DarkGray )
		
		if self:IsHovered() then
			draw.RoundedBoxEx( 8, 0, h * 0.8, w, h * 0.2, CH_CryptoCurrencies.Colors.GMSBlue, false, false, true, true )
		end
		
		draw.SimpleText( CH_CryptoCurrencies.LangString( "Cryptos" ), "CH_CryptoCurrency_Font_Size8", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		
	end
	GUI_BuyCryptoFrameBtn.DoClick = function()
		GUI_PortfolioFrame:Remove()
		
		CH_CryptoCurrencies.CryptoMenu()
	end
	
	local GUI_PortfolioFrameBtn = vgui.Create( "DButton", GUI_PortfolioFrame )
	GUI_PortfolioFrameBtn:SetSize( scr_w * 0.1, scr_h * 0.03 )
	GUI_PortfolioFrameBtn:SetPos( scr_w * 0.11, scr_h * 0.0375 )
	GUI_PortfolioFrameBtn:SetTextColor( Color( 0, 0, 0, 255 ) )
	GUI_PortfolioFrameBtn:SetText( "" )
	GUI_PortfolioFrameBtn.Paint = function( self, w, h )
		draw.RoundedBox( 8, 0, 0, w, h, CH_CryptoCurrencies.Colors.DarkGray )
		
		if IsValid( GUI_PortfolioFrame ) and not GUI_BuyCryptoFrameBtn:IsHovered() then
			draw.RoundedBoxEx( 8, 0, h * 0.8, w, h * 0.2, CH_CryptoCurrencies.Colors.GMSBlue, false, false, true, true )
		elseif self:IsHovered() then
			draw.RoundedBoxEx( 8, 0, h * 0.8, w, h * 0.2, CH_CryptoCurrencies.Colors.GMSBlue, false, false, true, true )
		end
		
		draw.SimpleText( CH_CryptoCurrencies.LangString( "Portfolio" ), "CH_CryptoCurrency_Font_Size8", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_PortfolioFrameBtn.DoClick = function()
	end
	
	local GUI_DrawTotalBalance = vgui.Create( "DPanel", GUI_PortfolioFrame )
	GUI_DrawTotalBalance:SetPos( scr_w * 0.215, scr_h * 0.0375 )
	GUI_DrawTotalBalance:SetSize( scr_w * 0.1375, scr_h * 0.03 )
	GUI_DrawTotalBalance.Paint = function( self, w, h )
		-- Draw total balance
		draw.RoundedBox( 8, 0, 0, w, h, CH_CryptoCurrencies.Colors.DarkGray )
		draw.SimpleText( CH_CryptoCurrencies.LangString( "Total balance" ) ..": ".. CH_CryptoCurrencies.FormatMoney( TotalBalance ), "CH_CryptoCurrency_Font_Size8", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	
	local GUI_CryptoList = vgui.Create( "DPanelList", GUI_PortfolioFrame )
	GUI_CryptoList:SetSize( scr_w * 0.36, scr_w * 0.225 )
	GUI_CryptoList:SetPos( scr_w * 0.005, scr_h * 0.075 )
	GUI_CryptoList:EnableVerticalScrollbar( true )
	GUI_CryptoList:EnableHorizontal( true )
	GUI_CryptoList:SetSpacing( 7 )
	GUI_CryptoList.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, CH_CryptoCurrencies.Colors.Invisible )
	end
	
	if ( GUI_CryptoList.VBar ) then
		GUI_CryptoList.VBar.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, CH_CryptoCurrencies.Colors.Invisible ) -- BG
		end
		
		GUI_CryptoList.VBar.btnUp.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, CH_CryptoCurrencies.Colors.Invisible )
		end
		
		GUI_CryptoList.VBar.btnGrip.Paint = function( self, w, h )
			draw.RoundedBoxEx( 8, 0, 0, w, h, CH_CryptoCurrencies.Colors.DarkGray, true, true, true, true )
		end
		
		GUI_CryptoList.VBar.btnDown.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, CH_CryptoCurrencies.Colors.Invisible )
		end
	end
	
	for index, crypto in ipairs( CH_CryptoCurrencies.CryptosCL ) do
		local prefix = crypto.Currency
		local player_owns = math.Round( ply.CH_CryptoCurrencies_Wallet[ prefix ].Amount, 7 )
		local crypto_worth = math.Round( player_owns * crypto.Price )
		
		-- Update total balance for the frame
		TotalBalance = TotalBalance + crypto_worth
		
		if CH_CryptoCurrencies.CryptoIconsCL[ prefix ] then -- Check if this exists. If this doesn't exist it means we have some coins that are no longer available on the server and thus we don't show that.
			if player_owns > 0 then
				local GUI_CryptoPortfolioPanel = vgui.Create( "DPanelList" )
				GUI_CryptoPortfolioPanel:SetSize( scr_w * 0.348, scr_h * 0.075 )
				GUI_CryptoPortfolioPanel.Paint = function( self, w, h )
					-- Background
					draw.RoundedBox( 8, 0, 0, w, h, CH_CryptoCurrencies.Colors.DarkGray )

					-- Coin Icon
					surface.SetDrawColor( color_white )
					surface.SetMaterial( crypto.Icon )
					surface.DrawTexturedRect( w * 0.0125, h * 0.1, 64, 64 )
					
					-- Vertical seperator line
					surface.SetDrawColor( CH_CryptoCurrencies.Colors.WhiteAlpha )
					surface.DrawRect( w * 0.12, h * 0.135, 2.5, scr_h * 0.0565 )
					
					-- Vertical seperator line END
					surface.SetDrawColor( CH_CryptoCurrencies.Colors.WhiteAlpha )
					surface.DrawRect( w * 0.825, h * 0.135, 2.5, scr_h * 0.0565 )
					
					-- Horizontal seperator line
					surface.SetDrawColor( CH_CryptoCurrencies.Colors.WhiteAlpha )
					surface.DrawRect( w * 0.135, h * 0.5, scr_w * 0.235, 2.5 )
					
					--[[
						Coin Name & Price
					--]]
					draw.SimpleText( crypto.Name, "CH_CryptoCurrency_Font_Size10", w * 0.135, h * 0.25, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					
					surface.SetFont( "CH_CryptoCurrency_Font_Size8" )
					local x, y = surface.GetTextSize( string.format( "%f", player_owns ) )
					
					draw.SimpleText( string.format( "%f", player_owns ), "CH_CryptoCurrency_Font_Size8", w * 0.135, h * 0.75, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					draw.SimpleText( prefix, "CH_CryptoCurrency_Font_Size6", w * 0.135 + ( x + scr_w * 0.0015 ), h * 0.775, CH_CryptoCurrencies.Colors.WhiteAlpha2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					
					--[[
						Worth
					--]]
					draw.SimpleText( CH_CryptoCurrencies.LangString( "Worth" ), "CH_CryptoCurrency_Font_Size10", w * 0.805, h * 0.25, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )

					draw.SimpleText( string.Comma( crypto_worth ), "CH_CryptoCurrency_Font_Size8", w * 0.77, h * 0.75, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
					draw.SimpleText( CH_CryptoCurrencies.CurrencyAbbreviation(), "CH_CryptoCurrency_Font_Size6", w * 0.81, h * 0.775, CH_CryptoCurrencies.Colors.WhiteAlpha2, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
				end
				
				local GUI_SendCrypto = vgui.Create( "DButton", GUI_CryptoPortfolioPanel )
				GUI_SendCrypto:SetSize( scr_w * 0.05, scr_h * 0.057 )
				GUI_SendCrypto:SetPos( scr_w * 0.2925, scr_h * 0.01 )
				GUI_SendCrypto:SetTextColor( Color( 0, 0, 0, 255 ) )
				GUI_SendCrypto:SetText( "" )
				GUI_SendCrypto.Paint = function( self, w, h )
					if self:IsHovered() then
						draw.RoundedBox( 8, 0, 0, w, h, CH_CryptoCurrencies.Colors.WhiteAlpha )
					else
						draw.RoundedBox( 8, 0, 0, w, h, CH_CryptoCurrencies.Colors.GMSBlue )
					end
					
						draw.SimpleText( CH_CryptoCurrencies.LangString( "Send" ), "CH_CryptoCurrency_Font_Size8", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					end
				GUI_SendCrypto.DoClick = function()
					CH_CryptoCurrencies.SendCryptoMenu( index )
					
					GUI_PortfolioFrame:Remove()
				end
			
				GUI_CryptoList:AddItem( GUI_CryptoPortfolioPanel )
			end
		end
	end
end