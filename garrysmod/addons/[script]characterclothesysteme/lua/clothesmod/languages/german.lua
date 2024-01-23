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

CLOTHESMOD.Config.Sentences[1][filename] = "hinzufügen"
CLOTHESMOD.Config.Sentences[2][filename] = "Bilder bearbeiten"
CLOTHESMOD.Config.Sentences[3][filename] = "Image"
CLOTHESMOD.Config.Sentences[4][filename] = "Entfernen"
CLOTHESMOD.Config.Sentences[5][filename] = "Textausgabe"
CLOTHESMOD.Config.Sentences[6][filename] = "Text"
CLOTHESMOD.Config.Sentences[7][filename] = "Wähle dein T-Shirt aus"
CLOTHESMOD.Config.Sentences[8][filename] = "Gestalte dein T-Shirt"
CLOTHESMOD.Config.Sentences[9][filename] = "Möchten Sie dieses T-Shirt individuell gestalten?"
CLOTHESMOD.Config.Sentences[10][filename] = "Fehler"
CLOTHESMOD.Config.Sentences[11][filename] = "Du musst das T-Shirt anpassen."
CLOTHESMOD.Config.Sentences[12][filename] = "Dieser Name ist bereits vergeben"
CLOTHESMOD.Config.Sentences[13][filename] = "erstellen"
CLOTHESMOD.Config.Sentences[14][filename] = "Wählen Sie Ihre Hose"
CLOTHESMOD.Config.Sentences[15][filename] = "ÄNDERUNG"
CLOTHESMOD.Config.Sentences[16][filename] = "KLEIDERLISTE"
CLOTHESMOD.Config.Sentences[17][filename] = "Wagen/Korb"
CLOTHESMOD.Config.Sentences[18][filename] = "Gesamtsumme"
CLOTHESMOD.Config.Sentences[19][filename] = "SCHLIEßEN"
CLOTHESMOD.Config.Sentences[20][filename] = "Geschäft"
CLOTHESMOD.Config.Sentences[21][filename] = "In den Warenkorb"
CLOTHESMOD.Config.Sentences[22][filename] = "Das gehört dir bereits"
CLOTHESMOD.Config.Sentences[23][filename] = "KAUFEN"
CLOTHESMOD.Config.Sentences[24][filename] = "kundengerecht angefertigt"
CLOTHESMOD.Config.Sentences[25][filename] = "Kleidung fallenlassen"
CLOTHESMOD.Config.Sentences[26][filename] = "T-Shirt fallenlassen"
CLOTHESMOD.Config.Sentences[27][filename] = "Hose fallenlassen"
CLOTHESMOD.Config.Sentences[28][filename] = "Willkommen"
CLOTHESMOD.Config.Sentences[29][filename] = "BESTÄTIGEN"
CLOTHESMOD.Config.Sentences[30][filename] = "ZURÜCK"
CLOTHESMOD.Config.Sentences[31][filename] = "Wähle deinen Namen"
CLOTHESMOD.Config.Sentences[32][filename] = "Wähle dein Geschlecht"
CLOTHESMOD.Config.Sentences[33][filename] = "Wähle deine Augenfarbe"
CLOTHESMOD.Config.Sentences[34][filename] = "Wähle deinen Kopf"
CLOTHESMOD.Config.Sentences[35][filename] = "FORTFAHREN"
CLOTHESMOD.Config.Sentences[36][filename] = "Das kannst du in diesem Job nicht machen."
CLOTHESMOD.Config.Sentences[37][filename] = "Du hast kein Oberteil."
CLOTHESMOD.Config.Sentences[38][filename] = "Du hast keine Hose"
CLOTHESMOD.Config.Sentences[39][filename] = "Du hast dein Oberteil fallengelassen"
CLOTHESMOD.Config.Sentences[40][filename] = "Du hast deine Hose fallengelassen"
CLOTHESMOD.Config.Sentences[41][filename] = "Du hast nicht genug Geld!"
CLOTHESMOD.Config.Sentences[42][filename] = "Du bist operiert worden."
CLOTHESMOD.Config.Sentences[43][filename] = "Deine Kleidung wurde gekauft und ist jetzt in deiner Garderobe."
CLOTHESMOD.Config.Sentences[44][filename] = "Dein T-Shirt wurde gekauft und ist jetzt in deiner Garderobe."
CLOTHESMOD.Config.Sentences[45][filename] = "Du hast dich umgezogen"
CLOTHESMOD.Config.Sentences[46][filename] = "Es ist bereits dein Name!"
CLOTHESMOD.Config.Sentences[47][filename] = "Dein Name wurde geändert!"
CLOTHESMOD.Config.Sentences[48][filename] = "Dein Charakter wurde erschaffen!"
CLOTHESMOD.Config.Sentences[49][filename] = "Garderobe"
CLOTHESMOD.Config.Sentences[50][filename] = "Diese Kleidung ist für das andere Geschlecht."
CLOTHESMOD.Config.Sentences[51][filename] = "Kleiderverkäufer"
CLOTHESMOD.Config.Sentences[52][filename] = "Chirurg"
CLOTHESMOD.Config.Sentences[53][filename] = "Hinweis: Wenn Du dein Geschlecht änderst, werden alle deine Kleider in deinem Kleiderschrank entfernt!"
CLOTHESMOD.Config.Sentences[54][filename] = "Bezahle die Operation"
CLOTHESMOD.Config.Sentences[55][filename] = "Willst du dieses dieses Aussehen erhalten?"
CLOTHESMOD.Config.Sentences[56][filename] = "Das kostet"
CLOTHESMOD.Config.Sentences[57][filename] = "Du hast nichts geändert."
CLOTHESMOD.Config.Sentences[58][filename] = "Bezahlen"
CLOTHESMOD.Config.Sentences[59][filename] = "Hallo, möchtest du etwas ändern"
CLOTHESMOD.Config.Sentences[60][filename] = "Erscheinung mit plastischen Chirurgen?"
CLOTHESMOD.Config.Sentences[61][filename] = "JA!"
CLOTHESMOD.Config.Sentences[62][filename] = "NEIN, DANKE!"
CLOTHESMOD.Config.Sentences[63][filename] = "Ändere deinen Namen"
CLOTHESMOD.Config.Sentences[64][filename] = "Willst du deinen Namen ändern?"
CLOTHESMOD.Config.Sentences[65][filename] = "Ändere meinen Namen!"
CLOTHESMOD.Config.Sentences[66][filename] = "Kaufe ein individuelles Oberteil"
CLOTHESMOD.Config.Sentences[67][filename] = "Kaufe das T-Shirt"
CLOTHESMOD.Config.Sentences[68][filename] = "Dein Vor- und Nachname muss mindestens 3 Zeichen haben"
CLOTHESMOD.Config.Sentences[69][filename] = "Es gibt kein freies Bett. Versuche es später"