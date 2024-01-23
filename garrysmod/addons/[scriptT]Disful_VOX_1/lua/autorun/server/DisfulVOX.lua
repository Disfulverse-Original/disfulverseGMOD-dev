--MADE BY DISFULVERSE

DisfulSounds = DisfulSounds or {}

local sounds = {}


if SERVER then

resource.AddFile( "sound/cough.mp3" )
resource.AddFile( "sound/reload2.wav" )
resource.AddFile( "sound/reload1.wav" )
resource.AddFile( "sound/jam.wav" )
resource.AddFile( "sound/move.wav" )
resource.AddFile( "sound/move2.wav" )
resource.AddFile( "sound/hit.wav" )
resource.AddFile( "sound/locked.wav" )
resource.AddFile( "sound/help.wav" )
resource.AddFile( "sound/cough.mp3" )
resource.AddFile( "sound/fuckoff.wav" )
resource.AddFile( "sound/taunt1.wav" )
resource.AddFile( "sound/taunt2.wav" )
resource.AddFile( "sound/taunt3.wav" )
resource.AddFile( "sound/taunt4.wav" )
resource.AddFile( "sound/taunt5.wav" )
resource.AddFile( "sound/taunt6.wav" )
resource.AddFile( "sound/taunt7.wav" )
resource.AddFile( "sound/taunt8.wav" )
resource.AddFile( "sound/taunt9.wav" )
resource.AddFile( "sound/taunt10.wav" )
resource.AddFile( "sound/taunt11.wav" )
resource.AddFile( "sound/taunt12.wav" )
resource.AddFile( "sound/the end.wav" )

end


sounds[ "reload" ] = { "reload1.wav", "reload2.wav" }
sounds[ "jam" ] = { "jam.wav" }
sounds[ "move" ] = { "move.wav", "move2.wav" }
sounds[ "cough" ] = { "cough.mp3" }
sounds[ "hit" ] = { "hit.wav" }
sounds[ "locked" ] = { "locked.wav" }
sounds[ "help" ] = { "help.wav" }
sounds[ "fuckoff" ] = { "fuckoff.wav" }
sounds[ "" ] = { "radio.mp3" }
sounds[ "taunt" ] = { "taunt"..math.random(1,12)..".wav" }
sounds[ "the end" ] = { "the end.wav" }
sounds[ "cough4" ] = { "cough.wav" }
sounds[ "cough4" ] = { "cough.wav" }


local function CheckChat(ply, text)
    if ply.nextSpeechSound and ply.nextSpeechSound > CurTime() then return end
    local prefix = string.sub(text, 0, 1)
    if prefix == "/" or prefix == "!" or prefix == "@" then return end -- nu tipa da
    for k, v in pairs(sounds) do
        local res1, res2 = string.find(string.lower(text), k)
        if res1 and (not text[res1 - 1] or text[res1 - 1] == "" or text[res1 - 1] == " ") and (not text[res2 + 1] or text[res2 + 1] == "" or text[res2 + 1] == " ") then
            ply:EmitSound(table.Random(v), 65, 100)
            ply.nextSpeechSound = CurTime() + 2 
            break
        end
    end
end
hook.Add("PlayerSay", "DisfulSounds", CheckChat)

function DisfulSounds.getChatSound(text)
    return sounds[string.lower(text or "")]
end

function DisfulSounds.setChatSound(text, sndTable)
    sounds[string.lower(text or "")] = sndTable
end