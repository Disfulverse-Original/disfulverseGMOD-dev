NC = {}
NC.Color = {}
NC.Language = {}

NC.NPCModel = "models/kleiner.mdl" --The model of the NPC

NC.NameChangeCost = 3000 --The price to change your name
NC.NotifyAll = true --Whether or not to notify the whole server once someone changes their name
NC.MaxAmtFirstName = 10 --The max amount of characters in a players first name
NC.MinAmtFirstName = 2 --The min amount of characters in a players first name
NC.MaxAmtLastName = 10 --The max amount of characters in a players last name
NC.MinAmtLastName = 2 --The min amount of characters in a players last name
NC.ServerName = "Disfulverse" --Name of your server, for when a player joins
NC.UseWhiteList = true --This uses the whitelist instead of the blacklist
NC.DisableChatCommand = true --This disables the ablity to type "/rpname" in chat
NC.AdminMenuCommand = "!nameadmin" --The command to bring up the admin menu.
NC.Admin = {--The ranks allowed to open the admin menu. {KEEP LOWERCASE}
	"superadmin",
}

NC.EntryType = "two"-- Options are two, one, or prefix. Two would be First and Last. One would be just Name. Prefix would be a prefix and name. {KEEP LOWERCASE}
NC.OnlyAllowOneSpace = true--Only allows the player to do one space. If using whitelist, you must have " " as one of your allowed. {THIS ONLY APPLIES WHEN NC.EntryType is equal to "one" or "prefix"}
--This below option, ONLY works with EntryType "two"
NC.AutoCapital = true --This will automatically capitalize the first character in the first name and the first character in the last name. It will lowercase the rest.

NC.WhiteList = {--If "UseWhiteList" is true, it uses this
	"q",
	"w",
	"e",
	"r",
	"t",
	"y",
	"u",
	"i",
	"o",
	"p",
	"a",
	"s",
	"d",
	"f",
	"g",
	"h",
	"j",
	"k",
	"l",
	"z",
	"x",
	"c",
	"v",
	"b",
	"n",
	"m",
	"1",
	" "
}

NC.Prefix = { --If set to prefix, it will use these.
	"Commander",
	"Officer",
	"Sgt.",
	"Mrs.",
	"Mr."
}

NC.BlackList = { --If "UseWhiteList" is false, it uses this
	"!",
	"@",
	"#",
	"$",
	"%",
	"^",
	"&",
	"*",
	"(",
	")",
	"-",
	"_",
	"=",
	"+",
	"/",
	"?",
	">",
	",",
	"<",
	"`",
	"~",
	"|",
	"'",
	'"',
	"[",
	"]",
	"{",
	"}",
	"1",
	"2",
	"3",
	"4",
	"5",
	"6",
	"7",
	"8",
	"9",
	"0",
	" "
}

NC.InnappropriateName = { --Names that are unable to be used
"anal",
"server",
"disfulverse",
"govno",
"anus",
"arse",
"ass",
"ballsack",
"balls",
"bastard",
"bitch",
"biatch",
"bloody",
"blowjob",
"blow job",
"bollock",
"bollok",
"boner",
"boob",
"bugger",
"bum",
"butt",
"buttplug",
"clitoris",
"cock",
"coon",
"crap",
"cunt",
"damn",
"dick",
"dildo",
"dyke",
"fag",
"feck",
"fellate",
"fellatio",
"felching",
"fuck",
"f u c k",
"fudgepacker",
"fudge packer",
"flange",
"Goddamn",
"God damn",
"hell",
"homo",
"jerk",
"jizz",
"knobend",
"knob end",
"labia",
"lmao",
"lmfao",
"muff",
"nigger",
"nigga",
"omg",
"penis",
"piss",
"poop",
"prick",
"pube",
"pussy",
"queer",
"scrotum",
"sex",
"shit",
"s hit",
"sh1t",
"slut",
"smegma",
"spunk",
"tit",
"tosser",
"turd",
"twat",
"vagina",
"wank",
"whore",
"wtf"
}

--Colors.
NC.Color.Header = Color(15, 15, 16, 245)
NC.Color.MainPage = Color(26, 26, 26, 245)
NC.Color.MainPageSecondary = Color(26, 26, 26)
NC.Color.Primary = Color(81, 201, 215)
NC.Color.MainPageText = Color(255, 255, 255)
NC.Color.HeaderText = Color(255, 255, 255)
NC.Color.EntryText = Color(5, 5, 5) 
NC.Color.CloseButton = Color(217, 76, 88)
NC.Color.AcceptButton = Color(81, 102, 237)


NC.Color.NPCName = Color(150, 150, 150, 255)

--Text Editing. Mainly for translation. If you edit below, I will not support.

NC.Language.MainTitle = " "
NC.Language.WelcomeMessage = "Добро пожаловать "
NC.Language.InfoText = "Вы можете изменить свое имя за $"..string.Comma(NC.NameChangeCost).."."
NC.Language.FirstName = "Имя:"
NC.Language.InvalidCharacter = "Вы пытаетесь использовать недопустимый символ: "
NC.Language.ExceedsAmount = "Ваше имя не может превышать "..NC.MaxAmtFirstName.." символов!"
NC.Language.NotEnoughAmount = "Ваше имя не может быть короче "..NC.MinAmtFirstName.." символов!"
NC.Language.BadWord = "Вы пытаетесь использовать неприемлемое слово."
NC.Language.GoodName = "Ваше имя в порядке!"
NC.Language.LastName = "Фамилия:"
NC.Language.OneEntry = "Имя"
NC.Language.Prefix = "Префикс:"
NC.Language.PrefixInfo = "Вы должны выбрать префикс!"
NC.Language.PrefixGood = "Ваш префикс подходит!"
NC.Language.OneSpace = "Вам разрешено использовать только один пробел!"
NC.Language.Selection = "Выберите префикс"
NC.Language.CheckChange = "Хотите изменить свое имя на"
NC.Language.CheckChangeAnswer1 = "ДА"
NC.Language.CheckChangeAnswer2 = "НЕТ"
NC.Language.ErrorInappropriate1 = "Одно из ваших имен содержит неприемлемый"
NC.Language.ErrorInappropriate2 = "термин!"
NC.Language.ErrorOk = "ОК"
NC.Language.ErrorUnauthorized1 = "Одно из ваших имен содержит"
NC.Language.ErrorUnauthorized2 = "недопустимый символ!"
NC.Language.ErrorNotEnoughCharacter1 = "Одно из ваших имен короче"
NC.Language.ErrorNotEnoughCharacter2 = "разрешенного предела!"
NC.Language.ErrorTooManyCharacter1 = "Одно из ваших имен превышает"
NC.Language.ErrorTooManyCharacter2 = "разрешенный предел!"
NC.Language.ErrorNonValidName = "Вы должны ввести допустимое имя!"
NC.Language.ErrorNameExists = "У вас уже есть такое имя!"
NC.Language.ErrorTooManySpaces1 = "Вы не можете использовать несколько"
NC.Language.ErrorTooManySpaces2 = "пробелов в вашем имени!"
NC.Language.OneCheckChange1 = "Хотите изменить свое имя на"
NC.Language.ErrorPrefix = "Вы должны выбрать префикс!"
NC.Language.ErrorCantAfford = "Вы не можете позволить себе оплатить"
NC.Language.ErrorCantAfford2 = "$"..string.Comma(NC.NameChangeCost).."!"
NC.Language.PreCheckChange1 = "Хотите изменить свое имя на"
NC.Language.ChangeButton = "ИЗМЕНИТЬ"
NC.Language.CancelButton = "ОТМЕНА"
NC.Language.NameChangePrefixChat = "[NC] "
NC.Language.NameTaken = "Имя '"
NC.Language.NameTaken1 = "' занято. Пожалуйста, попробуйте другое."
NC.Language.NameChanged = " изменил(а) свое имя на "
NC.Language.NameSetupTitle = "Выбор имени на сервере"
NC.Language.NameSetupWelcome = "Добро пожаловать на "..NC.ServerName..","
NC.Language.NameSetupInfo = "Пожалуйста, установите себе РП имя."
NC.Language.NameSetupConfirmation = "Хотите установить имя на"
NC.Language.AdminChangeInfo = "Пожалуйста, введите допустимое имя для этого игрока."
NC.Language.AdminButton1 = "Изменить"
NC.Language.AdminPanelTitle = "Панель администратора RP Name"
NC.Language.AdminPanelInfo = "Добро пожаловать в административную панель. Здесь вы можете изменять имя игрока."
NC.Language.AdminPanelInfo2 = "Выберите игрока и используйте одну из команд для него/нее!"
NC.Language.AdminPanelColumn = "Игроки"
NC.Language.AdminPanelColumn2 = "Команды"
NC.Language.CommandName = "Принудительное изменение имени"
NC.Language.PlayerSelect = "Вы должны выбрать "
NC.Language.PlayerSelect2 = "игрока!" 