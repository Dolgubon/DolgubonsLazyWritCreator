-----------------------------------------------------------------------------------
-- Addon label: Dolgubon's Lazy Writ Crafter
-- Creator: Dolgubon (Joseph Heinzle)
-- Addon Ideal: Simplifies Crafting Writs as much as possible
-- Addon Creation Date: March 14, 2016
--
-- File label: AlchGrab.lua
-- File Description: This file removes items required for writs from the bank
-- Load Order Requirements: None
-- 
-----------------------------------------------------------------------------------


WritCreater = WritCreater or {}


WritCreater.settings["panel"] =  
{
     type = "panel",
     label = "Lazy Writ Crafter",
     displaylabel = "|c8080FF Dolgubon's Lazy Writ Crafter|r",
     author = "@Dolgubon",
     registerForRefresh = true,
     registerForDefaults = true,
     resetFunction = WritCreater.resetSettings,
     donation = "https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=7CZ3LW6E66NAU"

}

local craftingHouses = 
{
    ["XB1live-eu"] = 
            {{displayName = "@Blackswan20022" , houseId = 116, greeting = "Welcome to the Highlanders Might Guild Hall",
        subHeading = "Stations are located directly by entrance.", chatMessage = "Like their guild house and want to join? Check them out here: |H1:guild:303060|hHighlanders Might|h|h",},
        {displayName = "@Darhysh" , houseId = 18, greeting = "Welcome to Wizard’s Emporium",
        subHeading = "Stations are located at entrance.", chatMessage = "Like their guild house and want to join? Check them out here: |H1:guild:289124|hWizard's Emporium|h",},},
    ["XB1live"] = {
        {displayName = "@J3zdaz", houseId = 46, greeting = "J3’s Craft Hub",
        subHeading = "Stations at front, to the right.", chatMessage = "Like their guild house and want to join? Check them out here: |H1:guild:1218717|hRebels Reign|h"},
        {displayName = "@Razberry9876" , houseId = 18, greeting = "Welcome to the Master Writ Pit!",
        subHeading = "Stations in front entry area.",},
        {displayName = "@MisfitOfSith" , houseId = 62, greeting = "Welcome to the Tarnished Architect's Guild House! Feel free to craft to your heart's content with your fellow housing nerds.",
        subHeading = "Inside house, in grand hall.", chatMessage = "Like their guild house and want to join? Check them out here: |H1:guild:1111961|hTarnished Architects|h"},},
    ["PS4live"] = 
        {{displayName = "@bat_girl77" , houseId =  55, greeting = "Welcome to bat’s Craft House!",
        subHeading = "Stations are located by front entrance.", chatMessage = "Like their guild house and want to join? Check them out here: |H1:guild:908761|hDecor and Design|h|h",},
        {displayName = "@b3ast03101978" , houseId = 21,  greeting = "B3astly Builds Headquarters",
        subHeading = "Stations are located in outside area.",},},
    ["PS4live-eu"] = 
         {{displayName = "@NocturnaStrix" , houseId = 102, greeting = "Welcome, traveler. The veil grows thin tonight.",
        subHeading = "Stations are located on the left side of the stairs at entrance.",},
        {displayName = "@Festegios" , houseId =  90, greeting = "Welcome to Renegade Jesters Guild House",
        subHeading = "Stations are located on the left.",}, 
        {displayName = "@Ettena_" , houseId =  99 , greeting = "Welcome to The Hex Pistols Craft Hub",
        subHeading = "Stations are to the left around the corner.", chatMessage = "Like their guild house and want to join? Check them out here: |H1:guild:382160|hThe Hex Pistols|h|h",},},
    ["NA Megaserver"] = 
    {
        {displayName = "@xGAMxHQ", houseId = 71, greeting = "Welcome to Moon's Edge's guild house!", subheading = "Stations straight ahead", 
            chatMessage = "Like their guild house and want to join? Check them out here: |H1:guild:391101|hMoon's Edge|h"},
        {displayName = "@Amrayia", houseId = 71, greeting = "Welcome to Auction House Central's guild house!", subheading = "Stations straight ahead", 
            chatMessage = "Like their house? Join AHC in Alinor - where friendly traders thrive. Check it out here: |H1:guild:370167|hAuction House Central|h"},
        {displayName = "@Kelinmiriel", houseId = 40, greeting = "Welcome to Kelinmiriel's house!", subheading = "Stations to your left", chatMessage = ""},
        {displayName = "@AuctionsBMW", houseId = 62, greeting = "Welcome to Black Market Wares' guild house!", subheading = "Stations to your left", 
            chatMessage ="Like their guild house and want to join? Check them out here: |H1:guild:1427|hBlack Market Wares|h"},
    },
    ["EU Megaserver"] = 
    {
        {displayName = "@JN_Slevin", houseId = 56, greeting = "Welcome to JNSlevin's house!", subheading = "Stations to the left", 
            chatMessage = "Welcome to the Independent Trading Team [ITT]'s guild house! if you find yourself in need of a "..
        "trading guild please join discord.gg/itt or contact @JN_Slevin, @LouAnja or @RichestGuyinESO. From Mournhold to Alinor we have a space for every every type of trader you might be!"},
        {displayName = "@Ek1", houseId = 66, greeting = "Welcome to Ek1's house!", subheading = "Stations right here!", chatMessage = ""},
    }
}


---Join AHC in Alinor - where traders thrive in a friendly community. Check it out here: |H1:guild:370167|hAuction House Central|h
-- Like their guild house? Join AHC in Alinor here: |H1:guild:370167|hAuction House Central|h
-- Like their house? Join AHC in Alinor - where friendly traders thrive. Check it out here: |H1:guild:370167|hAuction House Central|h
--GetCurrentHouseOwner()
-- GetCurrentZoneHouseId()
local houseToUse
local function displayGreeting(greeting, subHeading)
    local messageParams = CENTER_SCREEN_ANNOUNCE:CreateMessageParams(CSA_CATEGORY_LARGE_TEXT)
    messageParams:SetText(greeting, subHeading)
    CENTER_SCREEN_ANNOUNCE:AddMessageWithParams(messageParams)
end

local function welcomePlayerToHouse()
    if houseToUse and GetCurrentHouseOwner() == houseToUse.displayName and GetCurrentZoneHouseId()==houseToUse.houseId then
        displayGreeting(houseToUse.greeting, houseToUse.subheading)
        if houseToUse.chatMessage and houseToUse.chatMessage~="" then
            d(houseToUse.chatMessage)
        end
        houseToUse = nil
        EVENT_MANAGER:UnregisterForEvent(WritCreater.name.."_houseWelcome", EVENT_PLAYER_ACTIVATED )
    end
end

function WritCreater.portToCraftingHouse()
    if GetWorldName()=="PTS" then 
        return
    end
    if not craftingHouses[GetWorldName()] then return end -- no houses available :(
    houseToUse = craftingHouses[GetWorldName()][math.random(1, #craftingHouses[GetWorldName()] ) ]
    JumpToSpecificHouse(houseToUse.displayName, houseToUse.houseId)
    EVENT_MANAGER:RegisterForEvent(WritCreater.name.."_houseWelcome", EVENT_PLAYER_ACTIVATED , welcomePlayerToHouse)
end


function WritCreater.initializeSettingsMenu()
    WritCreater.generateHASConversions()
    local LHA = LibHarvensAddonSettings
    local options = {
        -- allowDefaults = true, --will allow users to reset the settings to default values
        allowRefresh = true, --if this is true, when one of settings is changed, all other settings will be checked for state change (disable/enable)
        defaultsFunction = function() --this function is called when allowDefaults is true and user hit the reset button
            d("Reset")
        end,
    }
    local settingsMenuName = "|c8080FFDolgubon's Lazy Writ Crafter|r"
    if GetDisplayName() == "@Dolgubon" then
        settingsMenuName = "|c8080FFDolgubon's 1 Lazy Writ Crafter|r"
    end
    -- settings.version = panel.version
    local settings = LHA:AddAddon(settingsMenuName, options)
    if not settings then
        return
    end
    settings.author = "Dolgubon"
    WritCreater.consoleSettingsMenu = settings
    local areSettingsDisabled = false
 
    --[[
        CHECKBOX
    --]]
    local checked = false
    -- Long, so that hopefully the various hide callLaters won't overlap
    local statusBarSampleTimeout = 20000

    local options =  {
        {
            type = LHA.ST_BUTTON,
            label = "Report a Bug",
            tooltip = "Open a thread to report bugs specifically with the console version of writ crafter. Please check to make sure the issue hasn't been reported yet.",
            buttonText = "Open URL",
            clickHandler = function(control, button)
                WritCreater.showQRCode("https://www.esoui.com/forums/showthread.php?t=11241")
            end,
            -- disable = function() return areSettingsDisabled end,
        },
        {
            type = LHA.ST_BUTTON,
            label = "Donate",
            tooltip = "Donate to Dolgubon on Paypal",
            buttonText = "Open URL",
            clickHandler = function(control, button)
                WritCreater.showQRCode("https://www.paypal.com/donate/?cmd=_s-xclick&hosted_button_id=7CZ3LW6E66NAU&ssrt=1747363295246")
            end,
            -- disable = function() return areSettingsDisabled end,
        },
        {
            type = LHA.ST_BUTTON,
            label = "Writ Stats",
            tooltip = "View historical writ reward statistics of writs done with the addon installed",
            buttonText = "Open Window",
            clickHandler = function(control, button)
                WritCreater.ShowStatsWindow(false)
            end,
            -- disable = function() return areSettingsDisabled end,
        },
        {
            type = LHA.ST_BUTTON,
            label = "Queue all sealed writs",
            tooltip = "Queue all sealed writs in your inventory. Does not queue Alchemy sealed writs",
            buttonText = "Queue",
            clickHandler = function(control, button)
                WritCreater.queueAllSealedWrits(BAG_BACKPACK)
            end,
            -- disable = function() return areSettingsDisabled end,
        },
        {
            type = LHA.ST_BUTTON,
            label = "Port to crafting house",
            tooltip = "Port to a publicly available crafting house",
            buttonText = "Port",
            clickHandler = function(control, button)
                WritCreater.portToCraftingHouse()
            end,
            -- disable = function() return areSettingsDisabled end,
        },
        {
            type = LHA.ST_SECTION,
            label = function() 
                local profile = WritCreater.optionStrings.accountWide
                if WritCreater.savedVars.useCharacterSettings then
                    profile = WritCreater.optionStrings.characterSpecific
                end
                return  string.format(WritCreater.optionStrings.nowEditing, profile)  
            end, 
        },
        {
            type = LHA.ST_CHECKBOX,
            label = WritCreater.optionStrings.useCharacterSettings,
            tooltip = WritCreater.optionStrings.useCharacterSettingsTooltip,
            getFunction = function() return WritCreater.savedVars.useCharacterSettings end,
            setFunction = function(value)
                WritCreater.savedVars.useCharacterSettings = value
                WritCreater.consoleSettingsMenu:UpdateControls()
            end,
        },
        {
            type = LHA.ST_SECTION,
            label = "Main Settings", 
        },
        -- {
        --     type = "divider",
        --     height = 15,
        --     alpha = 0.5,
        --     width = "full",
        -- },
        WritCreater.lamConvertedOptions[WritCreater.optionStrings.autocraft],
        WritCreater.lamConvertedOptions[WritCreater.optionStrings.stealingProtection],
        WritCreater.lamConvertedOptions[WritCreater.optionStrings["writ grabbing"]],
        WritCreater.lamConvertedOptions[WritCreater.optionStrings.suppressQuestAnnouncements],

        {
            type =  LibHarvensAddonSettings.ST_DROPDOWN,
            label = WritCreater.optionStrings['dailyResetWarnType'],
            tooltip = WritCreater.optionStrings['dailyResetWarnTypeTooltip'],
            choices = WritCreater.optionStrings["dailyResetWarnTypeChoices"],
            choicesValues = {"none","announcement","alert","chat","all"},
            items = {
                {
                    name = WritCreater.optionStrings["dailyResetWarnTypeChoices"][1],
                    data = "none",
                },
                {
                    name = WritCreater.optionStrings["dailyResetWarnTypeChoices"][2],
                    data = "announcement",
                },
                {
                    name = WritCreater.optionStrings["dailyResetWarnTypeChoices"][3],
                    data = "alert",
                },
                {
                    name = WritCreater.optionStrings["dailyResetWarnTypeChoices"][4],
                    data = "chat",
                },
            },
            getFunction = function()
                -- Do I like this? No. Is it a simple and fast way? Yes.
                local labelMap = 
                {
                    ["none"] = WritCreater.optionStrings["dailyResetWarnTypeChoices"][1],
                    ["announcement"] = WritCreater.optionStrings["dailyResetWarnTypeChoices"][2],
                    ["alert"] = WritCreater.optionStrings["dailyResetWarnTypeChoices"][3],
                    ["chat"] = WritCreater.optionStrings["dailyResetWarnTypeChoices"][4],
                }

                return labelMap[WritCreater:GetSettings().dailyResetWarnType] end,
            setFunction = function(combobox, label, item)
                WritCreater:GetSettings().dailyResetWarnType = item.data 
                WritCreater.showDailyResetWarnings("Example") -- Show the example warnings
            end
        },
        WritCreater.lamConvertedOptions[WritCreater.optionStrings.dailyResetWarnTime],
        {
            type = LHA.ST_CHECKBOX,
            label = WritCreater.optionStrings["master"],
            tooltip = WritCreater.optionStrings["master tooltip"],
            getFunction = function() return WritCreater.savedVarsAccountWide.masterWrits end,
            setFunction = function(value) 
            WritCreater.savedVarsAccountWide.masterWrits = value
            WritCreater.LLCInteraction:cancelItem()
                if value  then
                    for i = 1, 25 do WritCreater.MasterWritsQuestAdded(1, i,GetJournalQuestName(i)) end
                else
                    d("Master Writ crafting queue cleared")
                end
            end,
        },
        WritCreater.lamConvertedOptions[WritCreater.optionStrings["jubilee"]],
        -- {
        --     type = LHA.ST_CHECKBOX,
        --     label = WritCreater.optionStrings["right click to craft"],
        --     tooltip = WritCreater.optionStrings["right click to craft tooltip"],
        --     getFunction = function() return WritCreater.savedVarsAccountWide.rightClick end,
        --     disable = not LibCustomMenu or WritCreater.savedVarsAccountWide.rightClick,
        --     warning = "This option requires LibCustomMenu",
        --     setFunction = function(value) 
        --     WritCreater.savedVarsAccountWide.masterWrits = not value
        --     WritCreater.savedVarsAccountWide.rightClick = value
        --     WritCreater.LLCInteraction:cancelItem()
        --         if not value  then
                    
        --             for i = 1, 25 do WritCreater.MasterWritsQuestAdded(1, i,GetJournalQuestlabel(i)) end
        --         end
        --     end,
        -- },
        {
            type = LHA.ST_SECTION,
            label = WritCreater.optionStrings["timesavers submenu"],
        },
        WritCreater.lamConvertedOptions[WritCreater.optionStrings["automatic complete"]],
        WritCreater.lamConvertedOptions[WritCreater.optionStrings.autoCloseBank],
        WritCreater.lamConvertedOptions[WritCreater.optionStrings.despawnBanker],
        WritCreater.lamConvertedOptions[WritCreater.optionStrings.despawnBankerDeposit],
        WritCreater.lamConvertedOptions[WritCreater.optionStrings["exit when done"]],
        WritCreater.lamConvertedOptions[WritCreater.optionStrings["autoloot behaviour"]],

        -- {
        --     type = "dropdown",
        --     label = WritCreater.optionStrings["autoloot behaviour"]  ,
        --     tooltip = WritCreater.optionStrings["autoloot behaviour tooltip"],
        --     choices = WritCreater.optionStrings["autoloot behaviour choices"],
        --     choicesValues = {1,2,3},
        --     getFunction = function() if not WritCreater:GetSettings().ignoreAuto then return 1 elseif WritCreater:GetSettings().autoLoot then return 2 else return 3 end end,
        --     setFunction = function(value) 
        --         if value == 1 then 
        --             WritCreater:GetSettings().ignoreAuto = false
        --         elseif value == 2 then  
        --             WritCreater:GetSettings().autoLoot = true
        --             WritCreater:GetSettings().ignoreAuto = true
        --         elseif value == 3 then
        --             WritCreater:GetSettings().ignoreAuto = true
        --             WritCreater:GetSettings().autoLoot = false
        --             WritCreater:GetSettings().lootContainerOnReceipt  = false
        --         end
        --     end,
        -- },
        WritCreater.lamConvertedOptions[WritCreater.optionStrings["loot container"]],
        WritCreater.lamConvertedOptions[WritCreater.optionStrings["new container"]],
        WritCreater.lamConvertedOptions[WritCreater.optionStrings["master writ saver"]],
        WritCreater.lamConvertedOptions[WritCreater.optionStrings["loot output"]],
        WritCreater.lamConvertedOptions[WritCreater.optionStrings.reticleColour],
        WritCreater.lamConvertedOptions[WritCreater.optionStrings.questBuffer],
        WritCreater.lamConvertedOptions[WritCreater.optionStrings.craftMultiplier],
        WritCreater.lamConvertedOptions[WritCreater.optionStrings.smartMultiplier],
        WritCreater.lamConvertedOptions[WritCreater.optionStrings.craftMultiplierConsumables],


        -- {
        --     type = LHA.ST_CHECKBOX,
        --     label = WritCreater.optionStrings['noDELETEConfirmJewelry'],
        --     tooltip = WritCreater.optionStrings['noDELETEConfirmJewelryTooltip'],
        --     getFunction = function() return  WritCreater:GetSettings().EZJewelryDestroy end,
        --     setFunction = function(value) 
        --         WritCreater:GetSettings().EZJewelryDestroy = value
        --     end,
        -- },
        WritCreater.lamConvertedOptions[WritCreater.optionStrings["hireling behaviour"]],
        {
            type = "dropdown",
            label = WritCreater.optionStrings["hireling behaviour"]  ,
            tooltip = WritCreater.optionStrings["hireling behaviour tooltip"],
            choices = WritCreater.optionStrings["hireling behaviour choices"],
            choicesValues = {1,2,3},
            getFunction = function() if WritCreater:GetSettings().mail.delete then return 2 elseif WritCreater:GetSettings().mail.loot then return 3 else return 1 end end,
            setFunction = function(value) 
                if value == 1 then 
                    WritCreater:GetSettings().mail.delete = false
                    WritCreater:GetSettings().mail.loot = false
                elseif value == 2 then  
                    WritCreater:GetSettings().mail.delete = true
                    WritCreater:GetSettings().mail.loot = true
                elseif value == 3 then
                    WritCreater:GetSettings().mail.delete = false
                    WritCreater:GetSettings().mail.loot = true
                end
            end,
        },
        WritCreater.lamConvertedOptions[WritCreater.optionStrings["scan for unopened"]],
        {
            type = LHA.ST_SECTION,
            label = WritCreater.optionStrings["status bar submenu"],
        },
        WritCreater.lamConvertedOptions[WritCreater.optionStrings.showStatusBar],
        WritCreater.lamConvertedOptions[WritCreater.optionStrings.statusBarInventory],
        WritCreater.lamConvertedOptions[WritCreater.optionStrings.statusBarIcons],
        WritCreater.lamConvertedOptions[WritCreater.optionStrings.transparentStatusBar],
        WritCreater.lamConvertedOptions[WritCreater.optionStrings.incompleteColour],
        WritCreater.lamConvertedOptions[WritCreater.optionStrings.completeColour],
        {
            type = LibHarvensAddonSettings.ST_SLIDER,
            label = "Horizontal Position",
            tooltip = "Horizontal position of the status bar",
            setFunction = function(value)
                WritCreater:GetSettings().statusBarX = value
                WritCreater.updateQuestStatusAnchors()
            end,
            getFunction = function()
                return WritCreater:GetSettings().statusBarX
            end,
            default = 5,
            min = 0,
            max = GuiRoot:GetWidth()-120,
            step = 50,
            -- unit = "", --optional unit
            format = "%d", --value format
            disable = function() return not WritCreater:GetSettings().showStatusBar end,
        },
        {
            type = LibHarvensAddonSettings.ST_SLIDER,
            label = "Vertical Position",
            tooltip = "Horizontal position of the status bar",
            setFunction = function(value)
                WritCreater:GetSettings().statusBarY = value
                WritCreater.updateQuestStatusAnchors()
            end,
            getFunction = function()
                return WritCreater:GetSettings().statusBarY
            end,
            default = 5,
            min = 0,
            max = GuiRoot:GetHeight()-120,
            step = 50,
            -- unit = "", --optional unit
            format = "%d", --value format
            disable = function() return not WritCreater:GetSettings().showStatusBar end,
        },
        -- {
        --     type = LHA.ST_SECTION,
        --     label = WritCreater.optionStrings["writRewards submenu"],
        -- },
        {
            type = LHA.ST_SECTION,
            label = WritCreater.optionStrings["crafting submenu"],
        },
        WritCreater.lamConvertedOptions[WritCreater.optionStrings["blackmithing"]],
        WritCreater.lamConvertedOptions[WritCreater.optionStrings["clothing"]],
        WritCreater.lamConvertedOptions[WritCreater.optionStrings["woodworking"]],
        WritCreater.lamConvertedOptions[WritCreater.optionStrings["jewelry crafting"]],
        WritCreater.lamConvertedOptions[WritCreater.optionStrings["provisioning"]],
        WritCreater.lamConvertedOptions[WritCreater.optionStrings["enchanting"]],
        WritCreater.lamConvertedOptions[zo_strformat(WritCreater.optionStrings["abandon quest for item"], "|H1:item:45850:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")],
        WritCreater.lamConvertedOptions[zo_strformat(WritCreater.optionStrings["abandon quest for item"], "|H1:item:45831:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")],
        WritCreater.lamConvertedOptions[WritCreater.optionStrings["alchemy"]],
        WritCreater.lamConvertedOptions[zo_strformat(WritCreater.optionStrings["abandon quest for item"], "|H1:item:30152:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")],
        WritCreater.lamConvertedOptions[zo_strformat(WritCreater.optionStrings["abandon quest for item"], "|H1:item:30165:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")],
        WritCreater.lamConvertedOptions[zo_strformat(WritCreater.optionStrings["abandon quest for item"], "|H1:item:77591:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")],
        -- {
        --     type = LHA.ST_SECTION,
        --     label = WritCreater.optionStrings["style stone menu"],
        -- },
        {
            type = LHA.ST_SECTION,
            label = WritCreater.optionStrings["writRewards submenu"],
        },
        {
            type = LHA.ST_SECTION,
            label = WritCreater.optionStrings["masterReward"],
        },
        -- WritCreater.lamConvertedOptions["masterrewards1"],
        WritCreater.lamConvertedOptions["masterrewards2"],
        -- WritCreater.lamConvertedOptions["masterrewards3"],
        -- WritCreater.lamConvertedOptions["masterrewards4"],
        -- WritCreater.lamConvertedOptions["masterrewards5"],
        -- WritCreater.lamConvertedOptions["masterrewards6"],
        -- WritCreater.lamConvertedOptions["masterrewards7"],
        -- WritCreater.lamConvertedOptions["masterrewards8"],
        -- WritCreater.lamConvertedOptions["masterrewards9"],
        -- WritCreater.lamConvertedOptions["masterrewards10"],
        {
            type = LHA.ST_SECTION,
            label = WritCreater.optionStrings["intricateReward"],
        },
        -- WritCreater.lamConvertedOptions["intricaterewards1"],
        WritCreater.lamConvertedOptions["intricaterewards2"],
        -- WritCreater.lamConvertedOptions["intricaterewards3"],
        -- WritCreater.lamConvertedOptions["intricaterewards4"],
        -- WritCreater.lamConvertedOptions["intricaterewards5"],
        -- WritCreater.lamConvertedOptions["intricaterewards6"],
        -- WritCreater.lamConvertedOptions["intricaterewards7"],
        {
            type = LHA.ST_SECTION,
            label = WritCreater.optionStrings["ornateReward"],
        },
        -- WritCreater.lamConvertedOptions["ornaterewards1"],
        WritCreater.lamConvertedOptions["ornaterewards2"],
        -- WritCreater.lamConvertedOptions["ornaterewards3"],
        -- WritCreater.lamConvertedOptions["ornaterewards4"],
        -- WritCreater.lamConvertedOptions["ornaterewards5"],
        -- WritCreater.lamConvertedOptions["ornaterewards6"],
        -- WritCreater.lamConvertedOptions["ornaterewards7"],
        {
            type = LHA.ST_SECTION,
            label = WritCreater.optionStrings["surveyReward"],
        },
        -- WritCreater.lamConvertedOptions["surveyrewards1"],
        WritCreater.lamConvertedOptions["surveyrewards2"],
        -- WritCreater.lamConvertedOptions["surveyrewards3"],
        -- WritCreater.lamConvertedOptions["surveyrewards4"],
        -- WritCreater.lamConvertedOptions["surveyrewards5"],
        -- WritCreater.lamConvertedOptions["surveyrewards6"],
        -- WritCreater.lamConvertedOptions["surveyrewards7"],
        -- WritCreater.lamConvertedOptions["surveyrewards8"],
        -- WritCreater.lamConvertedOptions["surveyrewards9"],
        {
            type = LHA.ST_SECTION,
            label = WritCreater.optionStrings["repairRewards"],
        },
        WritCreater.lamConvertedOptions["repairReward"],
        WritCreater.lamConvertedOptions["soulGemReward"],
        WritCreater.lamConvertedOptions["glyphReward"],

    }
    local addAbandon = {
        WritCreater.lamConvertedOptions[zo_strformat(WritCreater.optionStrings["abandon quest for item"], "|H1:item:45850:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")],
        WritCreater.lamConvertedOptions[zo_strformat(WritCreater.optionStrings["abandon quest for item"], "|H1:item:45831:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")],
        WritCreater.lamConvertedOptions[zo_strformat(WritCreater.optionStrings["abandon quest for item"], "|H1:item:30152:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")],
        WritCreater.lamConvertedOptions[zo_strformat(WritCreater.optionStrings["abandon quest for item"], "|H1:item:30165:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")],
        WritCreater.lamConvertedOptions[zo_strformat(WritCreater.optionStrings["abandon quest for item"], "|H1:item:77591:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")],
    }
    for k, v in pairs(addAbandon) do
        v.label = "Abandon "..v.label
    end
    for i = 1, #options do
        -- if options[i] then
            settings:AddSetting(options[i])
        -- else
            
        -- end
    end

end