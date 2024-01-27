--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

PROJECT0.TEMP.AdminConfig = PROJECT0.TEMP.AdminConfig or {}
PROJECT0.TEMP.AdminConfig.Viewmodels = PROJECT0.TEMP.AdminConfig.Viewmodels or {}

hook.Add( "HUDPaint", "Project0.HUDPaint.ViewmodelMode", function()
    if( not PROJECT0.TEMP.ViewmodelMode ) then return end

    local barSize = PROJECT0.FUNC.ScreenScale( 5 )
    local margin = PROJECT0.FUNC.ScreenScale( 100 )

    surface.SetFont( "MontserratBold25" )
    local textX = surface.GetTextSize( "VIEWMODEL EDITOR" )

    local bottomW = (ScrW()-2*margin-textX-PROJECT0.FUNC.ScreenScale( 10 ))/2
    
    surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4 ) )

    PROJECT0.FUNC.BeginShadow( "viewmodel_mode_hud" )
    surface.DrawRect( margin, margin, ScrW()-2*margin, barSize )
    surface.DrawRect( margin, margin, barSize, ScrH()-2*margin )
    surface.DrawRect( ScrW()-margin-barSize, margin, barSize, ScrH()-2*margin )
    surface.DrawRect( margin, ScrH()-margin-barSize, bottomW, barSize )
    surface.DrawRect( ScrW()-margin-bottomW, ScrH()-margin-barSize, bottomW, barSize )
    draw.SimpleText( "VIEWMODEL EDITOR", "MontserratBold25", ScrW()/2, ScrH()-margin-barSize/2, PROJECT0.FUNC.GetTheme( 4 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    PROJECT0.FUNC.EndShadow( "viewmodel_mode_hud", 0, 0, 2, 1, 1, 255, 0, 0, false )

    return false
end )

local hide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudAmmo"] = true
}

hook.Add( "HUDShouldDraw", "Project0.HUDShouldDraw.ViewmodelModeHide", function( name )
    if( not hide[name] or not PROJECT0.TEMP.ViewmodelMode ) then return end
    return false
end )

net.Receive( "Project0.SendViewmodelMode", function()
    PROJECT0.TEMP.ViewmodelMode = net.ReadBool()

    if( not PROJECT0.TEMP.ViewmodelMode ) then
        PROJECT0.TEMP.ViewmodelWeapon = nil
    end

    hook.Run( "Project0.Hooks.AdminViewmodelChange" )
end )

net.Receive( "Project0.SendViewmodelWeapon", function()
    PROJECT0.TEMP.ViewmodelWeapon = net.ReadString()

    timer.Simple( 0.5, function() hook.Run( "Project0.Hooks.AdminViewmodelChange" ) end )
end )

local function updateViewModelSkin( viewmodel, weaponCfg )
    local activeWeapon  = LocalPlayer():GetActiveWeapon()
    local viewmodel = IsValid( activeWeapon.m_ViewModel ) and activeWeapon.m_ViewModel or viewmodel
    
    for i = 0, #viewmodel:GetMaterials()-1 do
        viewmodel:SetSubMaterial( i )
    end

    if( activeWeapon.Customization ) then
        for k, v in pairs( activeWeapon.Customization ) do
            if( not IsValid( v.m_Model ) ) then continue end
            for i = 0, #v.m_Model:GetMaterials()-1 do
                v.m_Model:SetSubMaterial( i )
            end
        end
    end

    if( not weaponCfg ) then return end

    for k, v in ipairs( weaponCfg.Skin.ViewModelMats ) do
        if( isstring( v ) ) then
            if( not (activeWeapon.Customization or {})[v] or not IsValid( activeWeapon.Customization[v].m_Model ) ) then continue end

            local modelEnt = activeWeapon.Customization[v].m_Model
            for i = 0, #modelEnt:GetMaterials()-1 do
                modelEnt:SetSubMaterial( i, "skins/gold" )
            end

            continue
        end

        viewmodel:SetSubMaterial( v, "skins/gold" )
    end
end

hook.Add( "Project0.Hooks.AdminViewmodelUpdate", "Project0.Project0.Hooks.AdminViewmodelUpdate.ViewmodelMode", function()
    local viewmodel = LocalPlayer():GetViewModel()
    local weaponCfg = PROJECT0.TEMP.AdminConfig.Viewmodels[PROJECT0.TEMP.ViewmodelWeapon or ""]
    if( not PROJECT0.TEMP.ViewmodelMode or not weaponCfg or not IsValid( viewmodel ) ) then
        return
    end

    -- Skin
    updateViewModelSkin( viewmodel, weaponCfg )
end )

hook.Add( "Project0.Hooks.AdminViewmodelChange", "Project0.Project0.Hooks.AdminViewmodelChange.ViewmodelMode", function()
    local viewmodel = LocalPlayer():GetViewModel()

    if( IsValid( PROJECT0.TEMP.WeaponTrinketBase ) ) then
        PROJECT0.TEMP.WeaponTrinketBase.Trinket:Remove()
        PROJECT0.TEMP.WeaponTrinketBase:Remove()
    end

    if( IsValid( viewmodel ) ) then
        updateViewModelSkin( viewmodel )
    end

    local weaponCfg = PROJECT0.TEMP.AdminConfig.Viewmodels[PROJECT0.TEMP.ViewmodelWeapon or ""]
    if( not PROJECT0.TEMP.ViewmodelMode or not weaponCfg or not IsValid( viewmodel ) ) then
        return
    end

    if( not IsValid( PROJECT0.TEMP.WeaponTrinketBase ) ) then
        local trinketBase = ClientsideModel( "models/sterling/smodel_c_tinket.mdl" )
        trinketBase:SetParent( viewmodel )
        trinketBase:SetNoDraw( true )

        trinketBase.Trinket = ClientsideModel( "models/sterling/smodel_slicedcheese.mdl" )
        trinketBase.Trinket:SetParent( trinketBase )
        trinketBase.Trinket:SetNoDraw( true )
        trinketBase.Trinket:SetModelScale( 0.25 )

        PROJECT0.TEMP.WeaponTrinketBase = trinketBase
    end

    -- Skin
    updateViewModelSkin( viewmodel, weaponCfg )
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

hook.Add( "PreDrawViewModel", "Project0.PreDrawViewModel.ViewmodelMode", function( viewmodel, ply, weapon )
    if( not PROJECT0.TEMP.ViewmodelMode ) then return end
    local trinketBase = PROJECT0.TEMP.WeaponTrinketBase

    local weaponCfg = PROJECT0.TEMP.AdminConfig.Viewmodels[PROJECT0.TEMP.ViewmodelWeapon or ""]
    if( not weaponCfg or weaponCfg.Charm.Disabled ) then 
        if( IsValid( trinketBase ) ) then trinketBase:Remove() end
        return
    end

    if( not IsValid( trinketBase ) ) then 
        hook.Run( "Project0.Hooks.AdminViewmodelChange" )
        return
    end

    -- Trinket Base
    local attachment = viewmodel:GetAttachment( weaponCfg.Charm.ViewModelAttachment or 1 ) or {
        Ang = viewmodel:GetAngles(),
        Pos = viewmodel:GetPos()
    }

    trinketBase:DrawModel()

    local angleOffset = weaponCfg.Charm.ViewModelAngle
    local angles = attachment.Ang 
    angles:RotateAroundAxis( angles:Forward(), angleOffset[1] )
    angles:RotateAroundAxis( angles:Right(), angleOffset[2] )
    angles:RotateAroundAxis( angles:Up(), angleOffset[3] )
    trinketBase:SetAngles( angles )

    local posOffset = weaponCfg.Charm.ViewModelPos
    trinketBase:SetPos( FormatViewModelAttachment(attachment.Pos)+(angles:Forward()*posOffset[1])+(angles:Right()*posOffset[2])+(angles:Up()*posOffset[3]) )

    -- Trinket
    trinketBase.Trinket:DrawModel()

    local trinketAttachment = trinketBase:GetAttachment( 2 )
    if( not trinketAttachment ) then return end

    trinketBase.Trinket:SetPos( trinketAttachment.Pos )
end )

hook.Add( "PostDrawViewModel", "Project0.PostDrawViewModel.ViewmodelMode", function( viewmodel, ply, weapon )
    if( not PROJECT0.TEMP.ViewmodelMode ) then return end
    
    local weaponCfg = PROJECT0.TEMP.AdminConfig.Viewmodels[PROJECT0.TEMP.ViewmodelWeapon or ""]
    if( not IsValid( weapon ) or not IsValid( viewmodel ) or not weaponCfg or weaponCfg.Sticker.Disabled ) then
        return
    end

    -- Sticker
    local attachment = viewmodel:GetAttachment( weaponCfg.Sticker.ViewModelAttachment or 1 ) or {
        Ang = viewmodel:GetAngles(),
        Pos = viewmodel:GetPos()
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
        surface.SetDrawColor( 255, 0, 0 )
        surface.DrawRect( 0, 0, stickerSize, stickerSize )

        surface.SetDrawColor( 255, 255, 255 )
        surface.DrawOutlinedRect( 0, 0, stickerSize, stickerSize )
        surface.DrawOutlinedRect( 1, 1, stickerSize-2, stickerSize-2 )

        draw.SimpleText( "R", "DermaDefault", stickerSize/2, stickerSize/2, PROJECT0.FUNC.GetTheme( 3 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    cam.End3D2D()
end )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
