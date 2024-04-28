timer.Simple( 5, function()
	DarkRP.addPhrase('en', 'advert', '[Advert]')
	DarkRP.removeChatCommand("advert")

	DarkRP.declareChatCommand{
	    command = "advert",
	    description = "Advertise something to everyone in the server.",
	    delay = 10
	}
end ) 
