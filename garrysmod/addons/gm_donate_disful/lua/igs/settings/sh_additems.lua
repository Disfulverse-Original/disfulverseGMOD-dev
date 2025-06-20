--[[-------------------------------------------------------------------------
	Обязательные методы:
		:SetPrice()
		:SetDescription()

	Популярные:
		:SetTerm()            --> Срок действия в днях (по умолчанию 0, т.е. одноразовая активация)
		:SetStackable()       --> Разрешает покупать несколько одинаковых предметов
		:SetCategory()        --> Группирует предметы
		:SetIcon()            --> Картинка или модель в качестве иконки
		:SetHighlightColor()  --> Цвет заголовка
		:SetDiscountedFrom()  --> Скидка
		:SetOnActivate()      --> Свое действие при активации
		:SetHidden()          --> Скрытый предмет

	Полезное:
		gm-donate.net/docs    -->  Подробнее о методах и все остальные
		gm-donate.net/support -->  Быстрая помощь и настройка от нас
		gm-donate.net/mods    -->  Бесплатные модули
---------------------------------------------------------------------------]]

-- Ниже примеры с объяснением

--[[-------------------------------------------------------------------------
	Разрешаем покупать отмычку а F4 только донатерам (DarkRP)
	https://img.qweqwe.ovh/1493244432112.png -- частичное объяснение
---------------------------------------------------------------------------]]

--[[
IGS("Отмычка", "otmichka") -- второй параметр не должен(!) повторяться с другими предметами
	:SetPrice(1) -- 1 рубль

	-- 0 - одноразовое (Т.е. купил, выполнилось OnActivate и забыл. Полезно для валюты)
	-- 30 - месяц, 7 - неделя и т.д. :SetPerma() - навсегда
	:SetTerm(30)

	:SetDarkRPItem("lockpick") -- реальный класс энтити
	:SetDescription("Разрешает вам покупать отмычку") -- описание
	:SetCategory("Оружие") -- категория

	-- квадратная ИКОНКА (Не обязательно). Отобразится на главной странице. Может быть с прозрачностью
	:SetIcon("http://i.imgur.com/4zfVs9s.png")

	-- БАННЕР 1000х400 (Не обязательно). Отобразится в подробностях итема
	:SetImage("http://i.imgur.com/RqsP5nP.png")
--]]

--[[-------------------------------------------------------------------------
	Доступ к энтити, оружию и машинам через спавнменю
---------------------------------------------------------------------------]]
--[[IGS("Арбалет с HL", "wep_arbalet"):SetWeapon("weapon_crossbow")
	:SetPrice(5000)
	:SetTerm(30)
	:SetDescription("Разрешает спавнить Арбалет через спавн меню в любое время")
	:SetIcon("models/weapons/w_crossbow.mdl", true) -- true значит, что указана моделька, а не ссылка]]

--[[IGS("Джип с HL", "veh_jeep"):SetVehicle("Jeep")
	:SetPrice(2000)
	:SetTerm(30)
	:SetDescription("Разрешает спавнить джип с халвы через спавн меню в любое время")]]



--[[-------------------------------------------------------------------------
	Гмод тулы
---------------------------------------------------------------------------]]
--[[IGS("Доступ к Веревке","verevka_na_mesyac"):SetTool("rope")
	:SetPrice(50)
	:SetTerm(30) -- 30 дней
	:SetDescription("Для соединения двух объектов или написания матов на стенах :)")

IGS("Доступ к Лебёдке","lebedka_navsegda"):SetTool("winch")
	:SetPrice(100)
	:SetPerma()
	:SetDescription("Лебёдка это веревка, способная становиться короче или длиннее")]]


--[[-------------------------------------------------------------------------
	"Паки" предметов и скрытые предметы
	В примере ниже мы создаем скрытый предмет "Аптечка", который НЕ отображается в магазине
	и видимый предмет "Набор аптечек". После активации набора игрок получит в инвентарь 5 аптечек
	Это полезно, если вы не хотите продавать по 1 аптечке или хотите делать скидку за опт
---------------------------------------------------------------------------]]
--[[local HEAL = IGS("Аптечка", "heal_10hp", 0)
	:SetDescription("Добавляет вам 10 хп")
	:SetStackable()
	:SetHidden()
	:SetOnActivate(function(pl) pl:SetHealth(pl:Health() + 10) end)

IGS("Набор аптечек", "heal_x5", 20)
	:SetDescription("Вы получите в инвентарь 5 аптечек")
	:SetStackable()
	:SetItems({HEAL, HEAL, HEAL, HEAL, HEAL}) -- вы можете использовать и разные предметы]]



-- Дальше примеры, которые нужно раскомментировать, чтобы работали (убрать "--[[" в начале)

--[[-------------------------------------------------------------------------
	Игровая валюта для DarkRP
	Здесь SetTerm не обязателен, т.к. срок ни на что не влияет
	Обратите внимание, цена указана третьим параметром. Так тоже можно
---------------------------------------------------------------------------]]
-- IGS("100 тысяч", "100k_deneg", 200):SetDarkRPMoney(100000)
-- IGS("500 тысяч", "500k_deneg", 450):SetDarkRPMoney(500000)



--[[-------------------------------------------------------------------------
	Доступ к DarkRP профессиям
---------------------------------------------------------------------------]]
--[[
IGS("Бомж", "team_hobo")
	:SetDarkRPTeams("hobo") -- одна тима (command)
	:SetCategory("Доступ к работам")
	:SetDescription("Вы сможете месяц работать бомжом :)")
	:SetPrice(50)
	:SetTerm(30)

IGS("Продвинутые воры", "team_thieves")
	:SetDarkRPTeams("advthief", "ultrathief") -- можно несколько
	:SetCategory("Доступ к работам")
	:SetDescription("Вам станут доступны работы продвинутого и ультравора")
	:SetPrice(200)
	:SetTerm(30)
--]]



--[[-------------------------------------------------------------------------
	Донат группы ULX
---------------------------------------------------------------------------]]
--[[
IGS("VIP на месяц", "vip_na_mesyac"):SetULXGroup("vip")
	:SetPrice(150)
	:SetTerm(30) -- 30 дней
	:SetCategory("Группы")
	:SetDescription("С этой покупкой вы станете офигенными, потому что в ней воооот такая куча крутых возможностей")

IGS("PREMIUM навсегда", "premium_navsegda"):SetULXGroup("premium")
	:SetPrice(400)
	:SetPerma() -- навсегда
	:SetCategory("Группы")
	:SetDescription("А с этой покупкой еще офигеннее, чем с покупкой VIP")
--]]

IGS("Серебро x50", "credits_50", 0)
    :SetDescription("Выдаёт 50 серебра игроку для покупи в Credit Store")
    :SetPrice(199)
    :SetCategory("Серебро")
    :SetStackable(true)  -- Разрешаем множественное использование
    :SetOnActivate(function(pl) RunConsoleCommand("onyx_give_credits", pl:SteamID64(), "50") end)

IGS("Серебро x100", "credits_100", 0)
    :SetDescription("Выдаёт 100 серебра игроку для покупи в Credit Store")
    :SetPrice(399)
    :SetCategory("Серебро")
    :SetStackable(true)  -- Разрешаем множественное использование
    :SetOnActivate(function(pl) RunConsoleCommand("onyx_give_credits", pl:SteamID64(), "100") end)

IGS("Серебро x150", "credits_150", 0)
    :SetDescription("Выдаёт 150 серебра игроку для покупи в Credit Store")
    :SetPrice(549)
    :SetCategory("Серебро")
    :SetStackable(true)  -- Разрешаем множественное использование
    :SetOnActivate(function(pl) RunConsoleCommand("onyx_give_credits", pl:SteamID64(), "150") end)

IGS("Серебро x200", "credits_200", 0)
    :SetDescription("Выдаёт 200 серебра игроку для покупи в Credit Store")
    :SetPrice(649)
    :SetCategory("Серебро")
    :SetStackable(true)  -- Разрешаем множественное использование
    :SetOnActivate(function(pl) RunConsoleCommand("onyx_give_credits", pl:SteamID64(), "200") end)

IGS("Серебро x250", "credits_250", 0)
    :SetDescription("Выдаёт 250 серебра игроку для покупи в Credit Store")
    :SetPrice(849)
    :SetCategory("Серебро")
    :SetStackable(true)  -- Разрешаем множественное использование
    :SetOnActivate(function(pl) RunConsoleCommand("onyx_give_credits", pl:SteamID64(), "250") end)

IGS("Серебро x300", "credits_300", 0)
    :SetDescription("Выдаёт 300 серебра игроку для покупи в Credit Store")
    :SetPrice(1000)
    :SetCategory("Серебро")
    :SetStackable(true)  -- Разрешаем множественное использование
    :SetOnActivate(function(pl) RunConsoleCommand("onyx_give_credits", pl:SteamID64(), "300") end)        



--[[-------------------------------------------------------------------------
	Другое
---------------------------------------------------------------------------]]
-- Продажа говорилки        : https://forum.gm-donate.net/t/1059
-- Продажа моделек игрока   : https://forum.gm-donate.net/t/1003
-- Увеличение лимита пропов : https://forum.gm-donate.net/t/481/2
-- Тестовая VIP и тд        : https://forum.gm-donate.net/t/369
-- Доп. броня при спавне    : https://forum.gm-donate.net/t/395/10
