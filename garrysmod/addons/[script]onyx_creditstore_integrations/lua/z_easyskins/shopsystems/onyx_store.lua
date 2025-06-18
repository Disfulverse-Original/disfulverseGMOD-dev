local customShopSystem = {}
customShopSystem.name = 'Onyx Store'

function customShopSystem.GetPoints(ply)
    if not IsValid(ply) or not ply:IsPlayer() then
        return 0
    end
    
    if not onyx or not onyx.creditstore then
        print("[ONYX_STORE] ERROR: Onyx framework not found")
        return 0
    end
    
    local credits = onyx.creditstore:GetCredits(ply)
    local isBusy = ply:onyx_GetNetVar and ply:onyx_GetNetVar('store_busy') or false

    if (isBusy) then
        return 0
    end

    return credits or 0
end

if SERVER then
    function customShopSystem.TakePoints(ply, amount)
        if not IsValid(ply) or not ply:IsPlayer() then
            print("[ONYX_STORE] ERROR: Invalid player for TakePoints")
            return false
        end
        
        if not amount or amount <= 0 then
            print("[ONYX_STORE] ERROR: Invalid amount for TakePoints")
            return false
        end
        
        if not onyx or not onyx.creditstore then
            print("[ONYX_STORE] ERROR: Onyx framework not found")
            return false
        end
        
        onyx.creditstore:TakeCredits(ply, amount)
        return true
    end

    function customShopSystem.GivePoints(ply, amount)
        if not IsValid(ply) or not ply:IsPlayer() then
            print("[ONYX_STORE] ERROR: Invalid player for GivePoints")
            return false
        end
        
        if not amount or amount <= 0 then
            print("[ONYX_STORE] ERROR: Invalid amount for GivePoints")
            return false
        end
        
        if not onyx or not onyx.creditstore then
            print("[ONYX_STORE] ERROR: Onyx framework not found")
            return false
        end
        
        onyx.creditstore:AddCredits(ply, amount)
        return true
    end
end

return customShopSystem