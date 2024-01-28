AddCSLuaFile()

surface.CreateFont( "ARXHUDFONT", {
    font = "Roboto", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
    extended = true,
    size = 15,
    weight = 250
} )





print('arx hud cs loaded!')

local ReloadStyle = GetConVar("darky_arc_ReloadStyle")
local HPStyle = GetConVar("darky_arc_HPStyle")

local DynamicHUD = GetConVar("darky_arc_DynamicHUD")
local AmmoSegments = GetConVar("darky_arc_AmmoSegments")

local DrawAmmo = GetConVar("darky_arc_DrawAmmo")
local DrawAmmoReserve = GetConVar("darky_arc_DrawAmmoReserve")
local DrawAmmoOnSingle = GetConVar("darky_arc_DrawAmmoOnSingle")
local DrawRegen = GetConVar("darky_arc_DrawRegen")
local DrawHeat = GetConVar("darky_arc_DrawHeat")
local DraconicHeat = GetConVar("darky_arc_DrawDraconicHeat")

local HPNumbers = GetConVar("darky_arc_HPNumbers")
local AmmoNumbers = GetConVar("darky_arc_AmmoNumbers")

local DrawHud = GetConVar("darky_arc_DrawHud")
local ArcDistance = GetConVar("darky_arc_ArcDistance")
local ClickSoundOnLowAmmo = GetConVar("darky_arc_ClickSoundOnLowAmmo")

local WakeUpOnContext = GetConVar("darky_arc_WakeUpOnContext")
local WakeUpOnZoom = GetConVar("darky_arc_WakeUpOnZoom")
local HideOnWalk = GetConVar("darky_arc_HideOnWalk")

local AmmoColorR = GetConVar("darky_arc_AmmoColorR")
local AmmoColorG = GetConVar("darky_arc_AmmoColorG")
local AmmoColorB = GetConVar("darky_arc_AmmoColorB")

local HPColorR = GetConVar("darky_arc_HPColorR")
local HPColorG = GetConVar("darky_arc_HPColorG")
local HPColorB = GetConVar("darky_arc_HPColorB")

local ARColorR = GetConVar("darky_arc_ARColorR")
local ARColorG = GetConVar("darky_arc_ARColorG")
local ARColorB = GetConVar("darky_arc_ARColorB")

local ReloadR = GetConVar("darky_arc_ReloadR")
local ReloadG = GetConVar("darky_arc_ReloadG")
local ReloadB = GetConVar("darky_arc_ReloadB")

local HeatR = GetConVar("darky_arc_HeatR")
local HeatG = GetConVar("darky_arc_HeatG")
local HeatB = GetConVar("darky_arc_HeatB")


local SColor = Color(AmmoColorR:GetInt(), AmmoColorG:GetInt(), AmmoColorB:GetInt())
local TRBlack = Color(20, 20, 20, 220)
local TRBlack2 = Color(0, 0, 0, 50)
local TRBlack3 = Color(0, 0, 0, 50)
local ReloadColor2 = Color(ReloadR:GetInt(), ReloadG:GetInt(), ReloadB:GetInt(), 150)
local HPColor = Color(HPColorR:GetInt(), HPColorG:GetInt(), HPColorB:GetInt(), 80)
local ARColor = Color(ARColorR:GetInt(), ARColorG:GetInt(), ARColorB:GetInt(), 80)

local HeatColor = Color(HeatR:GetInt(), HeatG:GetInt(), HeatB:GetInt(), 200)



local w, h = ScrW(), ScrH()
local HPTextAlpha, SHPTextAlpha, ReloadAlpha, SRAlpha, SHP, LastHP, SClip, Reloading, SArmor, AnimVal, LastAR, HPState, HPAlpha = 1, 1, 1, 1, 100, 100, 1, false, 0, 0, 0, 0, 0
local LastWeapon, PrevClip, ViewModel

--  cool funtion that i writed myself
--  ask Darky#7990 before using this in your code
function draw.drawArc(x, y, r, a1, a2, step, thickness, color) --x, y, radius, angle1, angle2, step, thick, color
    local trad = r - thickness
	if a2 < a1 then a2, a1 = a1, a2 end
    local a, px, py, ox, oy, ar, vx, vy, fx, fy = false, 0, 0, 0, 0, 0, 0, 0, 0, 0

	repeat
		a = a and math.min(a + step, a2) or a1
        ar = a + 90
        
		px,py = x + r * math.cos(math.rad(ar)), y +r *math.sin(math.rad(ar))

		vx,vy = x + trad * math.cos(math.rad(ar)), y + trad * math.sin(math.rad(ar))
		fx,fy = x + trad * math.cos(math.rad(ar - step)), y + trad * math.sin(math.rad(ar - step))
	
		if a ~= a1 and ar - step > 0 then
            surface.SetDrawColor(color)
            surface.DrawPoly({{x = vx, y = vy}, {x = fx, y = fy}, {x = ox, y = oy}, {x = px, y = py}})
		end
        ox, oy = px, py
    until(a >= a2)
end


-- cool function from github
-- https://gist.github.com/theawesomecoder61/d2c3a3d42bbce809ca446a85b4dda754

--removed in 16.01.21 update. this function was shit.



-- cool color transimition funtion from WoW forum lol
local ColorGradient = function(perc, ...)
    local num = select("#", ...)

    if perc >= 1 then
        return select(num-2, ...), select(num-1, ...), select(num, ...)
    elseif perc <= 0 then
    	local r, g, b = ...
    	return r, g, b
    end

    num = num/3

    local segment, relperc = math.modf(perc*(num-1))
    local r1, g1, b1, r2, g2, b2
    r1, g1, b1 = select((segment*3) + 1, ...), select((segment*3) + 2, ...), select((segment*3) + 3, ...)
    r2, g2, b2 = select((segment*3) + 4, ...), select((segment*3) + 5, ...), select((segment*3) + 6, ...)

    if not r2 or not g2 or not b2 then
        return r1, g1, b1
    else
        return r1 + (r2-r1)*relperc,
        g1 + (g2-g1)*relperc,
        b1 + (b2-b1)*relperc, perc
    end
end

hook.Add("HUDPaint", "darky_ammo_counter", function()

    if DynamicHUD:GetBool() then
        local traceResult = LocalPlayer():GetEyeTrace()
        local pos = traceResult.HitPos:ToScreen()

        w, h = math.Round(pos.x), math.Round(pos.y)
    else
        w, h = ScrW()/2, ScrH()/2
    end
    

    if LocalPlayer():IsValid() then
        if not LocalPlayer():InVehicle() or LocalPlayer():InVehicle() and LocalPlayer():GetAllowWeaponsInVehicle() then
            local Weapon = LocalPlayer():GetActiveWeapon()
            local Arcd = ArcDistance:GetInt()
            if Weapon:IsValid() then
                if HPStyle:GetInt()>0 then
                    local MaxHP = LocalPlayer():GetMaxHealth()
                    local HP = LocalPlayer():Health()
                    
                    SHP = math.min(Lerp(0.1, SHP, HP), MaxHP)
                    TRBlack2 = Color(0, 0, 0, HPAlpha*50)
                    HPColor = Color(HPColorR:GetInt(), HPColorG:GetInt(), HPColorB:GetInt(), HPAlpha*120)

                    HPAlpha = Lerp(0.1, HPAlpha, HPState)

                    draw.drawArc(w - Arcd, h - Arcd, 50, 180, 90, 7.5, 3, TRBlack2) --x, y, radius, angle1, angle2, step, thickness
                    draw.drawArc(w - Arcd, h - Arcd, 50, 90, 90+SHP/MaxHP*90, 7.5, 3, HPColor) --x, y, radius, angle1, angle2, step, thickness


                    if HPStyle:GetInt() == 2 then
                        local MaxAR = LocalPlayer():GetMaxArmor()
                        local Armor = LocalPlayer():Armor()
                        SArmor = math.min(Lerp(0.1, SArmor, Armor), MaxAR)
                        TRBlack3 = Color(0, 0, 0, (HPAlpha*50)*math.min(SArmor, 1))
                        ARColor = Color(ARColorR:GetInt(), ARColorG:GetInt(), ARColorB:GetInt(), (HPAlpha*120)*math.min(SArmor, 1))

                        if math.min(SArmor, 1)==1 then
                            draw.drawArc(w - Arcd, h - Arcd, 55, 90, 180, 7.5, 3, TRBlack3) --x, y, radius, angle1, angle2, step, thickness 
                            draw.drawArc(w - Arcd, h - Arcd, 55, 90, 90+SArmor/MaxAR*90, 7.5, 3, ARColor) --x, y, radius, angle1, angle2, step, thickness
                        end
                    end

                    if HPNumbers:GetBool() then
                        SHPTextAlpha = Lerp(0.1, SHPTextAlpha, HPTextAlpha)
                        local SHPTextcolor = ColorAlpha(HPColor, SHPTextAlpha*255)
                        draw.SimpleText(""..math.Round(SHP), "ARXHUDFONT", w-20-Arcd, h-20-Arcd, SHPTextcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    end

                    if DrawRegen:GetBool() then
                        local val2 = 90+SHP/MaxHP*90
                        local dhpregen = LocalPlayer().DHPRegen or 0
                        local regen = math.Clamp(dhpregen, 0, math.max(MaxHP-HP, 0))

                        draw.drawArc(w - Arcd, h - Arcd, 50, val2, val2+regen, 7.5, 3, ColorAlpha(ReloadColor2,HPAlpha*120)) --x, y, radius, angle1, angle2, step, thickness
                   end
                end

                if Weapon:GetMaxClip1() >=1 and DrawAmmo:GetBool() and Weapon:GetPrimaryAmmoType() ~= -1 then
                    local MaxClip = Weapon:GetMaxClip1()
                    local CurClip = Weapon:Clip1()

                    SClip = Lerp(0.05, SClip, CurClip)

                    if CurClip <= MaxClip/1.5 and MaxClip>=4 then
                        --nothing.
                    else
                        SColor = Color(AmmoColorR:GetInt(), AmmoColorG:GetInt(), AmmoColorB:GetInt())
                    end


                    if Weapon.Wep then --  FA:S 2.0
                        ViewModel = Weapon.Wep
                    elseif Weapon.CW_VM then --  CW 2.0
                        ViewModel = Weapon.CW_VM
                    elseif Weapon.m_bInitialized then --  MW Base
                        ViewModel = Weapon.m_ViewModel
                    else --  ArcCW, TFA or any other weapon pack
                        ViewModel = LocalPlayer():GetViewModel()
                    end

                    local ReloadName = ViewModel:GetSequenceName(ViewModel:GetSequence())

                    --  кто-то додумался назвать перезарядку "wet"
                    if string.find(string.lower(ReloadName), "reload") and not Reloading or string.find(string.lower(ReloadName), "wet") and not Reloading then
                        Reloading = true
                        ReloadAlpha = 1
                        timer.Remove("DarkyHP_AFK_3")
                    end

                    if Reloading and ViewModel:GetCycle()>=0.97 or Weapon.m_bInitialized and Reloading and ViewModel:GetCycle()>=0.8 then
                        -- reload cycle on tfa weapons doesn't go to 1, so "Reloading" will not stop
                        -- hl2 weapons can shoot while cycle isn't on 1

                        -- additional check for mw base
                        
                        Reloading = false
                        ReloadAlpha = 1
                        timer.Create("DarkyHP_AFK_3", 1, 1, function() ReloadAlpha = 0 end)
                    end

                    --Jamming code for arccw
                    if Weapon.ArcCW and DrawHeat:GetBool() then
                        local HD = Weapon:GetHUDData() -- Fesiug said me that i need use GetHUDData()
                        if HD.heat_enabled then
                            local Heat, MaxHeat = HD.heat_level, HD.heat_maxlevel
                            HeatColor = ColorAlpha(Color(ColorGradient(1-math.min(-0.2 + Heat/(MaxHeat/1.5), 1), HeatR:GetInt(), HeatG:GetInt(), HeatB:GetInt(), 255, 255, 255)), 255)

                            draw.drawArc(w + Arcd, h + Arcd, 58, 360-Heat/MaxHeat*90, 360, 7.5, 5, HeatColor) --x, y, radius, angle1, angle2, step, thickness
                        end
                    end

                    --  i didnt find any draconic weapon with heat so i can't even test this.
                    --  Vuthakral said that this is working okay
                    if DraconicHeat:GetBool() and Weapon.Draconic then
                        local Heat, MaxHeat = Weapon:GetNWInt("Heat"), 100
                        HeatColor = ColorAlpha(Color(ColorGradient(1-math.min(-0.2 + Heat/(MaxHeat/1.5), 1), HeatR:GetInt(), HeatG:GetInt(), HeatB:GetInt(), 255, 255, 255)), 255)

                        draw.drawArc(w + Arcd, h + Arcd, 58, 360-Heat/MaxHeat*90, 360, 7.5, 5, HeatColor) --x, y, radius, angle1, angle2, step, thickness
                    end
                    local function myarc()
                        local black = Color(5,5,6,50)
                        local white = Color(255,255,255,75)
                        draw.drawArc(w + Arcd, h + Arcd, 50, 360, 270, 10, 3, black) --x, y, radius, angle1, angle2, step, thickness
                        draw.drawArc(w + Arcd, h + Arcd, 50, 360-SClip/MaxClip*90, 360, 5, 3, white) --x, y, radius, angle1, angle2, step, thickness
                    end

                    if MaxClip<=18 and AmmoSegments:GetBool() then
                        -- stencil code for cool effect
                        render.SetStencilWriteMask(0xFF)
                        render.SetStencilTestMask(0xFF)
                        render.SetStencilReferenceValue(0)
                        render.SetStencilPassOperation(STENCIL_KEEP)
                        render.SetStencilZFailOperation(STENCIL_KEEP)
                        render.ClearStencil()
                        render.SetStencilEnable(true)
                        render.SetStencilReferenceValue(1)
                        render.SetStencilCompareFunction(STENCIL_NEVER)
                        render.SetStencilFailOperation(STENCIL_REPLACE)
                        --  cool polygons for cool effect
                            for i = 0, MaxClip do
                                surface.SetDrawColor(255, 255, 255)
                                local w, h = ScrW(), ScrH()
                                local offset = math.Clamp(18-MaxClip/0.5, 1, 4)/2
                                surface.DrawPoly({
                                    {x = w + Arcd, y = h + Arcd},
                                    {x = math.cos(math.rad(-offset + i*89/MaxClip))*100  + w + Arcd, y = math.sin(math.rad(-offset + i*89/MaxClip))*100  + h + Arcd},
                                    {x = math.cos(math.rad(offset + i*89/MaxClip))*100  + w + Arcd, y = math.sin(math.rad(offset + i*89/MaxClip))*100  + h + Arcd},
                                })
                            end
                        render.SetStencilCompareFunction(STENCIL_NOTEQUAL)
                        render.SetStencilFailOperation(STENCIL_KEEP)
                            myarc()
                        render.SetStencilEnable(false)
                    else
                        myarc()
                    end

                    if AmmoNumbers:GetBool() or DrawAmmoReserve:GetBool() then
                        SRAlpha = Lerp(0.1, SRAlpha, ReloadAlpha)
                        local SRcolor = ColorAlpha(SColor, SRAlpha*255)
                        if CurClip-MaxClip == 1 and MaxClip>6 and AmmoNumbers:GetBool() then
                            draw.SimpleText(""..(math.Round(SClip)-1).." + 1", "ARXHUDFONT", w + 30 + Arcd, h + 5 + Arcd, SRcolor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
                        elseif MaxClip>6 and AmmoNumbers:GetBool() then
                            draw.SimpleText(""..math.Round(SClip), "ARXHUDFONT", w + 30 + Arcd, h + 5 + Arcd, SRcolor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
                        end
                        if DrawAmmoReserve:GetBool() and MaxClip>1 then
                            local Reserve = LocalPlayer():GetAmmoCount(Weapon:GetPrimaryAmmoType())
                            if Reserve>0 then
                                draw.SimpleText("/"..Reserve, "ARXHUDFONT", w + 30 + Arcd, h + 25 + Arcd, SRcolor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
                            end
                        end
                    end



                    if ReloadStyle:GetInt() == 1 then
                        AnimVal = math.Round(Lerp(0.08, AnimVal, (Reloading and 1 or 0)), 3)
                        ReloadColor2 = Color(ReloadR:GetInt(), ReloadG:GetInt(), ReloadB:GetInt(), 150)
                        if AnimVal then
                            draw.drawArc(w + Arcd, h + Arcd, 47, 360 - ViewModel:GetCycle()*87, 272, 7, 0 + AnimVal *5, TRBlack)
                            draw.drawArc(w + Arcd, h + Arcd, 47, 360 - ViewModel:GetCycle()*90, 360, 7, 0 + AnimVal *5, ReloadColor2)
                        end
                    elseif ReloadStyle:GetInt() == 2 then
                        if Reloading then
                            draw.drawArc(w + Arcd, h + Arcd, 40, 270 + ViewModel:GetCycle()*90, 360, 7, 5, SColor)
                        end
                    elseif ReloadStyle:GetInt() == 3 then
                        if Reloading then
                            ReloadColor2 = Color(ReloadR:GetInt(), ReloadG:GetInt(), ReloadB:GetInt(), 150)
                            local val = 360-SClip/MaxClip*90
                            draw.drawArc(w + Arcd, h + Arcd, 50, val, val + (270-val)*ViewModel:GetCycle(), 5, 3, ReloadColor2)
                        end
                    end
                    if Weapon:GetMaxClip1() == 1 and Weapon:GetPrimaryAmmoType()>0 and LocalPlayer():GetAmmoCount(Weapon:GetPrimaryAmmoType())>0 and DrawAmmoOnSingle:GetBool() then
                        draw.SimpleText(""..LocalPlayer():GetAmmoCount(Weapon:GetPrimaryAmmoType()), "HudNumbers", w + 40 + Arcd, h + 55 + Arcd, SColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
                    end
                elseif DrawAmmo:GetBool() then
                    if Weapon:GetPrimaryAmmoType()>0 and LocalPlayer():GetAmmoCount(Weapon:GetPrimaryAmmoType())>0 and DrawAmmoOnSingle:GetBool() and Weapon.Base ~= "arccw_base_melee" then
                        draw.SimpleText(""..LocalPlayer():GetAmmoCount(Weapon:GetPrimaryAmmoType()), "HudNumbers", w + 40 + Arcd, h + 55 + Arcd, SColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
                    end
                end
                if Weapon:GetSecondaryAmmoType()>0 and LocalPlayer():GetAmmoCount(Weapon:GetSecondaryAmmoType())>0 and DrawAmmoOnSingle:GetBool() then
                    draw.SimpleText(""..LocalPlayer():GetAmmoCount(Weapon:GetSecondaryAmmoType()), "HudNumbers", w + 40 + Arcd, h + 55 + Arcd, SColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
                end
            end
        end
    end
end)


hook.Add("EntityFireBullets", "darky_ammo_counter_fire", function (ply, data)
    if LocalPlayer():IsValid() then
        if LocalPlayer()==ply then
            local Weapon = LocalPlayer():GetActiveWeapon()
            if Weapon:IsValid() then
                local MaxClip = Weapon:GetMaxClip1()
                local CurClip = Weapon:Clip1()
                if MaxClip >=1 then
                    if CurClip <= MaxClip/4 and MaxClip>=10 then
                        if PrevClip == Weapon:Clip1() then return end
                        if ClickSoundOnLowAmmo:GetBool() then
                            surface.PlaySound("weapons/lowammo_01.wav") -- from cs:go
                        end
                        PrevClip = CurClip
                    end
                    if CurClip <= MaxClip/1.5 and MaxClip>=4 then
                        SColor = ColorAlpha(Color(ColorGradient(1-math.min(-0.2 + SClip/(MaxClip/1.5), 1), AmmoColorR:GetInt(), AmmoColorG:GetInt(), AmmoColorB:GetInt(), 255, 10, 0)), 255)
                    else
                        SColor = Color(AmmoColorR:GetInt(), AmmoColorG:GetInt(), AmmoColorB:GetInt())
                    end
                end
            end
        end
    end
end)

hook.Add("Think", "darky_amc_think", function()
    local LP = LocalPlayer()
    
    if LP:IsValid() then
        local Wep = LP:GetActiveWeapon()
        local HP = LP:Health()
        local AR = LP:Armor()
        if Wep:IsValid() and Wep~= LastWeapon then
            SClip = LocalPlayer():GetActiveWeapon():GetMaxClip1()
            Reloading = false
            LastWeapon = Wep
            ReloadAlpha = 1
            timer.Create("DarkyHP_AFK_3", 2, 1, function() ReloadAlpha = 0 end)
        end
        if HP ~= LastHP or AR ~= LastAR then
            if LastHP-HP>=3 or AR ~= LastAR then
                timer.Remove("DarkyHP_AFK_1")
                timer.Remove("DarkyHP_AFK_2")
                --print("hurt")
                HPState = 2
                timer.Create("DarkyHP_AFK_1", 30, 1, function() HPState = 1 end)
                timer.Create("DarkyHP_AFK_2", 90, 1, function() HPState = 0 end)
            elseif LastHP-HP<=-10 or LastAR-AR<=-5 then
                timer.Remove("DarkyHP_AFK_1")
                timer.Remove("DarkyHP_AFK_2")
                --print("heal")
                HPState = 2
                HPTextAlpha = 1
                timer.Create("DarkyHP_AFK_1", 5, 1, function() HPState = 1 end)
                timer.Create("DarkyHP_AFK_2", 15, 1, function() HPState = 0 end)
                timer.Create("DarkyHP_AFK_4", 3, 1, function() HPTextAlpha = 0 end)
            end
            LastHP = HP
            LastAR = AR
        end
    end
end)


hook.Add("OnContextMenuOpen", "darky_amc_c_wakeup", function()
    if WakeUpOnContext:GetBool() then
        timer.Remove("DarkyHP_AFK_1")
        timer.Remove("DarkyHP_AFK_2")
        HPState = 1
        HPTextAlpha = 1
        timer.Create("DarkyHP_AFK_4", 3, 1, function() HPTextAlpha = 0 end)
        timer.Create("DarkyHP_AFK_2", 20, 1, function() HPState = 0 end)
    end
end)

hook.Add("KeyPress", "darky_amc_keypress", function(ply, key)
    if WakeUpOnZoom:GetBool() and key == IN_ZOOM then
        timer.Remove("DarkyHP_AFK_1")
        timer.Remove("DarkyHP_AFK_2")
        HPState = 1
        HPTextAlpha = 1
        timer.Create("DarkyHP_AFK_4", 3, 1, function() HPTextAlpha = 0 end)
        timer.Create("DarkyHP_AFK_2", 20, 1, function() HPState = 0 end)
    end
    if HideOnWalk:GetBool() and key == IN_WALK then
        timer.Remove("DarkyHP_AFK_1")
        timer.Remove("DarkyHP_AFK_2")
        timer.Remove("DarkyHP_AFK_3")
        timer.Remove("DarkyHP_AFK_4")
        HPState = 0
        HPTextAlpha = 0
        ReloadAlpha = 0
    end
end)
--  We gonna recieve regeneration messages
net.Receive("regen_hp", function()
    if LocalPlayer():IsValid() then
        LocalPlayer().DHPRegen = net.ReadUInt(8)
    end
end)

local hide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudAmmo"] = true,
	["CHudSecondaryAmmo"] = true
}

hook.Add("HUDShouldDraw", "darky_arc_hide_hl2", function(name)
	if hide[name] and not DrawHud:GetBool() then
		return false
	end
end)