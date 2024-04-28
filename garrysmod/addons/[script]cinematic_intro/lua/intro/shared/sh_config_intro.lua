--Texte qui s'affiche quand le joueur rejoint le serveur
Intro.Settings.Title = "• Disfulverse // DarkRPG // ОБТ // Оптимизация •"

--Mettre en fond un effet pour pour le panel quand le joueur rejoint le serveur ?
Intro.Settings.Blur = true

--Mettre un fond de couleur pour pour le panel quand le joueur rejoint le serveur ? (Intro.Settings.Blur doit être sur false)
Intro.Settings.BGColor = Color(0,0,0,255)

--Commande permettant au joueur de lancer l'intro quand il veux (laisser vide pour désactiver)
Intro.Settings.Commande = "/st1artin1tro"

--Afficher le menu quand le joueur rejoint le serveur à chauqe fois ou ne plus l'afficher quand il a vu au moins une fois l'intro ?
Intro.Settings.AlwaysShow = false

--Permet de retirer le boutton "Passer l'introduction"
Intro.Settings.ForceIntro = true

--Lien de la musique (les liens youtubes ne fonctionne pas)
Intro.Settings.URLMusic = "https://tutomtx.mtxserv.com/Dennis%20Lloyd%20-%20NEVERMIND.mp3"

--Volume de la musique (entre 0 et 1)
Intro.Settings.MusicVolume = 0.3

--Faire un retour sur le joueur une fois l'intro fini ?
Intro.Settings.AnimReturnPlayer = true

--Hauteur de la caméra sur le retour au joueur
Intro.Settings.AnimReturnPlayerHigh = 900

--Vitesse de la caméra sur le retour au joueur
Intro.Settings.Speedback = 0.2

--Texte sur le retour au joueur
Intro.Settings.textend = "Удачи вам в развитии на сервере, и пусть ваши приключения будут захватывающими!"

Intro.Settings.Camera = { 


    {
        startpos = Vector(-6501.146484, 1116.536987, -471.963715), --Position de base (getpos dans la console pour avoir la position)
        endpos = Vector(-5867.985840, 1118.801880, -300.345123), --Position finale
        startang = Angle(-18.590103, 0.990973, 0.000000), --Angle de base (getpos dans la console pour avoir la position)
        endang = Angle(-0.143272, 0.314912, 0.000000), --Angle finial
        text = "Добро пожаловать на Disfulverse // DarkRPG", --Texte afficher en bas de l'écran
        speed = 0.2, --Vitesse de la caméra
        makefade = true, --Faire un fondu lors de la transition de caméra ?
    },
    {
        startpos = Vector(-4687.106934, 1306.127930, -308.411316),
        endpos = Vector(-4692.697754, 1021.194763, -308.410706),
        startang = Angle(12.168842, -64.244797, 0.000000),
        endang = Angle(12.072375, 59.570435, 0.000000),
        text = "На сервере у вас есть возможность стать обычным разнорабочим или уборщиком мусора...",
        speed = 0.1,
        makefade = true,
    },
    {
        startpos = Vector(-3112.952637, 813.624023, -804.814026),
        endpos = Vector(-2816.778076, 225.232758, -810.813660),
        startang = Angle(9.416752, -56.285561, 0.000000),
        endang = Angle(5.746690, -117.902634, 0.000000),
        text = "Или же взять в руки кирку с топором и отправиться добывать ценные ресурсы!",
        speed = 0.1,
        makefade = true,
    },
    {
        startpos = Vector(-577.099426, 2143.620605, -223.157455),
        endpos = Vector(-437.162903, 2568.069336, -232.352081),
        startang = Angle(4.685573, 34.500122, 0.000000),
        endang = Angle(4.878998, -39.963020, 0.000000),
        text = "Отправляйтесь на поиски нанимателей, которые распределены по различным точкам карты. Выберите профессию из четырех доступных категорий",
        speed = 0.1,
        makefade = true,
    },
    {
        startpos = Vector(-514.432678, 534.727234, -287.343506),
        endpos = Vector(-518.106384, 1333.267578, -239.470840),
        startang = Angle(-3.863338, 90.524391, 0.000000),
        endang = Angle(-3.380464, 90.138107, 0.000000),
        text = "Выберите свой путь: работайте в правительстве или окунитесь в мир криминала. Ваш выбор формирует вашу судьбу на сервере.",
        speed = 0.1,
        makefade = true,
    },
    {
        startpos = Vector(4503.748535, 2552.923584, -279.893677),
        endpos = Vector(3865.520020, 2734.075928, -279.705902),
        startang = Angle(4.635735, 144.605606, 0.000000),
        endang = Angle(10.526935, 96.702690, 0.000000),
        text = "Для приобретения квартиры обращайтесь к нашему специальному риелтору, который находится в банке.",
        speed = 0.1,
        makefade = true,
    },
    {
        startpos = Vector(1672.943604, 196.161194, -942.946045),
        endpos = Vector(1465.047363, -315.574738, -997.982239),
        startang = Angle(12.458555, -118.182167, 0.000000),
        endang = Angle(3.186843, 168.804092, 0.000000),
        text = "Исследуйте различные уголки карты, где вас ожидают мощные боссы, сразившись с которыми вы сможете получить ценные предметы для крафта и продажи.",
        speed = 0.1,
        makefade = true,
    },
    {
        startpos = Vector(2813.732178, -2834.824951, -278.785736),
        endpos = Vector(2973.448486, -3177.464111, -309.726654),
        startang = Angle(7.293242, -74.003952, 0.000000),
        endang = Angle(1.594728, -120.554031, 0.000000),
        text = "На сервере доступен аукцион, где вы можете выставлять предметы с высокой ценностью на продажу другим игрокам.",
        speed = 0.1,
        makefade = true,
    },
}