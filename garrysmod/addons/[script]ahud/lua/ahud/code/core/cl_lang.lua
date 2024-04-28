function ahud.L(key, ...)
    if !ahud.LanguageTable[key] then
        print("[AHud] There a error with the language's text : " .. key)
    end

    return ... and string.format( ahud.LanguageTable[key], ... ) or ahud.LanguageTable[key]
end