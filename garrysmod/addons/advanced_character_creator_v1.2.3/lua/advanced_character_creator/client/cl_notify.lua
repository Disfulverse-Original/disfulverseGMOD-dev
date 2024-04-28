--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

/*
    Addon id: 00690769-9ce4-49c1-bc5f-802f53225f58
    Version: v1.2.3 (stable)
*/

ACC2 = ACC2 or {}
ACC2.Notify = ACC2.Notify or {}

function ACC2.Notification(time, msg)
    if ACC2.GetSetting("useCustomNotification", "boolean") then
        ACC2.Notify[#ACC2.Notify + 1] = {
            ["Message"] = msg,
            ["Time"] = CurTime() + (time or 5),
            ["Material"] = ACC2.Materials["notify_bell"], 
        }
    else
        notification.AddLegacy(msg, NOTIFY_GENERIC, time)
    end
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198931466944

function ACC2.DrawNotification()
    if ACC2.Notify and #ACC2.Notify > 0 then 
        for k,v in ipairs(ACC2.Notify) do 
            surface.SetFont("ACC2:Font:09")
            local SizeText = surface.GetTextSize(v.Message)

            if not isnumber(v.RLerp) then v.RLerp = -SizeText end 
            if not isnumber(v.RLerpY) then v.RLerpY = (ACC2.ScrH*0.055*k)-ACC2.ScrH*0.038 end

            if v.Time > CurTime() then
                v.RLerp = Lerp(FrameTime()*3, v.RLerp, ACC2.ScrW*0.02)
            else
                v.RLerp = Lerp(FrameTime()*3, v.RLerp, (-ACC2.ScrW*0.25 - SizeText))
                if v.RLerp < (-ACC2.ScrW*0.15 - SizeText) then 
                    ACC2.Notify[k] = nil 
                    ACC2.Notify = table.ClearKeys(ACC2.Notify) 
                end
            end 
            
            v.RLerpY = Lerp(FrameTime()*8, v.RLerpY, (ACC2.ScrH*0.055*k)-ACC2.ScrH*0.038)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198931466969
 
            local posy = v.RLerpY
            local incline = ACC2.ScrH*0.055

            local leftPart = {
                {x = v.RLerp, y = posy},
                {x = v.RLerp + incline + SizeText + ACC2.ScrH*0.043, y = posy},
                {x = v.RLerp + ACC2.ScrH*0.043 + SizeText + ACC2.ScrH*0.043, y = posy + ACC2.ScrH*0.043},
                {x = v.RLerp, y = posy + ACC2.ScrH*0.043},
            }
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- f7fd1fca3ccaab2e1a41a243c7c9e204241772fcea4df32223d2f6203cc38823
            
            surface.SetDrawColor(ACC2.Colors["black18220"])
            draw.NoTexture()
            surface.DrawPoly(leftPart)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- f7fd1fca3ccaab2e1a41a243c7c9e204241772fcea4df32223d2f6203cc38823

            local rightPart = {
                {x = v.RLerp, y = posy},
                {x = v.RLerp + incline, y = posy},
                {x = v.RLerp + ACC2.ScrH*0.043, y = posy + ACC2.ScrH*0.043},
                {x = v.RLerp, y = posy + ACC2.ScrH*0.043},
            }
            
            surface.SetDrawColor(ACC2.Colors["purple"])
            draw.NoTexture()
            surface.DrawPoly(rightPart)

            surface.SetDrawColor(ACC2.Colors["white"])
            surface.SetMaterial(v.Material)
            surface.DrawTexturedRect(v.RLerp + ACC2.ScrW*0.006, v.RLerpY + ACC2.ScrH*0.007, ACC2.ScrH*0.027, ACC2.ScrH*0.027)

            draw.SimpleText(v.Message, "ACC2:Font:09", v.RLerp + ACC2.ScrW*0.037, v.RLerpY + ACC2.ScrH*0.041/2, ACC2.Colors["white"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end 
    end
end

hook.Add("DrawOverlay", "ACC2:DrawOverlay:Notify", function()
    if IsValid(ACC2MainFrame) then return end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198931466944

    ACC2.DrawNotification()
end)

net.Receive("ACC2:Notification", function()
    local time = net.ReadUInt(3)
    local msg = net.ReadString()
    
    if ACC2.GetSetting("useCustomNotification", "boolean") then
        ACC2.Notification(time, msg)
    else
        notification.AddLegacy(msg, NOTIFY_GENERIC, time)
    end
end)


--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
