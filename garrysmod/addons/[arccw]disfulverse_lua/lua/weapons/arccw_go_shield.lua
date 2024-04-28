SWEP.Base = "arccw_base_melee"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - GSO (Gear)" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "Ballistic Shield"
SWEP.Trivia_Class = "Shield"
SWEP.Trivia_Desc = "Anti-ballistic shield for police entry teams. Stops bullets. Riot shields are made of flimsy plastic and designed to stop rocks and bricks, not bullets. This is a ballistic shield. Do not call it a riot shield."
SWEP.Trivia_Manufacturer = "Security Pro USA"
SWEP.Trivia_Calibre = "N/A"
SWEP.Trivia_Mechanism = "Steel-Aramid Composite"
SWEP.Trivia_Country = "USA"
SWEP.Trivia_Year = 2009

SWEP.Slot = 5
SWEP.SlotPos = 0
SWEP.NotForNPCs = true

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/arccw_go/v_shield.mdl"
SWEP.WorldModel = "models/weapons/arccw_go/v_shield.mdl"
SWEP.ViewModelFOV = 60

SWEP.WorldModelOffset = {
    pos = Vector(0, 15, -12),
    ang = Angle(0, 0, 180 - 15)
}

SWEP.ShieldProps = {
    {
        Model = "models/weapons/arccw_go/v_shield.mdl",
        Pos = Vector(0, -15, -12),
        Ang = Angle(0, 0, 180 - 15),
        Resistance = 100 -- basically nothing can go through the shield
    }
}

SWEP.PrimaryBash = true

SWEP.SpeedMult = 0.85

SWEP.MeleeDamage = 35
SWEP.MeleeRange = 32
SWEP.MeleeDamageType = DMG_CLUB
SWEP.MeleeTime = 1
SWEP.MeleeGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE
SWEP.MeleeAttackTime = 0

SWEP.MeleeSwingSound = {
    "arccw_go/shield/shield_push_01.wav",
}
SWEP.MeleeHitSound = {
    "physics/metal/metal_barrel_impact_hard7.wav",
}
SWEP.MeleeHitNPCSound = {
    "physics/body/body_medium_break3.wav",
}

SWEP.Firemodes = {
    {
        Mode = 1,
        PrintName = "MELEE"
    },
}

SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "melee2"

SWEP.Primary.ClipSize = -1

SWEP.Animations = {
    ["draw"] = {
        Source = "deploy",
    },
    -- ["idle"] = {
    --     Source = {"idle1", "idle2"}
    -- },
    ["idle"] = {
        Source = "idle",
    },
    ["bash"] = {
        Source = "bash",
        Time = 2,
    },
}

SWEP.IronSightStruct = false

SWEP.ActivePos = Vector(0, 0, 3)

SWEP.BashPreparePos = Vector(0, 0, 0)
SWEP.BashPrepareAng = Angle(0, 5, 0)

SWEP.CustomizePos = Vector(15, 5, 0)
SWEP.CustomizeAng = Angle(0, 60, 0)

SWEP.BashPos = Vector(0, 0, 0)
SWEP.BashAng = Angle(10, -10, 0)

SWEP.HolsterPos = Vector(0, -1, 2)
SWEP.HolsterAng = Angle(-15, 0, 0)

sound.Add({
    name = "ARCCW_GO_SHIELD.ShieldEquipStart",
    channel = 16,
    volume = 1.0,
    sound = "arccw_go/shield/shield_equip_04.wav"
})

sound.Add({
    name = "ARCCW_GO_SHIELD.ShieldEquipEnd",
    channel = 16,
    volume = 1.0,
    sound = "arccw_go/shield/shield_equip_05.wav"
})