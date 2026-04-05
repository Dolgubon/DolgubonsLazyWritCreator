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
	["en"]=true,["de"] = true,["fr"] = true,["jp"] = true, ["ru"] = false, ["zh"] = false, ["pl"] = false,["es"] = true
}
if true then
	EVENT_MANAGER:RegisterForEvent("WritCrafterLocalizationError", EVENT_PLAYER_ACTIVATED, function()
		if not WritCreater.writCompleteStrings then 
			local language = GetCVar("language.2")
			if validLanguages[language] == nil then
				d("Dolgubon's Lazy Writ Crafter: Your language is not fully supported for this addon. Some features may not work as expected. If you are looking to translate the addon, check the lang/en.lua file for more instructions.")
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
	if not self or not self.savedVars or not self.savedVarsAccountWide then
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
	-- Console just gets basic styles for now
	if IsConsoleUI() then
		return {}
	end
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
			type = "description",
			text = optionStrings["npcStyleStoneReminder"],
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
		-- ["@Dolgubon"]=UI_PLATFORM_PC,
		["@Dolgubonn"]=UI_PLATFORM_PC,
		-- ["@mithra62"]=1,
		["@Gitaelia"]=UI_PLATFORM_PC,
		-- ["@PacoHasPants"]=1,
		-- ["@Architecture"]=1,
		-- ["@K3VLOL99"]=1,
		["@Kelinmiriel"] = UI_PLATFORM_PC,
		["@StorybookTerror"] = UI_PLATFORM_PC,
		["@J3zdaz"] =UI_PLATFORM_XBOX,
		["@ThePurpleDDragon"] = UI_PLATFORM_PC,
		['@annathepiper'] = UI_PLATFORM_PC,

	}
	local platform = GetUIPlatform()
        
	if enableNames[GetDisplayName()] == UI_PLATFORM_XBOX then
		local dateCheck = GetDate()%10000
		if IsConsoleUI() and dateCheck <700 and dateCheck > 600 then
			return true
		end
	elseif enableNames[GetDisplayName()] == platform then
		return true
	end
	local dateCheck = GetDate()%10000 == 401 or false
	return dateCheck or enableNames[GetDisplayName()]
	-- return WritCreater.shouldDivinityprotocolbeactivatednowornotitshouldbeallthetimebutwhateveritlljustbeforabit and WritCreater.shouldDivinityprotocolbeactivatednowornotitshouldbeallthetimebutwhateveritlljustbeforabit() == 2
end
--  ZO_TimedActivitiesKeyboardListActivityHeader
-- WritCreater.savedVarsAccountWide.unlockedCheese
-- WritCreater.savedVarsAccountWide.cheeseCompletedTwice
if isCheeseOn() and WritCreater.cheeseyLocalizations and WritCreater.cheeseyLocalizations.superAmazingCraftSounds then
	WritCreater.cheeseyLocalizations.numFunThings = #WritCreater.cheeseyLocalizations.tasks
	local isConsolePeasant = IsConsoleUI() -- kidding, you guys are fine :) But you'll likely never read this, since 99.99% of console players won't download the source soooo....
	local cheesyActivityTypeIndex = 2
	-- PROMOTIONAL_EVENT_MANAGER.activeCampaignDataList[#PROMOTIONAL_EVENT_MANAGER.activeCampaignDataList+1] = 
	while PROMOTIONAL_EVENT_MANAGER.activeCampaignDataList[cheesyActivityTypeIndex] do 
		cheesyActivityTypeIndex = cheesyActivityTypeIndex + 1 
	end
	local function refreshTimedActivities()
		if not IsConsoleUI() then
			PROMOTIONAL_EVENTS_KEYBOARD:RefreshCampaignList()
		end
		-- PROMOTIONAL_EVENTS_GAMEPAD:RefreshCampaignList(true)
		-- PROMOTIONAL_EVENTS_GAMEPAD:RefreshAll()
	end
	-- Localization
	local il8n = WritCreater.cheeseyLocalizations
	if not isConsolePeasant then
		local originalInitializeKeyboardFinderCategory = ZO_TimedActivities_Keyboard.InitializeActivityFinderCategory
		function ZO_TimedActivities_Keyboard:InitializeActivityFinderCategory()
			local returnValue = originalInitializeKeyboardFinderCategory(self)

			GROUP_MENU_KEYBOARD.nodeList[4].children[cheesyActivityTypeIndex] = 
			{
	            priority = CATEGORY_PRIORITY + 20,
	            name = il8n.endeavorName,
	            categoryFragment = self.sceneFragment,
	            onTreeEntrySelected = onCheesyEndeavorsSelected,
	            isPromotionalEvent = true,
	        }
			GROUP_MENU_KEYBOARD.navigationTree:Reset()
			GROUP_MENU_KEYBOARD:AddCategoryTreeNodes(GROUP_MENU_KEYBOARD.nodeList)
			GROUP_MENU_KEYBOARD.navigationTree:Commit()
		end
	end

	function ZO_TimedActivities_Gamepad:InitializeActivityFinderCategory()
	    PROMOTIONAL_EVENTS_GAMEPAD_FRAGMENT = self.sceneFragment
	    self.scene:AddFragment(self.sceneFragment)

	    local primaryCurrencyType = PROMOTIONAL_EVENT_MANAGER.GetPrimaryTimedActivitiesCurrencyType()
	    self.categoryData =
	    {
	        gamepadData =
	        {
	            priority = ZO_ACTIVITY_FINDER_SORT_PRIORITY.TIMED_ACTIVITIES,
	            name = GetString(SI_ACTIVITY_FINDER_CATEGORY_TIMED_ACTIVITIES),
	            menuIcon = "EsoUI/Art/LFG/Gamepad/LFG_menuIcon_timedActivities.dds",
	            sceneName = "TimedActivitiesGamepad",
	            tooltipDescription = zo_strformat(SI_GAMEPAD_ACTIVITY_FINDER_TOOLTIP_TIMED_ACTIVITIES, GetCurrencyName(primaryCurrencyType), GetString(SI_GAMEPAD_MAIN_MENU_ENDEAVOR_SEAL_MARKET_ENTRY)),
	            isPromotionalEvent = true,
	        },
	        isPromotionalEvent = true,
	    }

	    local gamepadData = self.categoryData.gamepadData
	    ZO_ACTIVITY_FINDER_ROOT_GAMEPAD:AddCategory(gamepadData, gamepadData.priority)
	end
	local campaignData


    local function firePromotionalEvents(eventToFire,...)
    	for k, v in pairs(PROMOTIONAL_EVENT_MANAGER.callbackRegistry[eventToFire]) do
			-- pcall(function() v[1](...) end) -- Head in sand. Should be mostly fine, though
			v[1](...)
		end
    end
	-- local entryData = ZO_GamepadEntryData:New(il8n.menuName)
    -- entryData:SetDataSource({activityType = cheesyActivityTypeIndex})
    -- PROMOTIONAL_EVENTS_GAMEPAD.categoryList:AddEntry("ZO_GamepadItemEntryTemplate", entryData)
    -- PROMOTIONAL_EVENTS_GAMEPAD.categoryList:Commit()
    local activityKeyList = {"readInstructions", "robbajack","blingybling","totallyRealBlade","staffMagnus","lie"}
    local function claimReward()
    	if WritCreater.savedVarsAccountWide.applicationProgress.applicationCompletion == #activityKeyList and not WritCreater.savedVarsAccountWide.applicationProgress.rewardClaimed  then 
			WritCreater.savedVarsAccountWide.applicationProgress.rewardClaimed = true
			WritCreater.savedVarsAccountWide.skin = "fabulous"
		    WritCreater.savedVarsAccountWide.unlockedFabulousness = true
		    WritCreater.savedVarsAccountWide.cheeseCompleted2026 = true
		    WritCreater.toggleFabulousFrontLift(true) 
		    local finalMessageParams = CENTER_SCREEN_ANNOUNCE:CreateMessageParams(CSA_CATEGORY_LARGE_TEXT)
	    	finalMessageParams:SetText(il8n.claimRewardHeader, il8n.claimRewardSubheading)
	    	CENTER_SCREEN_ANNOUNCE:AddMessageWithParams(finalMessageParams)
	    	PlaySound(SOUNDS.ENDEAVOR_COMPLETED)
			campaignData.areAllRewardsClaimed = nil
			campaignData.isAnyRewardClaimable = nil
	    	SCENE_MANAGER:Show('hudui')
		end
		firePromotionalEvents("RewardsClaimed",campaignData, reward, true)
		local PROMOTIONAL_EVENT_REWARD = 22
		PLAYER_TO_PLAYER:RemoveFromIncomingQueue(PROMOTIONAL_EVENT_REWARD)
    end

    local function funcReplace (returnValue)
    	return function() return returnValue end
    end
    ---12473
    local activityCounter = 1
    local function generateIndividualActivityTable(campaignData, activityKey,activityIndex)
    	local activityData = ZO_PromotionalEventActivityData:New(campaignData, activityIndex)
    	-- activityData.activityIndex = activityInfo
    	activityData.showMonumentalTasks = function() return WritCreater.savedVarsAccountWide.applicationProgress.readInstructions~=0 or activityKey == "readInstructions" end
    	activityData.GetDisplayName = function() return activityData.showMonumentalTasks() and il8n["tasks"][activityData.activityIndex].name or "????" end
    	activityData.GetDescription = function() 
    		if WritCreater.savedVarsAccountWide.applicationProgress[activityKey] == 1 then 
    			return il8n['tasks'][activityData.activityIndex].completedDescription
    		else
    			return activityData.showMonumentalTasks() and il8n["tasks"][activityData.activityIndex].description or il8n.unknownMonumentalTask 
    		end
    	end
    	activityData.GetCompletionThreshold = function() return 1 end
    	activityData.GetProgress = function () return WritCreater.savedVarsAccountWide.applicationProgress[activityKey] end
    	-- activityData.GetRewardData = function () return il8n["rewardName"] end
    	activityData.IsComplete = function () return WritCreater.savedVarsAccountWide.applicationProgress[activityKey] == 1 end
    	activityData.IsLocked = function () return activityKey~="readInstructions" and WritCreater.savedVarsAccountWide.applicationProgress.readInstructions==0 end
    	activityData.IsRewardClaimed = function () return end
    	activityData.activityIndex = activityIndex
    	activityData.GetActivityIndex = funcReplace(activityIndex)
    	return activityData
    end
    local activityCache
    if GetDisplayName() == "@Dolgubon" then
    	prom = PROMOTIONAL_EVENT_MANAGER
    end

	
	ZO_PostHook(PROMOTIONAL_EVENT_MANAGER, "RefreshCampaignData", function(self)
		-- declared local earlier
		campaignData = ZO_PromotionalEventCampaignData:New(StringToId64("1212387216"))
		campaignData.GetKeyString = funcReplace("1212387216")
		campaignData.MatchesKeyWithCampaign = function(campaignData) return campaignData:GetKeyString() == "1212387216" end
		campaignData.campaignId = StringToId64("1212387216")
		campaignData.GetDisplayName = funcReplace(il8n.menuName)
		campaignData.ShouldCampaignBeVisible = function () return true end
		campaignData.GetCapstoneRewardThreshold = function() return #activityKeyList end
		campaignData.GetNumActivitiesCompleted = function () return WritCreater.savedVarsAccountWide.applicationProgress.applicationCompletion end
		campaignData.GetNumActivities = function () return #activityKeyList end
		campaignData.numActivities = #activityKeyList
		campaignData.GetDescription = function() return WritCreater.savedVarsAccountWide.applicationProgress.readInstructions == 1 and il8n.readDescription or il8n.initialDescription end
		activityCache=activityCache or 
		{
			generateIndividualActivityTable(campaignData, activityKeyList[1], 1),
			generateIndividualActivityTable(campaignData, activityKeyList[2], 2),
			generateIndividualActivityTable(campaignData, activityKeyList[3], 3),
			generateIndividualActivityTable(campaignData, activityKeyList[4], 4),
			generateIndividualActivityTable(campaignData, activityKeyList[5], 5),
			generateIndividualActivityTable(campaignData, activityKeyList[6], 6),
		}
		campaignData.activityInfo = activityCache
		campaignData.activities = campaignData.activityInfo
		campaignData.GetActivities = function() return activityCache end
		campaignData.GetActivityData = function(index) return activityCache[index] end
		-- campaignData.GetRewardData
		local reward = ZO_RewardData:New(-10, "")
		reward.GetRawName = function() return "HI" end
		reward.GetFormattedName = function() return "HI2" end
		-- reward.GetGamepadIcon
		reward.GetKeyboardIcon = function() return "/esoui/art/miscellaneous/help_icon.dds" end -- "/esoui/art/icons/u26_unknown_antiquity_questionmark.dds" end -- /esoui/art/miscellaneous/help_icon.dds
		reward.GetGamepadIcon = function() return "/esoui/art/miscellaneous/help_icon.dds" end -- "/esoui/art/icons/u26_unknown_antiquity_questionmark.dds" end -- /esoui/art/miscellaneous/help_icon.dds
		reward.TryClaimReward = claimReward
		campaignData.capstoneRewardId = -10
		campaignData.IsAnyRewardClaimable = function() return WritCreater.savedVarsAccountWide and 
			(not WritCreater.savedVarsAccountWide.applicationProgress.rewardClaimed and  WritCreater.savedVarsAccountWide.applicationProgress.applicationCompletion == #activityKeyList) or false end
		--OnRewardsClaimed
		--CanClaimReward
		-- AreAllRewardsClaimed
		campaignData.GetRewardData = function()
			return reward
		end
		campaignData.HasBeenSeen = function() return WritCreater.savedVarsAccountWide and WritCreater.savedVarsAccountWide.applicationProgress.hasSeenMostAwesomePursuitEver or true end
		campaignData.SetSeen  = function() WritCreater.savedVarsAccountWide.applicationProgress.hasSeenMostAwesomePursuitEver = true end
		campaignData.AreAllRewardsClaimed = function() return WritCreater.savedVarsAccountWide and WritCreater.savedVarsAccountWide.applicationProgress.rewardClaimed or true end
		campaignData.IsRewardClaimed = function() return WritCreater.savedVarsAccountWide and WritCreater.savedVarsAccountWide.applicationProgress.rewardClaimed or false end
		campaignData.GetSecondsRemaining = function() return (GetTimestampForStartOfDate(2026,4,2, true)- GetTimeStamp()) % 86400 end
		campaignData.OnRewardsClaimed = function() end
		campaignData.CanClaimReward = function() return WritCreater.savedVarsAccountWide and
			(not WritCreater.savedVarsAccountWide.applicationProgress.rewardClaimed and  WritCreater.savedVarsAccountWide.applicationProgress.applicationCompletion == #activityKeyList) or false end
		campaignData.TryClaimAllAvailableRewards = claimReward
		campaignData.TryClaimReward = campaignData.TryClaimAllAvailableRewards
		WritCreater.campaignData = campaignData
		table.insert(self.activeCampaignDataList, campaignData)
	end )
	local originalCampaignDataByKey = PROMOTIONAL_EVENT_MANAGER.GetCampaignDataByKey
	PROMOTIONAL_EVENT_MANAGER.GetCampaignDataByKey= function(self, campaignKey) if campaignKey == StringToId64("1212387216") then return  WritCreater.campaignData end return originalCampaignDataByKey(self, campaignKey) end
	SLASH_COMMANDS['/noclaim'] = function() WritCreater.savedVarsAccountWide.applicationProgress.rewardClaimed = false firePromotionalEvents("CampaignsUpdated") end
	EVENT_MANAGER:RegisterForEvent(WritCreater.name.."RefoolinatePursuit", EVENT_PLAYER_ACTIVATED, function()
		firePromotionalEvents("CampaignsUpdated")
		PROMOTIONAL_EVENT_MANAGER:RefreshCampaignData()
		zo_callLater(function() refreshTimedActivities() end,200)
	end)

	local function onCheesyEndeavorsSelected()
	    PROMOTIONAL_EVENTS_KEYBOARD:SetCurrentActivityType(cheesyActivityTypeIndex)
	end
	if not isConsolePeasant then
		-- PROMOTIONAL_EVENT_MANAGER:GetCampaignDataByIndex(i)
		local timedActivityIndex = 2
		for i = 1, #GROUP_MENU_KEYBOARD.nodeList do
			if GROUP_MENU_KEYBOARD.nodeList[i]['disabledIcon'] == "EsoUI/Art/LFG/LFG_indexIcon_PromotionalEvents_disabled.dds" then
				timedActivityIndex = i
			end
		end
		local promotionalEventNode = GROUP_MENU_KEYBOARD.nodeList[timedActivityIndex]
		promotionalEventNode.visible = function() return true end
		promotionalEventNode.name = il8n.endeavorName
		GROUP_MENU_KEYBOARD.navigationTree:Reset()
		GROUP_MENU_KEYBOARD:AddCategoryTreeNodes(GROUP_MENU_KEYBOARD.nodeList)
		GROUP_MENU_KEYBOARD.navigationTree:Commit()
	end
-- If we don't do this, players logging in won't see the glorious pyrite pursuits the first time they open them
local initial = true
EVENT_MANAGER:RegisterForEvent(WritCreater.name.."_CHAT_GPT", EVENT_PLAYER_ACTIVATED, function(event)
	if not initial then return end
	initial = false
zo_callLater(function()
	PROMOTIONAL_EVENT_MANAGER:RefreshCampaignData()
	firePromotionalEvents("CampaignsUpdated")
end, 500)
	EVENT_MANAGER:UnregisterForEvent(WritCreater.name.."_CHAT_GPT", EVENT_PLAYER_ACTIVATED ) end)



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
		{timedActivityId = 1001, index = 9, maxProgress = 1, reward = {standardReward}, svkey="robbajack"},
		{timedActivityId = 1003, index = 9, maxProgress = 1, reward = {standardReward}, svkey="blingybling"},
		-- {timedActivityId = 1003, index = 9, maxProgress = 1, reward = {standardReward}, svkey="evilWorm"},
		{timedActivityId = 1003, index = 9, maxProgress = 1, reward = {standardReward}, svkey="totallyRealBlade"},
		{timedActivityId = 1003, index = 9, maxProgress = 1, reward = {standardReward}, svkey="staffMagnus"},
		{timedActivityId = 1003, index = 9, maxProgress = 1, reward = {standardReward}, svkey="lie"},
	}
	

	for i = 1, #timedActivityData do
		timedActivityData[i].name = il8n.tasks[i].name
		timedActivityData[i].original = il8n.tasks[i].original
		timedActivityData[i].completePrevious = il8n.completePrevious
		timedActivityData[i].completion = il8n.tasks[i].completion
		timedActivityData[i].description = il8n.tasks[i].description
	end

	local activityDataObjects = {}
	local function pamphletRead()
	end
	local function isCheeseActivity(item)
		return item:GetType() == cheesyActivityTypeIndex
	end
	local gpadActivitiesList = PROMOTIONAL_EVENTS_GAMEPAD.activitiesList
	
	local function cheeseEndeavorCompleted(subHeading, activityIndex)
		if activityIndex == 1 then
			pamphletRead()
		end
		WritCreater.savedVarsAccountWide.applicationProgress["applicationCompletion"] = WritCreater.savedVarsAccountWide.applicationProgress["applicationCompletion"] + 1
		pcall(refreshTimedActivities)
		local activityTypeName = "CHEESY ENDEAVOR" --GetString("SI_TIMEDACTIVITYTYPE", 2)
	    -- local _, maxNumActivities = PROMOTIONAL_EVENT_MANAGER:GetTimedActivityTypeLimitInfo(2)
	    local messageTitle = zo_strformat(il8n.completionShout,  WritCreater.savedVarsAccountWide.applicationProgress["applicationCompletion"], #timedActivityData)
	    -- local messageTitle = zo_strformat(SI_TIMED_ACTIVITY_TYPE_COMPLETED_CSA, 6, #timedActivityData, "Cheesy")
	    local messageSubheading = subHeading
	     if  WritCreater.savedVarsAccountWide.applicationProgress["applicationCompletion"] < #timedActivityData then
	    	messageSubheading = subHeading
	    end

	    local messageParams = CENTER_SCREEN_ANNOUNCE:CreateMessageParams(CSA_CATEGORY_LARGE_TEXT)
	    messageParams:SetText(messageTitle, messageSubheading)
	    messageParams:SetCSAType(CENTER_SCREEN_ANNOUNCE_TYPE_CRAFTING_RESULTS)
	    CENTER_SCREEN_ANNOUNCE:AddMessageWithParams(messageParams)
	    CENTER_SCREEN_ANNOUNCE:DisplayMessage(messageParams)

		if WritCreater.savedVarsAccountWide.applicationProgress["applicationCompletion"] == #timedActivityData  then
	    	WritCreater.savedVarsAccountWide.applicationProgress["applicationCompletion"] = WritCreater.cheeseyLocalizations.numFunThings
	    	PROMOTIONAL_EVENT_MANAGER:OnActivityProgressUpdated(StringToId64("1212387216"))
	    	firePromotionalEvents("ActivityProgressUpdated", activityCache[activityIndex], 0, 1, true)
	    end
	    PlaySound(SOUNDS.ENDEAVOR_COMPLETED)
	end

	local terribleMusicEmotes = 
	{
		[10] = '/read',
	}
	-- /playtinyviolin, /festivebellring
	local originalEmoteFunction = PlayEmoteByIndex
	PlayEmoteByIndex = function(index, ...)
		originalEmoteFunction(index, ...)
		if WritCreater.savedVarsAccountWide.applicationProgress['readInstructions'] == 0 and terribleMusicEmotes[index] then
			WritCreater.savedVarsAccountWide.applicationProgress['readInstructions'] = 1
			cheeseEndeavorCompleted(timedActivityData[1].completion, 1)
			LORE_READER:Show(il8n.bookTitle, il8n.bookText, BOOK_MEDIUM_NOTE, true)
		end
	end
	if il8n.extraSlash then
		SLASH_COMMANDS[il8n.extraSlash] = function() PlayEmoteByIndex(10) end
	end


	local listOfBestCakesEver = -- if you don't like cheesecake you're a monster
	{
		[28330]=true, [42807]=true, [33870]=true
	}
	local magnusPrize = 48
	local daringTheft = 468
	local swiperIds = 
	{
		26,39, 53,
		[26] = 1,
		[39] = 1,
		[53] = 1,
	}
-- 	"readInstructions"},
-- "robbajack"},
-- "blingybling"},
-- "totallyRealBlade"},
-- "staffMagnus"},
-- "lie"},
	local function cheeseTracking(event, bag, slot, isNew, _, reason)
		local isCrafted = IsItemLinkCrafted(GetItemLink(bag, slot))
		local itemId = GetItemId(bag, slot)
		if WritCreater.savedVarsAccountWide.applicationProgress["lie"]==0 and listOfBestCakesEver[itemId] and isCrafted then
			WritCreater.savedVarsAccountWide.applicationProgress["lie"] = 1
			cheeseEndeavorCompleted(timedActivityData[6].completion, 6)
			return 
		end
		local _,_,_,_,_,itemSetId = GetItemLinkSetInfo(GetItemLink(bag, slot))
		local isBigStick = GetItemEquipmentFilterType(bag, slot) == EQUIPMENT_FILTER_TYPE_DESTRO_STAFF or GetItemEquipmentFilterType(bag, slot) == EQUIPMENT_FILTER_TYPE_RESTO_STAFF
		
		if WritCreater.savedVarsAccountWide.applicationProgress["staffMagnus"] == 0 and itemSetId == magnusPrize and isBigStick and isCrafted then
			cheeseEndeavorCompleted(timedActivityData[5].completion, 5)
			WritCreater.savedVarsAccountWide.applicationProgress["staffMagnus"] = 1
			return
		end
		local isJacked = GetItemEquipType(bag, slot)==EQUIP_TYPE_CHEST and GetItemArmorType(bag, slot)==ARMORTYPE_MEDIUM
		if WritCreater.savedVarsAccountWide.applicationProgress["robbajack"] == 0 and isJacked and itemSetId == daringTheft and isCrafted then
			cheeseEndeavorCompleted(timedActivityData[2].completion, 2)
			WritCreater.savedVarsAccountWide.applicationProgress["robbajack"] = 1
			return
		end
		local level = GetItemLevel(bag, slot)
		local isCP = GetItemRequiredChampionPoints(bag, slot)
		
		local harmType = GetItemWeaponType(bag, slot)
		local stabbyStabStabs = {[WEAPONTYPE_SWORD]=true, [WEAPONTYPE_TWO_HANDED_SWORD]=true, [WEAPONTYPE_DAGGER]=true}
		if WritCreater.savedVarsAccountWide.applicationProgress["totallyRealBlade"] == 0 and level >45 and isCrafted and stabbyStabStabs[harmType] and itemSetId == 0 and isCP==0 then
			cheeseEndeavorCompleted(timedActivityData[4].completion, 4)
			WritCreater.savedVarsAccountWide.applicationProgress["totallyRealBlade"] = 1
			return
		end
		local equipSlotMachine = GetItemEquipType(bag, slot)
		local amountOfActuallyInnocentCP = GetItemRequiredChampionPoints(bag, slot)
		if WritCreater.savedVarsAccountWide.applicationProgress["blingybling"] == 0 and amountOfActuallyInnocentCP>79 and amountOfActuallyInnocentCP <149 and isCrafted and EQUIP_TYPE_NECK == equipSlotMachine then
			cheeseEndeavorCompleted(timedActivityData[3].completion, 3)
			WritCreater.savedVarsAccountWide.applicationProgress["blingybling"] = 1
			return
		end
	end

	EVENT_MANAGER:RegisterForEvent(WritCreater.name.."_TotallyNotChatGPT",EVENT_INVENTORY_SINGLE_SLOT_UPDATE, cheeseTracking)
	EVENT_MANAGER:AddFilterForEvent(WritCreater.name.."_TotallyNotChatGPT",EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_IS_NEW_ITEM	, true)


	-----------------------------------
	


	-- /esraj /lute /drum /flute   /trumpetsolo /keyharp /panflute  /qunan /ragnarthered /sukun
	-- if GetDisplayName() == "@Dolgubon" then
	-- 	enableAlternateUniverse(true)	
	-- 	WritCreater.WipeThatFrownOffYourFace(true)	
	-- end
	SLASH_COMMANDS['/resetcheeseprogress'] = function(text)
		local numComplete = tonumber(text) or 2
		d("resetting to # "..numComplete)
		for i = 1, #timedActivityData do
			WritCreater.savedVarsAccountWide.applicationProgress[timedActivityData[i].svkey] = 0
		end
		for i = 1, numComplete do
			WritCreater.savedVarsAccountWide.applicationProgress[timedActivityData[i].svkey] = 1
		end
		WritCreater.savedVarsAccountWide.applicationProgress["applicationCompletion"] = numComplete
		if numComplete < #timedActivityData then
			WritCreater.savedVarsAccountWide.skin = "default"
			WritCreater.savedVarsAccountWide.unlockedFabulousness = false
		end
		if not isConsolePeasant then
			pcall(refreshTimedActivities)
		end
	end
	SLASH_COMMANDS['/resetcheeseprogresscomplete'] = function() 
		for k, v in pairs (WritCreater.savedVarsAccountWide.applicationProgress) do 
			WritCreater.savedVarsAccountWide.applicationProgress[k] = 0
		end 
		if not isConsolePeasant then
			pcall(refreshTimedActivities)
		end
	end
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
			end, 
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
			name = WritCreater.optionStrings['stealingProtection'], 
			getFunc = function() return WritCreater:GetSettings().stealProtection end,
			setFunc = function(value) WritCreater:GetSettings().stealProtection = value end,
			tooltip = WritCreater.optionStrings['stealingProtectionTooltip'], 
		} ,
		{
			type = "checkbox",
			name = WritCreater.optionStrings['suppressQuestAnnouncements'], 
			getFunc = function() return WritCreater:GetSettings().suppressQuestAnnouncements end,
			setFunc = function(value) WritCreater:GetSettings().suppressQuestAnnouncements = value end,
			tooltip = WritCreater.optionStrings['suppressQuestAnnouncementsTooltip'], 
		} ,
		{
			type = "checkbox",
			name = WritCreater.optionStrings["writ grabbing"] ,
			tooltip = WritCreater.optionStrings["writ grabbing tooltip"] ,
			getFunc = function() return WritCreater:GetSettings().shouldGrab end,
			setFunc = function(value) WritCreater:GetSettings().shouldGrab = value end,
		},
		{
			type = "dropdown",
			name = WritCreater.optionStrings['dailyResetWarnType'],
			tooltip = WritCreater.optionStrings['dailyResetWarnTypeTooltip'],
			choices = WritCreater.optionStrings["dailyResetWarnTypeChoices"],
			choicesValues =  IsConsoleUI() and {"none","announcement","alert","chat","all"} or {"none","announcement","alert","chat","window","all"},
			getFunc = function() return WritCreater:GetSettings().dailyResetWarnType end,
			setFunc = function(value) 
				WritCreater:GetSettings().dailyResetWarnType = value 
				WritCreater.showDailyResetWarnings("Example") -- Show the example warnings
			end
		},
		{
		    type = "slider",
		    name = WritCreater.optionStrings['dailyResetWarnTime'], 
		    getFunc = function() return WritCreater:GetSettings().dailyResetWarnTime end,
		    setFunc = function(value) WritCreater:GetSettings().dailyResetWarnTime = math.max(0,value) WritCreater.refreshWarning() end,
		    min = 0,
		    max = 300,
		    step = 1, 
		    clampInput = false, 
		    tooltip = WritCreater.optionStrings['dailyResetWarnTimeTooltip'], 
		    requiresReload = false, 
		} ,
		{
			type = "checkbox",
			name = WritCreater.optionStrings["master"],
			tooltip = WritCreater.optionStrings["master tooltip"],
			getFunc = function() return WritCreater.savedVarsAccountWide.masterWrits end,
			setFunc = function(value) 
			WritCreater.savedVarsAccountWide.masterWrits = value
			WritCreater.LLCInteractionMaster:cancelItem()
				if value  then
					for i = 1, 25 do WritCreater.MasterWritsQuestAdded(1, i,GetJournalQuestName(i)) end
				else
					ZO_Alert(UI_ALERT_CATEGORY_ALERT, SOUNDS.QUEST_SHARED ,WritCreater.strings['masterWritQueueCleared'] )
				end
			end,
		},
		{
			type = "dropdown",
			name = WritCreater.optionStrings["mimicStoneUse"],
			tooltip = WritCreater.optionStrings["mimicStoneUseTooltip"],
			choices = WritCreater.optionStrings['mimicStoneUseChoices'],
			choicesValues = {false, 1, 2, 3, 4},
			getFunc = function() return WritCreater:GetSettings().useMimic end,
			setFunc = function(value) 
				WritCreater:GetSettings().useMimic = value
				WritCreater.LLCInteractionMaster:cancelItem()
				ZO_Alert(UI_ALERT_CATEGORY_ALERT, SOUNDS.QUEST_SHARED ,WritCreater.strings['masterWritQueueCleared'] )
				if WritCreater.savedVarsAccountWide.masterWrits then
					for i = 1, 25 do WritCreater.MasterWritsQuestAdded(1, i,GetJournalQuestName(i)) end
				else
				end
			end,
		},
		{
			type = "button",
			name = WritCreater.optionStrings['queueWrits'],
            tooltip = WritCreater.optionStrings['queueWritsTooltip'],
			func = function(value) 
				WritCreater.queueAllSealedWrits(BAG_BACKPACK)
			end,
		},
		{ 
			type = "button",
			name = WritCreater.optionStrings.craftHousePort,
            tooltip = WritCreater.optionStrings.craftHousePortTooltip,
			func = function(value) 
				WritCreater.portToCraftingHouse()
			end,
		},
		-- {
		-- 	type = "checkbox",
		-- 	name = WritCreater.optionStrings["right click to craft"],
		-- 	tooltip = WritCreater.optionStrings["right click to craft tooltip"],
		-- 	getFunc = function() return WritCreater.savedVarsAccountWide.rightClick end,
		-- 	disabled = not LibCustomMenu or WritCreater.savedVarsAccountWide.rightClick,
		-- 	warning = "This option requires LibCustomMenu",
		-- 	setFunc = function(value) 
		-- 	WritCreater.savedVarsAccountWide.masterWrits = not value
		-- 	WritCreater.savedVarsAccountWide.rightClick = value
		-- 	WritCreater.LLCInteraction:cancelItem()
		-- 		if not value  then
					
		-- 			for i = 1, 25 do WritCreater.MasterWritsQuestAdded(1, i,GetJournalQuestName(i)) end
		-- 		end
		-- 	end,
		-- },

			
	}
	if WritCreater.savedVarsAccountWide.unlockedCheese or WritCreater.savedVarsAccountWide.unlockedGoat or WritCreater.savedVarsAccountWide.unlockedFabulousness then
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
		if WritCreater.savedVarsAccountWide.unlockedFabulousness then
			table.insert(skinOptions, "fabulous") 
			table.insert(skinChoices, WritCreater.optionStrings["fabulousSkin"])
		end
		table.insert(options, 4,
		{
			type = "divider",
			height = 15,
			alpha = 0.5,
			width = "full",
		})
		if WritCreater.savedVarsAccountWide.unlockedFabulousness then
			table.insert(options, 4, 
			{
			type = "checkbox",
			name = "Crafting Onomatopiea",
			tooltip = "Turns on the crafting Onomatopiea from LWC 2026 April Fools",
			choices = skinChoices,
			choicesValues = skinOptions,
			getFunc = function() return WritCreater.savedVarsAccountWide.craftSounds end,
			setFunc = function(value) 
				WritCreater.savedVarsAccountWide.craftSounds  = value
				-- WritCreater.applySkin(value)
			end
		}
		)
		end
		table.insert(options, 4, 
			{
			type = "dropdown",
			name = WritCreater.optionStrings["skin"],
			tooltip =WritCreater.optionStrings["skinTooltip"],
			choices = skinChoices,
			choicesValues = skinOptions,
			getFunc = function() return WritCreater.savedVarsAccountWide.skin end,
			setFunc = function(value) 
				WritCreater.savedVarsAccountWide.skin  = value
				WritCreater.applySkin(value)
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
			name = WritCreater.optionStrings['despawnBankerDeposit'],
			tooltip = WritCreater.optionStrings['despawnBankerDepositTooltip'],
			getFunc = function() return  WritCreater:GetSettings().despawnBankerDeposits end,
			setFunc = function(value) 
				WritCreater:GetSettings().despawnBankerDeposits = value
			end,
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
					WritCreater:GetSettings().lootContainerOnReceipt  = false
				end
			end,
		},
		{
			type = "checkbox",
			name = WritCreater.optionStrings["loot container"],
			tooltip = WritCreater.optionStrings["loot container tooltip"],
			disabled = function() return not WritCreater:GetSettings().autoLoot end,
			getFunc = function() 
				if not WritCreater:GetSettings().autoLoot then
					WritCreater:GetSettings().lootContainerOnReceipt  = false
				end
				return WritCreater:GetSettings().lootContainerOnReceipt 
			end,
			setFunc = function(value) 
			WritCreater:GetSettings().lootContainerOnReceipt = value					
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
			name = WritCreater.optionStrings["master writ saver"],
			tooltip = WritCreater.optionStrings["master writ saver tooltip"],
			getFunc = function() return WritCreater:GetSettings().preventMasterWritAccept end,
			setFunc = function(value) 
			WritCreater:GetSettings().preventMasterWritAccept = value					
			end,
		},
		{
			type = "checkbox",
			name = WritCreater.optionStrings["loot output"],
			tooltip = WritCreater.optionStrings["loot output tooltip"],
			getFunc = function() return WritCreater:GetSettings().lootOutput end,
			setFunc = function(value) 
			WritCreater:GetSettings().lootOutput = value					
			end,
		},
		{
			type = "checkbox",
			name = WritCreater.optionStrings['reticleColour'],
			tooltip = WritCreater.optionStrings['reticleColourTooltip'],
			getFunc = function() return  WritCreater:GetSettings().changeReticle end,
			setFunc = function(value) 
				WritCreater:GetSettings().changeReticle = value
			end,
		},
		{
			type = "checkbox",
			name = WritCreater.optionStrings['noDELETEConfirmJewelry'],
			tooltip = WritCreater.optionStrings['noDELETEConfirmJewelryTooltip'],
			getFunc = function() return  WritCreater:GetSettings().EZJewelryDestroy end,
			setFunc = function(value) 
				WritCreater:GetSettings().EZJewelryDestroy = value
			end,
		},
		{
			type = "checkbox",
			name = WritCreater.optionStrings['questBuffer'],
			tooltip = WritCreater.optionStrings['questBufferTooltip'],
			getFunc = function() return  WritCreater:GetSettings().keepQuestBuffer end,
			setFunc = function(value) 
				WritCreater:GetSettings().keepQuestBuffer = value
			end,
		},
		{
			type = "slider",
			name = WritCreater.optionStrings['craftMultiplier'],
			tooltip = WritCreater.optionStrings['craftMultiplierTooltip'],
			min = 0,
			max = 8,
			step = 1,
			getFunc = function() return  WritCreater:GetSettings().craftMultiplier end,
			setFunc = function(value) 
				WritCreater:GetSettings().craftMultiplier = value
			end,
		},
		{
			type = "checkbox",
			name = WritCreater.optionStrings['smartMultiplier'],
			tooltip = WritCreater.optionStrings['smartMultiplierTooltip'],
			getFunc = function() return not WritCreater:GetSettings().simpleMultiplier end,
			setFunc = function(value) 
				WritCreater:GetSettings().simpleMultiplier = not value
			end,
		},
		{
			type = "dropdown",
			name = WritCreater.optionStrings['craftMultiplierConsumables'],
			tooltip = WritCreater.optionStrings['craftMultiplierConsumablesTooltip'],
			choices = WritCreater.optionStrings["craftMultiplierConsumablesChoices"],
			choicesValues = {1,25},
			getFunc = function() return  WritCreater:GetSettings().consumableMultiplier end,
			setFunc = function(value) 
				WritCreater:GetSettings().consumableMultiplier = value
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
			name = WritCreater.optionStrings['showStatusBar'], 
			getFunc = function() return WritCreater:GetSettings().showStatusBar end,
			setFunc = function(value) 
				WritCreater:GetSettings().showStatusBar = value
				WritCreater.toggleQuestStatusWindow()
			end,
			tooltip = WritCreater.optionStrings['showStatusBarTooltip'], 
		} ,
		{
			type = "checkbox",
			name = WritCreater.optionStrings['statusBarInventory'], 
			getFunc = function() return WritCreater:GetSettings().statusBarInventory end,
			disabled = function() return not WritCreater:GetSettings().showStatusBar end,
			setFunc = function(value) WritCreater:GetSettings().statusBarInventory = value
				WritCreater.updateQuestStatus()
			end,
			tooltip = WritCreater.optionStrings['statusBarInventoryTooltip'], 
			default = WritCreater.default.statusBarIcons,
		},
		{
			type = "checkbox",
			name = WritCreater.optionStrings['statusBarIcons'], 
			getFunc = function() return WritCreater:GetSettings().statusBarIcons end,
			disabled = function() return not WritCreater:GetSettings().showStatusBar end,
			setFunc = function(value) WritCreater:GetSettings().statusBarIcons = value
				WritCreater.updateQuestStatus()
			end,
			tooltip = WritCreater.optionStrings['statusBarIconsTooltip'], 
			default = WritCreater.default.statusBarIcons,
		},
		{
			type = "checkbox",
			name = WritCreater.optionStrings['transparentStatusBar'], 
			getFunc = function() return WritCreater:GetSettings().transparentStatusBar end,
			disabled = function() return not WritCreater:GetSettings().showStatusBar end,
			setFunc = function(value) WritCreater:GetSettings().transparentStatusBar = value
				WritCreater.updateQuestStatus()
			end,
			tooltip = WritCreater.optionStrings['transparentStatusBarTooltip'], 
			default = WritCreater.default.transparentStatusBar,
		} ,
		{
			type = "colorpicker",
			name = WritCreater.optionStrings['incompleteColour'], 
			getFunc = function() return unpack(WritCreater:GetSettings().incompleteColour) end,
			disabled = function() return not WritCreater:GetSettings().showStatusBar end,
			setFunc = function(...) WritCreater:GetSettings().incompleteColour = {...}
				WritCreater.updateQuestStatus()
			end,
			default = WritCreater.default.incompleteColour,
		} ,
		{
			type = "colorpicker",
			name = WritCreater.optionStrings['completeColour'], 
			getFunc = function() return unpack(WritCreater:GetSettings().completeColour) end,
			disabled = function() return not WritCreater:GetSettings().showStatusBar end,
			setFunc = function(...) WritCreater:GetSettings().completeColour = {...}
				WritCreater.updateQuestStatus()
			end,
			default = WritCreater.default.completeColour,
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

	local function geRewardTypeOption(craftingIndex, rewardName, validActions, actionNames)
		return {
				type = "dropdown",
				name =  WritCreater.langWritNames()[craftingIndex],
				tooltip = WritCreater.optionStrings[craftingIndex.."RewardTooltip"],
				choices = actionNames,
				choicesValues = validActions,
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
	-- actions:
	-- 1 : Nothing
	-- 2 : Deposit
	-- 3 : Junk
	-- 4 : Destroy
	-- 5 : Decon
	local validForReward = 
	{  -- Name , list of crafts, valid actions
		-- {"mats" ,    {1,2,3,4,5,6,7}, },
		{"repair" ,  {}, {1,2,3,4}},
		{"glyph"  ,  {}, {1, 2, 3, 4, 5 }},
		{"soulGem",  {}, {1,2,3,4}},
		{"master" ,  {1,2,3,4,5,6,7} , {1,2,3,4}},
		{"survey" ,  {1,2,3,4,6,7}, {1,2,3,4}},
		{"ornate" ,  {1,2,6,7}, {1,2,3,4,5}},
		{"intricate" ,  {1,2,6,7}, {1,2,3,4,5}},
		{"goldMat" , {1,2,3, 6,7}, {1, 2}},
		{"fragment" ,    {5}, {1,2,3,4}},
		{"currency" , {}, {1, 2}},
		-- {"recipe" ,    {5}, {1,2,3,4}},
	}
	-- use same for all craft chaeckbox
	-- option to use
	------------------ divider
	-- per craft
	-- just the dropdown

	local function getChoiceListInfo(validActionList)
		local a = {}
		for k, v in ipairs(validActionList) do
			a[#a+1] = WritCreater.optionStrings["rewardChoices"][v]
		end
		return a
	end

	for i = 1, #validForReward do
		local rewardName, validCraftTypes, validActions = validForReward[i][1], validForReward[i][2], validForReward[i][3]
		local actionNames = getChoiceListInfo(validActions)
		if #validCraftTypes > 1 then
			local submenuOptions = {
				{
					type = "checkbox",
					name = WritCreater.optionStrings['sameForALlCrafts'],
					tooltip = WritCreater.optionStrings['sameForALlCraftsTooltip'],
					getFunc = function() return  WritCreater:GetSettings().rewardHandling[rewardName].sameForAllCrafts end,
					setFunc = function(value) 
						WritCreater:GetSettings().rewardHandling[rewardName].sameForAllCrafts = value
					end,
					disabled = function() return IsESOPlusSubscriber() and rewardName == "goldMat" end,
				},
				{
					type = "dropdown",
					name =  WritCreater.optionStrings["allReward"]	,
					tooltip = WritCreater.optionStrings["allRewardTooltip"],
					choices = actionNames,
					choicesValues = validActions,
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
					disabled = function() return IsESOPlusSubscriber() and rewardName == "goldMat" end,
				},
				{
					type = "divider",
					height = 15,
					alpha = 0.5,
					width = "full",
				},
			}
			for j = 1, #validCraftTypes do
				submenuOptions[#submenuOptions + 1] = geRewardTypeOption(validCraftTypes[j], rewardName, validActions, actionNames)
			end
			rewardsSubmenu[#rewardsSubmenu + 1] = {
				type = "submenu",
				name = WritCreater.optionStrings[rewardName.."Reward"],
				tooltip = WritCreater.optionStrings[rewardName.."RewardTooltip"],
				controls = submenuOptions,
				reference = "WritCreaterRewardsSubmenu"..rewardName,
				disabled = function() return IsESOPlusSubscriber() and rewardName == "goldMat" end,
			}
			for i = 1 , #submenuOptions do
				submenuOptions[i].LHASName = rewardName.."rewards"..i
			end
		else
			rewardsSubmenu[#rewardsSubmenu + 1] = {
				type = "dropdown",
				name =  WritCreater.optionStrings[rewardName.."Reward"]	,
				tooltip = WritCreater.optionStrings["allRewardTooltip"],
				choices = actionNames,
				LHASName = rewardName.."Reward",
				choicesValues = validActions,
				disabled = function() return IsESOPlusSubscriber() and rewardName == "goldMat" end,
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
		for i = 1 , #rewardsSubmenu do
			-- rewardsSubmenu[i].LHASName = rewardName.."rewards"..i
			-- WritCreater.lamConvertedOptions
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
		name = WritCreater.optionStrings["provisioning"],
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
		name = WritCreater.optionStrings["enchanting"],
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
	-- {
	-- 	type = "checkbox",
	-- 	name = WritCreater.optionStrings["alchemy"],
	-- 	tooltip = WritCreater.optionStrings["alchemy tooltip"]  ,
	-- 	getFunc = function() return WritCreater:GetSettings()[CRAFTING_TYPE_ALCHEMY] end,
	-- 	setFunc = function(value) 
	-- 		WritCreater:GetSettings()[CRAFTING_TYPE_ALCHEMY] = value 
	-- 	end,

	-- },
	{
		type = "dropdown",
		name = WritCreater.optionStrings["alchemy"],
		tooltip = WritCreater.optionStrings["alchemy tooltip"],
		choices = WritCreater.optionStrings["alchemyChoices"],
		choicesValues =  {false, true, "nocraft"},
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
}

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


local function addToControlTable(newOption, t)
	t.indexed[#t.indexed + 1 ] = newOption
	if newOption.LHASName then
		t.nameMap[newOption.LHASName] = newOption
	else
		t.nameMap[newOption.label] = newOption
	end
	newOption.conversionIndex = #t.indexed
end
local function LAMtoHASDropdownConverter(option, controlTable)
	local newOption = {
		type = LibHarvensAddonSettings.ST_DROPDOWN,
		label = option.name,
		default = option.default,
		-- setFunction = option.setFunc,
		getFunction = option.getFunc,
		tooltip = option.tooltip,
		disable = option.disabled,
		LHASName = option.LHASName,
	}

	newOption.setFunction = function(combobox, name, item) option.setFunc(item.data) end
	
	local items = {}
	local labelMap = {}
	for i = 1, # option.choices do
		items[i] = {name = option.choices[i], data = option.choicesValues[i]}
		if option.choicesValues[i] then
			labelMap[items[i].data] = items[i].name
		end
	end
	newOption.items = items
	newOption.getFunction = function() return labelMap[option.getFunc()]  end
	addToControlTable(newOption, controlTable)
end
local function LamToHASDividerConverter(entry, controlTable, optionalLabel)
    newOption = {
        type = LibHarvensAddonSettings.ST_SECTION,
        label = "",
        LHASName = entry.LHASName,
    }
    addToControlTable(newOption, controlTable)
end

local function convertlamToHasTable(optionsTable, controlTable)
	local LAMtoHAS = {
		slider = LibHarvensAddonSettings.ST_SLIDER,
		header = LibHarvensAddonSettings.ST_SECTION,
		checkbox = LibHarvensAddonSettings.ST_CHECKBOX,
		colorpicker = LibHarvensAddonSettings.ST_COLOR,
		button = LibHarvensAddonSettings.ST_BUTTON,
		editbox = LibHarvensAddonSettings.ST_EDIT,
	}
	local LAMtoHASSpecial = {
		dropdown = LAMtoHASDropdownConverter,
		submenu = function(option, controlTable) convertlamToHasTable(option.controls, controlTable) end,
		divider = LamToHASDividerConverter,
	}
	local controlTable = controlTable or {
		indexed = {},
		nameMap = {},
	}
	
	-- LAMHASMissing = {}
	
	for i, entry in ipairs(optionsTable) do
		local newType = LAMtoHAS[entry.type]
		if newType and not entry.isPCOnly then
			local newOption = {
				type = newType,
				label = entry.name,
				LHASName = entry.LHASName,
				default = entry.default,
				setFunction = entry.setFunc,
				getFunction = entry.getFunc,
				tooltip = entry.tooltip,
				min = entry.min,
				max = entry.max,
				step = entry.step,
				disable = entry.disabled,
				clickHandler = entry.func,
				buttonText = entry.name,
			}
			addToControlTable(newOption, controlTable)
			-- settings:AddSetting(newOption)
		elseif LAMtoHASSpecial[entry.type] then
			LAMtoHASSpecial[entry.type](entry, controlTable)
		else
			-- LAMHASMissing[entry.type] = entry.type
		end
	end
	return controlTable
end

function WritCreater.generateHASConversions()
	if not LibHarvensAddonSettings then return end
	local optionsTable = WritCreater.Options()
	WritCreater.lamConvertedOptions = {}
	local controlTable = convertlamToHasTable(optionsTable)
	WritCreater.lamConvertedOptions = controlTable.nameMap
end

function WritCreater.initializeSettingsMenu()
	local LAM = LibAddonMenu2
	if LAM and not IsConsoleUI() then
		LAM:RegisterAddonPanel("DolgubonsWritCrafter", WritCreater.settings["panel"])
		WritCreater.settings["options"] = WritCreater.Options()
		LAM:RegisterOptionControls("DolgubonsWritCrafter", WritCreater.settings["options"])
	end
end