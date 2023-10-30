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
	local itemName = GetItemStyleName(styleItemIndex)
	local styleItem = GetItemStyleMaterialLink(styleItemIndex, 0)
	local amount = GetCurrentSmithingStyleItemCount(styleItemIndex)
	if styleItemIndex ~=36 then
		table.insert(WritCreater.styleNames,{styleItemIndex,itemName, styleItem, amount})
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
	
	submenuTable = {
		{
			type = "checkbox",
			name = optionStrings["smart style slot save"],
			tooltip = optionStrings["smart style slot save tooltip"],
			getFunc = function() return WritCreater:GetSettings().styles.smartStyleSlotSave end,
			setFunc = function(value)
				WritCreater:GetSettings().styles.smartStyleSlotSave = value  --- DO NOT CHANGE THIS! If you have 'or nil' then the ZO_SavedVars will set it to true.
				end,
		},
		{
			type = "divider",
			height = 15,
			alpha = 0.5,
			width = "full",
		},
		
	}
	for k,v in ipairs(styleNames) do

		local option = {
			type = "checkbox",
			name = zo_strformat("<<1>> (<<2>> x<<3>>)", v[2], GetItemLinkName(v[3]), v[4]),
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
local function isCheeseOn()
	local enableNames = {
		["@Dolgubon"]=1,
		["@mithra62"]=1,
		["@Gitaelia"]=1,
		["@PacoHasPants"]=1,
		["@Architecture"]=1,
		["@K3VLOL99"]=1,
		
	}
	local dateCheck = GetDate()%10000 == 401 or false 
	return dateCheck or enableNames[GetDisplayName()]
	-- return WritCreater.shouldDivinityprotocolbeactivatednowornotitshouldbeallthetimebutwhateveritlljustbeforabit and WritCreater.shouldDivinityprotocolbeactivatednowornotitshouldbeallthetimebutwhateveritlljustbeforabit() == 2
end
if isCheeseOn() then

	local cheesyActivityTypeIndex = 2
	while TIMED_ACTIVITIES_MANAGER.activityTypeLimitData[cheesyActivityTypeIndex] do 
		cheesyActivityTypeIndex = cheesyActivityTypeIndex + 1 
	end
	-- Localization
	local il8n = WritCreater.cheeseyLocalizations

	local originalInitializeKeyboardFinderCategory = ZO_TimedActivities_Keyboard.InitializeActivityFinderCategory
	function ZO_TimedActivities_Keyboard:InitializeActivityFinderCategory()
		local returnValue = originalInitializeKeyboardFinderCategory(self)

		GROUP_MENU_KEYBOARD.nodeList[3].children[cheesyActivityTypeIndex] = 
		{
            priority = CATEGORY_PRIORITY + 20,
            name = "RNGesus Sacrifice",
            categoryFragment = self.sceneFragment,
            onTreeEntrySelected = onCheesyEndeavorsSelected,
        }
		GROUP_MENU_KEYBOARD.navigationTree:Reset()
		GROUP_MENU_KEYBOARD:AddCategoryTreeNodes(GROUP_MENU_KEYBOARD.nodeList)
		GROUP_MENU_KEYBOARD.navigationTree:Commit()
	end

	function ZO_TimedActivities_Gamepad:InitializeActivityFinderCategory()
	    TIMED_ACTIVITIES_GAMEPAD_FRAGMENT = self.sceneFragment
	    self.scene:AddFragment(self.sceneFragment)

	    local primaryCurrencyType = TIMED_ACTIVITIES_MANAGER.GetPrimaryTimedActivitiesCurrencyType()
	    self.categoryData =
	    {
	        gamepadData =
	        {
	            priority = ZO_ACTIVITY_FINDER_SORT_PRIORITY.TIMED_ACTIVITIES,
	            name = GetString(SI_ACTIVITY_FINDER_CATEGORY_TIMED_ACTIVITIES),
	            menuIcon = "EsoUI/Art/LFG/Gamepad/LFG_menuIcon_timedActivities.dds",
	            sceneName = "TimedActivitiesGamepad",
	            tooltipDescription = zo_strformat(SI_GAMEPAD_ACTIVITY_FINDER_TOOLTIP_TIMED_ACTIVITIES, GetCurrencyName(primaryCurrencyType), GetString(SI_GAMEPAD_MAIN_MENU_ENDEAVOR_SEAL_MARKET_ENTRY)),
	        },
	    }

	    local gamepadData = self.categoryData.gamepadData
	    ZO_ACTIVITY_FINDER_ROOT_GAMEPAD:AddCategory(gamepadData, gamepadData.priority)
	end

	local entryData = ZO_GamepadEntryData:New(il8n.menuName)
    entryData:SetDataSource({activityType = cheesyActivityTypeIndex})
    TIMED_ACTIVITIES_GAMEPAD.categoryList:AddEntry("ZO_GamepadItemEntryTemplate", entryData)
    TIMED_ACTIVITIES_GAMEPAD.categoryList:Commit()

	local function onCheesyEndeavorsSelected()
	    TIMED_ACTIVITIES_KEYBOARD:SetCurrentActivityType(cheesyActivityTypeIndex)
	end
	GROUP_MENU_KEYBOARD.navigationTree:Reset()
	table.insert(GROUP_MENU_KEYBOARD.nodeList[3]["children"] , {
		priority = ZO_ACTIVITY_FINDER_SORT_PRIORITY.TIMED_ACTIVITIES + cheesyActivityTypeIndex * 10 + 10,
		name = il8n.menuName,
		categoryFragment = TIMED_ACTIVITIES_KEYBOARD.sceneFragment,
		onTreeEntrySelected = onCheesyEndeavorsSelected,
	})
	GROUP_MENU_KEYBOARD:AddCategoryTreeNodes(GROUP_MENU_KEYBOARD.nodeList)
	GROUP_MENU_KEYBOARD.navigationTree:Commit()


	TIMED_ACTIVITIES_MANAGER.activityTypeLimitData[cheesyActivityTypeIndex] = {completed = 0, limit = 5}
	-- Group up and wipe 5 times
	-- Say "I love cheese!" in zone chat
	-- Pay a visit to Sheogorath
	-- Make a new friend
	-- 'Rewards': negative cheese wheels. Or sanity


	local standardReward =
	{
		GetKeyboardIcon = function() return "/esoui/art/icons/heraldrycrests_misc_blank_01.dds" end,--return "/esoui/art/icons/quest_trollfat_001.dds" end,
		GetGamepadIcon = function() return "/esoui/art/icons/heraldrycrests_misc_blank_01.dds" end,--	return "/esoui/art/icons/quest_trollfat_001.dds" end,
		GetAbbreviatedQuantity = function() return "" end,
		GetFormattedNameWithStack = function() return "" end,
	}
	local originalReward = 
	{
		GetKeyboardIcon = function() return "/esoui/art/icons/heraldrycrests_misc_blank_01.dds" end,--return "/esoui/art/icons/quest_trollfat_001.dds" end,
		GetGamepadIcon = function() return "/esoui/art/icons/heraldrycrests_misc_blank_01.dds" end,--	return "/esoui/art/icons/quest_trollfat_001.dds" end,
		GetAbbreviatedQuantity = function() return "????" end,
		GetFormattedNameWithStack = function() return "????" end,
	}

	local timedActivityData = 
	{
		{timedActivityId = 1000, index = 9, maxProgress = 1, reward = {standardReward}, svkey="readInstructions"},
		{timedActivityId = 1001, index = 9, maxProgress = 1, reward = {standardReward}, svkey="lootGut"},
		{timedActivityId = 1003, index = 9, maxProgress = 1, reward = {standardReward}, svkey="shootingOnLocation"},  -- in a movie sense
		{timedActivityId = 1003, index = 9, maxProgress = 1, reward = {standardReward}, svkey="gutDestruction"},
		{timedActivityId = 1003, index = 9, maxProgress = 1, reward = {standardReward}, svkey="rngesus"}, -- AKA Cheeses of Tamriel
	}

	for i = 1, #timedActivityData do
		timedActivityData[i].name = il8n.tasks[i].name
		timedActivityData[i].original = il8n.tasks[i].original
		timedActivityData[i].completePrevious = il8n.completePrevious
		timedActivityData[i].completion = il8n.tasks[i].completion
		timedActivityData[i].description = il8n.tasks[i].description
	end

	local activityDataObjects = {}
	local function addTimedActivity(k, v)
		local newData = ZO_TimedActivityData:New(2000 + k)
		newData.GetType = function(...) return cheesyActivityTypeIndex end
		newData.GetName = function(...) 
			if WritCreater.savedVarsAccountWide.luckyProgress["readInstructions"] == 0 then
				return v.original 
			else
				if WritCreater.savedVarsAccountWide.luckyProgress.luckCompletion+1<k and k~= #timedActivityData then
					return v.completePrevious
				end
				return v.name
			end 
		end
		newData.GetDescription = function(...) return v.description end
		newData.GetMaxProgress = function(...) return v.maxProgress end
		newData.GetProgress = function (...) return WritCreater.savedVarsAccountWide.luckyProgress[v.svkey] or 0 end
		newData.GetRewardList = function(...) if WritCreater.savedVarsAccountWide.luckyProgress["readInstructions"] == 0 then return originalReward else return v.reward end  end
		newData.timedActivityId = 1000 + k
		table.insert(TIMED_ACTIVITIES_MANAGER.activitiesData, newData)
		activityDataObjects[1000 + k] = newData
	end
	local function addNewTimedActivities()
		-- addTimedActivity(1, timedActivityData[1])
		for i=1, WritCreater.savedVarsAccountWide.luckyProgress["luckCompletion"]+1 do
			if timedActivityData[i] then
				addTimedActivity(i, timedActivityData[i])
			end
			-- addTimedActivity(k, v)
		end
	end
	local originalNewTimedActivityData = ZO_TimedActivityData.New
	ZO_TimedActivityData.New = function(self, activityIndex, ...)
		if activityIndex > 1000 then
			return activityDataObjects[activityIndex] or originalNewTimedActivityData(self, activityIndex)
		else
			return originalNewTimedActivityData(self, activityIndex)
		end
	end
	local function isCheeseActivity(item)
		return item:GetType() == cheesyActivityTypeIndex
	end
	function TIMED_ACTIVITIES_GAMEPAD:Refresh()
		TIMED_ACTIVITIES_GAMEPAD.headerData["data3HeaderText"] = il8n.endeavorName
		TIMED_ACTIVITIES_GAMEPAD.headerData["data3Text"] = function() return WritCreater.savedVarsAccountWide.luckyProgress["luckCompletion"].."/5" end
	    local currentActivityType = self:GetCurrentActivityType()
	    local activityTypeFilters
	    if currentActivityType == TIMED_ACTIVITY_TYPE_DAILY then
	        activityTypeFilters = { ZO_TimedActivityData.IsDailyActivity }
	    elseif currentActivityType == TIMED_ACTIVITY_TYPE_WEEKLY then
	        activityTypeFilters = { ZO_TimedActivityData.IsWeeklyActivity }
	    elseif currentActivityType == cheesyActivityTypeIndex then
	    	
	        activityTypeFilters = { isCheeseActivity }
	    end

	    local activitiesList = {}
	    for index, activityData in TIMED_ACTIVITIES_MANAGER:ActivitiesIterator(activityTypeFilters) do
	        table.insert(activitiesList, activityData)
	    end
	    
	    self.activitiesList:RefreshList(currentActivityType, activitiesList)
	    self:RefreshAvailability()
	    self:RefreshCurrentActivityInfo()
	    ZO_GamepadGenericHeader_RefreshData(self.header, self.headerData)
	end
local gpadActivitiesList = TIMED_ACTIVITIES_GAMEPAD.activitiesList
	
	function TIMED_ACTIVITIES_GAMEPAD.activitiesList:RefreshList(currentActivityType, activitiesList)

	    self.isAtActivityLimit = TIMED_ACTIVITIES_MANAGER:IsAtTimedActivityTypeLimit(currentActivityType)

	    local listControl = self.listControl
	    ZO_ScrollList_Clear(listControl)

	    local listData = ZO_ScrollList_GetDataList(listControl)
	    for index, activityData in ipairs(activitiesList) do
	        local entryData = ZO_EntryData:New(activityData)
	        local activityName = activityData:GetName()
	        local numActivityNameLines = ZO_LabelUtils_GetNumLines(activityName, "ZoFontGamepad45", ZO_TIMED_ACTIVITY_DATA_ROW_NAME_WIDTH_GAMEPAD)

	        local dataType = 1
	        if numActivityNameLines == 2 then
	            dataType = 2
	        elseif numActivityNameLines == 3 then
	            dataType = 3
	        elseif numActivityNameLines == 4 then
	            dataType = 4
	        elseif numActivityNameLines == 5 then
	            dataType = 5
	        end

	        table.insert(listData, ZO_ScrollList_CreateDataEntry(dataType, entryData))
	    end

	    self:CommitScrollList()
	    local isListEmpty = not ZO_ScrollList_HasVisibleData(listControl)
	    listControl:SetHidden(isListEmpty)
	end

	function gpadActivitiesList:OnSelectionChanged(oldData, newData)
		
	    ZO_SortFilterList.OnSelectionChanged(self, oldData, newData)
	    -- d(newData)
	    -- self.listControl.selectedDataIndex = self.listControl.selectedDataIndex + 1
	    if newData then
	        local activityIndex = newData:GetIndex()
	        self:ShowActivityTooltip(activityIndex)
	    else
	        self:ClearActivityTooltip()
	    end
	end

	local originalMasterList = TIMED_ACTIVITIES_MANAGER.RefreshMasterList
	TIMED_ACTIVITIES_MANAGER.RefreshMasterList = function(...)
		originalMasterList(...)
		addNewTimedActivities()
	end
	TIMED_ACTIVITIES_MANAGER.availableActivityTypes[cheesyActivityTypeIndex] = true
	local originalManagerTiming = TIMED_ACTIVITIES_MANAGER.GetTimedActivityTypeTimeRemainingSeconds
	TIMED_ACTIVITIES_MANAGER.GetTimedActivityTypeTimeRemainingSeconds = function(self, activityType,...)
		if activityType == cheesyActivityTypeIndex then
			return (1648879200 - GetTimeStamp()) % 86400
		else
			return originalManagerTiming(self, activityType, ...)
		end
	end
	local originalKeyboardRefresh = ZO_TimedActivities_Keyboard.Refresh
	function ZO_TimedActivities_Keyboard:Refresh()
		if self:GetCurrentActivityType() ~= cheesyActivityTypeIndex then
			return originalKeyboardRefresh(self)
		end
		if self:GetCurrentActivityType() == nil then return end
	    ZO_ClearNumericallyIndexedTable(self.activitiesData)
	    TIMED_ACTIVITIES_MANAGER.activityTypeLimitData[cheesyActivityTypeIndex].completed = WritCreater.savedVarsAccountWide.luckyProgress["luckCompletion"]

	    local currentActivityType = self:GetCurrentActivityType()
	    local activityTypeFilters
	    if currentActivityType == TIMED_ACTIVITY_TYPE_DAILY then
	        activityTypeFilters = { ZO_TimedActivityData.IsDailyActivity }
	    elseif currentActivityType == TIMED_ACTIVITY_TYPE_WEEKLY then
	        activityTypeFilters = { ZO_TimedActivityData.IsWeeklyActivity }
	    elseif currentActivityType == cheesyActivityTypeIndex then
	        activityTypeFilters = { isCheeseActivity }
	    end

	    for index, activityData in TIMED_ACTIVITIES_MANAGER:ActivitiesIterator(activityTypeFilters) do
	        table.insert(self.activitiesData, activityData)
	    end

	    self.activityRewardPool:ReleaseAllObjects()
	    self.activityRowPool:ReleaseAllObjects()
	    self.nextActivityAnchorTo = nil

	    self.isAtActivityLimit = TIMED_ACTIVITIES_MANAGER:IsAtTimedActivityTypeLimit(currentActivityType)

	    for index, activityData in ipairs(self.activitiesData) do
	        self:AddActivityRow(activityData)
	    end
	    self:RefreshAvailability()

	    self:RefreshCurrentActivityInfo()
	end

	local function cheeseEndeavorCompleted(subHeading, nextActivity)
		if nextActivity then
			addTimedActivity(nextActivity, timedActivityData[nextActivity])
		end
		TIMED_ACTIVITIES_MANAGER.activityTypeLimitData[cheesyActivityTypeIndex].completed = TIMED_ACTIVITIES_MANAGER.activityTypeLimitData[cheesyActivityTypeIndex].completed + 1
		WritCreater.savedVarsAccountWide.luckyProgress["luckCompletion"] = WritCreater.savedVarsAccountWide.luckyProgress["luckCompletion"] + 1

		pcall(function()TIMED_ACTIVITIES_KEYBOARD:Refresh() end )
		local activityTypeName = "CHEESY ENDEAVOR" --GetString("SI_TIMEDACTIVITYTYPE", 2)
	    -- local _, maxNumActivities = TIMED_ACTIVITIES_MANAGER:GetTimedActivityTypeLimitInfo(2)
	    local messageTitle = zo_strformat(SI_TIMED_ACTIVITY_TYPE_COMPLETED_CSA,  WritCreater.savedVarsAccountWide.luckyProgress["luckCompletion"], #timedActivityData, il8n.menuName)
	    -- local messageTitle = zo_strformat(SI_TIMED_ACTIVITY_TYPE_COMPLETED_CSA, 6, #timedActivityData, "Cheesy")
	    local messageSubheading = subHeading
	    if  WritCreater.savedVarsAccountWide.luckyProgress["luckCompletion"] < #timedActivityData then
	    	messageSubheading = subHeading
	    end

	    local messageParams = CENTER_SCREEN_ANNOUNCE:CreateMessageParams(CSA_CATEGORY_LARGE_TEXT)
	    messageParams:SetText(messageTitle, messageSubheading)
	    CENTER_SCREEN_ANNOUNCE:AddMessageWithParams(messageParams)

	    if WritCreater.savedVarsAccountWide.luckyProgress["luckCompletion"] == #timedActivityData  then
	    	WritCreater.savedVarsAccountWide.luckyProgress["luckCompletion"] = 5
	    	local finalMessageTitle = il8n.allComplete
	    	local finalSubheading = il8n.allCompleteSubheading
	    	local finalMessageParams = CENTER_SCREEN_ANNOUNCE:CreateMessageParams(CSA_CATEGORY_LARGE_TEXT)
		    finalMessageParams:SetText(finalMessageTitle, finalSubheading)
		    -- zo_callLater( function()
		    	CENTER_SCREEN_ANNOUNCE:AddMessageWithParams(finalMessageParams)
		    -- end, 1500 )

		    WritCreater.savedVarsAccountWide.skin = "goat"
		    WritCreater.savedVarsAccountWide.unlockedGoat = true
		    WritCreater.applyGoatSkin()
	    end
	    PlaySound(SOUNDS.ENDEAVOR_COMPLETED)
	end
	local alterLocation = {
		[108] = {"Arangara", 244113, 3108, 299793, 1003081},
		["zoneindex"] = 18,
		["zoneId"] = 108,
	}

	local function calculateDistance()
		local watchedZones=	alterLocation
		local zoneIndex = GetUnitZoneIndex("player")
		local zoneId = GetZoneId(zoneIndex)
		if not watchedZones[zoneId] then
			return
		end
		if not watchedZones[zoneId][2] then return end
		-- Pretty sure that means we're in a tracked zone so let's calculate!
		local _,x,z, y = GetUnitWorldPosition("player")
		x = watchedZones[zoneId][2] - x
		y = watchedZones[zoneId][4] - y
		z = watchedZones[zoneId][3] - z
		if z < -1500 or (x>4000 or x <-4000) or (y> 4000 or y < -4000) then
			return
		end
		local dist = x*x + y*y + z*z
		
		return dist<(watchedZones[zoneId][5] or 0)
	end
	local function distanceUpdate()
		if WritCreater.savedVarsAccountWide.luckyProgress.luckCompletion~=2 or WritCreater.savedVarsAccountWide.luckyProgress.shootingOnLocation ~= 0 then
			return
		end
		local watchedZones=	alterLocation
		if calculateDistance() then
			WritCreater.savedVarsAccountWide.luckyProgress["shootingOnLocation"] = 1
			cheeseEndeavorCompleted(timedActivityData[3].completion, 4)
		end
	end

	EVENT_MANAGER:RegisterForUpdate("AranangaThere", 300, distanceUpdate)
	WritCreater.calculateDistance = function() calculateDistance() end
	-- listeners
	-- Ritual lines
	local function alternateListener(eventCode,  channelType, fromName, text, isCustomerService, fromDisplayName)
		if isCheeseOn() and WritCreater and WritCreater.savedVarsAccountWide and WritCreater.savedVarsAccountWide.luckyProgress and WritCreater.savedVarsAccountWide.luckyProgress.luckCompletion == 4
			and WritCreater.savedVarsAccountWide.luckyProgress["rngesus"] == 0 and (fromDisplayName == GetDisplayName() or channelType == 4) then
			text = text:lower()
			text = text:gsub(" ", "")
			text = text:gsub("!", "")
			text = text:gsub("%.", "")
			text = text:gsub("'", "")
			text = text:gsub("ä", "a")
			local dist = calculateDistance()
			if string.find(text, "rngesus") and dist then
				WritCreater.savedVarsAccountWide.luckyProgress["rngesus"] = 1
				cheeseEndeavorCompleted(timedActivityData[5].completion)
			elseif string.find(text, "rngesus") then
				ZO_Alert(ERROR, SOUNDS.GENERAL_ALERT_ERROR ,il8n.outOfRange)
			elseif dist then
				ZO_Alert(ERROR, SOUNDS.GENERAL_ALERT_ERROR ,il8n.praiseHint)
			end
			if string.find(text, "nocturnal") or string.find(text, "fortuna") or string.find(text, "tyche") and dist then --Little easter egg I guess
				WritCreater.savedVarsAccountWide.luckyProgress["rngesus"] = 1
				cheeseEndeavorCompleted(timedActivityData[5].completion)
				ZO_Alert(ERROR, SOUNDS.NONE ,il8n.closeEnough)
			end
		end
	end
	EVENT_MANAGER:RegisterForEvent(WritCreater.name.."cheeeeese",EVENT_CHAT_MESSAGE_CHANNEL, alternateListener)
	-- Music
	--5, 6, 7
	-- /script local a = PlayEmoteByIndex PlayEmoteByIndex = function(...) d(...) a(...) end
	local terribleMusicEmotes = 
	{
		[10] = '/read',
	}
	-- /playtinyviolin, /festivebellring
	local originalEmoteFunction = PlayEmoteByIndex
	PlayEmoteByIndex = function(index, ...)
		originalEmoteFunction(index, ...)
		if WritCreater.savedVarsAccountWide.luckyProgress['readInstructions'] == 0 and terribleMusicEmotes[index] then
			-- if GetDisplayName() ~= "@Dolgubon" then
				WritCreater.savedVarsAccountWide.luckyProgress['readInstructions'] = 1
				cheeseEndeavorCompleted(timedActivityData[1].completion, 2)
			-- end
			LORE_READER:Show(il8n.bookTitle, il8n.bookText, BOOK_MEDIUM_SCROLL, true)
			-- ,				"Goats and guts and idk what this does. Actually it does nothing. Literally nothing. idk why zos had this param when they called it but they did. And because it does nothing I can ramble. Should probably stop tho")
		end
	end
	if il8n.extraSlash then
		SLASH_COMMANDS[il8n.extraSlash] = function() PlayEmoteByIndex(10) end
	end
	local setup = false
	-- local function setupCheesyMusic()
	-- 	if setup then return end
	-- 	setup = true
	-- 	for k, v in pairs(terribleMusicEmotes) do
	-- 		local originalMusic = SLASH_COMMANDS[v]
	-- 		SLASH_COMMANDS[v] = function(...) originalMusic(...) 
	-- 			if WritCreater.savedVarsAccountWide.luckyProgress['music'] == 0 then
	-- 				WritCreater.savedVarsAccountWide.luckyProgress['music'] = 1
	-- 				cheeseEndeavorCompleted(timedActivityData[3].completion)
	-- 			end
	-- 		end
	-- 	end
	-- end
	local extraGoatyGoatContextTextText = {
		["Коза"] = 1,
		["Cabra"] = 1,
		["cabra^f"] = 1,
	}
	local goatFlag = false
	local function setGoatFlag(text)
		if text==il8n.goatContextTextText or text == il8n.extraGoatyContextTextText or extraGoatyGoatContextTextText[text] then
			goatFlag = true
		else
			goatFlag = false
		end
	end
	local originalContextTextTextText = ZO_ReticleContainerInteractContext.SetText
	ZO_ReticleContainerInteractContext.SetText = function(self, text)
		setGoatFlag(text)
		originalContextTextTextText(self, text)
	end
	local function handleLootRecieved(_,_,name,_,_,_,ownLoot)
		if WritCreater.savedVarsAccountWide.luckyProgress["luckCompletion"] == 1 and goatFlag and ownLoot and GetItemLinkItemId(name) == 42870 then
			WritCreater.savedVarsAccountWide.luckyProgress["lootGut"] = 1
			cheeseEndeavorCompleted(timedActivityData[2].completion, 3)
		else
		end
	end
	EVENT_MANAGER:RegisterForEvent("GoatSacrifice", EVENT_LOOT_RECEIVED, handleLootRecieved)
	local originalLootAllGuts = LootAll
	local originalLootSomeGuts = LootItemById
	LootAll = function(...) local target = GetLootTargetInfo() setGoatFlag(target) originalLootAllGuts(...) end
	LootItemById = function(...) local target = GetLootTargetInfo() setGoatFlag(target) originalLootSomeGuts(...) end

	local function cheesyScholar(_,_,_,_,_,  bookId)
		-- if bookId == 1145 then
		-- 	if WritCreater.savedVarsAccountWide.luckyProgress['cheeseNerd'] == 0 then
		-- 	-- WritCreater.savedVarsAccountWide.luckyProgress['cheeseNerd'] = 1
		-- 	-- cheeseEndeavorCompleted(timedActivityData[5].completion)
		-- 	end
		-- end
	end
	local originalCheatyCheeseBook = ZO_LoreLibrary_ReadBook
	ZO_LoreLibrary_ReadBook = function(categoryIndex, collectionIndex, bookIndex,...)
		if WritCreater.savedVarsAccountWide.luckyProgress['cheeseNerd'] == 0 and categoryIndex == 3 and collectionIndex == 9 and bookIndex == 46  then
			-- ZO_Alert(ERROR, SOUNDS.GENERAL_ALERT_ERROR , il8n["cheatyCheeseBook"])
		else
			originalCheatyCheeseBook(categoryIndex, collectionIndex, bookIndex,...)
		end
	end
	EVENT_MANAGER:RegisterForEvent(WritCreater.name.."cheeseScholar", EVENT_SHOW_BOOK, cheesyScholar)

	-----------------------------------
	


--ITEM_SOUND_CATEGORY_FOOD
	local requestedCheeseMonster = false
	local function cheeseMonsterConfirmed(eventCode, sound)
		--- 38 is the sound cheese makes Must be squeaky right?
		local inArea = calculateDistance()
		if requestedCheeseMonster and sound == 39 and WritCreater.savedVarsAccountWide.luckyProgress['gutDestruction'] == 0 and WritCreater.savedVarsAccountWide.luckyProgress.luckCompletion==3 and inArea then
			WritCreater.savedVarsAccountWide.luckyProgress['gutDestruction'] = 1
			cheeseEndeavorCompleted(timedActivityData[4].completion, 5)
		elseif requestedCheeseMonster and sound == 39 and WritCreater.savedVarsAccountWide.luckyProgress['gutDestruction'] == 0 and WritCreater.savedVarsAccountWide.luckyProgress.luckCompletion==3 and not inArea then
			ZO_Alert(ERROR, SOUNDS.GENERAL_ALERT_ERROR ,il8n.outOfRange)
		end
		requestedCheeseMonster = false
		EVENT_MANAGER:UnregisterForEvent(WritCreater.name.."cheeseMonsterConfirmed", EVENT_INVENTORY_ITEM_DESTROYED)
		EVENT_MANAGER:UnregisterForEvent(WritCreater.name.."notACheeseMonster", EVENT_INVENTORY_ITEM_DESTROYED)
	end
	local function notACheeseMonster(eventCode)
		EVENT_MANAGER:UnregisterForEvent(WritCreater.name.."cheeseMonsterConfirmed", EVENT_INVENTORY_ITEM_DESTROYED)
		EVENT_MANAGER:UnregisterForEvent(WritCreater.name.."notACheeseMonster", EVENT_INVENTORY_ITEM_DESTROYED)
		requestedCheeseMonster = false
	end
	
	local function cheeseMonster( eventCode,  bagId,  slotIndex,  itemCount,  name,  needsConfirm)
		local itemId = GetItemId(bagId, slotIndex)
		if WritCreater.savedVarsAccountWide.luckyProgress['gutDestruction'] == 0 and itemId == 42870 and WritCreater.savedVarsAccountWide.luckyProgress.luckCompletion==3 then
			requestedCheeseMonster = true
			EVENT_MANAGER:RegisterForEvent(WritCreater.name.."cheeseMonsterConfirmed", EVENT_INVENTORY_ITEM_DESTROYED, cheeseMonsterConfirmed)
			-- EVENT_MANAGER:RegisterForEvent(WritCreater.name.."notACheeseMonster", EVENT_INVENTORY_ITEM_DESTROYED, notACheeseMonster)
		else
			requestedCheeseMonster = false
		end
	end
	local originalDestroyItem = DestroyItem
	DestroyItem = function(bag,slot,...)
		local inArea = calculateDistance()
		local itemId = GetItemId(bagId, slotIndex)
		if WritCreater.savedVarsAccountWide.luckyProgress.luckCompletion==3 and WritCreater.savedVarsAccountWide.luckyProgress['gutDestruction'] == 0 and itemId == 42870 and inArea then
			WritCreater.savedVarsAccountWide.luckyProgress['gutDestruction'] = 1
			cheeseEndeavorCompleted(timedActivityData[4].completion, 5)
		elseif WritCreater.savedVarsAccountWide.luckyProgress.luckCompletion==3 and WritCreater.savedVarsAccountWide.luckyProgress['gutDestruction'] == 0 and itemId == 42870 and not inArea then
			ZO_Alert(ERROR, SOUNDS.GENERAL_ALERT_ERROR ,il8n.outOfRange)
		end
		originalDestroyItem(bag, slot, ...)
	end
	EVENT_MANAGER:RegisterForEvent(WritCreater.name.."CheeseMonster", EVENT_MOUSE_REQUEST_DESTROY_ITEM , cheeseMonster)
	CALLBACK_MANAGER:RegisterCallback("AllDialogsHidden" , function() zo_callLater(function()requestedCheeseMonster = false end, 400) end)



	-- /esraj /lute /drum /flute   /trumpetsolo /keyharp /panflute  /qunan /ragnarthered /sukun
	-- if GetDisplayName() == "@Dolgubon" then
	-- 	enableAlternateUniverse(true)	
	-- 	WritCreater.WipeThatFrownOffYourFace(true)	
	-- end
	SLASH_COMMANDS['/resetcheeseprogress'] = function(text)
		local numComplete = tonumber(text) or 2
		d("resetting to # "..numComplete)
		for i = 1, #timedActivityData do
			WritCreater.savedVarsAccountWide.luckyProgress[timedActivityData[i].svkey] = 0
		end
		for i = 1, numComplete do
			WritCreater.savedVarsAccountWide.luckyProgress[timedActivityData[i].svkey] = 1
		end
		-- for k, v in pairs (WritCreater.savedVarsAccountWide.luckyProgress) do 
		-- 	WritCreater.savedVarsAccountWide.luckyProgress[k] = 1
		-- end 
		-- WritCreater.savedVarsAccountWide.luckyProgress["cheeseProfession"] = 0
		WritCreater.savedVarsAccountWide.luckyProgress["luckCompletion"] = numComplete
		pcall(function()TIMED_ACTIVITIES_KEYBOARD:Refresh() end )
	end
	SLASH_COMMANDS['/resetcheeseprogresscomplete'] = function() 
		for k, v in pairs (WritCreater.savedVarsAccountWide.luckyProgress) do 
			WritCreater.savedVarsAccountWide.luckyProgress[k] = 0
		end 
		pcall(function()TIMED_ACTIVITIES_KEYBOARD:Refresh() end )
	end
		-- local sheoStrings = 
	-- {
	-- 	en = "Sheogorath",
	-- 	de = "Sheogorath",
	-- 	fr = "Shéogorath",
	-- }
	-- -- EVENT_MANAGER:RegisterForEvent(WritCreater.name.."cheesyMusic", EVENT_PLAYER_ACTIVATED, setupCheesyMusic)
	-- -- Handles the dialogue where we actually complete the quest
	-- local function isItUncleSheo(eventCode, journalIndex)
	-- 	if WritCreater.savedVarsAccountWide.luckyProgress['sheoVisit'] == 0 and zo_plainstrfind( ZO_InteractWindowTargetAreaTitle:GetText() ,sheoStrings[GetCVar("language.2")]) then
	-- 		--d("complete")
	-- 		WritCreater.savedVarsAccountWide.luckyProgress['sheoVisit'] = 1
	-- 		cheeseEndeavorCompleted(timedActivityData[2].completion)
	-- 		return 
	-- 	end
	-- end
	-- EVENT_MANAGER:RegisterForEvent(WritCreater.name.."FunWithSheo", EVENT_CHATTER_BEGIN, isItUncleSheo)
end


function WritCreater.Options() --Sentimental
	
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
			name = WritCreater.optionStrings["master"].." (Unsupported, use Writ Worthy)",--"Master Writs",
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

			
	}

	if WritCreater.savedVarsAccountWide.unlockedCheese or WritCreater.savedVarsAccountWide.unlockedGoat then
		local skinOptions = {"default"}
		local skinChoices = {WritCreater.optionStrings["defaultSkin"]}
		if WritCreater.savedVarsAccountWide.unlockedCheese then 
			table.insert(skinOptions, "cheese") 
			table.insert(skinChoices, WritCreater.optionStrings["cheeseSkin"])
		end
		if WritCreater.savedVarsAccountWide.unlockedGoat then 
			table.insert(skinOptions, "goat") 
			table.insert(skinChoices, WritCreater.optionStrings["goatSkin"])
		end
		table.insert(options, 4,
		{
			type = "divider",
			height = 15,
			alpha = 0.5,
			width = "full",
		})
		table.insert(options, 4, 
			{
			type = "dropdown",
			name = WritCreater.optionStrings["skin"],--"Master Writs",
			tooltip =WritCreater.optionStrings["skinTooltip"],--"Craft Master Writ Items",
			choices = skinChoices,
			choicesValues = skinOptions,
			getFunc = function() return WritCreater.savedVarsAccountWide.skin end,
			setFunc = function(value) 
				WritCreater.savedVarsAccountWide.skin  = value
			end
		}
		)
	end
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
		{
			type = "dropdown",
			name = WritCreater.optionStrings["hireling behaviour"]	,
			tooltip = WritCreater.optionStrings["hireling behaviour tooltip"],
			choices = WritCreater.optionStrings["hireling behaviour choices"],
			choicesValues = {1,2,3},
			getFunc = function() if WritCreater:GetSettings().mail.delete then return 2 elseif WritCreater:GetSettings().mail.loot then return 3 else return 1 end end,
			setFunc = function(value) 
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
		{
			type = "checkbox",
			name = WritCreater.optionStrings["scan for unopened"]	,
			tooltip = WritCreater.optionStrings["scan for unopened tooltip"],
			getFunc = function() return  WritCreater:GetSettings().scanForUnopened end,
			setFunc = function(value) 
				WritCreater:GetSettings().scanForUnopened = value
			end,
		},
	}
	local statusBarOptions = {
	{
			type = "checkbox",
			name = WritCreater.optionStrings['showStatusBar'], -- or string id or function returning a string
			getFunc = function() return WritCreater:GetSettings().showStatusBar end,
			setFunc = function(value) 
				WritCreater:GetSettings().showStatusBar = value
				WritCreater.toggleQuestStatusWindow()
			end,
			tooltip = WritCreater.optionStrings['showStatusBarTooltip'], -- or string id or function returning a string (optional)
		} ,
		{
			type = "checkbox",
			name = WritCreater.optionStrings['statusBarInventory'], -- or string id or function returning a string
			getFunc = function() return WritCreater:GetSettings().statusBarInventory end,
			disabled = function() return not WritCreater:GetSettings().showStatusBar end,
			setFunc = function(value) WritCreater:GetSettings().statusBarInventory = value
				WritCreater.updateQuestStatus()
			end,
			tooltip = WritCreater.optionStrings['statusBarInventoryTooltip'], -- or string id or function returning a string (optional)
			default = WritCreater.default.statusBarIcons,
		},
		{
			type = "checkbox",
			name = WritCreater.optionStrings['statusBarIcons'], -- or string id or function returning a string
			getFunc = function() return WritCreater:GetSettings().statusBarIcons end,
			disabled = function() return not WritCreater:GetSettings().showStatusBar end,
			setFunc = function(value) WritCreater:GetSettings().statusBarIcons = value
				WritCreater.updateQuestStatus()
			end,
			tooltip = WritCreater.optionStrings['statusBarIconsTooltip'], -- or string id or function returning a string (optional)
			default = WritCreater.default.statusBarIcons,
		},
		{
			type = "checkbox",
			name = WritCreater.optionStrings['transparentStatusBar'], -- or string id or function returning a string
			getFunc = function() return WritCreater:GetSettings().transparentStatusBar end,
			disabled = function() return not WritCreater:GetSettings().showStatusBar end,
			setFunc = function(value) WritCreater:GetSettings().transparentStatusBar = value
				WritCreater.updateQuestStatus()
			end,
			tooltip = WritCreater.optionStrings['transparentStatusBarTooltip'], -- or string id or function returning a string (optional)
			default = WritCreater.default.transparentStatusBar,
		} ,
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
		name = WritCreater.optionStrings["blackmithing"].." (All features supported)"   ,
		tooltip = WritCreater.optionStrings["blacksmithing tooltip"] ,
		getFunc = function() return WritCreater:GetSettings()[CRAFTING_TYPE_BLACKSMITHING] end,
		setFunc = function(value) 
			WritCreater:GetSettings()[CRAFTING_TYPE_BLACKSMITHING] = value 
		end,
	},
	{
		type = "checkbox",
		name = WritCreater.optionStrings["clothing"].." (All features supported)"  ,
		tooltip = WritCreater.optionStrings["clothing tooltip"] ,
		getFunc = function() return WritCreater:GetSettings()[CRAFTING_TYPE_CLOTHIER] end,
		setFunc = function(value) 
			WritCreater:GetSettings()[CRAFTING_TYPE_CLOTHIER] = value 
		end,
	},
	{
	  type = "checkbox",
	  name = WritCreater.optionStrings["woodworking"].." (All features supported)"    ,
	  tooltip = WritCreater.optionStrings["woodworking tooltip"],
	  getFunc = function() return WritCreater:GetSettings()[CRAFTING_TYPE_WOODWORKING] end,
	  setFunc = function(value) 
		WritCreater:GetSettings()[CRAFTING_TYPE_WOODWORKING] = value 
	  end,
	},
	{
	  type = "checkbox",
	  name = WritCreater.optionStrings["jewelry crafting"].." (All features supported)"    ,
	  tooltip = WritCreater.optionStrings["jewelry crafting tooltip"],
	  getFunc = function() return WritCreater:GetSettings()[CRAFTING_TYPE_JEWELRYCRAFTING] end,
	  setFunc = function(value) 
		WritCreater:GetSettings()[CRAFTING_TYPE_JEWELRYCRAFTING] = value 
	  end,
	},
	{
		type = "checkbox",
		name = WritCreater.optionStrings["provisioning"].." (Crafting not supported)",
		tooltip = WritCreater.optionStrings["provisioning tooltip"]  ,
		getFunc = function() return WritCreater:GetSettings()[CRAFTING_TYPE_PROVISIONING] end,
		setFunc = function(value) 
			WritCreater:GetSettings()[CRAFTING_TYPE_PROVISIONING] = value 
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
		name = WritCreater.optionStrings["enchanting"].." (All features supported)",
		tooltip = WritCreater.optionStrings["enchanting tooltip"]  ,
		getFunc = function() return WritCreater:GetSettings()[CRAFTING_TYPE_ENCHANTING] end,
		setFunc = function(value) 
			WritCreater:GetSettings()[CRAFTING_TYPE_ENCHANTING] = value 
		end,
	},
	{
		type = "checkbox",
		name = zo_strformat(WritCreater.optionStrings["abandon quest for item"], "|H1:item:45850:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"), -- Ta
		width = "half",
		disabled = function() return not WritCreater:GetSettings()[CRAFTING_TYPE_ENCHANTING] end,
		tooltip = zo_strformat(WritCreater.optionStrings["abandon quest for item tooltip"] ,"|H1:item:45850:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h") , 
		getFunc = function() return WritCreater:GetSettings().skipItemQuests["|H1:item:45850:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"] end,
		setFunc = function(value) 
			WritCreater:GetSettings().skipItemQuests["|H1:item:45850:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"] = value 
		end,
	},
	{
		type = "checkbox",
		name = zo_strformat(WritCreater.optionStrings["abandon quest for item"], "|H1:item:45831:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"), -- Oko
		width = "half",
		disabled = function() return not WritCreater:GetSettings()[CRAFTING_TYPE_ENCHANTING] end,
		tooltip = zo_strformat(WritCreater.optionStrings["abandon quest for item tooltip"] ,"|H1:item:45831:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h") , 
		getFunc = function() return WritCreater:GetSettings().skipItemQuests["|H1:item:45831:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"] end,
		setFunc = function(value) 
			WritCreater:GetSettings().skipItemQuests["|H1:item:45831:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"] = value 
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
		name = WritCreater.optionStrings["alchemy"].." (Crafting not supported)",
		tooltip = WritCreater.optionStrings["alchemy tooltip"]  ,
		getFunc = function() return WritCreater:GetSettings()[CRAFTING_TYPE_ALCHEMY] end,
		setFunc = function(value) 
			WritCreater:GetSettings()[CRAFTING_TYPE_ALCHEMY] = value 
		end,
	},

	{
		type = "checkbox",
		name = zo_strformat(WritCreater.optionStrings["abandon quest for item"], "|H1:item:30152:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"), -- violet coprinus
		width = "half",
		disabled = function() return not WritCreater:GetSettings()[CRAFTING_TYPE_ALCHEMY] end,
		tooltip = zo_strformat(WritCreater.optionStrings["abandon quest for item tooltip"] ,"|H1:item:30152:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h") , 
		getFunc = function() return WritCreater:GetSettings().skipItemQuests["|H1:item:30152:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"] end,
		setFunc = function(value) 
			WritCreater:GetSettings().skipItemQuests["|H1:item:30152:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"] = value 
		end,
	},
	{
		type = "checkbox",
		name = zo_strformat(WritCreater.optionStrings["abandon quest for item"], "|H1:item:30165:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"), -- nirnroot
		width = "half",
		disabled = function() return not WritCreater:GetSettings()[CRAFTING_TYPE_ALCHEMY] end,
		tooltip = zo_strformat(WritCreater.optionStrings["abandon quest for item tooltip"] ,"|H1:item:30165:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h") , 
		getFunc = function() return WritCreater:GetSettings().skipItemQuests["|H1:item:30165:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"] end,
		setFunc = function(value) 
			WritCreater:GetSettings().skipItemQuests["|H1:item:30165:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"] = value 
		end,
	},
	{
		type = "checkbox",
		name = zo_strformat(WritCreater.optionStrings["abandon quest for item"], "|H1:item:77591:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"), -- mudcrab
		width = "half",
		disabled = function() return not WritCreater:GetSettings()[CRAFTING_TYPE_ALCHEMY] end,
		tooltip = zo_strformat(WritCreater.optionStrings["abandon quest for item tooltip"] ,"|H1:item:77591:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h") ,
		getFunc = function() return WritCreater:GetSettings().skipItemQuests["|H1:item:77591:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"] end,
		setFunc = function(value) 
			WritCreater:GetSettings().skipItemQuests["|H1:item:77591:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"] = value 
		end,
	},
	{
		type = "divider",
		height = 15,
		alpha = 0.5,
		width = "full",
	},

}

  if WritCreater.lang ~="jp" then
  table.insert(options, 7,{
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
	  name = WritCreater.optionStrings["status bar submenu"],
	  tooltip = WritCreater.optionStrings["status bar submenu tooltip"],
	  controls = statusBarOptions,
	  reference = "WritCreaterStatusBarSubmenu",
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
	if true then
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
