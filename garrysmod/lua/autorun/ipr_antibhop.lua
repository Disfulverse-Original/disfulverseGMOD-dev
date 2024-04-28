local ipr_delay_bhop = 0.9
local ipr_disabled_autojump = true

local ipr_key = IN_JUMP
local ipr_movetype = MOVETYPE_NOCLIP
local ipr_bhop = {}

hook.Add("StartCommand", "Ipr_Anti_BhopRestrict", function(ply, cmd)
    if not cmd:KeyDown(ipr_key) then
        return
    end

    if (cmd:CommandNumber() ~= 0) then
        if not IsValid(ply) or not ply:Alive() or (ply:GetMoveType() == ipr_movetype) then
            return
        end
        local ipr_cur = CurTime()
        if not ipr_bhop[ply] then
            ipr_bhop[ply] = {}
        end
        
        if (ipr_bhop[ply].pushc) then
            if (ipr_cur < ipr_bhop[ply].nextc) then
                cmd:RemoveKey(ipr_key)
            else
                if (SERVER) and (ipr_disabled_autojump) then
                    ply:ConCommand("-jump")
                end

                ipr_bhop[ply].pushc = false
            end
        end

        if not ipr_bhop[ply].pushc then
            ipr_bhop[ply].nextc = ipr_cur + ipr_delay_bhop
            ipr_bhop[ply].pushc = true
        end
    end
end)

if (SERVER) then
    hook.Add("PlayerDisconnected", "Ipr_Anti_BhopLeave", function(ply)
        if (ipr_bhop[ply]) then
            ipr_bhop[ply] = nil
        end
    end)
end
