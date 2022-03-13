-----------------------------------------------------------------------------------
-- Addon Name: Dolgubon's Lazy Writ Crafter
-- Creator: Dolgubon (Joseph Heinzle)
-- Addon Ideal: Simplifies Crafting Writs as much as possible
-- Addon Creation Date: March 14, 2016
--
-- File Name: AlchGrab.lua
-- File Description: This file removes items required for writs from the bank
-- Load Order Requirements: None
-- 
-----------------------------------------------------------------------------------

WritCreater = WritCreater or {}


local function specialDebug(...)
	if WritCreater.savedVarsAccountWide.bankDebug then
		--df("[%s] " .. message, ADDON_NAME, ...)
		d(...)
	end
end

local function dbug(...)
	DolgubonGlobalDebugOutput(...)
end

--
-- 
function numPotEffects(link)
	local typei= GetItemLinkItemType(link)
	if typei == ITEMTYPE_POTION or typei == ITEMTYPE_POISON then else return 0 end
	local potionInfo = { ZO_LinkHandler_ParseLink(link) }
	local traitInfo = potionInfo[24]

	count = math.floor(1/(math.floor(traitInfo / 65536) % 256 +1))
	count =count +  math.floor(1/(math.floor(traitInfo / 256) % 256 +1))
	count =count +  math.floor(1/(traitInfo % 256 + 1))
	return 3 - count
end
--helper functions

local function hexConversion(IN)

	local B,K,OUT,I,D=16,"0123456789ABCDEF","",0
	while IN>0 do
		I=I+1
		IN,D=math.floor(IN/B), IN%B+1
		OUT=string.sub(K,D,D)..OUT
	end
	return OUT
end

local timesToRun = 0

local queue = {}





DolgubonTest = false

local emptySlots = {}

local function findEmptySlots(location)
	specialDebug("WC Debug Locating empty slots in backpack")
	emptySlots = {}
	for i = FindFirstEmptySlotInBag(location) or 250, GetBagSize(location) - 1 do
		if GetItemName(location, i) == "" then
			emptySlots[#emptySlots + 1] = i
		end
	end
	return nil
end


local function myLower(str)
	return zo_strformat("<<z:1>>",str)-- "Rüstung der Verführung^f"
end

local function standardizeString(str)
	str = myLower(str)
	str = string.gsub(str,"-"," ")
	str = string.gsub(str,"ä","a")
	str = string.gsub(str,"ü","u")
	str = string.gsub(str,"ö","o")
	return str
end

local function strFind(str, str2find, a, b, c)
	str = standardizeString(str)
	str2find = standardizeString(str2find)
	return string.find(str, str2find, a, b, c)
end

local saidBankIsFull = false

local function moveItem( amountRequired, bag, slot, secondTry)
	if GetInteractionType()~=INTERACTION_BANK and GetInteractionType() == INTERACTION_CONVERSATION then
		for i= 1, GetChatterOptionCount() do
			local _, optiontype = GetChatterOption(i)
			if optiontype == CHATTER_START_BANK then
				SelectChatterOption(i)
			end
		end
	end

	-- if not IsBankOpen() then
	-- 	if not secondTry then
	-- 		zo_callLater(function() moveItem( amountRequired, bag, slot, true) end, 100)
	-- 	end
	-- 	return
	-- end
	local emptySlot = emptySlots[1]
	local _,remainingInBank = GetItemLinkStacks(GetItemLink(bag, slot))
	if emptySlot and GetItemName(BAG_BACKPACK, emptySlot)=="" then
		table.remove(emptySlots,1)
		specialDebug("WC Debug Moving item to bag")
		if IsProtectedFunction("RequestMoveItem") then
			CallSecureProtected("RequestMoveItem", bag, slot, BAG_BACKPACK,emptySlot,amountRequired)
		else
			RequestMoveItem(bag, slot, BAG_BACKPACK,emptySlot,amount)
		end
		d(WritCreater.strings.withdrawItem(tostring(amountRequired), GetItemLink(bag, slot,0) , math.max(0,remainingInBank - amountRequired )))
	else
		if not saidBankIsFull then
			d(WritCreater.strings.fullBag)
			saidBankIsFull = true
		end

		return false
	end
	return true

end

local function isPotentialMatch(validItemTypes, bag, slot, quest, stepindex, conditionindex)
	local name = GetItemName(bag, slot)
	if name == "" then return false end
	local itemType = GetItemType(bag, slot)
	if validItemTypes[itemType] then
		
		local link = GetItemLink(bag, slot)
		specialDebug("WC Debug Item is correct type of item (e.g. food, weapon)")
		specialDebug("WC Debug Item Link: "..link)
		
		
		if DoesItemFulfillJournalQuestCondition(bag, slot, quest, stepindex, conditionindex) then 
			
			return true 
		end
	end
	return false
end

local function filterMatches(matches)
	local traits = 4
	if #matches== 0 then
		specialDebug("WC Debug No potential matches")
		return nil, nil
	elseif #matches==1 then
		specialDebug("WC Debug Only one potential match. Item wins by default")
		return matches[1][1], matches[1][2]
	else
		specialDebug("WC Debug Multiple matches. Longest item will be withdrawn")
		local longest = 0
		local position = 0
		for i = 1, #matches do
			local traitAmount = numPotEffects(GetItemLink(matches[i][1], matches[i][2])) 
			if traitAmount<traits then
				position = i
				traits=traitAmount
			end
		end
		specialDebug("WC Debug "..GetItemLink(matches[position][1], matches[position][2]).." had the longest name and will now be withdrawn")
		return matches[position][1], matches[position][2]
	end

end
local bagList = {BAG_BANK, BAG_SUBSCRIBER_BANK, BAG_HOUSE_BANK_EIGHT ,BAG_HOUSE_BANK_FIVE ,BAG_HOUSE_BANK_FOUR,
	BAG_HOUSE_BANK_ONE ,BAG_HOUSE_BANK_SEVEN ,BAG_HOUSE_BANK_SIX  ,BAG_HOUSE_BANK_THREE ,BAG_HOUSE_BANK_TWO ,}
local houseBagList =  {BAG_HOUSE_BANK_EIGHT ,BAG_HOUSE_BANK_FIVE ,BAG_HOUSE_BANK_FOUR,
		BAG_HOUSE_BANK_ONE ,BAG_HOUSE_BANK_SEVEN ,BAG_HOUSE_BANK_SIX  ,BAG_HOUSE_BANK_THREE ,BAG_HOUSE_BANK_TWO ,}
local function potionGrabRefactored(questCondition, amountRequired, validItemTypes, quest, stepindex, conditionindex)
	specialDebug("WC Debug Beggining Bank Withdrawal Sequence")
	specialDebug("Attempting to find items for "..questCondition)
	specialDebug(" We need ".. amountRequired)
	specialDebug("Valid itemTypes are the table keys of the following table:")
	specialDebug(validItemTypes )
	local potentialMatches = {}
	local storageIncluded = false
	local bags = bagList
	if (GetBankingBag()==BAG_DELETE and GetInteractionType() ~= INTERACTION_CONVERSATION ) and GetCurrentZoneHouseId() >0 then
		bags = houseBagList
	end
	for i = 1, #bags do
		local bagId = bags[i]
		specialDebug("Searching bag number "..bagId)
		specialDebug("Bag has a size of "..GetBagSize(bagId))
		for i=0, GetBagSize(bagId) do -- check the rest of the bank
			if i < 5 and GetItemName(bagId, i)~="" then specialDebug("Checking item in slot "..i.." which has name "..GetItemName(bagId, i).." and itemType "..GetItemType(bagId, i)) end
			if isPotentialMatch(validItemTypes, bagId, i, quest, stepindex, conditionindex) then 
				-- Add to match list
				table.insert(potentialMatches, {bagId, i})
			end
		end
	end
	local bag, slot = filterMatches(potentialMatches)
	if bag and slot then
		local stackSize = GetSlotStackSize(bag, slot)
		if stackSize < amountRequired then
			specialDebug("WC Debug User does not have enough items for quest in the bank. Moving what is there, and checking again after")
			queue[#queue + 1]  = function() return potionGrabRefactored(questCondition, amountRequired -stackSize, validItemTypes ) end 
		else
			specialDebug("WC Debug User has enough items for quest. Withdrawing items")
			if not moveItem(amountRequired, bag, slot) then
				return false
			end
			return true
		end

	else
		-- No item was found. Would love to do an error message but would need to filter out delivery, glyphs, etc. in other languages
	end
end

local function exceptions(condition)
	
	
	return condition
end


local alchGrab = function() end
local wasItemInQueue
local function queueRun()
	if queue[1] then
		local result = queue[1]() 
		if result == false then
			wasItemInQueue = false
		elseif result and wasItemInQueue ~= false then
			wasItemInQueue = true
		end
		table.remove(queue, 1)
		zo_callLater(queueRun, 10)
		--queueRun()
	else
		if wasItemInQueue and  WritCreater:GetSettings().autoCloseBank then
			local function recursiveCall() 
				zo_callLater(
					function() 
						if GetInteractionType()==6 then
							if WritCreater:GetSettings().despawnBanker then
								ZO_SharedInteraction:CloseChatterAndDismissAssistant()
							end
							SCENE_MANAGER:Show('hud')
							recursiveCall()
						end
					end , 200) 
				end
			recursiveCall()
		end
		saidBankIsFull = false
		wasItemInQueue = nil
		queue = {}
		--emptySlots = {}
	end
end

local function addToQueue(questIndex, validItemTypes)
	for j=1,4 do 
		local a=GetJournalQuestConditionInfo(questIndex, 1, j)
		local cur, max =GetJournalQuestConditionValues(questIndex,1,j)

		a=a:lower()
		a = exceptions(a)
		a = string.gsub(a, " ", " ") -- First is a NO-BREAK SPACE, 2nd a SPACE, copied from Ayantir's BMR just in case
		if cur < max and a~="" then 

			queue[#queue + 1] = function() return potionGrabRefactored(a, max - cur, validItemTypes, questIndex, 1, j) end

			
		end
	end
end

local function equipmentCheck(link, bag, slot)
	return GetItemCreatorName(bag, slot)~= GetUnitName("player") or 
		GetItemTrait(bag, slot) ~= ITEM_TRAIT_TYPE_NONE or GetItemLinkQuality(link) ~= ITEM_QUALITY_NORMAL or 
		GetItemRequiredChampionPoints(bag, slot) == 160 or IsItemPlayerLocked(bag, slot) 
end


local validItemTypes = 
{
	[CRAFTING_TYPE_ALCHEMY] = {
		[ITEMTYPE_POTION] = {true, function(link) return numPotEffects(link)==0 end},
		[ITEMTYPE_POISON] = {true, function(link) return numPotEffects(link)==0 end},
		[ITEMTYPE_POTION_BASE] = {true},
		[ITEMTYPE_POISON_BASE] = {true},
		[ITEMTYPE_REAGENT] = {true},
	},
	[CRAFTING_TYPE_ENCHANTING] = {
		[ITEMTYPE_ENCHANTING_RUNE_ASPECT] = {true},
		[ITEMTYPE_ENCHANTING_RUNE_ESSENCE] = {true},
		[ITEMTYPE_ENCHANTING_RUNE_POTENCY] = {true},
		[ITEMTYPE_GLYPH_ARMOR] = {true, function(link) return not IsItemLinkCrafted(link) end},
	},
	[CRAFTING_TYPE_PROVISIONING] = {
		[ITEMTYPE_DRINK] = {true, function(link) return GetItemLinkQuality(link)~=ITEM_QUALITY_MAGIC end},
		[ITEMTYPE_FOOD] = {true, function(link) return GetItemLinkQuality(link)~=ITEM_QUALITY_MAGIC end},
	},
	-- [[
	[CRAFTING_TYPE_BLACKSMITHING] = {
		[ITEMTYPE_ARMOR] = {true, equipmentCheck},
		[ITEMTYPE_WEAPON] = {true,equipmentCheck},
	},
	[CRAFTING_TYPE_WOODWORKING] ={
		[ITEMTYPE_ARMOR] = {true,equipmentCheck},
		[ITEMTYPE_WEAPON] = {true,equipmentCheck },
	
	},
	[CRAFTING_TYPE_CLOTHIER] ={
		[ITEMTYPE_ARMOR] = {true,equipmentCheck},
	
	},
	--]]
}

local depositedItem = false

local function runProcessDeposits()
	if #WritCreater.pendingItemActions > 0 then
		for k, itemInfo in pairs(WritCreater.pendingItemActions) do
			if itemInfo[1] == GetItemLink(itemInfo[3], itemInfo[4]) then
				if itemInfo[2] == 2 then
					if GetInteractionType()~=INTERACTION_BANK and GetInteractionType() == INTERACTION_CONVERSATION then
						for i= 1, GetChatterOptionCount() do
							local _, optiontype = GetChatterOption(i)
							if optiontype == CHATTER_START_BANK then
								SelectChatterOption(i)
							end
						end
					end
					local bag
					local destinationSlot = FindFirstEmptySlotInBag(BAG_BANK) or FindFirstEmptySlotInBag(BAG_SUBSCRIBER_BANK)
					if FindFirstEmptySlotInBag(BAG_BANK) then
						bag = BAG_BANK
					elseif FindFirstEmptySlotInBag(BAG_SUBSCRIBER_BANK) then
						bag = BAG_SUBSCRIBER_BANK
					end
					if not bag then
						return
					end
					if IsProtectedFunction("RequestMoveItem") then
						CallSecureProtected("RequestMoveItem", itemInfo[3], itemInfo[4], bag,destinationSlot,1)
					else
						RequestMoveItem(itemInfo[3], itemInfo[4], bag,destinationSlot,itemInfo[5])
					end
					depositedItem = true
					d("Writ Crafter: Depositing "..itemInfo[1])
					WritCreater.pendingItemActions[k] = nil
					return zo_callLater( runProcessDeposits, 100)
				end
			end
		end
	elseif depositedItem and #WritCreater.pendingItemActions == 0 then
		depositedItem = false
		if WritCreater:GetSettings().despawnBanker then
			ZO_SharedInteraction:CloseChatterAndDismissAssistant()
			SCENE_MANAGER:Show('hud')
		end
	end
end

alchGrab = function (event, bag) 
	findEmptySlots(BAG_BACKPACK)
	if WritCreater.lang =="jp" then return end
	if WritCreater:GetSettings().shouldGrab then
		local writs = WritCreater.writSearch()
		for craft, validTypes in pairs(validItemTypes) do
			if writs[craft] and  (WritCreater:GetSettings()[craft] or WritCreater:GetSettings()[craft]==nil) then
				addToQueue(writs[craft], validTypes)
			end
		end
		if #queue>0 then

			--queueRun()
			zo_callLater(queueRun,WritCreater:GetSettings().delay)
		end
	end
	runProcessDeposits()

end

SLASH_COMMANDS["/testrun"] = alchGrab

WritCreater.alchGrab = alchGrab

--SLASH_COMMANDS['/testpotion'] = returnPotionLevel

function WritCreater.setupAlchGrabEvents()

	EVENT_MANAGER:RegisterForEvent(WritCreater.name, EVENT_QUEST_ADDED, function(event, journalIndex, name) 
		dbug("EVENT:Quest Added")
		dbug("Name: "..name)

	WritCreater.MasterWritsQuestAdded(event, journalIndex,name) end) 

	if not WritCreater:GetSettings().autoCloseBank then
		EVENT_MANAGER:RegisterForEvent(WritCreater.name, EVENT_OPEN_BANK, alchGrab)
	end

	EVENT_MANAGER:RegisterForEvent(WritCreater.name.." Withdraw", EVENT_PLAYER_ACTIVATED, function() if GetCurrentZoneHouseId() >0 then  alchGrab() end end)
	
	--I use SCENE_MANAGER:IsShowing("bank")

end
--|H1:item:27036:307:50:0:0:0:0:0:0:0:0:0:0:0:0:36:0:0:0:0:0|h|h
--|H1:item:54339:308:50:0:0:0:0:0:0:0:0:0:0:0:0:36:1:0:0:0:65536|h|h