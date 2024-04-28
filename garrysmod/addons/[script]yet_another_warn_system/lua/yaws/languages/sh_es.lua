-- Spanish translation created by Goran
-- https://www.gmodstore.com/users/Goran

YAWS.Language.Languages['Spanish'] = {
    --
    -- Chat Messages
    --
    chat_no_permission = "No tienes permitido hacer eso.", -- They aren't allowed to perform a certain action.
    net_cooldown = "Estás enviando demasiados paquetes al servidor, por favor espera e inténtalo de nuevo.", -- They're spamming the server with net messages.

    admin_permissions_saved = "Tus nuevos permisos fueron satisfactoriamente guardados.", -- Confirmation that the new permissions have been saved.
    admin_config_saved = "Tu configuración fue guardada satisfactoriamente.", -- Confirmation that the new config have been saved.

    admin_preset_added = "Nuevo preajuste añadido satisfactoriamente.", -- Confirmation that a new preset has been added.
    admin_preset_nope = "A tu preajuste le falta información.", -- Preset tried to be submitted without a name and/or reason.
    admin_preset_dupe = "Ya existe un preajuste con ese nombre.", -- Preset tried to be submitted without a unique name.
    admin_preset_cantfind = "El preajuste no fue encontrado.", -- Preset can't be found.
    admin_preset_removed = "El preajuste fue removido.", -- Preset was removed.
    admin_preset_limit = "No puedes tener más de 32 preajustes.", -- Hitting the preset count limit.
    
    admin_player_warned = "%s fue advertido satisfactoriamente.", -- Conformation to the admin that a player got warned.
    admin_player_note_update = "Las notas de administración de ese jugador fueron actualizadas.", -- Conformation to the admin that a players notes got updated.
    admin_player_wipewarns = "Todas las advertencias de %s fueron removidas.", -- Conformation to the admin that a players warnings got wiped.

    admin_punishment_created = "Castigo creado.", -- Conformation that a punishment got created
    admin_punishment_removed = "Castigo removido.", -- Conformation that a punishment got created
    
    player_warn_notice = "%s te ha dado una advertencia por el siguiente motivo: %s", -- Message to the player they got warned.
    player_warn_broadcast = "%s ha recibido una advertencia de %s por el siguiente motivo: %s", -- Broadcast to everyone about a warning.
    player_warn_immune = "Este jugador no puede recibir advertencias.", -- Message to the player that they can't be warned.
    player_warn_noreason = "Por favor especifica una razón para dar una advertencia a este jugador.", -- Tried to warn a player without a reason.
    player_warn_toolong = "La razón no puede ser de más de 150 caracteres.", -- Reason is too long.
    player_warn_maxpoints = "Puedes poner un máximo de %s puntos en una advertencia.", -- Tried to warn a player with more than the max points.
    player_warn_help = "Para advertir a un jugador a través del chat, utiliza !warn <jugador> <puntos> <razón>", -- Help for warning in the chat
    player_warn_ui = "No puedes aplicar una advertencia a través del chat ya que sólo puedes utilizar preajustes.", -- Message to the player that they can't warn through the chat.
    player_warn_not_found = "No se encontró al jugador \"%s\".", -- Tried to warn a player through the chat that couldn't be found
    player_warn_wrongpoints = "La cantidad de puntos especificada es inválida.", -- Tried to warn a player through the chat with an invalid point count.
    player_warn_notyou = "No puedes aplicarte una advertencia a ti mismo.", -- Tried to warn themselves.
    player_warn_deleted = "Advertencia eliminada satisfactoriamente.", -- Deleted warning.

    --
    -- UI
    --
    generic_save = "Guardar Cambios", -- Used for any "save" buttons.
    generic_cancel = "Cancelar", -- Used for any "cancel" buttons.
    generic_back = "Atrás", -- Used for any "back" buttons.
    generic_point_count = "Cantidad de Puntos", -- For the "point count" placeholders
    generic_delete = "Eliminar", -- Delete generic
    
    -- Sidebar Tabs
    sidebar_warnings = "Advertencias", -- Sidebar text for the warnings tab.
    sidebar_players = "Jugadores", -- Sidebar text for the players tab.
    sidebar_admin = "Administración", -- Sidebar text for the admin tab.
    sidebar_settings = "Ajustes", -- Sidebar text for the settings tab.
    sidebar_close = "Cerrar", -- Sidebar text for the close button.
    
    -- Players tab
    players_tab_search = "Buscar vía nombre/steamid(64).", -- Text for the search box in the Players tab without online players.
    players_tab_search_button = "Efectuar Búsqueda", -- Text for the search button.
    players_tab_offline = "¿Incluir a jugadores desconectados?", -- Include offline players text. Careful of how big this is.
    
    viewing_player_no_warns_found = "No se encontraron advertencias para este jugador.", -- Message when no warnings are found for a player.
    viewing_player_action_submit_warn = "Emitir nueva advertencia", -- Button for submitting a new warning.
    viewing_player_action_view_notes = "Ver Notas de Administración", -- Button for viewing admin notes.
    viewing_player_player_notes = "Notas de Administración", -- Admin Notes placeholder
    viewing_player_save_player_notes = "Save Admin Notes", -- Save the admin notes button

    viewing_player_table_admin = "Administrar", -- Admin table header
    viewing_player_table_reason = "Razón", -- Reason table header
    viewing_player_table_time = "Tiempo", -- Time table header
    viewing_player_table_points = "Puntos", -- Points table header
    viewing_player_table_server = "Servidor", -- Server table header

    viewing_player_table_right_admin = "Copiar Administración", -- Copy admin button
    viewing_player_table_right_reason = "Copiar Razón", -- Copy reason button
    viewing_player_table_right_time = "Copiar Tiempo", -- Copy time button
    viewing_player_table_right_points = "Copiar Puntos Agregados", -- Copy points button
    viewing_player_table_right_server = "Copiar Nombre de Servidor", -- Copy server button
    viewing_player_table_right_log = "Copiar como Log", -- Copy server button

    viewing_player_wipe_header = "¿Deseas remover todas las advertencias de %s?", -- Wipe a players warnings header
    viewing_player_wipe_subtext = "Esto es irreversible. Asegúrate de saber lo que estás haciendo.", -- Wipe a players warnings subtext

    viewing_warn_time = "Tiempo", -- Time header
    viewing_warn_point = "Sanción de Puntos", -- Points header
    viewing_warn_server = "Servidor", -- Server header
    viewing_warn_reason = "Razón", -- Reason header

    -- Warning Players
    warn_player_submit = "Advertir a Jugador", -- Warn Player submit.
    warn_player_reason = "Razón para la Advertencia", -- Reason for warn placeholder.

    -- Admin Tab
    admin_tab_sidebar_permissions = "Permisos", -- Sidebar text for the permissions tab. 
    admin_tab_sidebar_settings = "Ajustes", -- Sidebar text for the settings tab. 
    admin_tab_sidebar_presets = "Preajustes", -- Sidebar text for the presets tab. 
    admin_tab_sidebar_punishments = "Castigos", -- Sidebar text for the punishments tab. 
    
    admin_tab_presets_none = "No se encontraron preajustes", -- No presets found.
    admin_tab_presets_name = "Nombre del Preajuste", -- Name in preset creation. 
    admin_tab_presets_reason = "Razón del Preajuste", -- Reason in preset creation. 
    admin_tab_presets_create = "Crear Preajuste", -- Create Preset button. 

    admin_tab_punishments_selecttype = "Seleccionar Tipo de Castigo", -- Text in selecting a punishment type. 
    admin_tab_punishments_create = "Crear Límite de Castigos", -- Text in selecting a punishment type. 
    admin_tab_punishments_notype = "No se seleccionó ningún Tipo de Castigo.", -- Default text for the descripton. 
    admin_tab_punishments_none = "No se encontró ningún Castigo", -- Default text for the descripton. 

    admin_tab_warning_presets_box = "Elige un Preajuste", -- Selecting a preset placeholder
    admin_tab_warning_reason_placeholder = "Ingresa una Razón", -- Enter a reason placeholder


    -- 
    -- Misc 
    -- 
    yaws = "Otro Sistema de Advertencias", -- For the context menu
    context_warn = "Advertir a este jugador", -- Warn Player button in the context menu
    context_presets = "Advertir a este jugador utilizando Preajustes", -- Warn Player button in the context menu w/ presets
    context_points = "Contador de Puntos: %s", -- Point Count viewing
    context_reason = "Razón: %s", -- Reason viewing
    context_submit = "Emitir Advertencia", -- Submit Warning
    context_viewwarns = "Ver Advertencias", -- View Warnings
    context_viewnotes = "Ver Notas de Administración", -- View Admin Notes

    points_format = "%s Puntos", -- Points format for fancy UIs

    loading = "Cargando...", -- Loading screen
    loading_hehe = "Reproduciendo Satisfactoriamente...", -- aGVoZQ==

    -- Permission names
    permission_view_ui = "Abrir la IU",
    permission_view_self_warns = "Ver sus propias Advertencias",
    permission_view_others_warns = "Ver las Advertencias de los demás",
    permission_view_admin_settings = "Ver y Editar Ajustes de Administración",
    permission_create_warns = "Crear Advertencias",
    permission_customise_reason = "Utilizar Razones Personalizadas",
    permission_delete_warns = "Remover Advertencias",

    -- User settings names/descriptions
    user_settings_darkmode_name = "Modo Oscuro",
    user_settings_darkmode_desc = "Habilitar el modo oscuro en la IU.",

    user_settings_language_name = "Idioma",
    user_settings_language_desc = "¿Qué idioma deseas utilizar en el addon? Requiere reabrir la IU.",

    -- Admin settings names/descriptions
    admin_settings_prefix_name = "Prefijo",
    admin_settings_prefix_desc = "El prefijo que el addon utilizará en todos los mensajes de chat.",

    admin_settings_prefix_color_name = "Color del Prefijo",
    admin_settings_prefix_color_desc = "El color del prefijo para los mensajes de chat.",

    admin_settings_broadcast_warns_name = "Transmisión de Advertencias",
    admin_settings_broadcast_warns_desc = "Si se activa, el addon transmitirá las advertencias a todos los jugadores en línea.",

    admin_settings_point_cooldown_time_name = "Tiempo de Enfriamiento de Puntos",
    admin_settings_point_cooldown_time_desc = "Tiempo en segundos para que se remuevan los puntos activos de un jugador. 0 para desactivar.",

    admin_settings_point_cooldown_amount_name = "Cantidad de Puntos a remover",
    admin_settings_point_cooldown_amount_desc = "Cuántos puntos serán removidos al cumplir el enfriamiento. No hará nada si se desactiva.",

    admin_settings_reason_required_name = "¿Razón requerida?",
    admin_settings_reason_required_desc = "Si se activa, los administradores deberán establecer una razón para advertir a alguien.",

    admin_settings_point_max_name = "Puntos Máximos",
    admin_settings_point_max_desc = "La cantidad máxima de puntos que una advertencia puede tener.",

    admin_settings_purge_on_punishment_name = "Purgar al Castigar",
    admin_settings_purge_on_punishment_desc = "Si se activa, el addon marcará todos los puntos del jugador como inactivos cuando sea castigado.",
}