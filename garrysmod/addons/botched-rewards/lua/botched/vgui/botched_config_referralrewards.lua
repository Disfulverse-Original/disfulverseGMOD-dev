local PANEL = {}

function PANEL:Init()

end

function PANEL:Refresh()
    self:Clear()

    local gridWide = self:GetWide()
    local slotsWide = math.floor( gridWide/BOTCHED.FUNC.ScreenScale( 150 ) )
    local spacing = BOTCHED.FUNC.ScreenScale( 10 )
    local slotSize = (gridWide-((slotsWide-1)*spacing))/slotsWide

    self.grid = vgui.Create( "DIconLayout", self )
    self.grid:Dock( TOP )
    self.grid:SetSpaceY( spacing )
    self.grid:SetSpaceX( spacing )

    local rewards = BOTCHED.FUNC.GetChangedVariable( "REWARDS", "ReferralRewards" ) or BOTCHED.CONFIGMETA.REWARDS:GetConfigValue( "ReferralRewards" )

    local sortedRewards = {}
    for k, v in pairs( rewards ) do
        table.insert( sortedRewards, { k, v } )
    end

    table.SortByMember( sortedRewards, 1, true )

    for k, v in pairs( sortedRewards ) do
        local referralRewardKey, referralRewardCfg = v[1], v[2]

        self:CreateReferralRewardSlot( self.grid, referralRewardCfg, referralRewardKey, slotSize, slotSize*1.2, function()
            self:CreateRewardPopup( referralRewardKey, rewards )
        end )
    end

    local iconSize = BOTCHED.FUNC.ScreenScale( 64 )
    surface.SetFont( "MontserratBold30" )
    local contentH = iconSize+select( 2, surface.GetTextSize( "ADD NEW" ) )-BOTCHED.FUNC.ScreenScale( 5 )

    local addNewButton = vgui.Create( "DButton", self.grid )
    addNewButton:SetSize( slotSize, slotSize*1.2 )
    addNewButton:SetText( "" )
    local addMat = Material( "botched/icons/add_64.png" )
    addNewButton.Paint = function( self2, w, h )
        self2:CreateFadeAlpha( 0.2, 50 )

        local startY, endY = self.GetYShadowScissor()

        local uniqueID = "botched_config_item_add"
        BOTCHED.FUNC.BeginShadow( uniqueID, 0, startY, ScrW(), endY )
        local x, y = self2:LocalToScreen( 0, 0 )
        draw.RoundedBox( 8, x, y, w, h, BOTCHED.FUNC.GetTheme( 2 ) )		
        BOTCHED.FUNC.EndShadow( uniqueID, x, y, 1, 1, 2, 255, 0, 0, false )

        draw.RoundedBox( 8, 3, 3, w-6, h-6, BOTCHED.FUNC.GetTheme( 1 ) )
        draw.RoundedBox( 8, 3, 3, w-6, h-6, BOTCHED.FUNC.GetTheme( 2, self2.alpha ) )

        BOTCHED.FUNC.DrawClickCircle( self2, w, h, BOTCHED.FUNC.GetTheme( 2 ), 8 )

        local textColor = BOTCHED.FUNC.GetTheme( 4, 100+((self2.alpha/50)*155) )
        surface.SetDrawColor( textColor )
        surface.SetMaterial( addMat )
        surface.DrawTexturedRect( (w/2)-(iconSize/2), (h/2)-(contentH/2), iconSize, iconSize )

        draw.SimpleText( "ADD NEW", "MontserratBold30", w/2, (h/2)+(contentH/2)+BOTCHED.FUNC.ScreenScale( 5 ), textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
    end
    addNewButton.DoClick = function()
        BOTCHED.FUNC.DermaNumberRequest( "How many referrals are required?", "REWARD CREATION", 0, "Create", function( num )
            if( rewards[num] ) then 
                BOTCHED.FUNC.DermaMessage( "A reward already exists with this amount of referrals.", "CREATION ERROR" )
                return
            end

            rewards[num] = {
                Money = 10000
            }
    
            BOTCHED.FUNC.RequestConfigChange( "REWARDS", "ReferralRewards", rewards )
            self:Refresh()
        end )
    end

    self:SetTall( (math.ceil( (#sortedRewards+1)/slotsWide )*((slotSize*1.2)+spacing))-spacing )
end

function PANEL:CreateReferralRewardSlot( parent, rewardsCfg, referralKey, w, h, doClick )
    local rewardPanel = vgui.Create( "botched_item_slot", parent )
    rewardPanel:SetSize( w, h )
    rewardPanel:SetShadowScissor( function() 
        local startY, endY = self.GetYShadowScissor()
        return 0, startY, ScrW(), endY 
    end )
    local remainingRewards = 0
    rewardPanel.UpdateRewardInfo = function( self2, timeRewardCfg )
        local rewardKey, rewardValue
        for k, v in pairs( rewardsCfg ) do
            if( rewardKey ) then
                remainingRewards = remainingRewards+1
                continue
            end

            rewardKey = k

            if( k == "Items" ) then
                for key, val in pairs( v ) do
                    if( rewardValue ) then
                        remainingRewards = remainingRewards+1
                        continue
                    end

                    rewardValue = { key, val }
                end
                continue
            end

            rewardValue = v
        end

        local itemInfo
        if( not BOTCHED.DEVCONFIG.RewardTypes[rewardKey] ) then 
            itemInfo = {
                Name = "Error", 
                Model = "botched/icons/error.png"
            }
        elseif( rewardKey == "Items" ) then
            itemInfo = BOTCHED.CONFIG.LOCKER.Items[rewardValue[1]]
        else
            local rewardCfg = BOTCHED.DEVCONFIG.RewardTypes[rewardKey]
            itemInfo = {
                Name = rewardCfg.Name, 
                Model = rewardCfg.Material, 
                Border = rewardCfg.Border, 
                Stars = rewardCfg.Stars
            }
        end

        rewardPanel:SetItemInfo( itemInfo, false, doClick )
    end

    rewardPanel:UpdateRewardInfo( timeRewardCfg )

    local rewardCover = vgui.Create( "DPanel", rewardPanel.hoverDraw or rewardPanel )
    rewardCover:Dock( FILL )
    rewardCover:SetZPos( -100 )
    rewardCover.Paint = function( self2, w, h ) 
        draw.SimpleText( referralKey .. " Referrals", "MontserratBold17", w/2, BOTCHED.FUNC.ScreenScale( 25 ), BOTCHED.FUNC.GetTheme( 4, 75 ), TEXT_ALIGN_CENTER, 0 )

        if( remainingRewards <= 0 ) then return end
        draw.SimpleText( "+" .. remainingRewards .. " More", "MontserratMedium20", w-BOTCHED.FUNC.ScreenScale( 10 ), h-BOTCHED.FUNC.ScreenScale( 10 ), BOTCHED.FUNC.GetTheme( 4, 75 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )
    end

    return rewardPanel
end

function PANEL:CreateRewardPopup( rewardKey, rewards )
    if( IsValid( popup ) ) then return end

    local configItem = rewards[rewardKey]
    local itemPanel

    local valueChanged = false
    local function ChangeItemVariable( field, value )
        valueChanged = true
        configItem[field] = value
        itemPanel:UpdateRewardInfo( configItem )
    end

    local popup = vgui.Create( "botched_popup_config" )
    popup:SetHeader( "REFERRAL REWARD CONFIG" )
    popup.OnClose = function()
        if( not valueChanged ) then return end
        BOTCHED.FUNC.RequestConfigChange( "REWARDS", "ReferralRewards", rewards )
        self:Refresh()
    end
    popup:FinishSetup()

    self.popup = popup

    popup:SetInfo( "Reward Info", "Basic information and actions.", Material( "botched/icons/data.png" ) )

    popup:AddActionButton( "Delete", Material( "botched/icons/delete_24.png" ), function()
        BOTCHED.FUNC.DermaQuery( "Are you sure you want to delete this reward?", "REWARD DELETION", "Confirm", function()
            rewards[rewardKey] = nil
            valueChanged = true
            popup:Close()
        end, "Cancel" )
    end )

    -- VARIABLES --
    local margin10 = BOTCHED.FUNC.ScreenScale( 10 )

    -- ITEM ID --
    local itemIDLeftPadding = BOTCHED.FUNC.ScreenScale( 40 )

    local itemIDBack = vgui.Create( "DPanel", popup.infoBottom )
    itemIDBack:Dock( LEFT )
    itemIDBack:DockMargin( margin10, margin10, 0, margin10 )
    itemIDBack:DockPadding( itemIDLeftPadding, 0, 0, 0 )
    itemIDBack:SetWide( BOTCHED.FUNC.ScreenScale( 200 ) )
    itemIDBack.Paint = function( self2, w, h ) 
        draw.RoundedBox( 8, 0, 0, w, h, BOTCHED.FUNC.GetTheme( 1, 175 ) )

        draw.SimpleText( "ID:", "MontserratBold20", itemIDLeftPadding/2, h/2-1, BOTCHED.FUNC.GetTheme( 3 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end

    local itemIDEntry = vgui.Create( "botched_textentry", itemIDBack )
    itemIDEntry:Dock( FILL )
    itemIDEntry:SetBackColor( BOTCHED.FUNC.GetTheme( 1 ) )
    itemIDEntry:SetHighlightColor( BOTCHED.FUNC.GetTheme( 1 ) )
    itemIDEntry:SetRoundedCorners( false, true, false, true )
    itemIDEntry:SetValue( rewardKey )
    itemIDEntry:SetEnabled( false )

    -- ITEM SLOT --
    local itemPanelWide = BOTCHED.FUNC.ScreenScale( 200 )
    itemPanel = self:CreateReferralRewardSlot( popup, configItem, rewardKey, itemPanelWide, itemPanelWide*1.2 )
    itemPanel:SetPos( popup.sectionMargin+(popup.sectionWide/2)-(itemPanelWide/2), popup.header:GetTall()+(popup.mainPanel.targetH-popup.header:GetTall()-popup.infoBack:GetTall())/2-itemPanel:GetTall()/2 )

    -- REWARD INFO --
    local rewardField = popup:AddField( "Reward Info", "The rewards and their values.", Material( "botched/icons/reward.png" ) )

    local rewardExtraH = margin10
    for k, v in pairs( BOTCHED.DEVCONFIG.RewardTypes ) do
        if( k == "Items" ) then continue end

        local headerH = BOTCHED.FUNC.ScreenScale( 50 )
        local entryH = BOTCHED.FUNC.ScreenScale( 40 )
        local slotH = headerH+entryH+margin10

        local slot = vgui.Create( "DPanel", rewardField )
        slot:Dock( TOP )
        slot:DockMargin( margin10, margin10, margin10, 0 )
        slot:DockPadding( margin10, headerH, margin10, margin10 )
        slot:SetTall( slotH )
        slot.Paint = function( self2, w, h )
            draw.RoundedBox( 8, 0, 0, w, h, BOTCHED.FUNC.GetTheme( 2, 100 ) )

            draw.SimpleText( v.Name, "MontserratBold20", margin10, headerH/2+1, BOTCHED.FUNC.GetTheme( 3 ), 0, TEXT_ALIGN_BOTTOM )
            draw.SimpleText( v.Description, "MontserratMedium17", margin10, headerH/2-1, BOTCHED.FUNC.GetTheme( 4, 100 ) )
        end

        slot.entry = vgui.Create( "botched_numberwang", slot )
        slot.entry:SetValue( configItem[k] or 0 )
        slot.entry.OnChange = function( self2 )
            if( self2:GetValue() > 0 ) then
                ChangeItemVariable( k, self2:GetValue() )
            else
                ChangeItemVariable( k, nil )
            end
        end
        slot.entry:Dock( BOTTOM )
        slot.entry:SetTall( entryH )
        slot.entry:SetBackColor( BOTCHED.FUNC.GetTheme( 1 ) )
        slot.entry:SetHighlightColor( BOTCHED.FUNC.GetTheme( 2, 25 ) )

        rewardExtraH = rewardExtraH+slotH+margin10
    end

    rewardField:SetExtraHeight( rewardExtraH )

    -- ITEMS --
    local itemsField = popup:AddField( "Items", "Items to be given as a reward and amounts.", Material( "botched/icons/item.png" ) )

    itemsField.grid = vgui.Create( "DIconLayout", itemsField )
    itemsField.grid:Dock( TOP )
    itemsField.grid:DockMargin( margin10, margin10, 0, 0 )
    itemsField.grid:SetSpaceY( margin10 )
    itemsField.grid:SetSpaceX( margin10 )

    itemsField.Refresh = function( self2 )
        self2.grid:Clear()

        local gridWide = self2:GetWide()-(2*margin10)
        local slotsWide = math.floor( gridWide/BOTCHED.FUNC.ScreenScale( 125 ) )
        local spacing = margin10
        local slotSize = (gridWide-((slotsWide-1)*spacing))/slotsWide

        for key, val in pairs( configItem.Items or {} ) do
            local itemPanel = self2.grid:Add( "botched_item_slot" )
            itemPanel:SetSize( slotSize, slotSize*1.2 )
            itemPanel:SetItemInfo( key, val, function()
                BOTCHED.FUNC.DermaNumberRequest( "What amount should be given?", "ITEM EDITOR", val, "Confirm", function( value ) 
                    if( value <= 0 ) then
                        if( table.Count( configItem.Items )-1 <= 0 ) then
                            configItem.Items = nil
                        else
                            configItem.Items[key] = nil
                        end
                    else
                        configItem.Items[key] = value
                    end
    
                    ChangeItemVariable( "Items", configItem.Items )
                    self2:Refresh()
                end )
            end )
            itemPanel:DisableShadows( true )
            itemPanel:DisableStars( true )
        end

        local iconSize = BOTCHED.FUNC.ScreenScale( 32 )
        surface.SetFont( "MontserratBold25" )
        local contentH = iconSize+select( 2, surface.GetTextSize( "ADD NEW" ) )-BOTCHED.FUNC.ScreenScale( 5 )

        local addButton = vgui.Create( "DButton", self2.grid )
        addButton:SetSize( slotSize, slotSize*1.2 )
        addButton:SetText( "" )
        local addMat = Material( "botched/icons/add_32_cross.png" )
        addButton.Paint = function( self2, w, h )
            self2:CreateFadeAlpha( 0.2, 50 )
    
            draw.RoundedBox( 8, 0, 0, w, h, BOTCHED.FUNC.GetTheme( 2 ) )		
    
            draw.RoundedBox( 8, 3, 3, w-6, h-6, BOTCHED.FUNC.GetTheme( 1 ) )
            draw.RoundedBox( 8, 3, 3, w-6, h-6, BOTCHED.FUNC.GetTheme( 2, self2.alpha ) )
    
            BOTCHED.FUNC.DrawClickCircle( self2, w, h, BOTCHED.FUNC.GetTheme( 2 ), 8 )
    
            local textColor = BOTCHED.FUNC.GetTheme( 4, 100+((self2.alpha/50)*155) )
            surface.SetDrawColor( textColor )
            surface.SetMaterial( addMat )
            surface.DrawTexturedRect( (w/2)-(iconSize/2), (h/2)-(contentH/2), iconSize, iconSize )
    
            draw.SimpleText( "ADD NEW", "MontserratBold25", w/2, (h/2)+(contentH/2)+BOTCHED.FUNC.ScreenScale( 5 ), textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
        end
        addButton.DoClick = function()
            local options = {}
            for k, v in pairs( BOTCHED.FUNC.GetChangedVariable( "LOCKER", "Items" ) or BOTCHED.CONFIGMETA.LOCKER:GetConfigValue( "Items" ) ) do
                if( (configItem.Items or {})[k] ) then continue end
                options[k] = v.Name
            end

            BOTCHED.FUNC.DermaComboRequest( "What item would you like to add?", "ITEM EDITOR", options, false, true, false, function( value, data )
                configItem.Items = configItem.Items or {}
                configItem.Items[data] = 1
                ChangeItemVariable( "Items", configItem.Items )
                self2:Refresh()
            end )
        end

        self2:SetExtraHeight( (math.ceil( (table.Count( configItem.Items or {} )+1)/slotsWide )*((slotSize*1.2)+margin10))+margin10 )
    end

    itemsField:Refresh()
end

function PANEL:Paint( w, h )

end

vgui.Register( "botched_config_referralrewards", PANEL, "DPanel" )