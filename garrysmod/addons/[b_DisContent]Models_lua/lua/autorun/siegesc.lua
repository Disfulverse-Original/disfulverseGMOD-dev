player_manager.AddValidModel( "Shadow Company - Militant", "models/arty/codmw2022/mp/shadow company/militant/grunt_pm.mdl" )
player_manager.AddValidModel( "Shadow Company - Militant - ARC9", "models/arty/codmw2022/mp/shadow company/militant/grunt - arc9_pm.mdl" )
player_manager.AddValidModel( "Shadow Company - Siege", "models/arty/codmw2022/mp/shadow company/siege/grunt_pm.mdl" )
player_manager.AddValidModel( "Shadow Company - Siege - ARC9", "models/arty/codmw2022/mp/shadow company/siege/grunt - arc9_pm.mdl" )

player_manager.AddValidHands( "Shadow Company - Militant", "models/arty/codmw2022/mp/shadow company/militant/grunt_vm.mdl", 0, "00" )
player_manager.AddValidHands( "Shadow Company - Militant - ARC9", "models/arty/codmw2022/mp/shadow company/militant/grunt_vm.mdl", 0, "00" )
player_manager.AddValidHands( "Shadow Company - Siege", "models/arty/codmw2022/mp/shadow company/siege/grunt_vm.mdl", 0, "00" )
player_manager.AddValidHands( "Shadow Company - Siege - ARC9", "models/arty/codmw2022/mp/shadow company/siege/grunt_vm.mdl", 0, "00" )

local Category = "Shadow Company" 

local NPC = {   Name = "Militant Grunt Hostile", 
                Class = "npc_combine_s",
                Model = "models/arty/codmw2022/mp/shadow company/militant/grunt_hostile.mdl", 
                Health = "350", 
                Weapons = {"weapon_shotgun","weapon_smg1","weapon_ar2"}, 
                Category = Category }
                               
list.Set( "NPC", "militantscmw22_hostile", NPC )

local NPC = {   Name = "Militant Grunt Friendly", 
                Class = "npc_citizen",
                Model = "models/arty/codmw2022/mp/shadow company/militant/grunt_friendly.mdl", 
                Health = "350", 
                KeyValues = { citizentype = 4 }, 
                Weapons = {"weapon_shotgun","weapon_smg1","weapon_ar2"}, 
                Category = Category }
                               
list.Set( "NPC", "militantscmw22_friendly", NPC )

local NPC = {   Name = "Siege Grunt Hostile", 
                Class = "npc_combine_s",
                Model = "models/arty/codmw2022/mp/shadow company/siege/grunt_hostile.mdl", 
                Health = "350", 
                Weapons = {"weapon_shotgun","weapon_smg1","weapon_ar2"}, 
                Category = Category }
                               
list.Set( "NPC", "siegescmw22_hostile", NPC )

local NPC = {   Name = "Siege Grunt Friendly", 
                Class = "npc_citizen",
                Model = "models/arty/codmw2022/mp/shadow company/siege/grunt_friendly.mdl", 
                Health = "350", 
                KeyValues = { citizentype = 4 }, 
                Weapons = {"weapon_shotgun","weapon_smg1","weapon_ar2"}, 
                Category = Category }
                               
list.Set( "NPC", "siegescmw22_friendly", NPC )

