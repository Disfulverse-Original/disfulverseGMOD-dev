--[[

Author: tochnonement
Email: tochnonement@gmail.com

05/03/2023

--]]

function onyx.creditstore.OpenAdminSettings()
    local frame = vgui.Create('onyx.Frame')
    frame:SetSize(ScrW() * .66, ScrH() * .66)
    frame:Center()
    frame:MakePopup()
    frame:SetTitle('ADMIN PANEL')

    local p = onyx.ScaleTall(15)
    local content = frame:Add('Panel')
    content:Dock(FILL)
    content:DockPadding(p, p, p, p)

    local sidebar = frame:Add('onyx.Sidebar')
    sidebar:SetContainer(content)
    sidebar:SetWide(frame:GetWide() * .2)
    sidebar:Dock(LEFT)

    sidebar:AddTab({
        name = onyx.lang:Get('players_u'),
        desc = 'Edit players\' inventories',
        icon = 'https://i.imgur.com/LT0UQx1.png',
        class = 'onyx.creditstore.AdminPlayers'
    })

    CAMI.PlayerHasAccess(LocalPlayer(), 'onyx_creditstore_edit', function(bAllowed)
        if (bAllowed and IsValid(sidebar)) then
            sidebar:AddTab({
                name = onyx.lang:Get('items_u'),
                desc = 'Edit items',
                icon = 'https://i.imgur.com/eCOYBhL.png',
                class = 'onyx.creditstore.AdminItems'
            })
    
            sidebar:AddTab({
                name = onyx.lang:Get('settings_u'),
                desc = 'Configure the addon',
                icon = 'https://i.imgur.com/ECLKU9s.png',
                class = 'onyx.Configuration',
                onSelected = function(panel)
                    panel:LoadAddonSettings('creditstore')
                    panel:OpenCategories()
                end
            })
        end
    end)

    sidebar:AddTab({
        name = onyx.lang:Get('return_u'),
        desc = 'Return to store',
        icon = 'https://i.imgur.com/iTONhJq.png',
        onClick = function()
            frame:Remove()
            onyx.creditstore:OpenStore()
            return false
        end
    })

    sidebar:ChooseTab(1)

    return frame
end

function onyx.creditstore.OpenAdminPlayerInventory(steamid64)
    local frame = vgui.Create('onyx.Frame')
    frame:SetSize(ScrW() * .5, ScrH() * .75)
    frame:Center()
    frame:MakePopup()
    frame:SetTitle('ADMIN INVENTORY EDITOR')

    local content = frame:Add('onyx.creditstore.AdminPlayerInventory')
    content:Dock(FILL)
    content:Request(steamid64)

    return frame
end

--[[------------------------------
Networking
--------------------------------]]
net.Receive('onyx.creditstore:AdminRequestInventory', function()
    local balance = net.ReadUInt(32)
    local inventory = onyx.net.ReadTable()

    if (IsValid(onyx.AdminPlayerInventoryPanel)) then
        onyx.AdminPlayerInventoryPanel.inventory:LoadItems(inventory)
        onyx.AdminPlayerInventoryPanel:LoadBalance(balance)
    end
end)