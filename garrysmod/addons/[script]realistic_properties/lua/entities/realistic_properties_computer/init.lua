--[[
 _____           _ _     _   _       ______                          _   _           
| ___ \         | (_)   | | (_)      | ___ \                        | | (_)          
| |_/ /___  __ _| |_ ___| |_ _  ___  | |_/ / __ ___  _ __   ___ _ __| |_ _  ___  ___ 
|    // _ \/ _` | | / __| __| |/ __| |  __/ '__/ _ \| '_ \ / _ \ '__| __| |/ _ \/ __|
| |\ \  __/ (_| | | \__ \ |_| | (__  | |  | | | (_) | |_) |  __/ |  | |_| |  __/\__ \
\_| \_\___|\__,_|_|_|___/\__|_|\___| \_|  |_|  \___/| .__/ \___|_|   \__|_|\___||___/                          

]]

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel( "models/props/sycreations/Workstation.mdl" )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	if not istable(self.Table) && not istable(self.TableEnt) then 
		local RealisticPropertiesFil = file.Read("realistic_properties/"..game.GetMap().."/properties.txt", "DATA") or ""
		local RealisticPropertiesTab = util.JSONToTable(RealisticPropertiesFil) or {}
		self.Table = RealisticPropertiesTab 
		self.TableEnt = {}
	end 
end

function ENT:Use(activator)
	local RealisticPropertiesFil = file.Read("realistic_properties/"..game.GetMap().."/properties.txt", "DATA") or ""
    local RealisticPropertiesTab = util.JSONToTable(RealisticPropertiesFil) or {} 

	if #RealisticPropertiesTab == 0 then Realistic_Properties:Notify(activator, 47) return end 
	if #self.TableEnt == #RealisticPropertiesTab then 
		Realistic_Properties:Notify(activator, 47) 
	return 
	end 

	local CompressTable = util.Compress(RealisticPropertiesFil)
	net.Start("RealisticProperties:BuySellProperties")
		net.WriteEntity(self)
		net.WriteInt(CompressTable:len(), 32)
		net.WriteData( CompressTable, CompressTable:len() )
		net.WriteTable(self.TableEnt)
		net.WriteInt(1, 2)
		net.WriteInt(#Realistic_Properties:TableOwner(activator), 32)
	net.Send(activator)

	if table.Count(RealisticPropertiesTab) != 0 then 
		activator:SetFOV( 90, 0.5 )
	end 
end 