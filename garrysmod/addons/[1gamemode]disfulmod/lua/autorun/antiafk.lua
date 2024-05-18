-- Define constants
--[[
local AFK_TIME_THRESHOLD = 600 -- 600 seconds (10 minutes)
local KICK_MESSAGE = "Вы были кикнуты за АФК"

-- Store player activity timestamps
local playerLastActivity =  {}

-- Function to check player activity and kick if AFK
local function CheckPlayerActivity()
    for _, ply in ipairs(player.GetAll()) do
        print(ply)
        local lastActivityTime = playerLastActivity[ply]

        -- Check if last activity time is not nil and player is still connected
        if lastActivityTime and ply:IsValid() then
            -- Calculate time since last activity
            local currentTime = CurTime()
            local timeSinceLastActivity = currentTime - lastActivityTime

            -- Check if player has been inactive for the threshold time
            if timeSinceLastActivity >= AFK_TIME_THRESHOLD then
                -- Kick the player for being AFK
                ply:Kick(KICK_MESSAGE)
            end
        end
    end
end

-- Hook into player actions to track activity
hook.Add("KeyPress", "PlayerActivityTracker", function(ply)
    playerLastActivity[ply] = CurTime() -- Update last activity time on key press
end)

hook.Add("PlayerDisconnected", "ClearPlayerActivity", function(ply)
    playerLastActivity[ply] = nil -- Clear activity record on player disconnect
end)

-- Set up timer to periodically check player activity
timer.Create("AFKCheckTimer", 60, 0, CheckPlayerActivity) -- Check every 60 seconds (1 minute)

-- Print initialization message
]]
print("disful_Anti-AFK script initialized. [disabled]")

