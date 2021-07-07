-----------------------------------------------------------------------------------
-- Addon Name: Dolgubon's Lazy Writ Crafter
-- Creator: Dolgubon (Joseph Heinzle)
-- Addon Ideal: Simplifies Crafting Writs as much as possible
-- Addon Creation Date: March 14, 2016
--
-- File Name: SettingsMenu.lua
-- File Description: Contains the information for the settings menu
-- Load Order Requirements: None (April, after language files)
-- 
-----------------------------------------------------------------------------------

local checks = {}
local validLanguages = 
{
	["en"]=true,["de"] = true,["fr"] = true,["jp"] = true, ["ru"] = false, ["zh"] = false, ["pl"] = false,
}
if true then
	EVENT_MANAGER:RegisterForEvent("WritCrafterLocalizationError", EVENT_PLAYER_ACTIVATED, function()
		if not WritCreater.languageInfo then 
			local language = GetCVar("language.2")
			if validLanguages[language] == nil then
				d("Dolgubon's Lazy Writ Crafter: Your language is not supported for this addon. If you are looking to translate the addon, check the lang/en.lua file for more instructions.")
			elseif validLanguages[language] == false then
				d("Dolgubon's Lazy Writ Crafter: The Localization file could not be loaded.")
				d("Troubleshooting:")
				d("1. Your language is supported by a patch for the Writ Crafter. Please make sure you have downloaded the appropriate patch")
				d("2. Uninstall and then reinstall the Writ Crafter, and the patch")
				d("3. If you still have issues, contact the author of the patch")
			else
				d("Dolgubon's Lazy Writ Crafter: The Localization file could not be loaded.")
				d("Troubleshooting:")
				d("1. Try to uninstall and then reinstall the addon")
				d("2. If the error persists, contact @Dolgubon in-game or at tinyurl.com/WritCrafter")
			end
		end
		EVENT_MANAGER:UnregisterForEvent("WritCrafterLocalizationError", EVENT_PLAYER_ACTIVATED)
	end)
end


WritCreater.styleNames = {}

for i = 1, GetNumValidItemStyles() do

	local styleItemIndex = GetValidItemStyleId(i)
	local  itemName = GetItemStyleName(styleItemIndex)
	local styleItem = GetSmithingStyleItemInfo(styleItemIndex)
	if styleItemIndex ~=36 then
		table.insert(WritCreater.styleNames,{styleItemIndex,itemName, styleItem})
	end
end

function WritCreater:GetSettings()
	if not self or not self.savedVars then
		return false
	end
	if self.savedVars.useCharacterSettings then
		return self.savedVars
	else
		return self.savedVarsAccountWide.accountWideProfile
	end
end

--[[{
			type = "dropbox",
			name = "Autoloot Behaviour",
			tooltip = "Choose when the addon will autoloot writ reward containers",
			choices = {"Copy the", "Autoloot", "Never Autoloot"},
			choicesValues = {1,2,3},
			getFunc = function() if WritCreater:GetSettings().ignoreAuto then return 1 elseif WritCreater:GetSettings().autoLoot then return 2 else return 3 end end,
			setFunc = function(value) 
				if value == 1 then 
					WritCreater:GetSettings().ignoreAuto = false
				elseif value == 2 then  
					WritCreater:GetSettings().autoLoot = true
					WritCreater:GetSettings().ignoreAuto = true
				elseif value == 3 then
					WritCreater:GetSettings().ignoreAuto = true
					WritCreater:GetSettings().autoLoot = false
				end
			end,
		},]]

local function mypairs(tableIn)
	local t = {}
	for k,v in pairs(tableIn) do
		t[#t + 1] = {k,v}
	end
	table.sort(t, function(a,b) return a[1]<b[1] end)

	return t
end

local optionStrings = WritCreater.optionStrings
local function styleCompiler()
	local submenuTable = {}
	local styleNames = WritCreater.styleNames
	for k,v in ipairs(styleNames) do

		local option = {
			type = "checkbox",
			name = zo_strformat("<<1>>", v[2]),
			tooltip = optionStrings["style tooltip"](v[2], v[3]),
			getFunc = function() return WritCreater:GetSettings().styles[v[1]] end,
			setFunc = function(value)
				WritCreater:GetSettings().styles[v[1]] = value  --- DO NOT CHANGE THIS! If you have 'or nil' then the ZO_SavedVars will set it to true.
				end,
		}
		submenuTable[#submenuTable + 1] = option
	end
	local imperial = table.remove(submenuTable, 34)
	table.insert(submenuTable, 10, imperial)
	return submenuTable
end



	
	local options =  {
		{
			type = "header",
			name = function() 
				local profile = WritCreater.optionStrings.accountWide
				if WritCreater.savedVars.useCharacterSettings then
					profile = WritCreater.optionStrings.characterSpecific
				end
				return  string.format(WritCreater.optionStrings.nowEditing, profile)  
			end, -- or string id or function returning a string
		},

		{
			type = "checkbox",
			name = WritCreater.optionStrings.useCharacterSettings,
			tooltip = WritCreater.optionStrings.useCharacterSettingsTooltip,
			getFunc = function() return WritCreater.savedVars.useCharacterSettings end,
			setFunc = function(value) 
				WritCreater.savedVars.useCharacterSettings = value
			end,
		},
		{
			type = "divider",
			height = 15,
			alpha = 0.5,
			width = "full",
		},
		
		{
			type = "checkbox",
			name = WritCreater.optionStrings["autocraft"]  ,
			tooltip = WritCreater.optionStrings["autocraft tooltip"] ,
			getFunc = function() return WritCreater:GetSettings().autoCraft end,
			disabled = function() return not WritCreater:GetSettings().showWindow end,
			setFunc = function(value) 
				WritCreater:GetSettings().autoCraft = value 
			end,
		},
		
		
		{
			type = "checkbox",
			name = WritCreater.optionStrings["master"],--"Master Writs",
			tooltip = WritCreater.optionStrings["master tooltip"],--"Craft Master Writ Items",
			getFunc = function() return WritCreater.savedVarsAccountWide.masterWrits end,
			setFunc = function(value) 
			WritCreater.savedVarsAccountWide.masterWrits = value
			if LibCustomMenu or WritCreater.savedVarsAccountWide.rightClick then
				WritCreater.savedVarsAccountWide.rightClick = not value
			end
			WritCreater.LLCInteraction:cancelItem()
				if value  then
					
					for i = 1, 25 do WritCreater.MasterWritsQuestAdded(1, i,GetJournalQuestName(i)) end
				end
				
				
			end,
		},
		{
			type = "checkbox",
			name = WritCreater.optionStrings["right click to craft"],--"Master Writs",
			tooltip = WritCreater.optionStrings["right click to craft tooltip"],--"Craft Master Writ Items",
			getFunc = function() return WritCreater.savedVarsAccountWide.rightClick end,
			disabled = not LibCustomMenu or WritCreater.savedVarsAccountWide.rightClick,
			warning = "This option requires LibCustomMenu",
			setFunc = function(value) 
			WritCreater.savedVarsAccountWide.masterWrits = not value
			WritCreater.savedVarsAccountWide.rightClick = value
			WritCreater.LLCInteraction:cancelItem()
				if not value  then
					
					for i = 1, 25 do WritCreater.MasterWritsQuestAdded(1, i,GetJournalQuestName(i)) end
				end
			end,
		},
		{
			type = "dropdown",
			name = WritCreater.optionStrings['dailyResetWarnType'],--"Master Writs",
			tooltip = WritCreater.optionStrings['dailyResetWarnTypeTooltip'],--"Craft Master Writ Items",
			choices = WritCreater.optionStrings["dailyResetWarnTypeChoices"],
			choicesValues = {"none","announcement","alert","chat","window","all"},
			getFunc = function() return WritCreater:GetSettings().dailyResetWarnType end,
			setFunc = function(value) 
				WritCreater:GetSettings().dailyResetWarnType = value 
				WritCreater.showDailyResetWarnings("Example") -- Show the example warnings
			end
		},
		{
		    type = "slider",
		    name = WritCreater.optionStrings['dailyResetWarnTime'], -- or string id or function returning a string
		    getFunc = function() return WritCreater:GetSettings().dailyResetWarnTime end,
		    setFunc = function(value) WritCreater:GetSettings().dailyResetWarnTime = math.max(0,value) WritCreater.refreshWarning() end,
		    min = 0,
		    max = 300,
		    step = 1, --(optional)
		    clampInput = false, -- boolean, if set to false the input won't clamp to min and max and allow any number instead (optional)
		    tooltip = WritCreater.optionStrings['dailyResetWarnTimeTooltip'], -- or string id or function returning a string (optional)
		    requiresReload = false, -- boolean, if set to true, the warning text will contain a notice that changes are only applied after an UI reload and any change to the value will make the "Apply Settings" button appear on the panel which will reload the UI when pressed (optional)
		} ,
		{
			type = "checkbox",
			name = WritCreater.optionStrings['stealingProtection'], -- or string id or function returning a string
			getFunc = function() return WritCreater:GetSettings().stealProtection end,
			setFunc = function(value) WritCreater:GetSettings().stealProtection = value end,
			tooltip = WritCreater.optionStrings['stealingProtectionTooltip'], -- or string id or function returning a string (optional)
		} ,
		{
			type = "checkbox",
			name = WritCreater.optionStrings['suppressQuestAnnouncements'], -- or string id or function returning a string
			getFunc = function() return WritCreater:GetSettings().suppressQuestAnnouncements end,
			setFunc = function(value) WritCreater:GetSettings().suppressQuestAnnouncements = value end,
			tooltip = WritCreater.optionStrings['suppressQuestAnnouncementsTooltip'], -- or string id or function returning a string (optional)
		} ,

			
	}
----------------------------------------------------
----- TIMESAVERS SUBMENU

	local timesaverOptions =
	{
		{
			type = "checkbox",
			name = WritCreater.optionStrings["automatic complete"],
			tooltip = WritCreater.optionStrings["automatic complete tooltip"],
			getFunc = function() return WritCreater:GetSettings().autoAccept end,
			setFunc = function(value) WritCreater:GetSettings().autoAccept = value end,
		},
		{
			type = "checkbox",
			name = WritCreater.optionStrings['autoCloseBank'],
			tooltip = WritCreater.optionStrings['autoCloseBankTooltip'],
			getFunc = function() return  WritCreater:GetSettings().autoCloseBank end,
			setFunc = function(value) 
				WritCreater:GetSettings().autoCloseBank = value
				if not value then
					EVENT_MANAGER:RegisterForEvent(WritCreater.name, EVENT_OPEN_BANK, WritCreater.alchGrab)
				else
					EVENT_MANAGER:UnregisterForEvent(WritCreater.name)
				end
			end,
		},

		{
			type = "checkbox",
			name = WritCreater.optionStrings['despawnBanker'],
			tooltip = WritCreater.optionStrings['despawnBankerTooltip'],
			getFunc = function() return  WritCreater:GetSettings().despawnBanker end,
			setFunc = function(value) 
				WritCreater:GetSettings().despawnBanker = value
			end,
			disabled = function() return not WritCreater:GetSettings().autoCloseBank end,
		},
		{
			type = "checkbox",
			name = WritCreater.optionStrings["exit when done"],
			tooltip = WritCreater.optionStrings["exit when done tooltip"],
			getFunc = function() return WritCreater:GetSettings().exitWhenDone end,
			setFunc = function(value) WritCreater:GetSettings().exitWhenDone = value end,
		},
		{
			type = "dropdown",
			name = WritCreater.optionStrings["autoloot behaviour"]	,
			tooltip = WritCreater.optionStrings["autoloot behaviour tooltip"],
			choices = WritCreater.optionStrings["autoloot behaviour choices"],
			choicesValues = {1,2,3},
			getFunc = function() if not WritCreater:GetSettings().ignoreAuto then return 1 elseif WritCreater:GetSettings().autoLoot then return 2 else return 3 end end,
			setFunc = function(value) 
				if value == 1 then 
					WritCreater:GetSettings().ignoreAuto = false
				elseif value == 2 then  
					WritCreater:GetSettings().autoLoot = true
					WritCreater:GetSettings().ignoreAuto = true
				elseif value == 3 then
					WritCreater:GetSettings().ignoreAuto = true
					WritCreater:GetSettings().autoLoot = false
				end
			end,
		},
		{
			type = "checkbox",
			name = WritCreater.optionStrings["new container"],
			tooltip = WritCreater.optionStrings["new container tooltip"],
			getFunc = function() return WritCreater:GetSettings().keepNewContainer end,
			setFunc = function(value) 
			WritCreater:GetSettings().keepNewContainer = value			
			end,
		},
		{
			type = "checkbox",
			name = WritCreater.optionStrings["loot container"],
			tooltip = WritCreater.optionStrings["loot container tooltip"],
			getFunc = function() return WritCreater:GetSettings().lootContainerOnReceipt end,
			setFunc = function(value) 
			WritCreater:GetSettings().lootContainerOnReceipt = value					
			end,
		},
		--[[{
			type = "slider",
			name = WritCreater.optionStrings["container delay"],
			tooltip = WritCreater.optionStrings["container delay tooltip"]    ,
			min = 0,
			max = 5,
			getFunc = function() return WritCreater:GetSettings().containerDelay end,
			setFunc = function(value)
			WritCreater:GetSettings().containerDelay = value
			end,
			disabled = function() return not WritCreater:GetSettings().lootContainerOnReceipt end,
		  },--]]
		{
			type = "checkbox",
			name = WritCreater.optionStrings["master writ saver"],
			tooltip = WritCreater.optionStrings["master writ saver tooltip"],
			getFunc = function() return WritCreater:GetSettings().preventMasterWritAccept end,
			setFunc = function(value) 
			WritCreater:GetSettings().preventMasterWritAccept = value					
			end,
		},
		{
			type = "checkbox",
			name = WritCreater.optionStrings["loot output"],--"Master Writs",
			tooltip = WritCreater.optionStrings["loot output tooltip"],--"Craft Master Writ Items",
			getFunc = function() return WritCreater:GetSettings().lootOutput end,
			setFunc = function(value) 
			WritCreater:GetSettings().lootOutput = value					
			end,
		},
		{
			type = "checkbox",
			name = WritCreater.optionStrings['reticleColour'],--"Master Writs",
			tooltip = WritCreater.optionStrings['reticleColourTooltip'],--"Craft Master Writ Items",
			getFunc = function() return  WritCreater:GetSettings().changeReticle end,
			setFunc = function(value) 
				WritCreater:GetSettings().changeReticle = value
			end,
		},
		{
			type = "checkbox",
			name = WritCreater.optionStrings['noDELETEConfirmJewelry'],--"Master Writs",
			tooltip = WritCreater.optionStrings['noDELETEConfirmJewelryTooltip'],--"Craft Master Writ Items",
			getFunc = function() return  WritCreater:GetSettings().EZJewelryDestroy end,
			setFunc = function(value) 
				WritCreater:GetSettings().EZJewelryDestroy = value
			end,
		},
		{
			type = "dropdown",
			name = WritCreater.optionStrings["pet begone"]	,
			tooltip = WritCreater.optionStrings["pet begone tooltip"],
			choices = WritCreater.optionStrings["pet begone choices"],
			warning = WritCreater.optionStrings["pet begone warning"],
			choicesValues = {1,2,3},
			getFunc = function() return WritCreater:GetSettings().petBegone end ,
			setFunc = function(value) 
				WritCreater.savedVarsAccountWide.updateDefaultCopyValue.petBegone = value
				WritCreater:GetSettings().petBegone = value
				WritCreater.hidePets()
				
			end,
		},
		{
			type = "checkbox",
			name = WritCreater.optionStrings['questBuffer'],--"Master Writs",
			tooltip = WritCreater.optionStrings['questBufferTooltip'],--"Craft Master Writ Items",
			getFunc = function() return  WritCreater:GetSettings().keepQuestBuffer end,
			setFunc = function(value) 
				WritCreater:GetSettings().keepQuestBuffer = value
			end,
		},
		{
			type = "slider",
			name = WritCreater.optionStrings['craftMultiplier'],--"Master Writs",
			tooltip = WritCreater.optionStrings['craftMultiplierTooltip'],--"Craft Master Writ Items",
			min = 1,
			max = 8,
			step = 1,
			getFunc = function() return  WritCreater:GetSettings().craftMultiplier end,
			setFunc = function(value) 
				WritCreater:GetSettings().craftMultiplier = value
			end,
		},
	}

----------------------------------------------------
----- REWARDS SUBMENU
	local rewardsSubmenu = {
		-- Options: Nothing, destroy, deposit, junk (Vendor?)
		-- Enchanting
			-- Surveys
			-- master writs
			-- mats
			-- glyphs
			-- empty soul gems
		-- Alchemy
			-- Surveys
			-- master writs
			-- mats
		-- provisioning
			-- recipes
			-- mats
			-- psijic fragment

	}
	local function geRewardTypeOption(craftingIndex, rewardName)
		return {
				type = "dropdown",
				name =  WritCreater.langWritNames()[craftingIndex],
				tooltip = WritCreater.optionStrings[craftingIndex.."RewardTooltip"],
				choices = WritCreater.optionStrings["rewardChoices"],
				choicesValues = {1,2,3, 4},
				disabled = function() return WritCreater:GetSettings().rewardHandling[rewardName].sameForAllCrafts end,
				getFunc = function()
					-- So I don't need to ennummerate it all in the default writ creator settings
					if not  WritCreater:GetSettings().rewardHandling[rewardName][craftingIndex] then
						WritCreater:GetSettings().rewardHandling[rewardName][craftingIndex] = 1
					end
					return WritCreater:GetSettings().rewardHandling[rewardName][craftingIndex] end ,
				setFunc = function(value) 
					WritCreater:GetSettings().rewardHandling[rewardName][craftingIndex] = value
				end,
			}
	end
	local validForReward = 
	{
		-- {"mats" ,    {1,2,3,4,5,6,7}, },
		{"repair" ,  {}, false},
		{"master" ,  {1,2,3,4,5,6,7}, true },
		{"survey" ,  {1,2,3,4,6,7}, true},
		-- {"ornate" ,  {1,2,6,7}, },
		-- {"intricate" ,  {1,2,6,7}, },
		
		-- {"soulGem" ,    {3}, },
		-- {"glyph" ,    {3}, },
		-- {"fragment" ,    {5}, },
		-- {"recipe" ,    {5}, },
	}
	local function rewardSubmenu(submenuOptions, craftingIndex)
		local writName
		if craftingIndex == 0 then
			writName = "Gear Crafts"
		else
			writName = WritCreater.langWritNames()[craftingIndex]
		end
		return {
			type = "submenu",
			name = writName,
			tooltip = WritCreater.optionStrings["writRewards submenu tooltip"],
			controls = submenuOptions,
			reference = "WritCreaterRewardsSubmenu"..craftingIndex,
		}
	end
	-- use same for all craft chaeckbox
	-- option to use
	------------------ divider
	-- per craft
	-- just the dropdown
	for i = 1, #validForReward do
		local rewardName, validCraftTypes = validForReward[i][1], validForReward[i][2]
		local submenuOptions
		if  #validCraftTypes > 1 then
			submenuOptions = {
				{
					type = "checkbox",
					name = WritCreater.optionStrings['sameForALlCrafts'],--"Master Writs",
					tooltip = WritCreater.optionStrings['sameForALlCraftsTooltip'],--"Craft Master Writ Items",
					getFunc = function() return  WritCreater:GetSettings().rewardHandling[rewardName].sameForAllCrafts end,
					setFunc = function(value) 
						WritCreater:GetSettings().rewardHandling[rewardName].sameForAllCrafts = value
					end,
				},
				{
					type = "dropdown",
					name =  WritCreater.optionStrings["allReward"]	,
					tooltip = WritCreater.optionStrings["allRewardTooltip"],
					choices = WritCreater.optionStrings["rewardChoices"],
					choicesValues = {1,2,3,4},
					disabled = function() return not WritCreater:GetSettings().rewardHandling[rewardName].sameForAllCrafts end,
					getFunc = function()
						-- So I don't need to ennummerate it all in the default writ creator settings
						if not  WritCreater:GetSettings().rewardHandling[rewardName]["all"] then
							WritCreater:GetSettings().rewardHandling[rewardName]["all"] = 1
						end
						return WritCreater:GetSettings().rewardHandling[rewardName]["all"] end ,
					setFunc = function(value)
						local oldValue = WritCreater:GetSettings().rewardHandling[rewardName]["all"]
						for k, v in pairs(WritCreater:GetSettings().rewardHandling[rewardName]) do
							if WritCreater:GetSettings().rewardHandling[rewardName][k] == oldValue then
								WritCreater:GetSettings().rewardHandling[rewardName][k] = value
							end
						end
					end,
				},
				{
					type = "divider",
					height = 15,
					alpha = 0.5,
					width = "full",
				},
			}
			for j = 1, #validCraftTypes do
				submenuOptions[#submenuOptions + 1] = geRewardTypeOption(validCraftTypes[j], rewardName)
			end
			rewardsSubmenu[#rewardsSubmenu + 1] = {
			type = "submenu",
			name = WritCreater.optionStrings[rewardName.."Reward"],
			tooltip = WritCreater.optionStrings[rewardName.."RewardTooltip"],
			controls = submenuOptions,
			reference = "WritCreaterRewardsSubmenu"..rewardName,
		}
		else
			rewardsSubmenu[#rewardsSubmenu + 1] = {
				type = "dropdown",
				name =  WritCreater.optionStrings[rewardName.."Reward"]	,
				tooltip = WritCreater.optionStrings["allRewardTooltip"],
				choices = WritCreater.optionStrings["rewardChoices"],
				choicesValues = {1,2,3,4},
				disabled = function() return not WritCreater:GetSettings().rewardHandling[rewardName].sameForAllCrafts end,
				getFunc = function()
					-- So I don't need to ennummerate it all in the default writ creator settings
					if not  WritCreater:GetSettings().rewardHandling[rewardName]["all"] then
						WritCreater:GetSettings().rewardHandling[rewardName]["all"] = 1
					end
					return WritCreater:GetSettings().rewardHandling[rewardName]["all"] end ,
				setFunc = function(value)
					local oldValue = WritCreater:GetSettings().rewardHandling[rewardName]["all"]
					for k, v in pairs(WritCreater:GetSettings().rewardHandling[rewardName]) do
						if WritCreater:GetSettings().rewardHandling[rewardName][k] == oldValue then
							WritCreater:GetSettings().rewardHandling[rewardName][k] = value
						end
					end
				end,
			}
		end
		
		
	end
	-- local gearWrits = {1, 2, 6, 7}
	-- for _, craftingIndex in pairs(gearWrits) do

	-- 	local gearTemplateMenu =
	-- 	{
	-- 		geRewardTypeOption(0, "mats"),
	-- 		geRewardTypeOption(0, "survey"),
	-- 		geRewardTypeOption(0, "master"),
	-- 		geRewardTypeOption(0, "repair"),
	-- 		geRewardTypeOption(0, "ornate"),
	-- 		geRewardTypeOption(0, "intricate"),
	-- 	}
	-- 	rewardsSubmenu[1] = rewardSubmenu(gearTemplateMenu, 0)
	-- 	rewardsSubmenu[1].tooltip = "What to do with rewards from Blacksmithing, Clothing, Woodworking and Jewelry"
	-- -- end
	-- local enchantingSubmenu = {
	-- 	geRewardTypeOption(CRAFTING_TYPE_ENCHANTING, "mats"),
	-- 	geRewardTypeOption(CRAFTING_TYPE_ENCHANTING, "survey"),
	-- 	geRewardTypeOption(CRAFTING_TYPE_ENCHANTING, "master"),
	-- 	geRewardTypeOption(CRAFTING_TYPE_ENCHANTING, "soulGem"),
	-- 	geRewardTypeOption(CRAFTING_TYPE_ENCHANTING, "glyph"),
	-- }
	-- rewardsSubmenu[2] = rewardSubmenu(enchantingSubmenu, CRAFTING_TYPE_ENCHANTING)
	-- local alchemySubmenu = {
	-- 	geRewardTypeOption(CRAFTING_TYPE_ALCHEMY, "mats"),
	-- 	geRewardTypeOption(CRAFTING_TYPE_ALCHEMY, "survey"),
	-- 	geRewardTypeOption(CRAFTING_TYPE_ALCHEMY, "master"),
	-- }
	-- rewardsSubmenu[3] = rewardSubmenu(alchemySubmenu, CRAFTING_TYPE_ALCHEMY)
	-- local provisioningSubmenu = {
	-- 	geRewardTypeOption(CRAFTING_TYPE_PROVISIONING, "mats"),
	-- 	geRewardTypeOption(CRAFTING_TYPE_PROVISIONING, "master"),
	-- 	geRewardTypeOption(CRAFTING_TYPE_PROVISIONING, "fragment"),
	-- 	geRewardTypeOption(CRAFTING_TYPE_PROVISIONING, "recipe"),
	-- }
	-- rewardsSubmenu[4] = rewardSubmenu(provisioningSubmenu, CRAFTING_TYPE_PROVISIONING)
	
----------------------------------------------------
----- CRAFTING SUBMENU

	local craftSubmenu = {{
		type = "checkbox",
		name = WritCreater.optionStrings["blackmithing"]   ,
		tooltip = WritCreater.optionStrings["blacksmithing tooltip"] ,
		getFunc = function() return WritCreater:GetSettings()[CRAFTING_TYPE_BLACKSMITHING] end,
		setFunc = function(value) 
			WritCreater:GetSettings()[CRAFTING_TYPE_BLACKSMITHING] = value 
		end,
	},
	{
		type = "checkbox",
		name = WritCreater.optionStrings["clothing"]  ,
		tooltip = WritCreater.optionStrings["clothing tooltip"] ,
		getFunc = function() return WritCreater:GetSettings()[CRAFTING_TYPE_CLOTHIER] end,
		setFunc = function(value) 
			WritCreater:GetSettings()[CRAFTING_TYPE_CLOTHIER] = value 
		end,
	},
	{
	  type = "checkbox",
	  name = WritCreater.optionStrings["woodworking"]    ,
	  tooltip = WritCreater.optionStrings["woodworking tooltip"],
	  getFunc = function() return WritCreater:GetSettings()[CRAFTING_TYPE_WOODWORKING] end,
	  setFunc = function(value) 
		WritCreater:GetSettings()[CRAFTING_TYPE_WOODWORKING] = value 
	  end,
	},
	{
	  type = "checkbox",
	  name = WritCreater.optionStrings["jewelry crafting"]    ,
	  tooltip = WritCreater.optionStrings["jewelry crafting tooltip"],
	  getFunc = function() return WritCreater:GetSettings()[CRAFTING_TYPE_JEWELRYCRAFTING] end,
	  setFunc = function(value) 
		WritCreater:GetSettings()[CRAFTING_TYPE_JEWELRYCRAFTING] = value 
	  end,
	},

	{
		type = "checkbox",
		name = WritCreater.optionStrings["enchanting"],
		tooltip = WritCreater.optionStrings["enchanting tooltip"]  ,
		getFunc = function() return WritCreater:GetSettings()[CRAFTING_TYPE_ENCHANTING] end,
		setFunc = function(value) 
			WritCreater:GetSettings()[CRAFTING_TYPE_ENCHANTING] = value 
		end,
	},
	{
		type = "checkbox",
		name = WritCreater.optionStrings["provisioning"],
		tooltip = WritCreater.optionStrings["provisioning tooltip"]  ,
		getFunc = function() return WritCreater:GetSettings()[CRAFTING_TYPE_PROVISIONING] end,
		setFunc = function(value) 
			WritCreater:GetSettings()[CRAFTING_TYPE_PROVISIONING] = value 
		end,
	},
	{
		type = "checkbox",
		name = WritCreater.optionStrings["alchemy"],
		tooltip = WritCreater.optionStrings["alchemy tooltip"]  ,
		getFunc = function() return WritCreater:GetSettings()[CRAFTING_TYPE_ALCHEMY] end,
		setFunc = function(value) 
			WritCreater:GetSettings()[CRAFTING_TYPE_ALCHEMY] = value 
		end,
	},}

  if WritCreater.lang ~="jp" then
  table.insert(options, {
	type = "checkbox",
	name = WritCreater.optionStrings["writ grabbing"] ,
	tooltip = WritCreater.optionStrings["writ grabbing tooltip"] ,
	getFunc = function() return WritCreater:GetSettings().shouldGrab end,
	setFunc = function(value) WritCreater:GetSettings().shouldGrab = value end,
  })
  --[[table.insert(options,{
	type = "slider",
	name = WritCreater.optionStrings["delay"],
	tooltip = WritCreater.optionStrings["delay tooltip"]    ,
	min = 10,
	max = 2000,
	getFunc = function() return WritCreater:GetSettings().delay end,
	setFunc = function(value)
	WritCreater:GetSettings().delay = value
	end,
	disabled = function() return not WritCreater:GetSettings().shouldGrab end,
  })]]
  end

	if false --[[GetWorldName() == "NA Megaserver" and WritCreater.lang =="en" ]] then
	  table.insert(options,8, {
	  type = "checkbox",
	  name = WritCreater.optionStrings["send data"],
	  tooltip =WritCreater.optionStrings["send data tooltip"] ,
	  getFunc = function() return WritCreater.savedVarsAccountWide.sendData end,
	  setFunc = function(value) WritCreater.savedVarsAccountWide.sendData = value  end,
	}) 
	end
	table.insert(options,{
	  type = "submenu",
	  name = WritCreater.optionStrings["timesavers submenu"],
	  tooltip = WritCreater.optionStrings["timesavers submenu tooltip"],
	  controls = timesaverOptions,
	  reference = "WritCreaterTimesaverSubmenu",
	})
	table.insert(options,{
		type = "submenu",
		name = WritCreater.optionStrings["writRewards submenu"],
		tooltip = WritCreater.optionStrings["writRewards submenu tooltip"],
		controls = rewardsSubmenu,
		reference = "WritCreaterRewardsSubmenu",
	})
	table.insert(options,{
	  type = "submenu",
	  name = WritCreater.optionStrings["crafting submenu"],
	  tooltip = WritCreater.optionStrings["crafting submenu tooltip"],
	  controls = craftSubmenu,
	  reference = "WritCreaterMasterWritSubMenu",
	})
	table.insert(options,{
	  type = "submenu",
	  name =WritCreater.optionStrings["style stone menu"],
	  tooltip = WritCreater.optionStrings["style stone menu tooltip"]  ,
	  controls = styleCompiler(),
	  reference = "WritCreaterStyleSubmenu",
	})

	
	if WritCreater.alternateUniverse then
		table.insert(options,1, {
				type = "checkbox",
				name = WritCreater.optionStrings["alternate universe"],
				tooltip =WritCreater.optionStrings["alternate universe tooltip"] ,
				getFunc = function() return WritCreater.savedVarsAccountWide.alternateUniverse end,
				setFunc = function(value) 
					WritCreater.savedVarsAccountWide.alternateUniverse = value 
					WritCreater.savedVarsAccountWide.completeImmunity = not value 
				end,
				requiresReload = true,
				
			})
	end
	if GetTimeStamp() < 1618322400 then
		local jubileeOption = {
			type = "checkbox",
			name = WritCreater.optionStrings["jubilee"]  ,
			tooltip = WritCreater.optionStrings["jubilee tooltip"] ,
			getFunc = function() return WritCreater:GetSettings().lootJubileeBoxes end,
			setFunc = function(value) 
				WritCreater:GetSettings().lootJubileeBoxes = value 
			end,
		}
		table.insert(options, 4, jubileeOption)
		-- table.insert(timesaverOptions, 8, jubileeOption)
	end

	return options
end
