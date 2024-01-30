player_manager.AddValidModel("Call of Duty Modern Warfare II - Horangi (Warfighter)", "models/bread/cod/characters/kortac/horangi_kpop.mdl")
player_manager.AddValidHands("Call of Duty Modern Warfare II - Horangi (Warfighter)", "models/breadarms/weapons/kpopvh.mdl", 0, "0")

local NPC =
{
	Name = "Call of Duty Modern Warfare II - Horangi (Warfighter) (Friendly)",
	Class = "npc_citizen",
	KeyValues = { citizentype = 4, spawnflags = 155908, },
	Model = "models/bread/cod/characters/kortac/npc/horangi_kpop_f.mdl",
	Health = "120",
	Weapons = { "weapon_ar2" },
	Category = "Modern Warfare II"
	
}

list.Set( "NPC", "kpop_f", NPC )

local NPC =
{
	Name = "Call of Duty Modern Warfare II - Horangi (Warfighter) (Hostile)",
	Class = "npc_combine_s",
	Model = "models/bread/cod/characters/kortac/npc/horangi_kpop_h.mdl",
	Health = "120",
	Squadname = "PLAGUE",
	Numgrenades = "15",
	Weapons = { "weapon_ar2" },
	Category = "Modern Warfare II"
	
}

list.Set( "NPC", "kpop_h", NPC )
