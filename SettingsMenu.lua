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

function WritCreater.Options() --Sentimental

	local function WipeThatFrownOffYourFace(override)
		if WritCreater.alternateUniverse and (override or WritCreater.savedVarsAccountWide.alternateUniverse) then
			local stations, stationNames = WritCreater.alternateUniverse()
			local crafts, craftNames = WritCreater.alternateUniverseCrafts()
			local quests, questNames = WritCreater.alternateUniverseQuests()
			local items, itemNames = WritCreater.alternateUniverseItems()
			local oneOff, oneOffNames = WritCreater.alternateUniverseCoffers()
			local ones, oneNames = WritCreater.alternateUniverseOnes()
			local function setupReplacement(object, functionName, positionOfText, types, stationOrNot, case, x)
				if not object then return end
				local usingOld, usingNames
				if stationOrNot==nil then
					usingOld, usingNames = stations, stationNames
				elseif stationOrNot == 1 then
					usingOld, usingNames = crafts, craftNames
				elseif stationOrNot == 2 then
					usingOld, usingNames = quests, questNames
				elseif stationOrNot == 3 then
					usingOld, usingNames = items, itemNames
				elseif stationOrNot == 4 then
					usingOld, usingNames = oneOff, oneOffNames
				elseif stationOrNot == 0 then
					usingOld, usingNames = ones, oneNames
				end

				local stationsToCheck = {}
				if types then
					stationsToCheck = usingOld
				else
					for i = 1, #types do 
						stationsToCheck[types] = usingOld[types]
					end
				end
				local original = object[functionName]
				object[functionName] = function(self, ...)
					local parameters = {...}
					-- if x then d(parameters) end
					if not WritCreater.savedVarsAccountWide.alternateUniverse then
						return original(self, ...)
					end
					local text = parameters[positionOfText]
					if positionOfText == 0 then text = self end
					if type(text )~="string" then original(self, ...) return end
					for i, stationOriginalName in pairs(stationsToCheck) do 
						-- if case =="u" then d(text, string.upper(usingOld[i]) ) d(string.find(text, usingOld[i]) or (case == "u" and string.find(text, string.upper(usingOld[i]) ))) end
						if string.find(text, usingOld[i]) or (case == "u" and string.find(text, string.upper(usingOld[i]) )) then
							local newText = string.gsub(text, usingOld[i], usingNames[i] or text or "")
							parameters[positionOfText] = newText
							if positionOfText == 0 then self = newText end
							if case== "u" then

								local newText = string.gsub(text, string.upper(usingOld[i]), string.upper(usingNames[i]) or text or "")
								parameters[positionOfText] = newText
								if positionOfText == 0 then self = newText end
							end
							return original(self, unpack(parameters))
						end
					end
					return original(self, ...)
				end
			end
			local function interceptReplacement(object, functionName, positionOfText, types, stationOrNot)
				if not object then return end
				local usingOld, usingNames
				if stationOrNot==nil then
					usingOld, usingNames = stations, stationNames
				elseif stationOrNot == 1 then
					usingOld, usingNames = crafts, craftNames
				elseif stationOrNot == 2 then
					usingOld, usingNames = quests, questNames
				elseif stationOrNot == 3 then
					usingOld, usingNames = items, itemNames
				elseif stationOrNot == 4 then
					usingOld, usingNames = oneOff, oneOffNames
				end
				local stationsToCheck = {}
				if types then
					stationsToCheck = usingOld
				else
					for i = 1, #types do 
						stationsToCheck[types] = usingOld[types]
					end
				end
				local original = object[functionName]
				object[functionName] = function(self, ...)
					if not WritCreater.savedVarsAccountWide.alternateUniverse then
						return original(self, ...)
					end
					local results = {original(self, ...)}
					local text = results[positionOfText]
					if type(text )~="string" then return unpack(results) end
					for i, stationOriginalName in pairs(stationsToCheck) do 
						if string.find(text, usingOld[i]) then
							local newText = string.gsub(text, usingOld[i], usingNames[i] or text or "")
							results[positionOfText] = newText
							return unpack(results)
						end
					end
					return unpack(results)
				end
			end

			interceptReplacement(_G, "GetJournalQuestInfo",2,true, 3)
			local originalInventorySlot = ZO_Inventory_SetupSlot 

			ZO_Inventory_SetupSlot = function(slotControl, ...)
				local controlToAct = slotControl:GetParent():GetNamedChild("Name")

				if controlToAct and not controlToAct.isAlternatedUniverse and controlToAct.SetText then
					setupReplacement(controlToAct, "SetText",1,true,4)
					setupReplacement(controlToAct, "SetText",1,true,0)
					setupReplacement(controlToAct, "SetText",1,true,1)
					controlToAct.isAlternatedUniverse = true
					controlToAct:SetText(controlToAct:GetText())
				end
				return originalInventorySlot(slotControl, ...) 
			end
			-- interceptReplacement(_G, "GetItemLinkName",1,true, 4)
			
			-- interceptReplacement(LOOT_HISTORY_KEYBOARD, "InsertOrQueue", 1, true, 4)

			local original = LOOT_HISTORY_KEYBOARD.InsertOrQueue
			LOOT_HISTORY_KEYBOARD.InsertOrQueue = function(self, newEntry) 
				if not WritCreater.savedVarsAccountWide.alternateUniverse then
					return original(self, newEntry)
				end
				for k, v in pairs(newEntry.lines) do
					local text = v.text
					if type(text )~="string" then return original(self, newEntry)  end
					for i, stationOriginalName in pairs(oneOff) do 
						if string.find(text, oneOff[i]) then
							local newText = string.gsub(text, oneOff[i], oneOffNames[i] or text or "")
							v.text = newText
							return original(self, newEntry)
						end
					end
					return original(self, newEntry)
				end
			end
			local original
			local function inventorySetup (pool) 
				local activeObjects = pool:GetActiveObjects()
				for k, c in pairs(activeObjects) do
					local label  = c:GetNamedChild("Name")
					if not label.isAlternatedUniverse and label.SetText then
						label.isAlternatedUniverse = true

						setupReplacement(label, "SetText",1,true,4)
						setupReplacement(label, "SetText",1,true,1)
						setupReplacement(label, "SetText",1,1,0)
						label:SetText(label:GetText())
					end
				end
			end
			local function setupPool(object)
				SecurePostHook (object, "AcquireObject", function(pool)inventorySetup(pool) end)
			end
			-- setupPool(ZO_PlayerInventoryList.dataTypes[1].pool)
			-- setupPool(ZO_PlayerBankBackpack.dataTypes[1].pool)
			-- setupPool(ZO_HouseBankBackpack.dataTypes[1].pool)
			setupPool(WORLD_MAP_QUESTS.headerPool)

			local t = ACHIEVEMENTS.categoryTree.control:GetChild():GetChild(7)
			for i = 1, t:GetNumChildren() do
				local label = t:GetChild(i)
				if label and label.SetText then
					setupReplacement(label, "SetText",1,true,1)
					label:SetText(label:GetText())
				end
			end

			local o = QUEST_JOURNAL_KEYBOARD.navigationTree.AddNode
			QUEST_JOURNAL_KEYBOARD.navigationTree.AddNode = function (...)
				local c,b = o(...)
				local label  = c:GetControl()
				if not label.isAlternatedUniverse and label.SetText then
					label.isAlternatedUniverse = true

					setupReplacement(label, "SetText",1,true,2)
					label:SetText(label:GetText())
				end
				return c,b
			end

			setupReplacement(ZO_QuestJournalTitleText, "SetText",1,true,2)

			setupReplacement(ZO_CraftBagTabsActive, "SetText",1,true,1)
			for j = 3, 9 do 
				local text = ZO_CraftBagTabs:GetNamedChild("Button"..j).m_object.m_buttonData.tooltipText
				if type(text )=="string" then 
					for i, stationOriginalName in pairs(crafts) do 
						if string.find(text, crafts[i]) then
							local newText = string.gsub(text, crafts[i], craftNames[i] or text or "")
							ZO_CraftBagTabs:GetNamedChild("Button"..j).m_object.m_buttonData.tooltipText = newText
						end
					end
				end
			end

			QUEST_JOURNAL_KEYBOARD:RefreshQuestList()
			-- Refresh so the changes appear

			setupReplacement(ZO_CenterScreenAnnounce_GetEventHandlers(), EVENT_QUEST_ADDED,1,true,2)
			setupReplacement(ZO_CenterScreenAnnounce_GetEventHandlers(), EVENT_QUEST_COMPLETE,0,true,2)
			setupReplacement(ZO_LootTitle, "SetText",1,true,4)
			setupReplacement(ZO_TargetUnitFramereticleoverCaption , "SetText",1,true,2)

			
			setupReplacement(ZO_AchievementsCategoryTitle,"SetText", 1, true, 1)

			setupReplacement(ZO_AlchemyTopLevelSkillInfoName,"SetText", 2, true, 1,"u")

			setupReplacement(ZO_ProvisionerTopLevelSkillInfoName,"SetText", 2, true, 1,"u")

			setupReplacement(ZO_EnchantingTopLevelSkillInfoName,"SetText", 2, true, 1,"u")
			local function skillActvices()
				ZO_Skills_TieSkillInfoHeaderToCraftingSkill(ENCHANTING.control:GetNamedChild("SkillInfo"),CRAFTING_TYPE_ENCHANTING)
				ZO_Skills_TieSkillInfoHeaderToCraftingSkill(ALCHEMY.control:GetNamedChild("SkillInfo"),CRAFTING_TYPE_ALCHEMY)
				ZO_Skills_TieSkillInfoHeaderToCraftingSkill(PROVISIONER.control:GetNamedChild("SkillInfo"),CRAFTING_TYPE_PROVISIONING) 
				setupReplacement(ZO_FocusedQuestTrackerPanelContainerQuestContainerTrackedHeader1,"SetText", 1, true, 2)
				if ZO_FocusedQuestTrackerPanelContainerQuestContainerTrackedHeader1 then
					ZO_FocusedQuestTrackerPanelContainerQuestContainerTrackedHeader1:SetText(ZO_FocusedQuestTrackerPanelContainerQuestContainerTrackedHeader1:GetText())
				end
			end
			if IsPlayerActivated() then
				skillActvices()
			else
				EVENT_MANAGER:RegisterForEvent("AlternateUniversalCraftStudios",EVENT_PLAYER_ACTIVATED,function()
				skillActvices()
				EVENT_MANAGER:UnregisterForEvent("AlternateUniversalCraftStudios",EVENT_PLAYER_ACTIVATED)
				end , 1000)
			end

			interceptReplacement(_G, "GetSkillLineInfo", 1, true, 1)
			interceptReplacement(ZO_SkillLineData,"GetFormattedNameWithNumPointsAllocated", 1, true, 1)
			interceptReplacement(ZO_SkillLineData,"GetFormattedName", 1, true, 1)
			for i = 1, 10 do 
				setupReplacement(GetControl("ZO_ChatterOption",i), "SetText",1, true, 2)
			end
			

			-- unstuck yourself prompts do use the string overwrite functions
			SafeAddString(SI_CUSTOMER_SERVICE_UNSTUCK_COST_PROMPT,string.gsub(GetString(SI_CUSTOMER_SERVICE_UNSTUCK_COST_PROMPT_TELVAR), stations[9], stationNames[9]), 2)
			SafeAddString(SI_CUSTOMER_SERVICE_UNSTUCK_COST_PROMPT_TELVAR, string.gsub(GetString(SI_CUSTOMER_SERVICE_UNSTUCK_COST_PROMPT_TELVAR), stations[9], stationNames[9]), 2)

			setupReplacement(ZO_ReticleContainerInteractContext, "SetText", 1, true) -- reticle
			setupReplacement(ZO_ReticleContainerInteractContext, "SetText", 1, true,2) -- reticle, but for writ turnin
			setupReplacement(ZO_InteractWindowTargetAreaTitle, "SetText", 1, true,2) -- turnin titles
			setupReplacement(ZO_InteractWindowTargetAreaBodyText, "SetText", 1, true,2) -- turnin text of body
			setupReplacement(ZO_InteractWindowTargetAreaBodyText, "SetText", 1, true,1) -- turnin text of body

			local original = INTERACTION.givenRewardPool.AcquireObject
			INTERACTION.givenRewardPool.AcquireObject = function(...) 
				local c,b = original(...)
				if not c.isAlternatedUniverse then
					c.isAlternatedUniverse = true
					setupReplacement(c:GetNamedChild("Name"), "SetText",1,true,4)
				end
				return c,b
			end			

			setupReplacement(InformationTooltip, "AddLine", 1, true) -- tooltips
			setupReplacement(ZO_CompassCenterOverPinLabel, "SetText", 1, {9}) -- compass words
			setupReplacement(ZO_Dialog1Text, "SetText", 1, {9}) -- dialog porting box
			setupReplacement(_G, "ZO_Alert", 2, {9}) -- location change notification (top right of screen)
			setupReplacement(ZO_DeathReleaseOnlyButton1NameLabel, "SetText", 1, {9}) -- when you only have one port option on death
			setupReplacement(ZO_DeathTwoOptionButton2NameLabel, "SetText", 1, {9}) -- when you can revive here or go to wayshrine

			local originalMapAcquire = ZO_MapLocationTooltip.labelPool.AcquireObject
			ZO_MapLocationTooltip.labelPool.AcquireObject = function(...) 
				local control,b = originalMapAcquire(...)
				if not control.hasAprilStarted then 
					control.hasAprilStarted = true 
					setupReplacement(control, "SetText", 1, true)
					setupReplacement(control, "SetText", 1, true,2)
				end
				return control,b
			end
			-- Someone Else's Bank
			-- Bank of Hoarding

			-- checkboxes to show wayshrines on map. This one needs to be delayed because the map is not initialized at first
			local runOnce = {}
			SCENE_MANAGER.scenes['worldMap']:RegisterCallback("StateChange", function(old, new) 
				if new ~= "shown" then return end
				if not runOnce['worldMap'] then 
					runOnce['worldMap'] = true
					setupReplacement(ZO_WorldMapFiltersPvECheckBox2Label, "SetText", 1, {9})
					ZO_WorldMapFiltersPvECheckBox2Label:SetText(ZO_WorldMapFiltersPvECheckBox2Label:GetText()) 
				end  
			end)
		end
	end
	-- WipeThatFrownOffYourFace(GetDisplayName()=="@Dolgubon")
	-- WipeThatFrownOffYourFace(GetDisplayName()=="@Dolgubonn")
	WipeThatFrownOffYourFace()
	local g = getmetatable(WritCreater) or {}
	g.__index = g.__index or {}
	g.__index.WipeThatFrownOffYourFace = WipeThatFrownOffYourFace
	g.__metatable = "Only Sheogorath Certified Cheese Enthusiasts are allowed to see this table!"
	
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
