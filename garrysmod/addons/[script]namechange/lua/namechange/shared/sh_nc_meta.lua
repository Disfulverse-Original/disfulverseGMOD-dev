local Meta = FindMetaTable("Player")

function Meta:IsNCAdmin() 
	if table.HasValue(NC.Admin, string.lower(self:GetUserGroup())) then
		return true
	else
		return false
	end
end

function CheckOneSpace(text)
	local rtbl = string.ToTable(text)
	local artbl = {}
	if NC.OnlyAllowOneSpace then
		for k, v in pairs(rtbl) do
			if v == " " then
				table.insert(artbl, k)
			end
		end
		if table.Count(artbl) > 1 then
			return false
		else
			return true
		end
	else
		return true
	end
end

function AppropriateCheck(text)
	for k, v in pairs(NC.InnappropriateName) do
		if string.lower(v) == string.lower(text) then
			return false
		elseif string.match(text, v) then
			return false
		end
	end
	return true
end

function CheckIfNameHasRightChar(text)
	text = string.lower(text)
	local rtbl = string.ToTable(text)
	for k, v in pairs(rtbl) do
		if not table.HasValue(NC.WhiteList, v) then
			return false
		end
	end
	return true
end

function CheckIfPrefix(text)
	for k, v in pairs(NC.Prefix) do
		if v == text then
			return true
		end
	end
	return false
end
	
function GetInvalidChar(text)
	text = string.lower(text)
	local rtbl = string.ToTable(text)
	for k, v in pairs(rtbl) do
		if not table.HasValue(NC.WhiteList, v) then
			return v
		end
	end
end

function CheckIfValidName(text)
	local rtbl = string.ToTable(text)
	for k, v in pairs(rtbl) do
		if table.HasValue(NC.BlackList, v) then
			return false
		end
	end
	return true
end
function GetInvalidCharacter(text)
	local rtbl = string.ToTable(text)
	for k, v in pairs(rtbl) do
		if table.HasValue(NC.BlackList, v) then
			return v
		end
	end
end
function TooLongName(type, text)
	local len = string.len(text)
	if type == "first" then
		if len > NC.MaxAmtFirstName then
			return true
		else
			return false
		end
	else
		if len > NC.MaxAmtLastName then
			return true
		else
			return false
		end
	end
end
function TooShortName(type, text)
	local len = string.len(text)
	if type == "first" then
		if len < NC.MinAmtFirstName then
			return true
		else
			return false
		end
	else
		if len < NC.MinAmtLastName then
			return true
		else
			return false
		end
	end
end
function AutoCap(text)
	return table.concat({text[1]:upper(), string.sub(text,2):lower()})
end
function Meta:CheckIfDoneName()
	if file.Exists( "namenpc/completedname.txt", "DATA" ) then 
		local FILE = file.Read( "namenpc/completedname.txt", "DATA" )
		local TABLE = util.JSONToTable(FILE)
		for k, v in pairs(TABLE) do
			if v == self:SteamID() then
				return true
			end
		end
		return false
	else
		return false
	end
end

function Meta:SetNameInFile()
	if file.Exists( "namenpc/completedname.txt", "DATA" ) then 
		local FILE = file.Read( "namenpc/completedname.txt", "DATA" )
		local TABLE = util.JSONToTable(FILE)
		table.insert(TABLE, self:SteamID())
		file.Write( "namenpc/completedname.txt", util.TableToJSON(TABLE))
		print("[NC] File there, rewrote it.")
	else
		local tbl = {}
		table.insert(tbl, self:SteamID())
		file.Write( "namenpc/completedname.txt", util.TableToJSON(tbl))
		print("[NC] File not there, wrote a new one.")
	end
end

function NCRequestBox(text, text2, button1, button1fun, button2, button2fun)
	if !IsValid(RequestInput) then 
		local RequestInput = vgui.Create( "DFrame" ) 
		RequestInput:SetSize( 400, 125 )
		RequestInput:Center()
		RequestInput:SetTitle( " " ) 
		RequestInput:SetVisible( true )
		RequestInput:SetDraggable( false ) 
		RequestInput:ShowCloseButton( false ) 				
		RequestInput:MakePopup() 
		RequestInput.Paint = function(self, w, h)
			draw.RoundedBoxEx( 4, 0, 0, w, 30, NC.Color.Header, true, true, false, false )
			draw.RoundedBoxEx( 4, 0, 30, w, h-30, NC.Color.MainPageSecondary, false, false, true, true )	
			draw.SimpleText( text, "RCNPC_InfoText", RequestInput:GetWide()/2, 35, NC.Color.MainPageText, TEXT_ALIGN_CENTER )
			draw.SimpleText( text2, "RCNPC_InfoText", RequestInput:GetWide()/2, 55, NC.Color.MainPageText, TEXT_ALIGN_CENTER )
		end
		
		local Button1 = vgui.Create( "DButton", RequestInput )
		Button1:SetSize( 76, 30 )
		if button2 then
			Button1:SetPos( RequestInput:GetWide()/2-84,RequestInput:GetTall()-40 )
		else
			Button1:SetPos( RequestInput:GetWide()/2-38,RequestInput:GetTall()-40 )
		end
		Button1:SetText( "" )
		Button1:SetTextColor( NC.Color.CloseButton )
		Button1.Paint = function(self, w, h)
			draw.RoundedBox( 0, 0, 0, w, h, NC.Color.Primary )
			draw.SimpleText( button1, "RCNPC_EntryTitle", Button1:GetWide()/2, 5, NC.Color.HeaderText, TEXT_ALIGN_CENTER )
		end
		Button1.DoClick = function()
			RequestInput:Remove()	
			button1fun()		
		end
		if button2 then
			local Button2 = vgui.Create( "DButton", RequestInput )
			Button2:SetSize( 76, 30 )
			Button2:SetPos( RequestInput:GetWide()/2+8,RequestInput:GetTall()-40 )
			Button2:SetText( "" )
			Button2:SetTextColor( NC.Color.CloseButton )
			Button2.Paint = function(self, w, h)
				draw.RoundedBox( 0, 0, 0, w, h, NC.Color.Primary )
				draw.SimpleText( button2, "RCNPC_EntryTitle", Button2:GetWide()/2, 5, NC.Color.HeaderText, TEXT_ALIGN_CENTER )
			end
			Button2.DoClick = function()
				RequestInput:Remove()	
				button2fun()				
			end
		end
	end
end 