AddCSLuaFile()

print("cl_notify")

hook.Add( "HUDAmmoPickedUp", "AmmoPickedUp", function( itemName, amount )
    return false -- removed this for a moment
end )