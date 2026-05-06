WritCreater = WritCreater or {}

local StatusBar = DolgubonsLazyWritStatus
local containerMaximum = 0
local statusBackdrop = DolgubonsLazyWritStatusBackdrop


SLASH_COMMANDS['/dstat'] =function() StatusBar:SetHidden(false) end

local function myLower(str)
	return zo_strformat("<<z:1>>",str)
end

local function toggleStatusWindow(override)
	if containerMaximum > 0 and not WritCreater:GetSettings().showStatusBar then
		StatusBar:SetHidden(false)
		statusBackdrop:SetHidden(true)
		DolgubonsLazyWritStatusContainer:SetHidden(false)
	else
		statusBackdrop:SetHidden(false)
	end
	--WritCreater:GetSettings().lootContainerOnReceipt
	if override ~= nil then
		StatusBar:SetHidden(override)
		return
	end
	StatusBar:SetHidden(not WritCreater:GetSettings().showStatusBar)
end


local colours={
	notAccepted = {0.5,0.5,0.5},
	incomplete = "c67615",
	deliver = "32CD32",
}

local QUEST_NOT_ACCEPTED = "notAccepted"
local QUEST_INCOMPLETE = "incomplete"
local QUEST_DELIVER = "deliver"

local function isQuestDeliverable(questIndex)
	local conditionsTable = 
	{
		["text"] = {},
		["cur"] = {},
		["max"] = {},
		["complete"] = {},
		["pattern"] = {},
		["mats"] = {},
	}
	if IsJournalQuestStepEnding(questIndex, 1,1) then
		return QUEST_DELIVER
	end
	for condition = 1, GetJournalQuestNumConditions(questIndex,1) do
		conditionsTable["text"][condition], conditionsTable["cur"][condition], conditionsTable["max"][condition],_,conditionsTable["complete"][condition] = GetJournalQuestConditionInfo(questIndex, 1, condition)
		-- Check if the condition is complete or empty or at the deliver step
		if string.find(myLower(conditionsTable["text"][condition]),myLower(WritCreater.writCompleteStrings()["Deliver"])) then
			return QUEST_DELIVER
		else
		end
	end
	return QUEST_INCOMPLETE
end

local function singleQuestStatus(craftingIndex, questIndex)
	if not questIndex then
		return QUEST_NOT_ACCEPTED
	else
		return isQuestDeliverable(questIndex)
	end
end

local function computeQuestStatus ()
	local status = {
		QUEST_NOT_ACCEPTED , 
		QUEST_NOT_ACCEPTED , 
		QUEST_NOT_ACCEPTED , 
		QUEST_NOT_ACCEPTED , 
		QUEST_NOT_ACCEPTED , 
		QUEST_NOT_ACCEPTED , 
		QUEST_NOT_ACCEPTED ,
	}
	local writs = WritCreater.writSearch()
	for i = 1, 7 do
		status[i] = singleQuestStatus(i, writs[i])
	end
	return status
end

local statusOrder = 
{
	CRAFTING_TYPE_BLACKSMITHING, 
	CRAFTING_TYPE_CLOTHIER, 
	CRAFTING_TYPE_WOODWORKING, 
	CRAFTING_TYPE_JEWELRYCRAFTING ,
	CRAFTING_TYPE_ALCHEMY, 
	CRAFTING_TYPE_ENCHANTING, 
	CRAFTING_TYPE_PROVISIONING
}

local writLetters = 
{
	"B","C","E","A","P","W","J"
}

local statusIcons = {
	"esoui/art/icons/mapkey/mapkey_smithy.dds",
	"esoui/art/icons/mapkey/mapkey_clothier.dds",
	"esoui/art/icons/mapkey/mapkey_enchanter.dds",
	"esoui/art/icons/mapkey/mapkey_alchemist.dds",
	"esoui/art/icons/mapkey/mapkey_inn.dds",
	"esoui/art/icons/mapkey/mapkey_woodworker.dds",
	"esoui/art/icons/mapkey/mapkey_jewelrycrafting.dds",
	"",
}
local function statusBarWidth()
	local baseWidth = 120
	baseWidth = baseWidth + (WritCreater:GetSettings().statusBarIcons and 70 or 0)
	baseWidth = baseWidth + (WritCreater:GetSettings().statusBarInventory and 90 or 0)
	return baseWidth
end


local function updateQuestStatus(event)
	colours["incomplete"] = WritCreater:GetSettings().incompleteColour
	colours["deliver"] = WritCreater:GetSettings().completeColour
	-- StatusBar:SetDimensions(statusBarWidth(), 37)
	DolgubonsLazyWritStatusBackdrop:SetCenterColor(255, 255, 255, WritCreater:GetSettings().transparentStatusBar and 0 or 255)
	local status = computeQuestStatus()
	local workingString = ""
	local anyActive = false
	local size = 25
	if WritCreater:GetSettings().statusBarInventory then
		workingString = workingString.." |cFFFFFF"..string.format("|t%d:%d:%s:inheritColor|t",18,18,"EsoUI/Art/Tooltips/icon_bag.dds").." "..GetNumBagUsedSlots(1).."/"..GetBagSize(1).."|r "
	end
	for i = 1, 7 do
		local nextOrder = statusOrder[i]
		local nextStatus = status[nextOrder]
		local colour = colours[nextStatus]
		local colorObj = ZO_ColorDef:New(unpack(colour))
		if WritCreater:GetSettings().statusBarIcons then
			local iconStr = string.format("|t%d:%d:%s:inheritColor|t",size,size,statusIcons[nextOrder])
			iconStr = colorObj:Colorize(iconStr)
			workingString = workingString..iconStr
		else
			workingString = workingString..colorObj:Colorize(writLetters[nextOrder])
		end
		if i == 4 and not WritCreater:GetSettings().statusBarIcons then
			workingString = workingString.."  "
		end
		if nextStatus == QUEST_INCOMPLETE or nextStatus == QUEST_DELIVER then
			anyActive = true
		end
	end

	DolgubonsLazyWritStatusBackdropOutput:SetText(workingString)
	local width = DolgubonsLazyWritStatusBackdropOutput:GetTextWidth()+30
	width = math.floor(width/20)*20
	StatusBar:SetDimensions(width, 37)
	if not anyActive then
		toggleStatusWindow(true)
	else
		toggleStatusWindow()
	end
	StatusBar:ClearAnchors()
	StatusBar:SetAnchor(TOPRIGHT, GuiRoot, TOPLEFT, WritCreater:GetSettings().statusBarX, WritCreater:GetSettings().statusBarY)
	if event == EVENT_QUEST_REMOVED or event == EVENT_PLAYER_ACTIVATED or containerMaximum > 0 then
		WritCreater.updateContainerCooldown()
	end
end


function WritCreater.updateQuestStatusAnchors()
	StatusBar:ClearAnchors()
	StatusBar:SetAnchor(TOPRIGHT, GuiRoot, TOPLEFT, WritCreater:GetSettings().statusBarX, WritCreater:GetSettings().statusBarY)
end

local function inventorySlotFilter( eventCode,  bagId,  slotId,  isNewItem,  itemSoundCategory,  inventoryUpdateReason,  stackCountChange)
	if isNewItem then
		updateQuestStatus()
	elseif GetSlotStackSize(bagId, slotId) == 0 then
		updateQuestStatus()
	end
	return
end

local opened = 0
local lastOpened = 0

local function wipeContainer()
	containerMaximum = 0
	opened = 0
	-- DolgubonsLazyWritStatusContainer:SetHidden(true)
	
	-- local movieLength = 2900--4700-WritCreater.savedVarsAccountWide.applicationProgress["applicationCompletion"]*300
	
end
local animation
function WritCreater.updateContainerCooldown()
	if not WritCreater:GetSettings().showBoxCountdown then return end
	animation = animation or ZO_AlphaAnimation:New(DolgubonsLazyWritStatusContainer)
	if not WritCreater:GetSettings().lootContainerOnReceipt then
		return
	end
	DolgubonsLazyWritStatusContainer:SetHidden(false)
	local container = DolgubonsLazyWritStatusContainer
	local cooldown = DolgubonsLazyWritStatusContainerCooldown
	local label = DolgubonsLazyWritStatusContainerRemaining
	
	local numContainers = WritCreater.countContainers()
	if numContainers + opened > containerMaximum then
		containerMaximum = numContainers + opened
	end
	if numContainers == 0 then
		containerMaximum = 0
		opened = 0
		-- DolgubonsLazyWritStatusContainer:SetHidden(true)
		DolgubonsLazyWritStatusContainer:SetAlpha(0.7)
		animation:FadeOut(1000,800)
		cooldown:SetWidth(0)
		return
	end
	if numContainers + opened < containerMaximum then
		opened = containerMaximum - numContainers
	end
	if numContainers > 0 then
		toggleStatusWindow(false)
	end
	label:SetText(zo_strformat(WritCreater.strings['boxLootRemaining'], numContainers, containerMaximum))
	local width = label:GetTextWidth()+50
	DolgubonsLazyWritStatusContainer:SetWidth(width)
	
	local cooldownWidth = width * (numContainers/containerMaximum)
	cooldown:SetWidth(cooldownWidth)
	local timeout = 2000
	EVENT_MANAGER:UnregisterForUpdate(WritCreater.name.."wipeContainerProgress" ,timeout*4,wipeContainer)
	EVENT_MANAGER:RegisterForUpdate(WritCreater.name.."wipeContainerProgress", timeout*4,wipeContainer)
	DolgubonsLazyWritStatusContainer:SetAlpha(0.7)
	animation:FadeOut(timeout,800)
end

function WritCreater.addShipmentToContainerCooldown()
	-- Technically, this adds one to the opened when we loot a shipment rather than addong a shipment
	-- but it should have the intended effect
	opened = opened + 1
end

-- DolgubonsLazyWritStatus:SetHidden(false)
-- DolgubonsLazyWritStatusContainer:SetHidden(false)
WritCreater.updateQuestStatus = updateQuestStatus
function WritCreater.loadStatusBar()
	--EVENT_QUEST_COMPLETE
	EVENT_MANAGER:RegisterForEvent("WritCrafterStatusBar", EVENT_QUEST_ADDED , updateQuestStatus)
	EVENT_MANAGER:RegisterForEvent("WritCrafterStatusBar", EVENT_QUEST_ADVANCED , updateQuestStatus) -- items delivered
	EVENT_MANAGER:RegisterForEvent("WritCrafterStatusBar", EVENT_QUEST_CONDITION_COUNTER_CHANGED , updateQuestStatus) -- this one
	EVENT_MANAGER:RegisterForEvent("WritCrafterStatusBar", EVENT_OBJECTIVES_UPDATED , updateQuestStatus) -- probably not used
	EVENT_MANAGER:RegisterForEvent("WritCrafterStatusBar", EVENT_OBJECTIVE_COMPLETED , updateQuestStatus) -- probably not used
	EVENT_MANAGER:RegisterForEvent("WritCrafterStatusBar", EVENT_QUEST_REMOVED , updateQuestStatus)
	EVENT_MANAGER:RegisterForEvent("WritCrafterStatusBar", EVENT_PLAYER_ACTIVATED , updateQuestStatus)
	EVENT_MANAGER:RegisterForEvent("WritCrafterStatusBar", EVENT_INVENTORY_SINGLE_SLOT_UPDATE , updateQuestStatus)
	-- EVENT_MANAGER:AddFilterForEvent("WritCrafterStatusBar", EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_IS_NEW_ITEM, true)
	updateQuestStatus()
	StatusBar:ClearAnchors()
	StatusBar:SetAnchor(TOPRIGHT, GuiRoot, TOPLEFT, WritCreater:GetSettings().statusBarX, WritCreater:GetSettings().statusBarY)
end


WritCreater.toggleQuestStatusWindow = toggleStatusWindow