-- Add all categories and DarkRP entities here automatically.

function CH_BITMINERS_DarkRPEntities()
	-- Categories
	DarkRP.createCategory{
		name = "Оборудование Крипто-майнера",
		categorises = "entities",
		startExpanded = true,
		color = Color(0, 107, 0, 255),
		--canSee = function(ply) return true end,
		sortOrder = 50,
	}

	-- Entities
	DarkRP.createEntity("Силовой кабель", {
        ent = "ch_bitminer_power_cable",
        model = "models/craphead_scripts/bitminers/utility/plug.mdl",
        price = 300,
        max = 5,
		category = "Оборудование Крипто-майнера",
        cmd = "buypowercable",
        allowed = {TEAM_CRYPTMINER},
    })

    DarkRP.createEntity("Генератор", {
        ent = "ch_bitminer_power_generator",
        model = "models/craphead_scripts/bitminers/power/generator.mdl",
        price = 30000,
        max = 1,
		category = "Оборудование Крипто-майнера",
        cmd = "buypowergenerator",
        allowed = {TEAM_CRYPTMINER},
    })
	
	DarkRP.createEntity("Солнечная панель", {
        ent = "ch_bitminer_power_solar",
        model = "models/craphead_scripts/bitminers/power/solar_panel.mdl",
        price = 7500,
        max = 3,
		category = "Оборудование Крипто-майнера",
        cmd = "buysolarpanel",
        allowed = {TEAM_CRYPTMINER},
    })
	
	DarkRP.createEntity("Объединитель мощности", {
        ent = "ch_bitminer_power_combiner",
        model = "models/craphead_scripts/bitminers/power/power_combiner.mdl",
        price = 5000,
        max = 2,
		category = "Оборудование Крипто-майнера",
        cmd = "buypowercombiner",
        allowed = {TEAM_CRYPTMINER},
    })
	
	DarkRP.createEntity("Термоэлектрический генератор", {
        ent = "ch_bitminer_power_rtg",
        model = "models/craphead_scripts/bitminers/power/rtg.mdl",
        price = 50000,
        max = 1,
		category = "Оборудование Крипто-майнера",
        cmd = "buynucleargenerator",
        allowed = {TEAM_CRYPTMINER},
    })

    DarkRP.createEntity("Полка для криптомайнинга", {
        ent = "ch_bitminer_shelf",
        model = "models/craphead_scripts/bitminers/rack/rack.mdl",
        price = 15000,
        max = 3,
		category = "Оборудование Крипто-майнера",
        cmd = "buyminingshelf",
        allowed = {TEAM_CRYPTMINER},
    })
	
	DarkRP.createEntity("Охлаждение Тир-1", {
        ent = "ch_bitminer_upgrade_cooling1",
        model = "models/craphead_scripts/bitminers/utility/cooling_upgrade_1.mdl",
        price = 5000,
        max = 10,
		category = "Оборудование Крипто-майнера",
        cmd = "buycooling1",
        allowed = {TEAM_CRYPTMINER},
    })

    DarkRP.createEntity("Охлаждение Тир-2", {
        ent = "ch_bitminer_upgrade_cooling2",
        model = "models/craphead_scripts/bitminers/utility/cooling_upgrade_2.mdl",
        price = 10000,
        max = 10,
		category = "Оборудование Крипто-майнера",
        cmd = "buycooling2",
        allowed = {TEAM_CRYPTMINER},
    })
	
	DarkRP.createEntity("Охлаждение Тир-3", {
        ent = "ch_bitminer_upgrade_cooling3",
        model = "models/craphead_scripts/bitminers/utility/cooling_upgrade_3.mdl",
        price = 20000,
        max = 10,
		category = "Оборудование Крипто-майнера",
        cmd = "buycooling3",
        allowed = {TEAM_CRYPTMINER},
    })

    DarkRP.createEntity("Крипто-единица", {
        ent = "ch_bitminer_upgrade_miner",
        model = "models/craphead_scripts/bitminers/utility/miner_solo.mdl",
        price = 1500,
        max = 8,
		category = "Оборудование Крипто-майнера",
        cmd = "buysingleminer",
        allowed = {TEAM_CRYPTMINER},
    })

    DarkRP.createEntity("Обновление комплекта RGB", {
        ent = "ch_bitminer_upgrade_rgb",
        model = "models/craphead_scripts/bitminers/utility/rgb_kit.mdl",
        price = 7500,
        max = 8,
		category = "Оборудование Крипто-майнера",
        cmd = "buyrgbkit",
        allowed = {TEAM_CRYPTMINER},
    })
	
	DarkRP.createEntity("Модернизация источника питания", {
        ent = "ch_bitminer_upgrade_ups",
        model = "models/craphead_scripts/bitminers/utility/ups_solo.mdl",
        price = 5000,
        max = 8,
		category = "Оборудование Крипто-майнера",
        cmd = "buyupsupgrade",
        allowed = {TEAM_CRYPTMINER},
    })
	
	DarkRP.createEntity("Топливо - маленькое", {
        ent = "ch_bitminer_power_generator_fuel_small",
        model = "models/craphead_scripts/bitminers/utility/jerrycan.mdl",
        price = 750,
        max = 5,
		category = "Оборудование Крипто-майнера",
        cmd = "buygeneratorfuelsmall",
        allowed = {TEAM_CRYPTMINER},
    })
	
	DarkRP.createEntity("Топливо - среднее", {
        ent = "ch_bitminer_power_generator_fuel_medium",
        model = "models/craphead_scripts/bitminers/utility/jerrycan.mdl",
        price = 1500,
        max = 5,
		category = "Оборудование Крипто-майнера",
        cmd = "buygeneratorfuelmedium",
        allowed = {TEAM_CRYPTMINER},
    })
	
	DarkRP.createEntity("Топливо - большое", {
        ent = "ch_bitminer_power_generator_fuel_large",
        model = "models/craphead_scripts/bitminers/utility/jerrycan.mdl",
        price = 3000,
        max = 5,
		category = "Оборудование Крипто-майнера",
        cmd = "buygeneratorfuellarge",
        allowed = {TEAM_CRYPTMINER},
    })
	
	DarkRP.createEntity("Очищающая жидкость", {
        ent = "ch_bitminer_upgrade_clean_dirt",
        model = "models/craphead_scripts/bitminers/cleaning/spraybottle.mdl",
        price = 750,
        max = 5,
		category = "Оборудование Крипто-майнера",
        cmd = "buydirtcleanfluid",
        allowed = {TEAM_CRYPTMINER},
    })
end
hook.Add( "loadCustomDarkRPItems", "CH_BITMINERS_DarkRPEntities", CH_BITMINERS_DarkRPEntities )