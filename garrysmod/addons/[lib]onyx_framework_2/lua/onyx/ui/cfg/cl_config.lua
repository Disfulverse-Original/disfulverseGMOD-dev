--[[

Author: tochnonement
Email: tochnonement@gmail.com

05/06/2022

--]]

onyx.cfg.fontFamily = 'Roboto'

local function hexcolor(hex)
	local r, g, b = string.match(hex, '#(..)(..)(..)')
	local a = string.len(hex) > 7 and string.Right(hex, 2) or "FF"

	return Color(tonumber(r, 16), tonumber(g, 16), tonumber(b, 16), tonumber(a, 16))
end

onyx.cfg.colors = {}
onyx.cfg.colors.primary = Color(33, 33, 33, 250)
--onyx.cfg.colors.primary = hexcolor('#26272E')

onyx.cfg.colors.secondary = Color(29, 29, 29, 250)
--onyx.cfg.colors.secondary = hexcolor('#2A2C33')

onyx.cfg.colors.tertiary = Color(42, 42, 42, 250)
--onyx.cfg.colors.tertiary = hexcolor('#30323B')

onyx.cfg.colors.quaternary = Color(48, 47, 49, 245)
--onyx.cfg.colors.quaternary = hexcolor('#26272E')

onyx.cfg.colors.accent = Color(255,255,255)
onyx.cfg.colors.lightgray = Color(235, 235, 235)
onyx.cfg.colors.gray = Color(144, 144, 144)
onyx.cfg.colors.positive = Color(39, 174, 96)
onyx.cfg.colors.negative = Color(235, 77, 75)

onyx.wimg.Register('user', 'https://i.imgur.com/J1fNKdK.png')
onyx.wimg.Register('dashboard', 'https://i.imgur.com/9jAEe6f.png')
onyx.wimg.Register('home', 'https://i.imgur.com/Tv1U4pn.png')
onyx.wimg.Register('close', 'https://i.imgur.com/0jZwhKu.png')
onyx.wimg.Register('close-circle', 'https://i.imgur.com/Ee3TAhI.png')
onyx.wimg.Register('gear', 'https://i.imgur.com/njRQmA5.png')
