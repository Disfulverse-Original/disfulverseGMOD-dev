local ITEM = BOTCHED.FUNC.CreateItemType( "entity" )

ITEM:SetTitle( "Entity" )
ITEM:SetDescription( "Gives the player an entity." )

ITEM:AddReqInfo( BOTCHED.TYPE.String, "Class", "The entity class to give." )
ITEM:AddReqInfo( BOTCHED.TYPE.Int, "Amount", "The amount of entity to give to the player." )
ITEM:SetAllowInstantUse( true )
ITEM:SetUseFunction( function( ply, useAmount, itemEntity, amount ) 
    for i = 1, useAmount do
	    local ent = ents.Create( itemEntity )
	    if( not IsValid( ent ) ) then return end
	    ent:SetPos( ply:GetPos()+( ply:GetForward()*30 )+Vector( 0, 0, 20 ) )
	    ent:Spawn()
	    ent:SetAmount(amount)

	    --print(amount)
        --print(itemEntity)
        --print(ply:GetName())
    end
    DarkRP.notify(ply, 0, 5, "Награда была выдана!")
end )

ITEM:Register()