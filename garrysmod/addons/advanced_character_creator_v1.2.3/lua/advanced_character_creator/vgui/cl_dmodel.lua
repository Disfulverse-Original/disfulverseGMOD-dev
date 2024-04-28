--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

/*
    Addon id: 00690769-9ce4-49c1-bc5f-802f53225f58
    Version: v1.2.3 (stable)
*/

local PANEL = {}

function PANEL:Init()
    self.ACC2Zoom = true
    self.ACC2CanRotate = true
    self.ACC2FocusEnt = nil
    self.ACC2LerpFOV = 43
    self.ACC2FOVBase = 43
    self.ACC2LerpVector = ACC2.Constants["vectorOrigin"]
    self.ACC2Vector = ACC2.Constants["vectorOrigin"]
    self.ACC2StartAng = 0
    self.MinMaxLerp = {0, 0}
    self.IgnoreZ = false
end

function PANEL:Zoom()
    self.ACC2Zoom = !self.ACC2Zoom
end

function PANEL:CanRotateCamera(bool)
    self.ACC2CanRotate = bool
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- e76c9cbfd4851f046d135a3807c90610912e0963b3302ca13880769302aa4101

function PANEL:SetFocusEntity(ent)
    self.ACC2FocusEnt = ent
end

function PANEL:ACC2SetFOV(number)
    self.ACC2FOV = number
end

function PANEL:ACC2SetFOVBase(number)
    self.ACC2FOVBase = number
    self.ACC2LerpFOV = number
end

function PANEL:ACC2SetIgnoreZ(bool)
    self.IgnoreZ = bool
end

function PANEL:PreDrawModel(ent)
    if not self.IgnoreZ then return end

    cam.IgnoreZ(true)
    return true
end

function PANEL:PostDrawModel(ent)
    cam.IgnoreZ(false)
end

function PANEL:Think()
    if isnumber(self.ACC2FOV) then
        self.ACC2LerpFOV = Lerp(FrameTime()*3, self.ACC2LerpFOV, self.ACC2FOV)
        self:SetFOV(self.ACC2LerpFOV)
    end

    if isvector(self.ACC2Vector) then
        self.ACC2LerpVector = LerpVector(FrameTime()*3, self.ACC2LerpVector, self.ACC2Vector)
    end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- f7fd1fca3ccaab2e1a41a243c7c9e204241772fcea4df32223d2f6203cc38823
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* e76c9cbfd4851f046d135a3807c90610912e0963b3302ca13880769302aa4101 */

    if not self:IsHovered() && not isnumber(self.ACC2StartAng) or not IsValid(self.ACC2FocusEnt) then return end

    local CurX, CurY = self:ScreenToLocal(gui.MouseX(), gui.MouseY())
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- c1e813f17deb1a62965eca6e9ba2b60aeb690b46a55b07d54ea18ee0c7b23980

    if input.IsMouseDown(MOUSE_LEFT) && self.ACC2CanRotate then
        if not isnumber(self.ACC2StartAng) then self.ACC2StartAng = CurX end
        
        local ang = self.ACC2FocusEnt:GetAngles()
        local newAng = ang.yaw-((self.ACC2StartAng-CurX)/self:GetWide())*2
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 482c562e67c7127e3b68e63eb0de779cb19814da22ab42eae52a7d3451fc844a
        
        self.ACC2FocusEnt:SetAngles(Angle(ang.pitch, newAng, ang.roll))

    else
        self.ACC2StartAng = nil
    end
end

function PANEL:Paint(w, h)
	if not IsValid(self.Entity) then return end

	local x, y = self:LocalToScreen(0, 0)

	self:LayoutEntity(self.Entity)

	local ang = self.aLookAngle
	if not ang then
		ang = (self.vLookatPos - self.vCamPos):Angle()
	end

	cam.Start3D(self.vCamPos + self.vCamPos:Angle():Right() * math.Clamp(x, -999, 0)/12, ang, self.fFOV, math.max(x, 0), y, w, h, 5, self.FarZ)
        render.SuppressEngineLighting(true)
        render.SetLightingOrigin(self.Entity:GetPos())
        render.ResetModelLighting(self.colAmbientLight.r/255, self.colAmbientLight.g/255, self.colAmbientLight.b/255)
        render.SetColorModulation(self.colColor.r/255, self.colColor.g/255, self.colColor.b/255)
        render.SetBlend((self:GetAlpha()/255)*(self.colColor.a/255))

        for i=0, 6 do
            local col = self.DirectionalLight[i]
            if col then
                render.SetModelLighting(i, col.r/255, col.g/255, col.b/255)
            end
        end

        self:DrawModel()
        render.SuppressEngineLighting(false)
    cam.End3D()

	self.LastPaint = RealTime()
end

function PANEL:LayoutEntity()
    return
end

function PANEL:DoClick()
    self.ACC2StartAng = self.Entity:GetAngles().yaw
end

derma.DefineControl("ACC2:DModel", "ACC2 DModel", PANEL, "DModelPanel")


--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
