--[[
 _____           _ _     _   _       ______                          _   _           
| ___ \         | (_)   | | (_)      | ___ \                        | | (_)          
| |_/ /___  __ _| |_ ___| |_ _  ___  | |_/ / __ ___  _ __   ___ _ __| |_ _  ___  ___ 
|    // _ \/ _` | | / __| __| |/ __| |  __/ '__/ _ \| '_ \ / _ \ '__| __| |/ _ \/ __|
| |\ \  __/ (_| | | \__ \ |_| | (__  | |  | | | (_) | |_) |  __/ |  | |_| |  __/\__ \
\_| \_\___|\__,_|_|_|___/\__|_|\___| \_|  |_|  \___/| .__/ \___|_|   \__|_|\___||___/                          

]]

Realistic_Properties.Notify = Realistic_Properties.Notify or {} 

local Material1 = Material("materials/rps_materials3.png")

hook.Add("DrawOverlay", "RealisticProperties:Notify", function()
	for k, v in pairs( Realistic_Properties.Notify ) do
		surface.SetFont( "rps_font_8" )

		local x,y = surface.GetTextSize( v.rpsmessage ) 
		local RpsY = ( k * math.Clamp( CurTime() + 3 - CurTime(), 0, 1) * 45 ) - 23
		local RpsX = math.Clamp(CurTime() - 10, 0 , 1) 

		draw.RoundedBox( 5, RpsX, RpsY + 7, 50, 40, Realistic_Properties.Colors["lightblue"])

		surface.SetDrawColor( Realistic_Properties.Colors["white"] )
		surface.DrawRect( RpsX + 40, RpsY + 7, 20 + x, 40 )		

		surface.SetTextPos( RpsX + 50, RpsY + 7 + y - 8 )
		surface.SetTextColor( Realistic_Properties.Colors["black"] )
		surface.DrawText( v.rpsmessage )

		surface.SetMaterial(Material1)
		surface.DrawTexturedRect( RpsX + 10, RpsY + 14, 20, 20 )

		if v.rpscurtime < CurTime() then 
			Realistic_Properties.Notify[#Realistic_Properties.Notify] = nil 
		end 
	end	
end)

function RealisticPropertiesNotify(msg)
	Realistic_Properties.Notify[#Realistic_Properties.Notify + 1] = {
		rpsmessage = msg,
		rpscurtime = CurTime() + 3, 
	}
	surface.PlaySound( "UI/buttonclick.wav" )
end 

net.Receive("RealisticProperties:Notify", function()
	local msg = net.ReadString()
	RealisticPropertiesNotify(msg)
end)