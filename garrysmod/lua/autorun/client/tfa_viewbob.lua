local ViewBobTime = 0
local ViewBobIntensity = 1
local BobEyeFocus = 512
local rateScaleFac = math.pi
local rate_up = 4 * rateScaleFac
local scale_up = 0.3
local rate_right = 2 * rateScaleFac
local scale_right = 0.3
local LastCalcViewBob = 0
local sv_cheats_cv = GetConVar("sv_cheats")
local host_timescale_cv = GetConVar("host_timescale")
local AngularCompensation = 1
local MinimumFocus = 128
local cv_intensity = CreateClientConVar("cl_cbob_intensity", "1", true, false, "Intensity of cBobbing viewbob.")
local cv_comp = CreateClientConVar("cl_cbob_compensation", "1", true, false, "Intensity of cBobbing angular compensation.")

local function Viewbob(pos, ang, time, intensity)
	local ply = GetViewEntity()
	if not IsValid(ply) then return end
	if not ply:IsPlayer() then return end
	local eang = ply:EyeAngles()
	local up = eang:Up()
	local ri = eang:Right()
	local opos = pos * 1
	local tr = ply:GetEyeTraceNoCursor()
	if not tr then return end
	if not tr.HitPos then return end
	local ldist = tr.HitPos:Distance(pos)
	local delta = math.min(SysTime() - LastCalcViewBob, FrameTime(), 1 / 30)

	if sv_cheats_cv:GetBool() then
		delta = delta * host_timescale_cv:GetFloat()
	end
	if ply:GetMoveType() == MOVETYPE_LADDER then ri = Vector() end
	delta = delta * game.GetTimeScale()
	LastCalcViewBob = SysTime()

	if ldist <= 0 then
		local e = ply:GetEyeTraceNoCursor().Entity

		if not (IsValid(e) and not e:IsWorld()) then
			e = nil
		end

		ldist = util.QuickTrace(pos, eang:Forward() * 999999, {ply, e}).HitPos:Distance(pos)
	end

	ldist = math.max(ldist, MinimumFocus)
	BobEyeFocus = math.Approach(BobEyeFocus, ldist, (ldist - BobEyeFocus) * delta * 5)
	pos:Add(up * math.sin((time + 0.5) * rate_up) * scale_up * intensity * -7)
	pos:Add(ri * math.sin((time + 0.5) * rate_right) * scale_right * intensity * -7)
	local tpos = opos + BobEyeFocus * eang:Forward()
	local oang = eang * 1
	local nang = (tpos - pos):GetNormalized():Angle()
	eang:Normalize()
	nang:Normalize()
	local vfac = math.Clamp(1 - math.pow(math.abs(oang.p) / 90, 3), 0, 1) * (math.Clamp(ldist / 196, 0, 1) * 0.7 + 0.3) * AngularCompensation * cv_comp:GetFloat() / 2
	ang.y = ang.y - math.Clamp(math.AngleDifference(eang.y, nang.y), -2, 2) * vfac
	ang.p = ang.p - math.Clamp(math.AngleDifference(eang.p, nang.p), -2, 2) * vfac

	return pos, ang
end

local function AirWalkScale(ply)
	return ply:IsOnGround() and ply:Alive() and 1 or 0.2
end

hook.Add("PreRender", "TFA_Viewbob_Delta", function()
	local ply = GetViewEntity()
	if not IsValid(ply) then return end
	if not ply:IsPlayer() then return end
	if ply:InVehicle() then return end
	local rawVel = ply:GetVelocity()
	local velocity = math.max(rawVel:Length2D() * AirWalkScale(ply) - rawVel.z * 0.5, 0)
	local rate = math.Clamp(math.sqrt(velocity / ply:GetRunSpeed()) * 1.75, 0.15, 2)
	ViewBobTime = ViewBobTime + FrameTime() * rate * .9
	ViewBobIntensity = 0.15 + velocity / ply:GetRunSpeed()
end)

local ISCALC = false

hook.Add("CalcView", "TFA_Viewbob", function(ply, pos, ang, ...)
	if ISCALC or (IsValid(ply) and (ply:InVehicle() or not ply:Alive())) or cv_intensity:GetFloat() == 0 then return end
	ISCALC = true
	local tmptbl = hook.Run("CalcView", ply, pos, ang, ...) or {}
	ISCALC = false
	tmptbl.origin = tmptbl.origin or pos
	tmptbl.angles = tmptbl.angles or ang
	tmptbl.fov = tmptbl.fov or fov
	tmptbl.origin, tmptbl.angles = Viewbob(tmptbl.origin, tmptbl.angles, ViewBobTime, ViewBobIntensity * cv_intensity:GetFloat()* 0.75)

	return tmptbl
end)

local ISCALCVM = false

hook.Add("CalcViewModelView", "TFA_Viewbob", function(wep, vm, oPos, oAng, pos, ang, ...)
	if ISCALCVM or cv_intensity:GetFloat() == 0 then return end
	ISCALCVM = true
	local tPos, tAng = hook.Run("CalcViewModelView", wep, vm, oPos, oAng, pos, ang, ...)
	ISCALCVM = false
	pos = tPos or pos
	ang = tAng or ang
	pos, ang = Viewbob(pos, ang, ViewBobTime, ViewBobIntensity * cv_intensity:GetFloat())

	return pos, ang
end)

-- Function to detect movement direction based on velocity
--[[
local function DetectMovementDirection(velocity)
    local movementDirection = "none"

    -- Determine movement direction based on velocity
    --local forwardVelocity = velocity:Dot(Vector(1, 0, 0)) -- Check velocity along player's forward direction
    local rightVelocity = velocity:Dot(Vector(0, 1, 0)) -- Check velocity along player's right direction

    -- Set movement direction based on velocity components
    if rightVelocity < 0 then
        movementDirection = "right"
    elseif rightVelocity > 0 then
        movementDirection = "left"
    end

    return movementDirection
end

-- Hook to calculate view bobbing and detect movement direction
hook.Add("Think", "DetectPlayerMovementDirection", function()
    local ply = LocalPlayer()
    if not IsValid(ply) or not ply:Alive() then
        return
    end

    local velocity = ply:GetVelocity()
    if velocity == 0 then return end
    local movementDirection = DetectMovementDirection(velocity)

    -- Print the detected movement direction
    if movementDirection == "right" then

		ply:SetCurrentViewOffset( Vector(0, 1, 25) )

    end
    if movementDirection ~= "none" then
        print("Player is moving " .. movementDirection)
    else
        print("Player is not moving")
    end
end)
--]]


