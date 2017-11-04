-----------------------------------------------------------------------------------
-- Library Name: LibLazyCrafting
-- Creator: Dolgubon (Joseph Heinzle)
-- File Creator: ziggr
-- Library Ideal: Allow addons to craft anything, anywhere
-- Library Creation Date: December, 2016
-- Publication Date: Febuary 5, 2017
--
-- File Name: Alchemy.lua
-- File Description: Contains the functions for Alchemy
-- Load Order Requirements: After LibLazyCrafting.lua
--
-----------------------------------------------------------------------------------


local LibLazyCrafting = LibStub("LibLazyCrafting")
local sortCraftQueue = LibLazyCrafting.sortCraftQueue

local widgetType = 'alchemy'
local widgetVersion = 1.1
if not LibLazyCrafting:RegisterWidget(widgetType, widgetVersion) then return false end

local function dbug(...)
	if not DolgubonGlobalDebugOutput then return end
	DolgubonGlobalDebugOutput(...)
end

local craftingQueue = LibLazyCrafting.craftingQueue

local function LLC_CraftAlchemyItemByItemId(self, solventId, reagentId1, reagentId2, reagentId3, timesToMake, autocraft, reference)
	dbug('FUNCTION:LLCCraftAlchemy')
	if reference == nil then reference = "" end
	if not self then d("Please call with colon notation") end
	if autocraft==nil then autocraft = self.autocraft end
	if not solventId and reagentId1 and reagentId2 then return end -- reagentId3 optional, nil okay.

	table.insert(craftingQueue[self.addonName][CRAFTING_TYPE_ALCHEMY],
	{
		["solventId"] = solventId,
		["reagentId1"] = reagentId1,
		["reagentId2"] = reagentId2,
		["reagentId3"] = reagentId3,
		["timestamp"] = GetTimeStamp(),
		["autocraft"] = autocraft or self.autocraft,
		["Requester"] = self.addonName,
		["reference"] = reference or "",
		["station"] = CRAFTING_TYPE_ALCHEMY,
		["timesToMake"] = timesToMake or 1,
	}
	)

	sortCraftQueue()
	if GetCraftingInteractionType()==CRAFTING_TYPE_ALCHEMY then
		LibLazyCrafting.craftInteract(event, CRAFTING_TYPE_ALCHEMY)
	end
end

local function LLC_CraftAlchemyPotion(self, selventBagId, solventSlotId, reagent1BagId, reagent1SlotId, reagent2BagId, reagent2SlotId, reagent3BagId, reagent3SlotId, timesToMake, autocraft, reference)
	local reagent3itemId
	if reagent3SlotId==nil then
		reagent3itemId = nil
	else
		reagent3itemId = GetItemId(reagent3BagId, reagent3SlotId)
	end
	LLC_CraftAlchemyItemByItemId(self, GetItemId(selventBagId, solventSlotId),GetItemId( reagent1BagId, reagent1SlotId),GetItemId(reagent2BagId, reagent2SlotId), reagent3itemId, timesToMake,autocraft, reference)
end

local function copy(t)
	local a = {}
	for k, v in pairs(t) do
		a[k] = v
	end
	return a
end

local function LLC_AlchemyCraftInteraction(event, station)
	dbug("FUNCTION:LLCAlchemyCraft")
	local earliest, addon , position = LibLazyCrafting.findEarliestRequest(CRAFTING_TYPE_ALCHEMY)
	if (not earliest) or IsPerformingCraftProcess() then return end

	-- Find bag locations of each material used in the crafting attempt.
	local solventBagId, solventSlotIndex = findItemLocationById(earliest["solventId"])
	local reagent1BagId, reagent1SlotIndex = findItemLocationById(earliest["reagentId1"])
	local reagent2BagId, reagent2SlotIndex = findItemLocationById(earliest["reagentId2"])
	local reagent3BagId, reagent3SlotIndex = nil, nil
	if earliest["reagentId3"] then
		reagent3BagId, reagent3SlotIndex = findItemLocationById(earliest["reagentId3"])
	end
	local locations = {
		solventBagId, solventSlotIndex,
		reagent1BagId, reagent1SlotIndex,
		reagent2BagId, reagent2SlotIndex,
		reagent3BagId, reagent3SlotIndex,
	}
	if not (solventSlotIndex and reagent1SlotIndex and reagent2SlotIndex and (not earliest["reagentId3"] or reagent3SlotIndex)) then return end

	dbug("CALL:ZOAlchemyCraft")
	CraftAlchemyItem(unpack(locations))

	currentCraftAttempt= copy(earliest)
	currentCraftAttempt.callback = LibLazyCrafting.craftResultFunctions[addon]

						-- ZZ: This .slot field is INCORRECT when crafting
						-- multiple copies of the same stackable item such as
						-- alchemy potions or provisioning food/dring. In such
						-- a case, we'd have to scan the entire backback
						-- looking for our expected result, and record
						-- before/after totals to see if the total jumped by at
						-- least 1.
						-- We'd also need to deal with stacking limits: maybe
						-- we just crafted the 98th, 99th, 100th, and 101th
						-- copy of a potion and so the resulting 4 potions
						-- actually straddle two slots.
						--
						-- Maybe later. For now, no slot for you!
	currentCraftAttempt.slot = nil -- FindFirstEmptySlotInBag(BAG_BACKPACK)
	currentCraftAttempt.link = GetAlchemyResultingItemLink(unpack(locations))
	currentCraftAttempt.position = position
	currentCraftAttempt.timestamp = GetTimeStamp()
	currentCraftAttempt.addon = addon
	currentCraftAttempt.prevSlots = LibLazyCrafting.backpackInventory()
end

local function LLC_AlchemyCraftingComplete(event, station, lastCheck)
	dbug("EVENT:CraftComplete")
	LibLazyCrafting.stackableCraftingComplete(event, station, lastCheck, CRAFTING_TYPE_ALCHEMY, currentCraftAttempt)

end

LibLazyCrafting.craftInteractionTables[CRAFTING_TYPE_ALCHEMY] =
{
	["check"] = function(station) return station == CRAFTING_TYPE_ALCHEMY end,
	['function'] = LLC_AlchemyCraftInteraction,
	["complete"] = LLC_AlchemyCraftingComplete,
	["endInteraction"] = function(station) --[[endInteraction()]] end,
	["isItemCraftable"] = function(station) if station == CRAFTING_TYPE_ALCHEMY then return true else return false end end,
}

LibLazyCrafting.functionTable.CraftAlchemyPotion = LLC_CraftAlchemyPotion
LibLazyCrafting.functionTable.CraftAlchemyItemId = LLC_CraftAlchemyItemByItemId
