Slawer.Jobs.CFG = Slawer.Jobs.CFG or {}

-- Chosen language
Slawer.Jobs.CFG.Lang = "ru"

-- Display a text over each NPC (npc name)
Slawer.Jobs.CFG.EnableNPCTitle = true

-- Theme configuration
Slawer.Jobs.CFG.Theme = {
    Primary = Color(33, 33, 33, 245),
    Secondary = Color(29, 29, 29, 245),
    Tertiary = Color(42, 42, 42, 245), 
    Quaternary = Color(50, 50, 50,235),
    Texts = Color(255, 255, 255),
    Texts2 = Color(100, 100, 100),
    Blue = Color(94, 125, 247),
    Red = Color(192, 57, 43),
}

-- Jobs that any player can become without having to use an employer NPC
Slawer.Jobs.CFG.AccessWithoutNPC = {
    -- ["Job Name"] = true,
    -- ["Job Name Two"] = true,
}

-- Place here all the things linked to the in-game created jobs (agenda, etc..)
hook.Add("Slawer.Jobs:OnJobsCreated", "Slawer.Jobs:OJC", function()
    
    -- HERE (example below with agendas)

    -- DarkRP.createAgenda("Citizen Jobs Agenda", TEAM_WHATEVER, {TEAM_WHATEVER2, TEAM_WHATEVER3})
    -- DarkRP.createAgenda("Mechanic Jobs Agenda", TEAM_MECHANIC, {})

end)

-- Used time format (some help there https://wiki.facepunch.com/gmod/os.date)
Slawer.Jobs.CFG.TimeFormat = "%dd %Hh %Mm %Ss"