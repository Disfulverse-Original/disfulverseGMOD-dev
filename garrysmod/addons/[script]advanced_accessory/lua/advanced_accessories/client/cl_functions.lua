/*
    Addon id: 08ee2233-2d73-4598-a636-76adb93194f5
    Version: v2.1.6 (stable)
*/

function AAS.GetMaterial(cat)
	local mat = nil
	for k,v in ipairs(AAS.Category["mainMenu"]) do
		if cat != v.uniqueName then continue end
		
		mat = v.material
	end
	return mat
end

function AAS.GetInventoryByCategory(category)
	local itemsInventory = AAS.ClientTable["ItemsInventory"]
	local tableToSend = {}
	
	for k,v in pairs(itemsInventory) do
		if not isnumber(tonumber(v.uniqueId)) then continue end
		
		local itemTable = AAS.GetTableById(v.uniqueId)
		if itemTable.category != category then continue end

		tableToSend[category] = tableToSend[category] or {}
		tableToSend[category][#tableToSend[category] + 1] = v
	end

	return tableToSend
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 2ac76e693552f037481c18f13287287a7dd363c0c619b282b58470ebf17cd78a */

function AAS.CountInventory()
	local itemsInventory = AAS.ClientTable["ItemsInventory"]
	local Count = 0
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 2ac76e693552f037481c18f13287287a7dd363c0c619b282b58470ebf17cd78a */
	
	for k,v in pairs(itemsInventory) do
		if not isnumber(tonumber(v.uniqueId)) then continue end
		
		local itemTable = AAS.GetTableById(v.uniqueId)
		if not istable(itemTable) or table.Count(itemTable) == 0 then continue end

		Count = Count + 1
	end

	return Count
end

function AAS.BreakText(text, max)
    if not isstring(text) then return end
    if not isnumber(max) then return end

    local oldText = string.Trim(text)
    local newText = ""

    local words = string.Explode(" ", oldText)

    local textLine = ""
    local caracterLineCount = 0
    for k, v in ipairs(words) do
        if (caracterLineCount + string.len(v)) < max then
            textLine = textLine.." "..v
        else
            newText = (newText == "") and textLine or newText.."\n"..textLine
            textLine = " "..v
        end
        caracterLineCount = string.len(textLine)
    end
    newText = (newText == "") and textLine or newText.."\n"..textLine

    return newText
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198402768796

function AAS.ConvertVector(pos, offset, ang)
	return Vector(pos + ang:Forward() * offset.x + ang:Right() * offset.y + ang:Up() * offset.z)
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198402768796

function AAS.ConvertAngle(ang, vector)
	ang = Angle(ang)

	ang:RotateAroundAxis(ang:Up(), vector.x)
	ang:RotateAroundAxis(ang:Right(), vector.y)
	ang:RotateAroundAxis(ang:Forward(), vector.z)

	return ang
end

function AAS.GetTableById(uniqueId)
	uniqueId = tonumber(uniqueId)

	local tbl = {}
	for k,v in ipairs(AAS.ClientTable["ItemsTable"]) do
		if tonumber(v.uniqueId) == uniqueId then
			tbl = v
			break
		end
	end
	return tbl
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198402768796

function AAS.SetPanelSettings(panel, tbl)
	local skin = tonumber(tbl.options.skin)
	if isnumber(skin) then
		panel.Entity:SetSkin(skin)
	end

	local color = tbl.options.color
	if istable(color) then
		panel:SetColor(color)
	end
end

function AAS.ItemIsBought(uniqueId)
	local uniqueId = tonumber(uniqueId)

	local sell = false
	for k,v in pairs(AAS.ClientTable["ItemsInventory"]) do
		if tonumber(v.uniqueId) == uniqueId then
			sell = true 
			break
		end 
	end
	return sell
end
