

hook.Add("InitPostEntity", "FixBlurNotLoading", function()

	local SKIN = {}
	SKIN.BGColor = Color(0,0,0,200)
	SKIN.ThemeColor = Color(31, 133, 221,200) 
	SKIN.Colours = SKIN.Colours or table.Copy(derma.GetDefaultSkin().Colours)
	SKIN.Colours.Label.Default = color_white
	SKIN.Colours.Label.Dark = color_white
	SKIN.Colours.Tree.Normal = color_white
	SKIN.Colours.TooltipText = color_white
	SKIN.Colours.Category.Line.Text = color_white
	SKIN.Colours.Category.LineAlt.Text = color_white
	local blur = Material( "pp/blurscreen" )
	local function BlurMenu( panel, layers, density, alpha )
	    -- Its a scientifically proven fact that blur improves a script
	    local x, y = panel:LocalToScreen( 0, 0 )

	    surface.SetDrawColor( 255, 255, 255, alpha )
	    surface.SetMaterial( blur )

	    for i = 1, 5 do
	        blur:SetFloat( "$blur", ( i / 4 ) * 4 )
	        blur:Recompute()

	        render.UpdateScreenEffectTexture()
	        surface.DrawTexturedRect( -x, -y, ScrW(), ScrH() )
	    end
	end 

	--[[---------------------------------------------------------
		Panel
	-----------------------------------------------------------]]
	function SKIN:PaintPanel( panel, w, h )

		if ( !panel.m_bBackground ) then return end	
		surface.SetDrawColor(self.BGColor)
		surface.DrawRect(0,0,w,h)

	end

	--[[---------------------------------------------------------
		Panel
	-----------------------------------------------------------]]
	function SKIN:PaintShadow( panel, w, h )
		SKIN.tex.Shadow( 0, 0, w, h );
		surface.SetDrawColor(0,0,0,200)
		surface.DrawRect(0,0,w,h)

	end

	--[[---------------------------------------------------------
		Frame
	-----------------------------------------------------------]]
	function SKIN:PaintFrame( panel, w, h )

		if ( panel.m_bPaintShadow ) then
		
			DisableClipping( true )
			SKIN.tex.Shadow( -4, -4, w+10, h+10 );
			DisableClipping( false )
		
		end
		
		if ( panel:HasHierarchicalFocus() ) then
		
			surface.SetDrawColor(self.BGColor)
			surface.DrawRect(0,0,w,h)
			
		else
		
			surface.SetDrawColor(self.BGColor)
			surface.DrawRect(0,0,w,h)
			
		end


	end

	--[[---------------------------------------------------------
		Button
	-----------------------------------------------------------]]
	function SKIN:PaintButton( panel, w, h )
			
		if panel:GetName() != "DImageButton" then
			surface.SetDrawColor(0,0,0,200)
			surface.DrawRect(0,0,w,h)

			if panel:IsHovered() then
				surface.SetDrawColor(255,255,255,5)
				surface.DrawRect(0,0,w,h)
			end 
		end 
		panel:SetTextColor(color_white)

	end


	--[[---------------------------------------------------------
		Tree
	-----------------------------------------------------------]]
	function SKIN:PaintTree( panel, w, h )

		if ( !panel.m_bBackground ) then return end
		
		surface.SetDrawColor(0,0,0,200)
		surface.DrawRect(0,0,w,h)

	end

	local fillColor = Color(31,133,222)
	--[[---------------------------------------------------------
		CheckBox
	-----------------------------------------------------------]]
	function SKIN:PaintCheckBox( panel, w, h )
		surface.SetDrawColor(0,0,0,200)
		surface.DrawRect(0,0,w,h)

		if ( panel:GetChecked() ) then
		
			if ( not panel:GetDisabled() ) then
				surface.SetDrawColor(fillColor)
				surface.DrawRect(0,0,w,h)
			end
			

		end	

		if panel:IsHovered() then
			surface.SetDrawColor(255,255,255,5)
			surface.DrawRect(0,0,w,h)
		end 
		surface.SetDrawColor(color_white)
		surface.DrawOutlinedRect(0,0,w,h)
	end

	--[[---------------------------------------------------------
		ExpandButton IGNORE
	-----------------------------------------------------------]]

	function SKIN:PaintExpandButton( panel, w, h )

		if ( !panel:GetExpanded() ) then 
			self.tex.TreePlus( 0, 0, w, h )
		else 
			self.tex.TreeMinus( 0, 0, w, h )	
		end	

	end
	 
	--[[---------------------------------------------------------
		TextEntry
	-----------------------------------------------------------]]
	function SKIN:PaintTextEntry( panel, w, h )

		if ( panel.m_bBackground ) then

			if ( panel:GetDisabled() ) then
				self.tex.TextBox_Disabled( 0, 0, w, h )
			elseif ( panel:HasFocus() ) then
				self.tex.TextBox_Focus( 0, 0, w, h )
			else
				surface.SetDrawColor(0,0,0,200)
				surface.DrawRect(0,0,w,h)
			end

		end

		panel:DrawTextEntryText( panel.m_colText, panel.m_colHighlight, panel.m_colCursor )

	end

	function SKIN:SchemeTextEntry( panel ) ---------------------- TODO
		
		panel:SetTextColor( self.colTextEntryText )
		panel:SetHighlightColor( self.colTextEntryTextHighlight )
		panel:SetCursorColor( self.colTextEntryTextCursor )

	end

	--[[---------------------------------------------------------
		Menu
	-----------------------------------------------------------]]
	function SKIN:PaintMenu( panel, w, h )

		if ( panel:GetDrawColumn() ) then
			self.tex.MenuBG_Column( 0, 0, w, h )
		else
			self.tex.MenuBG( 0, 0, w, h )
		end
		--surface.SetDrawColor(0,0,0,200)
		--surface.DrawRect(0,0,w,h)



	end

	--[[---------------------------------------------------------
		Menu
	-----------------------------------------------------------]]
	function SKIN:PaintMenuSpacer( panel, w, h )

		--surface.SetDrawColor(SKIN.BGColor)
		--surface.DrawRect(0,0,w,h)
		
	end

	--[[---------------------------------------------------------
		MenuOption
	-----------------------------------------------------------]]
	function SKIN:PaintMenuOption( panel, w, h )

		if ( panel.m_bBackground && (panel.Hovered || panel.Highlight) ) then
			self.tex.MenuBG_Hover( 0, 0, w, h )
		end
		
		if ( panel:GetChecked() ) then
			self.tex.Menu_Check( 5, h/2-7, 15, 15 )
		end
		surface.SetDrawColor(0,0,0,200)
		surface.DrawRect(0,0,w,h)

		panel:SetTextColor(color_white)

	end

	--[[---------------------------------------------------------
		MenuRightArrow
	-----------------------------------------------------------]]
	function SKIN:PaintMenuRightArrow( panel, w, h )
		
		self.tex.Menu.RightArrow( 0, 0, w, h );

	end

	--[[---------------------------------------------------------
		PropertySheet
	-----------------------------------------------------------]]
	function SKIN:PaintPropertySheet( panel, w, h )

		surface.SetDrawColor(0,0,0,200)
		surface.DrawRect(0,0,w,h)
		BlurMenu(panel, 16, 16, 255)
	end

	--[[---------------------------------------------------------
		Tab -- SpawnList, Weapons, Entities 
	-----------------------------------------------------------]]
	function SKIN:PaintTab( panel, w, h )

		
		if ( panel:GetPropertySheet():GetActiveTab() == panel ) then
			return self:PaintActiveTab( panel, w, h )
		end
		
		surface.SetDrawColor(SKIN.BGColor)
		surface.DrawRect(0,0,w,h)
		
	end

	function SKIN:PaintActiveTab( panel, w, h )

		surface.SetDrawColor(SKIN.BGColor)
		surface.DrawRect(0,0,w,h * .78)
		surface.DrawRect(0,0,w,h * .78)
		
	end

	--[[---------------------------------------------------------
		Button
	-----------------------------------------------------------]]
	function SKIN:PaintWindowCloseButton( panel, w, h )

		if ( !panel.m_bBackground ) then return end
		
		if ( panel:GetDisabled() ) then
			return self.tex.Window.Close( 0, 0, w, h, Color( 255, 255, 255, 50 ) );	
		end	
		
		if ( panel.Depressed || panel:IsSelected() ) then
			return self.tex.Window.Close_Down( 0, 0, w, h );	
		end	
		
		if ( panel.Hovered ) then
			return self.tex.Window.Close_Hover( 0, 0, w, h );	
		end

		self.tex.Window.Close( 0, 0, w, h );

	end

	function SKIN:PaintWindowMinimizeButton( panel, w, h )

		if ( !panel.m_bBackground ) then return end
		
		if ( panel:GetDisabled() ) then
			return self.tex.Window.Mini( 0, 0, w, h, Color( 255, 255, 255, 50 ) );	
		end	
		
		if ( panel.Depressed || panel:IsSelected() ) then
			return self.tex.Window.Mini_Down( 0, 0, w, h );	
		end	
		
		if ( panel.Hovered ) then
			return self.tex.Window.Mini_Hover( 0, 0, w, h );	
		end
				
		self.tex.Window.Mini( 0, 0, w, h );

	end

	function SKIN:PaintWindowMaximizeButton( panel, w, h )

		if ( !panel.m_bBackground ) then return end
		
		if ( panel:GetDisabled() ) then
			return self.tex.Window.Maxi( 0, 0, w, h, Color( 255, 255, 255, 50 ) );	
		end	
		
		if ( panel.Depressed || panel:IsSelected() ) then
			return self.tex.Window.Maxi_Down( 0, 0, w, h );	
		end	
		
		if ( panel.Hovered ) then
			return self.tex.Window.Maxi_Hover( 0, 0, w, h );	
		end
				
		self.tex.Window.Maxi( 0, 0, w, h );

	end

	--[[---------------------------------------------------------
		VScrollBar
	-----------------------------------------------------------]]
	function SKIN:PaintVScrollBar( panel, w, h )
		w = w * .5
		surface.SetDrawColor(0,0,0,200)
		surface.DrawRect(w - w / 2,0,w,h)

	end

	--[[---------------------------------------------------------
		ScrollBarGrip
	-----------------------------------------------------------]]
	function SKIN:PaintScrollBarGrip( panel, w, h )
		w = w * .5
		surface.SetDrawColor(255,255,255,200)
		surface.DrawRect(w - w / 2,0,w,h)

	end

	--[[---------------------------------------------------------
		ButtonDown
	-----------------------------------------------------------]]
	function SKIN:PaintButtonDown( panel, w, h )
		w = w * .5
		surface.SetDrawColor(0,0,0,200)
		surface.DrawRect(w - w / 2,0,w,h)
	end

	--[[---------------------------------------------------------
		ButtonUp
	-----------------------------------------------------------]]
	function SKIN:PaintButtonUp( panel, w, h )
		w = w * .5
		surface.SetDrawColor(0,0,0,200)
		surface.DrawRect(w - w / 2,0,w,h)
	end

	--[[---------------------------------------------------------
		ButtonLeft
	-----------------------------------------------------------]]
	function SKIN:PaintButtonLeft( panel, w, h )

		if ( !panel.m_bBackground ) then return end
		
		if ( panel.Depressed || panel:IsSelected() ) then
			return self.tex.Scroller.LeftButton_Down( 0, 0, w, h );	
		end	
		
		if ( panel:GetDisabled() ) then
			return self.tex.Scroller.LeftButton_Dead( 0, 0, w, h );	
		end	
		
		if ( panel.Hovered ) then
			return self.tex.Scroller.LeftButton_Hover( 0, 0, w, h );	
		end
				
		self.tex.Scroller.LeftButton_Normal( 0, 0, w, h );

	end

	--[[---------------------------------------------------------
		ButtonRight
	-----------------------------------------------------------]]
	function SKIN:PaintButtonRight( panel, w, h )

		if ( !panel.m_bBackground ) then return end
		
		if ( panel.Depressed || panel:IsSelected() ) then
			return self.tex.Scroller.RightButton_Down( 0, 0, w, h );	
		end	
		
		if ( panel:GetDisabled() ) then
			return self.tex.Scroller.RightButton_Dead( 0, 0, w, h );	
		end	
		
		if ( panel.Hovered ) then
			return self.tex.Scroller.RightButton_Hover( 0, 0, w, h );	
		end
				
		self.tex.Scroller.RightButton_Normal( 0, 0, w, h );

	end


	--[[---------------------------------------------------------
		ComboDownArrow
	-----------------------------------------------------------]]
	function SKIN:PaintComboDownArrow( panel, w, h )

		if ( panel.ComboBox:GetDisabled() ) then
			return self.tex.Input.ComboBox.Button.Disabled( 0, 0, w, h );	
		end	
		
		if ( panel.ComboBox.Depressed || panel.ComboBox:IsMenuOpen() ) then
			return self.tex.Input.ComboBox.Button.Down( 0, 0, w, h );	
		end	
		
		if ( panel.ComboBox.Hovered ) then
			return self.tex.Input.ComboBox.Button.Hover( 0, 0, w, h );	
		end
				
		self.tex.Input.ComboBox.Button.Normal( 0, 0, w, h );

	end

	--[[---------------------------------------------------------
		ComboBox
	-----------------------------------------------------------]]
	function SKIN:PaintComboBox( panel, w, h )
		
		if ( panel:GetDisabled() ) then
			return self.tex.Input.ComboBox.Disabled( 0, 0, w, h );	
		end	
		
		if ( panel.Depressed || panel:IsMenuOpen() ) then
			return self.tex.Input.ComboBox.Down( 0, 0, w, h );	
		end	
		
		if ( panel.Hovered ) then
			return self.tex.Input.ComboBox.Hover( 0, 0, w, h );	
		end
				
		self.tex.Input.ComboBox.Normal( 0, 0, w, h );
		
	end

	--[[---------------------------------------------------------
		ComboBox
	-----------------------------------------------------------]]
	function SKIN:PaintListBox( panel, w, h )
		
		self.tex.Input.ListBox.Background( 0, 0, w, h );
		surface.SetDrawColor(0,0,0,200)
		surface.DrawRect(0,0,w,h)
	end

	--[[---------------------------------------------------------
		NumberUp
	-----------------------------------------------------------]]
	function SKIN:PaintNumberUp( panel, w, h )

		if ( panel:GetDisabled() ) then
			return self.Input.UpDown.Up.Disabled( 0, 0, w, h );	
		end	
		
		if ( panel.Depressed ) then
			return self.tex.Input.UpDown.Up.Down( 0, 0, w, h );	
		end	
		
		if ( panel.Hovered ) then
			return self.tex.Input.UpDown.Up.Hover( 0, 0, w, h );	
		end
				
		self.tex.Input.UpDown.Up.Normal( 0, 0, w, h );
		
	end
			
	--[[---------------------------------------------------------
		NumberDown
	-----------------------------------------------------------]]
	function SKIN:PaintNumberDown( panel, w, h )

		if ( panel:GetDisabled() ) then
			return self.tex.Input.UpDown.Down.Disabled( 0, 0, w, h );	
		end	
		
		if ( panel.Depressed ) then
			return self.tex.Input.UpDown.Down.Down( 0, 0, w, h );	
		end	
		
		if ( panel.Hovered ) then
			return self.tex.Input.UpDown.Down.Hover( 0, 0, w, h );	
		end
				
		self.tex.Input.UpDown.Down.Normal( 0, 0, w, h );
		
	end

	function SKIN:PaintTreeNode( panel, w, h )

		if ( !panel.m_bDrawLines ) then return end
		
		surface.SetDrawColor( self.Colours.Tree.Lines )
		
		if ( panel.m_bLastChild ) then
		
				surface.DrawRect( 9, 					0,		1, 	7 )
				surface.DrawRect( 9, 					7,		9, 	1 )
		
		else
				surface.DrawRect( 9, 					0,		1, 	h )
				surface.DrawRect( 9, 					7,		9, 	1 )
		end

	end


	function SKIN:PaintTreeNodeButton( panel, w, h )

		if ( !panel.m_bSelected ) then return end
		
		-- Don't worry this isn't working out the size every render
		-- it just gets the cached value from inside the Label
		local w, _ = panel:GetTextSize() 
		surface.SetDrawColor(SKIN.ThemeColor)
		surface.DrawRect(38,0,w + 6,h)
		panel:SetTextColor(color_white)
	end

	function SKIN:PaintSelection( panel, w, h )

		self.tex.Selection( 0, 0, w, h );

	end

	function SKIN:PaintSliderKnob( panel, w, h )

		if ( panel:GetDisabled() ) then	return self.tex.Input.Slider.H.Disabled( 0, 0, w, h ); end	
		
		if ( panel.Depressed ) then
			return self.tex.Input.Slider.H.Down( 0, 0, w, h );	
		end	
		
		if ( panel.Hovered ) then
			return self.tex.Input.Slider.H.Hover( 0, 0, w, h );	
		end
				
		self.tex.Input.Slider.H.Normal( 0, 0, w, h );

	end

	local function PaintNotches( x, y, w, h, num )

		if ( !num ) then return end

		local space = w / num
		
		for i=0, num do
		
			surface.DrawRect( x + i * space, y+4,	1,  5 )
		
		end

	end

	function SKIN:PaintNumSlider( panel, w, h )


		surface.SetDrawColor( Color( 0, 0, 0, 200 ) )
		surface.DrawRect( 8, h/2-1,		w-15,  1 )
		
		surface.SetDrawColor(SKIN.ThemeColor)
		PaintNotches( 8, h/2-1,		w-16,  1, panel.m_iNotches )

	end

	function SKIN:PaintProgress( panel, w, h )

		surface.SetDrawColor(0,0,0,200)
		surface.DrawRect(0,0,w,h)
		surface.SetDrawColor(SKIN.ThemeColor)
		surface.DrawRect(0, 0, w * panel:GetFraction(), h )

	end

	function SKIN:PaintCollapsibleCategory( panel, w, h )

		if ( !panel:GetExpanded() && h < 40 ) then
			surface.SetDrawColor(SKIN.ThemeColor)
			surface.DrawRect(0,0,w,h)
		else
			surface.SetDrawColor(40,40,40,200)
			surface.DrawRect(0,0,w,h)	
		end

	end 

	function SKIN:PaintCategoryList( panel, w, h )

		surface.SetDrawColor(0,0,0,200)
		surface.DrawRect(0,0,w,h)
	end

	function SKIN:PaintCategoryButton( panel, w, h )

		if ( panel.AltLine ) then

			if ( panel.Depressed || panel.m_bSelected ) then surface.SetDrawColor( self.Colours.Category.LineAlt.Button_Selected );
			elseif ( panel.Hovered ) then surface.SetDrawColor( self.Colours.Category.LineAlt.Button_Hover );
			else surface.SetDrawColor( self.Colours.Category.LineAlt.Button ); end
		
		else
		
			if ( panel.Depressed || panel.m_bSelected ) then surface.SetDrawColor( self.Colours.Category.Line.Button_Selected );
			elseif ( panel.Hovered ) then surface.SetDrawColor( self.Colours.Category.Line.Button_Hover );
			else surface.SetDrawColor( self.Colours.Category.Line.Button ); end
			
		end

		--surface.DrawRect( 0, 0, w, h );
		if panel.SetTextColor then 
			panel:SetTextColor(color_white)
		end
		surface.SetDrawColor(0,0,0,200)
		surface.DrawRect(0,0,w,h)
	end

	function SKIN:PaintListViewLine( panel, w, h )

		if ( panel:IsSelected() ) then

			self.tex.Input.ListBox.EvenLineSelected( 0, 0, w, h );
		 
		elseif ( panel.Hovered ) then

			self.tex.Input.ListBox.Hovered( 0, 0, w, h );
		 
		elseif ( panel.m_bAlt ) then

			self.tex.Input.ListBox.EvenLine( 0, 0, w, h );
		         
		end

	end

	function SKIN:PaintListView( panel, w, h )

		self.tex.Input.ListBox.Background( 0, 0, w, h )

	end

	function SKIN:PaintTooltip( panel, w, h )

		surface.SetDrawColor(0,0,0,200)
		surface.DrawRect(0,0,w,h)
		panel:SetTextColor(color_white)
	end

	function SKIN:PaintMenuBar( panel, w, h )

		surface.SetDrawColor(0,0,0, 200)
		surface.DrawRect(0,0,w,h)
	end
	derma.DefineSkin( "BLURSKIN", "Blur Spawnmenu", SKIN )
	hook.Add( "ForceDermaSkin", "BLURSKIN.Force", function()

    	return "BLURSKIN"

	end )
	derma.RefreshSkins()
end)
