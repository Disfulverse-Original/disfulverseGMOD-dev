BOTCHED.DEVCONFIG.DisableOpenLoginRewards = true

-- MENUES SAVING --
BOTCHED.DEVCONFIG.MenuTypes = BOTCHED.DEVCONFIG.MenuTypes or {}
BOTCHED.DEVCONFIG.MenuTypes["rewards"] = {
    Title = "Rewards",
    Element = "botched_rewards_panel",
    GetSize = function() return ScrW()*0.5, ScrH()*0.5 end
}