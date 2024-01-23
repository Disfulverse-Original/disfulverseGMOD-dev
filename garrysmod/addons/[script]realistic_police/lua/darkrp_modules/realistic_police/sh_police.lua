

--if Realistic_Police.DefaultJob then 
	--TEAM_CAMERAREPAIRER = DarkRP.createJob("Camera Repairer", {
		--color =  Color(252, 133, 0),
		--model = {"models/player/odessa.mdl"},
		--description = [[Repaire the camera of your city.]],
		--weapons = {"weapon_rpt_wrench"},
		--command = "camerarepairer",
		--max = 2,
		--salary = 20,
		--admin = 0,
		--vote = false,
		--hasLicense = false
	--})
--end

--[[DarkRP.createCategory{
	name = "Camera Repairer",
	categorises = "entities",
	startExpanded = true,
	color = Color(252, 133, 0),
	canSee = function(ply) return true end,
	sortOrder = 100
}

DarkRP.createEntity("Camera", {
	ent = "realistic_police_camera",
	model = "models/wasted/wasted_kobralost_camera.mdl",
	price = 500,
	max = 10,
	cmd = "realistic_police_camera",
	--allowed = TEAM_CAMERAREPAIRER,
	category = "Camera Repairer"
})

DarkRP.createEntity("Screen", {
	ent = "realistic_police_screen",
	model = "models/props/cs_office/tv_plasma.mdl",
	price = 500,
	max = 1,
	cmd = "realistic_police_screen",
	category = "Camera Repairer"
})]]
