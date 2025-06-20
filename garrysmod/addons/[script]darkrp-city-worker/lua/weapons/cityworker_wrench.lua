SWEP.PrintName              = "Гаечный ключ"
SWEP.Author                 = "Silhouhat"
SWEP.Purpose                = "City Worker"
SWEP.Instructions           = "LMB to tighten leak"

SWEP.Category               = "City Worker"
SWEP.Spawnable              = false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo		    = "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		    = "none"

SWEP.Weight			        = 5
SWEP.AutoSwitchTo		    = false
SWEP.AutoSwitchFrom		    = false

SWEP.Slot			        = 2
SWEP.SlotPos			    = 3
SWEP.DrawAmmo			    = false
SWEP.DrawCrosshair		    = true

SWEP.ViewModel			    = "models/props_c17/tools_wrench01a.mdl"
SWEP.WorldModel			    = "models/props_c17/tools_wrench01a.mdl"

function SWEP:Initialize()
    self:SetHoldType( "melee" )
end

function SWEP:PrimaryAttack()
    if CLIENT then return end
    if not IsFirstTimePredicted() then return end

    self:SetNextPrimaryFire( CurTime() + 1 )

    local ent = self.Owner:GetEyeTrace().Entity
    if not IsValid( ent ) then return end
    if ent:GetClass() == "cityworker_leak" or ( ent:GetClass() == "cityworker_hydrant" and ent:GetLeaking() ) then 
        if ent:GetPos():Distance( self.Owner:GetPos() ) > 200 then return end

        CITYWORKER.Begin( self.Owner, ent ) 
    end
end

function SWEP:SecondaryAttack()
    return
end

function SWEP:Reload()
    return
end

function SWEP:DrawWorldModel()
    if not IsValid( self.Owner ) then return end

    local pos, ang = self.Owner:GetBonePosition( self.Owner:LookupBone( "ValveBiped.Bip01_R_Hand" ) )
    local offsetPos = ang:Right() * 1 + ang:Forward() * 3 + ang:Up() * -2

    ang:RotateAroundAxis( ang:Right(), 0 )
    ang:RotateAroundAxis( ang:Forward(), 90 )
    ang:RotateAroundAxis( ang:Up(), 180 )

    self:SetRenderOrigin( pos + offsetPos )
    self:SetRenderAngles( ang )

    self:DrawModel()
end

function SWEP:GetViewModelPosition( pos, ang )
    pos = pos + ang:Right() * 9 + ang:Forward() * 18 + ang:Up() * -9

    ang:RotateAroundAxis( ang:Right(), 90 )
    ang:RotateAroundAxis( ang:Up(), -90 )

    return pos, ang
end