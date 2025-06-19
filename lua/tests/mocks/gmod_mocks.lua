-- lua/tests/mocks/gmod_mocks.lua
local mocks = {}

-- Player mock
mocks.createMockPlayer = function(steamid, pos)
    return {
        SteamID = function() return steamid or "STEAM_0:1:12345" end,
        GetPos = function() return pos or Vector(0,0,0) end,
        Nick = function() return "TestPlayer" end,
        IsValid = function() return true end,
        GetInventory = function() return {} end
    }
end

-- Entity mock
mocks.createMockEntity = function()
    local ent = {
        _health = 100,
        _model = "",
        _pos = Vector(0,0,0)
    }
    
    ent.GetHealth = function() return ent._health end
    ent.SetHealth = function(h) ent._health = h end
    ent.SetModel = function(m) ent._model = m end
    ent.GetPos = function() return ent._pos end
    ent.SetPos = function(p) ent._pos = p end
    ent.IsValid = function() return true end
    
    return ent
end

-- Global mocks
_G.timer = {
    Simple = function(delay, func) func() end,
    Create = function(name, delay, reps, func) func() end
}

_G.util = {
    TraceLine = function() return {Hit = false} end
}

return mocks
