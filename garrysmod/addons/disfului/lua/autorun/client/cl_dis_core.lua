AddCSLuaFile()

--------------------------------------------------------------
local hideHUDElements = {
    ["DarkRP_HUD"] = true,
    ["DarkRP_EntityDisplay"] = true,
    ["DarkRP_LocalPlayerHUD"] = true,
    ["DarkRP_Hungermod"] = true,
    ["DarkRP_Agenda"] = true,
    ["DarkRP_LockdownHUD"] = true,
    ["DarkRP_ArrestedHUD"] = true,
    ["CHudAmmo"] = true,
    ["CHudSecondaryAmmo"] = true,
    ["VCMod_Side"] = true,
    ["MurderHealthBall"] = true,
    ["MurderPlayerType"] = true,
    ["TTTInfoPanel"] = true
}
hook.Add("HUDShouldDraw", "dis_OverrideDarkRP", function(name)
    if hideHUDElements[name] then return false end
end)
--hook.Remove("PostPlayerDraw", "DarkRP_ChatIndicator") -- removed this shit internally
--------------------------------------------------------------

print("cl_core")

-- start of the hud ------------------------------------------
local scrw, scrh = ScrW(), ScrH()
local start, oldhp, newhp = 0, -1, -1
local startarm, oldarmor, newarmor = 0, -1, -1
local time, time2 = 0, 0
--mats
local backmaterial2 = Material( "vgui/mat1.png", "noclamp smooth" )
local hearticon = Material( "materials/vgui/hearticon64x.png", "noclamp smooth" )
local armoricon = Material( "materials/vgui/armoricon64x.png", "noclamp smooth" )

-- func to make smooth easeout anims
local function easedLerp(fraction, from, to)
	return Lerp(math.ease.OutExpo(fraction), from, to)
end

-- hud draw
local function disfulhud_draw()
	if not IsValid(LocalPlayer()) then return end

	local heightnormal, heightzero = scrh/2*0.01, 0

	if LocalPlayer():Health() < 100 then
		time = CurTime()
	end

	local heightanim = easedLerp( (CurTime() - time)*0.5, heightnormal, heightzero)
	--print(heightanim .. " " .. heightnormal)

	surface.SetMaterial( backmaterial2 )
	surface.SetDrawColor( 150, 50, 255, 225 )
	surface.DrawTexturedRect( scrw*0.02, scrh*0.03, scrw/6, math.max(0,heightanim) )

	--healthICON
	surface.SetMaterial( hearticon )
	surface.SetDrawColor( Color(255, 255 , 255, LocalPlayer():Health() == 100 and 0 or 255 ) )
	surface.DrawTexturedRect( scrw/2*0.02, (scrh*0.03)*0.885, 16, 16 )

	local hp = LocalPlayer():Health()

	if (oldhp == -1) and (newhp == -1) then
		oldhp = hp
		newhp = hp
	end

	local animhealthlen = easedLerp( (CurTime() - start), oldhp, newhp)


	if newhp != hp then
		if animhealthlen != hp then
			newhp = animhealthlen
		end

		oldhp = newhp
		start = CurTime()
		newhp = hp
	end

	surface.SetDrawColor(Color(204, 212, 255))
	surface.DrawRect(scrw*0.02, scrh*0.03, (math.max( 0, animhealthlen )) *4.262, math.max(0,heightanim) )
	----------------------------------------------------------------------------------------------------------------

	local heightnormal2, heightzero2 = scrh/2*0.01, 0

	if LocalPlayer():Armor() > 0 then
		time2 = CurTime()
	end

	local heightanim2 = easedLerp( (CurTime() - time2)*0.5, heightnormal2, heightzero2)

	armor = LocalPlayer():Armor()

	surface.SetMaterial( backmaterial2 )
	surface.SetDrawColor( 150, 50, 255, 225 )
	surface.DrawTexturedRect( scrw*0.02, scrh*0.06, scrw/6, math.max(0,heightanim2) )

	--armorICON
	surface.SetMaterial( armoricon )
	surface.SetDrawColor( Color(255,255,255, LocalPlayer():Armor() > 0 and 255 or 0) )
	surface.DrawTexturedRect( scrw/2*0.02, (scrh*0.06)*0.938, 16, 16 )

	if (oldarmor == -1) and (newarmor == -1) then
		oldarmor = armor
		newarmor = armor
	end

	local animarmorlen = easedLerp( (CurTime()/2 - startarm), oldarmor, newarmor)

	if newarmor != armor then
		if animarmorlen != armor then
			newarmor = animarmorlen
		end

		oldarmor = newarmor
		startarm = CurTime()/2
		newarmor = armor
	end

	surface.SetDrawColor( Color(204, 212, 255) )
	surface.DrawRect(scrw*0.02, scrh*0.06, (math.max( 0, animarmorlen )) *4.262, math.max(0,heightanim2))

end
-- vignette draw
local function disfulhud_vignette()
	DrawMaterialOverlay("overlays/vignette02", 1)
end

hook.Add( "HUDPaint", "Disfulverse_Hud", disfulhud_draw)
hook.Add("RenderScreenspaceEffects", "Disfulverse_Vignette", disfulhud_vignette)
-------- end of the hud --------------------------------------