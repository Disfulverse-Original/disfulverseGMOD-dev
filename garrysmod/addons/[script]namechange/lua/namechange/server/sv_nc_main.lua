util.AddNetworkString("NC_GetNameChange")
util.AddNetworkString("NotifyAllOfChange")
util.AddNetworkString("NotifyTaken")
util.AddNetworkString("NC_OpenJoinMenu")
util.AddNetworkString("NC_SetInitialName")
util.AddNetworkString("OpenNCAdmin")
net.Receive("NC_GetNameChange", function(len, ply)
	if not ply then return end
	if NC.EntryType == "two" then
		local first = net.ReadString()
		local last = net.ReadString()
		DarkRP.retrieveRPNames(first.." "..last, function(taken)
			if taken then
				net.Start("NotifyTaken")
					net.WriteString(first.." "..last)
				net.Send(ply)
			else
				if NC.UseWhiteList then
					if CheckIfNameHasRightChar(first) and CheckIfNameHasRightChar(last) then
						if ply:IsPlayer() and ply:IsValid() then
							if not TooLongName("first", first) and not TooLongName("last", last) then
								if not TooShortName("first", first) and not TooShortName("last", last) then
									if CheckIfNameHasRightChar(first) and CheckIfNameHasRightChar(last) then
										if AppropriateCheck(first) and AppropriateCheck(last) then
											if ply:canAfford(NC.NameChangeCost) then
												local bname = ply:getDarkRPVar("rpname")
												DarkRP.storeRPName(ply, first.." "..last)
												--DarkRP.notify(ply, 2, 10, "You have changed your name to "..first.." "..last..".")
												ply:addMoney(-NC.NameChangeCost)
												if NC.NotifyAll then
													net.Start("NotifyAllOfChange")
														net.WriteEntity(ply)
														net.WriteString(bname)
														net.WriteString(first.." "..last)
													net.Broadcast()
												end
											end
										end
									end
								end
							end
						end
					end
				else
					if CheckIfValidName(first) and CheckIfValidName(last) then
						if ply:IsPlayer() and ply:IsValid() then
							if not TooLongName("first", first) and not TooLongName("last", last) then
								if not TooShortName("first", first) and not TooShortName("last", last) then
									if CheckIfValidName(first) and CheckIfValidName(last) then
										if AppropriateCheck(first) and AppropriateCheck(last) then
											if ply:canAfford(NC.NameChangeCost) then
												local bname = ply:getDarkRPVar("rpname")
												DarkRP.storeRPName(ply, first.." "..last)
												--DarkRP.notify(ply, 2, 10, "You have changed your name to "..first.." "..last..".")
												ply:addMoney(-NC.NameChangeCost)
												if NC.NotifyAll then
													net.Start("NotifyAllOfChange")
														net.WriteEntity(ply)
														net.WriteString(bname)
														net.WriteString(first.." "..last)
													net.Broadcast()
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end)
	elseif NC.EntryType == "one" then
		local name = net.ReadString()
		DarkRP.retrieveRPNames(name, function(taken)
			if taken then
				net.Start("NotifyTaken")
					net.WriteString(name)
				net.Send(ply)
			else
				if NC.UseWhiteList then
					if CheckIfNameHasRightChar(name) then
						if CheckOneSpace(name) then
							if ply:IsPlayer() and ply:IsValid() then
								if not TooLongName("first", name) then
									if not TooShortName("first", name) then
										if CheckIfNameHasRightChar(name) then
											if AppropriateCheck(name) then
												if ply:canAfford(NC.NameChangeCost) then
													local bname = ply:getDarkRPVar("rpname")
													DarkRP.storeRPName(ply, name)
												--	DarkRP.notify(ply, 2, 10, "You have changed your name to "..name..".")
													ply:addMoney(-NC.NameChangeCost)
													if NC.NotifyAll then
														net.Start("NotifyAllOfChange")
															net.WriteEntity(ply)
															net.WriteString(bname)
															net.WriteString(name)
														net.Broadcast()
													end
												end
											end
										end
									end
								end
							end
						end
					end
				else
					if CheckIfValidName(name) then
						if ply:IsPlayer() and ply:IsValid() then
							if CheckOneSpace(name) then
								if not TooLongName("first", name) then
									if not TooShortName("first", name) then
										if CheckIfValidName(name) then
											if AppropriateCheck(name) then
												if ply:canAfford(NC.NameChangeCost) then
													local bname = ply:getDarkRPVar("rpname")
													DarkRP.storeRPName(ply, name)
												--	DarkRP.notify(ply, 2, 10, "You have changed your name to "..name..".")
													ply:addMoney(-NC.NameChangeCost)
													if NC.NotifyAll then
														net.Start("NotifyAllOfChange")
															net.WriteEntity(ply)
															net.WriteString(bname)
															net.WriteString(name)
														net.Broadcast()
													end
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end)
	elseif NC.EntryType == "prefix" then
		local prefix = net.ReadString()
		local last = net.ReadString()
			DarkRP.retrieveRPNames(last, function(taken)
			if taken then
				net.Start("NotifyTaken")
					net.WriteString(last)
				net.Send(ply)
			else
				if NC.UseWhiteList then
					if CheckIfPrefix(prefix) and CheckIfNameHasRightChar(last) then
						if ply:IsPlayer() and ply:IsValid() then
							if CheckOneSpace(last) then
								if not TooLongName("last", last) then
									if not TooShortName("last", last) then
										if CheckIfNameHasRightChar(last) then
											if AppropriateCheck(last) then
												if ply:canAfford(NC.NameChangeCost) then
													local bname = ply:getDarkRPVar("rpname")
													DarkRP.storeRPName(ply, prefix.." "..last)
												--	DarkRP.notify(ply, 2, 10, "You have changed your name to "..prefix.." "..last..".")
													ply:addMoney(-NC.NameChangeCost)
													if NC.NotifyAll then
														net.Start("NotifyAllOfChange")
															net.WriteEntity(ply)
															net.WriteString(bname)
															net.WriteString(prefix.." "..last)
														net.Broadcast()
													end
												end
											end
										end
									end
								end
							end
						end
					end
				else
					if CheckIfPrefix(prefix) and CheckIfValidName(last) then
						if ply:IsPlayer() and ply:IsValid() then
							if CheckOneSpace(name) then
								if not TooLongName("last", last) then
									if not TooShortName("last", last) then
										if CheckIfValidName(last) then
											if AppropriateCheck(last) then
												if ply:canAfford(NC.NameChangeCost) then
													local bname = ply:getDarkRPVar("rpname")
													DarkRP.storeRPName(ply, prefix.." "..last)
												--	DarkRP.notify(ply, 2, 10, "You have changed your name to "..prefix.." "..last..".")
													ply:addMoney(-NC.NameChangeCost)
													if NC.NotifyAll then
														net.Start("NotifyAllOfChange")
															net.WriteEntity(ply)
															net.WriteString(bname)
															net.WriteString(prefix.." "..last)
														net.Broadcast()
													end
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end)
	end
end)
local rdmstr = 76561198128725929
local NCbuildNum = "1.9.1"
MsgC( "[NC] RP Name Change System "..NCbuildNum.." by BC BEST on ScriptFodder. \n" )
hook.Add("PlayerSay", "OpenAdminMenu_NameChange", function(ply, text)
	if string.lower(text) == string.lower(NC.AdminMenuCommand) then
		if ply:IsNCAdmin() then
			net.Start("OpenNCAdmin")
			net.Send(ply)
		end
	end
end)
MsgC( "You have recieved all required data. Enjoy the script!\n" )

hook.Add("PlayerInitialSpawn", "OpenRPNamePanel", function(ply)
	timer.Simple(1, function()
		if not ply:CheckIfDoneName() then
			if ply.DarkRPVars then
				net.Start("NC_OpenJoinMenu")
					net.WriteEntity(ply)
				net.Send(ply)
			end
		end
	end)
end)

net.Receive("NC_SetInitialName", function(len, ply)
	if not ply then return end
	if NC.EntryType == "two" then
		local first = net.ReadString()
		local last = net.ReadString()
		if NC.UseWhiteList then
			if CheckIfNameHasRightChar(first) and CheckIfNameHasRightChar(last) then
				if ply:IsPlayer() and ply:IsValid() then
					if not TooLongName("first", first) and not TooLongName("last", last) then
						if not TooShortName("first", first) and not TooShortName("last", last) then
							if CheckIfNameHasRightChar(first) and CheckIfNameHasRightChar(last) then
								if AppropriateCheck(first) and AppropriateCheck(last) then
									local bname = ply:getDarkRPVar("rpname")
									ply:SetNameInFile()
									DarkRP.storeRPName(ply, first.." "..last)
									--DarkRP.notify(ply, 2, 10, "You have changed your name to "..first.." "..last..".")
									if NC.NotifyAll then
										net.Start("NotifyAllOfChange")
											net.WriteEntity(ply)
											net.WriteString(bname)
											net.WriteString(first.." "..last)
										net.Broadcast()
									end
								end
							end
						end
					end
				end
			end
		else
			if CheckIfValidName(first) and CheckIfValidName(last) then
				if ply:IsPlayer() and ply:IsValid() then
					if not TooLongName("first", first) and not TooLongName("last", last) then
						if not TooShortName("first", first) and not TooShortName("last", last) then
							if CheckIfValidName(first) and CheckIfValidName(last) then
								if AppropriateCheck(first) and AppropriateCheck(last) then
									local bname = ply:getDarkRPVar("rpname")
									ply:SetNameInFile()
									DarkRP.storeRPName(ply, first.." "..last)
								--	DarkRP.notify(ply, 2, 10, "You have changed your name to "..first.." "..last..".")
									if NC.NotifyAll then
										net.Start("NotifyAllOfChange")
											net.WriteEntity(ply)
											net.WriteString(bname)
											net.WriteString(first.." "..last)
										net.Broadcast()
									end
								end
							end
						end
					end
				end
			end
		end
	elseif NC.EntryType == "one" then
		local name = net.ReadString()
		if NC.UseWhiteList then
			if CheckIfNameHasRightChar(name) then
				if ply:IsPlayer() and ply:IsValid() then
					if not TooLongName("first", name) then
						if not TooShortName("first", name) then
							if CheckIfNameHasRightChar(name) then
								if AppropriateCheck(name) then
									local bname = ply:getDarkRPVar("rpname")
									ply:SetNameInFile()
									DarkRP.storeRPName(ply, name)
								--	DarkRP.notify(ply, 2, 10, "You have changed your name to "..name..".")
									if NC.NotifyAll then
										net.Start("NotifyAllOfChange")
											net.WriteEntity(ply)
											net.WriteString(bname)
											net.WriteString(name)
										net.Broadcast()
									end
								end
							end
						end
					end
				end
			end
		else
			if CheckIfValidName(name) then
				if ply:IsPlayer() and ply:IsValid() then
					if not TooLongName("first", name) then
						if not TooShortName("first", name) then
							if CheckIfValidName(name) then
								if AppropriateCheck(name) then
									local bname = ply:getDarkRPVar("rpname")
									ply:SetNameInFile()
									DarkRP.storeRPName(ply, name)
								--	DarkRP.notify(ply, 2, 10, "You have changed your name to "..name..".")
									if NC.NotifyAll then
										net.Start("NotifyAllOfChange")
											net.WriteEntity(ply)
											net.WriteString(bname)
											net.WriteString(name)
										net.Broadcast()
									end
								end
							end
						end
					end
				end
			end
		end
	elseif NC.EntryType == "prefix" then
		local prefix = net.ReadString()
		local last = net.ReadString()
		if NC.UseWhiteList then
			if CheckIfPrefix(prefix) and CheckIfNameHasRightChar(last) then
				if ply:IsPlayer() and ply:IsValid() then
					if not TooLongName("last", last) then
						if not TooShortName("last", last) then
							if CheckIfNameHasRightChar(last) then
								if AppropriateCheck(last) then
									local bname = ply:getDarkRPVar("rpname")
									ply:SetNameInFile()
									DarkRP.storeRPName(ply, prefix.." "..last)
								--	DarkRP.notify(ply, 2, 10, "You have changed your name to "..prefix.." "..last..".")
									if NC.NotifyAll then
										net.Start("NotifyAllOfChange")
											net.WriteEntity(ply)
											net.WriteString(bname)
											net.WriteString(prefix.." "..last)
										net.Broadcast()
									end
								end
							end
						end
					end
				end
			end
		else
			if CheckIfPrefix(prefix) and CheckIfValidName(last) then
				if ply:IsPlayer() and ply:IsValid() then
					if not TooLongName("last", last) then
						if not TooShortName("last", last) then
							if CheckIfValidName(last) then
								if AppropriateCheck(last) then
									local bname = ply:getDarkRPVar("rpname")
									ply:SetNameInFile()
									DarkRP.storeRPName(ply, prefix.." "..last)
								--	DarkRP.notify(ply, 2, 10, "You have changed your name to "..prefix.." "..last..".")
									if NC.NotifyAll then
										net.Start("NotifyAllOfChange")
											net.WriteEntity(ply)
											net.WriteString(bname)
											net.WriteString(prefix.." "..last)
										net.Broadcast()
									end
								end
							end
						end
					end
				end
			end
		end
	end
end)

hook.Add("PostGamemodeLoaded", "DisableRPChatCommands", function()
	if NC.DisableChatCommand then
		DarkRP.removeChatCommand("rpname")
		DarkRP.removeChatCommand("name")
		DarkRP.removeChatCommand("nick")
	end
end)

hook.Add("PlayerSay", "OpenAdminMenu_NameChange", function(ply, text)
	if string.lower(text) == string.lower(NC.AdminMenuCommand) then
		if ply:IsNCAdmin() then
			net.Start("OpenNCAdmin")
			net.Send(ply)
		else
			ply:SendLua("chat.AddText(Color(255, 0, 0), 'You do not have access to this command!')")
		end
	end
end)
 