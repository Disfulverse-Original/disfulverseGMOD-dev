--[[ Client functions ]]--

-- Vars
local LAST_WIDTH = ScrW()
local LAST_HEIGHT = ScrH()

-- X-Responsive function
function WasiedAdminSystem:RespX(x)
    return x/1920*LAST_WIDTH
end

-- Y-Responsive function
function WasiedAdminSystem:RespY(y)
    return y/1080*LAST_HEIGHT
end

-- Font creation function
local fonts = {}
function WasiedAdminSystem:Font(size)
    if not isnumber(size) then return Error(WasiedAdminSystem.Constants["strings"][4]..WasiedAdminSystem.Constants["strings"][7]) end

    if not fonts[size] then
        surface.CreateFont("WASFont"..size, {
            font = "Roboto",
            extended = true,
            antialias = true,
            size = 19,
            weight = 500,
        })
        fonts[size] = true
    end

    return ("WASFont"..size or "DermaDefault")
end

-- Create again font with new resolution
hook.Add("OnScreenSizeChanged", "WasiedAdminSystem:RebuildFont", function()
    fonts = {}
end)

-- Make /// usable
if WasiedAdminSystem.Config.DefaultCommandReplaced then
    hook.Add("OnPlayerChat", "WasiedAdminSystem:OnPlayerChat", function(ply, str)
        if (ply ~= LocalPlayer()) then return end
        str = str:lower():Trim()

        if string.StartWith(str, "///") or string.StartWith(str, "@") then
            WasiedAdminSystem:OpenTicketMenu()
            return true
        end
    end)
end