AddCSLuaFile()

SWEP.PrintName = "NPC Admin Tool"
SWEP.Author = "Slawer"

SWEP.Category = "Slawer | Jobs"

SWEP.DrawAmmo = false
SWEP.Base = "weapon_base"
SWEP.Spawnable = true
SWEP.ViewModel			= "models/weapons/c_pistol.mdl"
SWEP.WorldModel			= "models/weapons/w_pistol.mdl"
SWEP.ViewModelFOV = 75
SWEP.Slot = 0
SWEP.SlotPos = 4

SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
    if CLIENT then
        Slawer.Jobs:GenerateFonts()
    end
end

function SWEP:PrimaryAttack()
    if CLIENT then return end
    if not self.Owner:IsSuperAdmin() then return end

    local eTarget = self.Owner:GetEyeTrace().Entity

    if IsValid(eTarget) or eTarget:GetClass() == "slawer_jobs_npc" then return end

    local vPos = self.Owner:GetEyeTrace().HitPos
    local aAng = Angle(0, self.Owner:GetAngles().y - 180, 0)

    Slawer.Jobs:CreateNPCJobs(vPos, aAng)

    self:SetNextPrimaryFire(CurTime() + 1)
end

function SWEP:SecondaryAttack()
    if CLIENT then return end
    if not self.Owner:IsSuperAdmin() then return end

    self:SetNextSecondaryFire(CurTime() + 1)

    local eTarget = self.Owner:GetEyeTrace().Entity

    if IsValid(eTarget) and eTarget:GetClass() == "slawer_jobs_npc" then
        // Jobs NPC
        Slawer.Jobs:NetStart("OpenNPCEdit", {
            sName = eTarget.sName,
            tJobs = eTarget.tJobs,
        }, self.Owner)
    end
end

function SWEP:Think()
    if CLIENT then return end
    if not self.Owner:IsSuperAdmin() then
        self.Owner:StripWeapon("slawer_jobs_admin_tool")
    end
end

local xGradient = Material("gui/gradient")

function SWEP:DrawTextIconIndication(iX, iY, xIcon, sText)
    draw.SimpleText(sText, "Slawer.Jobs:B30", iX + 2, iY + 2, color_black, 1, 1)
    draw.SimpleText(sText, "Slawer.Jobs:B30", iX, iY, color_white, 1, 1)
end

function SWEP:DrawHUD()
    local eEye = LocalPlayer():GetEyeTrace().Entity

    if not eEye or not IsValid(eEye) then
        self:DrawTextIconIndication(ScrW() * 0.5, ScrH() * 0.06, xLeft, Slawer.Jobs:L("leftAdminTool"))
    else
        if eEye:GetClass() == "slawer_jobs_npc" then
            self:DrawTextIconIndication(ScrW() * 0.5, ScrH() * 0.06, xLeft, Slawer.Jobs:L("rightAdminTool"))
        end
    end
end