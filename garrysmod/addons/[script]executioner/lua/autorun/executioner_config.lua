    --[[
        Script: Executioner
        Developer: ted.lua
        Profile: http://steamcommunity.com/id/tedlua/
    ]]

    Executioner = Executioner or {}
    Executioner.Config = Executioner.Config or {}

    Executioner.Config.Placement = {}
    Executioner.Config.Confirmation = {}
    Executioner.Config.Bonus = {}
    Executioner.Config.Phone = {}
    Executioner.Config.Language = {}

    ---------------------------------
    --> Start of Server Settings <---
    ---------------------------------

    Executioner.Config.Developer_Mode = false

    --> Language Support <--
    -- Languages Supported: english, dutch, norwegian
    Executioner.Config.Language.Choice = 'russian'

    Executioner.Config.ChatPrefix = '[Disfulverse.Executioner] '
    Executioner.Config.PrefixColor = Color( 255, 255, 255 )

    Executioner.Config.Phone_Command = '!requests'
    Executioner.Config.Phone_Save = '!save_phones'
    Executioner.Config.Reset_Phones = '!reset_phones'
    Executioner.Config.Cancel_Hit = '!cancel_hit'

    Executioner.Config.Hitman_Teams = { -- These are your Hitman teams. Use the name of the job you want as a Hitman (case sensitive)
        [ 'Наёмник-Мародер' ] = true,
        [ 'Хакер-взломщик' ] = true,
        [ 'Оператор ЧВК [Dis+]' ] = true
    }

    Executioner.Config.Banned_Groups = { -- Which groups can not have a hit placed against them?
        [ 'superadmin' ] = true,
        [ 'owner' ] = false
    }

    Executioner.Config.No_Place_Teams = { -- These can still have a hit against them, but they not place hits at all.
        ['Патрульная полиция'] = true,
        ['Спецназ CTSFO'] = true,
        ['Отдел Disag [Dis+]'] = true, 
        ['Детектив'] = true,
        ['Администратор города'] = true,
        ['Отдел Безопасности [Dis+]'] = true,
        ['Отдел поддержки [ADM]'] = true,
    }

    Executioner.Config.BlackList_Teams = { -- Which teams can not have a hit placed against them? These teams also can't use the Phone.
        --[ 'Gun Dealer' ] = true,
        --[ 'Staff on Duty' ] = true,
        --[ 'Mob boss' ] = true
    }

    Executioner.Config.Clean_Ranks = { -- Translates a usergroup into a nicer string for the first interface.
        [ 'superadmin' ] = 'Super Administrator', [ 'admin' ] = 'Administrator', [ 'moderator' ] = 'Moderator',
        [ 'helper' ] = 'Helper', [ 'user' ] = 'User'
    }

    --[[
        Bonus Weapons are removed when the Hitman has attempted the hit.
        You can put anything in here, as long as it's capable of killing someone.
        Dildo Launcher, frying pan, whatever the fuck you want.
    --]]
    Executioner.BonusWeapons = {
        --{ name = 'Glock 18', ent = 'fas2_glock20' },
       -- { name = 'Revolver', ent = 'fas2_ragingbull' },
        --{ name = 'MP5', ent = 'fas2_mp5a5' },
        --{ name = 'AK-47', ent = 'fas2_ak47' },
        --{ name = 'SR-25', ent = 'fas2_sr25' },
        --{ name = 'M4A1', ent = 'fas2_m4a1' },
       -- { name = 'M82', ent = 'fas2_m82' },
        --{ name = 'SG 552', ent = 'fas2_sg552' }
    }

    Executioner.Config.BonusChance = 25 -- The chance 1 - 100% that a Hitman is offered a bonus.
    Executioner.Config.BonusMoney = 2500 -- How much money is given on a bonus hit? From a bonus weapon
    Executioner.Config.TaxOnKill = 0 -- What percentage is taken when a hit is completed? 0 to disable.

    Executioner.Config.Max_Hit_Price = 30000 -- The maximum price the customer can place
    Executioner.Config.Min_Hit_Price = 5000 -- The minimum price the customer can place

    Executioner.Config.PhoneEnabled = true -- If this enabled, you may only place hits via the phone.
    Executioner.Config.Enable_Face_To_Face = false -- Can people place hits on a Hitman by pressing 'E'?

    Executioner.Config.EnableDistance = true -- Enable a Distance tracker for the Hitman to see?
    Executioner.Config.EnableHitTime = true -- Enable random time limits the hit must be done in?
    Executioner.Config.EnableHitGeneration = false -- Enable random hits? (Now works for both face to face and phone hits)

    Executioner.Config.EnableUTimeSupport = false -- Enable uTime support?
    Executioner.Config.Min_Play_Time = 4 -- Minimum time until a hit can be placed on them? (In hours)

    Executioner.Config.Hit_Time_Min = 60 -- (Seconds). Default: Start at a minimum of 60 seconds
    Executioner.Config.Hit_Time_Max = 300 --(Seconds). Default: Max of 300 seconds

    Executioner.Config.RangeDistance = 1200 -- The distance before distance turns into ???? (Too close)
    Executioner.Config.HitCooldown = 45 * 5 -- How long must the customer place before placing another Hit?
    Executioner.Config.Grace_Cooldown = 50 * 10 -- How long until a hit can be placed on the same person?
    Executioner.Config.Draw_Info = true -- When close to a Hitman, show that they're a hitman and their status?

    Executioner.Config.Generate_Hit_Intervals = 60 * 15 -- How long for a hit to be placed? In seconds?
    Executioner.Config.Generate_Remove_Time = 60 * 40 -- How long until a hit is removed as nobody has taken it?
    Executioner.Config.Minimum_Players = 5 -- How many people need to be on the server for a random hit to take place?
    -- This number also required a hitman to be on the server, with no active hit.
    --------------------------------
    --> Start of Client Settings <--
    --------------------------------
    --> Interface Settings <--
    Executioner.Config.ResponseTime = 60 -- How long does the Hitman have to reply to a Hit that a customer has directly requested? (Seconds)
    Executioner.Config.BonusTime = 15 -- How long does the Hitman have to accept the Bonus Weapon Offer?
    Executioner.Config.MenuSounds = true -- Do you want there to be sounds in the interfaces?
    Executioner.Config.GlobalAlpha = 255 -- The Alpha of all the interfaces.
    Executioner.Config.Name_Colors = Color( 255, 255, 255 ) -- The color of all the names.
    Executioner.Config.EnableBlur = false -- Enable blur on all of the interfaces?
    Executioner.Config.Component_Colors = { -- All the colors for components. Normal = default look, no hover. Hover = color on hover, text = color of text.
        [ 'button_request' ] = { normal = Color( 22, 22, 22 ), hover = Color( 18, 18, 18 ), text = Color( 255, 255, 255 ) },
        [ 'button_accept' ] = { normal = Color(99, 99, 225), hover = Color( 204, 78, 78 ), text = Color( 255, 255, 255 ) },
        [ 'button_deny' ] = { normal = Color(129, 129, 252), hover = Color( 230, 32, 25 ), text = Color( 255, 255, 255 ) },
        [ 'hit_price_entry' ] = { normal = Color( 22, 22, 22 ), hover = Color( 18, 18, 18 ), text = Color( 255, 255, 255, 200 ) },
        [ 'health_armor_display' ] = { -- This is a bit of a bitch.
            barBackground = Color( 22, 22, 22 ),
            healthBar = Color( 232, 56, 71, 200 ),
            armorBar = Color( 79, 112, 111 ),
            outline = Color( 24, 24, 24 ),
            healthColor = Color( 255, 255, 255 ),
            armorColor = Color( 255, 255, 255 )
        }
    }
    Executioner.Config.GroupConfiguration = { -- Rank colors in the menu.
        [ 'superadmin' ] = Color( 200, 0, 0 ),
        [ 'admin' ] = Color( 155, 89, 182 )
    }
    Executioner.Config.Outline_Colors = Color( 42, 42, 42, 200 ) -- This will change the outline of every grey outline.
    Executioner.Config.Main_Text_Color = Color( 52, 152, 219 )
    ---------------------------------------------
    --> Start of Placement Menu Configuration <--
    ---------------------------------------------
    --> Strings <--
    Executioner.Config.Placement.Main_Title = 'Меню заказов'
    Executioner.Config.Placement.No_Preview = 'Выберите цель'
    Executioner.Config.Placement.Request_Hit = 'Заказать цель'
    --> Colors <--
    Executioner.Config.Placement.Background = Color(33, 33, 33, 250)
    Executioner.Config.Placement.Main_Title_Color = Color( 255, 255, 255 )
    Executioner.Config.Placement.ModelBackColor = Color(42, 42, 42, 250) --disfulversed
    Executioner.Config.Placement.Split_Bar = Color( 42, 42, 42, 240 ) -- The line down the middle of the first screen.
    Executioner.Config.Placement.No_Preview_Color = Color( 255, 255, 255 )
    ---------------------------------------------------------------------
    -- mainColor = the default color in row renders. onSecond = for every set of 2 use this color..
    Executioner.Config.Placement.Row_Hovers = { mainColor = Color( 48, 47, 49, 245 ), onSecond = Color( 48, 47, 49, 245 ) }
    Executioner.Config.Placement.Data_Canvis_Color = Color( 28, 28, 28, 220 )
    ------------------------------------------------
    --> Start of Confirmation Menu Configuration <--
    ------------------------------------------------
    --> Strings <--
    Executioner.Config.Confirmation.Main_Title = 'Меню заказов'
    Executioner.Config.Confirmation.Header_Title = 'Вам предложили убить: '
    Executioner.Config.Confirmation.Accept_Hit = 'Принять заказ'
    Executioner.Config.Confirmation.Deny_Hit = 'Отменить заказ'
    --> Colors <--
    Executioner.Config.Confirmation.Background = Color(33, 33, 33, 250)
    Executioner.Config.Confirmation.Main_Title_Color = Color( 255, 255, 255 )
    Executioner.Config.Confirmation.Data_Canvis_Color = Color( 28, 28, 28, 220 )
    Executioner.Config.Confirmation.Money_Bar_Color = Color( 20, 20, 20 )
    Executioner.Config.Confirmation.Money_Text_Color = Color( 46, 204, 113 )
    -----------------------------------------
    --> Start of Bonus Menu Configuration <--
    -----------------------------------------
    --> Strings <--
    Executioner.Config.Bonus.Main_Title = 'Предложение бонусного оружия'
    Executioner.Config.Bonus.Header = 'Загадка'
    Executioner.Config.Bonus.Description = 'Убейте цель используя это для доп. награды'
    Executioner.Config.Bonus.Detail = 'Оружие выдано на время заказа'
    Executioner.Config.Bonus.Accept_Offer = 'Принять предложение'
    Executioner.Config.Bonus.Deny_Offer = 'Отклонить предложение'
    --> Colors <--
    Executioner.Config.Bonus.Background = Color( 8, 8, 8, 240 )
    Executioner.Config.Bonus.Header_Color = Color( 156, 136, 255 )
    Executioner.Config.Bonus.Description_Color = Color( 255, 255, 255 )
    Executioner.Config.Bonus.Detail_Color = Color( 255, 255, 255 )
    -----------------------------------------
    --> Start of Phone Menu Configuration <--
    -----------------------------------------
    --> Strings <--
    Executioner.Config.Phone.Main_Title = 'Активные заказы'
    Executioner.Config.Phone.Text_On_Entity = 'Телефонная будка'
    Executioner.Config.Phone.Target = 'Цель: '
    Executioner.Config.Phone.Customer = 'Заказчик: '
    Executioner.Config.Phone.Price = 'Цена: '
    --> Colors <--
    Executioner.Config.Phone.Background = Color( 15,15,15,235 )
    Executioner.Config.Phone.Main_Title_Color = Color( 255, 255, 255 )
    Executioner.Config.Phone.Data_Canvis_Color = Color( 28, 28, 28, 220 )

    -----------------------------------------
    --> Start of Hitman HUD Conifguration <--
    -----------------------------------------
    --> Strings <--
    --> The panel on the right of the screen for Hitmen when they have an active hit <--
    -- Target: inherts from Executioner.Config.Phone.Target --
    Executioner.Config.Occupation = 'Профессия: '
    Executioner.Config.Time_Left = 'Оставшееся время: '
    Executioner.Config.Active_Hit = 'Активный заказ'
    Executioner.Config.Distance_Text = 'Расстояние'
    ----------------------------------------------------------
    Executioner.Config.Background = Color( 60, 60, 60, 220 )
    Executioner.Config.Foreground = Color( 8, 8, 8, 220 )
    Executioner.Config.Main_Title_Color = Color( 255, 255, 255 )
    Executioner.Config.HUD_Outline = Color( 30, 30, 30, 245 )
    --> The text which appears in the middle of the screen <--
    Executioner.Config.Hit_Completed = 'Заказ выполнен'
    Executioner.Config.Hit_Completed_Color = Color( 255, 255, 255 )
    --> The Text which appears when looking at a Hitman <--
    Executioner.Config.Hitman_Text = ''
    Executioner.Config.Busy_Text = ''
    Executioner.Config.Request_Hit_Text = ''
    --> The Green color is taken from the Money Green <--
    -- Executioner.Config.Confirmation.Money_Text_Color -
    -----------------------------------------------------
