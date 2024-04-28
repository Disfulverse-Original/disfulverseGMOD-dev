-- Material Cache
YAWS.UI.MaterialCache = {}
YAWS.UI.MaterialCache['left_gradient'] = Material("gui/gradient")
YAWS.UI.MaterialCache['down_gradient'] = Material("gui/gradient_down")
YAWS.UI.MaterialCache['close'] = Material("livaco/yet_another_warn_system/close.png", "smooth mips")
YAWS.UI.MaterialCache['warning'] = Material("livaco/yet_another_warn_system/warning.png", "mips smooth")
YAWS.UI.MaterialCache['player'] = Material("livaco/yet_another_warn_system/player.png", "smooth mips")
YAWS.UI.MaterialCache['admin'] = Material("livaco/yet_another_warn_system/admin.png", "smooth mips")
YAWS.UI.MaterialCache['settings'] = Material("livaco/yet_another_warn_system/wrench.png", "smooth mips")
YAWS.UI.MaterialCache['permissions'] = Material("livaco/yet_another_warn_system/permissions.png", "smooth mips")
YAWS.UI.MaterialCache['load'] = Material("livaco/yet_another_warn_system/load.png", "smooth mips")
YAWS.UI.MaterialCache['paper'] = Material("livaco/yet_another_warn_system/paper.png", "smooth mips")
YAWS.UI.MaterialCache['gavel'] = Material("livaco/yet_another_warn_system/gavel.png", "smooth mips")

function YAWS.UI.UpdatePermissionNames()
    YAWS.UI.PermissionsNames = {
        view_ui = YAWS.Language.GetTranslation("permission_view_ui"),
        view_self_warns = YAWS.Language.GetTranslation("permission_view_self_warns"),
        view_others_warns = YAWS.Language.GetTranslation("permission_view_others_warns"),
        view_admin_settings = YAWS.Language.GetTranslation("permission_view_admin_settings"),
        create_warns = YAWS.Language.GetTranslation("permission_create_warns"),
        customise_reason = YAWS.Language.GetTranslation("permission_customise_reason"),
        delete_warns = YAWS.Language.GetTranslation("permission_delete_warns"),
    }
end
-- Some "nice names" for the permissions keys
hook.Add("yaws.core.initalize", "yaws.ui.yesihadtouseahookhere", YAWS.UI.UpdatePermissionNames)
hook.Add("yaws.language.updated", "yaws.ui.anoterfuckinguselesshook", YAWS.UI.UpdatePermissionNames)

-- All the possible permissions that a group can have so the ui can loop through
-- it in order
YAWS.UI.Permissions = {"view_ui", "view_self_warns", "view_others_warns", "view_admin_settings", "create_warns", "customise_reason", "delete_warns",}

-- I do this way of fonts so theres fonts for the scaling function to use pls
-- don't yell at me thanks xx
for i=0,12 do
    surface.CreateFont("yaws." .. i, {
        font = "Roboto",
        size = ScreenScale(i),
        antialias = true,
        extended = true,
    })
    -- weight = 600,
end

-- Bits and pieces of helper stuff
function YAWS.UI.DrawShadow(x, y, w, h, downGradient)
    draw.NoTexture()
    surface.SetDrawColor(35, 35, 35, 50)

    if(downGradient) then
        surface.SetMaterial(YAWS.UI.MaterialCache['down_gradient'])
    else
        surface.SetMaterial(YAWS.UI.MaterialCache['left_gradient'])
    end

    surface.DrawTexturedRect(x, y, w, h)
end

function YAWS.UI.LerpColor(amount, old, new)
    local clr = Color(old.r, old.g, old.b, old.a)
    clr.r = Lerp(amount, old.r, new.r)
    clr.g = Lerp(amount, old.g, new.g)
    clr.b = Lerp(amount, old.b, new.b)
    clr.a = Lerp(amount, old.a, new.a)

    return clr
end

function YAWS.UI.DrawCircle(x, y, radius, quality)
    local cir = {}

    for i=1,quality do
        local rad = math.rad(i * 360) / quality

        cir[i] = {
            x = x + math.cos(rad) * radius,
            y = y + math.sin(rad) * radius
        }
    end

    draw.NoTexture()
    surface.DrawPoly(cir)
end

function YAWS.UI.TintColor(clr, amount)
    return Color(clr.r + amount, clr.g + amount, clr.b + amount)
end

-- \/ why i make fonts without knowing they'll be used
function YAWS.UI.ScaleFont(text, maxSize, min, max)
    local font = "yaws." .. min

    for i=min,max do
        font = "yaws." .. i
        surface.SetFont(font)
        local w = surface.GetTextSize(text)
        if(w <= maxSize) then continue end

        return "yaws." .. math.Max((i - 1), min)
    end

    return "yaws." .. max
end

function YAWS.UI.CutoffText(text, font, maxWidth)
    surface.SetFont(font)
    local curSize = surface.GetTextSize(text)
    if(curSize < maxWidth) then return text end

    for i=0,#text do
        i = #text - i
        if(i < 3) then return "..." end
        if(surface.GetTextSize(string.sub(text, 1, i)) < maxWidth) then return string.sub(text, 1, i - 3) .. "..." end
    end

    return "..."
end

function YAWS.UI.SetSurfaceDrawColor(clr)
    surface.SetDrawColor(clr.r, clr.g, clr.b, clr.a)
end

net.Receive("yaws.core.openui", function(len)
    YAWS.Core.PayloadDebug("yaws.core.openui", len)
    -- nother curator learn how addon work time
    -- Here I store the data the addon needs inside this table, that way if the
    -- UI needs the data it's in this table. I do this just to prevent me from
    -- shipping parameters into the ui functions all the time. 
    YAWS.UI.CurrentData = util.JSONToTable(util.Decompress(net.ReadData(net.ReadUInt(16))))

    if(YAWS.UI.CurrentData.state) then
        -- needs to open seperately
        if(YAWS.UI.CurrentData.state.state == "warning_player") then
            YAWS.UI.WarnPlayerPopup({
                steamid = YAWS.UI.CurrentData.state.steamid,
                realSteamID = util.SteamIDFrom64(YAWS.UI.CurrentData.state.steamid),
                name = YAWS.UI.CurrentData.state.name,
                usergroup = YAWS.UI.CurrentData.state.usergroup,
            })

            return
        end
    end

    YAWS.UI.CoreUI()

    -- Cached states
    if(YAWS.UI.CurrentData.state) then
        if(YAWS.UI.CurrentData.state.state == "viewing_player") then
            YAWS.UI.CurrentData.FrameCache:SetSidebarSelectedName(YAWS.Language.GetTranslation("sidebar_players"))

            YAWS.UI.HandleGettingPlayerWarndata(YAWS.UI.CurrentData.MasterCache, {
                steamid = YAWS.UI.CurrentData.state.steamid,
                name = YAWS.UI.CurrentData.state.name,
                usergroup = YAWS.UI.CurrentData.state.usergroup,
            })
        end

        if(YAWS.UI.CurrentData.state.state == "viewing_player_notes") then
            YAWS.UI.CurrentData.FrameCache:SetSidebarSelectedName(YAWS.Language.GetTranslation("sidebar_players"))

            YAWS.UI.HandleGettingPlayerWarndata(YAWS.UI.CurrentData.MasterCache, {
                steamid = YAWS.UI.CurrentData.state.steamid,
                name = YAWS.UI.CurrentData.state.name,
                usergroup = YAWS.UI.CurrentData.state.usergroup,
            }, true)
        end
    end
end)

-- Properties menu stuff 
properties.Add("yaws_primary", {
    MenuLabel = (YAWS.Language.GetTranslationSafe("yaws") == "" && "Yet Another Warning System" || YAWS.Language.GetTranslationSafe("yaws")),
    MenuIcon = "icon16/book_error.png",
    StructureField = 90000,
    Filter = function(self, ent, player)
        if(!IsValid(ent)) then return false end
        if(!ent:IsPlayer()) then return false end

        return YAWS.UI.ContextData['view'] || YAWS.UI.ContextData['create']
    end,
    -- return true 
    MenuOpen = function(self, option, ent, tr)
        local options = option:AddSubMenu("base")

        if(YAWS.UI.ContextData['create']) then
            options:AddOption(YAWS.Language.GetTranslationSafe("context_warn"), function()
                net.Start("yaws.core.c_warnplayer")
                -- 76561198121018313
                net.WriteString(ent:SteamID64() || "")
                net.SendToServer()
            end):SetIcon("icon16/page_white_edit.png")

            -- Presets
            local presetSub, presetMenuOption = options:AddSubMenu(YAWS.Language.GetTranslationSafe("context_presets"))
            presetMenuOption:SetIcon("icon16/folder_error.png")

            for k, v in pairs(YAWS.UI.ContextData['presets']) do
                local preset = presetSub:AddSubMenu(k)
                preset:AddOption(YAWS.Language.GetFormattedTranslation("context_points", v.points)):SetIcon("icon16/award_star_gold_3.png")
                preset:AddOption(YAWS.Language.GetFormattedTranslation("context_reason", v.reason)):SetIcon("icon16/page_edit.png")
                preset:AddSpacer()

                preset:AddOption(YAWS.Language.GetTranslationSafe('context_submit'), function()
                    net.Start("yaws.warns.warnplayer")
                    net.WriteBool(true)
                    net.WriteString(ent:SteamID64() || "")
                    net.WriteString(k)
                    net.SendToServer()
                end):SetIcon("icon16/accept.png")
            end

            if(YAWS.UI.ContextData['view']) then
                options:AddSpacer()
            end
        end

        if(YAWS.UI.ContextData['view']) then
            options:AddOption(YAWS.Language.GetTranslationSafe("context_viewwarns"), function()
                net.Start("yaws.core.c_viewplayer")
                net.WriteString(ent:SteamID64() || "")
                net.SendToServer()
            end):SetIcon("icon16/eye.png")

            options:AddOption(YAWS.Language.GetTranslationSafe("context_viewnotes"), function()
                net.Start("yaws.core.c_viewnotes")
                net.WriteString(ent:SteamID64() || "")
                net.SendToServer()
            end):SetIcon("icon16/page_white_edit.png")
        end
    end
})

-- Request to the server if we should be able to see the context menu 
-- This is the only cached shit there is settings/presets based 
YAWS.UI.ContextData = YAWS.UI.ContextData || {}

hook.Add("InitPostEntity", "yaws.ui.contextgview", function()
    net.Start("yaws.permissions.caniviewcontextquestionmark")
    net.SendToServer()
end)

net.Receive("yaws.permissions.maybeyoucanviewyes", function()
    YAWS.UI.ContextData['view'] = net.ReadBool()
    YAWS.UI.ContextData['create'] = net.ReadBool()

    if(YAWS.UI.ContextData['create']) then
        YAWS.UI.ContextData['presets'] = util.JSONToTable(util.Decompress(net.ReadData(net.ReadUInt(16))))
    end
end)