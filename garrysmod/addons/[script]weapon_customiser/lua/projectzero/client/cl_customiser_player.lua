--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

-- INVENTORY FUNCTIONS --
net.Receive( "Project0.SendCosmeticInventory", function()
    local cosmeticInventory = PROJECT0.LOCALPLYMETA.CosmeticInventory or {}

    for i = 1, net.ReadUInt( 8 ) do
        cosmeticInventory[net.ReadString()] = true
    end

    PROJECT0.LOCALPLYMETA.CosmeticInventory = cosmeticInventory

    hook.Run( "Project0.Hooks.CosmeticInventoryUpdated" )
end )

-- WEAPON FUNCTIONS --
net.Receive( "Project0.SendCustomisedWeapons", function()
    local customisedWeapons = PROJECT0.LOCALPLYMETA.CustomisedWeapons or {}

    for i = 1, net.ReadUInt( 8 ) do
        customisedWeapons[net.ReadString()] = {
            Skin = net.ReadUInt( 8 ),
            Charm = net.ReadUInt( 8 ),
            Sticker = net.ReadUInt( 8 )
        }
    end

    PROJECT0.LOCALPLYMETA.CustomisedWeapons = customisedWeapons

    hook.Run( "Project0.Hooks.CustomisedWeaponsUpdated" )
end )

-- SKIN FUNCTIONS --
net.Receive( "Project0.SendOwnedSkins", function()
    local ownedSkins = PROJECT0.LOCALPLYMETA.OwnedSkins or {}

    for i = 1, net.ReadUInt( 8 ) do
        local skinKey = net.ReadUInt( 8 )
        ownedSkins[skinKey] = {}

        for i = 1, net.ReadUInt( 8 ) do
            ownedSkins[skinKey][net.ReadString()] = true
        end
    end

    PROJECT0.LOCALPLYMETA.OwnedSkins = ownedSkins

    hook.Run( "Project0.Hooks.OwnedSkinsUpdated" )
end )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
