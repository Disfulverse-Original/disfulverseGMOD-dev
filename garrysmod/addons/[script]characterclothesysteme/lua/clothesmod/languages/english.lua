----- DO NOT TOUCH THAT -----
----- DO NOT TOUCH THAT -----
----- DO NOT TOUCH THAT -----
local function GetCurrentLuaFile()
    local source = debug.getinfo(2, "S").source
    if source:sub(1,1) == "@" then
        return source:sub(2)
    else
        error("Caller was not defined in a file", 2)
    end
end

local function GetCurrentLuaFileName()
	local luafile = GetCurrentLuaFile()

	local split = string.Split( luafile, "/")

	return split[#split]
end

local filename_wl = GetCurrentLuaFileName()
local filename = string.Replace(filename_wl, ".lua")
-------------------------------

CLOTHESMOD.Config.Sentences[1][filename] = "Add"
CLOTHESMOD.Config.Sentences[2][filename] = "Images edition"
CLOTHESMOD.Config.Sentences[3][filename] = "Image"
CLOTHESMOD.Config.Sentences[4][filename] = "Remove"
CLOTHESMOD.Config.Sentences[5][filename] = "Texts edition"
CLOTHESMOD.Config.Sentences[6][filename] = "Text"
CLOTHESMOD.Config.Sentences[7][filename] = "Choose your t-shirt"
CLOTHESMOD.Config.Sentences[8][filename] = "Create your t-shirt"
CLOTHESMOD.Config.Sentences[9][filename] = "Do you want to create this custom t-shirt?"
CLOTHESMOD.Config.Sentences[10][filename] = "Error"
CLOTHESMOD.Config.Sentences[11][filename] = "You have to customize the t-shirt"
CLOTHESMOD.Config.Sentences[12][filename] = "This name is already taken"
CLOTHESMOD.Config.Sentences[13][filename] = "Create"
CLOTHESMOD.Config.Sentences[14][filename] = "Choose your trousers"
CLOTHESMOD.Config.Sentences[15][filename] = "CHANGE"
CLOTHESMOD.Config.Sentences[16][filename] = "LIST OF CLOTHES"
CLOTHESMOD.Config.Sentences[17][filename] = "Корзина"
CLOTHESMOD.Config.Sentences[18][filename] = "Итого"
CLOTHESMOD.Config.Sentences[19][filename] = "Закрыть"
CLOTHESMOD.Config.Sentences[20][filename] = "Ассортимент"
CLOTHESMOD.Config.Sentences[21][filename] = "В корзину"
CLOTHESMOD.Config.Sentences[22][filename] = "You already own this"
CLOTHESMOD.Config.Sentences[23][filename] = "Купить"
CLOTHESMOD.Config.Sentences[24][filename] = "Индивидуал"
CLOTHESMOD.Config.Sentences[25][filename] = "Drop your clothes"
CLOTHESMOD.Config.Sentences[26][filename] = "Drop the top shirt"
CLOTHESMOD.Config.Sentences[27][filename] = "Drop the bottom pants"
CLOTHESMOD.Config.Sentences[28][filename] = "Welcome"
CLOTHESMOD.Config.Sentences[29][filename] = "CONFIRM"
CLOTHESMOD.Config.Sentences[30][filename] = "BACK"
CLOTHESMOD.Config.Sentences[31][filename] = "Choose your name"
CLOTHESMOD.Config.Sentences[32][filename] = "Choose your sex"
CLOTHESMOD.Config.Sentences[33][filename] = "Choose the color of your eyes"
CLOTHESMOD.Config.Sentences[34][filename] = "Choose your head"
CLOTHESMOD.Config.Sentences[35][filename] = "CONTINUE"
CLOTHESMOD.Config.Sentences[36][filename] = "You can not do this in this job."
CLOTHESMOD.Config.Sentences[37][filename] = "You don't have any top shirt"
CLOTHESMOD.Config.Sentences[38][filename] = "You don't have any bottom pants"
CLOTHESMOD.Config.Sentences[39][filename] = "You have dropped your top shirt"
CLOTHESMOD.Config.Sentences[40][filename] = "You have dropped your bottom pants"
CLOTHESMOD.Config.Sentences[41][filename] = "You don't have enough money!"
CLOTHESMOD.Config.Sentences[42][filename] = "You have went through surgery"
CLOTHESMOD.Config.Sentences[43][filename] = "Your clothes have been bought, and are now in your wardrobe"
CLOTHESMOD.Config.Sentences[44][filename] = "Your t-shirt has been bought, and are now in your wardrobe"
CLOTHESMOD.Config.Sentences[45][filename] = "You have changed your clothes"
CLOTHESMOD.Config.Sentences[46][filename] = "It is already your name!"
CLOTHESMOD.Config.Sentences[47][filename] = "Your name has been changed!"
CLOTHESMOD.Config.Sentences[48][filename] = "Your character has been created!"
CLOTHESMOD.Config.Sentences[49][filename] = "Wardrobe"
CLOTHESMOD.Config.Sentences[50][filename] = "This clothing is for the other sex"
CLOTHESMOD.Config.Sentences[51][filename] = "Clothes seller"
CLOTHESMOD.Config.Sentences[52][filename] = "Surgeon"
CLOTHESMOD.Config.Sentences[53][filename] = "Примечание: если вы поменяете свой пол, вся ваша одежда в гардеробе будет удалена!"
CLOTHESMOD.Config.Sentences[54][filename] = "Pay the surgery"
CLOTHESMOD.Config.Sentences[55][filename] = "Do you want to obtain this appearance ?"
CLOTHESMOD.Config.Sentences[56][filename] = "   Это будет стоить вам"
CLOTHESMOD.Config.Sentences[57][filename] = "You have not changed anything"
CLOTHESMOD.Config.Sentences[58][filename] = "Оплатить "
CLOTHESMOD.Config.Sentences[59][filename] = "Здравствуйте, вы хотите"
CLOTHESMOD.Config.Sentences[60][filename] = "изменить свой пол на другой?"
CLOTHESMOD.Config.Sentences[61][filename] = "Да, конечно!"
CLOTHESMOD.Config.Sentences[62][filename] = "Нет, спасибо"
CLOTHESMOD.Config.Sentences[63][filename] = ""
CLOTHESMOD.Config.Sentences[64][filename] = "Вы хотите изменить свое имя?"
CLOTHESMOD.Config.Sentences[65][filename] = "✓"
CLOTHESMOD.Config.Sentences[66][filename] = "Buy a customized top shirt"
CLOTHESMOD.Config.Sentences[67][filename] = "Buy the t-shirt"
CLOTHESMOD.Config.Sentences[68][filename] = "Your name and your first name must be at least 3 characters long"
CLOTHESMOD.Config.Sentences[69][filename] = "There is not any free bed. Retry later."
