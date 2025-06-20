YAWS.UserSettings.Settings = YAWS.UserSettings.Settings or {
    dark_mode = {
        name = "user_settings_darkmode_name",
        desc = "user_settings_darkmode_desc",
        default = false,
        value = nil,
        type = "boolean"
    },
    selected_language = {
        name = "user_settings_language_name",
        desc = "user_settings_language_desc",
        default = "English",
        value = nil,
        type = "combo",
        type_override = "string" -- used for storage stuff
    },
}

-- load our settings (ripped from ups / betterbanking)
hook.Add("yaws.core.initalize", "yaws.usersettings.client", function()
    -- langauges aren't loaded on startup so hi 
    YAWS.UserSettings.Settings['selected_language'].options = table.GetKeys(YAWS.Language.Languages)

    if(!sql.TableExists("yaws_settings")) then
        local create = sql.Query("CREATE TABLE `yaws_settings`(`key` VARCHAR(255) PRIMARY KEY, `value` VARCHAR(255));")

        if(create == false) then
            YAWS.Core.Print("Something went wrong creating the client-based settings table. This will (most likely) cause errors. Try re-joining the game, if that doesn't work then tell the server developers to create a ticket on gmodstore.")
            YAWS.Core.Print("Not continuing to fetch settings. Using default values.")

            return
        end
    end

    -- this is a bit of a rats nest but idk how to improve it :/
    local q = sql.Query("SELECT * FROM `yaws_settings`;")
    if(q != nil) then 
        if(q == false) then
            YAWS.Core.Print("Something went wrong fetching from the client-based settings table. This will most likely cause errors. Try re-joining the game, if that doesn't work then tell the server developers to create a ticket on gmodstore.")
            YAWS.Core.Print("Not continuing to fetch settings. Using default values.")

            return
        end

        for k,v in ipairs(q) do
            if(!YAWS.UserSettings.Settings[v.key]) then continue end

            local type = YAWS.UserSettings.Settings[v.key].type
            if(YAWS.UserSettings.Settings[v.key].type_override) then 
                type = YAWS.UserSettings.Settings[v.key].type_override
            end 

            local value = YAWS.Core.StorableToLua(v.value, type) -- This func is declared shared in sh_settings and shared files are loaded before client files in the autoloader, so this function definitely exists.
            if(YAWS.UserSettings.Settings[v.key].default == value) then
                sql.Query("DELETE FROM `yaws_settings` WHERE `key` = " .. sql.SQLStr(k) .. ";")
                continue
            end

            YAWS.UserSettings.Settings[v.key].value = value
        end
    end

    YAWS.Core.Print("Successfully loaded client's settings.")
    hook.Run("yaws.usersettings.created")
end)

function YAWS.UserSettings.SetValue(key, val)
    if(YAWS.UserSettings.Settings[key].value == val) then return end
    
    YAWS.UserSettings.Settings[key].value = val
    
    local storable = YAWS.Core.LuaToStorable(val)
    sql.Query("REPLACE INTO `yaws_settings`(`key`, `value`) VALUES(" .. sql.SQLStr(key) .. ", " .. sql.SQLStr(storable) .. ");")
    
    hook.Run("yaws.usersettings.updated", key, val)
end
function YAWS.UserSettings.GetValue(key)
    if(YAWS.UserSettings.Settings[key] == nil) then return end

    if(YAWS.UserSettings.Settings[key].value == nil) then
        return YAWS.UserSettings.Settings[key].default
    end
    return YAWS.UserSettings.Settings[key].value
end