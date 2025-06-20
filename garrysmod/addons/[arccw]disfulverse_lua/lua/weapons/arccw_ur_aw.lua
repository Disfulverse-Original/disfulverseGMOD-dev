SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Urban Coalition" -- edit this if you like
SWEP.UC_CategoryPack = "2Urban Renewal"
SWEP.AdminOnly = false

SWEP.PrintName = "AWP"

SWEP.Trivia_Class = "Sniper Rifle"
SWEP.Trivia_Desc = "A heavy rifle purpose-built for extreme range combat under extreme climates, first developed for the British military but quickly adopted by many more. Iconic for its appearance among military and police marksmen, this rifle is a symbol of discipline and order.\n\nOffers outstanding precision and kill potential, but its long bolt pull and reload time can become a hinderance outside its ideal engagement range.\n\nOne shot. One kill. You know the routine."
SWEP.Trivia_Manufacturer = "Accuracy International"
SWEP.Trivia_Calibre = "7.62x51mm NATO"
SWEP.Trivia_Mechanism = "Bolt Action"
SWEP.Trivia_Country = "United Kingdom"
SWEP.Trivia_Year = 1982

if !GetConVar("arccw_truenames"):GetBool() then
    SWEP.PrintName = "Apex Precision"
    SWEP.Trivia_Manufacturer = "Marksman Institute"
end


SWEP.Slot = 0
SWEP.CamAttachment = 3

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/arccw/c_ur_aw.mdl"
SWEP.WorldModel = "models/weapons/arccw/c_ur_aw.mdl"
SWEP.ViewModelFOV = 70

SWEP.DefaultBodygroups = "000000000000"

SWEP.BulletBones = {
    --[1] = "top_round",
    [2] = "mag_round",
}

-- Damage --

SWEP.Damage = 80 -- 2 shot close range
SWEP.DamageMin = 50 -- 2 shot long range
SWEP.RangeMin = 100
SWEP.Range = 400 -- 2 shot at ~300m

SWEP.Penetration = 18
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil
SWEP.MuzzleVelocity = 850
SWEP.PhysBulletMuzzleVelocity = 850

SWEP.BodyDamageMults = ArcCW.UC.BodyDamageMults

-- Mag size --

SWEP.ChamberSize = 1
SWEP.Primary.ClipSize = 5
SWEP.ExtendedClipSize = 10
SWEP.ReducedClipSize = 5

-- Recoil --

SWEP.Recoil = 1.75
SWEP.RecoilSide = 0.75

SWEP.RecoilRise = 0.6
SWEP.RecoilPunch = 0.3
SWEP.VisualRecoilMult = 5
SWEP.MaxRecoilBlowback = 4
SWEP.MaxRecoilPunch = 4
SWEP.RecoilPunchBack = 3
SWEP.RecoilPunchBackMax = 3.5
SWEP.RecoilPunchBackMaxSights = 2.5

SWEP.Sway = 0.2

-- Firerate / Firemodes --

SWEP.Delay = 60 / 80
SWEP.Num = 1
SWEP.Firemodes = {
    {
        PrintName = "fcg.bolt",
        Mode = 1,
    },
    {
        Mode = 0,
    },
}

SWEP.ShootPitch = 100
SWEP.ShootVol = 120

SWEP.ProceduralRegularFire = false
SWEP.ProceduralIronFire = false

SWEP.ReloadInSights = true

-- NPC --

SWEP.NPCWeaponType = "weapon_crossbow"
SWEP.NPCWeight = 60

-- Accuracy --

SWEP.AccuracyMOA = .25
SWEP.HipDispersion = 1250
SWEP.MoveDispersion = 500
SWEP.JumpDispersion = 700 -- tactical unrealism    set to 700 later

SWEP.Primary.Ammo = "SniperPenetratedRound"
SWEP.MagID = "awp"

SWEP.HeatCapacity = 75
SWEP.HeatDissipation = 15
SWEP.HeatDelayTime = 3

-- SWEP.Malfunction = true
SWEP.MalfunctionMean = 200
--SWEP.MeleeTime = 1.5

-- Speed multipliers --

SWEP.SpeedMult = 0.8
SWEP.SightedSpeedMult = 0.625
SWEP.SightTime = 0.35
SWEP.ShootSpeedMult = 0.625

local path = ")weapons/arccw_ur/ak/"

local testpath = ")weapons/arccw_ur/aw_placeholders/"
local path1 = ")weapons/arccw_ur/aw_placeholders/338/"

local path1 = ")weapons/arccw_ur/mp5/"
local common = ")/arccw_uc/common/"
local rottle = {common .. "cloth_1.ogg", common .. "cloth_2.ogg", common .. "cloth_3.ogg", common .. "cloth_4.ogg", common .. "cloth_6.ogg", common .. "rattle.ogg"}
local ratel = {common .. "rattle1.ogg", common .. "rattle2.ogg", common .. "rattle3.ogg"}
local rutle = {common .. "movement-sniper-03.ogg",common .. "movement-sniper-04.ogg"}

SWEP.ShootSound = {
    testpath .. "fire-01.ogg",
    testpath .. "fire-02.ogg",
    testpath .. "fire-03.ogg",
    testpath .. "fire-04.ogg",
    testpath .. "fire-05.ogg",
    testpath .. "fire-06.ogg"
}
SWEP.ShootSoundSilenced = {
    testpath .. "fire-sup-01.ogg",
    testpath .. "fire-sup-02.ogg",
    testpath .. "fire-sup-03.ogg",
    testpath .. "fire-sup-04.ogg",
    testpath .. "fire-sup-05.ogg",
    testpath .. "fire-sup-06.ogg"
}
SWEP.DistantShootSound = nil
SWEP.DistantShootSoundSilenced = nil
SWEP.ShootDrySound = testpath .. "dryfire.ogg"

local tail = ")/arccw_uc/common/308/"

SWEP.DistantShootSoundOutdoors = {
    tail .. "fire-dist-308-rif-ext-01.ogg",
    tail .. "fire-dist-308-rif-ext-02.ogg",
    tail .. "fire-dist-308-rif-ext-03.ogg",
    tail .. "fire-dist-308-rif-ext-04.ogg",
    tail .. "fire-dist-308-rif-ext-05.ogg",
    tail .. "fire-dist-308-rif-ext-06.ogg"
}
SWEP.DistantShootSoundIndoors = {
    common .. "fire-dist-int-shotgun-01.ogg",
    common .. "fire-dist-int-shotgun-02.ogg",
    common .. "fire-dist-int-shotgun-03.ogg",
    common .. "fire-dist-int-shotgun-04.ogg",
    common .. "fire-dist-int-shotgun-05.ogg",
    common .. "fire-dist-int-shotgun-06.ogg"
}
SWEP.DistantShootSoundOutdoorsSilenced = {
    common .. "sup-tail-01.ogg",
    common .. "sup-tail-02.ogg",
    common .. "sup-tail-03.ogg",
    common .. "sup-tail-04.ogg",
    common .. "sup-tail-05.ogg",
    common .. "sup-tail-06.ogg",
    common .. "sup-tail-07.ogg",
    common .. "sup-tail-08.ogg",
    common .. "sup-tail-09.ogg",
    common .. "sup-tail-10.ogg"
}
SWEP.DistantShootSoundIndoorsSilenced = {
    common .. "fire-dist-int-pistol-light-01.ogg",
    common .. "fire-dist-int-pistol-light-02.ogg",
    common .. "fire-dist-int-pistol-light-03.ogg",
    common .. "fire-dist-int-pistol-light-04.ogg",
    common .. "fire-dist-int-pistol-light-05.ogg",
    common .. "fire-dist-int-pistol-light-06.ogg"
}
SWEP.DistantShootSoundOutdoorsVolume = 1
SWEP.DistantShootSoundIndoorsVolume = 1
SWEP.Hook_AddShootSound = ArcCW.UC.InnyOuty

SWEP.MuzzleEffect = "muzzleflash_ak47"
SWEP.ShellEffect = "arccw_uc_shelleffect"
SWEP.ShellModel = "models/weapons/arccw/uc_shells/556x45.mdl"
SWEP.ShellPitch = 90
SWEP.ShellScale = 1.145
SWEP.ShellRotateAngle = Angle(0, 0, 0)

SWEP.ManualAction = true
-- SWEP.ManualAction = false
SWEP.NoLastCycle = true

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.IronSightStruct = {
    Pos = Vector(-3.37, -5, 0.68),
    Ang = Angle(0, 0, 2),
    Magnification = 1.1,
    SwitchToSound = "", -- sound that plays when switching to this sight
    CrosshairInSights = false
}
SWEP.LaserOffsetAngle = Angle(0, 0, 0)
SWEP.LaserIronsAngle = Angle(0, 1.5, 0)

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "rpg"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

SWEP.ActivePos = Vector(-0.1, 0.1, 0.2)
SWEP.ActiveAng = Angle(0, 0, -1)

SWEP.SprintPos = Vector(-1, -1, 1.2)
SWEP.SprintAng = Angle(-15, 8, -10)

SWEP.CrouchPos = Vector(-2, -2, -0.8)
SWEP.CrouchAng = Angle(0, 0, -14)

SWEP.HolsterPos = Vector(-1, -1, 1.2)
SWEP.HolsterAng = Angle(-15, 8, -10)

SWEP.BarrelOffsetSighted = Vector(0, 0, 0)
SWEP.BarrelOffsetHip = Vector(0, 0, 0)

SWEP.CustomizePos = Vector(0, 0, 0)
SWEP.CustomizeAng = Angle(0, 0, 0)

-- SWEP.CustomizePos = Vector(6.5, 0.8, -0.2)
-- SWEP.CustomizeAng = Angle(8, 18, 15)

SWEP.BarrelLength = 54

SWEP.AttachmentElements = {
    ["barrel_long"] = {
        VMBodygroups = {{ind = 2, bg = 1}},
        AttPosMods = {[3] = {
            vpos = Vector(0, 40, 1.75),
            vang = Angle(0, 270, 0),
        }}
    },
    ["barrel_short"] = {
        VMBodygroups = {{ind = 2, bg = 2}},
        AttPosMods = {[3] = {
            vpos = Vector(0, 28, 1.75),
            vang = Angle(0, 270, 0),
        }}
    },
    ["barrel_sd"] = {
        VMBodygroups = {{ind = 2, bg = 3}}
    },

    ["mag_338"] = {
        --VMBodygroups = {{ind = 3, bg = 2}}
    },
    ["mag_300"] = {
        --VMBodygroups = {{ind = 3, bg = 2}}
    },
    ["mag_ext"] = {
        --VMBodygroups = {{ind = 3, bg = 1}}
    },
    ["mag_ext_magnum"] = {
        --VMBodygroups = {{ind = 3, bg = 3}}
    },

    ["rail_bottom"] = {
        VMBodygroups = {{ind = 6, bg = 1}}
    },
    ["rail_top"] = {
        VMBodygroups = {{ind = 7, bg = 1}}
    },
    ["sights_compact"] = {
        VMBodygroups = {{ind = 8, bg = 2}},
        Override_IronSightStruct = {
            Pos = Vector(-3.395, -5, 1.35),
            Ang = Angle(0, 0, 2),
            Magnification = 1,
        }
    },
    ["sights_flipped"] = {
        VMBodygroups = {{ind = 8, bg = 1}}
    },

    ["skin_black"] = {
        VMSkin = 1
    },
    ["skin_tan"] = {
        VMSkin = 2
    },
    ["skin_cust"] = {
        VMSkin = 3
    },

    ["stock_at"] = {
        VMBodygroups = {{ind = 4, bg = 1}}
    },
    ["stock_ru"] = {
        VMBodygroups = {{ind = 4, bg = 2}}
    },
    ["stock_ru_rubber"] = {
        VMBodygroups = {{ind = 4, bg = 3}}
    },
    ["stock_fixed"] = {
        VMBodygroups = {
            {ind = 4, bg = 4},
            {ind = 5, bg = 1},
        }
    },
    ["stock_none"] = {
        VMBodygroups = {
            {ind = 4, bg = 5},
        }
    },
}

SWEP.ExtraSightDist = 2
SWEP.GuaranteeLaser = true

SWEP.WorldModelOffset = {
    pos = Vector(-7, 5, -4.8),
    ang = Angle(-12, 0, 180)
}

SWEP.MirrorVMWM = true

SWEP.Attachments = {
    {
        PrintName = "Optic",
        DefaultAttName = "Iron Sights",
        DefaultAttIcon = Material("entities/att/ur_aw/ironsights.png", "mips smooth"),
        Slot = {"optic","optic_lp","optic_sniper"},
        Bone = "tag_weapon",
        Offset = {
            vpos = Vector(0, 6, 2.65),
            vang = Angle(0, -90, 0),
        },
        CorrectivePos = Vector(0, 0, 0),
        CorrectiveAng = Angle(0, 180, 0),
        VMScale = Vector(1.05, 1.05, 1.05),
        SlideAmount = {
            vmin = Vector(0, 5.5, 2.65),
            vmax = Vector(0, 7, 2.65),
        },
    },
    {
        PrintName = "Barrel",
        DefaultAttName = "24\" Police Barrel",
        DefaultAttIcon = Material("entities/att/ur_aw/bar_def.png", "mips smooth"),
        Slot = "ur_aw_barrel",
    },
    {
        PrintName = "Muzzle",
        DefaultAttName = "Standard Muzzle",
        Slot = {"muzzle","ur_aw_muzzle"},
        Bone = "tag_weapon",
        VMScale = Vector(1.5, 1.5, 1.5),
        WMScale = VMScale,
        Offset = {
            vpos = Vector(0, 35.2, 1.675),
            vang = Angle(0, 270, 0),
        },
        ExcludeFlags = {"barrel_sd"},
        Installed = "ur_aw_muzzle_brake",
    },
    {
        PrintName = "Caliber",
        DefaultAttName = "7.62x51mm NATO",
        DefaultAttIcon = Material("entities/att/uc_bullets/762x51.png", "mips smooth"),
        Slot = {"ur_aw_cal"},
        Bone = "tag_weapon",
        Offset = {
            vpos = Vector(2.8, -4.2, -11.5),
            vang = Angle(90, 0, -90),
        },
    },
    {
        PrintName = "Magazine",
        Slot = {"ur_aw_mag"},
        DefaultAttName = "5-Round Mag",
        DefaultAttIcon = Material("entities/att/ur_aw/mag308_5.png", "mips smooth"),
        ExcludeFlags = {"mag_338"}
    },
    {
        PrintName = "Underbarrel",
        Slot = {"foregrip"},
        Bone = "tag_weapon",
        Offset = {
            vpos = Vector(0,16, -.6),
            vang = Angle(90, -90, -90),
        },
        VMScale = Vector(1, 1, 1),
        InstalledEles = {"rail_bottom"},
    },
    {
        PrintName = "Tactical",
        Slot = {"tac"},
        Bone = "tag_weapon",
        Offset = {
            vpos = Vector(-1.2, 16, 1.1),
            vang = Angle(-90, 270, 0),
        },
        GivesFlags = {"tac"},
        InstalledEles = {"rail_top"}
    },
    {
        PrintName = "Stock",
        Slot = {"ur_aw_stock"},
        DefaultAttName = "Factory Stock",
        DefaultAttIcon = Material("entities/att/ur_aw/stock_def.png", "mips smooth"),
    },
    {
        PrintName = "Ammo Type",
        DefaultAttName = "\"FMJ\" Full Metal Jacket",
        DefaultAttIcon = Material("entities/att/arccw_uc_ammo_generic.png", "mips smooth"),
        Slot = "uc_ammo",
        HideIfBlocked = true
    },
    {
        PrintName = "Powder Load",
        Slot = "uc_powder",
        DefaultAttName = "Standard Load"
    },
    {
        PrintName = "Training Package",
        Slot = "uc_tp",
        DefaultAttName = "Basic Training"
    },
    {
        PrintName = "Internals",
        Slot = "uc_fg", -- Fire group
        DefaultAttName = "Standard Internals"
    },
    {
        PrintName = "Charm",
        Slot = {"charm", "fml_charm"},
        FreeSlot = true,
        Bone = "tag_weapon",
        Offset = {
            vpos = Vector(.85, 4.6, 0.5),
            vang = Angle(90, -90, -90),
        },
    },
    {
        PrintName = "Finish",
        Slot = {"ur_aw_skin"},
        FreeSlot = true,
        DefaultAttName = "Olive Drab",
        DefaultAttIcon = Material("entities/att/ur_aw/skin_green.png", "mips smooth"),
    }
}


function SWEP:Hook_TranslateAnimation(anim)

end

SWEP.Hook_NameChange = function(wep,name)
    local atts = wep.Attachments
    local barr = string.Replace(atts[2].Installed or "default", "ur_aw_barrel_", "")
    local cal = string.Replace(atts[4].Installed or "default", "ur_aw_cal_", "")
    local stock = string.Replace(atts[8].Installed or "default", "ur_aw_stock_", "")

    if GetConVar("arccw_truenames"):GetBool() then
        if cal ~= "default" then
            return "AWM"
        elseif barr == "sd" then
            return "AWS"
        elseif stock == "at" then
            return "AT"
        end
    else
        if cal == "338" then
            return "Apex Magnum"
        elseif barr == "sd" then
            return "Apex Spectre"
        elseif stock == "at" then
            return "Apex Tactical"
        end
    end
end

SWEP.Hook_ModifyBodygroups = function(wep, data)
    local vm = data.vm
    if !IsValid(vm) then return end

    local atts = wep.Attachments
    local cal = string.Replace(atts[4].Installed or "default", "ur_aw_cal_", "")
    local mag = string.Replace(atts[5].Installed or "default", "ur_aw_mag_", "")
    local flags = wep:GetWeaponFlags()

    local pistolGrip = table.HasValue(flags,"pistolgrip")

    if cal ~= "default" then
        if pistolGrip then
            vm:SetBodygroup(1,3)
        else
            vm:SetBodygroup(1,1)
        end
    elseif pistolGrip then
        vm:SetBodygroup(1,2)
    else
        vm:SetBodygroup(1,0)
    end

    if atts[1].Installed then
        if table.HasValue(flags,"sights_compact") then
            vm:SetBodygroup(8,3)
        else
            vm:SetBodygroup(8,1)
        end
    end

    if mag == "10" then
        vm:SetBodygroup(3,1)
    elseif mag == "10m" then
        vm:SetBodygroup(3,3)
    elseif cal ~= "default" then
        vm:SetBodygroup(3,2)
    end
end

SWEP.Animations = {
    ["ready"] = {
        Source = "cycle",
         Time = 1.47,
        MinProgress = 1.3,
        SoundTable = {
            {s = ratel,                             t = 0.07},
            {s = testpath .. "boltup.ogg",          t = 0.1},
            {s = testpath .. "boltback.ogg",        t = 0.2},
            {s = testpath .. "boltforward.ogg",     t = 0.32},
            {s = testpath .. "boltdown.ogg",        t = 0.6},
        },
        ProcDraw = true,
    },
    ["idle"] = {
        Source = "idle"
    },
    ["idle_empty"] = {
        Source = "idle_empty"
    },
    ["draw"] = {
        Source = "draw",
        LHIK = false,
        LHIKIn = 0,
        LHIKOut = 0.5,
        Time = 35 / 30,
        MinProgess = .5,
        SoundTable = {
            {s = ratel, t = 0},
            {s = common .. "raise.ogg", t = 0.2},
        },
    },
    ["holster"] = {
        Source = "holster",
        LHIK = false,
        LHIKIn = 0,
        LHIKOut = 0.5,
        Time = .75,
        SoundTable = {
            {s = ratel, t = 0},
        },
    },
    ["draw_empty"] = {
        Source = "draw_empty",
        LHIK = false,
        LHIKIn = 0,
        LHIKOut = 35 / 30,
        SoundTable = {
            {s = ratel, t = 0},
            {s = common .. "raise.ogg", t = 0.2},
        },
    },
    ["holster_empty"] = {
        Source = "holster_empty",
        LHIK = false,
        LHIKIn = 0,
        LHIKOut = 0.5,
        SoundTable = {
            {s = ratel, t = 0},
        },
    },
    ["fire"] = {
        Source = {"fire"},
        Time = 27 / 30,
        MinProgress = 0.2,
        SoundTable = {
            SoundTable = {{ s = {path .. "mech-01.ogg", path .. "mech-02.ogg", path .. "mech-03.ogg", path .. "mech-04.ogg", path .. "mech-05.ogg", path .. "mech-06.ogg"}, t = 0, v = 0.25 }},
        },
    },

    ["fire_iron"] = {
        Source = {"fire_iron"},
        Time = 27 / 30,
        MinProgress = 0.2,
        SoundTable = {
            SoundTable = {{ s = {path .. "mech-01.ogg", path .. "mech-02.ogg", path .. "mech-03.ogg", path .. "mech-04.ogg", path .. "mech-05.ogg", path .. "mech-06.ogg"}, t = 0 }},
        },
    },

    ["reload"] = {
        Source = "reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        LHIK = true,
        LHIKIn = 0.3,
        LHIKOut = 1,
        Time = 85 / 30,
        LHIKEaseOut = 0.25,
        MinProgress = 1.5,
        SoundTable = {
            {s = rottle,                             t = 0.1},
            {s = testpath .. "magrel.ogg", 	t = 0.2},
            {s = testpath .. "magout.ogg",          t = 0.3},
            {s = rottle,    t = 0.75},
            {s = common .. "magpouch.ogg",           t = 0.8, v = 0.4},
            {s = testpath .. "struggle.ogg",   t = 0.9},
            {s = testpath .. "magin.ogg",   t = 1.2},
            {s = rottle,    t = 1.4},
            {s = ratel,   t = 1.5},
        },
    },
    ["reload_10"] = {
        Source = "reload_exte",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        LHIK = true,
        LHIKIn = 0.3,
        LHIKOut = 1.15,
        LHIKEaseOut = 0.25,
        MinProgress = 2.5,
        SoundTable = {
            {s = rottle,                             t = 0.1},
            {s = testpath .. "magrel.ogg", 	t = 0.2},
            {s = testpath .. "magout.ogg",          t = 0.3},
            {s = rottle,    t = 0.75},
            {s = common .. "magpouch.ogg",           t = 0.8, v = 0.4},
            {s = testpath .. "struggle.ogg",   t = 0.9},
            {s = testpath .. "magin.ogg",   t = 1.2},
            {s = rottle,    t = 1.4},
            {s = ratel,   t = 1.5},
        },
    },
    ["reload_338"] = {
        Source = "reload_magnum",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        LHIK = true,
        LHIKIn = 0.3,
        LHIKOut = 1.15,
        LHIKEaseOut = 0.25,
        MinProgress = 2.5,
        Time = 3.4,
        SoundTable = {
            {s = rottle,                             t = 0.1},
            {s = testpath .. "magrel.ogg", 	t = 0.2},
            {s = testpath .. "magout.ogg",          t = 0.4},
            {s = rottle,    t = 0.75},
            {s = common .. "magpouch.ogg",           t = 0.8, v = 0.4},
            {s = testpath .. "struggle.ogg",   t = 1.1, v = 1.1},
            {s = testpath .. "magin.ogg",   t = 1.3},
            {s = testpath .. "magtap.ogg",   t = 1.95},
            {s = rottle,    t = 2.3, v = 0.6},
            {s = ratel,   t = 2.35, v = 0.6},
        },
    },
    ["reload_empty"] = {
        Source = "reload_empty",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        LHIK = false,
        LHIKIn = 0.9,
        LHIKOut = 1.25,
        LHIKEaseIn = 0.1,
        LHIKEaseOut = 0.5,
        MinProgress = 3.0,
        ShellEjectAt = .45,
        LastClip1OutTime = 1.8,
        Time = 4.5,
        SoundTable = {
            {s = ratel,                             t = 0.05},
            {s = testpath .. "boltup.ogg",          t = 0.15},
            {s = testpath .. "boltback_reload.ogg",        t = 0.18},
            {s = testpath .. "eject.ogg",           t = 0.45},
            {s = rottle,    t = 0.6},
            {s = testpath .. "magrel.ogg", 	t = 1.0},
            {s = testpath .. "magout_empty.ogg",          t = 1.2},
            {s = rottle,    t = 1.25},
            {s = testpath .. "magdrop_metal.ogg",          t = 1.5, v = 0.4},
            {s = common .. "magpouch.ogg",           t = 1.6, v = 0.4},
            {s = rottle,    t = 1.65},
            {s = testpath .. "struggle.ogg",   t = 2},
            {s = testpath .. "magin.ogg",   t = 2.1},
            {s = rottle,    t = 2.4},
            {s = ratel,   t = 2.6},
            {s = testpath .. "boltforward_reload.ogg",     t = 2.7},
            {s = testpath .. "boltdown.ogg",        t = 3.1},
            {s = common .. "shoulder.ogg",        t = 3.15},
        },
    },
    ["reload_empty_10"] = {
        Source = "reload_empty_exte",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        LHIK = false,
        LHIKIn = 0.9,
        LHIKOut = 1.25,
        LHIKEaseIn = 0.1,
        LHIKEaseOut = 0.5,
        ShellEjectAt = .5,
        MinProgress = 3.5,
        LastClip1OutTime = 1.8,
        Time = 4.5,
        SoundTable = {
            {s = ratel,                             t = 0.05},
            {s = testpath .. "boltup.ogg",          t = 0.15},
            {s = testpath .. "boltback_reload.ogg",        t = 0.18},
            {s = testpath .. "eject.ogg",           t = 0.45},
            {s = rottle,    t = .6},
            {s = testpath .. "magrel.ogg", 	t = 1.0},
            {s = testpath .. "magout_empty.ogg",          t = 1.2},
            {s = rottle,    t = 1.25},
            {s = testpath .. "magdrop_metal.ogg",          t = 1.6, v = 0.4},
            {s = common .. "magpouch.ogg",           t = 1.6, v = 0.4},
            {s = rottle,    t = 1.65},
            {s = testpath .. "struggle.ogg",   t = 2.1},
            {s = testpath .. "magin.ogg",   t = 2.2},
            {s = rottle,    t = 2.5},
            {s = testpath .. "boltforward_reload.ogg",     t = 2.8},
            {s = ratel,   t = 2.7},
            {s = testpath .. "boltdown.ogg",        t = 3.2},
            {s = common .. "shoulder.ogg",        t = 3.2},
        },
    },
    ["reload_empty_338"] = {
        Source = "reload_empty_magnum",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        LHIK = false,
        LHIKIn = 0.9,
        LHIKOut = 1.25,
        LHIKEaseIn = 0.1,
        LHIKEaseOut = 0.5,
        ShellEjectAt = .5,
        LastClip1OutTime = 1.5,
        MinProgress = 4,
        Time = 4.25,
        SoundTable = {
            {s = ratel,                             t = 0.05},
            {s = testpath .. "boltup.ogg",          t = 0.15},
            {s = testpath .. "boltback_reload.ogg",        t = 0.18},
            {s = testpath .. "eject.ogg",           t = 0.45},
            {s = rottle,    t = 0.6},
            {s = testpath .. "magrel.ogg", 	t = 1.0},
            {s = testpath .. "magout_empty.ogg",          t = 1.1},
            {s = rottle,    t = 1.25},
            {s = testpath .. "magdrop_metal.ogg",          t = 1.5, v = 0.4},
            {s = common .. "magpouch.ogg",           t = 1.6, v = 0.4},
            {s = rottle,    t = 1.65},
            {s = testpath .. "struggle.ogg",   t = 1.8},
            {s = testpath .. "magin.ogg",   t = 1.9},
            {s = rottle,    t = 2.4},
            {s = testpath .. "magtap.ogg",   t = 2.5},
            {s = ratel,   t = 2.6},
            {s = testpath .. "boltforward_reload.ogg",     t = 2.7},
            {s = testpath .. "boltdown.ogg",        t = 3.1},
            {s = common .. "shoulder.ogg",        t = 3.15},
        },
    },
    ["reload_empty_10_338"] = {
        Source = "reload_empty_exte_magnum",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        LHIK = true,
        LHIKIn = 0.9,
        LHIKOut = 1.25,
        LHIKEaseIn = 0.1,
        LHIKEaseOut = 0.5,
        MinProgress = 4,
        LastClip1OutTime = 2.3,
        Time = 4.5,
        ShellEjectAt = .5,
        SoundTable = {
            {s = ratel,                             t = 0.05},
            {s = testpath .. "boltup.ogg",          t = 0.15},
            {s = testpath .. "boltback_reload.ogg",        t = 0.18},
            {s = testpath .. "eject.ogg",           t = 0.45},
            {s = rottle,    t = 0.6},
            {s = testpath .. "magrel.ogg", 	t = 1.0},
            {s = testpath .. "magout_empty.ogg",          t = 1.1},
            {s = rottle,    t = 1.25},
            {s = testpath .. "magdrop_metal.ogg",          t = 1.5, v = 0.4},
            {s = common .. "magpouch.ogg",           t = 1.6, v = 0.4},
            {s = rottle,    t = 1.65},
            {s = testpath .. "struggle.ogg",   t = 1.85},
            {s = testpath .. "magin.ogg",   t = 2.0},
            {s = rottle,    t = 2.4},
            {s = testpath .. "magtap.ogg",   t = 2.6},
            {s = ratel,   t = 2.6},
            {s = testpath .. "boltforward_reload.ogg",     t = 2.9},
            {s = testpath .. "boltdown.ogg",        t = 3.3},
            {s = common .. "shoulder.ogg",        t = 3.35},
        },
    },
    ["reload_10_338"] = {
        Source = "reload_exte_magnum",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        LHIK = true,
        LHIKIn = 0.3,
        LHIKOut = 0.65,
        LHIKEaseOut = 0.25,
        MinProgress = 3,
        Time = 3.5,
        SoundTable = {
            {s = rottle,                             t = 0.1},
            {s = testpath .. "magrel.ogg", 	t = 0.2},
            {s = testpath .. "magout.ogg",          t = 0.4},
            {s = rottle,    t = 0.75},
            {s = common .. "magpouch.ogg",           t = 0.8, v = 0.4},
            {s = testpath .. "struggle.ogg",   t = 1.1, v = 1},
            {s = testpath .. "magin.ogg",   t = 1.4},
            {s = testpath .. "magtap.ogg",   t = 2.0},
            {s = rottle,    t = 2.3, v = 0.6},
            {s = ratel,   t = 2.35, v = 0.6},
        },
    },
    ["cycle"] = {
        Source = "cycle",
        Time = 1.47,
        ShellEjectAt = 0.4,
        MinProgress = 0.9,
        SoundTable = {
            {s = ratel,                             t = 0.07},
            {s = testpath .. "boltup.ogg",          t = 0.1},
            {s = testpath .. "boltback.ogg",        t = 0.2},
            {s = testpath .. "boltforward.ogg",     t = 0.32},
            {s = testpath .. "eject.ogg",           t = 0.4},
            {s = testpath .. "boltdown.ogg",        t = 0.6},

            --{s = common .. "shoulder.ogg",          t = 0.7},
        },
    },

    ["enter_inspect"] = {
        Source = "inspect_enter",
        -- time = 35 / 60,
        LHIK = false,
        LHIKIn = 0,
        LHIKOut = 2.5,
        SoundTable = {
            {s = rottle, t = 0},
            {s = common .. "movement-sniper-03.ogg", t = 0.05},
        },
    },
    ["idle_inspect"] = {
        Source = "inspect_loop",
        -- time = 72 / 60,
        LHIK = false,
        LHIKIn = 0,
        LHIKOut = 999, -- maybe im dumb
    },
    ["exit_inspect"] = {
        Source = "inspect_exit",
        -- time = 66 / 60,
        LHIK = false,
        LHIKIn = 0,
        LHIKOut = 999, -- maybe im dumb
        SoundTable = {
            {s = common .. "movement-sniper-01.ogg", t = 0},
            {s = rottle, t = 0.25},
            {s = testpath .. "boltup_inspect.ogg",          t = 1.2},
            {s = common .. "movement-sniper-03.ogg", t = 1.25},
            {s = testpath .. "boltback_inspect.ogg",        t = 1.35},
            {s = testpath .. "boltforward_inspect.ogg",     t = 1.8},
            {s = testpath .. "boltdown_inspect.ogg",        t = 1.9},
            {s = rottle, t = 2.0},
            {s = common .. "movement-sniper-04.ogg", t = 2.2},
        },
    },
    ["enter_inspect_empty"] = { -- Animations needed!
        Source = "inspect_enter",
        -- time = 35 / 60,
        LHIK = false,
        LHIKIn = 0,
        LHIKOut = 2.5,
        SoundTable = {
            {s = rottle, t = 0},
            {s = rutle, t = 0.1},
        },
    },
    ["idle_inspect_empty"] = {
        Source = "inspect_loop",
        -- time = 72 / 60,
        LHIK = false,
        LHIKIn = 0,
        LHIKOut = 999, -- maybe im dumb
    },
    ["exit_inspect_empty"] = {
        Source = "inspect_exit",
        -- time = 66 / 60,
        LHIK = false,
        LHIKIn = 0,
        LHIKOut = 999, -- maybe im dumb
        SoundTable = {
            {s = common .. "movement-sniper-01.ogg", t = 0.05},
            {s = rottle, t = 0.25},
            {s = testpath .. "boltup_inspect.ogg",          t = 1.2},
            {s = common .. "movement-sniper-03.ogg", t = 1.25},
            {s = testpath .. "boltback_inspect.ogg",        t = 1.35},
            {s = testpath .. "boltforward_inspect.ogg",     t = 1.8},
            {s = testpath .. "boltdown_inspect.ogg",        t = 1.9},
            {s = rottle, t = 2.0},
            {s = common .. "movement-sniper-04.ogg", t = 2.2},
        },
    },
}

SWEP.Hook_Think = ArcCW.UC.ADSReload
