if SERVER then

--setup
resource.AddFile( "resource/fonts/verdana.ttf" )

nextspawn = CurTime();
util.AddNetworkString("enableDrawBlurEffect")
util.AddNetworkString("disableDrawBlurEffect")

local defaultstring = "Вы критически ранены.\nДождитесь реанимации или повторного возрождения."
local deathsystem_autorespawn = true
local deathtime = 45
--


--player death
local function initializeCustomThinkDeath(ply, wep, killer)

    net.Start("enableDrawBlurEffect")
		net.WriteType(true)
	    net.WriteString(defaultstring)
	net.Send(ply)
	
    ply.nextspawn = CurTime() + deathtime;
	ply.drp_jobswitch = false;

end
hook.Add("DoPlayerDeath", "initializeCustomThinkDeath", initializeCustomThinkDeath);


-- check time while death until can be respawned
local function dev_customThinkDeath(ply)

	ply:SetNWFloat("deathTimeLeft", ply.nextspawn - CurTime())
	if (CurTime() >= ply.nextspawn) or ply:IsSuperAdmin() then
		ply:Spawn()
	    ply.nextspawn = math.huge
	else
		return false
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