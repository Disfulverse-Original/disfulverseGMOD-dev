/*
    Addon id: 08ee2233-2d73-4598-a636-76adb93194f5
    Version: v2.1.6 (stable)
*/

AddCSLuaFile()
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198402768796 */

SWEP.PrintName = AAS.SwepName
SWEP.Category = "Advanced Accessory System"
SWEP.Author = "Kobralost"
SWEP.Purpose = ""

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.HoldType = "pistol"
SWEP.WorldModel = ""

SWEP.AnimPrefix	 = "pistol"
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* bd51170ee3a15f0e8d5e6b12ded39977f6a3f8896bd2c58844ad6ead73ef34eb */

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198402768796 */
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198402768773 */

SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 0fd22f1243f0001f31e3d159f2ecd1adb4d5513bd78688f3c34a090a154e38c5

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

function SWEP:PrimaryAttack()
	if CLIENT then
		if AAS.BuyItemWithSwep then
			AAS.ItemMenu()
		else
			AAS.InventoryMenu(true)
		end
	end
end

function SWEP:SecondaryAttack()
	if CLIENT then
		if AAS.BuyItemWithSwep then
			AAS.ItemMenu()
		else
			AAS.InventoryMenu(true)
		end
	end
end

function SWEP:CanPrimaryAttack() end
function SWEP:CanSecondaryAttack() end

function SWEP:Initialize() self:SetHoldType("pistol") end
function SWEP:DrawWorldModel() end
function SWEP:PreDrawViewModel() return true end
