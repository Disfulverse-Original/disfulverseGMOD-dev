VoidFactions.API = VoidFactions.API or {}

local PLAYER = FindMetaTable("Player")

function PLAYER:VF_GetFactionVar(strVar, bSur)
    if (SERVER) then
        local fFaction = self:GetVFFaction()
        return fFaction and fFaction[strVar] or (!bSur and "None" or nil)
    else
        return VoidFactions.Utils.SyncedFactionPlayers[self] and VoidFactions.Utils.SyncedFactionPlayers[self][strVar] or (!bSur and "None" or nil)
    end
end

function PLAYER:VF_GetMemberVar(strVar)
    if (SERVER) then
        local mMember = self:GetVFMember()
        return mMember and mMember[strVar]
    end
end

function PLAYER:VF_GetFactionName(b)
    return SERVER and self:VF_GetFactionVar("name", b) or self:VF_GetFactionVar("faction", b)
end

function PLAYER:VF_GetFactionTag(b)
    return SERVER and self:VF_GetFactionVar("tag", b) or self:VF_GetFactionVar("tag", b)
end

function PLAYER:VF_GetRankName(b)
    if (CLIENT) then
        return self:VF_GetFactionVar("rank", b)
    end

    local rRank = self:VF_GetMemberVar("rank")
    return rRank and rRank.name or (!b and "None" or nil)
end

function PLAYER:VF_GetRankTag(b)
    if (CLIENT) then
        return self:VF_GetFactionVar("rankTag", b)
    end

    local rRank = self:VF_GetMemberVar("rank")
    return rRank and rRank.tag or (!b and "None" or nil)
end

function PLAYER:VF_GetFactionColor(b)
    return CLIENT and self:VF_GetFactionVar("factionColor", b) or self:VF_GetFactionVar("color", b)
end
