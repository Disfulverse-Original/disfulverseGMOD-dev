--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

local blur = Material("pp/blurscreen")
local function blurPanel(p, a, h)
		local x, y = p:LocalToScreen(0, 0)
		local scrW, scrH = ScrW(), ScrH()
		surface.SetDrawColor(Color(255, 255, 255, 255))
		surface.SetMaterial(blur)
		for i = 1, (h or 3) do
			blur:SetFloat("$blur", (i/3)*(a or 6))
			blur:Recompute()
			render.UpdateScreenEffectTexture()
			surface.DrawTexturedRect(x*-1,y*-1,scrW,scrH)
		end
end

local MenuOpen = false
net.Receive("Numerix_Open_Menu_Intro", function()
    OpenMenuIntro()
    MenuOpen = true
end)

net.Receive("Numerix_Start_Intro", function()
    StartIntro()
end)

local IntroStart
function OpenMenuIntro()
    if MenuOpen then return end

    local BaseIntro = vgui.Create( "DFrame" )
    BaseIntro:SetPos( 0, 0 )
    BaseIntro:SetSize( ScrW(), ScrH() )
    BaseIntro:SetTitle( "" )
    BaseIntro:SetDraggable( false )
    BaseIntro:ShowCloseButton(false)
    BaseIntro:MakePopup()
    BaseIntro.Think = function(self)
        self:MoveToBack()
    end
    BaseIntro.Paint = function(self, w, h)
        if Intro.Settings.Blur then
            blurPanel(self, 4)
        else
            draw.RoundedBox(0, 0, 0, w, h, Intro.Settings.BGColor)
        end
        draw.SimpleText(Intro.Settings.Title, "Intro.Text", ScrW()/2, ScrH()/10, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local StartButton = vgui.Create( "DButton", BaseIntro )
    StartButton:SetText( "Начать знакомство" )
    StartButton:SetTextColor(Color(255,255,255,255))
    StartButton:SetFont("Intro.Text")
    StartButton:SizeToContentsX(100)
    StartButton:SizeToContentsY(10)					
    StartButton:SetPos( ScrW()/2 - StartButton:GetWide()/2 , ScrH()/2 - StartButton:GetTall()/2 )					
    StartButton.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(33, 31, 35, 255))
		surface.SetDrawColor( Color( 255, 255, 255, 100 ) )
		surface.DrawOutlinedRect( 0, 0, self:GetWide(), self:GetTall() )
    end
    StartButton.DoClick = function()				
        StartIntro()
        IntroStart = false

        net.Start("Numerix_Intro_Start_Stop")
        net.WriteBool(true)
        net.SendToServer()

        BaseIntro:Remove()
    end

    if !Intro.Settings.ForceIntro then
        local CloseButton = vgui.Create( "DButton", BaseIntro )
        CloseButton:SetText( "Passer l'introduction" )
        CloseButton:SetTextColor(Color(255,255,255,255))
        CloseButton:SetFont("Intro.Text")
        CloseButton:SizeToContentsX(100)
        CloseButton:SizeToContentsY(10)					
        CloseButton:SetPos( ScrW()/2 - CloseButton:GetWide()/2 , ScrH()/1.5 - CloseButton:GetTall()/2 )					
        CloseButton.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(33, 31, 35, 255))
            surface.SetDrawColor( Color( 255, 255, 255, 100 ) )
            surface.DrawOutlinedRect( 0, 0, self:GetWide(), self:GetTall() )
        end				
        CloseButton.DoClick = function()				
            BaseIntro:Remove()
        end
    end
end

function StartIntro()
    if !IntroStart then
        hook.Remove( "CalcView", "Numerix_CalcView_Intro" )
        hook.Remove( "HUDPaint", "aaaNumerix_HUDPaint_Intro" )
        hook.Remove( "HUDShouldDraw", "Numerix_HUDShouldDraw_Intro" )
        
        IntroStart = true
        if Intro.Settings.URLMusic != "" then
            sound.PlayURL ( Intro.Settings.URLMusic, "noplay", function( station )
                if ( IsValid( station ) ) then
                    station:Play()
                    station:SetVolume(math.Clamp(Intro.Settings.MusicVolume, 0, 1))
                else
                    LocalPlayer():ChatPrint( "" )
                end
            end)  
        end

        local scene = 1
        local fraction = 0
        local returntoply = false
        local fadeout = false
        local fadein = false
        local finalscene = false
        local showtext = true
        hook.Add("CalcView", "Numerix_CalcView_Intro", function(ply, pos, angles, fov)

            if scene <= #Intro.Settings.Camera then
                
                fraction = math.Clamp(fraction + FrameTime()*Intro.Settings.Camera[scene].speed, 0, 1)
                if fraction == 0 then return end
                
                local view = {}
                view.origin = LerpVector( fraction, Intro.Settings.Camera[scene].startpos, Intro.Settings.Camera[scene].endpos )
                view.angles = LerpAngle(fraction, Intro.Settings.Camera[scene].startang, Intro.Settings.Camera[scene].endang)
                view.fov = fov
                view.drawviewer = true

                local totaldist = Intro.Settings.Camera[scene].startpos:Distance(Intro.Settings.Camera[scene].endpos)
                local actualdist = view.origin:Distance(Intro.Settings.Camera[scene].endpos)
                
                if actualdist < totaldist/2.5*Intro.Settings.Camera[scene].speed/0.2 and !fadeout and Intro.Settings.Camera[scene].makefade then
                    if scene < #Intro.Settings.Camera and !finalscene then
                        ply:ScreenFade( SCREENFADE.OUT, Color( 0, 0, 0, 255 ), 1, 1 )
                        fadeout = true

                        timer.Simple(1, function()
                            showtext = false
                        end)

                        timer.Simple(2, function() 
                            fadeout = false
                        end)
                    end
                end
                if view.origin:IsEqualTol( Intro.Settings.Camera[scene].endpos, 5 ) then
                    fraction = 0

                    if scene <= #Intro.Settings.Camera then
                        if !fadein and Intro.Settings.Camera[scene].makefade then
                            ply:ScreenFade( SCREENFADE.IN, Color( 0, 0, 0, 255 ), 2, 0 )
                            fadein = true
                            showtext = true
                            
                            timer.Simple(2, function() 
                                fadein = false
                            end)
                        end
                    end

                    scene = scene + 1
                end

                return view
            elseif !returntoply and Intro.Settings.AnimReturnPlayer then
                finalscene = true
                fraction = math.Clamp(fraction + FrameTime()*0.3, 0, 1)
                
                local ang = ply:GetAngles()
                local view = {}
                view.origin = LerpVector( fraction, ply:GetPos() + Vector(0, 0, Intro.Settings.AnimReturnPlayerHigh), ply:GetPos() + Vector(0,0, 100) )
                view.angles = Angle(90,ang.yaw,ang.raw)
                view.fov = fov
                view.drawviewer = true
                
                if view.origin:IsEqualTol( ply:GetPos() + Vector(0,0,100), 5 ) then
                    returntoply = true
                end
                
                return view
            else
                EndIntro()
            end
        end)

        

        local text
        hook.Add("HUDPaint", "aaaNumerix_HUDPaint_Intro", function() --aaa pour être le premier HUD éxecuter
            local shouldDraw = hook.Call("HUDShouldDraw", nil, "Cinematic_HUD")
            if shouldDraw == false then return end

            if showtext then
                if scene <= #Intro.Settings.Camera then
                    text =  Intro.Settings.Camera[scene].text
                else
                    text = Intro.Settings.textend
                end

                surface.SetFont("Intro.Text")
                local textlenght = surface.GetTextSize(text)
                draw.RoundedBox(5, ScrW()/2 -textlenght/2 - 25, ScrH() - ScrH()/15, textlenght + 50, ScrH()/20, Color(0,0,0,150))
                draw.SimpleText(text, "Intro.Text", ScrW()/2, ScrH() - ScrH()/24 , Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) 
            end
            return false
        end)


        local disable = {
			["CHudHealth"] = true,
			["CHudBattery"] = true,
			["CHudAmmo"] = true,
			["CHudSecondaryAmmo"] = true,
            ["CHudCrosshair"] = true,
            ["CHudChat"] = true,
			["DarkRP_HUD"] = true,
			["DarkRP_EntityDisplay"] = true,
			["DarkRP_LocalPlayerHUD"] = true,
			["DarkRP_Hungermod"] = true,
			["DarkRP_Agenda"] = true,
			["DarkRP_LockdownHUD"] = true,
			["DarkRP_ArrestedHUD"] = true,
        }
        
        hook.Add( "HUDShouldDraw", "Numerix_HUDShouldDraw_Intro", function(name) 
            if disable[name] then
                return false
            end
        end)
    end
end


function EndIntro()
    hook.Remove( "CalcView", "Numerix_CalcView_Intro" )
    hook.Remove( "HUDPaint", "aaaNumerix_HUDPaint_Intro" )
    hook.Remove( "HUDShouldDraw", "Numerix_HUDShouldDraw_Intro" )

    net.Start("Numerix_Intro_Start_Stop")
    net.WriteBool(false)
    net.SendToServer()

    RunConsoleCommand("stopsound")

    IntroStart = false
end

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
