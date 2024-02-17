/**
* General configuration
**/

-- Title of the chatbox.
-- Here are special titles:
-- %hostname% : Shows the server's name
-- %players% : Shows the player count on the server
-- %uptime% : Uptime of the server
LOUNGE_CHAT.ChatTitle = "%hostname%"

-- Show the player's avatar when sending a message
LOUNGE_CHAT.ShowPlayerAvatar = true

-- Message display style
-- 0: Default
-- 1: Discord-like (enable ShowPlayerAvatar for better effect)
LOUNGE_CHAT.MessageStyle = 1

-- Name to display when the console sends a message
-- Parsers are allowed.
LOUNGE_CHAT.ConsoleName = "Console"

-- Whether to use Workshop or the FastDl for the custom content used by the add-on
LOUNGE_CHAT.UseWorkshop = true

/**
* Advanced configuration
* Only modify these if you know what you're doing.
**/

-- How the <timestamp=...> markup should be formatted.
-- See https://msdn.microsoft.com/en-us/library/fe06s4ak.aspx for a list of available mappings
LOUNGE_CHAT.TimestampFormat = "%c"

-- Where downloaded images should be in GMod's data folder.
LOUNGE_CHAT.ImageDownloadFolder = "lounge_chat_downloads"

-- Whether to use UTF-8 mode for character wrapping and parsing.
-- You can set this to false if your server's main language is Roman script only (English, etc)
LOUNGE_CHAT.UseUTF8 = true

-- Maximum messages allowed in the chatbox before deletion of the oldest messages.
LOUNGE_CHAT.MaxMessages = 200

/**
* Style configuration
**/

-- Font to use for normal text throughout the chatbox.
LOUNGE_CHAT.FontName = "Roboto-Regular"

-- Font to use for bold text throughout the chatbox.
LOUNGE_CHAT.FontNameBold = "Roboto-Bold"

-- Color sheet.
LOUNGE_CHAT.Style = {
	header = Color(32, 32, 39, 135),
	bg = Color(27, 27, 27, 135),
	inbg = Color(33, 33, 33, 145),

	close_hover = Color(231, 76, 60),
	hover = Color(255, 255, 255, 10),
	hover2 = Color(255, 255, 255, 5),

	text = Color(255, 255, 255),
	text_down = Color(0, 0, 1),

	url = Color(52, 152, 219),
	url_hover = Color(62, 206, 255),
	timestamp = Color(166, 166, 166),

	menu = Color(29, 29, 29, 200),
}

LOUNGE_CHAT.Anims = {
	FadeInTime = 0.15,
	FadeOutTime = 0.07,
	TextFadeOutTime = 1,
}

-- Size of the <glow> parser.
LOUNGE_CHAT.BlurSize = 2

/**
* Language configuration
**/

-- Various strings used throughout the chatbox. Change them to your language here.
-- %s and %d are special strings replaced with relevant info, keep them in the string!

-- FRENCH Translation: https://pastebin.com/pnQfQ82k

LOUNGE_CHAT.Language = {
	players_online = "Игроков онлайн",
	server_uptime = "Время работы сервера",
	click_to_load_image = "Нажмите, чтобы загрузить изображение",
	failed_to_load_image = "Не удалось загрузить изображение",
	click_here_to_view_x_profile = "Нажмите здесь, чтобы просмотреть профиль %s",

	chat_options = "Настройки чата",
	clear_chat = "Очистить чат",
	reset_position = "Сбросить позицию",
	reset_size = "Сбросить размер",

	chat_parsers = "Парсеры чата",
	usage = "Использование",
	example = "Пример",

	send = "Отправить",
	copy_message = "Копировать сообщение",
	copy_url = "Копировать URL",

	-- options
	general = "Общие",
	chat_x = "Позиция X",
	chat_y = "Позиция Y",
	chat_width = "Ширина чатбокса",
	chat_height = "Высота чатбокса",
	time_before_messages_hide = "Время до скрытия сообщений",
	show_timestamps = "Отображать временные метки",
	clear_downloaded_images = "Очистить папку загруженных изображений (%s)",
	dont_scroll_chat_while_open = "Не прокручивать чат автоматически при открытии",

	display = "Отображение",
	hide_images = "Скрыть изображения",
	hide_avatars = "Скрыть аватары",
	use_rounded_avatars = "Использовать круглые аватары (отключить, если низкий FPS)",
	disable_flashes = "Отключить вспышки",
	no_url_parsing = "Не разбирать URL",
	autoload_external_images = "Автоматически загружать внешние изображения",
	hide_options_button = "Скрыть кнопку опций",
}
