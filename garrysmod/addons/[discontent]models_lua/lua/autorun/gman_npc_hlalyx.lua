local Category = "Half-Life Alyx"

local NPC = {
  Name = "G-Man (Враг)", 
  Class = "npc_combine_s",
  Model = "models/1000shells/hla/gman/gman_combine.mdl",
  Weapons = { "weapon_smg1", "weapon_ar2", "weapon_shotgun" },
  Health = 100,
  KeyValues = {
    SquadName = "ZealTeam",
    Numgrenades = 5
  },
  Category = Category
}

list.Set( "NPC", "gman_combine", NPC )

local NPC = {
  Name = "G-Man (Друг)", 
  Class = "npc_citizen",
  Model = "models/1000shells/hla/gman/gman_rebel.mdl",
  Health = 300,
  KeyValues = {
    citizentype = CT_UNIQUE
  },
  Weapons = { "weapon_pistol", "weapon_ar2", "weapon_smg1", "weapon_ar2", "weapon_shotgun" },
  Category = Category
}

list.Set( "NPC", "gman_rebel", NPC )