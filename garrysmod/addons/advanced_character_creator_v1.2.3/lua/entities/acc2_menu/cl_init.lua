--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

/*
    Addon id: 00690769-9ce4-49c1-bc5f-802f53225f58
    Version: v1.2.3 (stable)
*/

include("shared.lua")

function ENT:Draw()
    if not IsValid(ACC2.LocalPlayer) then return end

    self:DrawModel()
	
    local pos = self:GetPos()
    
    if ACC2.LocalPlayer:GetPos():DistToSqr(pos) < 800000 then
		local name = ACC2.GetSetting("npcMenuName", "string") or ""

		cam.Start3D2D(pos + ACC2.Constants["vectorNPC"], Angle(0, ACC2.LocalPlayer:EyeAngles().y-90, 90), 0.025)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* e76c9cbfd4851f046d135a3807c90610912e0963b3302ca13880769302aa4101 */

			surface.SetFont("ACC2:Font:20")
			local size = surface.GetTextSize(name)*1.15
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198931466969

			draw.RoundedBox(0, -size/2, -2150, size, 250, ACC2.Colors["blackpurple"])
			draw.RoundedBox(0, -size/2, -1930, size, 30, ACC2.Colors["purple"])
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198931466969 */

			draw.DrawText(name, "ACC2:Font:20", 5, -2120, ACC2.Colors["white"], TEXT_ALIGN_CENTER)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* e76c9cbfd4851f046d135a3807c90610912e0963b3302ca13880769302aa4101 */
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- ded51e6532282dfa00c9343043e6163c5627f86ee51ba1d02ddf9be86bf42ec7

		cam.End3D2D()
	end 
end


--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
