local my_language = {
    -- Администраторские уведомления
    need_admin = "Вам нужны права администратора, чтобы %s",
    need_sadmin = "Вам нужны права суперадминистратора, чтобы %s",
    no_privilege = "У вас нет разрешения на это действие",
    no_jail_pos = "Нет позиции тюрьмы",
    invalid_x = "Неверные %s! %s",

    -- Меню F1
    f1ChatCommandTitle = "Команды чата",
    f1Search = "Поиск…",

    -- Связанное с деньгами:
    price = "Цена: %s%d",
    priceTag = "Цена: %s",
    reset_money = "%s сбрасывает деньги всех игроков!",
    has_given = "%s даёт вам %s",
    you_gave = "Вы дали %s %s",
    npc_killpay = "%s за убийство NPC!",
    profit = "прибыли",
    loss = "убытка",
    Donate = "Пожертвовать",
    you_donated = "Вы пожертвовали %s to %s!",
    has_donated = "%s жертвует %s!",

    -- обратная совместимость
    deducted_x = "Списано %s%d",
    need_x = "Нужно %s%d",

    deducted_money = "Списано %s",
    need_money = "Нужно %s",

    payday_message = "Зарплата! Вы получили %s!",
    payday_unemployed = "Вы не получили зарплату, так как вы безработный!",
    payday_missed = "Зарплата пропущена! (вы арестованы)",

    property_tax = "Налог на имущество! %s",
    property_tax_cant_afford = "Ваше имущество изъято: вы не смогли оплатить налоги!",
    taxday = "Оплата налогов! %s%% было списано из вашего дохода!",

    found_cheque = "Вы получили %s%s из чека, выписанном %s.",
    cheque_details = "Этот чек выписан на %s.",
    cheque_torn = "Вы разорвали чек.",
    cheque_pay = "Получатель: %s",
    signed = "Подпись: %s",

    found_cash = "Вы подобрали %s%d!", -- обратная совместимость
    found_money = "Вы подобрали %s!",

    owner_poor = "Владелец %s слишком беден, чтобы субсидировать эту продажу!",

    -- Полиция
    Wanted_text = "В розыске!",
    wanted = "Разыскивается полицией!\nПричина: %s",
    youre_arrested = "Вы арестованы. Осталось %d сек.",
    youre_arrested_by = "%s арестовывает вас.",
    youre_unarrested_by = "%s освобождает вас.",
    hes_arrested = "%s арестован на %d сек!",
    hes_unarrested = "%s освобождается из тюрьмы!",
    warrant_ordered = "%s запрашивает ордер на обыск %s. Причина: %s",
    warrant_request = "%s запрашивает ордер на обыск %s\nПричина: %s",
    warrant_request2 = "Запрос на получение ордера отправлен мэру %s!",
    warrant_approved = "Ордер на обыск %s одобрен!\nПричина: %s\nЗапрошено: %s",
    warrant_approved2 = "Теперь вы можете обыскать его дом.",
    warrant_denied = "Мэр %s отклоняет ваш запрос на получение ордера.",
    warrant_expired = "Ордер на обыск %s истёк!",
    warrant_required = "Вам нужен ордер на обыск, чтобы выломать эту дверь.",
    warrant_required_unfreeze = "Вам нужен ордер на обыск, чтобы разморозить этот объект.",
    warrant_required_unweld = "Вам нужен ордер на обыск, чтобы открепить этот объект.",
    wanted_by_police = "%s разыскивается полицией!\nПричина: %s\nЗапрошено: %s",
    wanted_by_police_print = "%s объявляет в розыск %s, причина: %s",
    wanted_expired = "%s больше не разыскивается полицией.",
    wanted_revoked = "%s больше не разыскивается полицией.\nОтозвано: %s",
    cant_arrest_other_cp = "Вы не можете арестовать другого полицейского!",
    cant_wanted_other_cp = "Вы не можете подать в розыск сотрудника полиции.",
    cant_warrant_other_cp = "Вы не можете запросить ордер на сотрудника полиции.",
    must_be_wanted_for_arrest = "Чтобы арестовать игрока, нужно объявить его в розыск.",
    cant_arrest_fadmin_jailed = "Вы не можете арестовать игрока, посаженного в клетку администратором.",
    cant_arrest_no_jail_pos = "Вы не можете арестовать игрока, так как не установлено позиций тюрьмы!",
    cant_arrest_spawning_players = "Вы не можете арестовать возрождающегося игрока.",

    suspect_doesnt_exist = "Подозреваемый не существует.",
    actor_doesnt_exist = "Пользователь не существует.",
    get_a_warrant = "запросить ордер на обыск",
    remove_a_warrant = "отозвать ордер на обыск",
    make_someone_wanted = "объявить подозреваемого в розыск",
    remove_wanted_status = "убрать подозреваемого из розыска",
    already_a_warrant = "На этого подозреваемого уже есть ордер на обыск.",
    not_warranted = "На этого игрока нет ордера на обыск.",
    already_wanted = "Подозреваемый уже в розыске.",
    not_wanted = "Подозреваемый не в розыске.",
    need_to_be_cp = "Вам нужно быть сотрудником полиции.",
    suspect_must_be_alive_to_do_x = "Подозреваемый должен быть жив, чтобы %s.",
    suspect_already_arrested = "Подозреваемый уже в тюрьме.",

    -- Игроки
    health = "Здоровье: %s",
    job = "Работа: %s",
    salary = "Зарплата: %s%s",
    wallet = "Кошелёк: %s%s",
    weapon = "Оружие: %s",
    kills = "Убийств: %s",
    deaths = "Смертей: %s",
    rpname_changed = "%s меняет своё ролевое имя на %s",
    disconnected_player = "Отключившийся игрок",
    player = "игрока",

    -- Работы
    need_to_be_before = "Вы должны быть %s перед тем, как стать %s",
    need_to_make_vote = "Вы должны начать голосование, чтобы стать %s!",
    team_limit_reached = "Не удалось стать %s: достигнут максимум.",
    wants_to_be = "%s\nжелает стать\n%s",
    has_not_been_made_team = "%s не становится %s!",
    job_has_become = "%s теперь %s!",

    -- Ключи, транспорт и двери
    keys_allowed_to_coown = "Вам разрешено стать совладельцем\n(Нажмите клавишу перезарядки, держа ключи, или F2)\n",
    keys_other_allowed = "Разрешено стать совладельцем:",
    keys_allow_ownership = "(Нажмите клавишу перезарядки, держа ключи, или F2, чтобы разрешить покупку)",
    keys_disallow_ownership = "(Нажмите клавишу перезарядки, держа ключи, или F2, чтобы запретить покупку)",
    keys_owned_by = "Владелец:",
    keys_unowned = "Не куплено\n(Нажмите клавишу перезарядки, держа ключи, или F2, чтобы купить)",
    keys_everyone = "(Нажмите клавишу перезарядки, держа ключи, или F2, чтобы включить для всех)",
    door_unown_arrested = "Покупка и продажа невозможны, находясь под арестом!",
    door_unownable = "Эту дверь нельзя купить или продать!",
    door_sold = "Вы продали эту дверь за %s",
    door_already_owned = "Эта дверь уже кем-то куплена!",
    door_cannot_afford = "Не хватает денег на покупку этой двери!",
    vehicle_cannot_afford = "Не хватает денег на покупку этого транспорта!",
    door_bought = "Вы купили эту дверь за %s%s",
    vehicle_bought = "Вы купили этот транспорт за %s%s",
    door_need_to_own = "Вы должны владеть этой дверью, чтобы %s",
    door_rem_owners_unownable = "Вы не можете удалить владельца непокупаемой двери!",
    door_add_owners_unownable = "Вы не можете добавить владельца непокупаемой двери!",
    rp_addowner_already_owns_door = "%s уже владеет (или разрешено владеть) этой дверью!",
    add_owner = "Добавить владельца",
    remove_owner = "Удалить владельца",
    coown_x = "Совладеть %s",
    allow_ownership = "Разрешить покупку",
    disallow_ownership = "Запретить покупку",
    edit_door_group = "Изменить дверные группы",
    door_groups = "Дверные группы",
    door_group_doesnt_exist = "Дверная группа не существует!",
    door_group_set = "Дверная группа установлена.",
    sold_x_doors_for_y = "Вы продали несколько дверей (%d) за %s%d!", -- обратная совместимость
    sold_x_doors = "Вы продали несколько дверей (%d) за %s!",
    no_doors_owned = "У вас не куплено никаких дверей!",

    -- Энтити
    any_lab = "любую лабораторию",
    gun = "оружие",
    microwave = "Микроволновка",
    food = "еду",
    Food = "Еда",
    money_printer = "Денежный принтер",

    sign_this_letter = "Подписать письмо",
    signed_yours = "Ваш,",

    money_printer_exploded = "Ваш денежный принтер взорвался!",
    money_printer_overheating = "Ваш денежный принтер перегревается!",

    contents = "Содержит: ",
    amount = "Количество: ",

    picking_lock = "Взлом замка",

    cannot_pocket_x = "Вы не можете положить это в карман!",
    cannot_pocket_gravgunned = "Вы не можете положить это в карман: удерживается гравипушкой.",
    object_too_heavy = "Этот объект слишком тяжёлый.",
    pocket_full = "Ваш карман полон!",
    pocket_no_items = "В вашем кармане нет предметов.",
    drop_item = "Бросить предмет",

    bonus_destroying_entity = "уничтожение этого нелегального предмета",

    switched_burst = "Выбран режим стрельбы очередями.",
    switched_fully_auto = "Выбран автоматический режим стрельбы.",
    switched_semi_auto = "Выбран полуавтоматический режим стрельбы.",

    keypad_checker_shoot_keypad = "Выстрелите в кейпад, чтобы узнать, что он контролирует.",
    keypad_checker_shoot_entity = "Выстрелите в объект, чтобы узнать, с чем он соединён.",
    keypad_checker_click_to_clear = "Нажмите правую кнопку мыши, чтобы убрать выделение.",
    keypad_checker_entering_right_pass = "Ввод правильного пароля",
    keypad_checker_entering_wrong_pass = "Ввод неправильного пароля",
    keypad_checker_after_right_pass = "после ввода правильного пароля",
    keypad_checker_after_wrong_pass = "после ввода неправильного пароля",
    keypad_checker_right_pass_entered = "Ввод правильного пароля",
    keypad_checker_wrong_pass_entered = "Ввод неправильного пароля",
    keypad_checker_controls_x_entities = "Объектов, контролируемых этим кейпадом: %d",
    keypad_checker_controlled_by_x_keypads = "Кейпадов, контролирующих этот объект: %d",
    keypad_on = "ВКЛ",
    keypad_off = "ВЫКЛ",
    seconds = "сек.",

    persons_weapons = "Нелегальные предметы %s:",
    returned_persons_weapons = "Конфискованные предметы %s возвращены.",
    no_weapons_confiscated = "У %s ничего не конфисковано!",
    no_illegal_weapons = "У %s нет нелегальных предметов.",
    confiscated_these_weapons = "Конфискованные предметы:",
    checking_weapons = "Конфискация предметов",

    shipment_antispam_wait = "Подождите немного, прежде чем создавать новый ящик.",
    createshipment = "Создать поставочный ящик",
    splitshipment = "Разделить поставочный ящик",
    shipment_cannot_split = "Не удалось разделить ящик.",

    -- Общение
    hear_noone = "Никто не слышит ваш %s!",
    hear_everyone = "Все слышат вас!",
    hear_certain_persons = "Игроки, слышащие ваш %s: ",

    whisper = "шепчет:",
    yell = "кричит:",
    broadcast = "[Вещание]",
    radio = "Радио",
    request = "(ВЫЗОВ!)",
    group = "(группе)",
    demote = "(УВОЛЬНЕНИЕ)",
    ooc = "Глобальный чат",
    radio_x = "Радио %d",

    talk = "разговор",
    speak = "голос",

    speak_in_ooc = "разговор (глобальный чат)",
    perform_your_action = "разговор (совершение действия)",
    talk_to_your_group = "разговор (групповой чат)",

    channel_set_to_x = "Установлен канал %s!",
    channel = "канал",

    -- Уведомления
    disabled = "%s выключено! %s",
    gm_spawnvehicle = "Создание транспорта",
    gm_spawnsent = "Создание скриптовых энтити",
    gm_spawnnpc = "Создание NPC",
    see_settings = "Просмотрите настройки DarkRP.",
    limit = "Вы достигли максимума %s!",
    have_to_wait = "Подождите %d сек. перед повторным использованием %s!",
    must_be_looking_at = "Вы должны смотреть на %s!",
    incorrect_job = "У вас не та работа, чтобы %s",
    unavailable = "Не удалось найти %s",
    unable = "Вы не можете %s. %s",
    cant_afford = "У вас не хватает денег на %s",
    created_x = "%s создаёт %s",
    cleaned_up = "Ваши %s были удалены.",
    you_bought_x = "Вы купили %s за %s%d.", -- обратная совместимость
    you_bought = "Вы купили %s за %s.",
    you_got_yourself = "Вы приобрели %s.",
    you_received_x = "Вы получили %s за %s.",

    created_first_jailpos = "Вы создали первую позицию тюрьмы!",
    added_jailpos = "Вы добавили дополнительную позицию тюрьмы!",
    reset_add_jailpos = "Вы удалили все позиции тюрьмы и создали новую здесь.",
    created_spawnpos = "Вы создали позицию возрождения для %s.",
    updated_spawnpos = "Вы удалили все позиции возрождения для %s и создали новую здесь",
    remove_spawnpos = "Вы удалили все позиции возрождения для %s.",
    do_not_own_ent = "Вы этим не владеете!",
    cannot_drop_weapon = "Это оружие нельзя выбросить!",
    job_switch = "Обмен работами завершён!",
    job_switch_question = "Обменяться работами с %s?",
    job_switch_requested = "Обмен работами запрошен.",
    switch_jobs = "обменяться работами",

    cooks_only = "Разрешено только поварам.",

    -- Прочее
    unknown = "Неизвестно",
    arguments = "аргументы",
    no_one = "никто",
    door = "дверь",
    vehicle = "траспорт",
    door_or_vehicle = "дверь/транспорт",
    driver = "Водитель: %s",
    name = "Имя: %s",
    locked = "Заперто.",
    unlocked = "Отперто.",
    player_doesnt_exist = "Игрок не существует.",
    job_doesnt_exist = "Работа не существует!",
    must_be_alive_to_do_x = "Вы должны быть живы, чтобы %s.",
    banned_or_demoted = "Заблокирован/уволен",
    wait_with_that = "Подождите немного.",
    could_not_find = "Не удалось найти %s",
    f3tovote = "[F3] Голосовать",
    listen_up = "Слушайте:", -- при rp_tell или rp_tellall
    nlr = "Правило новой жизни: не мсти обидчику.",
    reset_settings = "Вы сбросили все настройки!",
    must_be_x = "Вы должны быть %s, чтобы %s.",
    agenda = "повестка",
    agenda_updated = "Повестка обновлена",
    job_set = "%s меняет свою работу на '%s'",
    demote_vote = "увольнение",
    demoted = "%s уволен",
    demoted_not = "%s не уволен",
    demote_vote_started = "%s начинает голосование об увольнении %s",
    demote_vote_text = "Увольняемый:\n%s", -- где %s является причиной
    cant_demote_self = "Вы не можете уволить себя.",
    i_want_to_demote_you = "Я желаю уволить тебя. Причина: %s",
    tried_to_avoid_demotion = "Вы попытались избежать увольнения и были уволены за это.",
    lockdown_started = "Мэр объявил комендантский час! Вернитесь в свои дома!",
    lockdown_ended = "Комендантский час закончился",
    gunlicense_requested = "%s запрашивает лицензию на оружие у %s",
    gunlicense_granted = "%s выдаёт лицензию на оружие %s",
    gunlicense_denied = "%s не выдаёт лицензию на оружие %s",
    gunlicense_question_text = "Выдать лицензию на оружие %s?",
    gunlicense_remove_vote_text = "%s начинает голосование о лишении %s лицензии на оружие",
    gunlicense_remove_vote_text2 = "Лишаемый:\n%s", -- где %s является причиной
    gunlicense_removed = "%s лишается лицензии на оружие!",
    gunlicense_not_removed = "%s не лишается лицензии на оружие!",
    vote_specify_reason = "Вы должны указать причину!",
    vote_started = "Голосование создано",
    vote_alone = "Вы выиграли голосование, так как находитесь одни на сервере.",
    you_cannot_vote = "Вы не можете голосовать!",
    x_cancelled_vote = "%s отменяет последнее голосование.",
    cant_cancel_vote = "Не удалось отменить голосование, так как нет активных голосований!",
    jail_punishment = "Наказание за отключение! Вы арестованы на %d сек.",
    admin_only = "Администратору доступно это действие!", -- При использовании /addjailpos
    chief_or = "Начальнику полиции или", -- При использовании /addjailpos
    frozen = "Заморожен.",
    recipient = "получатель",
    forbidden_name = "Запрещённое имя.",
    illegal_characters = "Недопустимые символы.",
    too_long = "Слишком длинное.",
    too_short = "Слишком короткое.",

    dead_in_jail = "Вы будете мертвы до освобождения из тюрьмы!",
    died_in_jail = "%s умирает в тюрьме!",

    credits_for = "ТИТРЫ К %s\n",
    credits_see_console = "Титры DarkRP написаны в консоль.",

    rp_getvehicles = "Транспорт, доступный для создания собственного:",

    data_not_loaded_one = "Ваши данные ещё не загрузились. Пожалуйста, подождите.",
    data_not_loaded_two = "Если это повторится, переподключитесь к серверу или свяжитесь с администратором.",

    cant_spawn_weapons = "Вы не можете создавать оружие.",
    drive_disabled = "Управление выключено.",
    property_disabled = "Свойство выключено.",

    not_allowed_to_purchase = "Вы не можете купить этот предмет.",

    rp_teamban_hint = "rp_teamban [имя игрока/ID] [название работы/ID]. Блокирует игроку возможность выбирать указанную работу.",
    rp_teamunban_hint = "rp_teamunban [player name/ID] [team name/id]. Снимает блокировку на выбор указанной работы у игрока.",
    x_teambanned_y_for_z = "%s блокирует %s возможность становиться %s на %s мин.",
    x_teamunbanned_y = "%s снимает блокировку %s на становление %s.",

    -- Обратная совместимость:
    you_set_x_salary_to_y = "Вы изменили зарплату %s на %s%d.",
    x_set_your_salary_to_y = "%s меняет вашу зарплату на %s%d.",
    you_set_x_money_to_y = "Вы изменили количество денег %s на %s%d.",
    x_set_your_money_to_y = "%s меняет ваше количество денег на %s%d.",

    you_set_x_salary = "Вы изменили зарплату %s на %s.",
    x_set_your_salary = "%s меняет вашу зарплату на %s.",
    you_set_x_money = "Вы изменили количество денег %s на %s.",
    x_set_your_money = "%s меняет ваше количество денег на %s.",
    you_set_x_name = "Вы изменили ролевое имя %s на %s",
    x_set_your_name = "%s меняет ваше ролевое имя на %s",

    someone_stole_steam_name = "Ваше имя пользователя уже кем-то используется в качестве ролевого имени, поэтому к вашему приписано '1'.",
    already_taken = "Уже кем-то используется.",

    job_doesnt_require_vote_currently = "Для этой работы не требуется голосование!",

    x_made_you_a_y = "%s делает вас %s!",

    cmd_cant_be_run_server_console = "Эту команду нельзя использовать через консоль сервера.",

    -- Лотерея
    lottery_started = "Лотерея! Участвовать за %s%d?", -- обратная совместимость
    lottery_has_started = "Лотерея! Участвовать за %s?",
    lottery_entered = "Вы приняли участие в лотерее за %s.",
    lottery_not_entered = "%s не участвует в лотерее.",
    lottery_noone_entered = "Никто не участвовал в лотерее.",
    lottery_won = "%s выигрывает в лотерее! Выигрыш составил %s.",
    lottery = "лотерея",
    lottery_please_specify_an_entry_cost = "Укажите сумму для участия (%s-%s).",
    too_few_players_for_lottery = "Недостаточно игроков для начала лотереи. Нужно как минимум %d игрока.",
    lottery_ongoing = "Невозможно начать лотерею, поскольку она уже проводится.",

    -- Анимации
    custom_animation = "Анимации!",
    bow = "Поклон",
    sexy_dance = "Сексуальный танец",
    follow_me = "За мной!",
    laugh = "Смех",
    lion_pose = "Поза льва",
    nonverbal_no = "Нет",
    thumbs_up = "Палец вверх",
    wave = "Помахать",
    dance = "Танец",

    -- Модуль голода
    starving = "Голод!",

    -- Модуль бездействия
    afk_mode = "Режим бездействия",
    unable_afk_spam_prevention = "Подождите перед повторным переходом в режим бездействия.",
    salary_frozen = "Ваша зарплата заморожена.",
    salary_restored = "С возвращением! Ваша зарплата разморожена.",
    no_auto_demote = "Вы не будете уволены автоматически.",
    youre_afk_demoted = "Вы были уволены за длительное бездействие. В следующий раз используйте /afk.",
    hes_afk_demoted = "%s увольняется за длительное бездействие.",
    afk_cmd_to_exit = "Введите /afk, чтобы выйти из этого режима.",
    player_now_afk = "%s переходит в режиме бездействия.",
    player_no_longer_afk = "%s покидает режим бездействия.",

    -- Модуль меню заказов
    hit = "заказ",
    hitman = "Наёмный убийца",
    current_hit = "Цель: %s",
    cannot_request_hit = "Не удалось заказать убийство! %s",
    hitmenu_request = "Заказать",
    player_not_hitman = "Этот игрок не наёмный убийца!",
    distance_too_big = "Слишком большое расстояние.",
    hitman_no_suicide = "Наёмный убийца не убьёт самого себя.",
    hitman_no_self_order = "Наёмный убийца не может заказать убийство",
    hitman_already_has_hit = "У наёмного убийцы уже есть заказ.",
    price_too_low = "Цена слишком мала!",
    hit_target_recently_killed_by_hit = "Цель уже была недавно убита по заказу.",
    customer_recently_bought_hit = "Заказчик недавно уже делал заказ.",
    accept_hit_question = "Принять заказ от %s\nна %s за %s%d?", -- обратная совместимость
    accept_hit_request = "Принять заказ от %s\nна %s за %s?",
    hit_requested = "Заказ запрошен!",
    hit_aborted = "Заказ прерван! %s",
    hit_accepted = "Заказ принят!",
    hit_declined = "Наёмный убийца не принял заказ!",
    hitman_left_server = "Наёмный убийца покинул сервер!",
    customer_left_server = "Заказчик покинул сервер!",
    target_left_server = "Цель покинула сервер!",
    hit_price_set_to_x = "Цена заказов изменена на %s%d.", -- обратная совместимость
    hit_price_set = "Цена заказов изменена на %s.",
    hit_complete = "%s выполняет заказ!",
    hitman_died = "Наёмный убийца умер!",
    target_died = "Цель умерла!",
    hitman_arrested = "Наёмный убийца арестован!",
    hitman_changed_team = "Наёмный убийца сменил работу!",
    x_had_hit_ordered_by_y = "%s уже выполняет заказ от %s",
    place_a_hit = "заказать убийство!",
    hit_cancel = "отмену заказа!",
    hit_cancelled = "Заказ отменён!",
    no_active_hit = "Нет активных заказов!",

    -- Ограничения на голосования
    gangsters_cant_vote_for_government = "Бандиты не могут участвовать в правительственных голосованиях!",
    government_cant_vote_for_gangsters = "Государственные служащие не могут участвовать в криминальных голосованиях!",

    -- Визуальный интерфейс и фразы о дверях/транспорте
    vote = "Голосование",
    time = "Время: %d",
    yes = "Да",
    no = "Нет",
    ok = "ОК",
    cancel = "Отмена",
    add = "Добавить",
    remove = "Удалить",
    none = "Нет",

    x_options = "Настройки (%s)",
    sell_x = "Продать %s",
    set_x_title = "Переименовать %s",
    set_x_title_long = "Введите новое название объекту (%s), на который вы смотрите.",
    jobs = "Работы",
    buy_x = "Купить %s",

    -- Меню F4
    ammo = "патроны",
    weapon_ = "оружие",
    no_extra_weapons = "У этой работы нет дополнительного оружия.",
    become_job = "Выбрать работу",
    create_vote_for_job = "Начать голосование",
    shipment = "поставку",
    Shipments = "Поставки",
    shipments = "поставки",
    F4guns = "Оружие",
    F4entities = "Разное",
    F4ammo = "Патроны",
    F4vehicles = "Транспорт",

    -- Вкладка 1
    give_money = "Дать денег тому, на кого вы смотрите",
    drop_money = "Бросить деньги",
    change_name = "Изменить ролевое имя",
    go_to_sleep = "Заснуть или проснуться",
    drop_weapon = "Выбросить текущее оружие",
    buy_health = "Купить здоровье (%s)",
    request_gunlicense = "Запросить лицензию на оружие",
    demote_player_menu = "Уволить игрока",

    searchwarrantbutton = "Отправить игрока в розыск",
    unwarrantbutton = "Убрать игрока из розыска",
    noone_available = "Никто не доступен",
    request_warrant = "Запросить ордер на обыск игрока",
    make_wanted = "Отправить игрока в розыск",
    make_unwanted = "Убрать игрока из розыска",
    set_jailpos = "Установить позицию тюрьмы",
    add_jailpos = "Добавить позицию тюрьмы",

    set_custom_job = "Изменить название работы ([ENTER] Активировать)",

    set_agenda = "Изменить повестку ([ENTER] Активировать)",

    initiate_lockdown = "Начать комендантский час",
    stop_lockdown = "Закончить комендантский час",
    start_lottery = "Начать лотерею",
    give_license_lookingat = "Выдать лицензию на оружие (на кого смотрите)",

    laws_of_the_land = "ЗАКОНЫ ГОРОДА",
    law_added = "Закон добавлен.",
    law_removed = "Закон удалён.",
    law_reset = "Законы сброшены.",
    law_too_short = "Закон слишком короткий.",
    laws_full = "Достигнут максимум законов.",
    default_law_change_denied = "Вы не можете изменить стандартные законы.",

    -- Вкладка 2
    job_name = "Имя: ",
    job_description = "Описание: ",
    job_weapons = "Оружие: ",

    -- Вкладка энтити
    buy_a = "Купить %s: %s",

    -- Вкладка легального оружия
    license_tab = [[Легальное оружие

    Отметьте оружие, которое люди могут получить без лицензии!
    ]],
    license_tab_other_weapons = "Другое оружие:",
}

-- Языковой код обычно (не всегда) состоит из двух символов. Для английского языка это "en".
-- Другие примеры: "nl" для голландского, "de" для немецкого, "ru" для русского.
-- Если вы хотите узнать свой языковой код, запустите GMod, выберите язык справа снизу
-- затем введите gmod_language в консоль. После этого вам будет показан ваш код.
-- Убедитесь в том, что введённое значение допустимо для консольной переменной gmod_language.
DarkRP.addLanguage("en", my_language)
