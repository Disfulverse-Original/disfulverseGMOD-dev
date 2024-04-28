/*
    Addon id: 08ee2233-2d73-4598-a636-76adb93194f5
    Version: v2.1.6 (stable)
*/

local MODULE = GAS.Logging:MODULE()
MODULE.Category = "Advanced Accessory System"
MODULE.Name = "Bought / Sold Item"
MODULE.Colour = Color(54, 140, 220)

MODULE:Hook("AAS:SoldItem", "AAS:SoldItem", function(ply, uniqueId)
    MODULE:Log(GAS.Logging:FormatPlayer(ply) .. " sold the item with the uniqueId "..uniqueId)
end)

MODULE:Hook("AAS:BoughtItem", "AAS:BoughtItem", function(ply, tbl)
    MODULE:Log(GAS.Logging:FormatPlayer(ply) .. " bought the item "..tbl["name"].." ( uniqueId : "..tbl["uniqueId"].." )")
end)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 2ac76e693552f037481c18f13287287a7dd363c0c619b282b58470ebf17cd78a */
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198402768773

GAS.Logging:AddModule(MODULE)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198402768796
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 211b2def519ae9f141af89ab258a00a77f195a848e72e920543b1ae6f5d7c0c1
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 2ac76e693552f037481c18f13287287a7dd363c0c619b282b58470ebf17cd78a */
