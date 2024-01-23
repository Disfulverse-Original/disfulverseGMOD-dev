--[[Enhanced Cocaine Laboratory 1.2]]
--[[Leaked by High Leaker          ]]
--[[Enjoy !                        ]]

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize( ) 
 
	self:SetModel( ECL.Dealer.Model ) 
	self:SetHullType( HULL_HUMAN ) 
	self:SetHullSizeNormal( )
	self:SetNPCState( NPC_STATE_SCRIPT )
	self:SetSolid(  SOLID_BBOX ) 
	self:CapabilitiesAdd( CAP_TURN_HEAD ) 
	self:SetUseType( SIMPLE_USE )
	self:DropToFloor()
 
	self:SetMaxYawSpeed( 90 )

	self:SetNWInt("distance", ECL.Draw.Distance);
	self:SetNWBool("using", ECL.Cocaine.HideInPocketOnUse);
	self:SetNWBool("aiming", ECL.Draw.AimingOnEntity);
	self:SetNWBool("fadein", ECL.Draw.FadeInOnComingCloser);
end

function ENT:AcceptInput( Name, Activator, Caller )	
	if Name == "Use" and Caller:IsPlayer() then
		if !self:GetNWBool("using") then
			local tbl = {}
			local entities = ents.FindInSphere(self:GetPos(),20)
			for k, v in pairs(entities) do 
				tbl[#tbl+1] = v:GetClass()
			end

			if table.HasValue(tbl, "ecl_cocaine") then
				for k, v in pairs(entities) do 
					if v:GetClass() == "ecl_cocaine" then
						v:Effect()
						Caller:SendLua("local tab = {Color(255,165,0,255), ECL.Language.Entities.CocaineDealer..[[: ]], Color(255,255,255), ECL.Language.Dealer.GoodStuff } chat.AddText(unpack(tab))")	
						Caller:addMoney(v:GetNWInt("price"))
						DarkRP.notify(Caller, 0, 4, "You have received a "..DarkRP.formatMoney(v:GetNWInt("price"))..".")
					end
				end
			else
				Caller:SendLua("local tab = {Color(255,165,0,255), ECL.Language.Entities.CocaineDealer..[[: ]], Color(255,255,255), ECL.Language.Dealer.CannotFind } chat.AddText(unpack(tab))")
			end
		else
			if Caller.ECL and Caller.ECL.CocaineAmount > 0 then
				Caller:SendLua("local tab = {Color(255,165,0,255), ECL.Language.Entities.CocaineDealer..[[: ]], Color(255,255,255), ECL.Language.Dealer.GoodStuff } chat.AddText(unpack(tab))")	
				Caller:addMoney(Caller.ECL.CocainePrice)
				DarkRP.notify(Caller, 0, 4, "You have received a "..DarkRP.formatMoney(Caller.ECL.CocainePrice)..".")
				Caller.ECL.CocaineAmount = 0;
				Caller.ECL.CocainePrice = 0;
			else
				Caller:SendLua("local tab = {Color(255,165,0,255), ECL.Language.Entities.CocaineDealer..[[: ]], Color(255,255,255), [[Get out of here!]] } chat.AddText(unpack(tab))")
			end
		end;
	end
end