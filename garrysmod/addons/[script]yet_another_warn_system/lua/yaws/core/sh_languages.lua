YAWS.Language.Languages = YAWS.Language.Languages or {}

if(CLIENT) then 
    function YAWS.Language.GetTranslation(key)
        return YAWS.Language.Languages[YAWS.Language.Language or "English"][key]
    end 
    -- This is here for the context menu, that can sometimes call it too early
    -- and cause errors
    function YAWS.Language.GetTranslationSafe(key)
        if(table.Count(YAWS.Language.Languages) <= 0) then return "" end
        if(!YAWS.Language.Languages[YAWS.Language.Language or "English"]) then return "" end
        
        return YAWS.Language.Languages[YAWS.Language.Language or "English"][key]
    end 
    function YAWS.Language.GetFormattedTranslation(key, ...)
        return string.format(YAWS.Language.GetTranslation(key), unpack({...}))
    end 
    
    function YAWS.Language.SelectLanguage()
        YAWS.Language.Language = YAWS.UserSettings.GetValue("selected_language")
    end 
    hook.Add("yaws.usersettings.updated", "yaws.languages.change", function(key, val)
        if(key != "selected_language") then return end 
        YAWS.Language.SelectLanguage()

        hook.Run("yaws.language.updated")
    end)
    hook.Add("yaws.usersettings.created", "yaws.languages.setup", function()
        YAWS.Language.SelectLanguage()
    end)

    function YAWS.Language.SendMessage(key, ...)
        local col = YAWS.Config.GetValue("prefix_color")
        chat.AddText(Color(col.r, col.g, col.b), YAWS.Config.GetValue("prefix"), " ", Color(255, 255, 255), YAWS.Language.GetFormattedTranslation(key, unpack({...})))
    end 

    net.Receive("yaws.language.sendmessage", function(len)
        YAWS.Core.PayloadDebug("yaws.language.sendmessage", len)
        local key = net.ReadString()
        
        local args = {}
        local hasArgs = net.ReadBool()
        if(hasArgs) then 
            local length = net.ReadUInt(16)
            local data = net.ReadData(length)
            
            args = util.JSONToTable(util.Decompress(data))
        end 
        
        YAWS.Language.SendMessage(key, unpack(args))
    end)
else 
    util.AddNetworkString("yaws.language.sendmessage")

    function YAWS.Language.SendMessage(ply, key, ...)
        net.Start("yaws.language.sendmessage")
        net.WriteString(key)
        -- this is serverside so this is okay
        local args = {...}
        if(#args > 0) then
            net.WriteBool(true)

            local data = util.Compress(util.TableToJSON(args))

            net.WriteUInt(#data, 16)
            net.WriteData(data)
        else 
            net.WriteBool(false)
        end     
        net.Send(ply)
    end 
end