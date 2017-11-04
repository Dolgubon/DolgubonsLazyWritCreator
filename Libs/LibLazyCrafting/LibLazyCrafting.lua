-----------------------------------------------------------------------------------
-- Library Name: LibLazyCrafting (LLC)
-- Creator: Dolgubon (Joseph Heinzle)
-- Library Ideal: Allow addons to craft anything, anywhere
-- Library Creation Date: December, 2016
-- Publication Date: Febuary 5, 2017
--
-- File Name: LibLazyCrafting.lua
-- File Description: Contains the main functions of LLC, uncluding the queue and initialization functions
-- Load Order Requirements: Before all other library files
--
-----------------------------------------------------------------------------------

-- Initialize libraries

local function dbug(...)
	--DolgubonDebugRunningDebugString(...)
end
local libLoaded
local LIB_NAME, VERSION = "LibLazyCrafting", 1.4
local LibLazyCrafting, oldminor = LibStub:NewLibrary(LIB_NAME, VERSION)
if not LibLazyCrafting then return end
local LLC = LibLazyCrafting

LibLazyCrafting.craftInteractionTables =
{
	["example"] =
	{
		["check"] = function(station) if station == 123 then return false end end,
		["function"] = function(station) --[[craftStuff()]] end,
		["complete"] = function(station) --[[handleCraftCompletion()]] end,
		["endInteract"] = function(station) --[[endInteraction()]] end,
	}
}


LLC.widgets = LLC.widgets or {}
local widgets = LLC.widgets

--METHOD: REGISTER WIDGET--
--each widget has its version checked before loading,
--so we only have the most recent one in memory
--Usage:
--	widgetType = "string"; the type of widget being registered
--	widgetVersion = integer; the widget's version number
--	From LibAddonMenu

function LibLazyCrafting:RegisterWidget(widgetType, widgetVersion)
	if widgets[widgetType] and widgets[widgetType] >= widgetVersion then
		return false
	else
		widgets[widgetType] = widgetVersion
		return true
	end
end


-- Index starts at 0 because that's how many upgrades are needed.
local qualityIndexes =
{
	[0] = "White",
	[1] = "Green",
	[2] = "Blue",
	[3] = "Epic",
	[4] = "Gold",
}



--GetItemLinkSetInfo(string itemLink, boolean equipped)
--GetItemLinkInfo(string itemLink)
--GetItemId(number bagId, number slotIndex)
--|H1:item:72129:369:50:26845:370:50:0:0:0:0:0:0:0:0:0:15:1:1:0:17:0|h|h

-- Crafting request Queue. Split by addon. Further split by station. Each request has a timestamp for when it was requested.
-- Due to how requests are added, each addon's requests withing station should be sorted by oldest to newest. We'll assume that. (maybe check once in a while)
-- Thus, all that's needed to find the oldest request is cycle through each addon, and check only their first request.
-- Unless a user has hundreds of addons using this library (unlikely) it shouldn't be a big strain. (shouldn't anyway)
-- Not sure how to handle multiple stations for furniture. needs more research for that.
craftingQueue =
{
	--["GenericTesting"] = {}, -- This is for say, calling from chat.
	["ExampleAddon"] = -- This contains examples of all the crafting requests. It is removed upon initialization. Most values are random/default.
	{
		["autocraft"] = false, -- if true, then timestamps will be applied when the addon calls LLC_craft()
		[CRAFTING_TYPE_CLOTHIER] = {},
		[CRAFTING_TYPE_WOODWORKING] =
		{
			{["type"] = "smithing",
			["pattern"] =0,
			["Requester"] = "",
			["autocraft"] = true,
			["style"] = 0,
			["trait"] = 0,
			["materialIndex"] = 0,
			["materialQuantity"] = 0,
			["setIndex"] = 0,
			["quality"] = 0,
			["useUniversalStyleItem"] = false,
			["timestamp"] = 1111113223232323231, },
		},
		[CRAFTING_TYPE_BLACKSMITHING] =
		{
			{["type"] = "improvement",
			["Requester"] = "", -- ADDON NAME
			["autocraft"] = true,
			["ItemLink"] = "",
			["ItemBagID"] = 0,
			["ItemSlotID"] = 0,
			["ItemUniqueID"] = 0,
			["ItemCreater"] = "",
			["FinalQuality"] = 0,
			["timestamp"] = 111222323232323232322,}
		},
		[CRAFTING_TYPE_ENCHANTING] =
		{
			{["essenceItemID"] = 0,
			["aspectItemID"] = 0,
			["potencyItemID"] = 0,
			["timestamp"] = 1234232323235667,
			["autocraft"] = true,
			["Requester"] = "",
		}
		},
		[CRAFTING_TYPE_ALCHEMY] =
		{
			{["SolvenItemID"] = 0,
			["Reagents"] =
			{
				[1] = 0,
				[2] = 0,
				[3] = 0,
			},
			["timestamp"] = 123423232323555,
			["Requester"] = "",
			["autocraft"] = true,
		}
		},
		[CRAFTING_TYPE_PROVISIONING] =
		{
			{["RecipeID"] = 0,
			["timestamp"] = 111232323232323111,
			["Requester"] = "",
			["autocraft"] = true,}
		},
	},
}
craftingQueue["ExampleAddon"] = nil

LibLazyCrafting.craftingQueue = craftingQueue

local craftResultFunctions = {[""]=function() end}

LibLazyCrafting.functionTable = {}
LibLazyCrafting.craftResultFunctions = craftResultFunctions


--------------------------------------
--- GENERAL HELPER FUNCTIONS

function GetItemNameFromItemId(itemId)

	return GetItemLinkName(ZO_LinkHandler_CreateLink("Test Trash", nil, ITEM_LINK_TYPE,itemId, 1, 26, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 10000, 0))
end

-- Just a random help function; can probably be taken out but I'll leave it in for now
-- Pretty helpful function for exploration.
function GetItemIDFromLink(itemLink) return tonumber(string.match(itemLink,"|H%d:item:(%d+)")) end

-- Mostly a queue function, but kind of a helper function too
local function isItemCraftable(request, station)
	if LibLazyCrafting.craftInteractionTables[station]["isItemCraftable"] then
		return LibLazyCrafting.craftInteractionTables[station]["isItemCraftable"](station, request)
	end

	if station ==CRAFTING_TYPE_ENCHANTING or station == CRAFTING_TYPE_PROVISIONING or station == CRAFTING_TYPE_ALCHEMY then
		return true
	end

end


function findItemLocationById(itemID)
	for i=0, GetBagSize(BAG_BANK) do
		if GetItemId(BAG_BANK,i)==itemID  then
			return BAG_BANK, i
		end
	end
	for i=0, GetBagSize(BAG_BACKPACK) do
		if GetItemId(BAG_BACKPACK,i)==itemID then
			return BAG_BACKPACK,i
		end
	end
	if GetItemId(BAG_VIRTUAL, itemID) ~=0 then

		return BAG_VIRTUAL, itemID

	end
	return nil, itemID
end


LibLazyCrafting.functionTable.findItemLocationById = findItemLocationById

-- Return current backpack inventory.
function LibLazyCrafting.backpackInventory()
	local r = {}
	local bagId = BAG_BACKPACK
	local maxSlotId = GetBagSize(bagId)
	local total = 0 -- to help with debugging: did ANYTHING grow?
	for slotIndex = 0, maxSlotId do
		r[slotIndex] = GetSlotStackSize(bagId, slotIndex)
		total = total + r[slotIndex]
	end
	return r
end

-- Return the first slot index of a stack of items that grew.
-- Return nil if no stacks grew.
--
-- prevSlotsContaining and newSlotsContaining are expected to be
-- results from backpackInventory().
function LibLazyCrafting.findIncreasedSlotIndex(prevInventory, currInventory)
	local maxSlotId = math.max(#prevInventory, #currInventory)
	for slotIndex = 0, maxSlotId do
		local prev = prevInventory[slotIndex]
		local curr = currInventory[slotIndex]

						-- Previously nil slot now non-nil
						-- (can happen when #curr > #prev)
		if curr and not prev then return slotIndex end

						-- This stack increased.
		if prev < curr then return slotIndex end
	end
	return nil
end

function LibLazyCrafting.tableShallowCopy(t)
	local a = {}
	for k, v in pairs(t) do
		a[k] = v
	end
	return a
end
-- clear a table in-place. Allows functions to clear out tables passed as a parameter.
local function tableClear(t)
	for k,_ in ipairs(t) do
		t[k] = nil
	end
end
-- Common code called by Alchemy and Provisioning crafting complete handlers.
function LibLazyCrafting.stackableCraftingComplete(event, station, lastCheck, craftingType, currentCraftAttempt)
	dbug("EVENT:CraftComplete")
	if not (currentCraftAttempt and currentCraftAttempt.addon) then return end
	local currSlots = LibLazyCrafting.backpackInventory()
	local grewSlotIndex = LibLazyCrafting.findIncreasedSlotIndex(currentCraftAttempt.prevSlots, currSlots)
	if grewSlotIndex then
		dbug("RESULT:StackableMade")
		if currentCraftAttempt["timesToMake"] < 2 then
			dbug("ACTION:RemoveQueueItem")
			craftingQueue[currentCraftAttempt.addon][craftingType][currentCraftAttempt.position] = nil
			LibLazyCrafting.sortCraftQueue()
			local resultTable =
			{
				["bag"] = BAG_BACKPACK,
				["slot"] = grewSlotIndex,
				['link'] = currentCraftAttempt.link,
				['uniqueId'] = GetItemUniqueId(BAG_BACKPACK, currentCraftAttempt.slot),
				["quantity"] = 1,
				["reference"] = currentCraftAttempt.reference,
			}
			currentCraftAttempt.callback(LLC_CRAFT_SUCCESS, craftingType, resultTable)
			tableClear(currentCraftAttempt)
		else
			-- Loop to craft multiple copies
			local earliest = craftingQueue[currentCraftAttempt.addon][craftingType][currentCraftAttempt.position]
			earliest.timesToMake = earliest.timesToMake - 1
			currentCraftAttempt.timesToMake = earliest.timesToMake
			if GetCraftingInteractionType()==0 then zo_callLater(function() LibLazyCrafting.stackableCraftingComplete(event, station, true, craftingType, currentCraftAttempt) end,100) end
		end
	elseif lastCheck then
		-- give up on finding it.
		tableClear(currentCraftAttempt)
	else
		-- further search
		-- search again later
		if GetCraftingInteractionType()==0 then zo_callLater(function() LibLazyCrafting.stackableCraftingComplete(event, station, true, craftingType, currentCraftAttempt) end,100) end
	end
end


-------------------------------------
-- QUEUE FUNCTIONS

local function sortCraftQueue()
	for name, requests in pairs(craftingQueue) do
		for i = 1, 6 do
			table.sort(requests[i], function(a, b) if a and b then return a["timestamp"]<b["timestamp"] else return a end end)
		end
	end
end
LibLazyCrafting.sortCraftQueue = sortCraftQueue


local abc = 1
-- Finds the highest priority request.
function findEarliestRequest(station)
	local earliest = {["timestamp"] = GetTimeStamp() + 100000} -- should be later than anything else, as it's 'in the future'
	local addonName = nil
	local position = 0

	for addon, requestTable in pairs(craftingQueue) do

		for i = 1, #requestTable[station] do


			if isItemCraftable(requestTable[station][i],station)  and requestTable[station][i]["autocraft"] then

				if requestTable[station][i]["timestamp"] < earliest["timestamp"] then

					earliest = requestTable[station][i]
					addonName = addon
					position = i
					break
				else
					break
				end
			end

		end

	end
	if addonName then

		return earliest, addonName , position
	else
		return nil, nil , 0
	end
end

LibLazyCrafting.findEarliestRequest = findEarliestRequest

local function LLC_CraftAllItems(self)
	for i = 1, #craftingQueue[self.addonName] do
		for j = 1, #craftingQueue[self.addonName][i] do
			craftingQueue[self.addonName][i][j]["autocraft"] = true
		end
	end
end

local function LLC_CraftItem(self, station, position)
	if position == nil then
		for i = 1, #craftingQueue[self.addonName][station] do
			craftingQueue[self.addonName][station][i]["autocraft"] = true
		end
	else
		craftingQueue[self.addonName][station][position]["autocraft"] = true
	end
end

local function LLC_CancelItem(self, station, position)
	if position == nil then
		if station == nil then
			craftingQueue[self.addonName] = {{},{},{},{},{},{},}
		else
			for j = 1, #craftingQueue[self.addonName][station] do
				table.remove(craftingQueue[self.addonName][i], j)

			end
		end
	else
		table.remove(craftingQueue[self.addonName][i], j)

	end

end
local function LLC_CancelItemByReference(self, reference)
	for i = 1, #craftingQueue[self.addonName] do
		for j = 1, #craftingQueue[self.addonName][i] do
			if craftingQueue[self.addonName][i][j] and craftingQueue[self.addonName][i][j].reference==reference then
				table.remove(craftingQueue[self.addonName][i], j)

			end
		end
	end

end

local function LLC_FindItemByReference(self, reference)
	local matches = {}
	for i = 1, #craftingQueue[self.addonName] do
		for j = 1, #craftingQueue[self.addonName][i] do
			if craftingQueue[self.addonName][i][j].reference==reference then
				matches[#matches+1] = craftingQueue[self.addonName][i][j]
			end
		end
	end
	return matches
end

LibLazyCrafting.functionTable.cancelItemByReference = LLC_CancelItemByReference

LibLazyCrafting.functionTable.cancelItem = LLC_CancelItem

LibLazyCrafting.functionTable.craftItem = LLC_CraftItem

LibLazyCrafting.functionTable.CraftAllItems = LLC_CraftAllItems
LibLazyCrafting.functionTable.findItemByReference =  LLC_FindItemByReference

local function LLC_GetMatRequirements(self, reference)
	local requests = LLC_FindItemByReference(self, reference)
	for i = 1, #requests do
		LibLazyCrafting.craftInteractionTables[requests[i].station]["materialRequirements"](requests[i])
	end

end

function LibLazyCrafting:Init()

	-- Call this to register the addon with the library.
	-- Really this is mostly arbitrary, I just want to force an addon to give me their name ;p. But it's an easy way, and only needs to be done once.
	-- Returns a table with all the functions, as well as the addon's personal queue.
	-- nilable:boolean autocraft will cause the library to automatically craft anything in the queue when at a crafting station.
	function LibLazyCrafting:AddRequestingAddon(addonName, autocraft, functionCallback)
		-- Add the 'open functions' here.
		local LLCAddonInteractionTable = {}
		if LLCAddonInteractionTable[addonName] then
			d("LibLazyCrafting:AddRequestingAddon has been called twice, or the chosen addon name has already been used")
		end
		craftingQueue[addonName] = { {}, {}, {}, {}, {}, {},} -- Initialize the addon's personal queue. The tables are empty, station specific queues.

		-- Ensures that any request will have an addon name attached to it, if needed.
		LLCAddonInteractionTable["addonName"] = addonName
		-- The crafting queue is added. Consider hiding this.
		-- Pro: It hides it, prevents addon people from messing with the queue. More OOP. Don't have to deal with devs messing other addons up
		-- Cons: Prevents them from messing with it. Maybe no scroll menus! It's up to them if they want to manually add something, too.
		-- But can easily add 'if type(timestamp) ~= number then ignore end.' On the other hand, addons can mess with the timestamps, and change priority
		LLCAddonInteractionTable["personalQueue"]  = craftingQueue[addonName]

		-- Add all the functions to the interaction table!!
		-- On the other hand, then addon devs can mess up the functions?

		for functionName, functionBody in pairs(LibLazyCrafting.functionTable) do
			LLCAddonInteractionTable[functionName] = functionBody
		end

		craftResultFunctions[addonName] = functionCallback

		LLCAddonInteractionTable.autocraft = autocraft

		-- Give add-on authors a way to check for required version beyond
		-- "I hope LibStub returns what I asked for!"
		LLCAddonInteractionTable["version"] = VERSION

		return LLCAddonInteractionTable
	end

	-- Same as the normal crafting function, with a few extra parameters.
	-- However, doesn't craft it, just adds it to the queue. (TODO: Maybe change this? But do we want auto craft?)
	-- StationOverride
	-- test: /script LLC_CraftSmithingItem(1, 1, 7, 2, 1, false, 1, 0, 0 )
	-- test: /script LLC_CraftSmithingItem(1, 1, 7, 2, 1, false, 5, 0, 0)

	-- Probably has to be completely rewritten TODO
	function LLC_CraftQueue()

		local station = GetCraftingInteractionType()
		if station == 0 then d("You must be at a crafting station") return end
		d(craftingQueue[station][1])
		if canCraftItemHere(station, craftingQueue[station][1]["setIndex"]) and not IsPerformingCraftProcess() then
			local craftThis = craftingQueue[station][1]
			if not craftThis then d("Nothing queued") return end
			if canCraftItem(craftThis) then
				local patternIndex, materialIndex, materialQuantity, styleIndex, traitIndex, quality = craftThis["pattern"], craftThis["materialIndex"], craftThis["materialQuantity"], craftThis["style"], craftThis["trait"], craftThis["quality"]
				waitingOnSmithingCraftComplete = {}
				waitingOnSmithingCraftComplete["slotID"] = FindFirstEmptySlotInBag(BAG_BACKPACK)
				waitingOnSmithingCraftComplete["itemLink"] = GetSmithingPatternResultLink(patternIndex, materialIndex, materialQuantity, styleIndex, traitIndex, 0)
				waitingOnSmithingCraftComplete["craftFunction"] =
				function()
					CraftSmithingItem(patternIndex, materialIndex, materialQuantity, styleIndex, traitIndex, useUniversalStyleItem)
				end
				waitingOnSmithingCraftComplete["craftFunction"]()
				waitingOnSmithingCraftComplete["creater"] = GetDisplayName()
				waitingOnSmithingCraftComplete["finalQuality"] = quality

				return
			else
				d("User does not have the skill to craft this")
			end

		else
			if IsPerformingCraftProcess() then d("Already Crafting") else d("Item cannot be crafted here") end
		end
	end


	function LLC_CraftAlchemyItem(SolventNameOrIndex, IngredientNameOrIndexOne, IngredientNameOrIndexTwo, IngredientNameOrIndexThree)
	end

	function LLC_GetQueue(Station)
	end

	function LLC_RemoveQueueItem(index)
	end

	function LLC_ClearQueue()
	end

	--- Could be infeasible
	function LLC_GetSmithingResultLink(patternIndex, materialIndex, materialQuantity, styleIndex, traitIndex, useUniversalStyleItem, linkstyle, stationOverride, setIndex, quality)
	end


	-- Why use this instead of the EVENT_CRAFT_COMPLETE?
	-- Using this will allow the library to tell you how the craft failed, at least for some problems.
	-- Or that the craft was completed.
	-- AddonName is your addon. It will be used as a reference to the function
	-- funct is the function that will be called where:
	-- funct(event, station, extraLLCResultInfo)

	function LLC_DesignateCraftCompleteFunction(AddonName, funct)
		craftResultFunctions[AddonName] = funct
	end
	-- Response codes
	LLC_CRAFT_SUCCESS = "success" -- extra result: Position of item, item link, maybe other stuff?
	LLC_ITEM_TO_IMPROVE_NOT_FOUND = "item not found" -- extra result: Improvement request table
	LLC_INSUFFICIENT_MATERIALS = "not enough mats" -- extra result: what is missing, item identifier
	LLC_INSUFFICIENT_SKILL  = "not enough skill" -- extra result: what skills are missing; both if not enough traits, not enough styles, or trait unknown

	LLC_Global = LibLazyCrafting:AddRequestingAddon("LLC_Global",true, function(event, station, result)
		d("1 "..GetItemLink(result.bag,result.slot).." crafted at slot "..tostring(result.slot).." with reference "..result.reference) end)

	--craftingQueue["ExampleAddon"] = nil
end


-- Called when a crafting station is opened. Should then craft anything needed in the queue
local function CraftInteract(event, station)

	for k,v in pairs(LibLazyCrafting.craftInteractionTables) do
		if v["check"](station) then
			v["function"](station)
		end
	end
end

LibLazyCrafting.craftInteract = CraftInteract

local function endInteraction(event, station)
	for k,v in pairs(LibLazyCrafting.craftInteractionTables) do
		if v["check"](station) then
			v["endInteraction"](station)

		end
	end
end

-- Called when a crafting request is done.
-- Note that this function is called both when you finish crafting and when you leave the station
-- Additionally, the craft complete event is called BEFORE the end crafting station interaction event
-- So this function will check if the interaction is still going on, and call the endinteraction function if needed
-- which bypasses the event Manager, so that it is called first.

local function CraftComplete(event, station)
	--d("Event:completion")
	local LLCResult = nil
	for k,v in pairs(LibLazyCrafting.craftInteractionTables) do
		if v["check"](station) then
			if GetCraftingInteractionType()==0 then
				--d("Calling exit complete, why???")
				endInteraction(EVENT_END_CRAFTING_STATION_INTERACT, station)
				zo_callLater(function() v["complete"](station) end, timetest)
			else
				--d("calling complete")
				if WritCrafter and WritCrafter.savedVarsAccountWide.masterDebugDelay then
					zo_callLater(function()
					v["complete"](station)
					v["function"](station) end, 500)
				else
					v["complete"](station)
					v["function"](station)
				end
			end
		end
	end
	--for k, v in pairs(craftResultFunctions) do
	--	v(event, station, LLCResult)
	--end
end




local function OnAddonLoaded()
	if not libLoaded then
		libLoaded = true
		local LibLazyCrafting = LibStub('LibLazyCrafting')
		LibLazyCrafting:Init()
		EVENT_MANAGER:UnregisterForEvent(LIB_NAME, EVENT_ADD_ON_LOADED)
		EVENT_MANAGER:RegisterForEvent(LIB_NAME, EVENT_CRAFTING_STATION_INTERACT,CraftInteract)
		EVENT_MANAGER:RegisterForEvent(LIB_NAME, EVENT_CRAFT_COMPLETED, CraftComplete)
		--EVENT_MANAGER:RegisterForEvent(LIB_NAME, EVENT_END_CRAFTING_STATION_INTERACT, endInteraction)
	end
end

EVENT_MANAGER:RegisterForEvent(LIB_NAME, EVENT_ADD_ON_LOADED, OnAddonLoaded)





--[[
function ActivityManager:QueueActivity(activity)
    local queue, lookup = self.queue, self.lookup
    local key = activity:GetKey()
    if(lookup[key]) then return false end
    queue[#queue + 1] = activity
    lookup[key] = activity
    table.sort(queue, ByPriority)
    return true
end

function ActivityManager:RemoveActivity(activity)
    self.lookup[activity:GetKey()] = nil
    for i = 1, #self.queue do
        if(self.queue[i]:GetKey() == activity:GetKey()) then
            table.remove(self.queue, i)
            break
        end
    end
end





]]
