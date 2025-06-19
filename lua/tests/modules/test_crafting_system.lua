-- Test proximity checks
describe("Player Proximity", function()
    it("should detect nearby players", function()
        local mockPlayer = createMockPlayer("STEAM_123", Vector(50, 0, 0))
        _G.player = {GetAll = function() return {mockPlayer} end}
        
        local hasNearby = rockEntity:HasNearbyPlayers(Vector(0,0,0), 100)
        expect(hasNearby).to.be_true()
    end)
end)

-- Test resource dropping
describe("Resource Dropping", function()
    it("should handle inventory fallback", function()
        local mockPlayer = createMockPlayer()
        local resourceData = {name = "stone", amount = 5}
        
        -- Mock failed entity spawn
        _G.ents.Create = function() return nil end
        
        rockEntity:SpawnResourceEntity(mockPlayer, resourceData, "stone")
        -- Should fallback to inventory
    end)
end)
