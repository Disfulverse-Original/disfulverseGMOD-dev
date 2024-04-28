-- This is the config file for discord webhooks. If you don't want a discord
-- relay, ignore this file. :)

-- Set to true if you want discord relays to be enabled.
YAWS.ManualConfig.Discord.Enabled = false


-- You have two options on how to handle the webhooks, since some dumbass got
-- all requests from gmod to discord blocked. You can:
--
-- A 
-- Use CHTTP. This is a module that is a drop in replacement for the default
-- HTTP library, and isn't blocked by discord.
--
-- OR 
--
-- B 
-- Use a PHP relay. The addon sends a request to a website that posts the
-- webhook for us. I can host this file for you, or you can host it yourself.
--
-- Both will have the same functionality. The only difference is how you install
-- them. CHTTP requires installing a module. If your host doesn't allow that, or
-- you don't like installing random DLLs off the internet (like me), you can opt
-- for the relay option. Relay is free to use from me, but you can also
-- self-host if you want it.

-- Choose which one your using down here.
-- Put in either CHTTP or RELAY.
-- YAWS.ManualConfig.Discord.Method = "CHTTP"
YAWS.ManualConfig.Discord.Method = "RELAY"

-- IF YOU OPTED FOR CHTTP:
--    You will need to install the CHTTP module from here:
--    https://github.com/timschumi/gmod-chttp
--    If you need help, follow the installation guide in the README.
--    If your host doesn't allow installation of DLLs, contact them and request
--    them to add it. If they refuse, go for the relay instead.
--
-- IF YOU OPTED FOR THE RELAY:
--    Type in below where the request will be going. If you want to host it
--    yourself, upload it and type it in here (get someone who knows what
--    they're doing to do it!)
--    Alternatively, leave it alone if you are going to be using my hosting
--    services.
YAWS.ManualConfig.Discord.RelayURL = "https://api.livaco.dev/yaws/webhook.php"
--    Now, you need a password. This is so the relay knows the request came from
--    the server and not some random knob living in his mums basement.
--    Once again, if you aren't self-hosting, leave this alone.
YAWS.ManualConfig.Discord.Password = "6q282$Yu9aD5UqXt"



-- 
-- Now, the fun actual config stuff!
-- 

-- The webhook URL that was generated. If you don't know what this should be, follow the guide.
YAWS.ManualConfig.Discord.WebhookURL = "https://discord.com/api/webhooks/000000000000000000/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"

-- The color the side bar thingy should be.
YAWS.ManualConfig.Discord.EmbedColor = Color(83, 182, 155)

-- The title/description of the embed.
YAWS.ManualConfig.Discord.EmbedTitle = "Player Warned"
YAWS.ManualConfig.Discord.EmbedDescription = "A player has been warned."

-- If the embed should use emojis 
YAWS.ManualConfig.Discord.UseEmojis = true

-- Print debug info. Enable this if no webhook errors are appearing in your
-- server console but you still aren't getting anything in your webhook.
YAWS.ManualConfig.Discord.Debug = false