--[[
 _____           _ _     _   _       ______                          _   _           
| ___ \         | (_)   | | (_)      | ___ \                        | | (_)          
| |_/ /___  __ _| |_ ___| |_ _  ___  | |_/ / __ ___  _ __   ___ _ __| |_ _  ___  ___ 
|    // _ \/ _` | | / __| __| |/ __| |  __/ '__/ _ \| '_ \ / _ \ '__| __| |/ _ \/ __|
| |\ \  __/ (_| | | \__ \ |_| | (__  | |  | | | (_) | |_) |  __/ |  | |_| |  __/\__ \
\_| \_\___|\__,_|_|_|___/\__|_|\___| \_|  |_|  \___/| .__/ \___|_|   \__|_|\___||___/                          

]]


include("shared.lua")

surface.CreateFont( "HOMEFONT", {
 font = "Roboto",
 size = 118,
 weight = 700,
 blursize = 0,
 scanlines = 0,
 antialias = true,
 extended = true
} )

function ENT:Draw()
    -- Проверяем, является ли текущий объект (ENT) действительным, и существует ли локальный игрок
    if not IsValid(self) or not IsValid(LocalPlayer()) then return end

    -- Рисуем модель объекта
    self:DrawModel()

    -- Получаем позицию и углы объекта
    local pos = self:GetPos()
    local ang = self:GetAngles()
    ang:RotateAroundAxis(ang:Up(), 0)
    ang:RotateAroundAxis(ang:Forward(), 85)
    -- Проверяем, находится ли локальный игрок вблизи объекта
    if LocalPlayer():GetPos():DistToSqr(self:GetPos()) < 50000 then
        -- Начинаем рисование 3D-текста и элементов
        cam.Start3D2D(pos + ang:Up() * 0, Angle(0, LocalPlayer():EyeAngles().y - 90, 90), 0.025)
        -- Рисуем фон с закругленными углами
        draw.RoundedBoxEx(16, -500, -3100, 1000, 170, Color(21, 41, 56, 255), true, true, false, false)
        -- Рисуем прямоугольную полосу сверху
        draw.RoundedBox(0, -500, -2950, 1000, 20, Color(255, 255, 255, 255))
        -- Рисуем текст "Смена имени" по центру
        draw.DrawText("Продавец квартир", "HOMEFONT", 0, -3085, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
        -- Завершаем рисование 3D-текста и элементов
        cam.End3D2D()
    end
end 