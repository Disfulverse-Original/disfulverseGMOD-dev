AddCSLuaFile()

print("cl_contextmenu")


local contextIsOpen = false
local mapp, mclamp = math.Approach, math.Clamp
local Vec001, Vec1 = Vector(0.001, 0.001, 0.001), Vector(1, 1, 1)
local td = {}
local tr

local ViewOffsetUp = 0
local ViewOffsetForward = 3
local ViewOffsetForward2 = 0
local ViewOffsetLeftRight = 0
local RollDependency = 0.1
local CurView = nil
local traceHit = false
local eyeAtt, forwardVec, FT, ply
local view = {}
local anglelimit, maxleft, maxright
local angletouseY, angletouseP

local vectormouse = Vector()
local AimAnglesLocalized = Angle()
local td2 = {}
local tr2
local inspectable = {
	"worldspawn",
	"player"
}

local function easedLerp(fraction, from, to)
	return Lerp(math.ease.InExpo(fraction), from, to)
end

--[[
hook.Add( "PopulateMenuBar", "RemoveTopBar", function()
end)
--]]

hook.Add("OnContextMenuOpen", "disful_context_hookdraw", function()
	if not IsValid(LocalPlayer()) then return end

	gui.EnableScreenClicker(true)
	--anglelimit = LocalPlayer():GetAimVector():Angle()
	--anglelimit:Normalize()
	--maxleft = math.Clamp(anglelimit.y + 90, 0, 180)
	--maxright = math.Clamp(anglelimit.y - 90, -180, 0)

	contextIsOpen = true 
end )
hook.Add("OnContextMenuClose", "disful_context_hookdraw", function() 
	if not IsValid(LocalPlayer()) then return end 
	contextIsOpen = false
	gui.EnableScreenClicker(false)
	CurView = nil
	cachedEntity = nil
end )

local FVec = Vector(0, 0, 0)

local function contextview( ply, pos, angles, fov )
	FT = FrameTime()
	forwardVec = ply:GetAimVector() -- now we need to make getaimvector not fuck the view cuz it takes some values that we are not supposed to even take
	EA = ply:EyeAngles()
	--print(EA)

	eyeAtt = ply:GetAttachment(ply:LookupAttachment("eyes"))
	if !contextIsOpen or not ply:Alive() then return end
	--print(ply:GetMouseX())
	--print(angles)
	--print("forwardVec are " .. "pitch " .. forwardVec:Angle().p .. " yaw " .. forwardVec:Angle().y .. " roll " .. forwardVec:Angle().r)
	--print("vector is " .. tostring(forwardVec))

	--local AimAnglesLocalized = forwardVec:Angle()
	--AimAnglesLocalized:Normalize()
	vectormouse = Vector( gui.ScreenToVector(input.GetCursorPos()) )
	AimAnglesLocalized = ( Angle(vectormouse:Angle()) )
	AimAnglesLocalized:Normalize()
	--print(AimAnglesLocalized)

	--print(ply:GetEyeTrace().Entity)

	angletouseP = math.Clamp(AimAnglesLocalized.p, -35, 80)
	--angletouseY = math.Clamp(AimAnglesLocalized.y, maxright, maxleft)
	--print(angletouseP)

	--td2.start = eyeAtt.Pos
	--td2.endpos = eyeAtt.Pos + vectormouse * 250

	--tr2 = util.TraceLine( td2 )
	--PrintTable(td2.filter)
	--print(tr2.Entity:IsWorld())
	--print( IsValid(tr2.Entity) and tr2.Entity:GetClass() or "nil")

	

	--print(maxleft .. " and right " .. maxright)
	--print("this is ui.ScreenToVector( gui.MouseX(), gui.MouseY() ):Angle() " .. tostring(AimAnglesLocalized) )

	if not CurView then
		CurView = angles
	else
		CurView.p = easedLerp(FT*5, CurView.p, angletouseP)
		--CurView.y = easedLerp(FT*3, CurView.y, AimAnglesLocalized.y)
		--print(CurView.p)
	end

	--ply:SetEyeAngles(CurView)

	--CurView = LerpAngle( math.Clamp(FT * (35 * (1 - 0.4)), CurView, angles) )
	
	--print("ANGLES " .. tostring(angles) )
	--print("AimAnglesLocalized " .. tostring(AimAnglesLocalized) )
	--print( math.Approach(angles.y, number goalweight)( AimAnglesLocalized )
	--angles.y = AimAnglesLocalized.y > 0 and math.Clamp(AimAnglesLocalized.y, 0, 145) or AimAnglesLocalized.y < 0 and math.Clamp(AimAnglesLocalized.y, -145, 0)

	if traceHit then LocalPlayer():ManipulateBoneScale(LocalPlayer():LookupBone("ValveBiped.Bip01_Head1"), Vec1) return end

	--print(math.Clamp(angles.y, maxleft, maxright))

	--print(CurView)

	--print("EyeAngles are " .. "pitch " .. EA.p .. " yaw " .. EA.y .. " roll " .. EA.r)
	--EA.p = math.Clamp(math.NormalizeAngle(forwardVec:Angle().p), 0, 65)
	--EA.y = math.Clamp(math.NormalizeAngle(forwardVec:Angle().y), -90, 90)
	--print(EA.p .. " and yaw " .. EA.y)
		
	ViewOffsetUp = mapp(ViewOffsetUp, mclamp(angletouseP * -0.1, 0, 10), 0.5)
	ViewOffsetForward = mapp(ViewOffsetForward, 2 + mclamp(angletouseP * 0.1, 0, 5), 0.5)
	RollDependency = Lerp(mclamp(FT * 15, 0, 1), RollDependency, 0.05)

	if eyeAtt then
		FVec.x = forwardVec.x * (ViewOffsetForward + ViewOffsetForward2) * 0.1
		FVec.y = forwardVec.y * (ViewOffsetForward + ViewOffsetForward2) * 0.1
		FVec.z = ViewOffsetUp
		FVec = FVec + ply:GetRight() * ViewOffsetLeftRight
		--print(FVec)
		view.origin = eyeAtt.Pos + FVec
		view.angles = CurView
		view.fov = fov
		view.znear = 0.4
		view.drawviewer = true
			
		return view
	end
end
hook.Add( "CalcView", "MyCalcView", contextview)

local function IFPP_Think()
	if !contextIsOpen then LocalPlayer():ManipulateBoneScale(LocalPlayer():LookupBone("ValveBiped.Bip01_Head1"), Vec1) return end

	ply = LocalPlayer()
	
	if not ply:Alive() then
		return
	end

	if contextIsOpen then
		ply:ManipulateBoneScale(ply:LookupBone("ValveBiped.Bip01_Head1"), Vec001)
	end

	if eyeAtt then
		forwardVec = ply:GetAimVector()
		forwardVec.z = 0 -- by getting only the X and Y values, I can get what's ahead of the player, and not up/down, because other methods seem to fail.
		
		td.start = eyeAtt.Pos
		td.endpos = td.start + forwardVec * 15
		td.filter = ply
		
		tr = util.TraceLine(td)
		
		if tr.Hit then
			traceHit = true
			--print( tostring(traceHit) .. " we got something")
		else
			traceHit = false
			--print( tostring(traceHit) .. " we got nothing")
		end
	end
end
hook.Add("Think", "IFPP_Think", IFPP_Think)


local color_whiteish = Color(245, 249, 255)
hook.Add( "PreDrawHalos", "AddPropHalos", function()

	if !contextIsOpen then return end

	vectormouse = Vector( gui.ScreenToVector(input.GetCursorPos()) )
	td2.start = eyeAtt.Pos
	td2.endpos = eyeAtt.Pos + vectormouse * 250

	tr2 = util.TraceLine( td2 )

	if !IsValid(tr2.Entity) or tr2.Entity:IsWorld() then return end

	local haloadd = {tr2.Entity}

	halo.Add( haloadd, color_whiteish, 1, 1, 2 )

end)

hook.Add( "PostDrawTranslucentRenderables", "MySuper3DRenderingHook", function()
	if !contextIsOpen then return end
	render.DrawLine( td2.start, td2.endpos, color_white, true )
end )

local cachedEntity = nil
local entityMenuPanel = nil
local maxDistance = 260 -- Set the maximum allowable distance

hook.Add("GUIMousePressed", "PropertiesClick_dis", function(code, vector)
    if not contextIsOpen then return end

    if code == MOUSE_RIGHT and not input.IsButtonDown(MOUSE_LEFT) then
        entityMenuPanel = properties.OpenEntityMenu(tr2.Entity, vectormouse)
        cachedEntity = tr2.Entity
    end
end)

hook.Add("Think", "CloseMenuOnDistance", function()
    if not contextIsOpen or not IsValid(entityMenuPanel) then return end
    if not IsValid(cachedEntity) then return end

    local playerPos = LocalPlayer():GetPos()
    local entityPos = cachedEntity:GetPos()
    local distance = playerPos:Distance(entityPos)

    if distance > maxDistance then
        entityMenuPanel:Remove()
        entityMenuPanel = nil
        cachedEntity = nil
    end
end)




