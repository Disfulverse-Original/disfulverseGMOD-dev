-- Russian translation created by Levanchik
-- https://www.gmodstore.com/users/76561198301239655

YAWS.Language.Languages['Russian'] = {
    --
    -- Chat Messages
    --
    chat_no_permission = "У Вас не достаточно привилегий для этого.", -- They aren't allowed to perform a certain action.
    net_cooldown = "Вы посылаете слишком много Net-пакетов, постарайтесь позже.", -- They're spamming the server with net messages.

    admin_permissions_saved = "Успешно сохранены Ваши новые привилегии.", -- Confirmation that the new permissions have been saved.
    admin_config_saved = "Успешно сохранили настройки.", -- Confirmation that the new config have been saved.

    admin_preset_added = "Успешно добавлен пресет.", -- Confirmation that a new preset has been added.
    admin_preset_nope = "В Вашем пресете отсутствует информация.", -- Preset tried to be submitted without a name and/or reason.
    admin_preset_dupe = "Пресет с таким именем уже существует.", -- Preset tried to be submitted without a unique name.
    admin_preset_cantfind = "Этот пресет не найден.", -- Preset can't be found.
    admin_preset_removed = "Пресет удален.", -- Preset was removed.
    admin_preset_limit = "Вы не можете иметь больше 32-ух пресетов.", -- Hitting the preset count limit.

    admin_player_warned = "Успешно предупрежден %s.", -- Conformation to the admin that a player got warned.
    admin_player_note_update = "Успешно обновлены, примечания администратора.", -- Conformation to the admin that a players notes got updated.
    admin_player_wipewarns = "Успешно удалены все предупреждения игроку %s.", -- Conformation to the admin that a players warnings got wiped.

    admin_punishment_created = "Наказание, созданное.", -- Conformation that a punishment got created
    admin_punishment_removed = "Наказание, удалено.", -- Conformation that a punishment got created
    
    player_warn_notice = "%s вынес Вам предупреждение по следующей причине: %s", -- Message to the player they got warned.
    player_warn_broadcast = "%s предупрежден %s по причине: %s", -- Broadcast to everyone about a warning.
    player_warn_immune = "Этот игрок защищен от предупреждений.", -- Message to the player that they can't be warned.
    player_warn_noreason = "Пожалуйста, укажите причину для предупреждения этого игрока.", -- Tried to warn a player without a reason.
    player_warn_toolong = "Ваша причина не может быть длиннее 150 символов.", -- Reason is too long.
    player_warn_maxpoints = "Вы можете поставить только максимум %s баллов предупреждений.", -- Tried to warn a player with more than the max points.
    player_warn_help = "Чтобы предупредить игрока через чат, используйте: !warn <игрок> <кол-во баллов предупреждений> <причина>", -- Help for warning in the chat
    player_warn_ui = "Вы не можете предупреждать через чат, так как Вам разрешено использовать только пресеты.", -- Message to the player that they can't warn through the chat.
    player_warn_not_found = "Невозможно найти пользователя \"%s\".", -- Tried to warn a player through the chat that couldn't be found
    player_warn_wrongpoints = "Указанное количество баллов было неверным.", -- Tried to warn a player through the chat with an invalid point count.
    player_warn_notyou = "Вы не моежет предупредить самого себя.", -- Tried to warn themselves.
    player_warn_deleted = "Предупреждение успешно удалено.", -- Deleted warning.

    --
    -- UI
    --
    generic_save = "Сохранить изменения", -- Used for any "save" buttons.
    generic_cancel = "Отменить", -- Used for any "cancel" buttons.
    generic_back = "Назад", -- Used for any "back" buttons.
    generic_point_count = "Количество", -- For the "point count" placeholders
    generic_delete = "Удалить", -- Delete generic
    
    -- Sidebar Tabs
    sidebar_warnings = "Преды", -- Sidebar text for the warnings tab.
    sidebar_players = "Пользователи", -- Sidebar text for the players tab.
    sidebar_admin = "Админ", -- Sidebar text for the admin tab.
    sidebar_settings = "Настройки", -- Sidebar text for the settings tab.
    sidebar_close = "Закрыть", -- Sidebar text for the close button.
    
    -- Players tab
    players_tab_search = "Поиск через никнейм/steamid(64).", -- Text for the search box in the Players tab without online players.
    players_tab_search_button = "Начать поиск", -- Text for the search button.
    players_tab_offline = "Искать офлайн пользователей?", -- Include offline players text. Careful of how big this is.
    
    viewing_player_no_warns_found = "Для этого пользователя не было найдено предупреждений.", -- Message when no warnings are found for a player.
    viewing_player_action_submit_warn = "Подтвердить новое предупреждение", -- Button for submitting a new warning.
    viewing_player_action_view_notes = "Посмотреть заметки администратора", -- Button for viewing admin notes.
    viewing_player_player_notes = "Заметки администратора", -- Admin Notes placeholder
    viewing_player_save_player_notes = "Сохранить заметку", -- Save the admin notes button

    viewing_player_table_admin = "Админ", -- Admin table header
    viewing_player_table_reason = "Причина", -- Reason table header
    viewing_player_table_time = "Время", -- Time table header
    viewing_player_table_points = "Баллы", -- Points table header
    viewing_player_table_server = "Сервер", -- Server table header

    viewing_player_table_right_admin = "Скопировать админа", -- Copy admin button
    viewing_player_table_right_reason = "Скопировать причину", -- Copy reason button
    viewing_player_table_right_time = "Скопировать время", -- Copy time button
    viewing_player_table_right_points = "Скопировать баллы", -- Copy points button
    viewing_player_table_right_server = "Скопировать название сервера", -- Copy server button
    viewing_player_table_right_log = "Скопировать лог", -- Copy server button

    viewing_player_wipe_header = "Удалить все предупреждения игроку %s?", -- Wipe a players warnings header
    viewing_player_wipe_subtext = "Это необратимое действие, у игрока пропадут все предупреждения которые были выданы ранее.", -- Wipe a players warnings subtext

    viewing_warn_time = "Время", -- Time header
    viewing_warn_point = "Баллы", -- Points header
    viewing_warn_server = "Сервер", -- Server header
    viewing_warn_reason = "Причина", -- Reason header

    -- Warning Players
    warn_player_submit = "Предупредить пользователя", -- Warn Player submit.
    warn_player_reason = "Причина предупреждения", -- Reason for warn placeholder.

    -- Admin Tab
    admin_tab_sidebar_permissions = "Полномочия", -- Sidebar text for the permissions tab. 
    admin_tab_sidebar_settings = "Настройки", -- Sidebar text for the settings tab. 
    admin_tab_sidebar_presets = "Пресеты", -- Sidebar text for the presets tab. 
    admin_tab_sidebar_punishments = "Наказания", -- Sidebar text for the punishments tab. 
    
    admin_tab_presets_none = "Пресетов найдено не было", -- No presets found.
    admin_tab_presets_name = "Название пресета", -- Name in preset creation. 
    admin_tab_presets_reason = "Причина пресета", -- Reason in preset creation. 
    admin_tab_presets_create = "Создать пресета", -- Create Preset button. 

    admin_tab_punishments_selecttype = "Выберите тип наказания", -- Text in selecting a punishment type. 
    admin_tab_punishments_create = "Создать порог наказания", -- Text in selecting a punishment type. 
    admin_tab_punishments_notype = "Тип наказания не выбран.", -- Default text for the descripton. 
    admin_tab_punishments_none = "Никаких наказаний найдено не было", -- Default text for the descripton. 

    admin_tab_warning_presets_box = "Выбрать пресет", -- Selecting a preset placeholder
    admin_tab_warning_reason_placeholder = "Ввести причину", -- Enter a reason placeholder


    -- 
    -- Misc 
    -- 
    yaws = "Еще одна система предупреждения", -- For the context menu
    context_warn = "Предупредить этого пользователя", -- Warn Player button in the context menu
    context_presets = "Предупредите этого пользоваетля, используя пресеты", -- Warn Player button in the context menu w/ presets
    context_points = "Баллы предупреждения: %s", -- Point Count viewing
    context_reason = "Причина предупреждения: %s", -- Reason viewing
    context_submit = "Подтвердить предупреждение", -- Submit Warning
    context_viewwarns = "Посмотреть предупреждения", -- View Warnings
    context_viewnotes = "Посмотреть заметки администратора", -- View Admin Notes

    points_format = "%s Баллов", -- Points format for fancy UIs

    loading = "Загрузка...", -- Loading screen
    loading_hehe = "Играем в Майнкрафт...", -- aGVoZQ==

    -- Permission names
    permission_view_ui = "Открыть меню",
    permission_view_self_warns = "Просматреть их предупреждения",
    permission_view_others_warns = "Посмотреть другие предупреждения",
    permission_view_admin_settings = "Просмотр и редакция настроек",
    permission_create_warns = "Создать предупреждения",
    permission_customise_reason = "Использовать свою причину",
    permission_delete_warns = "Удалить предупреждения",

    -- User settings names/descriptions
    user_settings_darkmode_name = "Тёмная тема",
    user_settings_darkmode_desc = "Включает тёмную тему для меню.",

    user_settings_language_name = "Языки",
    user_settings_language_desc = "Какой язык Вы хотите использовать.",

    -- Admin settings names/descriptions
    admin_settings_prefix_name = "Префикс",
    admin_settings_prefix_desc = "Префикс аддона.",

    admin_settings_prefix_color_name = "Цвет префикса",
    admin_settings_prefix_color_desc = "Цвет префикса который будет выводиться в сообщениях.",

    admin_settings_broadcast_warns_name = "Уведомление предупреждений",
    admin_settings_broadcast_warns_desc = "Если включено, то все пользователи сервера увидят предупреждения для игрока.",

    admin_settings_point_cooldown_time_name = "Время для снятия предупреждений.",
    admin_settings_point_cooldown_time_desc = "Сколько времени в секундах для снятия предупреждения. При 0 выключено.",

    admin_settings_point_cooldown_amount_name = "Количество баллов перезарядки",
    admin_settings_point_cooldown_amount_desc = "Сколько баллов нужно начислять за каждый кулдаун. Работает если включен.",

    admin_settings_reason_required_name = "Требуемая причина?",
    admin_settings_reason_required_desc = "Если включено, то администраторы должны вводить причину.",

    admin_settings_point_max_name = "Максимум баллов",
    admin_settings_point_max_desc = "Максимальное количество баллов, которое может получить один игрок.",

    admin_settings_purge_on_punishment_name = "Очистить наказания",
    admin_settings_purge_on_punishment_desc = "Если включено, аддон отметит все баллы игроков как неактивные, когда они будут наказаны.",
}