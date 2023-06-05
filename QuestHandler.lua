-----------------------------------------------------------------------------------
-- Addon Name: Dolgubon's Lazy Writ Crafter
-- Creator: Dolgubon (Joseph Heinzle)
-- Addon Ideal: Simplifies Crafting Writs as much as possible
-- Addon Creation Date: March 14, 2016
--
-- File Name: QuestHandler.lua
-- File Description: Handles automatic acceptance and completion of quests
-- Load Order Requirements: None
-- 
-----------------------------------------------------------------------------------


WritCreater = WritCreater or {}
local completionStrings
local function onWritComplete()
	local zoneIndex = GetUnitZoneIndex("player")
	local zoneId = GetZoneId(zoneIndex)
	if WritCreater.savedVarsAccountWide.writLocations[zoneId] then
		return
	end
	
	local _,x,_, y = GetUnitWorldPosition("player")
	WritCreater.savedVarsAccountWide.writLocations[zoneId] = {zoneIndex, x, y, 640000}

end

-- Handles the dialogue where we actually complete the quest
local function HandleQuestCompleteDialog(eventCode, journalIndex)
	local writs = WritCreater.writSearch()
	if not GetJournalQuestIsComplete(journalIndex) then return end
	local currentWritDialogue 
	for i = 1, 7 do
		if writs[i] == journalIndex then -- determine which type of writ it is
			
			currentWritDialogue= i
		end
	end
	--d(writs[currentWritDialogue])
	--d(journalIndex)
	if zo_plainstrfind( ZO_InteractWindowTargetAreaTitle:GetText() ,completionStrings["Rolis Hlaalu"]) then
		--d("complete")
		CompleteQuest()
		EVENT_MANAGER:UnregisterForEvent(WritCreater.name, EVENT_QUEST_COMPLETE_DIALOG)
		WritCreater.analytic()
		return 
	end
	EVENT_MANAGER:UnregisterForEvent(WritCreater.name, EVENT_QUEST_COMPLETE_DIALOG)
	if not currentWritDialogue then return end
	
	-- Increment the number of writs complete number
	WritCreater.savedVarsAccountWide["rewards"][currentWritDialogue]["num"] = WritCreater.savedVarsAccountWide["rewards"][currentWritDialogue]["num"] + 1
	WritCreater.savedVarsAccountWide["total"] = WritCreater.savedVarsAccountWide["total"] + 1
    -- Complete the writ quest
    WritCreater.analytic()
    if not WritCreater:GetSettings().autoAccept then return end
	CompleteQuest()
	onWritComplete()


end

local wasQuestAccepted

-- Handles the dialogue where we actually accept the quest
local function HandleEventQuestOffered(eventCode)
    -- Stop listening for quest offering
    EVENT_MANAGER:UnregisterForEvent(WritCreater.name, EVENT_QUEST_OFFERED)
    -- Accept the writ quest
    wasQuestAccepted = true
    AcceptOfferedQuest()
end

-- Checks if we should deal with this type of quest or not
local function isQuestTypeActive(optionString)
	optionString = string.gsub(optionString, "couture","tailleur")

	for i = 1, 7 do
		if string.find(string.lower(optionString), string.lower(WritCreater.writNames[i])) and (WritCreater:GetSettings()[i] or WritCreater:GetSettings()[i]==nil) then 
			return true
		
		end
	end

	return false
end

-- Automatically accepts master writs. Off by default but it's written so not deleting it just in case
local function handleMasterWritQuestOffered()

	local a = {GetOfferedQuestInfo()}
	-- If it is a Master Writ offering
    if string.find(a[1], completionStrings["Rolis Hlaalu"]) and a[2] == completionStrings.masterStart and not WritCreater:GetSettings().preventMasterWritAccept then

		--d("Accept")
    	AcceptOfferedQuest()
	end
end

--EVENT_MANAGER:RegisterForEvent("DolgubonsLazyWritCreatorMasterWrit", EVENT_QUEST_OFFERED, handleMasterWritQuestOffered)
-- Handles dialogue start. It will fire on any NPC dialogue, so we need to filter out a bit
local function HandleChatterBegin(eventCode, optionCount)

	
    -- Ignore interactions with no options
    if optionCount == 0 then return end

    for i = 1, optionCount do
	    -- Get details of first option

	    local optionString, optionType = GetChatterOption(i)

	    -- If it is a writ quest option...
	    if optionType == CHATTER_START_NEW_QUEST_BESTOWAL 
	       and string.find(string.lower(optionString), string.lower(WritCreater.writNames["G"])) ~= nil 
	    then
	    	if not WritCreater:GetSettings().autoAccept then return end
	    	if isQuestTypeActive(optionString) then
				-- Listen for the quest offering
				EVENT_MANAGER:RegisterForEvent(WritCreater.name, EVENT_QUEST_OFFERED, HandleEventQuestOffered)
				-- Select the first writ
				SelectChatterOption(i)
				return
			else
				if i == optionCount and wasQuestAccepted then
					EndInteraction( INTERACTION_CONVERSATION)
					wasQuestAccepted = nil
				end
			end
			
	    -- If it is a writ quest completion option
	    elseif optionType == CHATTER_START_ADVANCE_COMPLETABLE_QUEST_CONDITIONS
	       and string.find(string.lower(optionString), string.lower(completionStrings.place)) ~= nil  
	    then
	    	if not WritCreater:GetSettings().autoAccept then return end
	        -- Listen for the quest complete dialog
	        EVENT_MANAGER:RegisterForEvent(WritCreater.name, EVENT_QUEST_COMPLETE_DIALOG, HandleQuestCompleteDialog)
	        -- Select the first option to complete the quest
	        SelectChatterOption(1)
	        return
	    
	    -- If the goods were already placed, then complete the quest
	    elseif optionType == CHATTER_START_COMPLETE_QUEST
	       and (string.find(string.lower(optionString), string.lower(completionStrings.place)) ~= nil 
	            or string.find(string.lower(optionString), string.lower(completionStrings.sign)) ~= nil)
	    then
	    	if not WritCreater:GetSettings().autoAccept then return end
	        -- Listen for the quest complete dialog
	        EVENT_MANAGER:RegisterForEvent(WritCreater.name, EVENT_QUEST_COMPLETE_DIALOG, HandleQuestCompleteDialog)
	        -- Select the first option to place goods and/or sign the manifest
	        SelectChatterOption(1)
	        return
	        -- Talking to the master writ person?
	    elseif zo_plainstrfind( ZO_InteractWindowTargetAreaTitle:GetText() ,completionStrings["Rolis Hlaalu"]) then 
	    	if not WritCreater:GetSettings().autoAccept then return end
	    	--d(optionType)
	    	--d(optionString)
		    if optionType == CHATTER_START_ADVANCE_COMPLETABLE_QUEST_CONDITIONS
		       and string.find(string.lower(optionString), string.lower(completionStrings.masterPlace)) ~= nil  
		    then
		        -- Listen for the quest complete dialog
		        EVENT_MANAGER:RegisterForEvent(WritCreater.name, EVENT_QUEST_COMPLETE_DIALOG, HandleQuestCompleteDialog)
		        -- Select the first option to complete the quest
		        --d("Chat")
		        SelectChatterOption(1)
		        return
		        -- If the goods were already placed, then complete the quest
		    elseif optionType == CHATTER_START_COMPLETE_QUEST
		       and (string.find(string.lower(optionString), string.lower(completionStrings.masterPlace)) ~= nil 
		            or string.find(string.lower(optionString), string.lower(completionStrings.masterSign)) ~= nil)
		    then
		        -- Listen for the quest complete dialog
		        EVENT_MANAGER:RegisterForEvent(WritCreater.name, EVENT_QUEST_COMPLETE_DIALOG, HandleQuestCompleteDialog)
		        -- Select the first option to place goods and/or sign the manifest
		        --d("Chat2")
		        SelectChatterOption(1)
		        return
		    end
		elseif optionType == CHATTER_START_BANK then
			if WritCreater:GetSettings().autoCloseBank then
				WritCreater.alchGrab()
			end
	    end
	end
end


--[[
WritCreater.savedVarsAccountWide.writLocations={
WritCreater.savedVarsAccountWide.writLocations[645] =  {1011 , 146161, 341851, 1000000}, -- summerset
WritCreater.savedVarsAccountWide.writLocations[496]= {849 , 215118,  512682, 900000 },-- vivec check
WritCreater.savedVarsAccountWide.writLocations[179]= {382 ,122717,  187928, 1000000},-- Rawlkha
WritCreater.savedVarsAccountWide.writLocations[16]= {103 , 366252, 201624 , 2000000}, -- Riften
WritCreater.savedVarsAccountWide.writLocations[154] = {347 , 237668,  302699, 1000000 },-- coldharbour chek
WritCreater.savedVarsAccountWide.writLocations[5] = {20 ,243273, 227612, 1000000 },  -- Shornhelm 
WritCreater.savedVarsAccountWide.writLocations[10] = {57 ,231085, 249391, 1000000 }, -- Mournhold
}
]]
-- Initialize the event listener, and grab the language strings

local function isQuestWritQuest(questId)
	local writs = WritCreater.writSearch()
	for k, v in pairs(writs) do
		if v == questId then
			return true
		end
	end
end

local function hookIndexEvent(event)
	local originalAdded = ZO_CenterScreenAnnounce_GetEventHandlers()[ event]
	ZO_CenterScreenAnnounce_GetEventHandlers()[ event] = function(...)
	originalAdded(...)
		local params={...} 
		local questIndex = params[1]
		if isQuestWritQuest(questIndex) then 
			return 
		end 
		return originalAdded(...)
	end
end

local function OnQuestAdvanced(eventId, questIndex, questName, isPushed, isComplete, mainStepChanged)
	
	if WritCreater:GetSettings().suppressQuestAnnouncements and isQuestWritQuest(questIndex) then
		return 
	end

    if(not mainStepChanged) then
    	return
    end
    local announceObject = CENTER_SCREEN_ANNOUNCE
    local sound = SOUNDS.QUEST_OBJECTIVE_STARTED
    for stepIndex = QUEST_MAIN_STEP_INDEX, GetJournalQuestNumSteps(questIndex) do
        local a, visibility, stepType, stepOverrideText, conditionCount = GetJournalQuestStepInfo(questIndex, stepIndex)
        if visibility == nil or visibility == QUEST_STEP_VISIBILITY_OPTIONAL then
            if stepOverrideText ~= "" then
                local messageParams = CENTER_SCREEN_ANNOUNCE:CreateMessageParams(CSA_CATEGORY_SMALL_TEXT, sound)
                messageParams:SetText(stepOverrideText)
                messageParams:SetCSAType(CENTER_SCREEN_ANNOUNCE_TYPE_QUEST_PROGRESSION_CHANGED)
                announceObject:AddMessageWithParams(messageParams)
                sound = nil -- no longer needed, we played it once
            else
                for conditionIndex = 1, conditionCount do
                    local conditionText, curCount, maxCount, isFailCondition, isConditionComplete, _, isVisible  = GetJournalQuestConditionInfo(questIndex, stepIndex, conditionIndex)

                    if not (isFailCondition or isConditionComplete) and isVisible then
                        local messageParams = CENTER_SCREEN_ANNOUNCE:CreateMessageParams(CSA_CATEGORY_SMALL_TEXT, sound)
                        messageParams:SetText(conditionText)
                        messageParams:SetCSAType(CENTER_SCREEN_ANNOUNCE_TYPE_QUEST_PROGRESSION_CHANGED)
                        announceObject:AddMessageWithParams(messageParams)
                        sound = nil -- no longer needed, we played it once
                    end
                end
            end
        end
    end
end
WritCreater.OnQuestAdvanced = OnQuestAdvanced
local function rejectQuest(questIndex)
	for itemLink, _ in pairs(WritCreater:GetSettings().skipItemQuests) do
		if not WritCreater:GetSettings().skipItemQuests[itemLink] then
			for i = 1, GetJournalQuestNumConditions(questIndex) do
				if DoesItemLinkFulfillJournalQuestCondition(itemLink, questIndex, 1, i)  then
					return itemLink
				end
			end
		end
	end
	return false
end
-- ta, oko, nirnroot, coprinus, mudcrab
local function OnQuestAdded(eventId, questIndex)
	local rejectedMat = rejectQuest(questIndex)
	if rejectedMat then
		d("Writ Crafter abandoned the "..GetJournalQuestName(questIndex).." because it requires "..rejectedMat.." which was disallowed for use in the settings")
		zo_callLater(function() AbandonQuest(questIndex) end , 500)
		return
	end
	if WritCreater:GetSettings().suppressQuestAnnouncements and isQuestWritQuest(questIndex) then 
		return 
	end 
    OnQuestAdvanced(EVENT_QUEST_ADVANCED, questIndex, nil, nil, nil, true)
end

local function centerScreenAnnouncingHandlerHooks()
	EVENT_MANAGER:UnregisterForEvent("CSA_MiscellaneousHandlers", EVENT_QUEST_ADDED)
	EVENT_MANAGER:RegisterForEvent("CSA_MiscellaneousHandlers", EVENT_QUEST_ADDED, OnQuestAdded)
	EVENT_MANAGER:UnregisterForEvent("CSA_MiscellaneousHandlers", EVENT_QUEST_ADVANCED)
	EVENT_MANAGER:RegisterForEvent("CSA_MiscellaneousHandlers", EVENT_QUEST_ADVANCED, OnQuestAdvanced)
	hookIndexEvent(EVENT_QUEST_ADDED)
	hookIndexEvent(EVENT_QUEST_CONDITION_COUNTER_CHANGED)
end

local id1 = GetAchievementIdFromLink("|H1:achievement:2225:1:1527019147|h|h")
local id2 = GetAchievementIdFromLink("|H1:achievement:1145:63:1464348343|h|h")

local function getBuffer()
	local buffer = 0
	for i = 1, 6 do
		local _, isComplete = GetAchievementCriterion(1145, i)
		buffer = buffer + isComplete
	end
	if IsAchievementComplete(2225) then
		buffer = buffer + 1
	end
	return buffer
end
--ERROR, GetString(SI_ERROR_QUEST_LOG_FULL), SOUNDS.GENERAL_ALERT_ERROR
local function checkIfCanAcceptQuest()
	-- Check if they can do jewelry writs
	if not WritCreater:GetSettings().keepQuestBuffer then
		return false
	end
	if string.find(string.lower(GetChatterOption(1)), string.lower(WritCreater.writNames["G"])) ~= nil  then
		return false
	end
	local numWrits = NonContiguousCount(WritCreater.writSearch())
	if GetNumJournalQuests() == 25 then
		return false
	end
	if 25 - getBuffer() + numWrits < GetNumJournalQuests() + 1 then
		-- ZO_Alert(ERROR, SOUNDS.GENERAL_ALERT_ERROR ,"This would eat into the writ Quest Buffer! If you still want to accept it, turn off Quest Buffer in Writ Crafter settings")
		ZO_Alert(ERROR, SOUNDS.GENERAL_ALERT_ERROR ,"The writ Quest Buffer from Lazy Writ Crafter™ is preventing you from accepting this quest")
		return true
	end
	return false
end
ZO_PreHook("AcceptSharedQuest", checkIfCanAcceptQuest)
ZO_PreHook("AcceptOfferedQuest", checkIfCanAcceptQuest)

function WritCreater.InitializeQuestHandling()
	EVENT_MANAGER:RegisterForEvent(WritCreater.name, EVENT_CHATTER_BEGIN, HandleChatterBegin)
	completionStrings = WritCreater.writCompleteStrings()
	local original = AcceptOfferedQuest
	AcceptOfferedQuest = function()
		if string.find(GetOfferedQuestInfo(), completionStrings["Rolis Hlaalu"]) and WritCreater:GetSettings().preventMasterWritAccept then 
			d(WritCreater.strings.masterWritSave)  
		else 
			original() 
		end 
	end
	for k, v in pairs(WritCreater.defaultAccountWide.writLocations) do
		WritCreater.savedVarsAccountWide.writLocations[k] = v
	end
	centerScreenAnnouncingHandlerHooks()
end

-- /script JumpToSpecificHouse("@marcopolo184", 46)