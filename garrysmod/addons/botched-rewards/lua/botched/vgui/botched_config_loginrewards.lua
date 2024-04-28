local PANEL = {}

function PANEL:Init()

end

function PANEL:Refresh()
    self:Clear()

    local gridWide = self:GetWide()
    local slotsWide = math.floor( gridWide/BOTCHED.FUNC.ScreenScale( 125 ) )
    local spacing = BOTCHED.FUNC.ScreenScale( 10 )
    local slotSize = (gridWide-((slotsWide-1)*spacing))/slotsWide

    self.grid = vgui.Create( "DIconLayout", self )
    self.grid:Dock( TOP )
    self.grid:SetSpaceY( spacing )
    self.grid:SetSpaceX( spacing )

    local rewards = BOTCHED.FUNC.GetChangedVariable( "REWARDS", "LoginRewards" ) or BOTCHED.CONFIGMETA.REWARDS:GetConfigValue( "LoginRewards" )

    for k, v in pairs( rewards ) do
        self:CreateLoginRewardSlot( self.grid, v, k, slotSize, slotSize, function()
            self:CreateRewardPopup( k, rewards )
        end )
    end

    local iconSize = BOTCHED.FUNC.ScreenScale( 32 )
    surface.SetFont( "MontserratBold20" )
    local contentH = iconSize+select( 2, surface.GetTextSize( "ADD NEW" ) )-BOTCHED.FUNC.ScreenScale( 5 )

    local addNewButton = vgui.Create( "DButton", self.grid )
    addNewButton:SetSize( slotSize, slotSize )
    addNewButton:SetText( "" )
    local addMat = Material( "botched/icons/add_32_cross.png" )
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

        draw.SimpleText( "ADD NEW", "MontserratBold20", w/2, (h/2)+(contentH/2)+BOTCHED.FUNC.ScreenScale( 5 ), textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
    end
    addNewButton.DoClick = function()
        BOTCHED.FUNC.DermaNumberRequest( "What day would to like the reward to be on?", "REWARD CREATION", #rewards+1, "Create", function( num )
            local function CreateFunc()
                table.insert( rewards, num, {
                    RewardType = "Money",
                    RewardValue = 0
                } )
                BOTCHED.FUNC.RequestConfigChange( "REWARDS", "LoginRewards", rewards )
                self:Refresh()
            end

            if( rewards[num] ) then
                BOTCHED.FUNC.DermaQuery( "Inserting a reward here will move the other rewards up/down.", "REWARD CREATION", "Confirm", CreateFunc, "Cancel" )
            else
                CreateFunc()
            end
        end )
    end

    self:SetTall( (math.ceil( (table.Count( rewards )+1)/slotsWide )*(slotSize+spacing))-spacing )
end

function PANEL:CreateLoginRewardSlot( parent, loginRewardCfg, loginRewardKey, w, h, doClick )
    local rewardPanel = vgui.Create( "botched_item_slot", parent )
    rewardPanel:SetSize( w, h )
    rewardPanel:DisableText( true )
    rewardPanel:SetShadowScissor( function()
        local startY, endY = self.GetYShadowScissor()
        return 0, startY, ScrW(), endY
    end )
    rewardPanel.UpdateRewardInfo = function( self2, loginRewardCfg )
        local itemInfo, amount
        if( not BOTCHED.DEVCONFIG.RewardTypes[loginRewardCfg.RewardType] ) then 
            itemInfo = {
                Name = "Error", 
                Model = "botched/icons/error.png"
            }
        elseif( loginRewardCfg.RewardType == "Items" ) then
            itemInfo, amount = BOTCHED.CONFIG.LOCKER.Items[loginRewardCfg.RewardValue[1]], loginRewardCfg.RewardValue[2]
        else
            local rewardCfg = BOTCHED.DEVCONFIG.RewardTypes[loginRewardCfg.RewardType]
            itemInfo = {
                Name = rewardCfg.Name, 
                Model = rewardCfg.Material, 
                Border = rewardCfg.Border, 
                Stars = rewardCfg.Stars
            }
    
            amount = loginRewardCfg.RewardValue
        end

        rewardPanel:SetItemInfo( itemInfo, amount, doClick )
    end

    rewardPanel:UpdateRewardInfo( loginRewardCfg )

    local rewardCover = vgui.Create( "DPanel", rewardPanel.hoverDraw or rewardPanel )
    rewardCover:Dock( FILL )
    rewardCover:SetZPos( -100 )
    rewardCover.Paint = function( self2, w, h )
        draw.SimpleText( "Day " .. loginRewardKey, "MontserratBold20", w/2, BOTCHED.FUNC.ScreenScale( 5 ), BOTCHED.FUNC.GetTheme( 3 ), TEXT_ALIGN_CENTER, 0 )
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
    end

    local popup = vgui.Create( "botched_popup_config" )
    popup:SetHeader( "LOGIN REWARD CONFIG" )
    popup.OnClose = function()
        if( not valueChanged ) then return end
        BOTCHED.FUNC.RequestConfigChange( "REWARDS", "LoginRewards", rewards )
        self:Refresh()
    end
    popup:FinishSetup()

    self.popup = popup

    popup:SetInfo( "Reward Info", "Basic information and actions.", Material( "botched/icons/data.png" ) )

    popup:AddActionButton( "Delete", Material( "botched/icons/delete_24.png" ), function()
        BOTCHED.FUNC.DermaQuery( "Are you sure you want to delete this reward?", "REWARD DELETION", "Confirm", function()
            table.remove( rewards, rewardKey )
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
    itemPanel = self:CreateLoginRewardSlot( popup, configItem, rewardKey, itemPanelWide, itemPanelWide )
    itemPanel:SetPos( popup.sectionMargin+(popup.sectionWide/2)-(itemPanelWide/2), popup.header:GetTall()+(popup.mainPanel.targetH-popup.header:GetTall()-popup.infoBack:GetTall())/2-itemPanel:GetTall()/2 )  

    -- REWARD INFO --
    local rewardField = popup:AddField( "Type Info", "The type of reward and value.", Material( "botched/icons/type_24.png" ) )

    local rewardTypeSelect = vgui.Create( "botched_combo_description", rewardField )
    rewardTypeSelect:Dock( TOP )
    rewardTypeSelect:DockMargin( margin10, margin10, margin10, margin10 )
    rewardTypeSelect:SetWide( rewardField:GetWide()-(2*margin10) )
    rewardTypeSelect.OnSelect = function( self2, index )
        if( index != configItem.RewardType ) then
            ChangeItemVariable( "RewardValue", index == "Items" and { table.GetKeys( BOTCHED.CONFIG.LOCKER.Items )[1], 1 } or 0 )
            ChangeItemVariable( "RewardType", index )
            itemPanel:UpdateRewardInfo( configItem )
        end

        rewardField:RefreshReqInfo()
    end

    for k, v in pairs( BOTCHED.DEVCONFIG.RewardTypes ) do
        rewardTypeSelect:AddChoice( k, v.Name, v.Description )
    end
    rewardField.RefreshReqInfo = function( self2 )
        for k, v in ipairs( self2.reqInfoPanels or {} ) do
            v:Remove()
        end

        self2.reqInfoPanels = {}

        local typeInfo = BOTCHED.DEVCONFIG.RewardTypes[configItem.RewardType]

        local headerH = BOTCHED.FUNC.ScreenScale( 50 )
        local entryH = BOTCHED.FUNC.ScreenScale( 40 )
        local slotH = headerH+entryH+margin10

        local function CreateEntrySlot( name, description )
            local slot = vgui.Create( "DPanel", self2 )
            slot:Dock( TOP )
            slot:DockMargin( margin10, 0, margin10, margin10 )
            slot:DockPadding( margin10, headerH, margin10, margin10 )
            slot:SetTall( slotH )
            slot.Paint = function( self2, w, h )
                draw.RoundedBox( 8, 0, 0, w, h, BOTCHED.FUNC.GetTheme( 2, 100 ) )

                draw.SimpleText( name, "MontserratBold20", margin10, headerH/2+1, BOTCHED.FUNC.GetTheme( 3 ), 0, TEXT_ALIGN_BOTTOM )
                draw.SimpleText( description, "MontserratMedium17", margin10, headerH/2-1, BOTCHED.FUNC.GetTheme( 4, 100 ) )
            end

            table.insert( self2.reqInfoPanels, slot )

            return slot
        end

        if( configItem.RewardType == "Items" ) then
            local itemSlot = CreateEntrySlot( "Selected Item", "The locker item to give as a reward." )

            itemSlot.entry = vgui.Create( "botched_combosearch", itemSlot )
            itemSlot.entry.OnSelect = function( self2, index, value, data )
                ChangeItemVariable( "RewardValue", { data, configItem.RewardValue[2] } )
                itemPanel:UpdateRewardInfo( configItem )
            end

            for k, v in pairs( BOTCHED.CONFIG.LOCKER.Items ) do
                itemSlot.entry:AddChoice( v.Name, k )
            end

            local itemConfig = BOTCHED.CONFIG.LOCKER.Items[configItem.RewardValue[1]]
            itemSlot.entry:SetValue( itemConfig.Name )

            local amountSlot = CreateEntrySlot( "Amount", "The amount of the item to give." )

            amountSlot.entry = vgui.Create( "botched_numberwang", amountSlot )
            amountSlot.entry:SetValue( configItem.RewardValue[2] )
            amountSlot.entry.OnChange = function( self2 )
                ChangeItemVariable( "RewardValue", { configItem.RewardValue[1], self2:GetValue() } )
                itemPanel:UpdateRewardInfo( configItem )
            end
        else
            local slot = CreateEntrySlot( "Amount", "The amount to give as a reward." )

            slot.entry = vgui.Create( "botched_numberwang", slot )
            slot.entry:SetValue( configItem.RewardValue )
            slot.entry.OnChange = function( self2 )
                ChangeItemVariable( "RewardValue", self2:GetValue() )
                itemPanel:UpdateRewardInfo( configItem )
            end
        end

        for k, v in pairs( self2.reqInfoPanels ) do
            v.entry:Dock( BOTTOM )
            v.entry:SetTall( entryH )
            v.entry:SetBackColor( BOTCHED.FUNC.GetTheme( 1 ) )
            v.entry:SetHighlightColor( BOTCHED.FUNC.GetTheme( 2, 25 ) )
        end

        rewardField:SetExtraHeight( margin10+rewardTypeSelect:GetTall()+margin10+(#self2.reqInfoPanels*(slotH+margin10)) )
    end

    rewardTypeSelect:SelectChoice( configItem.RewardType )
end

function PANEL:Paint( w, h )

end

vgui.Register( "botched_config_loginrewards", PANEL, "DPanel" )