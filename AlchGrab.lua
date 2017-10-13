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


local function dbug(...)
	DolgubonGlobalDebugOutput(...)
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
	emptySlots = {}
	for i = FindFirstEmptySlotInBag(location) or 250, GetBagSize(location) do
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

local function moveItem( amountRequired, bag, slot)
	local emptySlot = emptySlots[1]

	if emptySlot then
		table.remove(emptySlots,1)
		if IsProtectedFunction("RequestMoveItem") then
			CallSecureProtected("RequestMoveItem", bag, slot, BAG_BACKPACK,emptySlot,amountRequired)
		else
			RequestMoveItem(bag, slot, BAG_BACKPACK,emptySlot,amount)
		end
		d("Dolgubon's Lazy Writ Crafter retrieved "..tostring(amountRequired).." "..GetItemLink(bag, slot,0))
	else
		d("You have no open bag spaces. Please empty your bag.")
	end

end

local function isPotentialMatch(questCondition, validItemTypes, bag, slot)
	local itemType = GetItemType(bag, slot)
	if name == "" then return false end
	if validItemTypes[itemType] then
		local name = GetItemName(bag, slot)
		local link = GetItemLink(bag, slot)		
		if validItemTypes[itemType][2] and validItemTypes[itemType][2](link, bag, slot) then return false end
		if strFind(questCondition, " "..name.." ") then
			return true
		end
	end
	return false
end

local function filterMatches(matches)
	if #matches== 0 then
		return nil, nil
	elseif #matches==1 then
		return matches[1][1], matches[1][2]
	else
		local longest = 0
		local position = 0
		for i = 1, #matches do
			if string.len(GetItemName(matches[i][1], matches[i][2]))>longest then
				longest = string.len(GetItemName(matches[i][1], matches[i][2]))
				position = i
			end
		end
		return matches[position][1], matches[position][2]
	end

end

local function potionGrabRefactored(questCondition, amountRequired, validItemTypes)
	questCondition = string.gsub(questCondition, " ", " ") -- First is a NO-BREAK SPACE, 2nd a SPACE, copied from Ayantir's BMR just in case
	local potentialMatches = {}
	if IsESOPlusSubscriber() then -- check ESO+ bank
		for i = 0, GetBagSize(BAG_BANK) do
			if isPotentialMatch(questCondition, validItemTypes, BAG_SUBSCRIBER_BANK, i) then 
				table.insert(potentialMatches, {BAG_SUBSCRIBER_BANK, i})
			end
		end
	end
	for i=0, GetBagSize(BAG_BANK) do -- check the rest of the bank
		if isPotentialMatch(questCondition, validItemTypes, BAG_BANK, i) then 
			-- Add to match list
			table.insert(potentialMatches, {BAG_BANK, i})
		end
	end
	local bag, slot = filterMatches(potentialMatches)
	if bag and slot then
		local stackSize = GetSlotStackSize(bag, slot)
		if stackSize < amountRequired then
			moveItem(stackSize, bag, slot)
			zo_callLater(function() potionGrabRefactored(questCondition, amountRequired -stackSize, validItemTypes ) end , 50)
		else
			moveItem(amountRequired, bag, slot)
		end

	else
		-- No item was found. Would love to do an error message but would need to filter out delivery, glyphs, etc. in other languages
	end
end

local function exceptions(condition)
	
	condition = WritCreater.bankExceptions(condition)
	return condition
end


local alchGrab = function() end

local function queueRun()
	if queue[1] then
		queue[1]()
		table.remove(queue, 1)
		zo_callLater(queueRun, 10)
		--queueRun()
	else
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

			queue[#queue + 1] = function() potionGrabRefactored(a, max - cur, validItemTypes) end

			
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
		[ITEMTYPE_POTION] = {true, function(link) return not IsItemLinkCrafted(link) end},
		[ITEMTYPE_POISON] = {true, function(link) return not IsItemLinkCrafted(link) end},
		[ITEMTYPE_POTION_BASE] = {true},
		[ITEMTYPE_POTION_BASE] = {true},
		[ITEMTYPE_REAGENT] = {true},
	},
	[CRAFTING_TYPE_ENCHANTING] = {
		[ITEMTYPE_ENCHANTING_RUNE_ASPECT] = {true},
		[ITEMTYPE_ENCHANTING_RUNE_ESSENCE] = {true},
		[ITEMTYPE_ENCHANTING_RUNE_POTENCY] = {true},
		[ITEMTYPE_GLYPH_ARMOR] = {true, function(link) return not IsItemLinkCrafted(link) end},
	},
	[CRAFTING_TYPE_PROVISIONING] = {
		[ITEMTYPE_DRINK] = {true, function(link) return not IsItemLinkCrafted(link) end},
		[ITEMTYPE_FOOD] = {true, function(link) return not IsItemLinkCrafted(link) end},
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


alchGrab = function (event) 
	findEmptySlots(BAG_BACKPACK)
	if WritCreater.lang =="jp" then return end
	if WritCreater.savedVars.shouldGrab then
		local writs = WritCreater.writSearch()
		for craft, validTYpes in pairs(validItemTypes) do
			if writs[craft] then
				addToQueue(writs[craft], validTYpes)
			end
		end
		if #queue>0 then

			--queueRun()
			zo_callLater(queueRun,WritCreater.savedVars.delay)
		end
	end

end



WritCreater.alchGrab = alchGrab

--SLASH_COMMANDS['/testpotion'] = returnPotionLevel

function WritCreater.setupAlchGrabEvents()

	EVENT_MANAGER:RegisterForEvent(WritCreater.name, EVENT_QUEST_ADDED, function(event, journalIndex, name) 
		dbug("EVENT:Quest Added")
		dbug("Name: "..name)

	WritCreater.MasterWritsQuestAdded(event, journalIndex,name) end) 

	EVENT_MANAGER:RegisterForEvent(WritCreater.name, EVENT_OPEN_BANK, alchGrab)
	--I use SCENE_MANAGER:IsShowing("bank")

end
--|H1:item:27036:307:50:0:0:0:0:0:0:0:0:0:0:0:0:36:0:0:0:0:0|h|h
--|H1:item:54339:308:50:0:0:0:0:0:0:0:0:0:0:0:0:36:1:0:0:0:65536|h|h