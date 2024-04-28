player_manager.AddValidModel("Call of Duty Modern Warfare 2019 - Shadow Company Mil-Sim", "models/bread/cod/characters/milsim/shadow_company.mdl")
player_manager.AddValidHands("Call of Duty Modern Warfare 2019 - Shadow Company Mil-Sim", "models/weapons/scmilsimarms.mdl", 0, "0")

local NPC =
{
	Name = "Call of Duty Modern Warfare - Shadow Company Mil-Sim(Friendly)",
	Class = "npc_citizen",
	KeyValues = { citizentype = 4, spawnflags = 155908, },
	Model = "models/bread/cod/characters/milsim/npc/shadow_company_19_f.mdl",
	Health = "120",
	Weapons = { "weapon_ar2" },
	Category = "Shadow Company"
	
}

list.Set( "NPC", "sc19_f", NPC )

local NPC =
{
	Name = "Call of Duty Modern Warfare - Shadow Company Mil-Sim(Hostile)",
	Class = "npc_combine_s",
	Model = "models/bread/cod/characters/milsim/npc/shadow_company_19_h.mdl",
	Health = "120",
	Squadname = "PLAGUE",
	Numgrenades = "15",
	Weapons = { "weapon_ar2" },
	Category = "Shadow Company"
	
}

list.Set( "NPC", "sc19_h", NPC )
