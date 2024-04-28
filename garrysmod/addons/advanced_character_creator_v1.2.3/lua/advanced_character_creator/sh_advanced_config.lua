--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

/*
    Addon id: 00690769-9ce4-49c1-bc5f-802f53225f58
    Version: v1.2.3 (stable)
*/

ACC2 = ACC2 or {}

--[[ Max page and max per page ]]
ACC2.MaxPage = 7

ACC2.MaxPerPage = 14

--[[ You can add more currency here don't remove them ]]
ACC2.Currencies = {
    ["$"] = function(money)
        return "$"..money
    end,
    ["€"] = function(money)
        return money.."€"
    end,
}

--[[ This is the default configuration ]]
ACC2.DefaultSettings = ACC2.DefaultSettings or {
    ["precacheModels"] = true,
    ["useCustomNotification"] = true,
    ["canOpenMenuWithKey"] = false,
    ["canOpenModificationMenuWithKey"] = false,
    ["enableCharacterDescription"] = true,
    ["selectPlay"] = true,
    ["synchronizationMenu"] = false,
    ["enableCharacterSaveNotification"] = false,
    ["adminRankBypassWhitelist"] = true,
    ["adminRankBypassBlacklist"] = true,
    ["enableContextToWhitelist"] = true,
    ["disableLastName"] = false,
    ["cooldownToOpen"] = 60,
    ["openMenuKey"] = KEY_M,
    ["cooldownToggleToOpen"] = 3,
    ["cooldownToOpenModification"] = 60,
    ["openModificationMenuKey"] = KEY_L,
    ["cooldownToggleToOpenModification"] = 3,
    ["defaultMenuModel"] = "models/player/Group01/male_02.mdl",
    ["defaultJob"] = "Безработный",
    ["adminCommand"] = "/acc2",
    ["whitelistCommand"] = "/whitelist",
    ["mainMenuDescription"] = "Добро пожаловать на сервер! Если у вас возникнут проблемы или вопросы, не стесняйтесь обращаться к нашему персоналу.",
    ["shortDescription"] = "",
    ["currency"] = "$",
    ["canRemoveWhenNotAllowed"] = false,
    ["canSelectWhenNotAllowed"] = false,
    ["defaultModelGroup1"] = {
        ["models/player/Group01/male_02.mdl"] = true,
        ["models/player/Group01/male_03.mdl"] = true,
        ["models/player/Group01/male_04.mdl"] = true,
        ["models/player/Group01/male_05.mdl"] = true,
        ["models/player/Group01/male_06.mdl"] = true,
        ["models/player/Group01/male_07.mdl"] = true,
        ["models/player/Group01/male_08.mdl"] = true,
        ["models/player/Group01/male_09.mdl"] = true,
    },
    ["defaultModelGroup2"] = {
        ["models/player/Group01/female_01.mdl"] = true,
        ["models/player/Group01/female_02.mdl"] = true,
        ["models/player/Group01/female_03.mdl"] = true,
        ["models/player/Group01/female_04.mdl"] = true,
        ["models/player/Group01/female_06.mdl"] = true,
    },
    ["randomName"] = {
        "Ethan",
        "Robert",
        "Adrien",
        "William",
        "Mickael",
        "Emillie",
        "Sarah",
        "Jack",
        "David",
        "Vladimir",
    },
    ["randomLastName"] = {
        "Adam",
        "Austin",
        "Lincoln",
        "Murfy",
        "Gran",
        "Edouards",
        "Anderson",
        "Boswell",
        "Roswell",
        "Guthember",
    },
    ["randomNameEnable"] = true,
    ["minSizeValue"] = 1,
    ["maxSizeValue"] = 1.1,
    ["maxSizeConvertion"] = 175,
    ["enableSize"] = true,
    ["enableAge"] = true,
    ["minimumAge"] = 18,
    ["prefixTable"] = {},
    ["dontOverrideModel"] = {},
    ["dontLoadJobWeapon"] = {},
    ["dontLoadJob"] = {},
    ["blacklistedSurnameAndName"] = {
        ["fuck"] = true,
    },
    ["maximumAge"] = 65,
    ["minCharacterLastName"] = 3,
    ["minCharacterName"] = 3,
    ["maxCharacterName"] = 15,
    ["maxCharacterLastName"] = 15,
    ["moneyWhenCreating"] = 5000,
    ["serverName"] = "DisfulverseRP",
    ["serverLogo"] = "https://i.imgur.com/sZn2Qzr.png",
    ["welcomeScreen"] = false,
    ["factionSystem"] = false,
    ["bodygroupMenu"] = false,
    ["enableSoundMenu"] = true,
    ["enableSoundCreated"] = true,
    ["deleteCharacterWhenDie"] = false,
    ["lang"] = "ru",
    ["soundMenuLink"] = "https://voca.ro/192wrbxfE6kp",
    ["soundCreatedLink"] = "https://i.imgur.com/sZn2Qzr.png",
    ["soundCreatedVolume"] = 1,
    ["soundMenuVolume"] = 1,
    ["maxPlayerCharacters"] = {1},
    ["enableMenuOnDeath"] = false,
    ["loadJob"] = true,
    ["loadHealth"] = true,
    ["loadArmor"] = true,
    ["loadMoney"] = true,
    ["loadPos"] = true,
    ["loadSize"] = true,
    ["loadSizeView"] = true,
    ["loadWeapons"] = true,
    ["loadModel"] = true,
    ["loadName"] = true,
    ["onlyOneModelGroup"] = false,
    ["npcMenuName"] = "Character Menu",
    ["npcMenuModel"] = "models/breen.mdl",
    ["npcModificationName"] = "Модифицировать персонажа",
    ["npcModificationModel"] = "models/Kleiner.mdl",
    ["npcRPNameName"] = "Смена имени",
    ["npcRPNameModel"] = "models/mossman.mdl",
    ["groupName1"] = "Мужчина",
    ["groupName2"] = "Женщина",
    ["priceToModifyCharacter"] = 25000,
    ["priceToModifyRPName"] = 10000,
    ["cooldownToModifyRPName"] = 60,
    ["cooldownToModifyCharacter"] = 60,
    ["buttonsEnable1"] = false,
    ["buttonsEnable2"] = false,
    ["buttonsEnable3"] = false,
    ["buttonsEnable4"] = false,
    ["buttonsLinks1"] = "https://store.steampowered.com/",
    ["buttonsLinks2"] = "https://discord.com/",
    ["buttonsLinks3"] = "https://steamcommunity.com/",
    ["buttonsLinks4"] = "https://google.com/",
    ["buttonsImage1"] = "https://i.imgur.com/YdzOu6r.png",
    ["buttonsImage2"] = "https://i.imgur.com/FmuBV6q.png",
    ["buttonsImage3"] = "https://i.imgur.com/DqYdnUA.png",
    ["buttonsImage4"] = "https://i.imgur.com/FmuBV6q.png",
}

--[[ All tables used on the admin menu ]]
ACC2.AdvancedConfiguration = ACC2.AdvancedConfiguration or {
    ["settings"] = {},
}

--[[ List all type of value for the NW functions ]]
ACC2.TypeNet = ACC2.TypeNet or {
    ["Player"] = "Entity",
    ["Vector"] = "Vector",
    ["Color"] = "Color",
    ["Angle"] = "Angle",
    ["Entity"] = "Entity",
    ["number"] = "Float",
    ["string"] = "String",
    ["table"] = "Table",
    ["boolean"] = "Bool",
}

--[[ List all constants values ]]
ACC2.Constants = {
    ["vectorOrigin"] = Vector(0, 0, 0),
    ["vectorNPC"] = Vector(0, 0, 26),
    ["angleOrigin"] = Angle(0, 0, 0),
    ["vectorModel1"] = Vector(0, 0, 18),
    ["vectorModel2"] = Vector(0, 0, 25),
    ["angleDModel1"] = Angle(0, 35, 0),
    ["angleDModel2"] = Angle(0, 45, 0),
    ["playerViewBase"] = Vector(0, 0, 64),
}

--[[ All things used on accordion, and other stuff ]] 
ACC2.ParametersConfig = {
    ["generalSettings"] = {
        {
            {
                ["class"] = "ACC2:CheckBox",
                ["text"] = "useCustomNotification",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink)
                    ACC2.AdvancedConfiguration["settings"] = {}

                    pnl:SetActive(tobool(ACC2.DefaultSettings["useCustomNotification"]))

                    pnl.OnChange = function(self, bChecked)
                        ACC2.AdvancedConfiguration["settings"]["useCustomNotification"] = bChecked
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:CheckBox",
                ["text"] = "enableCharacterSaveNotification",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink)
                    ACC2.AdvancedConfiguration["settings"] = {}

                    pnl:SetActive(tobool(ACC2.DefaultSettings["enableCharacterSaveNotification"]))

                    pnl.OnChange = function(self, bChecked)
                        ACC2.AdvancedConfiguration["settings"]["enableCharacterSaveNotification"] = bChecked
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:CheckBox",
                ["text"] = "selectPlay",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink)
                    ACC2.AdvancedConfiguration["settings"] = {}

                    pnl:SetActive(tobool(ACC2.DefaultSettings["selectPlay"]))

                    pnl.OnChange = function(self, bChecked)
                        ACC2.AdvancedConfiguration["settings"]["selectPlay"] = bChecked
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:CheckBox",
                ["text"] = "adminRankBypassWhitelist",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink)
                    ACC2.AdvancedConfiguration["settings"] = {}

                    pnl:SetActive(tobool(ACC2.DefaultSettings["adminRankBypassWhitelist"]))

                    pnl.OnChange = function(self, bChecked)
                        ACC2.AdvancedConfiguration["settings"]["adminRankBypassWhitelist"] = bChecked
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:CheckBox",
                ["text"] = "adminRankBypassBlacklist",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink)
                    ACC2.AdvancedConfiguration["settings"] = {}

                    pnl:SetActive(tobool(ACC2.DefaultSettings["adminRankBypassBlacklist"]))

                    pnl.OnChange = function(self, bChecked)
                        ACC2.AdvancedConfiguration["settings"]["adminRankBypassBlacklist"] = bChecked
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:CheckBox",
                ["text"] = "enableContextToWhitelist",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink)
                    ACC2.AdvancedConfiguration["settings"] = {}

                    pnl:SetActive(tobool(ACC2.DefaultSettings["enableContextToWhitelist"]))

                    pnl.OnChange = function(self, bChecked)
                        ACC2.AdvancedConfiguration["settings"]["enableContextToWhitelist"] = bChecked
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:CheckBox",
                ["text"] = "precacheModels",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink)
                    ACC2.AdvancedConfiguration["settings"] = {}

                    pnl:SetActive(tobool(ACC2.DefaultSettings["precacheModels"]))

                    pnl.OnChange = function(self, bChecked)
                        ACC2.AdvancedConfiguration["settings"]["precacheModels"] = bChecked
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:DComboBox",
                ["text"] = "language",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetRounded(6)

                    for k,v in pairs(ACC2.Language) do
                        pnl:AddChoice(k)
                    end

                    pnl:ChooseOption(ACC2.DefaultSettings["lang"])

                    pnl.OnSelect = function(self, index, text, data)
                        ACC2.AdvancedConfiguration["settings"]["lang"] = text
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:DComboBox",
                ["text"] = "defaultJob",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetRounded(6)

                    for k, v in pairs(team.GetAllTeams()) do
                        if not v.Joinable then continue end
                        if k == 0 then continue end

                        pnl:AddChoice(team.GetName(k))
                    end

                    pnl:ChooseOption(ACC2.DefaultSettings["defaultJob"])

                    pnl.OnSelect = function(self, index, text, data)
                        ACC2.AdvancedConfiguration["settings"]["defaultJob"] = text
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:DComboBox",
                ["text"] = "currency",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetRounded(6)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* ded51e6532282dfa00c9343043e6163c5627f86ee51ba1d02ddf9be86bf42ec7 */

                    for k,v in pairs(ACC2.Currencies) do
                        pnl:AddChoice(k)
                    end

                    pnl:ChooseOption(ACC2.DefaultSettings["currency"])

                    pnl.OnSelect = function(self, index, text, data)
                        ACC2.AdvancedConfiguration["settings"]["currency"] = text
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:TextEntry",
                ["text"] = "adminCommand",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetText(ACC2.DefaultSettings["adminCommand"])
                    pnl:SetRounded(6)
    
                    pnl.entry.OnChange = function()
                        ACC2.AdvancedConfiguration["settings"]["adminCommand"] = pnl:GetText()
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:TextEntry",
                ["text"] = "whitelistCommand",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetText(ACC2.DefaultSettings["whitelistCommand"])
                    pnl:SetRounded(6)
    
                    pnl.entry.OnChange = function()
                        ACC2.AdvancedConfiguration["settings"]["whitelistCommand"] = pnl:GetText()
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:TextEntry",
                ["text"] = "serverName",
                ["sizeX"] = 0.085,
                ["sizeY"] = 0.03,
                ["posX"] = 0.44,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetText(ACC2.DefaultSettings["serverName"])
                    pnl:SetRounded(6)
    
                    pnl.entry.OnChange = function()
                        ACC2.AdvancedConfiguration["settings"]["serverName"] = pnl:GetText()
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:TextEntry",
                ["text"] = "defaultMenuModel",
                ["sizeX"] = 0.175,
                ["sizeY"] = 0.03,
                ["posX"] = 0.35,
                ["posY"] = 0.01, 
                ["func"] = function(pnl, panelLink)
                    pnl:SetText(ACC2.DefaultSettings["defaultMenuModel"])
                    pnl:SetRounded(6)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198931466944
    
                    pnl.entry.OnChange = function()
                        ACC2.AdvancedConfiguration["settings"]["defaultMenuModel"] = pnl:GetText()
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:TextEntry",
                ["text"] = "serverLogo",
                ["sizeX"] = 0.175,
                ["sizeY"] = 0.03,
                ["posX"] = 0.35,
                ["posY"] = 0.01, 
                ["func"] = function(pnl, panelLink)
                    pnl:SetText(ACC2.DefaultSettings["serverLogo"])
                    pnl:SetRounded(6)
    
                    pnl.entry.OnChange = function()
                        ACC2.AdvancedConfiguration["settings"]["serverLogo"] = pnl:GetText()
                    end
                end,
            },
        },
        {
            {
                ["class"] = "DButton",
                ["text"] = "maxCharacters",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetTextColor(ACC2.Colors["white100"])
                    pnl:SetFont("ACC2:Font:18")
                    
                    pnl.Paint = function(self, w, h)
                        pnl:SetText(ACC2.GetSentence("open"))
                        draw.RoundedBox(6, 0, 0, w, h, ACC2.Colors["white5"])
                    end

                    pnl.DoClick = function(self)
                        if IsValid(maxCharacters) then maxCharacters:Remove() end
                        
                        maxCharacters = vgui.Create("DFrame")
                        maxCharacters:SetSize(ACC2.ScrW*0.2, ACC2.ScrH*0.43)
                        maxCharacters:SetDraggable(true)
                        maxCharacters:MakePopup()
                        maxCharacters:SetTitle("")
                        maxCharacters:ShowCloseButton(false)
                        maxCharacters:Center()
                        maxCharacters.Paint = function(self,w,h)
                            ACC2.DrawBlur(self, 4) 
                    
                            draw.RoundedBox(0,0,0,w,h,ACC2.Colors["blackpurple"])
                            draw.RoundedBox(0,w/2-ACC2.ScrW*0.192/2,h*0.02,ACC2.ScrW*0.192, ACC2.ScrH*0.062,ACC2.Colors["white20"])
                            
                            draw.DrawText(ACC2.GetSentence("maxCharactersTitle"), "ACC2:Font:13", w*0.05, h*0.02, ACC2.Colors["white"], TEXT_ALIGN_LEFT)
                            draw.DrawText(ACC2.GetSentence("maxCharacters"), "ACC2:Font:14", w*0.05, h*0.09, ACC2.Colors["white100"], TEXT_ALIGN_LEFT)
                        end

                        local scrollPanel = vgui.Create("ACC2:DScroll", maxCharacters)
                        scrollPanel:SetSize(ACC2.ScrW*0.193, ACC2.ScrH*0.295)
                        scrollPanel:SetPos(ACC2.ScrW*0.0049, ACC2.ScrH*0.078)

                        local userTable = CAMI and CAMI.GetUsergroups() or {}
                        local saveTable = {}
                        for k, v in pairs(userTable) do
                            local rankMax = vgui.Create("DButton", scrollPanel)
                            rankMax:SetSize(0, ACC2.ScrH*0.06)
                            rankMax:DockMargin(0, 0, ACC2.ScrW*0.0028, ACC2.ScrH*0.006)
                            rankMax:Dock(TOP)
                            rankMax:SetText("")
                            
                            rankMax.Paint = function(self, w, h)
                                draw.RoundedBox(4, 0, 0, w, h, ACC2.Colors["white5"])
                                draw.SimpleText(k, "ACC2:Font:18", w*0.05, h/2, ACC2.Colors["white100"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                            end

                            local maxRank = vgui.Create("ACC2:TextEntry", rankMax)
                            maxRank:SetSize(ACC2.ScrH*0.08, ACC2.ScrH*0.035)
                            maxRank:SetPos(ACC2.ScrH*0.245, ACC2.ScrH*0.015)
                            maxRank:SetRounded(6)
                            maxRank:SetPlaceHolder(1)
                            maxRank:SetNumeric(true)

                            ACC2.DefaultSettings["maxPlayerCharacters"] = ACC2.DefaultSettings["maxPlayerCharacters"] or {}
                            local settingsmaxCharacters = tonumber(ACC2.DefaultSettings["maxPlayerCharacters"][k]) or 1

                            if isnumber(settingsmaxCharacters) then
                                maxRank:SetPlaceHolder(settingsmaxCharacters)
                                saveTable[k] = settingsmaxCharacters
                            end

                            maxRank.entry.OnChange = function(self)
                                saveTable[k] = maxRank:GetText()
                            end
                        end
                        
                        local save = vgui.Create("ACC2:SlideButton", maxCharacters)
                        save:SetSize(ACC2.ScrW*0.192, ACC2.ScrH*0.041)
                        save:SetPos(ACC2.ScrW*0.005, ACC2.ScrH*0.38)
                        save:SetText(ACC2.GetSentence("saveMaxCharacter"))
                        save:SetFont("ACC2:Font:15")
                        save:SetTextColor(ACC2.Colors["white"])
                        save:InclineButton(0)
                        save.MinMaxLerp = {100, 200}
                        save:SetIconMaterial(nil)
                        save:SetButtonColor(ACC2.Colors["purple"])
                        save.DoClick = function()
                            maxCharacters:Remove()
                            ACC2.AdvancedConfiguration["settings"]["maxPlayerCharacters"] = saveTable

                            ACC2.SaveConfigSettings()
                        end

                        local closeLerp = 50
                        local close = vgui.Create("DButton", maxCharacters)
                        close:SetSize(ACC2.ScrH*0.026, ACC2.ScrH*0.026)
                        close:SetPos(ACC2.ScrW*0.175, ACC2.ScrH*0.028)
                        close:SetText("")
                        close.Paint = function(self,w,h)
                            closeLerp = Lerp(FrameTime()*5, closeLerp, (close:IsHovered() and 50 or 100))
                    
                            surface.SetDrawColor(ColorAlpha(ACC2.Colors["white100"], closeLerp))
                            surface.SetMaterial(ACC2.Materials["icon_close"])
                            surface.DrawTexturedRect(0, 0, w, h)
                        end
                        close.DoClick = function()
                            maxCharacters:Remove()
                        end
                    end
                end,
            },
        },
        {
            {
                ["class"] = "DButton",
                ["text"] = "blacklistedSurnameAndName",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetTextColor(ACC2.Colors["white100"])
                    pnl:SetFont("ACC2:Font:09")
                    
                    pnl.Paint = function(self, w, h)
                        pnl:SetText(ACC2.GetSentence("open"))
                        draw.RoundedBox(6, 0, 0, w, h, ACC2.Colors["white5"])
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198931466944

                        ACC2.AdvancedConfiguration["settings"]["blacklistedSurnameAndName"] = ACC2.DefaultSettings["blacklistedSurnameAndName"]
                    end

                    pnl.DoClick = function()
                        ACC2.AddOnTableConfig(ACC2.DefaultSettings["blacklistedSurnameAndName"], true)         
                    end
                end,
            },
        },
        {
            {
                ["class"] = "DButton",
                ["text"] = "configurePrefix",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetTextColor(ACC2.Colors["white100"])
                    pnl:SetFont("ACC2:Font:09")
                    
                    pnl.Paint = function(self, w, h)
                        pnl:SetText(ACC2.GetSentence("open"))
                        draw.RoundedBox(6, 0, 0, w, h, ACC2.Colors["white5"])
                    end

                    pnl.DoClick = function()
                        ACC2.PrefixConfig()
                    end
                end,
            },
        },
        {
            {
                ["class"] = "DButton",
                ["text"] = "configureFaction",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetTextColor(ACC2.Colors["white100"])
                    pnl:SetFont("ACC2:Font:09")
                    
                    pnl.Paint = function(self, w, h)
                        pnl:SetText(ACC2.GetSentence("open"))
                        draw.RoundedBox(6, 0, 0, w, h, ACC2.Colors["white5"])
                    end

                    pnl.DoClick = function()
                        ACC2.AdminMenuFaction()
                    end
                end,
            },
        },
        {
            {
                ["class"] = "DButton",
                ["text"] = "managePlayersCharacters",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetTextColor(ACC2.Colors["white100"])
                    pnl:SetFont("ACC2:Font:09")
                    
                    pnl.Paint = function(self, w, h)
                        pnl:SetText(ACC2.GetSentence("open"))
                        draw.RoundedBox(6, 0, 0, w, h, ACC2.Colors["white5"])
                    end

                    pnl.DoClick = function()
                        ACC2.ManagePlayers()
                    end
                end,
            },
        },
    },
    ["keySettings"] = {
        {
            {
                ["class"] = "ACC2:CheckBox",
                ["text"] = "canOpenMenuWithKey",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink)
                    ACC2.AdvancedConfiguration["settings"] = {}

                    pnl:SetActive(tobool(ACC2.DefaultSettings["canOpenMenuWithKey"]))

                    pnl.OnChange = function(self, bChecked)
                        ACC2.AdvancedConfiguration["settings"]["canOpenMenuWithKey"] = bChecked
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:TextEntry",
                ["text"] = "cooldownToOpen",
                ["sizeX"] = 0.085,
                ["sizeY"] = 0.03,
                ["posX"] = 0.44,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetPlaceHolder(ACC2.DefaultSettings["cooldownToOpen"])
                    pnl:SetRounded(6)
                    pnl:SetNumeric(true)
    
                    pnl.entry.OnChange = function()
                        ACC2.AdvancedConfiguration["settings"]["cooldownToOpen"] = tonumber(pnl:GetText())
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:TextEntry",
                ["text"] = "cooldownToggleToOpen",
                ["sizeX"] = 0.085,
                ["sizeY"] = 0.03,
                ["posX"] = 0.44,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetPlaceHolder(ACC2.DefaultSettings["cooldownToggleToOpen"])
                    pnl:SetRounded(6)
                    pnl:SetNumeric(true)
    
                    pnl.entry.OnChange = function()
                        ACC2.AdvancedConfiguration["settings"]["cooldownToggleToOpen"] = tonumber(pnl:GetText())
                    end
                end,
            },
        },
        {
            {
                ["class"] = "DBinder",
                ["text"] = "openMenuKey",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetText("KEY_"..input.GetKeyName(ACC2.DefaultSettings["openMenuKey"]):upper())
                    pnl:SetFont("ACC2:Font:09")
    
                    pnl.OnChange = function(self, key)
                        self:SetText("KEY_"..input.GetKeyName(key):upper())
                        ACC2.AdvancedConfiguration["settings"]["openMenuKey"] = key
                    end
    
                    pnl.Paint = function(self, w, h)
                        draw.RoundedBox(6, 0, 0, w, h, ACC2.Colors["white5"])
                    end
                    
                    pnl:SetTextColor(ACC2.Colors["white100"])
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:CheckBox",
                ["text"] = "canOpenModificationMenuWithKey",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink)
                    ACC2.AdvancedConfiguration["settings"] = {}

                    pnl:SetActive(tobool(ACC2.DefaultSettings["canOpenModificationMenuWithKey"]))

                    pnl.OnChange = function(self, bChecked)
                        ACC2.AdvancedConfiguration["settings"]["canOpenModificationMenuWithKey"] = bChecked
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:TextEntry",
                ["text"] = "cooldownToOpenModification",
                ["sizeX"] = 0.085,
                ["sizeY"] = 0.03,
                ["posX"] = 0.44,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetPlaceHolder(ACC2.DefaultSettings["cooldownToOpenModification"])
                    pnl:SetRounded(6)
                    pnl:SetNumeric(true)
    
                    pnl.entry.OnChange = function()
                        ACC2.AdvancedConfiguration["settings"]["cooldownToOpenModification"] = tonumber(pnl:GetText())
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:TextEntry",
                ["text"] = "cooldownToggleToOpenModification",
                ["sizeX"] = 0.085,
                ["sizeY"] = 0.03,
                ["posX"] = 0.44,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetPlaceHolder(ACC2.DefaultSettings["cooldownToggleToOpenModification"])
                    pnl:SetRounded(6)
                    pnl:SetNumeric(true)
    
                    pnl.entry.OnChange = function()
                        ACC2.AdvancedConfiguration["settings"]["cooldownToggleToOpenModification"] = tonumber(pnl:GetText())
                    end
                end,
            },
        },
        {
            {
                ["class"] = "DBinder",
                ["text"] = "openModificationMenuKey",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetText("KEY_"..input.GetKeyName(ACC2.DefaultSettings["openModificationMenuKey"]):upper())
                    pnl:SetFont("ACC2:Font:09")
    
                    pnl.OnChange = function(self, key)
                        self:SetText("KEY_"..input.GetKeyName(key):upper())
                        ACC2.AdvancedConfiguration["settings"]["openModificationMenuKey"] = key
                    end
    
                    pnl.Paint = function(self, w, h)
                        draw.RoundedBox(6, 0, 0, w, h, ACC2.Colors["white5"])
                    end
                    
                    pnl:SetTextColor(ACC2.Colors["white100"])
                end,
            },
        },
    },
    ["npcSettings"] = {
        {
            {
                ["class"] = "ACC2:TextEntry",
                ["text"] = "priceToModifyCharacter",
                ["sizeX"] = 0.085,
                ["sizeY"] = 0.03,
                ["posX"] = 0.44,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetPlaceHolder(ACC2.DefaultSettings["priceToModifyCharacter"])
                    pnl:SetRounded(6)
                    pnl:SetNumeric(true)
    
                    pnl.entry.OnChange = function()
                        ACC2.AdvancedConfiguration["settings"]["priceToModifyCharacter"] = tonumber(pnl:GetText())
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:TextEntry",
                ["text"] = "cooldownToModifyCharacter",
                ["sizeX"] = 0.085,
                ["sizeY"] = 0.03,
                ["posX"] = 0.44,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetPlaceHolder(ACC2.DefaultSettings["cooldownToModifyCharacter"])
                    pnl:SetRounded(6)
                    pnl:SetNumeric(true)
    
                    pnl.entry.OnChange = function()
                        ACC2.AdvancedConfiguration["settings"]["cooldownToModifyCharacter"] = tonumber(pnl:GetText())
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:TextEntry",
                ["text"] = "priceToModifyRPName",
                ["sizeX"] = 0.085,
                ["sizeY"] = 0.03,
                ["posX"] = 0.44,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetPlaceHolder(ACC2.DefaultSettings["priceToModifyRPName"])
                    pnl:SetRounded(6)
                    pnl:SetNumeric(true)
    
                    pnl.entry.OnChange = function()
                        ACC2.AdvancedConfiguration["settings"]["priceToModifyRPName"] = tonumber(pnl:GetText())
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:TextEntry",
                ["text"] = "cooldownToModifyRPName",
                ["sizeX"] = 0.085,
                ["sizeY"] = 0.03,
                ["posX"] = 0.44,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetPlaceHolder(ACC2.DefaultSettings["cooldownToModifyRPName"])
                    pnl:SetRounded(6)
                    pnl:SetNumeric(true)
    
                    pnl.entry.OnChange = function()
                        ACC2.AdvancedConfiguration["settings"]["cooldownToModifyRPName"] = tonumber(pnl:GetText())
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:TextEntry",
                ["text"] = "npcMenuName",
                ["sizeX"] = 0.085,
                ["sizeY"] = 0.03,
                ["posX"] = 0.44,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetText(ACC2.DefaultSettings["npcMenuName"])
                    pnl:SetRounded(6)
    
                    pnl.entry.OnChange = function()
                        ACC2.AdvancedConfiguration["settings"]["npcMenuName"] = pnl:GetText()
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:TextEntry",
                ["text"] = "npcMenuModel",
                ["sizeX"] = 0.085,
                ["sizeY"] = 0.03,
                ["posX"] = 0.44,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetText(ACC2.DefaultSettings["npcMenuModel"])
                    pnl:SetRounded(6)
    
                    pnl.entry.OnChange = function()
                        ACC2.AdvancedConfiguration["settings"]["npcMenuModel"] = pnl:GetText()
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:TextEntry",
                ["text"] = "npcModificationName",
                ["sizeX"] = 0.085,
                ["sizeY"] = 0.03,
                ["posX"] = 0.44,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetText(ACC2.DefaultSettings["npcModificationName"])
                    pnl:SetRounded(6)
    
                    pnl.entry.OnChange = function()
                        ACC2.AdvancedConfiguration["settings"]["npcModificationName"] = pnl:GetText()
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:TextEntry",
                ["text"] = "npcModificationModel",
                ["sizeX"] = 0.085,
                ["sizeY"] = 0.03,
                ["posX"] = 0.44,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetText(ACC2.DefaultSettings["npcModificationModel"])
                    pnl:SetRounded(6)
    
                    pnl.entry.OnChange = function()
                        ACC2.AdvancedConfiguration["settings"]["npcModificationModel"] = pnl:GetText()
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:TextEntry",
                ["text"] = "npcRPNameName",
                ["sizeX"] = 0.085,
                ["sizeY"] = 0.03,
                ["posX"] = 0.44,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetText(ACC2.DefaultSettings["npcRPNameName"])
                    pnl:SetRounded(6)
    
                    pnl.entry.OnChange = function()
                        ACC2.AdvancedConfiguration["settings"]["npcRPNameName"] = pnl:GetText()
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:TextEntry",
                ["text"] = "npcRPNameModel",
                ["sizeX"] = 0.085,
                ["sizeY"] = 0.03,
                ["posX"] = 0.44,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetText(ACC2.DefaultSettings["npcRPNameModel"])
                    pnl:SetRounded(6)
    
                    pnl.entry.OnChange = function()
                        ACC2.AdvancedConfiguration["settings"]["npcRPNameModel"] = pnl:GetText()
                    end
                end,
            },
        },
    },
    ["groupModelsSettings"] = {
        {
            {
                ["class"] = "ACC2:CheckBox",
                ["text"] = "onlyOneModelGroup",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink)
                    ACC2.AdvancedConfiguration["settings"] = {}

                    pnl:SetActive(tobool(ACC2.DefaultSettings["onlyOneModelGroup"]))

                    pnl.OnChange = function(self, bChecked)
                        ACC2.AdvancedConfiguration["settings"]["onlyOneModelGroup"] = bChecked
                    end
                end,
            },
        },
        {
            {
                ["class"] = "DButton",
                ["text"] = "defaultModelGroup1",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetTextColor(ACC2.Colors["white100"])
                    pnl:SetFont("ACC2:Font:09")
                    
                    pnl.Paint = function(self, w, h)
                        pnl:SetText(ACC2.GetSentence("open"))
                        draw.RoundedBox(6, 0, 0, w, h, ACC2.Colors["white5"])

                        ACC2.AdvancedConfiguration["settings"]["defaultModelGroup1"] = ACC2.DefaultSettings["defaultModelGroup1"]
                    end

                    pnl.DoClick = function()
                        ACC2.AddOnTableConfig(ACC2.DefaultSettings["defaultModelGroup1"], true)         
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:TextEntry",
                ["text"] = "groupName1",
                ["sizeX"] = 0.085,
                ["sizeY"] = 0.03,
                ["posX"] = 0.44,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetText(ACC2.DefaultSettings["groupName1"])
                    pnl:SetRounded(6)
    
                    pnl.entry.OnChange = function()
                        ACC2.AdvancedConfiguration["settings"]["groupName1"] = pnl:GetText()
                    end
                end,
            },
        },
        {
            {
                ["class"] = "DButton",
                ["text"] = "defaultModelGroup2",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetTextColor(ACC2.Colors["white100"])
                    pnl:SetFont("ACC2:Font:09")
                    
                    pnl.Paint = function(self, w, h)
                        pnl:SetText(ACC2.GetSentence("open"))
                        draw.RoundedBox(6, 0, 0, w, h, ACC2.Colors["white5"])

                        ACC2.AdvancedConfiguration["settings"]["defaultModelGroup2"] = ACC2.DefaultSettings["defaultModelGroup2"]
                    end

                    pnl.DoClick = function()
                        ACC2.AddOnTableConfig(ACC2.DefaultSettings["defaultModelGroup2"], true)         
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:TextEntry",
                ["text"] = "groupName2",
                ["sizeX"] = 0.085,
                ["sizeY"] = 0.03,
                ["posX"] = 0.44,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetText(ACC2.DefaultSettings["groupName2"])
                    pnl:SetRounded(6)
    
                    pnl.entry.OnChange = function()
                        ACC2.AdvancedConfiguration["settings"]["groupName2"] = pnl:GetText()
                    end
                end,
            },
        },
    },
    ["menuSettings"] = {
        {
            {
                ["class"] = "ACC2:CheckBox",
                ["text"] = "factionSystem",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink)
                    ACC2.AdvancedConfiguration["settings"] = {}

                    pnl:SetActive(tobool(ACC2.DefaultSettings["factionSystem"]))

                    pnl.OnChange = function(self, bChecked)
                        ACC2.AdvancedConfiguration["settings"]["factionSystem"] = bChecked
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:CheckBox",
                ["text"] = "enableMenuOnDeath",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink)
                    ACC2.AdvancedConfiguration["settings"] = {}

                    pnl:SetActive(tobool(ACC2.DefaultSettings["enableMenuOnDeath"]))

                    pnl.OnChange = function(self, bChecked)
                        ACC2.AdvancedConfiguration["settings"]["enableMenuOnDeath"] = bChecked
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:CheckBox",
                ["text"] = "welcomeScreen",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink)
                    ACC2.AdvancedConfiguration["settings"] = {}

                    pnl:SetActive(tobool(ACC2.DefaultSettings["welcomeScreen"]))

                    pnl.OnChange = function(self, bChecked)
                        ACC2.AdvancedConfiguration["settings"]["welcomeScreen"] = bChecked
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:CheckBox",
                ["text"] = "bodygroupMenu",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink)
                    ACC2.AdvancedConfiguration["settings"] = {}

                    pnl:SetActive(tobool(ACC2.DefaultSettings["bodygroupMenu"]))

                    pnl.OnChange = function(self, bChecked)
                        ACC2.AdvancedConfiguration["settings"]["bodygroupMenu"] = bChecked
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:TextEntry",
                ["text"] = "mainMenuDescription",
                ["sizeX"] = 0.175,
                ["sizeY"] = 0.03,
                ["posX"] = 0.35,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetText(ACC2.DefaultSettings["mainMenuDescription"])
                    pnl:SetRounded(6)
    
                    pnl.entry.OnChange = function()
                        ACC2.AdvancedConfiguration["settings"]["mainMenuDescription"] = pnl:GetText()
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:TextEntry",
                ["text"] = "shortDescription",
                ["sizeX"] = 0.175,
                ["sizeY"] = 0.03,
                ["posX"] = 0.35,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetText(ACC2.DefaultSettings["shortDescription"])
                    pnl:SetRounded(6)
    
                    pnl.entry.OnChange = function()
                        ACC2.AdvancedConfiguration["settings"]["shortDescription"] = pnl:GetText()
                    end
                end,
            },
        },
    },
    ["loadSettings"] = {
        {
            {
                ["class"] = "DButton",
                ["text"] = "dontOverrideModel",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetTextColor(ACC2.Colors["white100"])
                    pnl:SetFont("ACC2:Font:09")
                    
                    pnl.Paint = function(self, w, h)
                        pnl:SetText(ACC2.GetSentence("open"))
                        draw.RoundedBox(6, 0, 0, w, h, ACC2.Colors["white5"])

                        ACC2.AdvancedConfiguration["settings"]["dontOverrideModel"] = ACC2.DefaultSettings["dontOverrideModel"]
                    end

                    pnl.DoClick = function()
                        ACC2.JobConfig(ACC2.DefaultSettings["dontOverrideModel"])         
                    end
                end,
            },
        },
        {
            {
                ["class"] = "DButton",
                ["text"] = "dontLoadJobWeapon",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetTextColor(ACC2.Colors["white100"])
                    pnl:SetFont("ACC2:Font:09")
                    
                    pnl.Paint = function(self, w, h)
                        pnl:SetText(ACC2.GetSentence("open"))
                        draw.RoundedBox(6, 0, 0, w, h, ACC2.Colors["white5"])

                        ACC2.AdvancedConfiguration["settings"]["dontLoadJobWeapon"] = ACC2.DefaultSettings["dontLoadJobWeapon"]
                    end

                    pnl.DoClick = function()
                        ACC2.JobConfig(ACC2.DefaultSettings["dontLoadJobWeapon"])         
                    end
                end,
            },
        },
        {
            {
                ["class"] = "DButton",
                ["text"] = "dontLoadJob",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetTextColor(ACC2.Colors["white100"])
                    pnl:SetFont("ACC2:Font:09")
                    
                    pnl.Paint = function(self, w, h)
                        pnl:SetText(ACC2.GetSentence("open"))
                        draw.RoundedBox(6, 0, 0, w, h, ACC2.Colors["white5"])

                        ACC2.AdvancedConfiguration["settings"]["dontLoadJob"] = ACC2.DefaultSettings["dontLoadJob"]
                    end

                    pnl.DoClick = function()
                        ACC2.JobConfig(ACC2.DefaultSettings["dontLoadJob"])         
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:CheckBox",
                ["text"] = "loadName",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink)
                    ACC2.AdvancedConfiguration["settings"] = {}

                    pnl:SetActive(tobool(ACC2.DefaultSettings["loadName"]))

                    pnl.OnChange = function(self, bChecked)
                        ACC2.AdvancedConfiguration["settings"]["loadName"] = bChecked
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:CheckBox",
                ["text"] = "loadJob",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink)
                    ACC2.AdvancedConfiguration["settings"] = {}

                    pnl:SetActive(tobool(ACC2.DefaultSettings["loadJob"]))

                    pnl.OnChange = function(self, bChecked)
                        ACC2.AdvancedConfiguration["settings"]["loadJob"] = bChecked
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:CheckBox",
                ["text"] = "loadModel",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink)
                    ACC2.AdvancedConfiguration["settings"] = {}

                    pnl:SetActive(tobool(ACC2.DefaultSettings["loadModel"]))

                    pnl.OnChange = function(self, bChecked)
                        ACC2.AdvancedConfiguration["settings"]["loadModel"] = bChecked
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:CheckBox",
                ["text"] = "loadHealth",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink)
                    ACC2.AdvancedConfiguration["settings"] = {}

                    pnl:SetActive(tobool(ACC2.DefaultSettings["loadHealth"]))

                    pnl.OnChange = function(self, bChecked)
                        ACC2.AdvancedConfiguration["settings"]["loadHealth"] = bChecked
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:CheckBox",
                ["text"] = "loadArmor",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink)
                    ACC2.AdvancedConfiguration["settings"] = {}

                    pnl:SetActive(tobool(ACC2.DefaultSettings["loadArmor"]))

                    pnl.OnChange = function(self, bChecked)
                        ACC2.AdvancedConfiguration["settings"]["loadArmor"] = bChecked
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:CheckBox",
                ["text"] = "loadMoney",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink)
                    ACC2.AdvancedConfiguration["settings"] = {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 482c562e67c7127e3b68e63eb0de779cb19814da22ab42eae52a7d3451fc844a

                    pnl:SetActive(tobool(ACC2.DefaultSettings["loadMoney"]))

                    pnl.OnChange = function(self, bChecked)
                        ACC2.AdvancedConfiguration["settings"]["loadMoney"] = bChecked
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:CheckBox",
                ["text"] = "loadPos",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink)
                    ACC2.AdvancedConfiguration["settings"] = {}

                    pnl:SetActive(tobool(ACC2.DefaultSettings["loadPos"]))

                    pnl.OnChange = function(self, bChecked)
                        ACC2.AdvancedConfiguration["settings"]["loadPos"] = bChecked
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:CheckBox",
                ["text"] = "loadSize",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink)
                    ACC2.AdvancedConfiguration["settings"] = {}

                    pnl:SetActive(tobool(ACC2.DefaultSettings["loadSize"]))

                    pnl.OnChange = function(self, bChecked)
                        ACC2.AdvancedConfiguration["settings"]["loadSize"] = bChecked
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:CheckBox",
                ["text"] = "loadSizeView",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink)
                    ACC2.AdvancedConfiguration["settings"] = {}

                    pnl:SetActive(tobool(ACC2.DefaultSettings["loadSizeView"]))

                    pnl.OnChange = function(self, bChecked)
                        ACC2.AdvancedConfiguration["settings"]["loadSizeView"] = bChecked
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:CheckBox",
                ["text"] = "loadWeapons",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink)
                    ACC2.AdvancedConfiguration["settings"] = {}

                    pnl:SetActive(tobool(ACC2.DefaultSettings["loadWeapons"]))

                    pnl.OnChange = function(self, bChecked)
                        ACC2.AdvancedConfiguration["settings"]["loadWeapons"] = bChecked
                    end
                end,
            },
        },
    },
    ["characterSettings"] = {
        {
            {
                ["class"] = "ACC2:CheckBox",
                ["text"] = "randomNameEnable",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink)
                    ACC2.AdvancedConfiguration["settings"] = {}

                    pnl:SetActive(tobool(ACC2.DefaultSettings["randomNameEnable"]))

                    pnl.OnChange = function(self, bChecked)
                        ACC2.AdvancedConfiguration["settings"]["randomNameEnable"] = bChecked
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:CheckBox",
                ["text"] = "disableLastName",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink)
                    ACC2.AdvancedConfiguration["settings"] = {}

                    pnl:SetActive(tobool(ACC2.DefaultSettings["disableLastName"]))

                    pnl.OnChange = function(self, bChecked)
                        ACC2.AdvancedConfiguration["settings"]["disableLastName"] = bChecked
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:CheckBox",
                ["text"] = "canRemoveWhenNotAllowed",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink)
                    ACC2.AdvancedConfiguration["settings"] = {}

                    pnl:SetActive(tobool(ACC2.DefaultSettings["canRemoveWhenNotAllowed"]))

                    pnl.OnChange = function(self, bChecked)
                        ACC2.AdvancedConfiguration["settings"]["canRemoveWhenNotAllowed"] = bChecked
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:CheckBox",
                ["text"] = "canSelectWhenNotAllowed",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink)
                    ACC2.AdvancedConfiguration["settings"] = {}

                    pnl:SetActive(tobool(ACC2.DefaultSettings["canSelectWhenNotAllowed"]))

                    pnl.OnChange = function(self, bChecked)
                        ACC2.AdvancedConfiguration["settings"]["canSelectWhenNotAllowed"] = bChecked
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:CheckBox",
                ["text"] = "deleteCharacterWhenDie",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink)
                    ACC2.AdvancedConfiguration["settings"] = {}

                    pnl:SetActive(tobool(ACC2.DefaultSettings["deleteCharacterWhenDie"]))

                    pnl.OnChange = function(self, bChecked)
                        ACC2.AdvancedConfiguration["settings"]["deleteCharacterWhenDie"] = bChecked
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:CheckBox",
                ["text"] = "enableSize",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink)
                    ACC2.AdvancedConfiguration["settings"] = {}

                    pnl:SetActive(tobool(ACC2.DefaultSettings["enableSize"]))

                    pnl.OnChange = function(self, bChecked)
                        ACC2.AdvancedConfiguration["settings"]["enableSize"] = bChecked
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:CheckBox",
                ["text"] = "enableCharacterDescription",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink)
                    ACC2.AdvancedConfiguration["settings"] = {}

                    pnl:SetActive(tobool(ACC2.DefaultSettings["enableCharacterDescription"]))

                    pnl.OnChange = function(self, bChecked)
                        ACC2.AdvancedConfiguration["settings"]["enableCharacterDescription"] = bChecked
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:CheckBox",
                ["text"] = "enableAge",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink)
                    ACC2.AdvancedConfiguration["settings"] = {}

                    pnl:SetActive(tobool(ACC2.DefaultSettings["enableAge"]))

                    pnl.OnChange = function(self, bChecked)
                        ACC2.AdvancedConfiguration["settings"]["enableAge"] = bChecked
                    end
                end,
            },
        },
        {
            {
                ["class"] = "DButton",
                ["text"] = "randomName",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetTextColor(ACC2.Colors["white100"])
                    pnl:SetFont("ACC2:Font:09")
                    
                    pnl.Paint = function(self, w, h)
                        pnl:SetText(ACC2.GetSentence("open"))
                        draw.RoundedBox(6, 0, 0, w, h, ACC2.Colors["white5"])

                        ACC2.AdvancedConfiguration["settings"]["randomName"] = ACC2.DefaultSettings["randomName"]
                    end

                    pnl.DoClick = function()
                        ACC2.AddOnTableConfig(ACC2.DefaultSettings["randomName"])         
                    end
                end,
            },
        },
        {
            {
                ["class"] = "DButton",
                ["text"] = "randomLastName",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetTextColor(ACC2.Colors["white100"])
                    pnl:SetFont("ACC2:Font:09")
                    
                    pnl.Paint = function(self, w, h)
                        pnl:SetText(ACC2.GetSentence("open"))
                        draw.RoundedBox(6, 0, 0, w, h, ACC2.Colors["white5"])

                        ACC2.AdvancedConfiguration["settings"]["randomLastName"] = ACC2.DefaultSettings["randomLastName"]
                    end

                    pnl.DoClick = function()
                        ACC2.AddOnTableConfig(ACC2.DefaultSettings["randomLastName"])         
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:TextEntry",
                ["text"] = "moneyWhenCreating",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetPlaceHolder(ACC2.DefaultSettings["moneyWhenCreating"])
                    pnl:SetRounded(6)
                    pnl.entry:SetNumeric(true)
    
                    pnl.entry.OnChange = function()
                        ACC2.AdvancedConfiguration["settings"]["moneyWhenCreating"] = tonumber(pnl:GetText())
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:TextEntry",
                ["text"] = "minSizeValue",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetPlaceHolder(math.Round(ACC2.DefaultSettings["minSizeValue"], 3))
                    pnl:SetRounded(6)
                    pnl.entry:SetNumeric(true)
    
                    pnl.entry.OnChange = function()
                        ACC2.AdvancedConfiguration["settings"]["minSizeValue"] = tonumber(pnl:GetText())
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:TextEntry",
                ["text"] = "maxSizeValue",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetPlaceHolder(math.Round(ACC2.DefaultSettings["maxSizeValue"], 3))
                    pnl:SetRounded(6)
                    pnl.entry:SetNumeric(true)
    
                    pnl.entry.OnChange = function()
                        ACC2.AdvancedConfiguration["settings"]["maxSizeValue"] = tonumber(pnl:GetText())
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:TextEntry",
                ["text"] = "maxSizeConvertion",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetPlaceHolder(ACC2.DefaultSettings["maxSizeConvertion"])
                    pnl:SetRounded(6)
                    pnl.entry:SetNumeric(true)
    
                    pnl.entry.OnChange = function()
                        ACC2.AdvancedConfiguration["settings"]["maxSizeConvertion"] = tonumber(pnl:GetText())
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:TextEntry",
                ["text"] = "minimumAge",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetPlaceHolder(ACC2.DefaultSettings["minimumAge"])
                    pnl:SetRounded(6)
                    pnl.entry:SetNumeric(true)
    
                    pnl.entry.OnChange = function()
                        ACC2.AdvancedConfiguration["settings"]["minimumAge"] = tonumber(pnl:GetText())
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:TextEntry",
                ["text"] = "maximumAge",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetPlaceHolder(ACC2.DefaultSettings["maximumAge"])
                    pnl:SetRounded(6)
                    pnl.entry:SetNumeric(true)
    
                    pnl.entry.OnChange = function()
                        ACC2.AdvancedConfiguration["settings"]["maximumAge"] = tonumber(pnl:GetText())
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:TextEntry",
                ["text"] = "minCharacterName",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetPlaceHolder(ACC2.DefaultSettings["minCharacterName"])
                    pnl:SetRounded(6)
                    pnl.entry:SetNumeric(true)
    
                    pnl.entry.OnChange = function()
                        ACC2.AdvancedConfiguration["settings"]["minCharacterName"] = tonumber(pnl:GetText())
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:TextEntry",
                ["text"] = "maxCharacterName",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetPlaceHolder(ACC2.DefaultSettings["maxCharacterName"])
                    pnl:SetRounded(6)
                    pnl.entry:SetNumeric(true)
    
                    pnl.entry.OnChange = function()
                        ACC2.AdvancedConfiguration["settings"]["maxCharacterName"] = tonumber(pnl:GetText())
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:TextEntry",
                ["text"] = "minCharacterLastName",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetPlaceHolder(ACC2.DefaultSettings["minCharacterLastName"])
                    pnl:SetRounded(6)
                    pnl.entry:SetNumeric(true)
    
                    pnl.entry.OnChange = function()
                        ACC2.AdvancedConfiguration["settings"]["minCharacterLastName"] = tonumber(pnl:GetText())
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:TextEntry",
                ["text"] = "maxCharacterLastName",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetPlaceHolder(ACC2.DefaultSettings["maxCharacterLastName"])
                    pnl:SetRounded(6)
                    pnl.entry:SetNumeric(true)
    
                    pnl.entry.OnChange = function()
                        ACC2.AdvancedConfiguration["settings"]["maxCharacterLastName"] = tonumber(pnl:GetText())
                    end
                end,
            },
        },
    },
    ["soundSettings"] = {
        {
            {
                ["class"] = "ACC2:CheckBox",
                ["text"] = "enableSoundMenu",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink)
                    ACC2.AdvancedConfiguration["settings"] = {}

                    pnl:SetActive(tobool(ACC2.DefaultSettings["enableSoundMenu"]))

                    pnl.OnChange = function(self, bChecked)
                        ACC2.AdvancedConfiguration["settings"]["enableSoundMenu"] = bChecked
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:TextEntry",
                ["text"] = "soundMenuLink",
                ["sizeX"] = 0.175,
                ["sizeY"] = 0.03,
                ["posX"] = 0.35,
                ["posY"] = 0.01, 
                ["func"] = function(pnl, panelLink)
                    pnl:SetText(ACC2.DefaultSettings["soundMenuLink"])
                    pnl:SetRounded(6)
    
                    pnl.entry.OnChange = function()
                        ACC2.AdvancedConfiguration["settings"]["soundMenuLink"] = pnl:GetText()
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:TextEntry",
                ["text"] = "soundMenuVolume",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetPlaceHolder(ACC2.DefaultSettings["soundMenuVolume"])
                    pnl:SetRounded(6)
                    pnl:SetNumeric(true)
    
                    pnl.entry.OnChange = function()
                        ACC2.AdvancedConfiguration["settings"]["soundMenuVolume"] = pnl:GetText()
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:CheckBox",
                ["text"] = "enableSoundCreated",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink)
                    ACC2.AdvancedConfiguration["settings"] = {}

                    pnl:SetActive(tobool(ACC2.DefaultSettings["enableSoundCreated"]))

                    pnl.OnChange = function(self, bChecked)
                        ACC2.AdvancedConfiguration["settings"]["enableSoundCreated"] = bChecked
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:TextEntry",
                ["text"] = "soundCreatedLink",
                ["sizeX"] = 0.175,
                ["sizeY"] = 0.03,
                ["posX"] = 0.35,
                ["posY"] = 0.01, 
                ["func"] = function(pnl, panelLink)
                    pnl:SetText(ACC2.DefaultSettings["soundCreatedLink"])
                    pnl:SetRounded(6)
    
                    pnl.entry.OnChange = function()
                        ACC2.AdvancedConfiguration["settings"]["soundCreatedLink"] = pnl:GetText()
                    end
                end,
            },
        },
        {
            {
                ["class"] = "ACC2:TextEntry",
                ["text"] = "soundCreatedVolume",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetPlaceHolder(ACC2.DefaultSettings["soundCreatedVolume"])
                    pnl:SetRounded(6)
                    pnl:SetNumeric(true)
    
                    pnl.entry.OnChange = function()
                        ACC2.AdvancedConfiguration["settings"]["soundCreatedVolume"] = pnl:GetText()
                    end
                end,
            },
        },
    },
}

function ACC2.AddToConfigCompatibilities()
    local compatibilities = {}

    if CharacterCreator then
        compatibilities[#compatibilities + 1] = {
            {
                ["class"] = "DButton",
                ["text"] = "importDataOfCharacter",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetTextColor(ACC2.Colors["white100"])
                    pnl:SetFont("ACC2:Font:09")
                    
                    pnl.Paint = function(self, w, h)
                        pnl:SetText(ACC2.GetSentence("import"))
                        draw.RoundedBox(6, 0, 0, w, h, ACC2.Colors["white5"])
                    end
    
                    pnl.DoClick = function()
                        RunConsoleCommand("acc2_import_charactercreator")
                    end
                end,
            },
        }
    end

    if Aden_DC then
        compatibilities[#compatibilities + 1] = {
            {
                ["class"] = "DButton",
                ["text"] = "importDataOfAden",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetTextColor(ACC2.Colors["white100"])
                    pnl:SetFont("ACC2:Font:09")
                    
                    pnl.Paint = function(self, w, h)
                        pnl:SetText(ACC2.GetSentence("import"))
                        draw.RoundedBox(6, 0, 0, w, h, ACC2.Colors["white5"])
                    end
    
                    pnl.DoClick = function()
                        RunConsoleCommand("acc2_import_adencharacter")
                    end
                end,
            },
        }
    end
    
    if VoidChar then
        compatibilities[#compatibilities + 1] = {
            {
                ["class"] = "DButton",
                ["text"] = "importDataOfVoidChar",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink)
                    pnl:SetTextColor(ACC2.Colors["white100"])
                    pnl:SetFont("ACC2:Font:09")
                    
                    pnl.Paint = function(self, w, h)
                        pnl:SetText(ACC2.GetSentence("import"))
                        draw.RoundedBox(6, 0, 0, w, h, ACC2.Colors["white5"])
                    end
    
                    pnl.DoClick = function()
                        RunConsoleCommand("acc2_import_voidcharacter")
                    end
                end,
            },
        }
    end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198931466969

    ACC2.ParametersConfig["transfertSettings"] = compatibilities
end

timer.Simple(2, function()
    ACC2.AddToConfigCompatibilities()
end)


ACC2.ParametersConfig["buttonsSettings"] = {}
for i=1, 4 do
    ACC2.ParametersConfig["buttonsSettings"][#ACC2.ParametersConfig["buttonsSettings"] + 1] = {
        {
            ["class"] = "ACC2:CheckBox",
            ["text"] = "buttonsEnable"..i,
            ["sizeX"] = 0.02,
            ["sizeY"] = 0.02,
            ["posX"] = 0.51,
            ["posY"] = 0.015,
            ["func"] = function(pnl, panelLink)
                ACC2.AdvancedConfiguration["settings"] = {}

                pnl:SetActive(tobool(ACC2.DefaultSettings["buttonsEnable"..i]))

                pnl.OnChange = function(self, bChecked)
                    ACC2.AdvancedConfiguration["settings"]["buttonsEnable"..i] = bChecked
                end
            end,
        },
    }
    ACC2.ParametersConfig["buttonsSettings"][#ACC2.ParametersConfig["buttonsSettings"] + 1] = {
        {
            ["class"] = "ACC2:TextEntry",
            ["text"] = "buttonsLinks"..i,
            ["sizeX"] = 0.175,
            ["sizeY"] = 0.03,
            ["posX"] = 0.35,
            ["posY"] = 0.01,
            ["func"] = function(pnl, panelLink)
                pnl:SetText(ACC2.DefaultSettings["buttonsLinks"..i])
                pnl:SetRounded(6)

                pnl.entry.OnChange = function()
                    ACC2.AdvancedConfiguration["settings"]["buttonsLinks"..i] = pnl:GetText()
                end
            end,
        },
    }
    ACC2.ParametersConfig["buttonsSettings"][#ACC2.ParametersConfig["buttonsSettings"] + 1] = {
        {
            ["class"] = "ACC2:TextEntry",
            ["text"] = "buttonsImage"..i,
            ["sizeX"] = 0.175,
            ["sizeY"] = 0.03,
            ["posX"] = 0.35,
            ["posY"] = 0.01, 
            ["func"] = function(pnl, panelLink)
                pnl:SetText(ACC2.DefaultSettings["buttonsImage"..i])
                pnl:SetRounded(6)

                pnl.entry.OnChange = function()
                    ACC2.AdvancedConfiguration["settings"]["buttonsImage"..i] = pnl:GetText()
                end
            end,
        },
    }
end


--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
