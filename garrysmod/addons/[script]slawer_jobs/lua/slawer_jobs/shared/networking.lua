if SERVER then util.AddNetworkString("Slawer.Jobs") end

Slawer.Jobs.NetsList = Slawer.Jobs.NetsList or {}

function Slawer.Jobs:NetReceive(strName, fnCallback, intDelay)
	self.NetsList[strName] = {
		callback = fnCallback,
		delay = intDelay or 0.1
	}
end

function Slawer.Jobs:NetStart(strName, tblToSend, pTo)
	local tbl, intLength = self:Compress(tblToSend)

	net.Start("Slawer.Jobs")
		net.WriteString(strName)
		net.WriteUInt(intLength, 32)
		net.WriteData(tbl, intLength)
	if ( SERVER ) then
		if pTo then
			net.Send(pTo)
		elseif tblToSend:IsPlayer() then
			net.Send(tblToSend)
		else
			net.Broadcast()
		end
	else
		net.SendToServer()
	end
end

net.Receive("Slawer.Jobs", function(_, pSender)
	local strName = net.ReadString()

	if not Slawer.Jobs.NetsList[strName] then return end
	
	if ( SERVER ) then
        pSender.tblSlawerJobsNets = pSender.tblSlawerJobsNets or {}
        if pSender.tblSlawerJobsNets[strName] and pSender.tblSlawerJobsNets[strName] > CurTime() then return end
        pSender.tblSlawerJobsNets[strName] = CurTime() + (Slawer.Jobs.NetsList[strName].delay or 0.2)
    end

	local intLength = net.ReadUInt(32)
	local tCompressed = net.ReadData(intLength)
	local tblToSend = Slawer.Jobs:Decompress(tCompressed)


	if ( SERVER ) then
		Slawer.Jobs.NetsList[strName].callback(pSender, tblToSend)
	else
		Slawer.Jobs.NetsList[strName].callback(tblToSend)
	end
end)