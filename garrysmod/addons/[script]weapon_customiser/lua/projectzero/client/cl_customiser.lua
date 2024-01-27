--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

function PROJECT0.FUNC.OpenCustomiserMenu()
    hook.Run( "Project0.Hooks.CustomiserMenuOpen" )
    
    if( IsValid( PROJECT0.TEMP.WeaponCustomiser ) ) then
        PROJECT0.TEMP.WeaponCustomiser:SetVisible( true )
        return
    end

    PROJECT0.TEMP.WeaponCustomiser = vgui.Create( "pz_weaponcustomiser_menu" )
end

concommand.Add( "pz_weaponcustomiser", PROJECT0.FUNC.OpenCustomiserMenu )
net.Receive( "Project0.SendOpenCustomiserMenu", PROJECT0.FUNC.OpenCustomiserMenu )

local commands = {
    ["!skins"] = true,
    ["/skins"] = true,
    ["!cosmetics"] = true,
    ["/cosmetics"] = true,
    ["!weaponcustomiser"] = true,
    ["/weaponcustomiser"] = true
}

hook.Add( "OnPlayerChat", "Project0.OnPlayerChat.OpenMenu", function( ply, strText, bTeam, bDead ) 
    if( ply != LocalPlayer() ) then return end

	strText = string.lower( strText )
	if( not commands[strText] ) then return end

    PROJECT0.FUNC.OpenCustomiserMenu()
    return true
end )

local function FormatViewModelAttachment(vOrigin)
	local vEyePos = EyePos()
	local aEyesRot = EyeAngles()
	local vOffset = vOrigin - vEyePos
	local vForward = aEyesRot:Forward()

	local nViewX = math.tan(render.GetViewSetup().fovviewmodel_unscaled * math.pi / 360)

	if (nViewX == 0) then
		vForward:Mul(vForward:Dot(vOffset))
		vEyePos:Add(vForward)
		
		return vEyePos
	end

	local nWorldX = math.tan(LocalPlayer():GetFOV() * math.pi / 360)

	if (nWorldX == 0) then
		vForward:Mul(vForward:Dot(vOffset))
		vEyePos:Add(vForward)
		
		return vEyePos
	end

	local vRight = aEyesRot:Right()
	local vUp = aEyesRot:Up()

    local nFactor = nViewX / nWorldX
    vRight:Mul(vRight:Dot(vOffset) * nFactor)
    vUp:Mul(vUp:Dot(vOffset) * nFactor)

	vForward:Mul(vForward:Dot(vOffset))

	vEyePos:Add(vRight)
	vEyePos:Add(vUp)
	vEyePos:Add(vForward)

	return vEyePos
end

local function updateViewmodelWeapon( viewmodel, weapon, weaponClass, isDelayed )
    local viewmodel = IsValid( weapon.m_ViewModel ) and weapon.m_ViewModel or viewmodel

    local oldWeaponClass = PROJECT0.TEMP.ViewmodelActiveWeapon
    PROJECT0.TEMP.ViewmodelActiveWeapon = weaponClass

    if( string.StartWith( weaponClass, "tfa" ) and not isDelayed and (PROJECT0.TEMP.ViewmodelActiveWeapon or "") == weaponClass ) then
        timer.Simple( 0.1, function()
            updateViewmodelWeapon( viewmodel, weapon, weaponClass, true )
        end )

        return
    end

    local oldWeaponCfg = PROJECT0.FUNC.GetConfiguredWeapon( oldWeaponClass or "" )
    if( oldWeaponCfg ) then
        for k, v in ipairs( oldWeaponCfg.Skin.ViewModelMats ) do
            if( isstring( v ) ) then
                if( not (weapon.Customization or {})[v] or not IsValid( weapon.Customization[v].m_Model ) ) then continue end

                local modelEnt = weapon.Customization[v].m_Model
                for i = 0, #modelEnt:GetMaterials()-1 do
                    modelEnt:SetSubMaterial( i )
                end
    
                continue
            end

            viewmodel:SetSubMaterial( v )
        end
    end

    local weaponCfg = PROJECT0.FUNC.GetConfiguredWeapon( weaponClass or "" )
    if( not weaponCfg or not IsValid( viewmodel ) ) then return end

    local playerMeta = LocalPlayer():Project0()
    
    local equippedSkin = playerMeta:GetEquippedCosmetic( "Skin", weaponClass )
    if( equippedSkin != 0 ) then
        local skinMat = PROJECT0.DEVCONFIG.WeaponSkins[equippedSkin].Material
        for k, v in ipairs( weaponCfg.Skin.ViewModelMats ) do
            if( isstring( v ) ) then
                if( not (weapon.Customization or {})[v] or not IsValid( weapon.Customization[v].m_Model ) ) then continue end

                local modelEnt = weapon.Customization[v].m_Model
                for i = 0, #modelEnt:GetMaterials()-1 do
                    modelEnt:SetSubMaterial( i, skinMat )
                end
    
                continue
            end
    
            viewmodel:SetSubMaterial( v, skinMat )
        end
    end
end

hook.Add( "Project0.Hooks.CustomisedWeaponsUpdated", "Project0.Project0.Hooks.CustomisedWeaponsUpdated.ClientUpdate", function()
    PROJECT0.TEMP.ViewmodelActiveWeapon = nil
end )

hook.Add( "TFA_Attachment_Attached", "Project0.TFA_Attachment_Attached.ClientUpdate", function()
    PROJECT0.TEMP.ViewmodelActiveWeapon = nil
end )

hook.Add( "TFA_Attachment_Detached", "Project0.TFA_Attachment_Detached.ClientUpdate", function()
    PROJECT0.TEMP.ViewmodelActiveWeapon = nil
end )

hook.Add( "PreDrawViewModel", "Project0.PreDrawViewModel.WeaponCosmetics", function( viewmodel, ply, weapon )
    if( PROJECT0.TEMP.ViewmodelMode ) then return end

    local weaponClass = weapon:GetClass()
    if( (PROJECT0.TEMP.ViewmodelActiveWeapon or "") != weaponClass ) then
        updateViewmodelWeapon( viewmodel, weapon, weaponClass )
    end

    local weaponCfg = PROJECT0.FUNC.GetConfiguredWeapon( weaponClass )
    if( not IsValid( viewmodel ) or not weaponCfg ) then
        if( IsValid( PROJECT0.TEMP.WeaponTrinketBase ) ) then
            PROJECT0.TEMP.WeaponTrinketBase.Trinket:Remove()
            PROJECT0.TEMP.WeaponTrinketBase:Remove()
        end

        return
    end

    local playerMeta = LocalPlayer():Project0()

    -- Trinket
    local equippedCharm = playerMeta:GetEquippedCosmetic( "Charm", weaponClass )
    local charmConfig = PROJECT0.CONFIG.CUSTOMISER.Charms[equippedCharm]
    if( not weaponCfg.Charm.Disabled and equippedCharm != 0 and charmConfig ) then
        if( not IsValid( PROJECT0.TEMP.WeaponTrinketBase ) ) then
            local trinketBase = ClientsideModel( "models/sterling/smodel_c_tinket.mdl" )
            trinketBase:SetParent( viewmodel )
            trinketBase:SetNoDraw( true )
    
            trinketBase.Trinket = ClientsideModel( charmConfig.Model )
            trinketBase.Trinket:SetParent( trinketBase )
            trinketBase.Trinket:SetNoDraw( true )
            trinketBase.Trinket:SetModelScale( 0.25 )
    
            PROJECT0.TEMP.WeaponTrinketBase = trinketBase
        end

        local attachment = viewmodel:GetAttachment( weaponCfg.Charm.ViewModelAttachment or 1 ) or {
            Pos = viewmodel:GetPos(),
            Ang = viewmodel:GetAngles(),
        }

        PROJECT0.TEMP.WeaponTrinketBase:DrawModel()

        local angleOffset = weaponCfg.Charm.ViewModelAngle
        local angles = attachment.Ang
        angles:RotateAroundAxis( angles:Forward(), angleOffset[1] )
        angles:RotateAroundAxis( angles:Right(), angleOffset[2] )
        angles:RotateAroundAxis( angles:Up(), angleOffset[3] )
        PROJECT0.TEMP.WeaponTrinketBase:SetAngles( angles )

        local posOffset = weaponCfg.Charm.ViewModelPos
        PROJECT0.TEMP.WeaponTrinketBase:SetPos( FormatViewModelAttachment(attachment.Pos)+(angles:Forward()*posOffset[1])+(angles:Right()*posOffset[2])+(angles:Up()*posOffset[3]) )

        -- Trinket Model
        local attachment = PROJECT0.TEMP.WeaponTrinketBase:GetAttachment( 2 )
        if( not attachment ) then return end

        local trinket = PROJECT0.TEMP.WeaponTrinketBase.Trinket

        if( trinket:GetModel() != charmConfig.Model ) then
            trinket:SetModel( charmConfig.Model )
        end

        trinket:DrawModel()
        trinket:SetPos( attachment.Pos )

        local trinketAngles = attachment.Ang
        trinketAngles:RotateAroundAxis( trinketAngles:Forward(), 0 )
        trinketAngles:RotateAroundAxis( trinketAngles:Right(), -90 )
        trinketAngles:RotateAroundAxis( trinketAngles:Up(), 90 )

        trinket:SetAngles( trinketAngles )
    elseif( IsValid( PROJECT0.TEMP.WeaponTrinketBase ) ) then
        PROJECT0.TEMP.WeaponTrinketBase.Trinket:Remove()
        PROJECT0.TEMP.WeaponTrinketBase:Remove()
    end
end )

local stickerMat, currentSticker, calledGetImage
hook.Add( "PostDrawViewModel", "Project0.PostDrawViewModel.WeaponCosmetics", function( viewmodel, ply, weapon )
    if( PROJECT0.TEMP.ViewmodelMode ) then return end
    
    local weaponClass = weapon:GetClass()
    local weaponCfg = PROJECT0.FUNC.GetConfiguredWeapon( weaponClass )
    if( not IsValid( weapon ) or not IsValid( viewmodel ) or not weaponCfg or weaponCfg.Sticker.Disabled ) then
        return
    end

    -- Sticker
    local equippedSticker = LocalPlayer():Project0():GetEquippedCosmetic( "Sticker", weaponClass )
    local stickerConfig = PROJECT0.CONFIG.CUSTOMISER.Stickers[equippedSticker]
    if( stickerConfig ) then
        if( not calledGetImage and (not stickerMat or equippedSticker != currentSticker) ) then
            calledGetImage = true
            currentSticker = equippedSticker
            PROJECT0.FUNC.GetImage( stickerConfig.Icon, function( mat )
                stickerMat = mat
                calledGetImage = false
            end )
        end

        if( stickerMat ) then
            local attachment = viewmodel:GetAttachment( weaponCfg.Sticker.ViewModelAttachment or 1 ) or {
                Pos = viewmodel:GetPos(),
                Ang = viewmodel:GetAngles(),
            }

            local pos = FormatViewModelAttachment( attachment.Pos )
            local ang = attachment.Ang
    
            local angleOffset = weaponCfg.Sticker.ViewModelAngle
            ang:RotateAroundAxis(ang:Up(), angleOffset[1])
            ang:RotateAroundAxis(ang:Forward(), angleOffset[2])
            ang:RotateAroundAxis(ang:Right(), angleOffset[3])

            local stickerSize = 20
            local posOffset = weaponCfg.Sticker.ViewModelPos
            cam.Start3D2D( pos+(ang:Forward()*posOffset[1])+(ang:Right()*posOffset[2])+(ang:Up()*posOffset[3]), ang, 0.05 )
                surface.SetDrawColor( 255, 255, 255 )
                surface.SetMaterial( stickerMat )
                surface.DrawTexturedRect( 0, 0, stickerSize, stickerSize)
            cam.End3D2D()
        end
    end
end )

-- 3rd person skins
local function updatePlyWeaponSkin( ply )
    local activeWeapon = ply:GetActiveWeapon()
    if( not IsValid( activeWeapon ) ) then return end

    local weaponClass = activeWeapon:GetClass()
    local equippedSkin = ((PROJECT0.TEMP.RequestedWeapons or {})[ply] or {})[weaponClass]
    if( not equippedSkin ) then return end

    local weaponCfg = PROJECT0.FUNC.GetConfiguredWeapon( weaponClass )
    for k, v in ipairs( PROJECT0.FUNC.GetModelMaterials( weaponCfg.Model ) ) do
        activeWeapon:SetSubMaterial( k )
    end

    local skinMaterial = PROJECT0.DEVCONFIG.WeaponSkins[equippedSkin].Material
    for k, v in ipairs( weaponCfg.Skin.WorldModelMats ) do
        activeWeapon:SetSubMaterial( v, skinMaterial )
    end
end

net.Receive( "Project0.SendPlayerSkin", function()
    local requestVictim = net.ReadEntity()
    if( not IsValid( requestVictim ) ) then return end

    PROJECT0.TEMP.RequestedWeapons = PROJECT0.TEMP.RequestedWeapons or {}
    PROJECT0.TEMP.RequestedWeapons[requestVictim] = PROJECT0.TEMP.RequestedWeapons[requestVictim] or {}
    PROJECT0.TEMP.RequestedWeapons[requestVictim][net.ReadString()] = net.ReadUInt( 8 )

    local activeWeapon = requestVictim:GetActiveWeapon()
    if( IsValid( activeWeapon ) ) then
        PROJECT0.TEMP.RequestedWeapons[requestVictim].ActiveWeapon = activeWeapon:GetClass()
    end

    updatePlyWeaponSkin( requestVictim )
end )

hook.Add( "PostPlayerDraw", "Project0.PostPlayerDraw.WeaponCosmetics", function( ply )
    local activeWeapon = ply:GetActiveWeapon()
    if( not IsValid( activeWeapon ) ) then return end

    -- if( not IsValid( (PROJECT0.TEMP.WeaponTrinketModels or {})[ply] ) ) then
    --     local trinketBase = ClientsideModel( "models/sterling/smodel_w_tinket.mdl", RENDERGROUP_OTHER )
    --     trinketBase:SetIK( false )

    --     PROJECT0.TEMP.WeaponTrinketModels = PROJECT0.TEMP.WeaponTrinketModels or {}
    --     PROJECT0.TEMP.WeaponTrinketModels[ply] = trinketBase
    -- else
    --     local weaponCfg = PROJECT0.FUNC.GetConfiguredWeapon( activeWeapon:GetClass() )

    --     local worldPos = weaponCfg.Charm.WorldModelPos
    --     PROJECT0.TEMP.WeaponTrinketModels[ply]:SetAngles( activeWeapon:GetAngles()+weaponCfg.Charm.WorldModelAngle )
    --     PROJECT0.TEMP.WeaponTrinketModels[ply]:SetPos( activeWeapon:GetPos()+(activeWeapon:GetForward()*worldPos[1])+(activeWeapon:GetRight()*worldPos[2])+(activeWeapon:GetUp()*worldPos[3]) )
    -- end

    local weaponClass = activeWeapon:GetClass()
    if( ((PROJECT0.TEMP.RequestedWeapons or {})[ply] or {}).ActiveWeapon != weaponClass ) then
        updatePlyWeaponSkin( ply )
    end

    if( CurTime() < (PROJECT0.TEMP.LastWeaponSkinRequest or 0)+PROJECT0.CONFIG.CUSTOMISER.SkinNetworkDelay ) then return end
    --if( ((PROJECT0.TEMP.RequestedWeapons or {})[ply] or {})[weaponClass] and CurTime() < (PROJECT0.TEMP.LastWeaponSkinRequest or 0)+5 ) then return end

    PROJECT0.TEMP.LastWeaponSkinRequest = CurTime()

    net.Start( "Project0.RequestPlayerSkin" )
        net.WriteEntity( ply )
    net.SendToServer()
end )

-- concommand.Add( "test_model2d", function()
--     if( IsValid( TEST_PANEL ) ) then
--         TEST_PANEL:Remove()
--     end

--     TEST_PANEL = vgui.Create( "DFrame" )
--     TEST_PANEL:SetSize( 1500, 1500 )
--     TEST_PANEL:Center()
--     TEST_PANEL:MakePopup()

--     local model = vgui.Create("DModelPanel", TEST_PANEL)
--     model:SetPos(20,20)
--     model:SetSize(1500,1500)
--     model:SetModel(LocalPlayer():GetModel())
--     model:SetFOV( 120 )
--     function model:LayoutEntity( Entity ) return end
--     model.PostDrawModel = function(self2, ent)
--         local pos = ent:GetPos()
--         local x, y = self2:LocalToScreen()

--         local angle = Angle(180, 0, 0)


--         print(y*angle:Forward())
--         local screenVector = Vector( x*angle:Forward(), y*angle:Forward(), 0 )

--         cam.Start3D2D( Vector( screenVector[1]+pos[1], screenVector[2]+pos[2], pos[3] ), angle, 1 )
--             surface.SetDrawColor(255, 0, 0)
--             surface.DrawRect(0, 0, 2500, 2500)
--         cam.End3D2D()
--     end
--     model.OnMouseWheeled = function( self2, delta )
--         self2:SetFOV( math.Clamp( self2:GetFOV()-(delta*5), 10, 1000 ) )
--     end
-- end )

-- concommand.Add( "test_model2d", function()
--     if( IsValid( TEST_PANEL ) ) then
--         TEST_PANEL:Remove()
--     end

--     TEST_PANEL = vgui.Create( "DFrame" )
--     TEST_PANEL:SetSize( 1000, 1000 )
--     TEST_PANEL:SetPos( 0, 0 )
--     TEST_PANEL:MakePopup()

--     local model = vgui.Create("pz_test_dmodelpanel", TEST_PANEL)
--     model:SetPos(20,20)
--     model:SetSize(1000,1000)
--     model:SetModel(LocalPlayer():GetModel())
--     model:SetFOV( 120 )
--     function model:LayoutEntity( Entity ) return end
--     model.OnMouseWheeled = function( self2, delta )
--         self2:SetFOV( math.Clamp( self2:GetFOV()-(delta*5), 10, 1000 ) )
--     end
-- end )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
