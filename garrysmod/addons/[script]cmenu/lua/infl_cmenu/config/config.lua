-- SCROLL DOWN FOR THE IMPORTANT PART OF CONFIG
PIS.Config = {}
PIS.Config.Pings = {}
PIS.Config.PingsSorted = {}
PIS.Config.PingSets = {}

local Color = Color 

local yellow = 	Color(200, 200, 30)
local red = 	Color(200, 30, 30)
local blue = 	Color(30, 30, 200)
local ocean = 	Color(0,133,255)
local green = 	Color(30,200,30)
local info = 	Color(92,107,192)
local white = 	Color(255,255,255)
local black = 	Color(0,0,0)
local redy = 	Color(236, 136, 22)
local greeny = Color(87, 255, 3)
local violet = Color(186, 133, 255)
local lightsteel = Color(176, 196, 222)
local gold = Color(255, 215, 0)

function PIS.Config:AddMenu(id, mat, text, col, commands,cc)
	self.Pings[id] = {
		mat = mat,
		text = text,
		color = col,
		commands = commands,
		customcheck = cc,
		id = id
	}

	table.insert(self.PingsSorted, id)
end

-- Colors used. Should explain themselfes
PIS.Config.Colors = {
	Green = Color(46, 204, 113),
	Red = Color(230, 58, 64)
}
PIS.Config.BackgroundColor = Color(44, 44, 44)
PIS.Config.HighlightTabColor = Color(200, 25, 35)
PIS.Config.HighlightColor = Color(193, 70, 40)

PIS.Config.DefaultSettings = {
	PingSound = 1,
	PingOffscreen = 1,
	PingPulsating = 2,
	PingOverhead = 1,
	PingIconSet = 1, -- Change this to 2 if you want Sci-Fi to be default
	Scale = 1,
	DetectionScale = 1,
	PingAvatarVertices = 30,
	WheelDelay = 0.1,
	WheelKey = MOUSE_MIDDLE,
	--InteractionKey = KEY_F,
	WheelBlur = 1,
	WheelScale = 1,
	WheelMonochrome = 1
}

-- This is the settings for the wheel monochrome option.
-- { name, color }
PIS.Config.WheelColors = {
	[1] = { "Disabled", "none" },
	[2] = { "White", color_white },
	[3] = { "Blue", blue },
	[4] = { "Red", red },
	[5] = { "Green", Color(128, 177, 11) }
}


--[[

Синтаксис AddMenu:

1. id - делать таким же, как и название
2. иконка - писать только название, берется из materials/ping_system/
3. название - чек 1
4. цвет иконки - цвета есть на самом верху, но ничего не мешает тебе сделать их самому с помощью Color 
5. действие: если сделать это массивом (чек Деньги), то кнопка будет включать в себя меню, если функцией - одно действие
6(необ). customCheck - в каких случаях игроку доступна кнопка

]]



local LeadCP = {}

hook.Add("loadCustomDarkRPItems","inflexible.CMenu",function()

	LeadCP = 	{
		[TEAM_MAYOR] = true,
		[TEAM_CHIEF] = true,
				}

end)



--[[-------------------------------------------------------------------------

Обьяснение функций
PIS.OpenTextBox - Заголовок,Вопрос игроку, команда (здесб пользователь вписывает нужные данные в поле)
PIS.OpenPlyBox - Заголовок, Вопрос игроку, команда (в отличии от OpenTextBox, здесь пользователь выбирает игрока из списка)
PIS.OpenPlyReasonBox - Заголовок,Вопрос игроку,Второй вопрос игроку, команда (полезно для команд по типу wanted, demote etc)

---------------------------------------------------------------------------]]

PIS.Config:AddMenu("Деньги", 			"business", 		"Деньги", 				green, {

	{name = "Передать деньги", 	mat = "money_give", col = green, func = function() PIS.OpenTextBox("Передача денег","Сколько денег вы хотите дать этому игроку?", "/give") end},
	{name = "Бросить деньги", 	mat = "money_drop", col = green, func = function() PIS.OpenTextBox("Бросить деньги на пол","Сколько денег вы собираетесь бросить на пол?","/dropmoney") end},
	--{name = "Выписать чек", 	mat = "money", col = green, func = function() PIS.OpenPlyReasonBox("Выписать чек","Кому выписать чек?","На какую сумму?","/cheque") end},
	--{name = "Продать предмет", 	mat = "sell", col = green, func = function() RunConsoleCommand("say","/sell") end},


})

PIS.Config:AddMenu("RP Действия", 			"rp", 		"RP Действия", 			ocean, {


	{name = "Выбросить оружие", 	mat = "gun", col = white, func = function() RunConsoleCommand("say","/drop") end},
	{name = "Положить оружие в инвентарь", 			mat = "gun", col = white, func = function() RunConsoleCommand("say", "!holster") end},
	{name = "Попытка", 				mat = "success", col = white, func = function() PIS.OpenTextBox("Попытка","Укажите попытку","/try") end},
	{name = "Анонимный.чат", 				mat = "darkweb", col = black, func = function() PIS.OpenTextBox("Анонимный-чат","Ваше имя будет зашифровано","/ano") end},
	{name = "Бросить кубик", 		mat = "dice", col = white, func = function() RunConsoleCommand("say","/roll") end},
	{name = "Действие", 			mat = "default", col = white, func = function() PIS.OpenTextBox("Действие","Укажите действие","/me") end},
	{name = "Реклама", 				mat = "broadcast", col = white, func = function() PIS.OpenTextBox("Реклама","Укажите текст рекламы","/advert") end},
	{name = "Уволить", 				mat = "demote", col = white, func = function() PIS.OpenPlyReasonBox("Уволить игрока","Кого вы хотите уволить?","Укажите корректную причину увольнения","/demote") end},
	{name = "Продать все двери", 		mat = "door", col = white, func = function() RunConsoleCommand("say","/unownalldoors") end},

	--
	--


})   

PIS.Config:AddMenu("Остальное", 			"action", 		"Разное", 			info, {

	{name = "Написать администратору", 				mat = "admin_menu", col = red, func = function() PIS.OpenTextBox("Админ-чат","Укажите текст жалобы","@") end},
	{name = "Вид от 3 лица", 			mat = "third_person", col = redy, func = function() RunConsoleCommand("thirdperson_toggle") end},
	{name = "Способности", 			mat = "atom", col = violet, func = function() RunConsoleCommand("say", "!slevels") end},
	{name = "Поддержать проект", 			mat = "good", col = gold, func = function() RunConsoleCommand("say", "!store") end},


})

PIS.Config:AddMenu("SuperAdmin-only", 			"binary-code", 		"SuperAdmin-only", 			red, {

	{name = "Weapon.Customise", 			mat = "binary-code", col = red, func = function() RunConsoleCommand("say", "!project0") end},
	{name = "Zone.Creator", 			mat = "binary-code", col = red, func = function() RunConsoleCommand("brs_zone_editor") end},
	{name = "ATM.Admin", 			mat = "binary-code", col = red, func = function() RunConsoleCommand("say", "!adminatm") end},
	{name = "Name.Editor", 			mat = "binary-code", col = red, func = function() RunConsoleCommand("say", "!nameadmin") end},
	{name = "House.Editor", 			mat = "binary-code", col = red, func = function() RunConsoleCommand("say", "/rpsconfig") end},
	{name = "Accessory.Editor", 			mat = "binary-code", col = red, func = function() RunConsoleCommand("say", "/aasconfig") end},

},function(ply) return ply:IsSuperAdmin() end)

PIS.Config:AddMenu("Меню полиции", 		"police", 		"Меню полиции", 			blue, {


	{name = "Подать в розыск", 		mat = "police", col = red, func = function() PIS.OpenPlyReasonBox("Обьявить в розыск","Кого обьявить в розыск?","По какой причине?","/wanted") end},
	{name = "Выдать ордер", 		mat = "police", col = red, func = function() PIS.OpenPlyReasonBox("Выдача ордера","Кому вы хотите выдать ордер?","Обьясните свой выбор.","/warrant") end},
	{name = "Выдать лицензию", 		mat = "license", col = white, func = function() RunConsoleCommand("say", "/givelicense") end,  customcheck = function(ply) return ply:isCP() end},
	{name = "Начать ком. час", 		mat = "warning", col = redy, func = function() RunConsoleCommand("say", "/lockdown") end, customcheck = function(ply) return ply:isMayor() && !GetGlobalBool("DarkRP_LockDown") end},
	{name = "Окончить ком. час", 		mat = "warning", col = greeny, func = function() RunConsoleCommand("say", "/unlockdown") end, customcheck = function(ply) return ply:isMayor() && GetGlobalBool("DarkRP_LockDown") end},

},function(ply) return ply:isCP() end)



PIS.Config:AddMenu("Список заказов", 			"hitman", 		"Список заказов", 		    red,	  function() RunConsoleCommand("say","!requests")   end, function(ply) return Executioner.Config.Hitman_Teams[ team.GetName( ply:Team() ) ] end)
