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

CLOTHESMOD.Config.Sentences[1][filename] = "Ajouter"
CLOTHESMOD.Config.Sentences[2][filename] = "Edition des images"
CLOTHESMOD.Config.Sentences[3][filename] = "Image"
CLOTHESMOD.Config.Sentences[4][filename] = "Supprimer"
CLOTHESMOD.Config.Sentences[5][filename] = "Edition des textes"
CLOTHESMOD.Config.Sentences[6][filename] = "Texte"
CLOTHESMOD.Config.Sentences[7][filename] = "Choisi ton t-shirt"
CLOTHESMOD.Config.Sentences[8][filename] = "Créer le t-shirt"
CLOTHESMOD.Config.Sentences[9][filename] = "Veux-tu créer ce t-shirt personnalisé?"
CLOTHESMOD.Config.Sentences[10][filename] = "Erreur"
CLOTHESMOD.Config.Sentences[11][filename] = "Tu dois personnaliser le t-shirt"
CLOTHESMOD.Config.Sentences[12][filename] = "Ce nom est déjà utilisé"
CLOTHESMOD.Config.Sentences[13][filename] = "Créer"
CLOTHESMOD.Config.Sentences[14][filename] = "Choisi ton pantalon"
CLOTHESMOD.Config.Sentences[15][filename] = "CHANGER"
CLOTHESMOD.Config.Sentences[16][filename] = "LISTE DES VÊTEMENTS"
CLOTHESMOD.Config.Sentences[17][filename] = "Panier"
CLOTHESMOD.Config.Sentences[18][filename] = "Total"
CLOTHESMOD.Config.Sentences[19][filename] = "FERMER"
CLOTHESMOD.Config.Sentences[20][filename] = "Boutique"
CLOTHESMOD.Config.Sentences[21][filename] = "Ajouter au panier"
CLOTHESMOD.Config.Sentences[22][filename] = "Vous possédez déjà ça"
CLOTHESMOD.Config.Sentences[23][filename] = "ACHETER"
CLOTHESMOD.Config.Sentences[24][filename] = "Customisé"
CLOTHESMOD.Config.Sentences[25][filename] = "Jete tes vêtements"
CLOTHESMOD.Config.Sentences[26][filename] = "Jete ton haut"
CLOTHESMOD.Config.Sentences[27][filename] = "Jete ton bas"
CLOTHESMOD.Config.Sentences[28][filename] = "Bienvenue"
CLOTHESMOD.Config.Sentences[29][filename] = "CONFIRMER"
CLOTHESMOD.Config.Sentences[30][filename] = "RETOUR"
CLOTHESMOD.Config.Sentences[31][filename] = "Choisi ton nom"
CLOTHESMOD.Config.Sentences[32][filename] = "Choisi ton sexe"
CLOTHESMOD.Config.Sentences[33][filename] = "Choisi la couleur de tes yeux"
CLOTHESMOD.Config.Sentences[34][filename] = "Choisi ta tête"
CLOTHESMOD.Config.Sentences[35][filename] = "CONTINUER"
CLOTHESMOD.Config.Sentences[36][filename] = "Tu ne peux pas faire ça dans ce métier."
CLOTHESMOD.Config.Sentences[37][filename] = "Tu n'as pas de haut"
CLOTHESMOD.Config.Sentences[38][filename] = "Tu n'as pas de bas"
CLOTHESMOD.Config.Sentences[39][filename] = "Tu as jeté ton haut"
CLOTHESMOD.Config.Sentences[40][filename] = "Tu as jeté ton bas"
CLOTHESMOD.Config.Sentences[41][filename] = "Tu n'as pas assez d'argent!"
CLOTHESMOD.Config.Sentences[42][filename] = "Tu t'es fait opéré"
CLOTHESMOD.Config.Sentences[43][filename] = "Tes vêtements ont été achetés, et sont maintenant dans ta garde-robe"
CLOTHESMOD.Config.Sentences[44][filename] = "Ton t-shirt a été acheté, et est maintenant dans ta garde-robe"
CLOTHESMOD.Config.Sentences[45][filename] = "Tu as changé tes vêtements"
CLOTHESMOD.Config.Sentences[46][filename] = "C'est déjà ton nom!"
CLOTHESMOD.Config.Sentences[47][filename] = "Ton nom a été changé!"
CLOTHESMOD.Config.Sentences[48][filename] = "Ton personnage a été créé!"
CLOTHESMOD.Config.Sentences[49][filename] = "Garde-robe"
CLOTHESMOD.Config.Sentences[50][filename] = "Ce vêtement est pour un autre sexe"
CLOTHESMOD.Config.Sentences[51][filename] = "Vendeur de vêtements"
CLOTHESMOD.Config.Sentences[52][filename] = "Chirurgien"
CLOTHESMOD.Config.Sentences[53][filename] = "Note : si tu changes ton sexe, tous tes vêtements dans ta garde-robe seront supprimés!"
CLOTHESMOD.Config.Sentences[54][filename] = "Payer la chirurgie"
CLOTHESMOD.Config.Sentences[55][filename] = "Veux-tu obtenir cette apparence ?"
CLOTHESMOD.Config.Sentences[56][filename] = "Cela va coûter"
CLOTHESMOD.Config.Sentences[57][filename] = "Tu n'as rien changé"
CLOTHESMOD.Config.Sentences[58][filename] = "Payer"
CLOTHESMOD.Config.Sentences[59][filename] = "Bonjour, voudrais-tu changer ton"
CLOTHESMOD.Config.Sentences[60][filename] = "apparence par chirurgie plastique?"
CLOTHESMOD.Config.Sentences[61][filename] = "OUI!"
CLOTHESMOD.Config.Sentences[62][filename] = "NON, MERCI!"
CLOTHESMOD.Config.Sentences[63][filename] = "Changer ton nom"
CLOTHESMOD.Config.Sentences[64][filename] = "Veux-tu changer ton nom?"
CLOTHESMOD.Config.Sentences[65][filename] = "Changer mon nom!"
CLOTHESMOD.Config.Sentences[66][filename] = "Acheter un haut personnalisé"
CLOTHESMOD.Config.Sentences[67][filename] = "Acheter le t-shirt"
CLOTHESMOD.Config.Sentences[68][filename] = "Ton nom et ton prénom doivent faire au moins 3 caractères"
CLOTHESMOD.Config.Sentences[69][filename] = "Il n'y a aucun lit de libre. Réessayez plus tard."
