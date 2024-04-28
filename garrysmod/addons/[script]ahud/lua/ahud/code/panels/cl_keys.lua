local function openMenu(setDoorOwnerAccess, doorSettingsAccess)

    if !LocalPlayer():IsSuperAdmin() then return false end

    local trace = LocalPlayer():GetEyeTrace()
    local ent = trace.Entity
    -- Don't open the menu if the entity is not ownable, the entity is too far away or the door settings are not loaded yet
    if not IsValid(ent) or not ent:isKeysOwnable() or trace.HitPos:DistToSqr(LocalPlayer():EyePos()) > 40000 then return end

    local entType = DarkRP.getPhrase(ent:IsVehicle() and "vehicle" or "door")

    local buttons = {}

    -- All the buttons

    if ent:isKeysOwnedBy(LocalPlayer()) then
        table.insert(buttons, {
            txt = DarkRP.getPhrase("sell_x", entType),
            callback = function()
                RunConsoleCommand("darkrp", "toggleown")
            end
        })

        table.insert(buttons, {
            txt = DarkRP.getPhrase("add_owner"),
            callback = function()
                local menu = DermaMenu()
                menu.found = false
                for _, v in pairs(DarkRP.nickSortedPlayers()) do
                    if not ent:isKeysOwnedBy(v) and not ent:isKeysAllowedToOwn(v) then
                        local steamID = v:SteamID()
                        menu.found = true
                        menu:AddOption(v:Nick(), function() RunConsoleCommand("darkrp", "ao", steamID) end)
                    end
                end
                if not menu.found then
                    menu:AddOption(DarkRP.getPhrase("noone_available"), function() end)
                end
                menu:Open()
            end
        })

        if ent:isMasterOwner(LocalPlayer()) then
            table.insert(buttons, {
                txt = DarkRP.getPhrase("remove_owner"),
                callback = function()
                    local menu = DermaMenu()
                    for _, v in pairs(DarkRP.nickSortedPlayers()) do
                        if (ent:isKeysOwnedBy(v) and not ent:isMasterOwner(v)) or ent:isKeysAllowedToOwn(v) then
                            local steamID = v:SteamID()
                            menu.found = true
                            menu:AddOption(v:Nick(), function() RunConsoleCommand("darkrp", "ro", steamID) end)
                        end
                    end
                    if not menu.found then
                        menu:AddOption(DarkRP.getPhrase("noone_available"), function() end)
                    end
                    menu:Open()
                end
            })
        end
    end

    if doorSettingsAccess then
        table.insert(buttons, {
            txt = DarkRP.getPhrase(ent:getKeysNonOwnable() and "allow_ownership" or "disallow_ownership"),
            callback = function() RunConsoleCommand("darkrp", "toggleownable") end
        })
    end

    if doorSettingsAccess and (ent:isKeysOwned() or ent:getKeysNonOwnable() or ent:getKeysDoorGroup() or hasTeams) or ent:isKeysOwnedBy(LocalPlayer()) then
        table.insert(buttons, {
            txt = DarkRP.getPhrase("set_x_title", entType),
            callback = function()
                Derma_StringRequest(DarkRP.getPhrase("set_x_title", entType), DarkRP.getPhrase("set_x_title_long", entType), "", function(text)
                    RunConsoleCommand("darkrp", "title", text)
                end,
                function() end, DarkRP.getPhrase("ok"), DarkRP.getPhrase("cancel"))
            end
        })
    end

    if not ent:isKeysOwned() and not ent:getKeysNonOwnable() and not ent:getKeysDoorGroup() and not ent:getKeysDoorTeams() or not ent:isKeysOwnedBy(LocalPlayer()) and ent:isKeysAllowedToOwn(LocalPlayer()) then
        table.insert(buttons, {
            txt = DarkRP.getPhrase("buy_x", entType),
            callback = function()
                RunConsoleCommand("darkrp", "toggleown")
            end
        })
    end

    if doorSettingsAccess then
        table.insert(buttons, {
            txt = DarkRP.getPhrase("edit_door_group"),
            callback = function()
                local menu = DermaMenu()
                local groups = menu:AddSubMenu(DarkRP.getPhrase("door_groups"))
                local teams = menu:AddSubMenu(DarkRP.getPhrase("jobs"))
                local add = teams:AddSubMenu(DarkRP.getPhrase("add"))
                local remove = teams:AddSubMenu(DarkRP.getPhrase("remove"))

                menu:AddOption(DarkRP.getPhrase("none"), function()
                    RunConsoleCommand("darkrp", "togglegroupownable")
                end)

                for k in pairs(RPExtraTeamDoors) do
                    groups:AddOption(k, function()
                        RunConsoleCommand("darkrp", "togglegroupownable", k)
                    end)
                end

                local doorTeams = ent:getKeysDoorTeams()
                for k, v in pairs(RPExtraTeams) do
                    local which = (not doorTeams or not doorTeams[k]) and add or remove
                    which:AddOption(v.name, function()
                        RunConsoleCommand("darkrp", "toggleteamownable", k)
                    end)
                end

                menu:Open()
            end
        })
    end

    if #buttons == 1 then
        buttons[1].callback()
    elseif !table.IsEmpty(buttons) then
        if !ahud.radMenuOpened then
            local v = vgui.Create("ahudRadial")
            v:BuildPanels(buttons)

            function v:Think()
                local tr = LocalPlayer():GetEyeTrace()
                local LAEnt = tr.Entity
                if !IsValid(LAEnt) or !LAEnt:isKeysOwnable() or tr.HitPos:DistToSqr(LocalPlayer():EyePos()) > 40000 then
                    v:Remove()
                end
            end

            hook.Call("onKeysMenuOpened", nil, ent, v)
        end
    end
end

// Support lua refresh, else darkrp put his menu back
local function detour()
    if DarkRP then
        function DarkRP.openKeysMenu()
            CAMI.PlayerHasAccess(LocalPlayer(), "DarkRP_SetDoorOwner", function(setDoorOwnerAccess)
                CAMI.PlayerHasAccess(LocalPlayer(), "DarkRP_ChangeDoorSettings", openMenu(openMenu, setDoorOwnerAccess))
            end)
        end

        GAMEMODE.ShowTeam = DarkRP.openKeysMenu
        usermessage.Hook("KeysMenu", DarkRP.openKeysMenu)
    end
end

detour()
hook.Add("PostGamemodeLoaded", "ahud_detourKeys", detour)