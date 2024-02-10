if SERVER then

--setup
resource.AddFile( "resource/fonts/verdana.ttf" )

nextspawn = CurTime();
util.AddNetworkString("enableDrawBlurEffect")
util.AddNetworkString("disableDrawBlurEffect")

local defaultstring = "Вы критически ранены.\nДождитесь реанимации или повторного возрождения."
local deathsystem_autorespawn = true
local deathtime = 45
local deadcheck = false

--chatgpt
local quickRespawnTime = 15
local quickRespawnKey = IN_ATTACK

hook.Add("KeyPress", "CheckQuickRespawn", function(ply, key)
    if key == quickRespawnKey and deadcheck then
        ply:SetNWBool("IsQuickRespawning", true)
    end
end)

hook.Add("KeyRelease", "CheckQuickRespawnRelease", function(ply, key)
    if key == quickRespawnKey and deadcheck then
        ply:SetNWBool("IsQuickRespawning", false)
    end
end)
--chatgpt

--player death
local function initializeCustomThinkDeath(ply, wep, killer)
	deadcheck = true

    net.Start("enableDrawBlurEffect")
		net.WriteType(true)
	    net.WriteString(defaultstring)
	net.Send(ply)

	ply.drp_jobswitch = false;
    ply.nextspawn = CurTime() + deathtime;
    ply.nextquickspawn = CurTime() + quickRespawnTime;

end
hook.Add("DoPlayerDeath", "initializeCustomThinkDeath", initializeCustomThinkDeath);


-- check time while death until can be respawned
local function dev_customThinkDeath(ply)

    if ply:IsSuperAdmin() then ply:Spawn() ply.nextspawn = math.huge deathcheck = false return end

    if ply:GetNWBool("IsQuickRespawning", false) then
    	--ply:ChatPrint(quickRespawnTime)
        ply:SetNWFloat("deathTimeLeft", ply.nextquickspawn - CurTime())
        if CurTime() >= ply.nextquickspawn then
            ply:Spawn()
            ply.nextspawn = math.huge
            deadcheck = false
        else
            return false
        end
    else
        ply:SetNWFloat("deathTimeLeft", ply.nextspawn - CurTime())
        if (CurTime() >= ply.nextspawn) then
            ply:Spawn()
            ply.nextspawn = math.huge
            deadcheck = false
        else
            return false
        end
    end

end
hook.Add("PlayerDeathThink", "dev_customThinkDeath", dev_customThinkDeath)


--player respawn
local function dev_customPlayerSpawn(ply)
    net.Start("disableDrawBlurEffect")
	net.WriteType(false)
	net.Send(ply)
end
hook.Add("PlayerSpawn", "dev_customPlayerSpawn", dev_customPlayerSpawn)


end