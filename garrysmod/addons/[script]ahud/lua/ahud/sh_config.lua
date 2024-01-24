	--[[
	Hello there !
	You like the addon ? Mind making a review ? That would be very helpful :)
]]--

ahud.Language = "russian"
ahud.Colors = {
	["HUD_Background"] = Color(47, 47, 47, 255 * 0.8), // Default HUD Color, also the color of bystander and detective in TTT
	["HUD_Bar"] = Color(0, 147, 255), // Default HUD Color, also the color of bystander and detective in TTT
	["HUD_Circle"] = Color(125, 125, 125, 60),
	["HUD_Bad"] = Color(255, 72, 81),
	["HUD_Good"] = Color(54,186,54),
	["HUD_Warning"] = Color(254, 211, 48),
	["HUD_Tip"] = Color(43, 203, 186),

	["C200_120"] = Color(255, 255, 255, 140),
	["C54"] = Color(54, 54, 54),
	["C40"] = Color(40, 40, 40),
	["C230"] = Color(230, 230, 230),
	["C160"] = Color(160, 160, 160),
	["C125_60"] = Color(125, 125, 125, 60),

	// Specific gamemodes colors
	["HUD_TraitorBar"] = Color(219, 29, 38), // TTT Traitor, murderer use same color
	["HUD_Traitor"] = Color(38, 20, 20, 255 * 0.8),

	["HUD_InnocentBar"] = Color(54, 186, 54), // TTT Innocent, NOT DETECTIVE !.
	["HUD_Innocent"] = Color(24, 38, 15, 255 * 0.8),

	["HUD_NoGameBar"] = Color(40, 40, 40),
	["HUD_NoGame"] = Color(40, 40, 40, 255 * 0.8),
}

ahud.overheadScale = 1 // Make overhead text bigger

// Will replace colors of HUD_Background and HUD_Bar
// Format :

/*
	["TEAMNAME"] = {
		FIRST COLOR,
		SECOND COLOR
	}
*/

ahud.ColorsTeam = {
	/*
	["Citizen"] = {
		Color(24, 38, 15, 255 * 0.8), // HUD_Background
		Color(54, 186, 54) // HUD_Bar
	},
	*/
}

ahud.InvertNotifications = false // Put notifications on the bottom right, rather than on the top right

ahud.dollarIcon = true
ahud.hideEntInfo = true
ahud.disableHUDAnimations = false // Disable animations when a number change in HUD, will instantly switch to the new value

ahud.DisableModules = {
	["Speedometer"] = false,
	["Crashscreen"] = false,
	["AFK"] = false,
	["AddYellowIcon"] = false, // Remove yellow icon, on top of people talking
	["Overhead"] = false,
	["ChatIndicatorRemover"] = false,
	["OwnerFPP"] = false,
}

// Distance for the owner of the drawn door to be opaque
ahud.minDistDraw = 150 * 150

// Distance from the owner of the drawing, the owner of the vehicle, the owner of the door
ahud.maxDistDraw = 200 * 200