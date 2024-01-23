
AddCSLuaFile()

SWEP.PrintName				= "Revival Tool"
SWEP.Author					= "A1steaksa"
SWEP.Purpose			= "Bring fresh bodies back to life"

SWEP.Slot					= 2
SWEP.SlotPos				= 3

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.ViewModel				= Model( "models/weapons/c_medkit.mdl" )
SWEP.WorldModel				= Model( "models/weapons/w_medkit.mdl" )
SWEP.ViewModelFOV			= 54
SWEP.UseHands				= true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

local HealSound = Sound( "HealthKit.Touch" )
local DenySound = Sound( "WallHealth.Deny" )
local reviveDistance = 190

function SWEP:Initialize()

	self:SetHoldType( "slam" )

	if ( CLIENT ) then return end

end

function SWEP:PrimaryAttack()
	if ( CLIENT ) then return end
	if not self:GetNextPrimaryFire() then return end
	local tr = self:GetOwner():GetEyeTrace()
		
	if ( IsValid( tr.Entity ) and tr.Entity:GetClass() == "prop_ragdoll"  and tr.Entity:GetPos():Distance( self:GetOwner():GetPos() ) <= reviveDistance ) then
	
		if SERVER then
			if IsValid( tr.Entity.BodyOf ) then
				local rev = tr.Entity.BodyOf:revive()
				
				if rev then
					self:GetOwner():EmitSound( HealSound )
					self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
				else
					self:GetOwner():ChatPrint( "Выбранный человек уже мертв." )
					self:GetOwner():EmitSound( DenySound )
				end
			end
		end
	
	end
	self:SetNextPrimaryFire( CurTime() + 1 )
end

function SWEP:SecondaryAttack()
	return
end

function SWEP:CustomAmmoDisplay()

	self.AmmoDisplay = self.AmmoDisplay or {} 
	self.AmmoDisplay.Draw = false
	self.AmmoDisplay.PrimaryClip = self:Clip1()

	return self.AmmoDisplay

end
