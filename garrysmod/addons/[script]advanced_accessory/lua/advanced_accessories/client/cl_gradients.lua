/*
    Addon id: 08ee2233-2d73-4598-a636-76adb93194f5
    Version: v2.1.6 (stable)
*/

//   This Source Code Form is subject to the terms of the Mozilla Public
//   License, v. 2.0. If a copy of the MPL was not distributed with this
//   file, You can obtain one at http://mozilla.org/MPL/2.0/.
//   https://github.com/Bo98/garrysmod-util/blob/master/LICENSE
//   https://github.com/Bo98/garrysmod-util/blob/master/lua/autorun/client/gradient.lua

local mat_white = Material("vgui/white")

function AAS.SimpleLinearGradient(x, y, w, h, startColor, endColor)
	AAS.LinearGradient(x, y, w, h, {{offset = 0, color = startColor}, {offset = 1, color = endColor}})
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 0fd22f1243f0001f31e3d159f2ecd1adb4d5513bd78688f3c34a090a154e38c5

function AAS.LinearGradient(x, y, w, h, stops)
	if #stops == 0 then
		return
	elseif #stops == 1 then
		surface.SetDrawColor(stops[1].color)
		surface.DrawRect(x, y, w, h)
		return
	end

	table.SortByMember(stops, "offset", true)

	render.SetMaterial(mat_white)
	mesh.Begin(MATERIAL_QUADS, #stops - 1)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 211b2def519ae9f141af89ab258a00a77f195a848e72e920543b1ae6f5d7c0c1 */
    
	for i = 1, #stops - 1 do
		local offset1 = math.Clamp(stops[i].offset, 0, 1)
		local offset2 = math.Clamp(stops[i + 1].offset, 0, 1)
		if offset1 == offset2 then continue end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 0fd22f1243f0001f31e3d159f2ecd1adb4d5513bd78688f3c34a090a154e38c5 */

		local deltaX1, deltaY1, deltaX2, deltaY2

		local color1 = stops[i].color
		local color2 = stops[i + 1].color

		local r1, g1, b1, a1 = color1.r, color1.g, color1.b, color1.a
		local r2, g2, b2, a2
		local r3, g3, b3, a3 = color2.r, color2.g, color2.b, color2.a
		local r4, g4, b4, a4

		r2, g2, b2, a2 = r1, g1, b1, a1
        r4, g4, b4, a4 = r3, g3, b3, a3
        deltaX1 = 0
        deltaY1 = offset1 * h
        deltaX2 = w
        deltaY2 = offset2 * h

		mesh.Color(r1, g1, b1, a1)
		mesh.Position(Vector(x + deltaX1, y + deltaY1))
		mesh.AdvanceVertex()

		mesh.Color(r2, g2, b2, a2)
		mesh.Position(Vector(x + deltaX2, y + deltaY1))
		mesh.AdvanceVertex()
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198402768796
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198402768796 */

		mesh.Color(r3, g3, b3, a3)
		mesh.Position(Vector(x + deltaX2, y + deltaY2))
		mesh.AdvanceVertex()

		mesh.Color(r4, g4, b4, a4)
		mesh.Position(Vector(x + deltaX1, y + deltaY2))
		mesh.AdvanceVertex()
	end
	mesh.End()
end
