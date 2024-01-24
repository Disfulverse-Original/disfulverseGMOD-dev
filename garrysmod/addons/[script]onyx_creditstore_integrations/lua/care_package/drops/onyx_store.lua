--[[------------------------------
EXPLANATION
You would need to add following lines to register item (xenin-carepackages\lua\care_package\configuration\items.lua):

CarePackage:AddItem(100, 'OnyxCredits', {
	Color = XeninUI.Theme.Yellow
})

P.S: The first argument is the amount of credits
--------------------------------]]

local DROP = CarePackage:CreateDrop()

DROP.InventoryEnabled = false
DROP.EquipName = function()
    return 'Credits'
end
DROP.EquipName = function()
	return CarePackage:GetPhrase('Drops.Money.Loot')
end

function DROP:CanLoot(ent, ply, type)
    return true
end

function DROP:Loot(ent, ply, type)
    onyx.creditstore:AddCredits(ply, tonumber(ent))
end

function DROP:GetName(ent)
    return (string.Comma(ent) .. ' Credits')
end

function DROP:GetModel(ent)
	return '.mdl'
end

function DROP:GetColor(ent)
    return Color(59, 183, 255)
end

function DROP:CustomPanel(panel, reward)
    panel.Model = panel:Add('Panel')
    panel.Model:Dock(FILL)
    panel.Model:SetZPos(1)
    panel.Model:DockMargin(1, 65, 1, 1)
    panel.Model:SetMouseInputEnabled(false)

    local wimgObject = onyx.wimg.Create('creditstore_truecurrency3', 'smooth mips')
    panel.Model.Paint = function(pnl, w, h)
        XeninUI:Mask(function()
            XeninUI:DrawRoundedBox(6, 8, 8, w - 16, h - 16, color_white)
        end, function()
            local width = w - 16
            local height = width / 4
            local y = h / 2 - height / 2
            local size = onyx.ScaleTall(48)

            wimgObject:Draw(w * .5 - size * .5, h * .5 - size * .5, size, size)
        end)
    end
end

DROP:Register('OnyxCredits')