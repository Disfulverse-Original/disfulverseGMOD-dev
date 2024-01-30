TEAM_CITIZEN = DarkRP.createJob("Безработный", {
    color = Color(20, 150, 20, 255),
    model = {
        "models/player/Group01/male_09.mdl",
        "models/player/Group01/male_08.mdl",
        "models/player/Group01/male_07.mdl",
        "models/player/Group01/male_06.mdl",
        "models/player/Group01/male_05.mdl",
        "models/player/Group01/male_01.mdl",
        "models/player/Group01/male_03.mdl",
        "models/player/Group01/male_04.mdl",
        "models/player/Group01/female_01.mdl",
        "models/player/Group01/female_02.mdl",
        "models/player/Group01/female_03.mdl",
        "models/player/Group01/female_05.mdl",
        "models/player/Group01/female_06.mdl",
        "models/player/Group01/female_04.mdl"
    },
    description = [[Безработный гражданин - вы средняя прослойка этого мира, вы просто гражданин, может вам нужно найти работу?]],
    weapons = {},
    command = "qsse",
    max = 0,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Нейтральные",
})

TEAM_RUN = DarkRP.createJob("Бегущий", {
    color = Color(20, 150, 20, 255),
    model = {
        "models/dejtriyev/hl1/ryangosling.mdl",
    },
    description = [[Неопределённое сообщество независимо действующих лиц, одурманеное идеей самосовершенствования. There's something inside them.]],
    weapons = {},
    command = "qssw",
    max = 0,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Нейтральные",
})

TEAM_PRODOR = DarkRP.createJob("Продавец оружия", {
    color = Color(20, 150, 20, 255),
    model = {
        "models/player/guerilla.mdl"
    },
    description = [[Занимайтесь распространением всякого оружия.]],
    weapons = {},
    command = "z22fffaaa",
    max = 2,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = true,
    category = "Нейтральные",
})

TEAM_ZARUB = DarkRP.createJob("Контрабандист [Dis+]", {
    color = Color(20, 150, 20, 255),
    model = {
        "models/player/leet.mdl"
    },
    description = [[Поставка дорогих редких вещей, может работать на всех сразу, в зависимости от того кто больше платит.]],
    weapons = {},
    command = "h31131313s",
    max = 1,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = true,
    customCheck = function(ply) 
        return CLIENT or table.HasValue({"dis+", "admin", "superadmin"}, ply:GetUserGroup()) 
    end,
    CustomCheckFailMsg = "Только Dis+ могут взять эту роль!",
    category = "Нейтральные",
})

TEAM_BANDIT = DarkRP.createJob("Бандит", {
    color = Color(20, 150, 20, 255),
    model = {
        "models/drem/cch/female_01.mdl",
        "models/drem/cch/female_02.mdl",
        "models/drem/cch/female_03.mdl",
        "models/drem/cch/female_04.mdl",
        "models/drem/cch/female_06.mdl",
        "models/drem/cch/female_07.mdl",
        "models/drem/cch/male_01.mdl",
        "models/drem/cch/male_02.mdl",
        "models/drem/cch/male_03.mdl",
        "models/drem/cch/male_04.mdl",
        "models/drem/cch/male_05.mdl",
        "models/drem/cch/Male_06.mdl",
        "models/drem/cch/male_07.mdl",
        "models/drem/cch/Male_08.mdl",
        "models/drem/cch/Male_09.mdl"
    },
    description = [[Основной костяк преступного мира, занимаются уже вещами посерьёзнее, грабёж, вооруженные захваты, налёты и тому прочее.]],
    weapons = {},
    command = "11124rrrrg",
    max = 10,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = true,
    category = "Криминал",
})

TEAM_BANDITLOCKPICKER = DarkRP.createJob("Взломщик", {
    color = Color(20, 150, 20, 255),
    model = {
        "models/drem/cch/female_01.mdl",
        "models/drem/cch/female_02.mdl",
        "models/drem/cch/female_03.mdl",
        "models/drem/cch/female_04.mdl",
        "models/drem/cch/female_06.mdl",
        "models/drem/cch/female_07.mdl",
        "models/drem/cch/male_01.mdl",
        "models/drem/cch/male_02.mdl",
        "models/drem/cch/male_03.mdl",
        "models/drem/cch/male_04.mdl",
        "models/drem/cch/male_05.mdl",
        "models/drem/cch/Male_06.mdl",
        "models/drem/cch/male_07.mdl",
        "models/drem/cch/Male_08.mdl",
        "models/drem/cch/Male_09.mdl"
    },
    description = [[Часть преступного мира, по воле случая обучился в мелкой моторике и использовании монтировки для взлома.]],
    weapons = {},
    command = "11124rr4rrg",
    max = 2,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = true,
    category = "Криминал",
})

TEAM_GRABER = DarkRP.createJob("Грабитель [Dis+]", {
    color = Color(20, 150, 20, 255),
    model = {
        "models/player/suits/robber_tie.mdl",
        "models/player/suits/robber_shirt.mdl",
        "models/player/suits/robber_open.mdl"
    },
    description = [[Это грабитель и он умеет грабить, воровать и убивать, если вы не уверены в своём преступном дельце, позовите этого парня, он порешает.]],
    weapons = {},
    command = "11124rr45rrg",
    max = 1,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = true,
    customCheck = function(ply) 
        return CLIENT or table.HasValue({"dis+", "admin", "superadmin"}, ply:GetUserGroup()) 
    end,
    CustomCheckFailMsg = "Только Dis+ могут взять эту роль!",
    category = "Криминал",
})

TEAM_CRYPTMINER = DarkRP.createJob("Крипто-Майнер", {
    color = Color(20, 150, 20, 255),
    model = {
        "models/drem/cch/female_01.mdl",
        "models/drem/cch/female_02.mdl",
        "models/drem/cch/female_03.mdl",
        "models/drem/cch/female_04.mdl",
        "models/drem/cch/female_06.mdl",
        "models/drem/cch/female_07.mdl",
        "models/drem/cch/male_01.mdl",
        "models/drem/cch/male_02.mdl",
        "models/drem/cch/male_03.mdl",
        "models/drem/cch/male_04.mdl",
        "models/drem/cch/male_05.mdl",
        "models/drem/cch/Male_06.mdl",
        "models/drem/cch/male_07.mdl",
        "models/drem/cch/Male_08.mdl",
        "models/drem/cch/Male_09.mdl"
    },
    description = [[Тот самый причастный к кризису полупроводников. Нелегально майнит криптовалюту и оберегается криминальными елементами, а может и не оберегается, who knows.]],
    weapons = {},
    command = "d1233ddccv",
    max = 2,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = true,
    category = "Криминал",
})

TEAM_MAF = DarkRP.createJob("Мафиози", {
    color = Color(20, 150, 20, 255),
    model = {
        "models/player/suits/group1/male_09_shirt.mdl",
        "models/player/suits/group1/male_02_shirt.mdl",
        "models/player/suits/group1/male_08_shirt.mdl",
        "models/player/suits/group2/male_01_open.mdl",
        "models/player/suits/group2/male_03_open.mdl",
        "models/player/suits/group3/male_09_open.mdl",
        "models/player/suits/group3/male_08_open.mdl"

    },
    description = [[Высшая каста преступного мира на сервере. Занимаются насильным, принудительным взиманием налогов среди торговцев, держателей бизнесов, да и простых граждан. Регулируют все процессы внутри криминального сообщества.]],
    weapons = {},
    command = "123tggfa",
    max = 10,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = true,
    category = "Криминал",
})

TEAM_GROVER = DarkRP.createJob("Варщик мета", {
    color = Color(20, 150, 20, 255),
    model = {
        "models/drem/cch/female_01.mdl",
        "models/drem/cch/female_02.mdl",
        "models/drem/cch/female_03.mdl",
        "models/drem/cch/female_04.mdl",
        "models/drem/cch/female_06.mdl",
        "models/drem/cch/female_07.mdl",
        "models/drem/cch/male_01.mdl",
        "models/drem/cch/male_02.mdl",
        "models/drem/cch/male_03.mdl",
        "models/drem/cch/male_04.mdl",
        "models/drem/cch/male_05.mdl",
        "models/drem/cch/Male_06.mdl",
        "models/drem/cch/male_07.mdl",
        "models/drem/cch/Male_08.mdl",
        "models/drem/cch/Male_09.mdl"
    },
    description = [[Химик, пошедший немного не туда. Варит мет и прочую хурму, зарабатывает на этом хорошо, но рискованно]],
    weapons = {},
    command = "d1x2341xz",
    max = 2,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = true,
    category = "Криминал",
})

TEAM_BARACH = DarkRP.createJob("Барахольщик [Dis+]", {
    color = Color(20, 150, 20, 255),
    model = {
        "models/grim/isa/isa_sniper.mdl"
    },
    description = [[Преступный торговец-крафтер, в ассортименте всевозможные товары нелегального характера, оружия, запрещённые детали для изготовления и тому прочее. Все товары достаточно дорогие, так что и цена за них соответствующая.]],
    weapons = {},
    command = "d12341xz",
    max = 2,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = true,
    customCheck = function(ply) 
        return CLIENT or table.HasValue({"dis+", "admin", "superadmin"}, ply:GetUserGroup()) 
    end,
    category = "Криминал",
})

TEAM_MAF41 = DarkRP.createJob("Головорез Мафии [Dis+]", {
    color = Color(20, 150, 20, 255),
    model = {
        "models/arty/codmw2022/mp/dmz/shadowcompany/dmr/dmr_pm.mdl"
    },
    description = [[Ячейка Дона для особых случаев или охраны.]],
    weapons = {},
    command = "123tggf1a",
    max = 2,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = true,
    customCheck = function(ply) 
        return CLIENT or table.HasValue({"dis+", "admin", "superadmin"}, ply:GetUserGroup()) 
    end,
    CustomCheckFailMsg = "Только Dis+ могут взять эту роль!",
    category = "Криминал",
})

TEAM_NAEB = DarkRP.createJob("Наёмник-Мародер", {
    color = Color(20, 150, 20, 255),
    model = {
        "models/drem/cch/female_01.mdl",
        "models/drem/cch/female_02.mdl",
        "models/drem/cch/female_03.mdl",
        "models/drem/cch/female_04.mdl",
        "models/drem/cch/female_06.mdl",
        "models/drem/cch/female_07.mdl",
        "models/drem/cch/male_01.mdl",
        "models/drem/cch/male_02.mdl",
        "models/drem/cch/male_03.mdl",
        "models/drem/cch/male_04.mdl",
        "models/drem/cch/male_05.mdl",
        "models/drem/cch/Male_06.mdl",
        "models/drem/cch/male_07.mdl",
        "models/drem/cch/Male_08.mdl",
        "models/drem/cch/Male_09.mdl" 
    },
    description = [[Незаурядный вооруженный бандит, работает за деньги и способен на малое в одиночку, но на многое в группе.]],
    weapons = {},
    command = "p1gbged",
    max = 3,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = true,
    category = "Мародёры",
})

TEAM_HACKER = DarkRP.createJob("Хакер-взломщик", {
    color = Color(20, 150, 20, 255),
    model = {
        "models/drem/cch/female_01.mdl",
        "models/drem/cch/female_02.mdl",
        "models/drem/cch/female_03.mdl",
        "models/drem/cch/female_04.mdl",
        "models/drem/cch/female_06.mdl",
        "models/drem/cch/female_07.mdl",
        "models/drem/cch/male_01.mdl",
        "models/drem/cch/male_02.mdl",
        "models/drem/cch/male_03.mdl",
        "models/drem/cch/male_04.mdl",
        "models/drem/cch/male_05.mdl",
        "models/drem/cch/Male_06.mdl",
        "models/drem/cch/male_07.mdl",
        "models/drem/cch/Male_08.mdl",
        "models/drem/cch/Male_09.mdl"
    },
    description = [[Наёмник со знаниями в сфере электронных и компьютерных технологий. Хотя и про обычный механический взлом дверей, замков, etc тоже не стоит забывать. Работает за деньги.]],
    weapons = {},
    command = "ofsdaef",
    max = 2,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = true,
    category = "Мародёры",
})

TEAM_PMC = DarkRP.createJob("Оператор ЧВК [Dis+]", {
    color = Color(20, 150, 20, 255),
    model = {
        "models/arty/codmw2022/mp/dmz/shadowcompany/smg/smg_pm.mdl"
    },
    description = [[Опытный боец ЧВК Scorpion, неизвестное прошлое, известные цели. Зароботок денег. Работает на всех и ни на кого. Может заниматься чем угодно за деньги.]],
    weapons = {},
    command = "isdfgs",
    max = 4,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    customCheck = function(ply) 
        return CLIENT or table.HasValue({"dis+", "admin", "superadmin"}, ply:GetUserGroup()) 
    end,
    CustomCheckFailMsg = "Только Dis+ могут взять эту роль!",
    category = "Мародёры",
})

TEAM_PATP = DarkRP.createJob("Патрульная полиция", {
    color = Color(20, 150, 20, 255),
    model = {
        "models/roro/police_male_1.mdl",
        "models/roro/police_male_10.mdl",
        "models/roro/police_male_2.mdl",
        "models/roro/police_male_3.mdl",
        "models/roro/police_male_4.mdl",
        "models/roro/police_male_5.mdl",
        "models/roro/police_male_6.mdl",
        "models/roro/police_male_7.mdl",
        "models/roro/police_male_8.mdl",
        "models/roro/police_male_9.mdl"
    },
    description = [[Патрульный отдел полиции, выходит на операции низкой сложности, охраняют стратегически важные объекты и тому прочее.]],
    weapons = {},
    command = "usdbsdgar",
    max = 10,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "Правительство",
})

TEAM_SPEZ = DarkRP.createJob("Спецназ CTSFO", {
    color = Color(20, 150, 20, 255),
    model = {
        "models/arty/codmw2019/mp/coalition/ctsfo/ctsfo_pm.mdl"
    },
    description = [[Отдел быстрого реагирования, выходит на операции средней сложности, охраняют стратегически важные объекты и тому прочее.]],
    weapons = {},
    command = "ybsdxce",
    max = 5,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "Правительство",
})

TEAM_DISAG = DarkRP.createJob("Отдел Disag [Dis+]", {
    color = Color(20, 150, 20, 255),
    model = {
        "models/bread/cod/characters/milsim/shadow_company.mdl"
    },
    description = [[Спец войска, занимаются рейдами, захватами точек, штурмами и прочими тяжелыми и сложными тактико-военными операциями. По слухам состоят из бывших наемников.]],
    weapons = {},
    command = "tsdg444",
    max = 3,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    customCheck = function(ply) 
        return CLIENT or table.HasValue({"dis+", "admin", "superadmin"}, ply:GetUserGroup()) 
    end,
    CustomCheckFailMsg = "Только Dis+ могут взять эту роль!",
    category = "Правительство",
})

TEAM_DET = DarkRP.createJob("Детектив", {
    color = Color(20, 150, 20, 255),
    model = {
        "models/kerry/detective/male_01.mdl",
        "models/kerry/detective/male_02.mdl",
        "models/kerry/detective/male_03.mdl",
        "models/kerry/detective/male_04.mdl",
        "models/kerry/detective/male_05.mdl",
        "models/kerry/detective/male_06.mdl",
        "models/kerry/detective/male_07.mdl",
        "models/kerry/detective/male_08.mdl",
        "models/kerry/detective/male_09.mdl"
    },
    description = [[Ведёт расследования, сотрудничает с отделом MI5.]],
    weapons = {},
    command = "rsdffggggbn",
    max = 1,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "Правительство",
})

TEAM_MAYOR = DarkRP.createJob("Администратор города", {
    color = Color(20, 150, 20, 255),
    model = {
        "models/player/suits/group3/male_09_open.mdl"
    },
    description = [[Сам мэр, принимает законы, регулирует цены и т.д]],
    weapons = {},
    command = "gfvdcze",
    max = 1,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
    hasLicense = true,
    mayor = true,
    candemote = false,
    category = "Правительство",
})

TEAM_OTDELBEZ = DarkRP.createJob("Отдел Контрразведки MI5", {
    color = Color(20, 150, 20, 255),
    model = {
        "models/bread/cod/characters/kortac/horangi_kpop.mdl"
    },
    description = [[Защита Мэра и Администрации города. Занимаются серьёзными невоенными делами. Расследованиями внутри гос. структур, а так же поиском особо опасных преступников. Сотрудничают с Отделом Разведки.]],
    weapons = {},
    command = "wkloldd",
    max = 1,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    --[[bodygroups = {
        ["pathes"] = {1},
        ["legs"] = {0,1,2,3,4,5},
        ["beanies"] = {0,1,2},
        ["glasses"] = {0,1},
    }]]
    category = "Правительство",
})

TEAM_STAFF = DarkRP.createJob("Отдел поддержки [ADM]", {
    color = Color(20, 150, 20, 255),
    model = {
        "models/player/skeleton.mdl"
    },
    description = [[]],
    weapons = {},
    command = "admdvvvv2",
    max = 0,
    salary = GAMEMODE.Config.normalsalary,
    admin = 1,
    vote = false,
    hasLicense = true,
    candemote = false,
    customCheck = function(ply) 
        return CLIENT or table.HasValue({"admin", "superadmin"}, ply:GetUserGroup()) 
    end,
    CustomCheckFailMsg = "Только Администраторы могут взять эту роль!",
    category = "NONRP",
})

-- Default categories
DarkRP.createCategory{
    name = "Нейтральные",
    categorises = "jobs",
    startExpanded = true,
    color = Color(255, 255, 255, 255 ),
    canSee = fp{fn.Id, true},
    sortOrder = 1,
}
DarkRP.createCategory{
    name = "Криминал",
    categorises = "jobs",
    startExpanded = true,
    color = Color(250,25,50,255),
    canSee = fp{fn.Id, true},
    sortOrder = 2,
}
DarkRP.createCategory{
    name = "Правительство",
    categorises = "jobs",
    startExpanded = true,
    color = Color(0,105,250,255),
    canSee = fp{fn.Id, true},
    sortOrder = 4,
}
DarkRP.createCategory{
    name = "Мародёры",
    categorises = "jobs",
    startExpanded = true,
    color = Color(100,10,255),
    canSee = fp{fn.Id, true},
    sortOrder = 3,
}
DarkRP.createCategory{
    name = "NONRP",
    categorises = "jobs",
    startExpanded = true,
    color = Color(100,10,255),
    canSee = fp{fn.Id, true},
    sortOrder = 5,
}

-- Door groups
AddDoorGroup("Полицейский Участок", TEAM_POLICE, TEAM_MAYOR, TEAM_SPEZ, TEAM_DET, TEAM_PATP, TEAM_OTDELBEZ, TEAM_DISAG)
AddDoorGroup("Бар BeerRunners", TEAM_MAF)

-- Agendas
DarkRP.createAgenda("Gangster's agenda", TEAM_MOB, {TEAM_GANG})
DarkRP.createAgenda("Police agenda", {TEAM_MAYOR, TEAM_CHIEF}, {TEAM_POLICE})

-- Group chats
DarkRP.createGroupChat(function(ply) return ply:isCP() end)
DarkRP.createGroupChat(TEAM_MOB, TEAM_GANG)
DarkRP.createGroupChat(function(listener, ply) return not ply or ply:Team() == listener:Team() end)

-- Demote groups
DarkRP.createDemoteGroup("Cops", {TEAM_POLICE, TEAM_CHIEF})
DarkRP.createDemoteGroup("Gangsters", {TEAM_GANG, TEAM_MOB})

--[[---------------------------------------------------------------------------
Define which team joining players spawn into and what team you change to if demoted
---------------------------------------------------------------------------]]
GAMEMODE.DefaultTeam = TEAM_CITIZEN
--[[---------------------------------------------------------------------------
Define which teams belong to civil protection
Civil protection can set warrants, make people wanted and do some other police related things
---------------------------------------------------------------------------]]
GAMEMODE.CivilProtection = {
    [TEAM_SPEZ] = true,
    [TEAM_DET] = true,
    [TEAM_PATP] = true,
    [TEAM_OTDELBEZ] = true,
    [TEAM_DISAG] = true,
    [TEAM_MAYOR] = true,
}
--[[---------------------------------------------------------------------------
Jobs that are hitmen (enables the hitman menu)
---------------------------------------------------------------------------]]
DarkRP.addHitmanTeam(TEAM_NAEB)
DarkRP.addHitmanTeam(TEAM_PMC)