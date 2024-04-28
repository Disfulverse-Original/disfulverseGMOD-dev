--[[

Author: tochnonement
Email: tochnonement@gmail.com


23/04/2023

--]]

local creditstore = onyx.creditstore

do
    local validators = {}

    local function registerField(fieldID, fnCheck)
        validators[fieldID] = fnCheck
    end

    local function stringCheck(id, value, min, max)
        if (value == '') then
            return false, onyx.lang:Get('fieldEnter', {field = id:upper()}, true)
        end

        local len = utf8.len(value)

        if (len < min) then
            return false, onyx.lang:Get('notEnoughSymbols', {field = id:upper(), min = min}, true)
        end

        if (len > max) then
            return false, onyx.lang:Get('tooManySymbols', {field = id:upper(), max = max}, true)
        end

        return true
    end
    
    registerField('id', function(value)
        if (not isstring(value)) then return false end

        local validString, reason = stringCheck('identifier', value, 1, 16)

        if (not validString) then
            return false, reason
        end

        if (creditstore.items[value]) then
            return false, onyx.lang:Get('idMustBeUnique')
        end

        return true
    end)

    registerField('name', function(value)
        if (not isstring(value)) then return false end
        return stringCheck('name', value, 1, 24)
    end)

    registerField('price', function(value)
        value = tonumber(value)

        if (not value) then
            return false, onyx.lang:Get('fieldMustNumber', {field = 'PRICE'}, true)
        end

        if (value < 1) then
            return false, onyx.lang:Get('fieldMustPositive', {field = 'PRICE'}, true)
        end

        return true
    end)

    registerField('order', function(value)
        value = tonumber(value)

        if (not value) then
            return false, onyx.lang:Get('fieldMustNumber', {field = 'ORDER'}, true)
        end

        if (value < 1) then
            return false, onyx.lang:Get('fieldMustPositive', {field = 'ORDER'}, true)
        end

        return true
    end)

    registerField('type', function(value)
        if (value == '') then
            return false, onyx.lang:Get('fieldMustChoose', {field = 'TYPE'}, true)
        end

        if (not onyx.creditstore.types[value]) then
            return false, 'Invalid item type!'
        end

        return true
    end)

    registerField('category', function(value)
        if (value == '') then
            return false, onyx.lang:Get('fieldMustChoose', {field = 'CATEGORY'}, true)
        end

        if (not onyx.creditstore.categories[value]) then
            return false, 'Invalid category!'
        end

        return true
    end)

    registerField('model', function(value)
        if (value == '') then
            return false, onyx.lang:Get('fieldEnter', {field = 'model'}, true)
        end

        if (IsUselessModel(value)) then
            return false, onyx.lang:Get('invalidModel')
        end

        return true
    end)

    do
        local urlPatterns = {
            'https?://[^%s%\'%>%<]+',
            'http?://[^%s%\'%>%<]+',
        }

        local function isURL(text)
            for _, pattern in ipairs(urlPatterns) do
                if text:find(pattern) then
                    return true
                end
            end
            return false
        end
    
        registerField('icon', function(value)
            if (value == '') then
                return false, onyx.lang:Get('fieldEnter', {field = 'icon'}, true)
            end
    
            if (not isURL(value)) then
                return false, onyx.lang:Get('iconMustURL')
            end

            local ext = string.GetExtensionFromFilename(value)

            if (ext ~= 'jpg' and ext ~= 'png') then
                return false, onyx.lang:Get('invalidIconFormat')
            end
    
            return true
        end)
    end

    function creditstore:ValidateFieldValue(fieldID, value)
        local validator = validators[fieldID]
        assert(validator, 'unknown item field id (' .. fieldID .. ')')
        local valid, reason = validator(value)
        if (not valid) then
            return false, reason
        end
        return true
    end

    function creditstore:ValidatorExists(fieldID)
        return validators[fieldID] ~= nil
    end
end