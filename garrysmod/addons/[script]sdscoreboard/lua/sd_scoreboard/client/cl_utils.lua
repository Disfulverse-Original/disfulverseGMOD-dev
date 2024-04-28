---------------------
-- column function --
---------------------
function SD_SCOREBOARD_GMS.AddColumn(id, align, textAlign, size, func)
	SD_SCOREBOARD_GMS.Columns = SD_SCOREBOARD_GMS.Columns or {}

	local tbl = {id = id, align = align, textAlign = textAlign, size = size, text = func}
	table.insert(SD_SCOREBOARD_GMS.Columns, 1, tbl)
end
-------------------------------
-- boolean to admin settings --
-------------------------------
function SD_SCOREBOARD_GMS.AddBool(tabName, tabDesc, name, category, svName)
	SD_SCOREBOARD_GMS.Config.boolean = SD_SCOREBOARD_GMS.Config.boolean or {}
	table.insert(SD_SCOREBOARD_GMS.Config.boolean, 1, {tabName, tabDesc, name, category, svName})
end
---------------------------------------
-- Set/Get color scheme and language --
---------------------------------------
function SD_SCOREBOARD_GMS.SetColorScheme(index)
	local colTbl = SD_SCOREBOARD_GMS.ColorSchemes

	SD_SCOREBOARD_GMS.Colors = colTbl[index] or colTbl[2]
	SD_SCOREBOARD_GMS.ActiveColor = index

	RunConsoleCommand("sd_scoreboard_scheme", index)
	if IsValid(SD_SCOREBOARD_GMS.BasePanel) then 
		GAMEMODE:ScoreboardShow(true)
	end
end

function SD_SCOREBOARD_GMS.SetLanguage(index)
	local langTbl = SD_SCOREBOARD_GMS.Languages

	SD_SCOREBOARD_GMS.Language = SD_SCOREBOARD_GMS.Language or {}
	SD_SCOREBOARD_GMS.Language = langTbl[index] or langTbl[2]
	SD_SCOREBOARD_GMS.ActiveLanguage = index

	RunConsoleCommand("sd_scoreboard_language", index)
	if IsValid(SD_SCOREBOARD_GMS.BasePanel) then 
		GAMEMODE:ScoreboardShow(true)
	end
end

function SD_SCOREBOARD_GMS.GetColor(index)
	return SD_SCOREBOARD_GMS.Colors[index]
end

function SD_SCOREBOARD_GMS.GetString(str)
	return SD_SCOREBOARD_GMS.Language[str] or str
end
--------------------------
-- Get Data from server --
--------------------------
SD_SCOREBOARD_GMS.ServerConfig = SD_SCOREBOARD_GMS.ServerConfig or {hostName = "", sortBy = "", categoriesBy = "", boolean = {}, groups = {}, commands = {}, links = {}, hide = {}}

net.Receive("sd_scoreboard_sdtc", function()
	local index = net.ReadString()
	local data = SD_SCOREBOARD_GMS.ServerConfig[index]

	if istable(data) then
		SD_SCOREBOARD_GMS.ServerConfig[index] = net.ReadTable()
	elseif isstring(data) then
		SD_SCOREBOARD_GMS.ServerConfig[index] = net.ReadString()
	end

	if IsValid(SD_SCOREBOARD_GMS.BasePanel) then
		GAMEMODE:ScoreboardShow(true)
	end
end)

local function GetData()
	net.Start("sd_scoreboard_rdtp")
	net.SendToServer()
end

hook.Add("InitPostEntity", "sd_scoreboard_config_call", function()
	GetData()
end)
-----------------
-- panel focus --
-----------------
function SD_SCOREBOARD_GMS.PanelFocus()
	SD_SCOREBOARD_GMS.BasePanel:SetKeyboardInputEnabled(true)
	if IsValid(SD_SCOREBOARD_GMS.BasePanel) and !SD_SCOREBOARD_GMS.Focus then
		SD_SCOREBOARD_GMS.AllowHide = false
		SD_SCOREBOARD_GMS.Focus = true
	end
end
----------------
-- Chat Print --
----------------
net.Receive("sd_scoreboard_cp", function()
	local tbl = net.ReadTable()
	local strTbl = string.Explode("#arg", SD_SCOREBOARD_GMS.GetString(tbl[1]))
	local cache = {}

	for k, v in ipairs(strTbl) do
		table.insert(cache, SD_SCOREBOARD_GMS.GetColor("firstChat"))
		table.insert(cache, v)

		if not tbl[k+1] then continue end

		table.insert(cache, SD_SCOREBOARD_GMS.GetColor("secondChat"))
		table.insert(cache, tostring(tbl[k+1]))
	end

	chat.AddText(unpack(cache))
end)

----------------------------
-- HEX 2 RGB -- RGB 2 HEX --
----------------------------
function SD_SCOREBOARD_GMS.hex2rgb(hex)
    return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
end

function SD_SCOREBOARD_GMS.rgb2Hex(rgb)
	return table.concat({bit.tohex(rgb["r"], 2),bit.tohex(rgb["g"], 2),bit.tohex(rgb["b"], 2)})
end
-------------------------
-- Get Player PlayTime --
-------------------------
function SD_SCOREBOARD_GMS.GetTime(time)
	local timeTable = {}

	local weeks = math.floor(time/(86400 * 7))
	if(weeks>0) then table.insert(timeTable, weeks.."w ") time = time - weeks * (86400 * 7) end

	local days = math.floor(time/86400)
	if(days>0) then table.insert(timeTable, days.."d ") time = time - days * 86400 end

	local hours = math.floor(time/3600)
	if(hours>0) then table.insert(timeTable, hours.."h ") time = time - hours * 3600 end

	local minutes = math.floor(time/60)
	if(minutes>0) then table.insert(timeTable, minutes.."m ") time = time - minutes * 60 end

	local seconds = math.floor(time)
	table.insert(timeTable, seconds.."s")

	return table.concat(timeTable, "")
end
-----------------------
-- Buttons animation --
-----------------------
function SD_SCOREBOARD_GMS.ButtonAnim(panel)
	panel.anim = {pos = 0, start = 0, stop = 0, STime = 0}
	panel.Think = function()
		if panel:IsDown() then
			if panel.anim.stop == 150 then
				panel.anim = {pos = 0, start = 150, stop = 255, STime = SysTime()} 
			end
		elseif panel:IsHovered() then 
			if panel.anim.stop == 0 then 
				panel.anim = {pos = 0, start = 0, stop = 150, STime = SysTime()} 
			end
		else
			if panel.anim.stop >= 150 then 
				panel.anim = {pos = 0, start = 150, stop = 0, STime = SysTime()} 
			end
		end
		panel.anim.pos = Lerp((SysTime() - panel.anim.STime)*4, panel.anim.start, panel.anim.stop)
	end
end
------------
-- Easing --
------------
function SD_SCOREBOARD_GMS.Easing(x)
	return x < 0.5 and 4 * x * x * x or 1 - math.pow(-2 * x + 2, 3) / 2
end
------------
-- Shadow --
------------
function SD_SCOREBOARD_GMS.Shadow(targetPanel, distance, noClip, iteration)
	local distance = distance*2 or 15
	local iteration = iteration or 5

	local color = Color(0,0,0)

	local panel = vgui.Create("DPanel", targetPanel:GetParent())
	panel.Think = function(this)
		if not IsValid(targetPanel) then this:Remove() return end
		local PosX,PosY = targetPanel:GetPos()

		panel:SetPos(PosX-(distance/2),PosY-(distance/2))
		panel:SetSize(targetPanel:GetWide()+distance,targetPanel:GetTall()+distance)
	end

	panel.Paint = function(this, w, h)
		if targetPanel:GetTall() == 0 then return end
		for i = 0, iteration do
			draw.RoundedBox(5,i*(distance/iteration)/2,i*(distance/iteration)/2,w-(distance/iteration)*i,h-(distance/iteration)*i,ColorAlpha(color, i*SD_SCOREBOARD_GMS.Colors.ShadowMultiplier))
		end
	end

	if noClip then panel:NoClipping(true) end
	panel:SetZPos(targetPanel:GetZPos()-1)
end
----------
-- Blur --	
----------
function SD_SCOREBOARD_GMS.Blur(w, h, panel)
	local blurMat = SD_SCOREBOARD_GMS.Colors.icons.blur
	local x, y = panel:LocalToScreen(0, 0)

	surface.SetMaterial(blurMat)

	for i = 0.1, 1, 0.1 do
		blurMat:Recompute()
		blurMat:SetFloat("$blur", i)
		
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(x *-1, y *-1, ScrW()+1, ScrH()+1)
	end
return end
------------
-- Circle --
------------
function SD_SCOREBOARD_GMS.Circle(x, y, radius, seg, color)
	local cir = {}

	for i = 0, seg do
		local t = math.rad((i/seg) * -360)
		table.insert(cir, {x = (math.sin(t)*radius)+x, y = (math.cos(t)*radius)+y})
	end

	surface.SetDrawColor(color)
	draw.NoTexture()
	surface.DrawPoly(cir)
end
-----------
-- hooks -- 
-----------
if DarkRP then -- If DarkRP then remove DarkRP hooks
	hook.Remove("ScoreboardShow","FAdmin_scoreboard")
	hook.Remove("ScoreboardHide","FAdmin_scoreboard")
end

function GAMEMODE:ScoreboardShow(skipAnimation)
	if IsValid(SD_SCOREBOARD_GMS.BasePanel) and SD_SCOREBOARD_GMS.Focus and not skipAnimation then return end
	if IsValid(SD_SCOREBOARD_GMS.BasePanel) then SD_SCOREBOARD_GMS.BasePanel:Remove() end

	SD_SCOREBOARD_GMS.BasePanel = vgui.Create("sd_scoreboard")
	if (!skipAnimation and SD_SCOREBOARD_GMS.fullScreen == 0 and !SD_SCOREBOARD_GMS.Focus) then 
		SD_SCOREBOARD_GMS.BasePanel:Animation("open")
	end
end

function GAMEMODE:ScoreboardHide(skipAnimation)
	if !SD_SCOREBOARD_GMS.AllowHide then 
		SD_SCOREBOARD_GMS.AllowHide = true
	return end

	if (IsValid(SD_SCOREBOARD_GMS.BasePanel) and !skipAnimation and SD_SCOREBOARD_GMS.fullScreen == 0) then 
		SD_SCOREBOARD_GMS.BasePanel:Animation("close")
	elseif IsValid(SD_SCOREBOARD_GMS.BasePanel) then
		SD_SCOREBOARD_GMS.BasePanel:Remove()
	end

	SD_SCOREBOARD_GMS.Focus = false
end