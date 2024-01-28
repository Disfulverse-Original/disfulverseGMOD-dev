local CATEGORY_NAME = "Utility"

local CATEGORY_NAME = "Utility"

if (CLIENT) then
	local enabled = false;
	concommand.Add("thirdperson_toggle", function ()
		enabled = !enabled;
	end);
	hook.Add("ShouldDrawLocalPlayer", "ThirdPersonDrawPlayer", function ()
		if (enabled && LocalPlayer():Alive()) then
			return true;
		end
	end);
	hook.Add("CalcView", "ThirdPersonView", function (ply, pos, ang, fov, madeByZero)
		if (enabled && IsValid(ply) && ply:Alive()) then
			if (IsValid(ply:GetActiveWeapon())) then
				ply:GetActiveWeapon().AccurateCrosshair = true;
			end
			local view = {};
			view.origin = (pos - (ang:Forward() * 70) + (ang:Right() * 20) + (ang:Up() * 5));
			view.ang = (ply:EyeAngles() + Angle(1, 1, 0));
			local TrD = {}
			TrD.start = (ply:EyePos())
			TrD.endpos = (TrD.start + (ang:Forward() * - 75) + (ang:Right() * 25) + (ang:Up() * 10));
			TrD.filter = ply;
			local trace = util.TraceLine(TrD);
			pos = trace.HitPos;
			if (trace.Fraction < 1) then
				pos = pos + trace.HitNormal * 5;
			end
			view.origin = pos;
			view.fov = fov;
			return GAMEMODE:CalcView(ply, view.origin, view.ang, view.fov);
		end
	end);
	function ulx.thirdperson(calling_ply)
	calling_ply:SendLua([[RunConsoleCommand("thirdperson_toggle")]]);
	end
	local thirdperson = ulx.command("Utility", "ulx thirdperson", ulx.thirdperson, {"!3p", "!thirdperson"}, true);
	thirdperson:defaultAccess(ULib.ACCESS_ALL);
	thirdperson:help("Toggle third person mode.");
	net.Receive("ulxcc_steamid", function (_, ply)
		if (ply:IsAdmin()) then
			local id2 = net.ReadString();
			local tbl = ULib.bans[id2];
			net.Start("ulxcc_steamid");
				net.WriteTable(tbl);
			net.Send(ply);
		end
	end);
	net.Receive("ulxcc_friends", function (_, ply)
		if (net.ReadEntity() == ply.expcall) then
			net.Start("ulxcc_sendfriends");
				net.WriteTable(net.ReadTable());
				net.WriteString(ply:Nick());
			net.Send(ply.expcall);
		end
		ply.expcall = nil;
	end);
end