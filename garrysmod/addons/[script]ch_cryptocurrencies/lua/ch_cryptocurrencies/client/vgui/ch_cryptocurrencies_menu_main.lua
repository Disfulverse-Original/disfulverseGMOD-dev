--[[
	CRYPTO MENU
--]]
function CH_CryptoCurrencies.CryptoMenu()
	local ply = LocalPlayer()
	
	local scr_w = ScrW()
	local scr_h = ScrH()
	
	local GUI_CryptoFrame = vgui.Create( "DFrame" )
	GUI_CryptoFrame:SetTitle( "" )
	GUI_CryptoFrame:SetSize( scr_w * 0.37, scr_h * 0.485 )
	GUI_CryptoFrame:Center()
	GUI_CryptoFrame.Paint = function( self, w, h )
		-- Draw frame
		draw.RoundedBox( 8, 0, 0, w, h, CH_CryptoCurrencies.Colors.LightGray )
		
		-- Draw top
		draw.RoundedBoxEx( 8, 0, 0, w, scr_h * 0.03, CH_CryptoCurrencies.Colors.DarkGray, true, true, false, false )

		-- Draw the top title.
		draw.SimpleText( CH_CryptoCurrencies.LangString( "Browse Cryptocurrencies" ), "CH_CryptoCurrency_Font_Size8", w / 2, scr_h * 0.015, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_CryptoFrame:MakePopup()
	GUI_CryptoFrame:SetDraggable( false )
	GUI_CryptoFrame:ShowCloseButton( false )
	
	local GUI_CloseMenu = vgui.Create( "DButton", GUI_CryptoFrame )
	GUI_CloseMenu:SetPos( scr_w * 0.355, scr_h * 0.01 )
	GUI_CloseMenu:SetSize( 16, 16 )
	GUI_CloseMenu:SetText( "" )
	GUI_CloseMenu.Paint = function( self, w, h )
		surface.SetDrawColor( color_white )
		surface.SetMaterial( CH_CryptoCurrencies.Materials.CloseIcon )
		surface.DrawTexturedRect( 0, 0, 16, 16 )
	end
	GUI_CloseMenu.DoClick = function()
		GUI_CryptoFrame:Remove()
	end
	
	local GUI_PortfolioFrameBtn = vgui.Create( "DButton", GUI_CryptoFrame )
	GUI_PortfolioFrameBtn:SetSize( scr_w * 0.1, scr_h * 0.03 )
	GUI_PortfolioFrameBtn:SetPos( scr_w * 0.11, scr_h * 0.0375 )
	GUI_PortfolioFrameBtn:SetTextColor( Color( 0, 0, 0, 255 ) )
	GUI_PortfolioFrameBtn:SetText( "" )
	GUI_PortfolioFrameBtn.Paint = function( self, w, h )
		draw.RoundedBox( 8, 0, 0, w, h, CH_CryptoCurrencies.Colors.DarkGray )
		
		if IsValid( GUI_PortfolioFrame ) then
			draw.RoundedBoxEx( 8, 0, h * 0.8, w, h * 0.2, CH_CryptoCurrencies.Colors.GMSBlue, false, false, true, true )
		elseif self:IsHovered() then
			draw.RoundedBoxEx( 8, 0, h * 0.8, w, h * 0.2, CH_CryptoCurrencies.Colors.GMSBlue, false, false, true, true )
		end
		
		draw.SimpleText( CH_CryptoCurrencies.LangString( "Portfolio" ), "CH_CryptoCurrency_Font_Size8", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_PortfolioFrameBtn.DoClick = function()
		GUI_CryptoFrame:Remove()
		
		CH_CryptoCurrencies.PortfolioMenu()
	end
	
	if CH_CryptoCurrencies.Config.EnableSQL then
		GUI_TransactionsFrameBtn = vgui.Create( "DButton", GUI_CryptoFrame )
		GUI_TransactionsFrameBtn:SetSize( scr_w * 0.1, scr_h * 0.03 )
		GUI_TransactionsFrameBtn:SetPos( scr_w * 0.215, scr_h * 0.0375 )
		GUI_TransactionsFrameBtn:SetTextColor( Color( 0, 0, 0, 255 ) )
		GUI_TransactionsFrameBtn:SetText( "" )
		GUI_TransactionsFrameBtn.Paint = function( self, w, h )
			draw.RoundedBox( 8, 0, 0, w, h, CH_CryptoCurrencies.Colors.DarkGray )
			
			if IsValid( GUI_PortfolioFrame ) then
				draw.RoundedBoxEx( 8, 0, h * 0.8, w, h * 0.2, CH_CryptoCurrencies.Colors.GMSBlue, false, false, true, true )
			elseif self:IsHovered() then
				draw.RoundedBoxEx( 8, 0, h * 0.8, w, h * 0.2, CH_CryptoCurrencies.Colors.GMSBlue, false, false, true, true )
			end
			
			draw.SimpleText( CH_CryptoCurrencies.LangString( "Transactions" ), "CH_CryptoCurrency_Font_Size8", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		GUI_TransactionsFrameBtn.DoClick = function()
			GUI_CryptoFrame:Remove()
			
			CH_CryptoCurrencies.TransactionsMenu()
		end
	end
	
	local GUI_BuyCryptoFrameBtn = vgui.Create( "DButton", GUI_CryptoFrame )
	GUI_BuyCryptoFrameBtn:SetSize( scr_w * 0.1, scr_h * 0.03 )
	GUI_BuyCryptoFrameBtn:SetPos( scr_w * 0.005, scr_h * 0.0375 )
	GUI_BuyCryptoFrameBtn:SetTextColor( Color( 0, 0, 0, 255 ) )
	GUI_BuyCryptoFrameBtn:SetText( "" )
	GUI_BuyCryptoFrameBtn.Paint = function( self, w, h )
		draw.RoundedBox( 8, 0, 0, w, h, CH_CryptoCurrencies.Colors.DarkGray )
		
		if CH_CryptoCurrencies.Config.EnableSQL then
			if IsValid( GUI_CryptoFrame ) and not GUI_PortfolioFrameBtn:IsHovered() and not GUI_TransactionsFrameBtn:IsHovered() then
				draw.RoundedBoxEx( 8, 0, h * 0.8, w, h * 0.2, CH_CryptoCurrencies.Colors.GMSBlue, false, false, true, true )
			end
		elseif not CH_CryptoCurrencies.Config.EnableSQL then
			if IsValid( GUI_CryptoFrame ) and not GUI_PortfolioFrameBtn:IsHovered() then
				draw.RoundedBoxEx( 8, 0, h * 0.8, w, h * 0.2, CH_CryptoCurrencies.Colors.GMSBlue, false, false, true, true )
			end
		elseif self:IsHovered() then
			draw.RoundedBoxEx( 8, 0, h * 0.8, w, h * 0.2, CH_CryptoCurrencies.Colors.GMSBlue, false, false, true, true )
		end
		
		draw.SimpleText( CH_CryptoCurrencies.LangString( "Cryptos" ), "CH_CryptoCurrency_Font_Size8", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_BuyCryptoFrameBtn.DoClick = function()
	end
	
	local GUI_CryptoList = vgui.Create( "DPanelList", GUI_CryptoFrame )
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
		if crypto.Name then
			-- Cache some variables that doesn't have to be in the Paint hook
			local player_owns = math.Round( ply.CH_CryptoCurrencies_Wallet[ crypto.Currency ].Amount, 7 )
			
			local price_change = crypto.Change
			local price_change_color = CH_CryptoCurrencies.Colors.Green
			if price_change < 0 then
				price_change_color = CH_CryptoCurrencies.Colors.Red
			end
			local no_change = false
			
			-- Panel per crypto
			local GUI_CryptoPanel = vgui.Create( "DPanelList" )
			GUI_CryptoPanel:SetSize( scr_w * 0.348, scr_h * 0.075 )
			GUI_CryptoPanel.Paint = function( self, w, h )
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
				local x, y = surface.GetTextSize( crypto.Price )
				
				draw.SimpleText( crypto.Price, "CH_CryptoCurrency_Font_Size8", w * 0.135, h * 0.75, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				draw.SimpleText( CH_CryptoCurrencies.CurrencyAbbreviation(), "CH_CryptoCurrency_Font_Size6", w * 0.135 + ( x + scr_w * 0.002 ), h * 0.775, CH_CryptoCurrencies.Colors.WhiteAlpha2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				
				--[[
					Coin Change
				--]]
				surface.SetDrawColor( color_white )
				if price_change == 0 then
					no_change = true
				elseif price_change > 0 then
					surface.SetMaterial( CH_CryptoCurrencies.Materials.ArrowUpIcon )
				else
					surface.SetMaterial( CH_CryptoCurrencies.Materials.ArrowDownIcon )
				end
				if not no_change then
					surface.DrawTexturedRect( w * 0.135 + ( x + scr_w * 0.02 ), h * 0.7, 12, 12 )

					draw.SimpleText( price_change .."%", "CH_CryptoCurrency_Font_Size6", w * 0.135 + ( x + scr_w * 0.0275 ), h * 0.775, price_change_color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				end
				
				--[[
					Owns Amount
				--]]
				draw.SimpleText( CH_CryptoCurrencies.LangString( "Owns" ), "CH_CryptoCurrency_Font_Size10", w * 0.805, h * 0.25, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )

				surface.SetFont( "CH_CryptoCurrency_Font_Size8" )
				local x, y = surface.GetTextSize( crypto.Currency )
				
				draw.SimpleText( string.format( "%f", player_owns ), "CH_CryptoCurrency_Font_Size8", w * 0.81 - x, h * 0.75, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
				draw.SimpleText( crypto.Currency, "CH_CryptoCurrency_Font_Size6", w * 0.805, h * 0.775, CH_CryptoCurrencies.Colors.WhiteAlpha2, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			end
			
			local GUI_BuyCrypto = vgui.Create( "DButton", GUI_CryptoPanel )
			GUI_BuyCrypto:SetSize( scr_w * 0.05, scr_h * 0.0245 )
			GUI_BuyCrypto:SetPos( scr_w * 0.2925, scr_h * 0.01 )
			GUI_BuyCrypto:SetTextColor( Color( 0, 0, 0, 255 ) )
			GUI_BuyCrypto:SetText( "" )
			GUI_BuyCrypto.Paint = function( self, w, h )
				if self:IsHovered() then
					draw.RoundedBox( 8, 0, 0, w, h, CH_CryptoCurrencies.Colors.GreenHovered )
				else
					draw.RoundedBox( 8, 0, 0, w, h, CH_CryptoCurrencies.Colors.Green )
				end
				
					draw.SimpleText( CH_CryptoCurrencies.LangString( "Buy" ), "CH_CryptoCurrency_Font_Size7", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end
			GUI_BuyCrypto.DoClick = function()
				CH_CryptoCurrencies.BuyCryptoMenu( index )
				
				GUI_CryptoFrame:Remove()
			end
			
			local GUI_SellCrypto = vgui.Create( "DButton", GUI_CryptoPanel )
			GUI_SellCrypto:SetSize( scr_w * 0.05, scr_h * 0.0245 )
			GUI_SellCrypto:SetPos( scr_w * 0.2925, scr_h * 0.0425 )
			GUI_SellCrypto:SetTextColor( Color( 0, 0, 0, 255 ) )
			GUI_SellCrypto:SetText( "" )
			GUI_SellCrypto.Paint = function( self, w, h )
				if player_owns > 0 and self:IsHovered() then
					draw.RoundedBox( 8, 0, 0, w, h, CH_CryptoCurrencies.Colors.RedHovered )
				else
					draw.RoundedBox( 8, 0, 0, w, h, CH_CryptoCurrencies.Colors.Red )
				end
				
					draw.SimpleText( CH_CryptoCurrencies.LangString( "Sell" ), "CH_CryptoCurrency_Font_Size7", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end
			GUI_SellCrypto.DoClick = function()
				if player_owns <= 0 then
					surface.PlaySound( "common/wpn_denyselect.wav" )
					return
				end
			
				CH_CryptoCurrencies.SellCryptoMenu( index )
				
				GUI_CryptoFrame:Remove()
			end
			
			GUI_CryptoList:AddItem( GUI_CryptoPanel )
		end
	end
end