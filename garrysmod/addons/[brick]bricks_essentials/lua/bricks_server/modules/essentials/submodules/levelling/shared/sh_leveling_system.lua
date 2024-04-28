function BRICKS_SERVER.Func.GetExpToLevel( from, to )
    local totalExp = 0

    for i = 0, (to-from)-1 do
        --local levelExp = BRICKS_SERVER.CONFIG.LEVELING["Original EXP Required"]*(BRICKS_SERVER.CONFIG.LEVELING["EXP Required Increase"]^(from+i) )
        local levelExp = BRICKS_SERVER.CONFIG.LEVELING["Original EXP Required"] * math.exp(BRICKS_SERVER.CONFIG.LEVELING["EXP Required Increase"] * (from + i))
        totalExp = totalExp+levelExp
    end

    return totalExp
end

print(BRICKS_SERVER.Func.GetExpToLevel(2,3))

function BRICKS_SERVER.Func.GetCurLevelExp( ply )
    local level = (ply.BRS_LEVEL or BRS_LEVEL) or 0

    local experience = ply.BRS_EXPERIENCE or BRS_EXPERIENCE

    local totalOldExp = BRICKS_SERVER.Func.GetExpToLevel( 0, level )

    return experience-totalOldExp
end


--[[
local function calculateRequiredExperience(level, baseExp, expFactor)
    return baseExp * math.exp(expFactor * (level - 1))
end

-- Example usage: calculating required experience for level 20 and level 30
local baseExperience = 1000  -- Base experience requirement for level 1
local experienceFactor = 0.2 -- Exponential growth factor

for level = 1, 30 do
    local requiredExp = calculateRequiredExperience(level, baseExperience, experienceFactor)
    print(string.format("Level %d: Required Exp = %.2f", level, requiredExp))
end
--]]
