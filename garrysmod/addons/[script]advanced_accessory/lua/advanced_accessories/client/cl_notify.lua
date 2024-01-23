/*
    Addon id: 08ee2233-2d73-4598-a636-76adb93194f5
    Version: v2.1.6 (stable)
*/

AAS.Notify = AAS.Notify or {}

function AAS.Notification(time, msg)
    if AAS.ActivateNotification then
        AAS.Notify[#AAS.Notify + 1] = {
            ["Message"] = msg,
            ["Time"] = CurTime() + (time or 5),
            ["Material"] = Material("aas_materials/man.png", "smooth"), 
        }
    else
        notification.AddLegacy(msg, NOTIFY_GENERIC, time)
    end
end

hook.Add("DrawOverlay", "AAS:DrawOverlay", function()
    if AAS.Notify and #AAS.Notify > 0 then 
        for k,v in ipairs(AAS.Notify) do 
            if not isnumber(v.RLerp) then v.RLerp = -(AAS.ScrW*0.25 + #v.Message*AAS.ScrW*0.0057) end 
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 4fe11df2c417444b79aed9fe6656320fa35293cadbcf662f9154077dfcbe3cb8 */

            surface.SetFont("AAS:Font:11")
            local SizeText = surface.GetTextSize(v.Message)

            if v.Time > CurTime() then 
                v.RLerp = math.Round(Lerp(6*FrameTime(), v.RLerp, AAS.ScrW*0.02))
            else 
                v.RLerp = math.Round(Lerp(6*FrameTime(), v.RLerp, -(AAS.ScrW*0.25 + #v.Message*AAS.ScrW*0.0057+AAS.ScrW*0.032)))
                if v.RLerp < -(AAS.ScrW*0.1 + #v.Message*AAS.ScrW*0.0057+AAS.ScrW*0.032) then AAS.Notify[k] = nil AAS.Notify = table.ClearKeys(AAS.Notify) end 
            end 
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198402768773
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- bd51170ee3a15f0e8d5e6b12ded39977f6a3f8896bd2c58844ad6ead73ef34eb
            
            draw.RoundedBox(4, v.RLerp, (AAS.ScrH*0.055*k)-AAS.ScrH*0.038, SizeText + AAS.ScrH*0.07, AAS.ScrH*0.043, AAS.Colors["black18200"])
            draw.RoundedBox(4, v.RLerp, (AAS.ScrH*0.055*k)-AAS.ScrH*0.038, AAS.ScrH*0.043, AAS.ScrH*0.043, AAS.Colors["notifycolor"])
            
            local width, height = (v.Material:Width()*AAS.ScrW/1920), (v.Material:Height()*AAS.ScrH/1080)
            surface.SetDrawColor(AAS.Colors["white"])
            surface.SetMaterial(v.Material)
            surface.DrawTexturedRect( v.RLerp + AAS.ScrH*0.045/2 - width/2, (AAS.ScrH*0.055*k) - height, width, height)

            draw.SimpleText(v.Message, "AAS:Font:11", v.RLerp + AAS.ScrW*0.03, (AAS.ScrH*0.055*k) + AAS.ScrH*0.04/2-AAS.ScrH*0.038, AAS.Colors["white"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end 
    end
end)

net.Receive("AAS:Notification", function()
    local Time = net.ReadUInt(5)
    local Message = net.ReadString()
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 2ac76e693552f037481c18f13287287a7dd363c0c619b282b58470ebf17cd78a
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198402768796 */
    
    if AAS.ActivateNotification then
        AAS.Notification(Message, Time)
    else
        notification.AddLegacy(Message, NOTIFY_GENERIC, Time)
    end
end)
