local function createFonts()
	surface.CreateFont( "MontserratMedium15", {
		font = "Roboto",
		extended = false,
		size = BOTCHED.FUNC.ScreenScale( 15 ),
		weight = 500,
		outline = false,
	} )
	
	surface.CreateFont( "MontserratMedium17", {
		font = "Roboto",
		extended = false,
		size = BOTCHED.FUNC.ScreenScale( 17 ),
		weight = 500,
		outline = false,
	} )
	
	surface.CreateFont( "MontserratMedium20", {
		font = "Roboto",
		extended = false,
		size = BOTCHED.FUNC.ScreenScale( 20 ),
		weight = 500,
		outline = false,
	} )

	surface.CreateFont( "MontserratMedium21", {
		font = "Roboto",
		extended = false,
		size = BOTCHED.FUNC.ScreenScale( 21 ),
		weight = 500,
		outline = false,
	} )

	surface.CreateFont( "MontserratMedium23", {
		font = "Roboto",
		extended = false,
		size = BOTCHED.FUNC.ScreenScale( 23 ),
		weight = 500,
		outline = false,
	} )

	surface.CreateFont( "MontserratMedium25", {
		font = "Roboto",
		extended = false,
		size = BOTCHED.FUNC.ScreenScale( 25 ),
		weight = 500,
		outline = false,
	} )

	surface.CreateFont( "MontserratMedium33", {
		font = "Roboto",
		extended = false,
		size = BOTCHED.FUNC.ScreenScale( 33 ),
		weight = 500,
		outline = false,
	} )

	surface.CreateFont( "MontserratBold17", {
		font = "Roboto",
		extended = false,
		size = BOTCHED.FUNC.ScreenScale( 17 ),
		weight = 5000,
		outline = false,
	} )

	surface.CreateFont( "MontserratBold18", {
		font = "Roboto",
		extended = false,
		size = BOTCHED.FUNC.ScreenScale( 18 ),
		weight = 5000,
		outline = false,
	} )

	surface.CreateFont( "MontserratBold19", {
		font = "Roboto",
		extended = false,
		size = BOTCHED.FUNC.ScreenScale( 19 ),
		weight = 5000,
		outline = false,
	} )

	surface.CreateFont( "MontserratBold20", {
		font = "Roboto",
		extended = false,
		size = BOTCHED.FUNC.ScreenScale( 20 ),
		weight = 5000,
		outline = false,
	} )

	surface.CreateFont( "MontserratBold21", {
		font = "Roboto",
		extended = false,
		size = BOTCHED.FUNC.ScreenScale( 21 ),
		weight = 5000,
		outline = false,
	} )

	surface.CreateFont( "MontserratBold22", {
		font = "Roboto",
		extended = false,
		size = BOTCHED.FUNC.ScreenScale( 22 ),
		weight = 500,
		outline = false,
	} )

	surface.CreateFont( "MontserratBold25", {
		font = "Roboto",
		extended = false,
		size = BOTCHED.FUNC.ScreenScale( 25 ),
		weight = 500,
		outline = false,
	} )

	surface.CreateFont( "MontserratBold30", {
		font = "Roboto",
		extended = false,
		size = BOTCHED.FUNC.ScreenScale( 30 ),
		weight = 500,
		outline = false,
	} )

	surface.CreateFont( "MontserratBold40", {
		font = "Roboto",
		extended = false,
		size = BOTCHED.FUNC.ScreenScale( 40 ),
		weight = 500,
		outline = false,
	} )

	surface.CreateFont( "MontserratBold50", {
		font = "Roboto",
		extended = false,
		size = BOTCHED.FUNC.ScreenScale( 50 ),
		weight = 500,
		outline = false,
	} )

	surface.CreateFont( "MontserratBold70", {
		font = "Roboto",
		extended = false,
		size = BOTCHED.FUNC.ScreenScale( 70 ),
		weight = 500,
		outline = false,
	} )

	surface.CreateFont( "MontserratBold120", {
		font = "Roboto",
		extended = false,
		size = BOTCHED.FUNC.ScreenScale( 120 ),
		weight = 500,
		outline = false,
	} )

	surface.CreateFont( "MontserratSemiBold18", {
		font = "Roboto",
		extended = false,
		size = BOTCHED.FUNC.ScreenScale( 18 ),
		weight = 500,
		outline = false,
	} )

	surface.CreateFont( "MontserratSemiBold15", {
		font = "Roboto",
		extended = false,
		size = BOTCHED.FUNC.ScreenScale( 15 ),
		weight = 500,
		outline = false,
	} )
end
createFonts()

hook.Add( "OnScreenSizeChanged", "Botched.OnScreenSizeChanged.Fonts", createFonts )