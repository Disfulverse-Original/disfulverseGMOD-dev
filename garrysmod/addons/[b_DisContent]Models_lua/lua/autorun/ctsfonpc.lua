if SERVER then
	AddCSLuaFile()
end

list.Set("NPC", "codmw19_ctsfo_friendly", {
	Name = "CoD MW19: CTSFO Friendly",
	Class = "npc_citizen",
	Model = "models/arty/codmw2019/mp/coalition/ctsfo/ctsfo_friendly.mdl",
	Health = "350",
	KeyValues = {citizentype = 5},
	Category = "CTFSO"
})
list.Set("NPC", "codmw19_ctsfo_hostile", {
	Name = "CoD MW19: CTSFO Hostile",
	Class = "npc_combine_s",
	Model = "models/arty/codmw2019/mp/coalition/ctsfo/ctsfo_hostile.mdl",
	Health = "350",
	Weapons = {"weapon_smg1", "weapon_ar2"},
	Numgrenades = "4",
	Category = "CTFSO"
})
