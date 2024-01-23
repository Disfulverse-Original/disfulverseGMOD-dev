hook.Add("HUDPaint", "HUDPaint.ClothesMod", function()
	
	net.Start("ClothesMod:PlayerHasLoaded")
	net.SendToServer()
	
	hook.Remove("HUDPaint", "HUDPaint.ClothesMod")
	
end)