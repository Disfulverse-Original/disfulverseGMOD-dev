// _G used to add support for TEAM_EXAMPLE in another addon or whatever
function Slawer.Jobs:CreateOrEditDarkRPJob(sTeam, tJob)
    if _G[sTeam] and RPExtraTeams[_G[sTeam]] then
        if SERVER then
            for k, v in pairs(team.GetPlayers(_G[sTeam])) do
                v:changeTeam((GAMEMODE or GM).DefaultTeam, true)
            end
        end

        DarkRP.removeJob(_G[sTeam])
    end

    local sNeedToChangeFrom = tJob.NeedToChangeFrom

    local tJob = table.Copy(tJob)
    tJob.NeedToChangeFrom = nil
    local xCustomCheck = tJob.customCheck

    if xCustomCheck then
        function tJob.customCheck(pPlayer)
            xCustomCheck = string.Replace( xCustomCheck or "return true", "ply", "Entity(" .. pPlayer:EntIndex() .. ")" )

            local code = CompileString(xCustomCheck, "Slawer.Jobs:CustomCheckJob" )

            if code then
                return code() == true
            else
                return true
            end
        end
    end

    _G[sTeam] = DarkRP.createJob(tJob.name, tJob)

    if tJob.hitman then
        DarkRP.addHitmanTeam(_G[sTeam])
    end

    if sNeedToChangeFrom then
        // as using string, need to get team when generated
        timer.Simple(1, function()
            tJob.NeedToChangeFrom = _G[sNeedToChangeFrom]
        end)
    end
end

function Slawer.Jobs:DeleteDarkRPJob(sTeam)
    if _G[sTeam] and RPExtraTeams[_G[sTeam]] then
        if SERVER then
            for k, v in pairs(team.GetPlayers(_G[sTeam])) do
                v:changeTeam((GAMEMODE or GM).DefaultTeam, true)
            end
        end

        DarkRP.removeJob(_G[sTeam])
        _G[sTeam] = nil
    end
end

function Slawer.Jobs:Compress(tbl)
	local strJSON = util.TableToJSON(tbl or {})
	local strCompressed = util.Compress(strJSON or "")
	
    return strCompressed, strCompressed:len()
end

function Slawer.Jobs:Decompress(strData)
	local strJSON = util.Decompress(strData)
	local tblResult = util.JSONToTable(strJSON or "")

	return tblResult
end