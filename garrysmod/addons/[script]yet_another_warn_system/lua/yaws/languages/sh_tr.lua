-- Turkish translation created by Higamato
-- https://www.gmodstore.com/users/higamato

YAWS.Language.Languages['Turkish'] = {
    --
    -- Chat Messages
    --
    chat_no_permission = "Bunu yapmaya iznin yok.", -- They aren't allowed to perform a certain action.
    net_cooldown = "Sunucuya çok fazla paket gönderiyorsun. Lütfen daha sonra tekrar deneyin.", -- They're spamming the server with net messages.

    admin_permissions_saved = "Yeni izinler başarıyla kaydedildi.", -- Confirmation that the new permissions have been saved.
    admin_config_saved = "Konfigurasyonlar başarıyla kaydedildi.", -- Confirmation that the new config have been saved.

    admin_preset_added = "Başarıyla yeni bir ön ayar eklendi.", -- Confirmation that a new preset has been added.
    admin_preset_nope = "Ön ayarda eksik bilgi var.", -- Preset tried to be submitted without a name and/or reason.
    admin_preset_dupe = "Bu isimde bir ön ayar zaten var.", -- Preset tried to be submitted without a unique name.
    admin_preset_cantfind = "Böyle bir ön ayar bulunamadı.", -- Preset can't be found.
    admin_preset_removed = "Ön ayar silindi.", -- Preset was removed.
    admin_preset_limit = "32\'den fazla ön ayarın olamaz.", -- Hitting the preset count limit.

    admin_player_warned = "%s Başarıyla uyarıldı.", -- Conformation to the admin that a player got warned.
    admin_player_note_update = "Oyuncuların admin notları başarıyla güncellendi.", -- Conformation to the admin that a players notes got updated.
    admin_player_wipewarns = "%s adlı oyuncunun bütün uyarıları silindi.", -- Conformation to the admin that a players warnings got wiped.

    admin_punishment_created = "Ceza oluşturuldu.", -- Conformation that a punishment got created
    admin_punishment_removed = "Ceza silindi.", -- Conformation that a punishment got created
    
    player_warn_notice = "%s seni %s sebebiyle uyardı", -- Message to the player they got warned.
    player_warn_broadcast = "%s, %s tarafından %s sebebiyle uyarıldı", -- Broadcast to everyone about a warning.
    player_warn_immune = "Bu oyuncuyu uyaramzsın.", -- Message to the player that they can't be warned.
    player_warn_noreason = "Lütfen bu oyuncunun uyarılma sebebini yazınız.", -- Tried to warn a player without a reason.
    player_warn_toolong = "Sebebin 150 kararterden uzun olamaz.", -- Reason is too long.
    player_warn_maxpoints = "Bir uyarıya maksimum %s puan verebilirsin.", -- Tried to warn a player with more than the max points.
    player_warn_help = "Bir oyuncuyu chatten uyarmak için: !warn <oyuncu> <puan> <sebep>", -- Help for warning in the chat
    player_warn_ui = "Sadece ön ayarları kullanmaya iznin varsa chatten kimseyi uyaramazsın.", -- Message to the player that they can't warn through the chat.
    player_warn_not_found = "\"%s\" adlı oyuncu bulunamadı.", -- Tried to warn a player through the chat that couldn't be found
    player_warn_wrongpoints = "Girdiğin puan geçersiz.", -- Tried to warn a player through the chat with an invalid point count.
    player_warn_notyou = "Kendini uyaramazsın.", -- Tried to warn themselves.
    player_warn_deleted = "Uyarı başarıyla silindi.", -- Deleted warning.

    --
    -- UI
    --
    generic_save = "Değişiklikleri Kaydet", -- Used for any "save" buttons.
    generic_cancel = "İptal Et", -- Used for any "cancel" buttons.
    generic_back = "Geri", -- Used for any "back" buttons.
    generic_point_count = "Puan", -- For the "point count" placeholders
    generic_delete = "Sil", -- Delete generic
    
    -- Sidebar Tabs
    sidebar_warnings = "Uyarılar", -- Sidebar text for the warnings tab.
    sidebar_players = "Oyuncular", -- Sidebar text for the players tab.
    sidebar_admin = "Yetkili", -- Sidebar text for the admin tab.
    sidebar_settings = "Ayarlar", -- Sidebar text for the settings tab.
    sidebar_close = "Kapat", -- Sidebar text for the close button.
    
    -- Players tab
    players_tab_search = "İsim/steamid(64) ile ara.", -- Text for the search box in the Players tab without online players.
    players_tab_search_button = "Ara", -- Text for the search button.
    players_tab_offline = "Çevrimdışı oyuncular da aransın mı?", -- Include offline players text. Careful of how big this is.
    
    viewing_player_no_warns_found = "Bu oyunucu için herhangi bir uyarı bulunmadı.", -- Message when no warnings are found for a player.
    viewing_player_action_submit_warn = "Yeni Uyarı Gir", -- Button for submitting a new warning.
    viewing_player_action_view_notes = "Yetkili Notlarını Görüntüle", -- Button for viewing admin notes.
    viewing_player_player_notes = "Yetkili Notları", -- Admin Notes placeholder
    viewing_player_save_player_notes = "Admin Notlarını Kaydet", -- Save the admin notes button

    viewing_player_table_admin = "Yetkili", -- Admin table header
    viewing_player_table_reason = "Sebep", -- Reason table header
    viewing_player_table_time = "Zaman", -- Time table header
    viewing_player_table_points = "Puan", -- Points table header
    viewing_player_table_server = "Sunucu", -- Server table header

    viewing_player_table_right_admin = "Yetkiliyi Kopyala", -- Copy admin button
    viewing_player_table_right_reason = "Sebebi Kopyala", -- Copy reason button
    viewing_player_table_right_time = "Zamanı Kopyala", -- Copy time button
    viewing_player_table_right_points = "Puanı Kopyala", -- Copy points button
    viewing_player_table_right_server = "Sunucu İsmini Kopyala", -- Copy server button
    viewing_player_table_right_log = "Log Olarak Kopyala", -- Copy server button

    viewing_player_wipe_header = "%s adlı oyuncunun bütün uyarılarını sil?", -- Wipe a players warnings header
    viewing_player_wipe_subtext = "Bu geri döndürülemez. Yapmak istediğinizin bu olduğundan emin olun.", -- Wipe a players warnings subtext  

    viewing_warn_time = "Zaman", -- Time header
    viewing_warn_point = "Puan Cezası", -- Points header
    viewing_warn_server = "Sunucu", -- Server header
    viewing_warn_reason = "Sebep", -- Reason header

    -- Warning Players
    warn_player_submit = "Oyuncuyu Uyar", -- Warn Player submit.
    warn_player_reason = "Uyarı Sebebi", -- Reason for warn placeholder.

    -- Admin Tab
    admin_tab_sidebar_permissions = "İzinler", -- Sidebar text for the permissions tab. 
    admin_tab_sidebar_settings = "Ayarlar", -- Sidebar text for the settings tab. 
    admin_tab_sidebar_presets = "Ön Ayarlar", -- Sidebar text for the presets tab. 
    admin_tab_sidebar_punishments = "Cezalar", -- Sidebar text for the punishments tab. 
    
    admin_tab_presets_none = "Hiç bir ön ayar bulunamadı", -- No presets found.
    admin_tab_presets_name = "Ön Ayar İsmi", -- Name in preset creation. 
    admin_tab_presets_reason = "Ön Ayar Sebebi", -- Reason in preset creation. 
    admin_tab_presets_create = "Ön Ayarı Oluştur", -- Create Preset button. 

    admin_tab_punishments_selecttype = "Ceza Tipini Seç", -- Text in selecting a punishment type. 
    admin_tab_punishments_create = "Ceza Eşiği Oluştur", -- Text in selecting a punishment type. 
    admin_tab_punishments_notype = "Hiç bir ceza tipi seçilmedi.", -- Default text for the descripton. 
    admin_tab_punishments_none = "Hiç bir ceza bulunamadı", -- Default text for the descripton. 

    admin_tab_warning_presets_box = "Ön Ayar Seç", -- Selecting a preset placeholder
    admin_tab_warning_reason_placeholder = "Sebep Gir", -- Enter a reason placeholder


    -- 
    -- Misc 
    -- 
    yaws = "Yine Bir Uyarı Sistemi", -- For the context menu
    context_warn = "Bu Oyuncuyu Uyar", -- Warn Player button in the context menu
    context_presets = "Bu Oyuncuyu Ön Ayarları Kullanarak Uyar", -- Warn Player button in the context menu w/ presets
    context_points = "Puan: %s", -- Point Count viewing
    context_reason = "Uyarı Sebebi: %s", -- Reason viewing
    context_submit = "Uyar", -- Submit Warning
    context_viewwarns = "Uyarıları Görüntüle", -- View Warnings
    context_viewnotes = "Yetkili Notlarını Görüntüle", -- View Admin Notes

    points_format = "%s Puan", -- Points format for fancy UIs

    loading = "Yükleniyor...", -- Loading screen
    loading_hehe = "Satisfactory Oynanıyor...", -- aGVoZQ==

    -- Permission names
    permission_view_ui = "Arayüzü Aç",
    permission_view_self_warns = "Keni Uyarılarını Görüntüle",
    permission_view_others_warns = "Başkalarının Uyarılarını Görüntüle",
    permission_view_admin_settings = "Yetkili Ayarlarını Görüntüle ve Düzenle",
    permission_create_warns = "Uyarı Oluştur",
    permission_customise_reason = "Özel Sebepler Kullan",
    permission_delete_warns = "Uyarıları Sil",

    -- User settings names/descriptions
    user_settings_darkmode_name = "Karanlık Mod",
    user_settings_darkmode_desc = "Arayüzdeki karanlık modu açar.",

    user_settings_language_name = "Dil",
    user_settings_language_desc = "Arayüzü hangi dilde kullanmak istiyorsunuz? Arayüzün yeniden açılması gerekir.",

    -- Admin settings names/descriptions
    admin_settings_prefix_name = "Ön ek",
    admin_settings_prefix_desc = "Eklentiun sohbette kullanacağı ön ek.",

    admin_settings_prefix_color_name = "Prefiks Rengi",
    admin_settings_prefix_color_desc = "Sohbetteki ön ekin rengi.",

    admin_settings_broadcast_warns_name = "Uyarıları Duyur",
    admin_settings_broadcast_warns_desc = "Eğer true ise eklenti uyarıları çevrimiçi herkese duyuracak.",

    admin_settings_point_cooldown_time_name = "Puan Azalma Süresi",
    admin_settings_point_cooldown_time_desc = "Bir oyuncudan aktif puanların kaldırılmasının ne kadar süreceği(saniye). Devre dışı bırakmak için 0 yapın.",

    admin_settings_point_cooldown_amount_name = "Puan Azalma Miktarı",
    admin_settings_point_cooldown_amount_desc = "Belirlenen sürede ne kadar puanın azalacağını belirler. Eğer kapalıysa bunu ellemeyin.",

    admin_settings_reason_required_name = "Sebep Gerekli mi?",
    admin_settings_reason_required_desc = "Eğer true ise yetkililerin her uyarıya sebep yazmaları gerekir.",

    admin_settings_point_max_name = "Maksimum Puan",
    admin_settings_point_max_desc = "Bir uyarının verebileceği maksimum puan.",

    admin_settings_purge_on_punishment_name = "Cezada Tasfiye",
    admin_settings_purge_on_punishment_desc = "Eğer true ise eklenti cezalandırıldıklarında oyuncuların puanlarını devre dışı bırakır.",  
}