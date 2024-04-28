YAWS.Language.Languages['English'] = {
    --
    -- Chat Messages
    --
    chat_no_permission = "You aren't allowed to do that.", -- They aren't allowed to perform a certain action.
    net_cooldown = "Your sending too many packets to the server, please wait and try again.", -- They're spamming the server with net messages.

    admin_permissions_saved = "Successfully saved your new permissions.", -- Confirmation that the new permissions have been saved.
    admin_config_saved = "Successfully saved your config.", -- Confirmation that the new config have been saved.

    admin_preset_added = "Successfully added a new preset.", -- Confirmation that a new preset has been added.
    admin_preset_nope = "Your preset is missing information.", -- Preset tried to be submitted without a name and/or reason.
    admin_preset_dupe = "A preset with that name already exists.", -- Preset tried to be submitted without a unique name.
    admin_preset_cantfind = "That preset can't be found.", -- Preset can't be found.
    admin_preset_removed = "Preset was removed.", -- Preset was removed.
    admin_preset_limit = "You can't have more than 32 presets.", -- Hitting the preset count limit.

    admin_player_warned = "Successfully warned %s.", -- Conformation to the admin that a player got warned.
    admin_player_note_update = "Successfully updated that players admin notes.", -- Conformation to the admin that a players notes got updated.
    admin_player_wipewarns = "Successfully wiped all warnings from %s.", -- Conformation to the admin that a players warnings got wiped.

    admin_punishment_created = "Punishment created.", -- Conformation that a punishment got created
    admin_punishment_removed = "Punishment removed.", -- Conformation that a punishment got created
    
    player_warn_notice = "%s has issued a warn to you, for the following reason: %s", -- Message to the player they got warned.
    player_warn_broadcast = "%s has been warned by %s for the following reason: %s", -- Broadcast to everyone about a warning.
    player_warn_immune = "This player is immune from being warned.", -- Message to the player that they can't be warned.
    player_warn_noreason = "Please specify a reason to warn this player.", -- Tried to warn a player without a reason.
    player_warn_toolong = "Your reason cannot be longer than 150 characters.", -- Reason is too long.
    player_warn_maxpoints = "You can only put a maximum of %s points on a warn.", -- Tried to warn a player with more than the max points.
    player_warn_help = "To warn a player through the chat, use: !warn <player> <point count> <reason>", -- Help for warning in the chat
    player_warn_ui = "You cannot warn through the chat as you are only permitted to use presets.", -- Message to the player that they can't warn through the chat.
    player_warn_not_found = "Could not find player \"%s\".", -- Tried to warn a player through the chat that couldn't be found
    player_warn_wrongpoints = "The point count specified was invalid.", -- Tried to warn a player through the chat with an invalid point count.
    player_warn_notyou = "You can't warn yourself.", -- Tried to warn themselves.
    player_warn_deleted = "Successfully deleted warning.", -- Deleted warning.

    --
    -- UI
    --
    generic_save = "Save Changes", -- Used for any "save" buttons.
    generic_cancel = "Cancel", -- Used for any "cancel" buttons.
    generic_back = "Back", -- Used for any "back" buttons.
    generic_point_count = "Point Count", -- For the "point count" placeholders
    generic_delete = "Delete", -- Delete generic
    
    -- Sidebar Tabs
    sidebar_warnings = "Warnings", -- Sidebar text for the warnings tab.
    sidebar_players = "Players", -- Sidebar text for the players tab.
    sidebar_admin = "Admin", -- Sidebar text for the admin tab.
    sidebar_settings = "Settings", -- Sidebar text for the settings tab.
    sidebar_close = "Close", -- Sidebar text for the close button.
    
    -- Players tab
    players_tab_search = "Search via name/steamid(64).", -- Text for the search box in the Players tab without online players.
    players_tab_search_button = "Submit Search", -- Text for the search button.
    players_tab_offline = "Search for offline players too?", -- Include offline players text. Careful of how big this is.
    
    viewing_player_no_warns_found = "There were no warnings found for this player.", -- Message when no warnings are found for a player.
    viewing_player_action_submit_warn = "Submit New Warning", -- Button for submitting a new warning.
    viewing_player_action_view_notes = "View Admin Notes", -- Button for viewing admin notes.
    viewing_player_player_notes = "Admin Notes", -- Admin Notes placeholder
    viewing_player_save_player_notes = "Save Admin Notes", -- Save the admin notes button

    viewing_player_table_admin = "Admin", -- Admin table header
    viewing_player_table_reason = "Reason", -- Reason table header
    viewing_player_table_time = "Time", -- Time table header
    viewing_player_table_points = "Points", -- Points table header
    viewing_player_table_server = "Server", -- Server table header

    viewing_player_table_right_admin = "Copy Admin", -- Copy admin button
    viewing_player_table_right_reason = "Copy Reason", -- Copy reason button
    viewing_player_table_right_time = "Copy Time", -- Copy time button
    viewing_player_table_right_points = "Copy Points Added", -- Copy points button
    viewing_player_table_right_server = "Copy Server Name", -- Copy server button
    viewing_player_table_right_log = "Copy as Log", -- Copy server button

    viewing_player_wipe_header = "Wipe all of %s's warnings?", -- Wipe a players warnings header
    viewing_player_wipe_subtext = "This is irreversible. Make sure this is what you want to do.", -- Wipe a players warnings subtext

    viewing_warn_time = "Time", -- Time header
    viewing_warn_point = "Point Penalty", -- Points header
    viewing_warn_server = "Server", -- Server header
    viewing_warn_reason = "Reason", -- Reason header

    -- Warning Players
    warn_player_submit = "Warn Player", -- Warn Player submit.
    warn_player_reason = "Reason for Warn", -- Reason for warn placeholder.

    -- Admin Tab
    admin_tab_sidebar_permissions = "Permissions", -- Sidebar text for the permissions tab. 
    admin_tab_sidebar_settings = "Settings", -- Sidebar text for the settings tab. 
    admin_tab_sidebar_presets = "Presets", -- Sidebar text for the presets tab. 
    admin_tab_sidebar_punishments = "Punishments", -- Sidebar text for the punishments tab. 
    
    admin_tab_presets_none = "There were no presets found", -- No presets found.
    admin_tab_presets_name = "Preset Name", -- Name in preset creation. 
    admin_tab_presets_reason = "Preset Reason", -- Reason in preset creation. 
    admin_tab_presets_create = "Create Preset", -- Create Preset button. 

    admin_tab_punishments_selecttype = "Select Punishment Type", -- Text in selecting a punishment type. 
    admin_tab_punishments_create = "Create Punishment Threshold", -- Text in selecting a punishment type. 
    admin_tab_punishments_notype = "No punishment type selected.", -- Default text for the descripton. 
    admin_tab_punishments_none = "There were no punishments found", -- Default text for the descripton. 

    admin_tab_warning_presets_box = "Select a Preset", -- Selecting a preset placeholder
    admin_tab_warning_reason_placeholder = "Enter a Reason", -- Enter a reason placeholder


    -- 
    -- Misc 
    -- 
    yaws = "Yet Another Warning System", -- For the context menu
    context_warn = "Warn this Player", -- Warn Player button in the context menu
    context_presets = "Warn this Player using Presets", -- Warn Player button in the context menu w/ presets
    context_points = "Point Count: %s", -- Point Count viewing
    context_reason = "Warning Reason: %s", -- Reason viewing
    context_submit = "Submit Warning", -- Submit Warning
    context_viewwarns = "View Warnings", -- View Warnings
    context_viewnotes = "View Admin Notes", -- View Admin Notes

    points_format = "%s Points", -- Points format for fancy UIs

    loading = "Loading...", -- Loading screen
    loading_hehe = "Playing Satisfactory...", -- aGVoZQ==

    -- Permission names
    permission_view_ui = "Open the UI",
    permission_view_self_warns = "View Their Own Warnings",
    permission_view_others_warns = "View Others Warnings",
    permission_view_admin_settings = "View and Edit Admin Settings",
    permission_create_warns = "Create Warnings",
    permission_customise_reason = "Use Custom Reasons",
    permission_delete_warns = "Delete Warnings",

    -- User settings names/descriptions
    user_settings_darkmode_name = "Dark Mode",
    user_settings_darkmode_desc = "Enable dark mode inside the UI.",

    user_settings_language_name = "Language",
    user_settings_language_desc = "Which langauge would you like to see the addon in? Requires reopening the UI.",

    -- Admin settings names/descriptions
    admin_settings_prefix_name = "Prefix",
    admin_settings_prefix_desc = "The prefix the addon will use in chat messages.",

    admin_settings_prefix_color_name = "Prefix Color",
    admin_settings_prefix_color_desc = "The color of the prefix for chat messages.",

    admin_settings_broadcast_warns_name = "Broadcast Warnings",
    admin_settings_broadcast_warns_desc = "If true, the addon will broadcast warnings to everyone online.",

    admin_settings_point_cooldown_time_name = "Point Cooldown",
    admin_settings_point_cooldown_time_desc = "How long in seconds it takes for active points to be removed from a player. Set to 0 to disable this.",

    admin_settings_point_cooldown_amount_name = "Point Cooldown Amount",
    admin_settings_point_cooldown_amount_desc = "How many points to deduce each cooldown. Won't do anything if it's disabled.",

    admin_settings_reason_required_name = "Reason Required?",
    admin_settings_reason_required_desc = "If true, admins will be required to put a reason for every warn.",

    admin_settings_point_max_name = "Maximum Points",
    admin_settings_point_max_desc = "The maximum amount of points one warn can have.",

    admin_settings_purge_on_punishment_name = "Purge on Punishment",
    admin_settings_purge_on_punishment_desc = "If true, the addon will mark all a players points as inactive when they are punished.",
}