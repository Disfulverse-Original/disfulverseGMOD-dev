if CLIENT then

local drawDeathEffects = false
local deathsystem_autorespawn = true
local drawString = "You died!"



local tab = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0.05,
	["$pp_colour_brightness"] = -0.65,
	["$pp_colour_contrast"] = 15,
	["$pp_colour_colour"] = 0.05,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 1
}

surface.CreateFont("DeathFont", {
	font = "Roboto", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 25,
	weight = 25,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )
--




local function hideOtherDeathEffects(name)
    if (name == "CHudDamageIndicator" and (not LocalPlayer():Alive())) then
	    return false
	end
end
hook.Add("HUDShouldDraw", "hideOtherDeathEffects", hideOtherDeathEffects)



net.Receive("enableDrawBlurEffect", function ()
    drawDeathEffects = net.ReadType()
	drawString = net.ReadString()
end)

net.Receive("disableDrawBlurEffect", function ()
    drawDeathEffects = net.ReadType()
end)

--Render the death effects
local function renderBlurEffect()
    if drawDeathEffects == true then
		DrawColorModify(tab)
        DrawMotionBlur(0.05, 0.8, 0.02)
	else
	  --nothing
	end
end
hook.Add("RenderScreenspaceEffects", "renderBlurEffect", renderBlurEffect)


local function drawPlayerDeathThink()
    if drawDeathEffects == true then
	    local ply = LocalPlayer()
		    draw.DrawText(drawString, "DeathFont", ScrW() / 2, ScrH() / 2 - 275, Color(255, 0, 0, 150), TEXT_ALIGN_CENTER)
		    draw.DrawText(drawString, "DeathFont", ScrW() / 2 - 1, ScrH() / 2 - 274, Color(0, 0, 0, 125), TEXT_ALIGN_CENTER)
		    --draw.DrawText("Время до возрождения " .. tostring(math.floor(ply:GetNWFloat("deathTimeLeft"))) .. " секунд.", "DermaLarge", ScrW() / 2, ScrH() / 2 - 225, Color(255, 255, 255, 175), TEXT_ALIGN_CENTER)
		    --draw.DrawText("Время до возрождения " .. tostring(math.floor(ply:GetNWFloat("deathTimeLeft"))) .. " секунд.", "DermaLarge", ScrW() / 2 - 1, ScrH() / 2 - 224, Color(0, 0, 0, 125), TEXT_ALIGN_CENTER)
		    draw.RoundedBox( 2, ScrW() / 2 - 250, ScrH() / 2 - 215, tostring(math.floor(ply:GetNWFloat("deathTimeLeft")*10*Lerp(math.floor(ply:GetNWFloat("deathTimeLeft")) + CurTime(), 0, 1))), 15, Color( 255, 255, 255, 175 ) )
	end
end
hook.Add("HUDPaint", "drawPlayerDeathThink", drawPlayerDeathThink)



end