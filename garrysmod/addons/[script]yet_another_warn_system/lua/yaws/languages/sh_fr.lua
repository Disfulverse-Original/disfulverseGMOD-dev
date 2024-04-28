-- French translation created by Sabatore
-- https://www.gmodstore.com/users/76561198392047603

YAWS.Language.Languages['French'] = {
    --
    -- Chat Messages
    --
    chat_no_permission = "Tu n'as pas le droit de faire ça.", -- They aren't allowed to perform a certain action.
    net_cooldown = "Vous envoyez trop de paquets au serveur, veuillez patienter et réessayer.", -- They're spamming the server with net messages.

    admin_permissions_saved = "Vos nouvelles permissions ont bien été enregistrées.", -- Confirmation that the new permissions have been saved.
    admin_config_saved = "Votre configuration a été enregistrée avec succès.", -- Confirmation that the new config have been saved.

    admin_preset_added = "Un nouveau préréglage a été ajouté avec succès.", -- Confirmation that a new preset has been added.
    admin_preset_nope = "Votre préréglage manque d'informations.", -- Preset tried to be submitted without a name and/or reason.
    admin_preset_dupe = "Un préréglage avec ce nom existe déjà.", -- Preset tried to be submitted without a unique name.
    admin_preset_cantfind = "Ce préréglage ne peut pas être trouvé.", -- Preset can't be found.
    admin_preset_removed = "Préréglage supprimé.", -- Preset was removed.
    admin_preset_limit = "Vous ne pouvez pas avoir plus de 32 préréglages.", -- Hitting the preset count limit.
    
    admin_player_warned = "%s averti avec succès.", -- Conformation to the admin that a player got warned.
    admin_player_note_update = "Note Admin du joueur mise à jour avec succès.", -- Conformation to the admin that a players notes got updated.
    admin_player_wipewarns = "Tous les avertissements de %s ont été supprimé avec succès.", -- Conformation to the admin that a players warnings got wiped.

    admin_punishment_created = "Santion créée.", -- Conformation that a punishment got created
    admin_punishment_removed = "Santion supprimée.", -- Conformation that a punishment got created
    
    player_warn_notice = "%s vous a mis un avertissement, pour la raison suivante: %s", -- Message to the player they got warned.
    player_warn_broadcast = "%s a été averti par %s pour la raison suivante: %s", -- Broadcast to everyone about a warning.
    player_warn_immune = "Ce joueur est immunisé contre les avertissements.", -- Message to the player that they can't be warned.
    player_warn_noreason = "Veuillez spécifier une raison d'avertir ce joueur.", -- Tried to warn a player without a reason.
    player_warn_toolong = "Votre raison ne peut pas être plus longue de 150 caractères.", -- Reason is too long.
    player_warn_maxpoints = "Vous ne pouvez mettre au maximum %s points pour un avertissement.", -- Tried to warn a player with more than the max points.
    player_warn_help = "Pour avertir un joueur avec le tchat, utilisez: !warn <joueur> <quantité de point> <raison>", -- Help for warning in the chat
    player_warn_ui = "Vous ne pouvez pas avertir avec le tchat puisque vous n'avez que la permission d'utiliser les préréglages.", -- Message to the player that they can't warn through the chat.
    player_warn_not_found = "Impossible de trouver le joueur \"%s\".", -- Tried to warn a player through the chat that couldn't be found
    player_warn_wrongpoints = "Le nombre de point spécifié est invalide.", -- Tried to warn a player through the chat with an invalid point count.
    player_warn_notyou = "Vous ne pouvez pas vous avertir vous-même.", -- Tried to warn themselves.
    player_warn_deleted = "Avertissement supprimé avec succès.", -- Deleted warning.

    --
    -- UI
    --
    generic_save = "Sauvegarder les changements", -- Used for any "save" buttons.
    generic_cancel = "Quitter", -- Used for any "cancel" buttons.
    generic_back = "Retour", -- Used for any "back" buttons.
    generic_point_count = "Nombre de Point", -- For the "point count" placeholders
    generic_delete = "Supprimer", -- Delete generic
    
    -- Sidebar Tabs
    sidebar_warnings = "Avertissements", -- Sidebar text for the warnings tab.
    sidebar_players = "Joueurs", -- Sidebar text for the players tab.
    sidebar_admin = "Admin", -- Sidebar text for the admin tab.
    sidebar_settings = "Paramètres", -- Sidebar text for the settings tab.
    sidebar_close = "Fermer", -- Sidebar text for the close button.
    
    -- Players tab
    players_tab_search = "Rechercher par nom/steamid(64).", -- Text for the search box in the Players tab without online players.
    players_tab_search_button = "Rechercher", -- Text for the search button.
    players_tab_offline = "Rechercher les joueurs hors-ligne?", -- Include offline players text. Careful of how big this is.
    
    viewing_player_no_warns_found = "Aucun avertissement n'a été trouvé pour ce joueur.", -- Message when no warnings are found for a player.
    viewing_player_action_submit_warn = "Soumettre un Nouvel Avertissement", -- Button for submitting a new warning.
    viewing_player_action_view_notes = "Voir les Notes Admin", -- Button for viewing admin notes.
    viewing_player_player_notes = "Notes Admin", -- Admin Notes placeholder
    viewing_player_save_player_notes = "Sauvegarder les Notes Admin", -- Save the admin notes button

    viewing_player_table_admin = "Admin", -- Admin table header
    viewing_player_table_reason = "Raison", -- Reason table header
    viewing_player_table_time = "Temps", -- Time table header
    viewing_player_table_points = "Points", -- Points table header
    viewing_player_table_server = "Serveur", -- Server table header

    viewing_player_table_right_admin = "Copier Admin", -- Copy admin button
    viewing_player_table_right_reason = "Copier Raison", -- Copy reason button
    viewing_player_table_right_time = "Copier Temps", -- Copy time button
    viewing_player_table_right_points = "Copier Points Ajoutés", -- Copy points button
    viewing_player_table_right_server = "Copier Nom du Serveur", -- Copy server button
    viewing_player_table_right_log = "Copier comme Log", -- Copy server button

    viewing_player_wipe_header = "Supprimer tous les avertissements de %s ?", -- Wipe a players warnings header
    viewing_player_wipe_subtext = "C'est irréversible. Veillez à être sûr que c'est bien ce que vous voulez faire", -- Wipe a players warnings subtext

    viewing_warn_time = "Temps", -- Time header
    viewing_warn_point = "Point de Pénalité", -- Points header
    viewing_warn_server = "Serveur", -- Server header
    viewing_warn_reason = "Raison", -- Reason header

    -- Warning Players
    warn_player_submit = "Avertir le Joueur", -- Warn Player submit.
    warn_player_reason = "Raison d'avertir", -- Reason for warn placeholder.

    -- Admin Tab
    admin_tab_sidebar_permissions = "Permissions", -- Sidebar text for the permissions tab. 
    admin_tab_sidebar_settings = "Paramètres", -- Sidebar text for the settings tab. 
    admin_tab_sidebar_presets = "Préréglages", -- Sidebar text for the presets tab. 
    admin_tab_sidebar_punishments = "Santions", -- Sidebar text for the punishments tab. 
    
    admin_tab_presets_none = "Aucun Préréglage n'a été trouvé", -- No presets found.
    admin_tab_presets_name = "Nom du Préréglage", -- Name in preset creation. 
    admin_tab_presets_reason = "Raison du Préréglage", -- Reason in preset creation. 
    admin_tab_presets_create = "Créer le Préréglage", -- Create Preset button. 

    admin_tab_punishments_selecttype = "Sélectionner le Type de Santion", -- Text in selecting a punishment type. 
    admin_tab_punishments_create = "Créer un Seuil de Sanction", -- Text in selecting a punishment type. 
    admin_tab_punishments_notype = "Aucun Type de Sanction sélectionné.", -- Default text for the descripton. 
    admin_tab_punishments_none = "Aucune Sanction n'a été trouvée", -- Default text for the descripton. 

    admin_tab_warning_presets_box = "Sélectionner un Préréglage", -- Selecting a preset placeholder
    admin_tab_warning_reason_placeholder = "Entrer une Raison", -- Enter a reason placeholder


    -- 
    -- Misc 
    -- 
    yaws = "Yet Another Warning System", -- For the context menu
    context_warn = "Avertir ce Joueur", -- Warn Player button in the context menu
    context_presets = "Avertir ce Joueur utilisant les Préréglages", -- Warn Player button in the context menu w/ presets
    context_points = "Nombre de point: %s", -- Point Count viewing
    context_reason = "Raison de l'Avertissement: %s", -- Reason viewing
    context_submit = "Envoyer un Avertissement", -- Submit Warning
    context_viewwarns = "Voir les Avertissements", -- View Warnings
    context_viewnotes = "Voir les Notes Admin", -- View Admin Notes

    points_format = "%s Points", -- Points format for fancy UIs

    loading = "Chargement...", -- Loading screen
    loading_hehe = "Jouant à Satisfactory...", -- aGVoZQ==

    -- Permission names
    permission_view_ui = "Ouvrir l'UI",
    permission_view_self_warns = "Voir ses Propres Avertissements",
    permission_view_others_warns = "Voir d'Autres Avertissements",
    permission_view_admin_settings = "Voir et Modifier les Paramètres Admin",
    permission_create_warns = "Créer des Avertissements",
    permission_customise_reason = "Utiliser une Raison Personnalisée",
    permission_delete_warns = "Supprimer les avertissements",

    -- User settings names/descriptions
    user_settings_darkmode_name = "Mode Sombre",
    user_settings_darkmode_desc = "Active le Mode Sombre dans l'UI.",

    user_settings_language_name = "Langage",
    user_settings_language_desc = "En quelle langue voulez-vous que l'addon soit? Nécessite la réouverture de l'UI.",

    -- Admin settings names/descriptions
    admin_settings_prefix_name = "Préfixe",
    admin_settings_prefix_desc = "Le préfixe que l'addon utilisera dans les messages du tchat.",

    admin_settings_prefix_color_name = "Couleur du Préfixe",
    admin_settings_prefix_color_desc = "La Couleur du Préfixe pour le tchat.",

    admin_settings_broadcast_warns_name = "Avertissement pour tous",
    admin_settings_broadcast_warns_desc = "Si oui, l'addon va avertir toutes les personnes en ligne.",

    admin_settings_point_cooldown_time_name = "Durée des Points",
    admin_settings_point_cooldown_time_desc = "Temps en secondes pour que les points actifs soient supprimés. Réglez sur 0 pour désactiver cela.",

    admin_settings_point_cooldown_amount_name = "Durée du Temps de Recharge des Points",
    admin_settings_point_cooldown_amount_desc = "Combien de points pour déduire chaque temps de recharge. Ne fera rien s'il est désactivé.",

    admin_settings_reason_required_name = "Raison Requise?",
    admin_settings_reason_required_desc = "Si oui, les admins devront préciser une raison pour tout avertissement.",

    admin_settings_point_max_name = "Maximum de Points",
    admin_settings_point_max_desc = "Le Nombre Maximum de Points qu'un Avertissement peut avoir.",

    admin_settings_purge_on_punishment_name = "Purge de Sanction",
    admin_settings_purge_on_punishment_desc = "Si oui, l'Addon marquera tous les Points d'un Joueur comme inactifs lorsqu'ils seront sanctionnés.",
}