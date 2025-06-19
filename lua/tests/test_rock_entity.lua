-- lua/tests/test_rock_entity.lua
describe("Rock Entity", function()
    local rockEntity
    
    before_each(function()
        -- Mock essential GMod functions
        _G.ents = {
            Create = function(class) 
                return {
                    class = class,
                    SetModel = function() end,
                    SetPos = function() end,
                    Spawn = function() end,
                    GetPos = function() return Vector(0,0,0) end
                }
            end,
            FindInSphere = function() return {} end
        }
        
        -- Load your entity
        include("entities/bricks_server_rock/init.lua")
        rockEntity = ents.Create("bricks_server_rock")
    end)
    
    describe("Resource Selection", function()
        it("should select valid resources", function()
            local resource = rockEntity:SelectRandomResource()
            expect(resource).to_not.be_nil()
        end)
        
        it("should handle proximity checks", function()
            local hasNearby = rockEntity:HasNearbyPlayers(Vector(0,0,0), 100)
            expect(hasNearby).to.be_a("boolean")
        end)
    end)
    
    describe("Stage Transitions", function()
        it("should transition stages correctly", function()
            rockEntity:TransitionToStage(2)
            -- Assert stage change logic
        end)
    end)
end)
