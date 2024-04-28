--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

/*
    Addon id: 00690769-9ce4-49c1-bc5f-802f53225f58
    Version: v1.2.3 (stable)
*/

-- [[ Thanks to GNLIB for the DrawCircle and DrawElipse function ( https://github.com/Nogitsu/GNLib/ ) ]]
function ACC2.DrawComplexCircle(x, y, radius, angle_start, angle_end, color)
	local poly = {}
	angle_start = angle_start or 0
	angle_end = angle_end or 360
	
	poly[1] = { x = x, y = y }
	for i = math.min( angle_start, angle_end ), math.max( angle_start, angle_end ) do
		local a = math.rad( i )
		if angle_start < 0 then
			poly[#poly + 1] = { x = x + math.cos( a ) * radius, y = y + math.sin( a ) * radius }
		else
			poly[#poly + 1] = { x = x - math.cos( a ) * radius, y = y - math.sin( a ) * radius }
		end
	end
	poly[#poly + 1] = { x = x, y = y }

	draw.NoTexture()
	surface.SetDrawColor( color or color_white )
	surface.DrawPoly( poly )

	return poly
end

function ACC2.DrawSimpleCircle(x, y, radius, seg)
	local cir = {}

	table.insert(cir, { x = x, y = y, u = 0.5, v = 0.5 })
	for i = 0, seg do
		local a = math.rad((i / seg) * -360)
		table.insert(cir, { x = x + math.sin(a) * radius, y = y + math.cos(a) * radius, u = math.sin(a) / 2 + 0.5, v = math.cos(a) / 2 + 0.5 })
	end

	local a = math.rad(0) -- This is needed for non absolute segment counts
	table.insert(cir, { x = x + math.sin(a) * radius, y = y + math.cos(a) * radius, u = math.sin(a) / 2 + 0.5, v = math.cos(a) / 2 + 0.5 })

	surface.DrawPoly(cir)
end

ACC2.PrecachedCircles = ACC2.PrecachedCircles or {} 

function ACC2.GetCircle(x, y, radius, angle_start)
    local poly = {}

    local i = 0
    while i < 360 do
        i = i + 15
        local posx = x + math.cos(math.rad(i))*radius
        local posy = y + math.sin(math.rad(i))*radius

        poly[#poly+1] = {x=posx, y=posy}
    end

    return poly
end

function ACC2.PrecacheCircle(x, y, radius, angle_start, angle_end)
    ACC2.PrecachedCircles[x] = ACC2.PrecachedCircles[x] or {}
    ACC2.PrecachedCircles[x][y] = ACC2.PrecachedCircles[x][y] or {}
    ACC2.PrecachedCircles[x][y][radius] = ACC2.PrecachedCircles[x][y][radius] or {}
    ACC2.PrecachedCircles[x][y][radius][angle_start] = ACC2.PrecachedCircles[x][y][radius][angle_start] or {}
    ACC2.PrecachedCircles[x][y][radius][angle_start][angle_end] = ACC2.PrecachedCircles[x][y][radius][angle_start][angle_end] or ACC2.GetCircle(x, y, radius, angle_start, angle_end)
    
    return ACC2.PrecachedCircles[x][y][radius][angle_start][angle_end]
end

function ACC2.DrawCircle(x, y, radius, angle_start, angle_end, color)
    
    local poly = ACC2.PrecacheCircle(x, y, radius, angle_start, angle_end)

    draw.NoTexture()
    surface.SetDrawColor(color or color_white)
    surface.DrawPoly(poly)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 482c562e67c7127e3b68e63eb0de779cb19814da22ab42eae52a7d3451fc844a */

    return poly
end

-- [[ Thanks to GNLIB for the DrawCircle and DrawElipse function ( https://github.com/Nogitsu/GNLib/ ) ]]
function ACC2.DrawElipse(x, y, w, h, color, hide_left, hide_right)
	surface.SetDrawColor(color or color_white)

	if hide_left then surface.DrawRect( x, y, h / 2, h ) else ACC2.DrawCircle( x + h / 2, y + h / 2, h / 2, 90, -90, color ) end
	if hide_right then surface.DrawRect( x + w - h / 2, y, h / 2, h ) else ACC2.DrawCircle( x + w - h / 2, y + h / 2, h / 2, -90, 90, color ) end

	surface.DrawRect( x + h / 2, y, w - h + 2, h )
end

--[[ Lerp a color to an other color ]]
function ACC2.LerpColor(frameTime, color, colorTo)
	return Color(Lerp(frameTime, color.r, colorTo.r), Lerp(frameTime, color.g, colorTo.g), Lerp(frameTime, color.b, colorTo.b), Lerp(frameTime, color.a, colorTo.a))
end

--[[ Draw a blur on a specific panel ]]
function ACC2.DrawBlur(panel, amount)
    local x, y = panel:LocalToScreen(0, 0)

    surface.SetDrawColor(ACC2.Colors["white"])
    surface.SetMaterial(ACC2.Materials["blur"])

    for i=1, 3 do
        ACC2.Materials["blur"]:SetFloat("$blur", (i/3) * (amount or 6))
        ACC2.Materials["blur"]:Recompute()
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198931466969

        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(x*-1, y*-1, ACC2.ScrW, ACC2.ScrH)
    end
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* ded51e6532282dfa00c9343043e6163c5627f86ee51ba1d02ddf9be86bf42ec7 */

--[[ Change the origin point of a rotated texture ]]
function ACC2.DrawTexturedRectRotatedPoint( x, y, w, h, rot, x0, y0 )
	local c = math.cos(math.rad(rot))
	local s = math.sin(math.rad(rot))
	
	local newx = y0 * s - x0 * c
	local newy = y0 * c + x0 * s
	
	surface.DrawTexturedRectRotated(x + newx, y + newy, w, h, rot)
end

--[[ Stencil function ]]
function ACC2.MaskStencil(maskFunc, renderFunc, bool)
    render.SetStencilEnable(true)
    render.ClearStencil()
    render.SetStencilWriteMask(1)
  
    render.SetStencilTestMask(1)
  
    render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
    render.SetStencilPassOperation(bool and STENCILOPERATION_ZERO or STENCILOPERATION_KEEP)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
    render.SetStencilReferenceValue(1)
  
	maskFunc()
  
    render.SetStencilFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilPassOperation(bool and STENCILOPERATION_ZERO or STENCILOPERATION_KEEP)
    render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
    render.SetStencilReferenceValue(bool and 0 or 1)
  
    renderFunc(self, w, h)
  
    render.ClearStencil()
    render.SetStencilEnable(false)
end

--[[ Function used to create fonts ]]
local FontTable = {}
function ACC2.CreateFonts(size, fontType, fontWeight, italicOption)
	local fontSize = math.Round(size, 0)
	local fontName = "ACC2_generate"..fontSize

    if FontTable[fontName] then 
        return fontName
    end

    surface.CreateFont(fontName, {
        font = (fontType or "Georama Black"), 
        size = fontSize, 
        weight = (fontWeight or 0),
        antialias = true,
        italic = italicOption,
    })
    FontTable[fontName] = true

    return fontName
end 
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- e76c9cbfd4851f046d135a3807c90610912e0963b3302ca13880769302aa4101

--[[ Function to created rounded rect ]]
function ACC2.DrawRoundedRect(radius, x, y, w, h, color)
    surface.SetDrawColor(color or color_white)

    surface.DrawRect(x + radius, y, w - radius * 2, h)
    surface.DrawRect(x, y + radius, radius, h - radius * 2)
    surface.DrawRect(x + w - radius, y + radius, radius, h - radius * 2)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 482c562e67c7127e3b68e63eb0de779cb19814da22ab42eae52a7d3451fc844a */

    ACC2.DrawCircle(x + radius, y + radius, radius, -180, -90, color)
    ACC2.DrawCircle(x + w - radius, y + radius, radius, -90, 0, color)
    ACC2.DrawCircle(x + radius, y + h - radius, radius, -270, -180, color)
    ACC2.DrawCircle(x + w - radius, y + h - radius, radius, 270, 180, color)
end

--[[ Function to created texture rect ]]
function ACC2.RoundedTextureRect(radius, x, y, w, h, mat, color, rotation)
    ACC2.MaskStencil(function()
        ACC2.DrawRoundedRect(radius, x, y, w, h, color)
    end, function()
        surface.SetMaterial(mat)
        surface.DrawTexturedRect(x, y, w, h)
    end)
end


--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
