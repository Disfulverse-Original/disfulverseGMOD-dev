include("shared.lua")

surface.CreateFont( "NPCFONT1", {
 font = "Roboto",
 size = 49,
 weight = 550,
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

    -- Проверяем, активированы ли заголовки NPC
    if not Slawer.Jobs.CFG.EnableNPCTitle then return end

    -- Проверяем, находится ли локальный игрок вблизи объекта
    if LocalPlayer():GetPos():DistToSqr(self:GetPos()) < 50000 then
        -- Получаем позицию и углы объекта
        local vecPos = self:LocalToWorld(Vector(4, -1, 77))
        local angPos = self:LocalToWorldAngles(Angle(0, LocalPlayer():EyeAngles().y - self:GetAngles().y - 90, 90))

        -- Начинаем рисование 3D-текста и элементов
        cam.Start3D2D(vecPos, angPos, 0.050)
        -- Рисуем фон с закругленными углами
        draw.RoundedBoxEx(10, -250, -25, 500, 85, Color(21, 40, 56, 255), true, true, false, false)
        -- Рисуем прямоугольную полосу сверху
        draw.RoundedBox(0, -250, 50, 500, 10, Color(255, 255, 255, 255))
        -- Рисуем текст NPC имени по центру
        draw.DrawText(self:GetNPCName(), "NPCFONT1", 0, -11, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
        -- Завершаем рисование 3D-текста и элементов
        cam.End3D2D()
    end
end




