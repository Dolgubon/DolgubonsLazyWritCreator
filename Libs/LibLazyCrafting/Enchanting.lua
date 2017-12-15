-----------------------------------------------------------------------------------
-- Library Name: LibLazyCrafting
-- Creator: Dolgubon (Joseph Heinzle)
-- Library Ideal: Allow addons to craft anything, anywhere
-- Library Creation Date: December, 2016
-- Publication Date: Febuary 5, 2017
--
-- File Name: Enchanting.lua
-- File Description: Contains the functions for Enchanting
-- Load Order Requirements: After LibLazyCrafting.lua
-- 
-----------------------------------------------------------------------------------

local LibLazyCrafting = LibStub("LibLazyCrafting")
local sortCraftQueue = LibLazyCrafting.sortCraftQueue

local widgetType = 'enchanting'
local widgetVersion = 1.4
if not LibLazyCrafting:RegisterWidget(widgetType, widgetVersion) then return false end

local function dbug(...)
	if not DolgubonGlobalDebugOutput then return end
	DolgubonGlobalDebugOutput(...)
end

local craftingQueue = LibLazyCrafting.craftingQueue

--------------------------------------
-- ENCHANTING HELPER FUNCTIONS

local function getItemLinkFromItemId(itemId) local name = GetItemLinkName(ZO_LinkHandler_CreateLink("Test Trash", nil, ITEM_LINK_TYPE,itemId, 1, 26, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 10000, 0)) 
	return ZO_LinkHandler_CreateLink(zo_strformat("<<t:1>>",name), nil, ITEM_LINK_TYPE,itemId, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) end

local function areIdsValid(potency, essence, aspect)
	if GetItemLinkEnchantingRuneClassification( getItemLinkFromItemId(potency)) ~= ENCHANTING_RUNE_POTENCY
		or GetItemLinkEnchantingRuneClassification( getItemLinkFromItemId(aspect)) ~= ENCHANTING_RUNE_ASPECT
		or GetItemLinkEnchantingRuneClassification( getItemLinkFromItemId(essence)) ~= ENCHANTING_RUNE_ESSENCE then

		return false
	else
		return true
	end
end

local function copy(t)
	local a = {}
	for k, v in pairs(t) do
		a[k] = v
	end
	return a
end

-----------------------------------------------------
-- ENCHANTING USER INTERACTION FUNCTIONS

-- Since bag indexes can change, this ignores those. Instead, it takes in the name, or the index (table of indexes is found in table above, and is specific to this library)
-- Bag indexes will be determined at time of crafting	
local function LLC_CraftEnchantingGlyphItemID(self, potencyItemID, essenceItemID, aspectItemID, autocraft, reference)
	dbug('FUNCTION:LLCEnchantCraft')
	if reference == nil then reference = "" end
	if not self then d("Please call with colon notation") end
	if autocraft==nil then autocraft = self.autocraft end
	if not potencyItemID or not essenceItemID or not aspectItemID then  return end
	if not areIdsValid(potencyItemID, essenceItemID, aspectItemID) then d("invalid essence Ids") return end

	table.insert(craftingQueue[self.addonName][CRAFTING_TYPE_ENCHANTING],
	{
		["potencyItemID"] = potencyItemID,
		["essenceItemID"] = essenceItemID,
		["aspectItemID"] = aspectItemID,
		["timestamp"] = GetTimeStamp(),
		["autocraft"] = autocraft,
		["Requester"] = self.addonName,
		["reference"] = reference,
		["station"] = CRAFTING_TYPE_ENCHANTING,
	}
	)

	--sortCraftQueue()
	if GetCraftingInteractionType()==CRAFTING_TYPE_ENCHANTING then 
		LibLazyCrafting.craftInteract(event, CRAFTING_TYPE_ENCHANTING) 
	end
end

local function LLC_CraftEnchantingGlyph(self, potencyBagId, potencySlot, essenceBagId, essenceSlot, aspectBagId, aspectSlot, autocraft, reference)
	LLC_CraftEnchantingGlyphItemID(self, GetItemId(potencyBagId, potencySlot),GetItemId(essenceBagId, essenceSlot),GetItemId(aspectBagId,aspectSlot),autocraft, reference)
end

------------------------------------------------------------------------
-- ENCHANTING STATION INTERACTION FUNCTIONS

local currentCraftAttempt = 
{
	["essenceItemID"] = 0,
	["aspectItemID"] = 0,
	["potencyItemID"] = 0,
	["timestamp"] = 1234566789012345,
	["autocraft"] = true,
	["Requester"] = "",
	["slot"]  = 0,
	["link"] = "",
	["callback"] = function() end,
	["position"] = 0,

}


local function LLC_EnchantingCraftinteraction(event, station)
	dbug("FUNCTION:LLCEnchantCraft")
	local earliest, addon , position = LibLazyCrafting.findEarliestRequest(CRAFTING_TYPE_ENCHANTING)
	if not earliest then  LibLazyCrafting.SendCraftEvent( LLC_NO_FURTHER_CRAFT_POSSIBLE,  station) end
	if earliest and not IsPerformingCraftProcess() then
		local locations = 
		{
		select(1,findItemLocationById(earliest["potencyItemID"])),
		select(2,findItemLocationById(earliest["potencyItemID"])),
		select(1,findItemLocationById(earliest["essenceItemID"])),
		select(2,findItemLocationById(earliest["essenceItemID"])),
		findItemLocationById(earliest["aspectItemID"]),
		}
		if locations[1] and locations[5] and locations[3] then
			dbug("CALL:ZOEnchantCraft")
			LibLazyCrafting.isCurrentlyCrafting = {true, "enchanting", earliest["Requester"]}
			CraftEnchantingItem(unpack(locations))
			
			currentCraftAttempt= copy(earliest)
			currentCraftAttempt.callback = LibLazyCrafting.craftResultFunctions[addon]
			currentCraftAttempt.slot = FindFirstEmptySlotInBag(BAG_BACKPACK)
			currentCraftAttempt.link = GetEnchantingResultingItemLink(unpack(locations))
			currentCraftAttempt.position = position
			currentCraftAttempt.timestamp = GetTimeStamp()
			currentCraftAttempt.addon = addon

			ENCHANTING.potencySound = SOUNDS["NONE"]
			ENCHANTING.potencyLength = 0
			ENCHANTING.essenceSound = SOUNDS["NONE"]
			ENCHANTING.essenceLength = 0
			ENCHANTING.aspectSound = SOUNDS["NONE"]
			ENCHANTING.aspectLength = 0
			
		end
	end
end


local function LLC_EnchantingCraftingComplete(event, station, lastCheck)
	dbug("EVENT:CraftComplete")
	if not currentCraftAttempt.addon then return end
	if GetItemLinkName(GetItemLink(BAG_BACKPACK, currentCraftAttempt.slot,0)) == GetItemLinkName(currentCraftAttempt.link)
		and GetItemLinkQuality(GetItemLink(BAG_BACKPACK, currentCraftAttempt.slot,0)) == GetItemLinkQuality(currentCraftAttempt.link)
	then
		-- We found it!
		dbug("ACTION:RemoveQueueItem")
		table.remove(craftingQueue[currentCraftAttempt.addon][CRAFTING_TYPE_ENCHANTING] , currentCraftAttempt.position )
		--sortCraftQueue()
		local resultTable = 
		{
			["bag"] = BAG_BACKPACK,
			["slot"] = currentCraftAttempt.slot,
			['link'] = currentCraftAttempt.link,
			['uniqueId'] = GetItemUniqueId(BAG_BACKPACK, currentCraftAttempt.slot),
			["quantity"] = 1,
			["reference"] = currentCraftAttempt.reference,
		}
		
		LibLazyCrafting.SendCraftEvent( LLC_CRAFT_SUCCESS ,  station, currentCraftAttempt.addon , resultTable )
		currentCraftAttempt = {}

	elseif lastCheck then

		-- give up on finding it.
		currentCraftAttempt = {}
	else

		-- further search
		-- search again later
		if GetCraftingInteractionType()==0 then zo_callLater(function() LLC_EnchantingCraftingComplete(event, station, true) end,100) end
	end


end

local function LLC_EnchantingEndInteraction(event ,station)

	local slot = FindFirstEmptySlotInBag(BAG_BACKPACK)
	zo_callLater(function() d(GetItemLink(1,slot)) end, 3000)
	--currentCraftAttempt = nil

end

local function haveEnoughMats(...)
	local IDs = {...}
	for k, itemId in pairs (IDs) do
		local bag, bank, craft = GetItemLinkStacks(getItemLinkFromItemId(itemId))
		if bag + bank + craft == 0 then -- i.e.if the stack count of all is 0
			return false
		end
	end
	return true
end


LibLazyCrafting.craftInteractionTables[CRAFTING_TYPE_ENCHANTING] =
{
	["station"] = CRAFTING_TYPE_ENCHANTING,
	["check"] = function(self, station) return station == self.station end,
	['function'] = LLC_EnchantingCraftinteraction,
	["complete"] = LLC_EnchantingCraftingComplete,
	["endInteraction"] = function(self, station) --[[endInteraction()]] end,
	["isItemCraftable"] = function(self, station, request) 
		if station == CRAFTING_TYPE_ENCHANTING and haveEnoughMats(request.potencyItemID, request.essenceItemID, request.aspectItemID) then 
			return true else return false 
		end 
	end,
}

LibLazyCrafting.functionTable.CraftEnchantingItemId = LLC_CraftEnchantingGlyphItemID
LibLazyCrafting.functionTable.CraftEnchantingGlyph = LLC_CraftEnchantingGlyph

--- testers:
-- /script LLC_Global:CraftEnchantingItemId(45830, 45838, 45851)

