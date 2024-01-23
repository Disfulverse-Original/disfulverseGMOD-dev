--[[Enhanced Cocaine Laboratory 1.2]]
--[[Leaked by High Leaker          ]]
--[[Enjoy !                        ]]


timer.Simple(5, function()
local allowedTeam = {TEAM_GANG, TEAM_MOB} -- Jobs what are allowed to buy cocaine supplies.

DarkRP.createCategory{
	name = "Cocaine Supplies",
	categorises = "entities",
	startExpanded = true,
	color = Color(255, 165, 0, 255),
	sortOrder = 100,
	canSee = function(ply) return true end,
}

DarkRP.createEntity("Pot for growing Coca Plant", {
	ent = "ecl_plant_pot",
	model = "models/props_junk/terracotta01.mdl",
	price = 150,
	max = 5,
	cmd = "eclbuypp",
	category = "Cocaine Supplies",
	allowed = allowedTeam
})

if (ECL.CustomModels.Stove) then	
	DarkRP.createEntity("Portable Stove", {
		ent = "ecl_stove",
		model = "models/srcocainelab/portablestove.mdl",
		price = 1000,
		max = 4,
		cmd = "eclbuyst",
		category = "Cocaine Supplies",
		allowed = allowedTeam
	})
else
	DarkRP.createEntity("Stove", {
		ent = "ecl_stove",
		model = "models/props_c17/furnitureStove001a.mdl",
		price = 5000,
		max = 1,
		cmd = "eclbuyst",
		category = "Cocaine Supplies",
		allowed = allowedTeam
	})
end

DarkRP.createEntity("Pot for cooking Cocaine", {
	ent = "ecl_pot",
	model = "models/props_c17/metalPot001a.mdl",
	price = 500,
	max = 4,
	cmd = "eclbuyp",
	category = "Cocaine Supplies",
	allowed = allowedTeam
})

DarkRP.createEntity("Box for collecting leaves", {
	ent = "ecl_leafbox",
	model = "models/props_junk/cardboard_box004a.mdl",
	price = 150,
	max = 5,
	cmd = "eclbuycl",
	category = "Cocaine Supplies",
	allowed = allowedTeam
})

DarkRP.createEntity("Kerosin", {
	ent = "ecl_kerosin",
	model = "models/props_junk/metal_paintcan001a.mdl",
	price = 750,
	max = 8,
	cmd = "eclbuyks",
	category = "Cocaine Supplies",
	allowed = allowedTeam
})

if (ECL.CustomModels.Gascan) then
	DarkRP.createEntity("Gascan", {
		ent = "ecl_gas",
		model = "models/srcocainelab/gascan.mdl",
		price = 500,
		max = 5,
		cmd = "eclbuygs",
		category = "Cocaine Supplies",
		allowed = allowedTeam
	})
else	
	DarkRP.createEntity("Gas for Stove", {
		ent = "ecl_gas",
		model = "models/props_junk/propane_tank001a.mdl",
		price = 500,
		max = 5,
		cmd = "eclbuygs",
		category = "Cocaine Supplies",
		allowed = allowedTeam
	})
end;

DarkRP.createEntity("Gasoline", {
	ent = "ecl_gasoline",
	model = "models/props_junk/metalgascan.mdl",
	price = 1000,
	max = 2,
	cmd = "eclbuygl",
	category = "Cocaine Supplies",
	allowed = allowedTeam
})

DarkRP.createEntity("Water for Drufing Leaves", {
	ent = "ecl_drafted",
	model = "models/props_junk/plasticbucket001a.mdl",
	price = 500,
	max = 4,
	cmd = "eclbuydl",
	category = "Cocaine Supplies",
	allowed = allowedTeam
})

DarkRP.createEntity("Sulfuric Acid", {
	ent = "ecl_sulfuric_acid",
	model = "models/props_junk/garbage_milkcarton001a.mdl",
	price = 1000,
	max = 2,
	cmd = "eclbuysa",
	category = "Cocaine Supplies",
	allowed = allowedTeam
})

end)