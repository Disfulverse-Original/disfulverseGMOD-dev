AddCSLuaFile()

hook.Add( "PreReloadToolsMenu", "HideTools", function()
	local ply = LocalPlayer()
	if not IsValid(ply) then print("not valid") return end

	--print(ply:GetUserGroup())

    if not ply:IsSuperAdmin() then
        for name, data in pairs(weapons.GetStored("gmod_tool").Tool) do
        	--print(data.Admin)
            if data.Admin then
                data.AddToMenu = false
            end
        end
    end

end )