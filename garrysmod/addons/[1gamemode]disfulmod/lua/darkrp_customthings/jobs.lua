--Neutral--
TEAM_CITIZEN = DarkRP.createJob("Безработный", { -- / 0 lvl
    color = Color(20, 150, 20, 255),
    model = {
        "models/player/Group01/male_09.mdl",
        "models/player/Group01/male_08.mdl",
        "models/player/Group01/male_07.mdl",
        "models/player/Group01/male_06.mdl",
        "models/player/Group01/male_05.mdl",
        "models/player/Group01/male_01.mdl",
        "models/player/Group01/male_03.mdl",
        "models/player/Group01/male_04.mdl"
    },
    description = [[Безработный гражданин, стоило бы найти работу.]],
    weapons = {},
    command = "qsse",
    max = 0,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Нейтральные",
})
--Neutral--


--Traders--
TEAM_PRODOR = DarkRP.createJob("Продавец оружия", { -- / 25 lvl
    color = Color(244, 164, 96, 255),
    model = {
        "models/player/guerilla.mdl"
    },
    description = [[Обладает рабочим, проверенным ассортиментом вооружения, в придачу к этому может продавать все необходимые компоненты для их крафта.]],
    weapons = {},
    command = "z22fffaaa",
    max = 2,
    salary = 50,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = true,
    category = "Нейтральные",
})
TEAM_ZARUB = DarkRP.createJob("Контрабандист [Dis+]", { -- / 35 lvl
    color = Color(192, 192, 192, 255),
    model = {
        "models/player/leet.mdl"
    },
    description = [[Поставщик редкого экзотического вооружения, оружейных модулей и продвинутых материалов для крафта.]],
    weapons = {},
    command = "h31131313s",
    max = 1,
    salary = 65,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = true,
    customCheck = function(ply) 
        return CLIENT or table.HasValue({"disfulversed", "admin", "superadmin"}, ply:GetUserGroup()) 
    end,
    CustomCheckFailMsg = "Только Disfulversed могут взять эту роль!",
    category = "Нейтральные",
})
TEAM_RUN = DarkRP.createJob("Бегущий", { -- / 100 lvl
    color = Color(0, 0, 0, 255),
    model = {
        "models/dejtriyev/hl1/ryangosling.mdl",
    },
    description = [[Неопределённое сообщество независимо действующих лиц, одурманеное идеей самосовершенствования. There's something inside them.]],
    weapons = {parkourmod},
    command = "qssw",
    max = 0,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Нейтральные",
})
--Traders--


--Criminal--
TEAM_BANDIT = DarkRP.createJob("Бандит", { -- / 10 lvl
    color = Color(105, 105, 105, 255),
    model = {
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
    description = [[Основной костяк преступного мира, занимаются всевозможной криминальной деятельностью и наводять шороху в городе.]],
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
TEAM_BANDITLOCKPICKER = DarkRP.createJob("Взломщик", { -- / 10 lvl
    color = Color(105, 105, 105, 255),
    model = {
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
    description = [[Часть преступного мира, по воле случая обучился навыками взлома различных замков.]],
    weapons = {"lockpick"},
    command = "11124rr4rrg",
    max = 2,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = true,
    category = "Криминал",
})
TEAM_BARACH = DarkRP.createJob("Барахольщик [Dis+]", { -- / 30 lvl
    color = Color(119, 136, 153, 255),
    model = {
        "models/grim/isa/isa_sniper.mdl"
    },
    description = [[Загадочный торговец работающий как правило на тех, кто больше платит. В ассортименте всевозможные материалы для крафта, разношёрстное оружие и прочее полезное барахло. ]],
    weapons = {},
    command = "d12341xz",
    max = 1,
    salary = 75,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = true,
    customCheck = function(ply) 
        return CLIENT or table.HasValue({"disfulversed", "admin", "superadmin"}, ply:GetUserGroup()) 
    end,
    CustomCheckFailMsg = "Только Disfulversed могут взять эту роль!",
    category = "Криминал",
})
TEAM_GROVER = DarkRP.createJob("Варщик мета", { -- / 30 lvl
    color = Color(218, 165, 32, 255),
    model = {
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
    description = [[Химик, пошедший немного не туда. Мутит деньги путем варки мета.]],
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
TEAM_MAF = DarkRP.createJob("Мафиози", { -- / 30 lvl
    color = Color(105, 105, 105, 255),
    model = {
        "models/player/suits/group1/male_09_shirt.mdl",
        "models/player/suits/group1/male_02_shirt.mdl",
        "models/player/suits/group1/male_08_shirt.mdl",
        "models/player/suits/group2/male_01_open.mdl",
        "models/player/suits/group2/male_03_open.mdl",
        "models/player/suits/group3/male_09_open.mdl",
        "models/player/suits/group3/male_08_open.mdl"

    },
    description = [[Высшая каста преступного мира. Основная деятельность - удержание контроля над всеми преступными процессами в городе, а так же планировка серьёзных рейдов на администрацию города.]],
    weapons = {},
    command = "123tggfa",
    max = 10,
    salary = 10,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = true,
    category = "Криминал",
})
TEAM_GRABER = DarkRP.createJob("Грабитель [Dis+]", { -- / 35 lvl
    color = Color(105, 105, 105, 255),
    model = {
        "models/player/suits/robber_tie.mdl",
        "models/player/suits/robber_shirt.mdl",
        "models/player/suits/robber_open.mdl"
    },
    description = [[Это грабитель и он умеет грабить, воровать и убивать, если вы не уверены в своём преступном дельце, позовите этого парня, он порешает.]],
    weapons = {"lockpick2"},
    command = "11124rr45rrg",
    max = 1,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = true,
    customCheck = function(ply) 
        return CLIENT or table.HasValue({"disfulversed", "admin", "superadmin"}, ply:GetUserGroup()) 
    end,
    CustomCheckFailMsg = "Только Disfulversed могут взять эту роль!",
    category = "Криминал",
})
TEAM_CRYPTMINER = DarkRP.createJob("Крипто-Майнер", { -- / 45 lvl
    color = Color(105, 105, 105, 255),
    model = {
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
TEAM_MAF41 = DarkRP.createJob("Головорез Мафии [Dis+]", { -- / 45 lvl
    color = Color(105, 105, 105, 255),
    model = {
        "models/arty/codmw2022/mp/dmz/shadowcompany/dmr/dmr_pm.mdl"
    },
    description = [[Ячейка Дона для особых случаев или охраны.]],
    weapons = {},
    command = "123tggf1a",
    max = 2,
    salary = 15,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = true,
    customCheck = function(ply) 
        return CLIENT or table.HasValue({"disfulversed", "admin", "superadmin"}, ply:GetUserGroup()) 
    end,
    CustomCheckFailMsg = "Только Disfulversed могут взять эту роль!",
    category = "Криминал",
})
--Criminal--


--Marauders--
TEAM_NAEB = DarkRP.createJob("Наёмник-мародер", { -- / 30 lvl
    color = Color(176, 196, 222, 255),
    model = {
        "models/player/Group03/male_04.mdl",
        "models/player/Group03/male_08.mdl",
        "models/player/Group03/male_09.mdl",
        "models/player/Group03/Male_05.mdl",
        "models/player/Group03/male_03.mdl",
        "models/player/Group03/Male_06.mdl" 
    },
    description = [[Незаурядный вооруженный бандит, работает за деньги.]],
    weapons = {},
    command = "p1gbged",
    max = 4,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = true,
    category = "Мародёры",
})
TEAM_HACKER = DarkRP.createJob("Хакер-взломщик", { -- / 35 lvl
    color = Color(176, 196, 222, 255),
    model = {
        "models/player/arctic.mdl"
    },
    description = [[Наёмник со знаниями в сфере электронных и компьютерных технологий. Хотя и про обычный механический взлом дверей, замков, etc тоже не стоит забывать. Работает за деньги.]],
    weapons = {"lockpick"},
    command = "ofsdaef",
    max = 2,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = true,
    category = "Мародёры",
})
TEAM_PMC = DarkRP.createJob("Оператор ЧВК [Dis+]", { -- / 50 lvl
    color = Color(176, 196, 222, 255),
    model = {
        "models/arty/codmw2022/mp/dmz/shadowcompany/smg/smg_pm.mdl"
    },
    description = [[Опытный боец ЧВК Scorpion, неизвестное прошлое, известные цели. Заработок денег. Работает на всех и ни на кого. Может заниматься чем угодно за деньги.]],
    weapons = {},
    command = "isdfgs",
    max = 3,
    salary = 15,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = true,
    customCheck = function(ply) 
        return CLIENT or table.HasValue({"disfulversed", "admin", "superadmin"}, ply:GetUserGroup()) 
    end,
    CustomCheckFailMsg = "Только Disfulversed могут взять эту роль!",
    category = "Мародёры",
})
--Marauders--


--Government--
TEAM_PATP = DarkRP.createJob("Патрульная полиция", { -- / 10 lvl
    color = Color(0, 0, 255, 255),
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
    description = [[Патрульный отдел полиции специализируется на выполнении операций низкой сложности. В их обязанности входит: охрана стратегически важных объектов, поддержание общественного порядка и реагирование на события, бытовой, для полицейского, сложности.]],
    weapons = {"weapon_rpt_finebook", "weapon_rpt_handcuff", "weapon_rpt_stungun", "weaponchecker", "door_ram"},
    command = "usdbsdgar",
    max = 10,
    salary = 10,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = true,
    category = "Правительство",
})
TEAM_SPEZ = DarkRP.createJob("Спецназ CTSFO", { -- / 30 lvl
    color = Color(0, 0, 255, 255),
    model = {
        "models/arty/codmw2019/mp/coalition/ctsfo/ctsfo_pm.mdl"
    },
    description = [[Отдел быстрого реагирования специализирующийся на решении операций средней сложности. Занимаются обеспечением безопасности и охраной стратегически значимых объектов, а также выполнением прочих задач, связанных с поддержанием общественного порядка и безопасности.]],
    weapons = {"weapon_rpt_finebook", "weapon_rpt_handcuff", "weapon_rpt_stungun", "weaponchecker", "door_ram"},
    command = "ybsdxce",
    max = 5,
    salary = 15,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = true,
    category = "Правительство",
})
TEAM_DET = DarkRP.createJob("Детектив", { -- / 35 lvl
    color = Color(0, 0, 255, 255),
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
    description = [[Занимается проведением расследований и внедрением своих людей в криминальный мир. Взаимодействует с Отделом Безопасности в рамках своей деятельности.]],
    weapons = {"weapon_rpt_finebook", "weapon_rpt_handcuff", "weapon_rpt_stungun", "weaponchecker", "door_ram"},
    command = "rsdffggggbn",
    max = 1,
    salary = 25,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = true,
    category = "Правительство",
})
TEAM_DISAG = DarkRP.createJob("Отдел Disag [Dis+]", { -- / 45 lvl
    color = Color(0, 0, 255, 255),
    model = {
        "models/bread/cod/characters/milsim/shadow_company.mdl"
    },
    description = [[Специальное военное подразделение, специализирующееся на проведениях рейдов, захватах стратегических точек, штурмах и других сложных тактических военных операциях. Согласно слухам, члены этого подразделения предположительно являются бывшими наемниками.]],
    weapons = {"weapon_rpt_finebook", "weapon_rpt_handcuff", "weapon_rpt_stungun", "weaponchecker", "door_ram"},
    command = "tsdg444",
    max = 3,
    salary = 25,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = true,
    customCheck = function(ply) 
        return CLIENT or table.HasValue({"disfulversed", "admin", "superadmin"}, ply:GetUserGroup()) 
    end,
    CustomCheckFailMsg = "Только Disfulversed могут взять эту роль!",
    category = "Правительство",
})
TEAM_OTDELBEZ = DarkRP.createJob("Отдел Безопасности", { --/ 45 lvl
    color = Color(0, 0, 255, 255),
    model = {
        "models/bread/cod/characters/kortac/horangi_kpop.mdl"
    },
    description = [[Орган, ответственный за обеспечение безопасности и защиты Администрации города, осуществляет решение важных невоенных вопросов. В их компетенции входит: ведение расследований внутри государственных структур, выявление и преследование особо опасных преступников.]],
    weapons = {"weapon_rpt_finebook", "weapon_rpt_handcuff", "weapon_rpt_stungun", "weaponchecker", "door_ram"},
    command = "wkloldd",
    max = 2,
    salary = 30,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = true,
    --[[bodygroups = {
        ["pathes"] = {1},
        ["legs"] = {0,1,2,3,4,5},
        ["beanies"] = {0,1,2},
        ["glasses"] = {0,1},
    }]]
    category = "Правительство",
})
TEAM_MAYOR = DarkRP.createJob("Администратор города", { -- / 75 lvl
    color = Color(255, 0, 0, 255),
    model = {
        "models/player/suits/group3/male_09_open.mdl"
    },
    description = [[Администратор города, обладающий полномочиями по управлению городом и решению различных проблем, в том числе принятия мер, таких как объявление комендантского часа. В случае занятия должности мэра, вся полнота власти переходит в его ведение.]],
    weapons = {"weaponchecker"},
    command = "gfvdcze",
    max = 1,
    salary = 30,
    admin = 0,
    vote = true,
    hasLicense = true,
    mayor = true,
    candemote = true,
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
    salary = 0,
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
--Government--


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
AddDoorGroup("Правительство", TEAM_POLICE, TEAM_MAYOR, TEAM_SPEZ, TEAM_DET, TEAM_PATP, TEAM_OTDELBEZ, TEAM_DISAG)
AddDoorGroup("Бар [В Погоне за Пивом]", TEAM_MAF)

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
DarkRP.addHitmanTeam(TEAM_HACKER)
DarkRP.addHitmanTeam(TEAM_PMC)