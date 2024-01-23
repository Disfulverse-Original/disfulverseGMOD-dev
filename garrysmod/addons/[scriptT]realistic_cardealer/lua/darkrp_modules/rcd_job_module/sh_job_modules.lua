TEAM_CARDEALER = DarkRP.createJob("Cardealer Job", {
    color = Color(158, 38, 228),
    model = {"models/player/odessa.mdl"},
    description = [[ Sell vehicle to other people ! ]],
    weapons = {},
    command = "cardealer",
    max = 1,
    salary = 20,
    admin = 0,
    vote = false,
    category = "Citizens",
    hasLicense = false
})

DarkRP.createCategory{
	name = "Cardealer Job", 
	categorises = "entities",
	startExpanded = true,
	color = Color(158, 38, 228),
	canSee = function(ply) return true end,
	sortOrder = 100,
}

DarkRP.createEntity("Showcase", {
	ent = "rcd_showcase",
	model = "models/dimitri/kobralost/stand.mdl",
	price = 500,
	max = 2,
	cmd = "rcd_showcase",
	allowed = {TEAM_CARDEALER},
    category = "Cardealer Job",
})

DarkRP.createEntity("Printer", {
	ent = "rcd_printer",
	model = "models/dimitri/kobralost/printer.mdl",
	price = 500,
	max = 2,
	cmd = "rcd_printer",
	allowed = {TEAM_CARDEALER},
    category = "Cardealer Job",
})