--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

function PROJECT0.FUNC.ScreenScale( number )
    return math.Round( number*(ScrW()/2560) )
end
 
PROJECT0.UI = {
	Margin5 = PROJECT0.FUNC.ScreenScale( 5 ),
	Margin10 = PROJECT0.FUNC.ScreenScale( 10 ),
	Margin15 = PROJECT0.FUNC.ScreenScale( 15 ),
	Margin25 = PROJECT0.FUNC.ScreenScale( 25 ),
	Margin50 = PROJECT0.FUNC.ScreenScale( 50 ),
	Margin100 = PROJECT0.FUNC.ScreenScale( 100 )
}

function PROJECT0.FUNC.Repeat( val, amount )
	local args = {}
	for i = 1, amount do
		table.insert( args, val )
	end

	return unpack( args )
end

function PROJECT0.FUNC.GetTheme( num, alpha )
    local color = PROJECT0.CONFIG.GENERAL.Themes[num] or Color( 255, 0, 0 )
    if( alpha and alpha < 255 ) then
        color = Color( color.r, color.g, color.b, alpha )
    end

    return color
end

local blur = Material("pp/blurscreen")
function PROJECT0.FUNC.DrawBlur( p, a, d )
	local x, y = p:LocalToScreen(0, 0)
	surface.SetDrawColor( 255, 255, 255 )
    surface.SetMaterial( blur )
    
	for i = 1, d do
		blur:SetFloat( "$blur", (i / d ) * ( a ) )
		blur:Recompute()
		if( render ) then render.UpdateScreenEffectTexture() end
		surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH() )
	end
end

-- Credits: https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/includes/modules/draw.lua, https://gist.github.com/MysteryPancake/e8d367988ef05e59843f669566a9a59f
PROJECT0.MaskMaterial = CreateMaterial("!project0_mask","UnlitGeneric",{
	["$translucent"] = 1,
	["$vertexalpha"] = 1,
	["$alpha"] = 1,
})

local whiteColor = Color( 255, 255, 255 )
local renderTarget
local function drawRoundedMask( cornerRadius, x, y, w, h, drawFunc, roundTopLeft, roundTopRight, roundBottomLeft, roundBottomRight )
	if( not renderTarget ) then
		renderTarget = GetRenderTargetEx( "PROJECT0_ROUNDEDBOX", ScrW(), ScrH(), RT_SIZE_FULL_FRAME_BUFFER, MATERIAL_RT_DEPTH_NONE, 2, CREATERENDERTARGETFLAGS_UNFILTERABLE_OK, IMAGE_FORMAT_RGBA8888 )
	end

	render.PushRenderTarget( renderTarget )
	render.OverrideAlphaWriteEnable( true, true )
	render.Clear( 0, 0, 0, 0 ) 

	drawFunc()

	render.OverrideBlendFunc( true, BLEND_ZERO, BLEND_SRC_ALPHA, BLEND_DST_ALPHA, BLEND_ZERO )
	draw.RoundedBoxEx( cornerRadius, x, y, w, h, whiteColor, roundTopLeft, roundTopRight, roundBottomLeft, roundBottomRight )
	render.OverrideBlendFunc( false )
	render.OverrideAlphaWriteEnable( false )
	render.PopRenderTarget() 

	PROJECT0.MaskMaterial:SetTexture( "$basetexture", renderTarget )

	draw.NoTexture()

	surface.SetDrawColor( 255, 255, 255, 255 ) 
	surface.SetMaterial( PROJECT0.MaskMaterial ) 
	render.SetMaterial( PROJECT0.MaskMaterial )
	render.DrawScreenQuad() 
end

function PROJECT0.FUNC.DrawRoundedMask( cornerRadius, x, y, w, h, drawFunc )
	drawRoundedMask( cornerRadius, x, y, w, h, drawFunc, true, true, true, true )
end

function PROJECT0.FUNC.DrawRoundedExMask( cornerRadius, x, y, w, h, drawFunc, roundTopLeft, roundTopRight, roundBottomLeft, roundBottomRight )
	drawRoundedMask( cornerRadius, x, y, w, h, drawFunc, roundTopLeft, roundTopRight, roundBottomLeft, roundBottomRight )
end

-- Credits: https://github.com/FPtje/DarkRP/blob/master/gamemode/modules/base/cl_util.lua
local function charWrap(text, remainingWidth, maxWidth)
    local totalWidth = 0

    text = text:gsub(".", function(char)
        totalWidth = totalWidth + surface.GetTextSize(char)

        -- Wrap around when the max width is reached
        if totalWidth >= remainingWidth then
            -- totalWidth needs to include the character width because it's inserted in a new line
            totalWidth = surface.GetTextSize(char)
            remainingWidth = maxWidth
            return "\n" .. char
        end

        return char
    end)

    return text, totalWidth
end

function PROJECT0.FUNC.TextWrap(text, font, maxWidth)
    local totalWidth = 0

    surface.SetFont(font)

    local spaceWidth = surface.GetTextSize(' ')
    text = text:gsub("(%s?[%S]+)", function(word)
		local char = string.sub(word, 1, 1)
		if char == "\n" or char == "\t" then
			totalWidth = 0
		end

		local wordlen = surface.GetTextSize(word)
		totalWidth = totalWidth + wordlen

		-- Wrap around when the max width is reached
		if wordlen >= maxWidth then -- Split the word if the word is too big
			local splitWord, splitPoint = charWrap(word, maxWidth - (totalWidth - wordlen), maxWidth)
			totalWidth = splitPoint
			return splitWord
		elseif totalWidth < maxWidth then
			return word
		end

		-- Split before the word
		if char == ' ' then
			totalWidth = wordlen - spaceWidth
			return '\n' .. string.sub(word, 2)
		end

		totalWidth = wordlen
		return '\n' .. word
	end)

    return text, string.len( text )-string.len( string.Replace( text, "\n", "" ) )+1
end

-- Credits: https://github.com/FPtje/DarkRP/blob/master/gamemode/modules/base/cl_drawfunctions.lua
local function safeText(text)
    return string.match(text, "^#([a-zA-Z_]+)$") and text .. " " or text
end

function PROJECT0.FUNC.DrawNonParsedText(text, font, x, y, color, xAlign)
    return draw.DrawText(safeText(text), font, x, y, color, xAlign)
end

function PROJECT0.FUNC.NiceTrimText( text, font, w )
	local newText = string.Trim( text )
	local splitText = string.Split( newText, " " )

	surface.SetFont( font )

	while( surface.GetTextSize( newText ) >= w and #splitText > 0 ) do
		newText = string.sub( newText, 1, string.len( newText )-string.len( splitText[#splitText] ) )
		newText = string.Trim( newText )
		table.remove( splitText )
	end

	if( newText != text ) then
		newText = newText .. "..."
	end

	return newText
end

-- CIRCLE/ARC STUFF --
function PROJECT0.FUNC.DrawCircle( x, y, radius, color )
	if( radius <= 0 ) then return end
	
	if( color and istable( color ) and color.r and color.g and color.b ) then
		surface.SetDrawColor( color )
	end
	
	draw.NoTexture()

	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, 45 do
		local a = math.rad( ( i / 45 ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 ) -- This is needed for non absolute segment counts
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
end

function PROJECT0.FUNC.PrecachedArc( cx, cy, radius, thickness, startang, endang, roughness )
	local triarc = {}
	-- local deg2rad = math.pi / 180
	
	-- Define step
	local roughness = math.max(roughness or 1, 1)
	local step = roughness
	
	-- Correct start/end ang
	local startang,endang = startang or 0, endang or 0
	
	if startang > endang then
		step = math.abs(step) * -1
	end
	
	-- Create the inner circle's points.
	local inner = {}
	local r = radius - thickness
	for deg=startang, endang, step do
		local rad = math.rad(deg)
		-- local rad = deg2rad * deg
		local ox, oy = cx+(math.cos(rad)*r), cy+(-math.sin(rad)*r)
		table.insert(inner, {
			x=ox,
			y=oy,
			u=(ox-cx)/radius + .5,
			v=(oy-cy)/radius + .5,
		})
	end	
	
	-- Create the outer circle's points.
	local outer = {}
	for deg=startang, endang, step do
		local rad = math.rad(deg)
		-- local rad = deg2rad * deg
		local ox, oy = cx+(math.cos(rad)*radius), cy+(-math.sin(rad)*radius)
		table.insert(outer, {
			x=ox,
			y=oy,
			u=(ox-cx)/radius + .5,
			v=(oy-cy)/radius + .5,
		})
	end	
	
	-- Triangulize the points.
	for tri=1,#inner*2 do -- twice as many triangles as there are degrees.
		local p1,p2,p3
		p1 = outer[math.floor(tri/2)+1]
		p3 = inner[math.floor((tri+1)/2)+1]
		if tri%2 == 0 then --if the number is even use outer.
			p2 = outer[math.floor((tri+1)/2)]
		else
			p2 = inner[math.floor((tri+1)/2)]
		end
	
		table.insert(triarc, {p1,p2,p3})
	end
	
	-- Return a table of triangles to draw.
	return triarc
end

function PROJECT0.FUNC.DrawCachedArc( arc, color )
	draw.NoTexture()

	if( color ) then
		surface.SetDrawColor( color )
	end

	for k,v in ipairs(arc) do
		surface.DrawPoly(v)
	end
end


function PROJECT0.FUNC.DrawArc( cx, cy, radius, thickness, startang, endang, color )
	PROJECT0.FUNC.DrawCachedArc( PROJECT0.FUNC.PrecachedArc( cx, cy, radius, thickness, startang, endang ), color )
end

local gradientMatR, gradientMatU, gradientMatD = Material("gui/gradient"), Material("gui/gradient_up"), Material("gui/gradient_down")
function PROJECT0.FUNC.DrawGradientBox(x, y, w, h, direction, ...)
	local colors = {...}
	local horizontal = direction != 1
	local secSize = math.ceil( ((horizontal and w) or h)/math.ceil( #colors/2 ) )
	
	local previousPos = (horizontal and x or y)-secSize
	for k, v in pairs( colors ) do
		if( k % 2 == 0 ) then continue end

		previousPos = previousPos+secSize
		surface.SetDrawColor( v )
		surface.DrawRect( (horizontal and previousPos or x), (horizontal and y or previousPos), (horizontal and secSize or w), (horizontal and h or secSize) )
	end

	local previousGradPos = (horizontal and x or y)-secSize
	for k, v in pairs( colors ) do
		if( k % 2 != 0 ) then continue end

		previousGradPos = previousGradPos+secSize

		surface.SetDrawColor( v )
		surface.SetMaterial( horizontal and gradientMatR or gradientMatU )

		if( horizontal ) then
			surface.DrawTexturedRectUV( previousGradPos, y, secSize, h, 1, 0, 0, 1)
		else
			surface.DrawTexturedRect( x, previousGradPos, w, secSize )
		end

		if( colors[k+1] ) then
			surface.SetDrawColor( v )
			surface.SetMaterial( horizontal and gradientMatR or gradientMatD )
			surface.DrawTexturedRect((horizontal and previousGradPos+secSize or x), (horizontal and y or previousGradPos+secSize), (horizontal and secSize or w), (horizontal and h or secSize))
		end
	end
end

local blur = Material("pp/blurscreen")
function PROJECT0.FUNC.DrawBlur( p, a, d )
	local x, y = p:LocalToScreen(0, 0)
	surface.SetDrawColor( 255, 255, 255 )
    surface.SetMaterial( blur )
    
	for i = 1, d do
		blur:SetFloat( "$blur", (i / d ) * ( a ) )
		blur:Recompute()
		if( render ) then render.UpdateScreenEffectTexture() end
		surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH() )
	end
end

local function GetImageFromURL( url, failFunc )
    local CRC = util.CRC( url )
    local Extension = string.Split( url, "." )
    Extension = Extension[#Extension] or "png"

    if( not file.Exists( "projectzero/images", "DATA" ) ) then
        file.CreateDir( "projectzero/images" )
    end
    
    if( file.Exists( "projectzero/images/" .. CRC .. "." .. Extension, "DATA" ) ) then
        PROJECT0.TEMP.CachedMaterials[url] = Material( "data/projectzero/images/" .. CRC .. "." .. Extension )

        if( failFunc ) then
            failFunc( PROJECT0.TEMP.CachedMaterials[url], key )
        end

        return PROJECT0.TEMP.CachedMaterials[url], key
    else
        http.Fetch( url, function( body )
            file.Write( "projectzero/images/" .. CRC .. "." .. Extension, body )
            PROJECT0.TEMP.CachedMaterials[url] = Material( "data/projectzero/images/" .. CRC .. "." .. Extension )

            if( failFunc ) then
                failFunc( PROJECT0.TEMP.CachedMaterials[url], key )
            end
        end )
    end
end

PROJECT0.TEMP.CachedMaterials = {}

function PROJECT0.FUNC.CacheImageFromURL( url, failFunc )
    PROJECT0.TEMP.CachedMaterials[url] = false

    if( not PROJECT0.TEMP.CachedMaterials[url] ) then
        PROJECT0.TEMP.CachedMaterials[url] = GetImageFromURL( url, failFunc )
    end
end

PROJECT0.TEMP.GetImagesQueue = PROJECT0.TEMP.GetImagesQueue or {}
local function RunGetImagesQueue()
	local queueItem = PROJECT0.TEMP.GetImagesQueue[1]
	if( queueItem ) then
		table.remove( PROJECT0.TEMP.GetImagesQueue, 1 )

		local url, onGetFunc = queueItem[1], queueItem[2]
		if( PROJECT0.TEMP.CachedMaterials[url] ) then
			onGetFunc( PROJECT0.TEMP.CachedMaterials[url] )
			RunGetImagesQueue()
		else
			PROJECT0.FUNC.CacheImageFromURL( url, onGetFunc )

			timer.Create( "PROJECT0.Timer.GetImageLoad", 0.2, 1, function()
				RunGetImagesQueue()
			end )
		end
	end
end

function PROJECT0.FUNC.GetImage( url, onGetFunc )
	table.insert( PROJECT0.TEMP.GetImagesQueue, { url, onGetFunc } )
	
	if( timer.Exists( "PROJECT0.Timer.GetImageLoad" ) ) then return end
	RunGetImagesQueue()
end

function PROJECT0.FUNC.DrawClickPolygon( panel, w, h, color )
	if( panel:IsDown() and (panel.polyLastClicked or 0) <= CurTime() ) then
		panel.polyLastClicked = CurTime()
	end

	local clickPercent = math.Clamp( (CurTime()-(panel.polyLastClicked or 0))/0.3, 0, 1 )
	if( panel.polyLastClicked and panel.polyLastClicked+0.3 > CurTime() ) then
		local size = (w+PROJECT0.FUNC.ScreenScale( 300 ))*math.Clamp( clickPercent/0.5, 0, 1 )
		local offset = PROJECT0.FUNC.ScreenScale( 200 )

		surface.SetAlphaMultiplier( 1-math.Clamp( (clickPercent-0.5)*2, 0, 1 ) )
		surface.SetDrawColor( color or PROJECT0.FUNC.GetTheme( 2 ) )
		draw.NoTexture()
		surface.DrawPoly( {
			{ x = w-size+offset, y = -offset },
			{ x = w+offset, y = size-offset },
			{ x = size-offset, y = h+offset },
			{ x = -offset, y = h-size+offset }
		} )
		surface.SetAlphaMultiplier( 1 )
	end
end

function PROJECT0.FUNC.DrawClickFade( panel, w, h, color )
	if( panel:IsDown() and (panel.fadeLastClicked or 0) <= CurTime() ) then
		panel.fadeLastClicked = CurTime()
	end

	local clickPercent = math.Clamp( (CurTime()-(panel.fadeLastClicked or 0))/0.2, 0, 1 )
	if( panel.fadeLastClicked and panel.fadeLastClicked+0.3 > CurTime() ) then
		surface.SetAlphaMultiplier( 1-math.Clamp( clickPercent, 0, 1 ) )
		surface.SetDrawColor( color or PROJECT0.FUNC.GetTheme( 2 ) )
		surface.DrawRect( 0, 0, w, h )
		surface.SetAlphaMultiplier( 1 )
	end
end

function PROJECT0.FUNC.GetSolidColor( colorInfo )
	if( not colorInfo ) then 
		return PROJECT0.FUNC.GetTheme( 4 )
	end

	local duration = 6--#colorInfo*0.2
	local percent = CurTime()/duration
	percent = percent-math.floor( percent ) 

	local color1Key = math.ceil( percent*#colorInfo )
	local color2Key = (color1Key+1 > #colorInfo and 1) or color1Key+1

	local transitionPercent = (percent-((color1Key-1)/#colorInfo))/(1/#colorInfo)
	local color1, color2 = colorInfo[color1Key], colorInfo[color2Key]
	if( not color1 or not color2 ) then return PROJECT0.FUNC.GetTheme( 4 ) end 

	return Color( Lerp( transitionPercent, color1.r, color2.r ), Lerp( transitionPercent, color1.g, color2.g ), Lerp( transitionPercent, color1.b, color2.b ) )
end

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
