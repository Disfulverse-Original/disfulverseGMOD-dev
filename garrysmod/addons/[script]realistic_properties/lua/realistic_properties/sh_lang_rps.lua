-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------

--[[
 _____           _ _     _   _       ______                          _   _           
| ___ \         | (_)   | | (_)      | ___ \                        | | (_)          
| |_/ /___  __ _| |_ ___| |_ _  ___  | |_/ / __ ___  _ __   ___ _ __| |_ _  ___  ___ 
|    // _ \/ _` | | / __| __| |/ __| |  __/ '__/ _ \| '_ \ / _ \ '__| __| |/ _ \/ __|
| |\ \  __/ (_| | | \__ \ |_| | (__  | |  | | | (_) | |_) |  __/ |  | |_| |  __/\__ \
\_| \_\___|\__,_|_|_|___/\__|_|\___| \_|  |_|  \___/| .__/ \___|_|   \__|_|\___||___/                          

]]
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-- German translation by Funny_TV 
-- French translation by Kobralost
-- English translation by Kobralost
-- Polish translation by Foxie
-- Polish translation by TheDenVX
-- Turkish translation by Wolflix

include("sh_config_rps.lua")

Realistic_Properties.Lang = {} 
Realistic_Properties.Lang[1] = {

	["en"] = "Select Door",
	["ru"] = "Выбрать Дверь",
	["fr"] = "Select Door",
	["de"] = "Tür auswählen",
	["pl"] = "Wybierz drzwi",
	["da"] = "Vælg Dør",
	["pt"] = "Escolha a porta",
    ["tr"] = "Kapi Sec",
	["cn"] = "选择门",

}

Realistic_Properties.Lang[2] = {

	["en"] = "Delivery Point",
	["ru"] = "Точка доставки",
	["fr"] = "Delivery Point",
	["de"] = "Übergabepunkt",
	["pl"] = "Punkt dostawy",
	["da"] = "Leverings Punkt",
	["pt"] = "Ponto de entrega",
    ["tr"] = "Teslim Noktasi",
	["cn"] = "交付地点",

}

Realistic_Properties.Lang[3] = {

	["en"] = "Camera Pos",
	["ru"] = "Позиция Камеры",
	["fr"] = "Camera Pos",
	["de"] = "Kamera Position",
	["pl"] = "Pozycja kamery",
	["da"] = "Kamera Pos",
	["pt"] = "Posição da camera",
    ["tr"] = "Kamera Konumu",
	["cn"] = "摄像机位置",

}

Realistic_Properties.Lang[4] = {

	["en"] = "Select Zone",
	["ru"] = "Выбрать зону",
	["fr"] = "Select Zone",
	["de"] = "Zone auswählen",
	["pl"] = "Zaznacz obszar",
	["da"] = "Vælg Zone",
	["pt"] = "Selecionar zona",
    ["tr"] = "Alan Sec",
	["cn"] = "选择区域",

}

Realistic_Properties.Lang[5] = {

	["en"] = "Properties Tool - Realistic Properties",
	["ru"] = "Properties Tool - Реалистичная собственность",
	["fr"] = "Properties Tool - Realistic Properties",
	["de"] = "Immobilien Werkzeug - Realistic Properties",
	["pl"] = "Narzędzie - Realistyczne nieruchomości",
	["da"] = "Enjendoms Værktøj - Realistiske Ejendomme",
	["pt"] = "Ferramenta de propriedades - Propriedades realisticas",
    ["tr"] = "Ozellikler Araci - Realistic Properties",
	["cn"] = "属性工具 - 现实房产",

}

Realistic_Properties.Lang[6] = {

	["en"] = "[USE] & [RELOAD] Change Step | [LeftClick] & [RightClick] Select / UnSelect",
	["ru"] = "[USE] & [RELOAD] Смена шага | [ЛКМ] & [ПКМ] Выбрать / Отменить выбор",
	["fr"] = "[USE] & [RELOAD] Changer d'Etape | [Click-Gauche] & [Click-Droit] Selection / Désélection",
	["de"] = "[USE] & [RELOAD] Schritt ändern | [Linksklick] & [Rechtsklick] Auswählen / Aufheben der Auswahl",
	["pl"] = "[USE] & [RELOAD] Zmień krok | [LPM] & [PPM] Wybierz / Odznacz",
	["da"] = "[USE] & [RELOAD] Skift Stadie | [LeftClick] & [RightClick] Vælg / Fravælg",
    ["pt"] = "[USE] & [RELOAD] Trocar passo | [Clique Esquerdo] * [Clique Direito] Selecicionar / de-Selecionar",
    ["tr"] = "[USE] & [RELOAD] Adim Degistir | [LeftClick] & [RightClick] Sec / Secme",
	["cn"] = "[USE] & [RELOAD] 更改步骤 | [LeftClick] & [RightClick] 选择/取消选择",
}

Realistic_Properties.Lang[7] = {

	["en"] = "Realistic Properties",
	["ru"] = "Реалистичная собственность",
	["fr"] = "Realistic Properties",
	["de"] = "Realistische Immobilien",
	["pl"] = "Realistyczne nieruchomości",
	["da"] = "Realistiske Ejendomme",
    ["pt"] = "Propriedades Realisticas",
    ["tr"] = "Gercekci Mulk",
	["cn"] = "现实房产",

}

Realistic_Properties.Lang[8] = {

	["en"] = "The property can be rented",
	["ru"] = "Собственность может быть арендована",
	["fr"] = "La proprieté peut être louée",
	["de"] = "Die Immobilie kann gemietet werden",
	["pl"] = "Nieruchomość może zostać wynajęta",
	["da"] = "Denne ejendom kan lejes",
	["pt"] = "Essa propriedade pode ser alugada",
    ["tr"] = "Bu mulk kiralanabilir",
	["cn"] = "该房产可以出租",

}

Realistic_Properties.Lang[9] = {

	["en"] = "You have too many entities of this kind it was refunded to you.",
	["ru"] = "У вас слишком много объектов такого рода, вам было возвращено.",
	["fr"] = "Vous avez trop d'entité de se type elle vous as été remboursé.",
	["de"] = "Sie haben zu viele entities dieser Art, diese wurden Ihnen zurückerstattet.",
	["pl"] = "Masz zbyt wiele przedmiotów tego samego rodzaju, nadwyżka została ci zwrócona.",
	["da"] = "Du har for mange af denne, den blev retuneret.",
	["pt"] = "Você tem entidades de mais desse tipo, por isso essa foi reembolsada",
    ["tr"] = "Bu turden cok fazla varliga sahipsiniz. Bu yuzden paraniz iade edildi.",
	["cn"] = "你有太多这样的实体，它被退给你了。",

}

Realistic_Properties.Lang[10] = {

	["en"] = "The property can't be rented",
	["ru"] = "Недвижимость не может быть сдана в аренду",
	["fr"] = "La proprieté ne peut pas être louée",
	["de"] = "Die Immobilie kann nicht vermietet werden",
	["pl"] = "Nieruchomość nie może zostać wynajęta",
	["da"] = "Ejendommen kan ikke lejes",
	["pt"] = "Essa propriedade não pode ser alugada",
    ["tr"] = "Bu mulk kiralanamiyor",
	["cn"] = "该房产不可出租",

}

Realistic_Properties.Lang[11] = {

	["en"] = "Property Name",
	["ru"] = "Имя собственности",
	["fr"] = "Nom de la Proprieté",
	["de"] = "Name der Immobilie",
	["pl"] = "Nazwa nieruchomości",
	["da"] = "Ejendomsnavn",
	["pt"] = "Nome da propriedade",
    ["tr"] = "Mulk Ismi",
	["cn"] = "房产名称",

}

Realistic_Properties.Lang[12] = {

	["en"] = "Property Price",
	["ru"] = "Стоимость собственности",
	["fr"] = "Prix de la Proprieté",
	["de"] = "Preis der Immobilie",
	["pl"] = "Cena nieruchomości",
	["da"] = "Pris på Ejendommen",
	["pt"] = "Preço da propriedade",
    ["tr"] = "Mulkun Fiyati",
	["cn"] = "房产价格",

}

Realistic_Properties.Lang[13] = {

	["en"] = "Property Location",
	["ru"] = "Место положения собственности",
	["fr"] = "Location de la Proprieté",
	["de"] = "Standort der Immobilie",
	["pl"] = "Lokalizacja nieruchomości",
	["da"] = "Placering af Ejendommen",
	["pt"] = "Localização da propriedade",
    ["tr"] = "Mulkun Konusu",
	["cn"] = "房产位置",

}

Realistic_Properties.Lang[14] = {

	["en"] = "Property Type",
	["ru"] = "Тип собственности",
	["fr"] = "Type de Proprieté",
	["de"] = "Immobilien Typ",
	["pl"] = "Typ nieruchomości",
	["da"] = "Ejendomstype",
	["pt"] = "Tipo da propriedade",
    ["tr"] = "Mulk Turu",
	["cn"] = "房产类型",

}

Realistic_Properties.Lang[15] = {

	["en"] = "Accept",
	["ru"] = "Принять",
	["fr"] = "Accepter",
	["de"] = "Akzeptieren",
	["pl"] = "Akceptuj",
	["da"] = "Acceptere",
	["pt"] = "Aceitar",
    ["tr"] = "Kabul",
	["cn"] = "接受",

}

Realistic_Properties.Lang[16] = {

	["en"] = "Delete",
	["ru"] = "Удалить",
	["fr"] = "Supprimer",
	["de"] = "Löschen",
	["pl"] = "Usuń",
	["da"] = "Slet",
	["pt"] = "Deletar",
    ["tr"] = "Sil",
	["cn"] = "删除",

}

Realistic_Properties.Lang[17] = {

	["en"] = "Square Meters :",
	["ru"] = "Квадратных метров :",
	["fr"] = "Nombre de M² :",
	["de"] = "Quadrad-Meter",
	["pl"] = "Metry kwadratowe:",
	["da"] = "Kvadratmeter :",
	["pt"] = "Metros Quadrados",
    ["tr"] = "Su Kadar Metrekare :",
	["cn"] = "房产大小/平方：",

}

Realistic_Properties.Lang[18] = {

	["en"] = "Properties List",
	["ru"] = "Список собственности",
	["fr"] = "Liste Proprietés",
	["de"] = "Immobilien Liste",
	["pl"] = "Lista nieruchomości",
	["da"] = "Ejendoms Liste",
	["pt"] = "Lista de propriedades",
    ["tr"] = "Mulk Listesi",
	["cn"] = "房产列表",

}

Realistic_Properties.Lang[19] = {

	["en"] = "Price",
	["ru"] = "Цена",
	["fr"] = "Prix",
	["de"] = "Preis",
	["pl"] = "Cena",
	["da"] = "Pris",
	["pt"] = "Preço",
    ["tr"] = "Fiyat",
	["cn"] = "价格",

}

Realistic_Properties.Lang[20] = {

	["en"] = "Rent",
	["ru"] = "Арендовать",
	["fr"] = "Louer",
	["de"] = "Mieten",
	["pl"] = "Wynajmij",
	["da"] = "Lej",
	["pt"] = "Aluguel",
    ["tr"] = "Kirala",
	["cn"] = "租用",

}

Realistic_Properties.Lang[21] = {

	["en"] = "VIEW",
	["ru"] = "ПОКАЗАТЬ",
	["fr"] = "VOIR",
	["de"] = "BESICHTIGEN",
	["pl"] = "ZOBACZ",
	["da"] = "SE",
	["pt"] = "VER",
    ["tr"] = "GORUNTULE",
	["cn"] = "查看",

}

Realistic_Properties.Lang[22] = {

	["en"] = "Doors Number",
	["ru"] = "Номер Двери",
	["fr"] = "Nombre de Portes",
	["de"] = "Anzahl an Türen",
	["pl"] = "Liczba drzwi",
	["da"] = "Antal Døre",
	["pt"] = "Numeros de portas",
    ["tr"] = "Kapi Sayisi",
	["cn"] = "门牌号",

}

Realistic_Properties.Lang[23] = {

	["en"] = "Renting :",
	["ru"] = "Аренда :",
	["fr"] = "Location :",
	["de"] = "Mietbar :",
	["pl"] = "Wynajem :",
	["da"] = "Udlejes :",
	["pt"] = "Alugando :",
    ["tr"] = "Kiralama :",
	["cn"] = "租用：",

}

Realistic_Properties.Lang[24] = {

	["en"] = "Renting : NO",
	["ru"] = "Аренда : НЕТ",
	["fr"] = "Location : NON",
	["de"] = "Mietbar : JA",
	["pl"] = "Wynajem : NIE",
	["da"] = "Udlejes : NEJ",
	["pt"] = "Alugando : NÃO",
    ["tr"] = "Kiralama :HAYIR",
	["cn"] = "租用：无",

}

Realistic_Properties.Lang[25] = {

	["en"] = "Type",
	["ru"] = "Тип",
	["fr"] = "Type",
	["de"] = "Typ",
	["pl"] = "Typ",
	["da"] = "Type",
	["pt"] = "Tipo",
    ["tr"] = "Tur",
	["cn"] = "类型",

}

Realistic_Properties.Lang[26] = {

	["en"] = "SOLD",
	["ru"] = "ПРОДАНО",
	["fr"] = "VENDU",
	["de"] = "VERKAUFT",
	["pl"] = "SPRZEDANE",
	["da"] = "SOLGT",
	["pt"] = "Vendida",
    ["tr"] = "SATILDI",
	["cn"] = "已出售",

}

Realistic_Properties.Lang[28] = { --  

	["en"] = "You have bought the property",
	["ru"] = "Вы купили собственность",
	["fr"] = "Vous venez d'acheter la proprieté",
	["de"] = "Du laufst diese Immobilie",
	["pl"] = "Kupiłeś nieruchomość",
	["da"] = "Du har købt denne ejendom",
	["pt"] = "Você comprou a propriedade",
    ["tr"] = "Mulku satin aldiniz.",
	["cn"] = "你已经买下了这套房子",

}

Realistic_Properties.Lang[27] = {

	["en"] = "You have rented the properties",
	["ru"] = "Вы арендовали собственность",
	["fr"] = "Vous avez loué la proprieté",
	["de"] = "Du mietest diese Immobilie",
	["pl"] = "Wynająłeś nieruchomość",
	["da"] = "Du har lejet denne ejendom",
	["pt"] = "Você alugou a propriedade",
    ["tr"] = "Mulku kiraladiniz",
	["cn"] = "你已经租下了这套房子",

}

Realistic_Properties.Lang[29] = {

	["en"] = "SELL",
	["ru"] = "ПРОДАТЬ",
	["fr"] = "VENDRE",
	["de"] = "VERKAUFEN",
	["pl"] = "SPRZEDAJ",
	["da"] = "SÆLG",
	["pt"] = "Vender",
    ["tr"] = "SAT",
	["cn"] = "出售",

}

Realistic_Properties.Lang[30] = {

	["en"] = "DELIVERY SYSTEM",
	["ru"] = "СИСТЕМА ДОСТАВКИ",
	["fr"] = "SYSTEM DE LIVRAISON",
	["de"] = "LIEFERSYSTEM",
	["pl"] = "SYSTEM DOSTAWY",
	["da"] = "LEVERINGSSYSTEM",
	["pt"] = "Sistema de entregas",
    ["tr"] = "TESLIMAT SISTEMI",
	["cn"] = "交付系统",

}

Realistic_Properties.Lang[31] = {

	["en"] = "DELIVERY",
	["ru"] = "ДОСТАВКА",
	["fr"] = "LIVRAISON",
	["de"] = "LIEFERUNG",
	["pl"] = "DOSTAWA",
	["da"] = "LEVERING",
	["pt"] = "ENTREGA",
    ["tr"] = "TESLIMAT",
	["cn"] = "送货",

}

Realistic_Properties.Lang[32] = {

	["en"] = "Rent Normally",
	["ru"] = "Арендовать Обычно",
	["fr"] = "Louer Normalement",
	["de"] = "Normal Mieten",
	["pl"] = "Wynajmij",
	["da"] = "Lej Normalt",
	["pt"] = "Alugar Normalmente",
    ["tr"] = "Normal Kirala",
	["cn"] = "正常租金",
	
	
}

Realistic_Properties.Lang[33] = {

	["en"] = "BUY",
	["ru"] = "КУПИТЬ",
	["fr"] = "ACHETER",
	["de"] = "KAUFEN",
	["pl"] = "KUP",
	["da"] = "KØB",
	["pt"] = "COMPRAR",
    ["tr"] = "SATIN AL",
	["cn"] = "购买",

}

Realistic_Properties.Lang[34] = {

	["en"] = "day",
	["ru"] = "День",
	["fr"] = "jour",
	["de"] = "Tag",
	["pl"] = "dni",
	["da"] = "dag",
	["pt"] = "dia",
    ["tr"] = "gun",
	["cn"] = "天",

}

Realistic_Properties.Lang[35] = {

	["en"] = "Rent the property",
	["ru"] = "Арендовать собственность",
	["fr"] = "Louer la Proprieté",
	["de"] = "Diese Immobilie mieten",
	["pl"] = "Wynajmij nieruchomość",
	["da"] = "Lej denne ejendom",
	["pt"] = "Alugar a propriedade",
    ["tr"] = "Mulku Kirala",
	["cn"] = "租用房产",

}

Realistic_Properties.Lang[36] = {

	["en"] = "["..Realistic_Properties.NameDeliveryEnterprise.."] Your package is being delivered and will arrive very soon.",
	["ru"] = "["..Realistic_Properties.NameDeliveryEnterprise.."] Ваша посылка доставляется и прибудет очень скоро.",
	["fr"] = "["..Realistic_Properties.NameDeliveryEnterprise.."] Votre colis est en cours de livraison il arrivera d'ici peu.",
	["de"] = "["..Realistic_Properties.NameDeliveryEnterprise.."] Ihr Paket wird gerade ausgeliefert und wird bald bei Ihnen eintreffen.",
	["pl"] = "["..Realistic_Properties.NameDeliveryEnterprise.."] Twoja przesyłka zostanie wkrótce dostarczona.",
	["da"] = "["..Realistic_Properties.NameDeliveryEnterprise.."] Din pakke er ved at blive leveret! den ankommer meget snart.",
	["pt"] = "["..Realistic_Properties.NameDeliveryEnterprise.."] Seu pacote esta sendo entregue e deve chegar em breve",
    ["tr"] = "["..Realistic_Properties.NameDeliveryEnterprise.."] Siparisiniz kargoya verildi. Kisa sure sonra size ulasacaktir.",
	["cn"] = "["..Realistic_Properties.NameDeliveryEnterprise.."] 你的包裹正在交付，很快就会到达。",

}

Realistic_Properties.Lang[37] = {

	["en"] = "["..Realistic_Properties.NameDeliveryEnterprise.."] Your package arrived",
	["ru"] = "["..Realistic_Properties.NameDeliveryEnterprise.."] Ваша посылка прибыла",
	["fr"] = "["..Realistic_Properties.NameDeliveryEnterprise.."] Votre colis est arrivé",
	["de"] = "["..Realistic_Properties.NameDeliveryEnterprise.."] Ihr Paket ist angekommen",
	["pl"] = "["..Realistic_Properties.NameDeliveryEnterprise.."] Twoja przesyłka została dostarczona.",
	["da"] = "["..Realistic_Properties.NameDeliveryEnterprise.."] Din pakke er ankommet",
	["pt"] = "["..Realistic_Properties.NameDeliveryEnterprise.."] Seu pacote chegou",
    ["tr"] = "["..Realistic_Properties.NameDeliveryEnterprise.."] Siparisiniz geldi",
	["cn"] = "["..Realistic_Properties.NameDeliveryEnterprise.."] 你的包裹已经到达",

}

Realistic_Properties.Lang[38] = {

	["en"] = "You don't have any properties your entities were refund",
	["ru"] = "У вас нет каких-либо предметов, которые были возвращены вам",
	["fr"] = "Vous n'avez aucune proprieté votre entités a été remboursé",
	["de"] = "Du hast keine Immobilien, deine entities wurden zurückerstattet",
	["pl"] = "Nie posiadasz żadnej nieruchomości, twoje przedmioty zostały ci zwrócone.",
	["da"] = "Du har ikke nogen ejendom, dine ting blev refunderet",
	["pt"] = "Você não tem nenhuma propriedade, suas entidades foram reembolsadas",
    ["tr"] = "Hic mulkunuz yok, varliklariniz iade edildi",
	["cn"] = "你没有任何财产，你的实体被退货了",

}

Realistic_Properties.Lang[39] = {

	["en"] = "We could not deliver you have too many packages unload before reorder",
	["ru"] = "Мы не можем доставить слишком много пакетов, которые нужно выгрузить перед повторным заказом",
	["fr"] = "Nous n'avons pas pu livrer vous avez trop de colis déchargez les avant de recommander",
	["de"] = "Wir konnten nicht liefern. Sie haben Pakete von einer Nachbestellung entladen.",
	["pl"] = "Nie można dostarczyć przesyłki, ponieważ masz ich zbyt wiele. Rozpakuj przed ponownym zamówieniem.",
	["da"] = "Vi kunne ikke levere din pakke, du har for mange. Tøm din pakkeboks før ny bestilling",
	["pt"] = "Nos não podemos entregar, você tem pacotes de mais.",
    ["tr"] = "Siparisi teslim edemiyoruz . Yuklenecek cok maliniz var, onlar bosaltildiktan sonra yeniden siparis verin",
	["cn"] = "我们无法为你送达，你有太多的包裹未卸下。在卸下之前，我们无法重新订购。",

}


Realistic_Properties.Lang[40] = {

	["en"] = "You have sold the properties",
	["ru"] = "Вы продали недвижимость",
	["fr"] = "Vous avez vendu la proprieté",
	["de"] = "Sie haben die Immobilien verkauft",
	["pl"] = "Sprzedałeś nieruchomość",
	["da"] = "Du har solgt denne ejendom",
	["pt"] = "Você vendeu a propriedade",
    ["tr"] = "Mulkleri sattiniz",
	["cn"] = "你把房子卖掉了",

}

Realistic_Properties.Lang[41] = {

	["en"] = "Purchased",
	["ru"] = "Приобретено",
	["fr"] = "Acheté",
	["de"] = "Gekauft",
	["pl"] = "Zakupione",
	["da"] = "Købt",
	["pt"] = "Comprada",
    ["tr"] = "Satin Alindi",
	["cn"] = "已购买的",

}

Realistic_Properties.Lang[42] = {

	["en"] = "For Sale",
	["ru"] = "Продается", 
	["fr"] = "A Vendre",
	["de"] = "Zu Verkaufen",
	["pl"] = "Na sprzedaż",
	["da"] = "Til Salg",
	["pt"] = "A Venda",
    ["tr"] = "Satilik",
	["cn"] = "待售",

}

Realistic_Properties.Lang[43] = {

	["en"] = "You can't buy the property because it is sold",
	["ru"] = "Вы не можете купить недвижимость, потому что она была продана", 
	["fr"] = "Vous ne pouvez pas acheter la proprieté car elle a été vendu",
	["de"] = "Sie können die Immobilie nicht kaufen, weil sie verkauft ist",
	["pl"] = "Nie możesz kupić nieruchomości, ponieważ została sprzedana",
	["da"] = "Du kan ikke købe ejendommen, fordi den allerede er solgt",
	["pt"] = "Você não pode comprar a propriedade porque ela ja foi vendida",
    ["tr"] = "Satilmis bir mulku satin alamazsiniz",
	["cn"] = "你不能购买房子，因为它已经被买了",

}

Realistic_Properties.Lang[44] = {

	["en"] = "You can't spawn props outside your properties",
	["ru"] = "Вы не можете создавать реквизит за пределами вашей собственности", 
	["fr"] = "Vous ne pouvez pas faire spawn de props en dehors de votre proprieté",
	["de"] = "Sie können keine Props außerhalb Ihrer Immobilie spawnen",
	["pl"] = "Nie możesz spawnować rekwizytów poza swoimi właściwościami",
	["da"] = "Du kan ikke spawne props udenfor din ejendom",
	["pt"] = "Você não pode spawnar props fora da sua propriedade",
    ["tr"] = "Mulkunuzun disinda prop yaratamazsiniz",
	["cn"] = "你不能在你的房产之外生成实体",

}

Realistic_Properties.Lang[45] = {

	["en"] = "Add Owner",
	["ru"] = "Add Owner", 
	["fr"] = "Add Owner",
	["de"] = "Besitzer hinzufügen",
	["pl"] = "Add Owner",
	["da"] = "Tilføj Ejer",
	["pt"] = "Adicionar sub-dono",
    ["tr"] = "Sahip Ekle",
	["cn"] = "添加所有者",

}

Realistic_Properties.Lang[46] = {

	["en"] = "Press [USE] to spawn your entity and [RELOAD] for stop pos",
	["ru"] = "Нажмите [USE], чтобы породить вашу сущность, и [RELOAD], чтобы остановить ее.", 
	["fr"] = "Appuyez sur [UTILISER] pour faire spawn l'entité et [RELOAD] pour arreter la pose ",
	["de"] = "Drücken Sie [VERWENDEN], um Ihre Entität zu spawnen und [RELOAD] für Stop-Pos",
	["pl"] = "Naciśnij [USE], aby zrodzić swoją jednostkę i [RELOAD], aby zatrzymać poz.",
	["da"] = "Tryk [USE] for at spawn din entity og [RELOAD] for stop pos",
	["pt"] = "Aperte [USE] para spawnar sua entidade e [RELOAD] para stop-pos",
    ["tr"] = "Su tusa [USE] basarak varligi olusturun ve su tusa [RELOAD] basarak durdurabilirsin",
	["cn"] = "按[USE]生成你的实体，按[RELOAD]停止。",

}

Realistic_Properties.Lang[47] = {

	["en"] = "There is no property on this server ( Contact an Admin )",
	["ru"] = "На этом сервере нет свойств ( Контакт с администратором )", 
	["fr"] = "Il n'y a pas de proprieté sur le serveur ( Contactez un Administrateur )",
	["de"] = "Es gibt keine Immobiöien auf diesem Server ( Kontaktieren Sie einem Admin )",
	["pl"] = "Nie ma żadnej własności na tym serwerze ( skontaktuj się z administratorem )",
	["da"] = "Der ingen ejendomme på serveren ( Kontakt Staff )",
	["pt"] = "Não há nenhuma propriedade nesse servidor ( Contate um admin!)",
    ["tr"] = "Sunucuda hic mulk yok ( Bir Yetkiliye Ulasin )",
	["cn"] = "此服务器上没有任何房产 (请联系管理员)",

}

Realistic_Properties.Lang[48] = {

	["en"] = "You added a property",
	["ru"] = "Вы добавили свойство", 
	["fr"] = "Vous avez ajouté une proprieté",
	["de"] = "Sie haben eine Immobilie hinzugefügt",
	["pl"] = "Dodałeś nieruchomość",
	["da"] = "Du tilføjede en ejendom",
	["pt"] = "Você adicionou uma propriedade",
    ["tr"] = "Mulk eklediniz",
	["cn"] = "你增加了一处房产",

}

Realistic_Properties.Lang[49] = {

	["en"] = "You removed a property",
	["ru"] = "Вы удалили собственность", 
	["fr"] = "Vous avez supprimé une propriété",
	["de"] = "Sie haben eine Immobilie entfernt",
	["pl"] = "Usunąłeś nieruchomość",
	["da"] = "Du har fjernet en ejendom",
	["pt"] = "Você removou uma propriedade",
    ["tr"] = "Mulk sildiniz",
	["cn"] = "你删除了一处房产",

}

Realistic_Properties.Lang[50] = {

	["en"] = "You don't have enough money",
	["ru"] = "У тебя нет денег", 
	["fr"] = "Vous n'avez pas assez d'argent",
	["de"] = "Sie haben nicht genug Geld",
	["pl"] = "Nie masz wystarczająco dużo pieniędzy",
	["da"] = "Du har ikke nok penge",
	["pt"] = "Você não tem dinheiro o bastante",
    ["tr"] = "Yeterli paraniz yok",
	["cn"] = "你没有足够的钱",

}

Realistic_Properties.Lang[51] = {

	["en"] = "A selected door is already in the database.",
	["ru"] = "Выбранная дверь уже находится в базе данных.", 
	["fr"] = "Une porte selectionné est déjà dans les datas",
	["de"] = "Eine ausgewählte Tür befindet sich bereits in der Datenbank.",
	["pl"] = "Wybrane drzwi znajdują się już w bazie danych.",
	["da"] = "En valgt dør findes allerede i databasen.",
    ["pt"] = "Uma porta selecionada ja esta na database",
    ["tr"] = "Secilen kapi zaten veri tabaninda",
	["cn"] = "选中的门已经在数据库中。",

}

Realistic_Properties.Lang[52] = {

	["en"] = "Your props was saved",
	["ru"] = "Ваш реквизит был сохранен", 
	["fr"] = "Les props on été sauvegardé",
	["de"] = "Ihre Props wurden gespeichert.",
	["pl"] = "Twoje rekwizyty zostały uratowane",
	["da"] = "Dine props blev gemt",
	["pt"] = "Seus props foram salvos",
    ["tr"] = "Proplarin kaydedildi",
	["cn"] = "你的实体已保存",

}

Realistic_Properties.Lang[53] = {

	["en"] = "Search...",
	["ru"] = "Поиск...", 
	["fr"] = "Chercher...",
	["de"] = "Suchen...",
	["pl"] = "Szukaj...",
	["da"] = "Søg...",
	["pt"] = "Procurar...",
    ["tr"] = "Arama...",
	["cn"] = "搜索.....",

}

Realistic_Properties.Lang[54] = {

	["en"] = "The name of the property is already used",
	["ru"] = "Название собственности уже взято", 
	["fr"] = "Le nom de la propriété est déjà pris",
	["de"] = "Der Name der Immobilie ist bereits vergeben.",
	["pl"] = "Nazwa nieruchomości jest już zajęta",
	["da"] = "Navnet er allerede i brug af en anden ejendom",
	["pt"] = "Esse nome de propriedade ja esta em uso",
    ["tr"] = "Mulkun ismi coktan kullanilmis",
	["cn"] = "该名称已被其他房产使用",

}

Realistic_Properties.Lang[55] = {

	["en"] = "Price Limit : $999,999,999",
	["ru"] = "Ценовой предел $999,999,999", 
	["fr"] = "Prix Limite $999,999,999",
	["de"] = "Preisgrenze $999,999,999",
	["pl"] = "Limit cenowy $999,999,999",
	["da"] = "Pris Grænse : 999,999,999 Kr",
	["pt"] = "Limite de preço : R$999,999,999",
    ["tr"] = "Fiyat Limiti : $999,999,999",
	["cn"] = "价格上限：$999,999,999",

}

Realistic_Properties.Lang[56] = {
 
	["en"] = "ENABLE",
	["ru"] = "ДЕЯТЕЛЬНОСТЬ", 
	["fr"] = "ACTIVER",
	["de"] = "AKTIVIEREN",
	["pl"] = "DZIAŁAĆ",
	["da"] = "AKTIVER",
	["pt"] = "Ativar",
    ["tr"] = "ETKINLESTIRME",
	["cn"] = "启用",

}

Realistic_Properties.Lang[57] = {

	["en"] = "Text Limit (20)",
	["ru"] = "Текстовый Лимит (20)", 
	["fr"] = "Limite de Texte (20)",
	["de"] = "Textlimit (20)",
	["pl"] = "Text Limit (20)",
	["da"] = "Tekst Grænse (20)",
	["pt"] = "Limite de texto (20)",
    ["tr"] = "Metin Siniri (20)",
	["cn"] = "文本限制(20)",

}

Realistic_Properties.Lang[58] = {

	["en"] = "DISABLE",
	["ru"] = "ДИСКУССИЯ",
	["fr"] = "DESACTIVER",
	["de"] = "DEAKTIVIEREN",
	["pl"] = "DISABLE",
	["da"] = "DEAKTIVER",
	["pt"] = "DESABILITAR",
    ["tr"] = "DEVRE DISI",
	["cn"] = "停用",

}

Realistic_Properties.Lang[59] = {

	["en"] = "You have too many properties",
	["ru"] = "У вас слишком много свойств",
	["fr"] = "Vous avez trop de propriétés",
	["de"] = "Sie haben zu viele Eigenschaften",
	["pl"] = "Masz zbyt wiele właściwości",
	["da"] = "Du har for mange ejendomme",
	["pt"] = "Você tem propriedades de mais",
    ["tr"] = "Cok fazla mulkun var",
	["cn"] = "你的房产太多了",

}

Realistic_Properties.Lang[60] = {

	["en"] = "Config the List of the Properties for each entities",
	["ru"] = "Настройка списка свойств для каждого объекта",
	["fr"] = "Configurer la liste des proprietés pour chaque entités",
	["de"] = "Konfigurieren Sie die Liste der Eigenschaften für jede Entität",
	["pl"] = "Skonfiguruj listę właściwości dla każdego z podmiotów",
	["da"] = "Konfigurer listen over ejendomme for hver enhed",
    ["pt"] = "Configura a lista de propriedades para cada entidade",
    ["tr"] = "Her bir varlik icin Mulk Listesini yapilandirin",
	["cn"] = "配置每个实体的房产列表",

}

Realistic_Properties.Lang[61] = {

	["en"] = "Price Min : $0",
	["ru"] = "Цена мин : $0",
	["fr"] = "Prix Minimum : $0",
	["de"] = "Preis Min : $0",
	["pl"] = "Cena Min : $0",
	["da"] = "Pris Minimum : 0 Kr",
	["pt"] = "Preço Mini : R$ 0",
    ["tr"] = "Minimum Fiyat : $0",
	["cn"] = "最低价：$0",

}

Realistic_Properties.Lang[62] = {

	["en"] = "Final Step",
	["ru"] = "Следующий шаг",
	["fr"] = "Etape Suivante",
	["de"] = "Nächster Schritt",
	["pl"] = "Następny krok",
	["da"] = "Sidste Stadie",
	["pt"] = "Passo Final",
    ["tr"] = "Son Adim",
	["cn"] = "最后一步",

}

Realistic_Properties.Lang[63] = {

	["en"] = "Text Mins (3)",
	["ru"] = "Текст Минс (3)", 
	["fr"] = "Texte Minimum (3)",
	["de"] = "Text Min (3)",
	["pl"] = "Tekst Mins (3)",
	["da"] = "Tekst Minimum (3)",
	["pt"] = "Texto Minimo (3)",
    ["tr"] = "Minimum Metin Sayisi (3)",
	["cn"] = "最少文本数(3)",

}

Realistic_Properties.Lang[64] = {

	["en"] = "There seems to be a problem with the creation of the property, so it has been removed.",
	["ru"] = "Похоже, что существует проблема с созданием свойства, поэтому оно было удалено.", 
	["fr"] = "Il semblerait qu'il y ait un problème à la création de la propriété elle a donc été supprime",
	["de"] = "Es scheint ein Problem mit der Schaffung des Eigentums zu geben, daher wurde es entfernt.",
	["pl"] = "Wydaje się, że istnieje problem z utworzeniem nieruchomości, więc została ona usunięta.",
	["da"] = "Det ser ud til der er et problem med oprettelsen af ​​ejendommen, så den er blevet fjernet.",
	["pt"] = "Parece ter tido um problema com a criação da propriedade, então ela foi removida",
    ["tr"] = "Mulk yaratmada bir problem var, bu yuzden kaldirildi",
	["cn"] = "似乎在房产的设定上有问题，所以被它删除了。",

}

Realistic_Properties.Lang[65] = {

	["en"] = "The property is sold",
	["ru"] = "Недвижимость продана", 
	["fr"] = "La propriété est vendu",
	["de"] = "Das Grundstück wird verkauft",
	["pl"] = "Nieruchomość jest sprzedawana",
	["da"] = "Ejendommen er solgt",
    ["pt"] = "A propriedade esta vendida",
    ["tr"] = "Mulk satildi",
	["cn"] = "该房产已出售",

} 

Realistic_Properties.Lang[66] = {

	["en"] = "You can buy only",
	["ru"] = "Вы можете купить только", 
	["fr"] = "Vous ne pouvez acheter que",
	["de"] = "Sie können nur Folgendes kaufen",
	["pl"] = "Możesz kupić tylko",
	["da"] = "Du kan kun købe",
	["pt"] = "Você so pode comprar",
    ["tr"] = "Sadece satin alabilirsiniz",
	["cn"] = "你只能购买",

} 

Realistic_Properties.Lang[67] = {

	["en"] = "property",
	["ru"] = "свойство", 
	["fr"] = "propriété",
	["de"] = "Eigentum",
	["pl"] = "nieruchomość",
	["da"] = "ejendom",
	["pt"] = "Propriedade",
    ["tr"] = "Mulk",
	["cn"] = "房产",

} 


Realistic_Properties.Lang[68] = {

	["en"] = "Final Step",
	["ru"] = "Заключительный этап", 
	["fr"] = "Etape Finale",
	["de"] = "Letzter Schritt",
	["pl"] = "Krok końcowy",
	["da"] = "Sidste Stadie",
	["pt"] = "Passo Final",
    ["tr"] = "Son Adim",
	["cn"] = "最后一步",

} 

Realistic_Properties.Lang[69] = {

	["en"] = "You added a Co-Owner",
	["ru"] = "Вы добавили совладельца", 
	["fr"] = "Vous avez ajouté un coproprietaire",
	["de"] = "Sie haben einen Miteigentümer hinzugefügt",
	["pl"] = "Dodałeś współwłaściciela",
	["da"] = "Du tilføjede en medejer",
	["pt"] = "Você adicionou um sub-dono",
    ["tr"] = "Ikincil Sahip eklediniz",
	["cn"] = "你添加了一个共同拥有者",

} 

Realistic_Properties.Lang[70] = {

	["en"] = "You removed a Co-Owner",
	["ru"] = "Ты удалил совладельца", 
	["fr"] = "Vous avez retiré un copropriétaire",
	["de"] = "Sie haben einen Miteigentümer entfernt",
	["pl"] = "Usunąłeś Współwłaściciela",
	["da"] = "Du fjernede en medejer",
	["pt"] = "Você removou um sub-dono",
    ["tr"] = "Ikincil sahibi cikardiniz",
	["cn"] = "你删除了一个共同拥有者",

} 

Realistic_Properties.Lang[71] = {

	["en"] = "You dont have the right job to buy this property.",
	["ru"] = "У вас нет подходящей работы, чтобы купить эту недвижимость.", 
	["fr"] = "Vous n'etes pas dans le bon metier pour acheter cette propriete ",
	["de"] = "Sie haben nicht die richtige Stelle für den Kauf dieser Immobilie",
	["pl"] = "Nie masz odpowiedniej pracy, żeby kupić tę nieruchomość",
	["da"] = "Du har et forkert job til at kunne købe denne ejendom",
	["pt"] = "Você não tem o trabalho certo para comprar essa propriedade",
    ["tr"] = "Mulku satin almak icin uygun meslege sahip degilsiniz.",
	["cn"] = "你没有合适的工作来买这个房子。",

} 

Realistic_Properties.Lang[72] = {

	["en"] = "Owner",
	["ru"] = "Владелец", 
	["fr"] = "Proprietaire",
	["de"] = "Eigentümer",
	["pl"] = "właściciel",
	["da"] = "ejer",
	["pt"] = "proprietário",
    ["tr"] = "sahip",
	["cn"] = "业主",

} 

Realistic_Properties.Lang[73] = {

	["en"] = "Door Group",
	["ru"] = "Дверная группа", 
	["fr"] = "Groupe de Portes",
	["de"] = "Türgruppe",
	["pl"] = "Grupa drzwi",
	["da"] = "Dørgruppe",
	["pt"] = "Grupo da porta",
    ["tr"] = "Kapı Grubu",
	["cn"] = "门组",

} 

-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------