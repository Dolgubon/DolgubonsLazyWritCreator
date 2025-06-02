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
                RequestOpenUnsafeURL("https://www.esoui.com/forums/showthread.php?t=11241")
            end,
            -- disable = function() return areSettingsDisabled end,
        },
        {
            type = LHA.ST_BUTTON,
            label = "Donate",
            tooltip = "Donate to Dolgubon on Paypal",
            buttonText = "Open URL",
            clickHandler = function(control, button)
                RequestOpenUnsafeURL("https://www.paypal.com/donate/?cmd=_s-xclick&hosted_button_id=7CZ3LW6E66NAU&ssrt=1747363295246")
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
                    for i = 1, 25 do WritCreater.MasterWritsQuestAdded(1, i,GetJournalQuestlabel(i)) end
                else
                    d("Master Writ crafting queue cleared")
                end
            end,
        },
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
            type = LHA.ST_SECTION,
            label = WritCreater.optionStrings["writRewards submenu"],
        },
        {
            type = LHA.ST_SECTION,
            label = WritCreater.optionStrings["crafting submenu"],
        },
        WritCreater.lamConvertedOptions[WritCreater.optionStrings["blackmithing"].." (All features supported)"],
        WritCreater.lamConvertedOptions[WritCreater.optionStrings["clothing"].." (All features supported)"],
        WritCreater.lamConvertedOptions[WritCreater.optionStrings["woodworking"].." (All features supported)"],
        WritCreater.lamConvertedOptions[WritCreater.optionStrings["jewelry crafting"].." (All features supported)"],
        WritCreater.lamConvertedOptions[WritCreater.optionStrings["provisioning"].." (All features supported)"],
        WritCreater.lamConvertedOptions[WritCreater.optionStrings["enchanting"].." (All features supported)"],
        WritCreater.lamConvertedOptions[zo_strformat(WritCreater.optionStrings["abandon quest for item"], "|H1:item:45850:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")],
        WritCreater.lamConvertedOptions[zo_strformat(WritCreater.optionStrings["abandon quest for item"], "|H1:item:45831:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")],
        WritCreater.lamConvertedOptions[WritCreater.optionStrings["alchemy"].." (All features supported)"],
        WritCreater.lamConvertedOptions[zo_strformat(WritCreater.optionStrings["abandon quest for item"], "|H1:item:30152:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")],
        WritCreater.lamConvertedOptions[zo_strformat(WritCreater.optionStrings["abandon quest for item"], "|H1:item:30165:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")],
        WritCreater.lamConvertedOptions[zo_strformat(WritCreater.optionStrings["abandon quest for item"], "|H1:item:77591:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")],
        -- {
        --     type = LHA.ST_SECTION,
        --     label = WritCreater.optionStrings["style stone menu"],
        -- },
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