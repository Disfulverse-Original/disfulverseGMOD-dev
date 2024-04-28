-- This is a list of usergroups or SteamID(64)'s that will always have full permissions.
YAWS.ManualConfig.Immunes['superadmin'] = true
YAWS.ManualConfig.Immunes['admin'] = true
YAWS.ManualConfig.Immunes['smod'] = true
YAWS.ManualConfig.Immunes['moderator'] = true
YAWS.ManualConfig.Immunes['operator'] = true
YAWS.ManualConfig.FullPerms['STEAM_0:1:80376292'] = true
YAWS.ManualConfig.FullPerms['76561198121018313'] = true

-- And this is a list of usergroups or SteamID(64)'s that can never be warned ever.
YAWS.ManualConfig.Immunes['superadmin'] = true
YAWS.ManualConfig.Immunes['admin'] = true
YAWS.ManualConfig.Immunes['smod'] = true
YAWS.ManualConfig.Immunes['moderator'] = true
YAWS.ManualConfig.Immunes['STEAM_0:1:80376292'] = true
YAWS.ManualConfig.Immunes['76561198121018313'] = true

-- The command to access the UI in-game.
YAWS.ManualConfig.Command = "!warn"


-- Rest of this shit is done in-game. :)




--
-- (Down here is development/debug stuff, dw about it if you don't know what it is)
--

-- Print net message payload lengths client-side. Lots of data being thrown
-- about so this is a concern sometimes.
YAWS.ManualConfig.ClientNetDebug = false

-- Same as above, but on the server-side realm.
YAWS.ManualConfig.ServerNetDebug = false