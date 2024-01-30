player_manager.AddValidModel( "Shadow Company - Trap Boss", "models/arty/codmw2022/mp/dmz/shadowcompany/boss/trap/trap_pm.mdl" )
player_manager.AddValidModel( "Shadow Company - DMR Grunt", "models/arty/codmw2022/mp/dmz/shadowcompany/dmr/dmr_pm.mdl" )
player_manager.AddValidModel( "Shadow Company - SMG Grunt", "models/arty/codmw2022/mp/dmz/shadowcompany/smg/smg_pm.mdl" )
player_manager.AddValidHands( "Shadow Company - Trap Boss", "models/arty/codmw2022/mp/dmz/shadowcompany/trap_vm.mdl", 0, "00" )
player_manager.AddValidHands( "Shadow Company - DMR Grunt", "models/arty/codmw2022/mp/dmz/shadowcompany/dmr_vm.mdl", 0, "00" )
player_manager.AddValidHands( "Shadow Company - SMG Grunt", "models/arty/codmw2022/mp/dmz/shadowcompany/smg_vm.mdl", 0, "00" )


local Category = "Shadow Company" 

local NPC = {   Name = "Trap Boss (Hostile)", 
                Class = "npc_combine_s",
                Model = "models/arty/codmw2022/mp/dmz/shadowcompany/boss/trap/trap_hostile.mdl", 
                Health = "500", 
                Weapons = {"weapon_shotgun","weapon_smg1","weapon_ar2"}, 
                Category = Category }
                               
list.Set( "NPC", "sctrap_hostile", NPC )

local NPC = {   Name = "Trap Boss (Friendly)", 
                Class = "npc_citizen",
                Model = "models/arty/codmw2022/mp/dmz/shadowcompany/boss/trap/trap_friendly.mdl", 
                Health = "500", 
                KeyValues = { citizentype = 4 }, 
                Weapons = {"weapon_shotgun","weapon_smg1","weapon_ar2"}, 
                Category = Category }
                               
list.Set( "NPC", "sctrap_friendly", NPC )

local NPC = {   Name = "DMR Grunt (Hostile)", 
                Class = "npc_combine_s",
                Model = "models/arty/codmw2022/mp/dmz/shadowcompany/dmr/dmr_hostile.mdl", 
                Health = "500", 
                Weapons = {"weapon_shotgun","weapon_smg1","weapon_ar2"}, 
                Category = Category }
                               
list.Set( "NPC", "scdmr_hostile", NPC )

local NPC = {   Name = "DMR Grunt (Friendly)", 
                Class = "npc_citizen",
                Model = "models/arty/codmw2022/mp/dmz/shadowcompany/dmr/dmr_friendly.mdl", 
                Health = "500", 
                KeyValues = { citizentype = 4 }, 
                Weapons = {"weapon_shotgun","weapon_smg1","weapon_ar2"}, 
                Category = Category }
                               
list.Set( "NPC", "scdmr_friendly", NPC )

local NPC = {   Name = "SMG Grunt (Hostile)", 
                Class = "npc_combine_s",
                Model = "models/arty/codmw2022/mp/dmz/shadowcompany/smg/smg_hostile.mdl", 
                Health = "500", 
                Weapons = {"weapon_shotgun","weapon_smg1","weapon_ar2"}, 
                Category = Category }
                               
list.Set( "NPC", "scsmg_hostile", NPC )

local NPC = {   Name = "SMG Grunt (Friendly)", 
                Class = "npc_citizen",
                Model = "models/arty/codmw2022/mp/dmz/shadowcompany/smg/smg_friendly.mdl", 
                Health = "500", 
                KeyValues = { citizentype = 4 }, 
                Weapons = {"weapon_shotgun","weapon_smg1","weapon_ar2"}, 
                Category = Category }
                               
list.Set( "NPC", "scsmg_friendly", NPC )



