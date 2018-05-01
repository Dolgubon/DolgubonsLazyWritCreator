-----------------------------------------------------------------------------------
-- Library Name: LibLazyCrafting
-- Creator: Dolgubon (Joseph Heinzle)
-- Library Ideal: Allow addons to craft anything, anywhere
-- Library Creation Date: December, 2016
-- Publication Date: Febuary 5, 2017
--
-- File Name: Smithing.lua
-- File Description: Contains the functions for Smithing (Blacksmithing, Clothing, Woodworking)
-- Load Order Requirements: After LibLazyCrafting.lua
-- 
-----------------------------------------------------------------------------------


--GetLastCraftingResultItemLink(number resultIndex, number LinkStyle linkStyle)
--/script d(GetLastCraftingResultItemInfo(1))

--if tonumber(requestTable[station][i]["timestamp"]) < earliest["timestamp"] then
--user:/AddOns/DolgubonsLazySetCrafter/Libs/LibLazyCrafting/LibLazyCrafting.lua:300: operator < is not supported for string < number
-- 	stack traceback:
 --   user:/AddOns/DolgubonsLazySetCrafter/Libs/LibLazyCrafting/LibLazyCrafting.lua:300: in function 'findEarliestRequest'
 --   user:/AddOns/DolgubonsLazyWritCreator/libs/LibLazyCrafting/Smithing.lua:423: in function 'LLC_SmithingCraftInteraction'
 --   user:/AddOns/DolgubonsLazySetCrafter/Libs/LibLazyCrafting/LibLazyCrafting.lua:523: in function 'CraftInteract'

local LibLazyCrafting = LibStub("LibLazyCrafting")

local widgetType = 'smithing'
local widgetVersion = 1.7
if not LibLazyCrafting:RegisterWidget(widgetType, widgetVersion) then return  end

local function dbug(...)

	if DolgubonGlobalDebugOutput then
		DolgubonGlobalDebugOutput(...)
	end
end


local craftingQueue = LibLazyCrafting.craftingQueue

local SetIndexes

local sortCraftQueue = LibLazyCrafting.sortCraftQueue
SetIndexes ={}
local abc = 1
local improvementChances = {}

-- This is filled out after crafting. It's so we can make sure that:
-- A: The item was crafted and
-- B: Find it. Includes itemLink and other stuff just in case it doesn't go to the expected slot (It should)
local waitingOnSmithingCraftComplete = 
{
	["craftFunction"] = function() end,
	["slotID"] = 0,
	["itemLink"] = "",
	["creater"] = "",
	["finalQuality"] = "",
}


--- EXAMPLE ONLY - for knowing what is in a request
local CraftSmithingRequestItem = 
{
	["pattern"] =0,
	["style"] = 0,
	["trait"] = 0,
	["materialIndex"] = 0,
	["materialQuantity"] = 0,
	["setIndex"] = 0,
	["quality"] = 0,
	["useUniversalStyleItem"] = false,
}

------------------------------------------------------
-- HELPER FUNCTIONS

-- A simple shallow copy of a table.
local function copy(t)
	local a = {}
	for k, v in pairs(t) do
		a[k] = v
	end
	return a
end

-- increments queue position and returns it, guarenteeing a unique order
local queuePosition = 0
local function GetSmithingQueueOrder()
	queuePosition = queuePosition + 1
	return queuePosition
end

-- Returns an item link from the given itemId. 
local function getItemLinkFromItemId(itemId) 
	return string.format("|H1:item:%d:%d:50:0:0:0:0:0:0:0:0:0:0:0:0:%d:%d:0:0:%d:0|h|h", itemId, 0, ITEMSTYLE_NONE, 0, 10000) end


local requirementJumps = { -- At these material indexes, the material required changes, and the amount required jumps down
	[1] = 1,
	[2] = 8,
	[3] = 13,
	[4] = 18,
	[5] = 23,
	[6] = 26,
	[7] = 29,
	[8] = 32,
	[9] = 34,
	[10] = 40,

}

additionalRequirements = -- Seperated by station. The additional amount of mats added to the base amount.
{
	[CRAFTING_TYPE_BLACKSMITHING] = 
	{ 2, 2, 2, 4, 4, 4, 1, 6, 4, 4, 4, 5, 4, 4,
	},
	[CRAFTING_TYPE_WOODWORKING] = 
	{ 2, 5, 2, 2, 2, 2,
	},
	[CRAFTING_TYPE_CLOTHIER] = 
	{ 6, 6, 4, 4, 4, 5, 4, 4, 6, 4, 4, 4, 5, 4, 4,

	},
}

local currentStep = 1
baseRequirements = {}
for i = 1, 41 do
	if i == 41 then
		baseRequirements[i] = baseRequirements[40]
	elseif i == 40 then
		baseRequirements[i] = currentStep - 1
	elseif requirementJumps[currentStep] == i then
		currentStep = currentStep + 1
		baseRequirements[i] = currentStep -1 
	else
		baseRequirements[i] = baseRequirements[i-1] +1
	end
end


function enoughMaterials(craftRequestTable)

	local missing = 
	{
		["materials"] = {},
	}
	if GetCurrentSmithingStyleItemCount(craftRequestTable["style"]) >0 then
		-- Check trait mats
		if GetCurrentSmithingTraitItemCount(craftRequestTable["trait"])> 0 or craftRequestTable["trait"]==1 then
			-- Check wood/ingot/cloth mats
			if GetCurrentSmithingMaterialItemCount(craftRequestTable["pattern"],craftRequestTable["materialIndex"])>=craftRequestTable["materialQuantity"] then
				-- Check if enough traits are known
				return true
			else
				missing.materials["mats"]  = true

			end
		else
			if craftRequestTable["trait"]==0 then d("Invalid trait") end
			missing.materials["trait"] = true
			
		end
	else
		missing.materials["style"] = true

	end
	return false, missing
end



function canCraftItem(craftRequestTable)
	local missing = 
	{
		["knowledge"] = {},
		["materials"] = {},
	}
	--CanSmithingStyleBeUsedOnPattern()
	-- Check stylemats
	local setPatternOffset = {}
	if craftRequestTable["setIndex"] == 1 then
		setPatternOffset = {0,0,[6]=0}
	else
		setPatternOffset = {14, 15,[6]=6}
	end

	local _,_,_,_,traitsRequired, traitsKnown = GetSmithingPatternInfo(craftRequestTable["pattern"] + setPatternOffset[craftRequestTable["station"]])

	if traitsRequired<= traitsKnown then
		
		-- Check if the specific trait is known
		if IsSmithingTraitKnownForResult(craftRequestTable["pattern"], craftRequestTable["materialIndex"], craftRequestTable["materialQuantity"],craftRequestTable["style"], craftRequestTable["trait"]) then
			-- Check if the style is known for that piece
			if IsSmithingStyleKnown(craftRequestTable["style"], craftRequestTable["pattern"]) then
				return true
			else

				missing.knowledge["style"] = true
			end
			
		else

			missing.knowledge["trait"] = true
		end
	else
		missing.knowledge["traitNumber"] = true
	end

	return false, missing
	
end
LibLazyCrafting.canCraftItemHere = canCraftItemHere



-- Returns SetIndex, Set Full Name, Traits Required
local function GetCurrentSetInteractionIndex()
	local baseSetPatternName
	local sampleId
	local currentStation = GetCraftingInteractionType()
	-- Get info based on what station it is.
	if currentStation == CRAFTING_TYPE_BLACKSMITHING then
		baseSetPatternName = GetSmithingPatternInfo(15)
		sampleId = GetItemIDFromLink(GetSmithingPatternResultLink(15,1,3,1,1,0))
	elseif currentStation == CRAFTING_TYPE_CLOTHIER then
		baseSetPatternName = GetSmithingPatternInfo(16)
		sampleId = GetItemIDFromLink(GetSmithingPatternResultLink(16,1,7,1,1,0))
	elseif currentStation == CRAFTING_TYPE_WOODWORKING then
		baseSetPatternName = GetSmithingPatternInfo(7)
		sampleId = GetItemIDFromLink(GetSmithingPatternResultLink(7,1,3,1,1,0))
	else
		
		return nil , nil, nil, nil
	end
	-- If no set
	if baseSetPatternName=="" then  return 1, SetIndexes[1][1],  SetIndexes[1][3]   end
	-- find set index
	for i =1, #SetIndexes do
		if sampleId == SetIndexes[i][2][currentStation] then
			
			return i, SetIndexes[i][1] , SetIndexes[i][3]
		end
	end
	
end
LibLazyCrafting.functionTable.GetCurrentSetInteractionIndex  = GetCurrentSetInteractionIndex

-- Can an item be crafted here, based on set and station indexes
local function canCraftItemHere(station, setIndex)
	
	if not setIndex then setIndex = 1 end
	
	if GetCraftingInteractionType()==station then
		
		if GetCurrentSetInteractionIndex()==setIndex or setIndex==1 then
			
			return true
		end
	end
	return false

end


---------------------------------
-- SMITHING HELPER FUNCTIONS

local function GetMaxImprovementMats(bag, slot ,station)
	local numBooster = 1
	local chance =0
	if not CanItemBeSmithingImproved(bag, slot, station) then return false end
	while chance<100 do
		numBooster = numBooster + 1
		chance = GetSmithingImprovementChance(bag, slot, numBooster,station)
		
	end
	return numBooster
end


function LLC_GetSmithingPatternInfo(patternIndex, station, set)
end

function LLC_GetSetIndexTable()
	return SetIndexes
end

-- Finds the material index based on the level
local function findMatIndex(level, champion)

	local index = 1

	if champion then
		index = 25
		index = index + math.floor(level/10)
	else
		index = 0
		if level<3 then
			index = 1
		else
			index = index + math.floor(level/2)
		end
	end
	return index
end

local function findMatTierByIndex(index)
	local a = {	[1] = 7,
	[2] = 12,
	[3] = 17,
	[4] = 22,
	[5] = 25,
	[6] = 28,
	[7] = 29,
	[8] = 32,
	[9] = 39,
	[10] = 41,}
	for i = 1, #a do
		if index  > a[i] then
		else

			return i 
		end
	end 
	return 10
end


local function GetMatRequirements(pattern, index, station)
	if station == nil then station = GetCraftingInteractionType() end
	mats = baseRequirements[index] + additionalRequirements[station][pattern]
	if station == CRAFTING_TYPE_WOODWORKING and pattern ~= 2 and index >=40 then
		mats = mats + 1
	end
	if station == CRAFTING_TYPE_BLACKSMITHING and pattern ==12 and index <13 and index >=8 then
		mats = mats - 1
	end

	if station == CRAFTING_TYPE_BLACKSMITHING and pattern >=4 and pattern <=6 and index >= 40 then
		mats = mats + 1
	end

	if index==41 then
		mats = mats*10
	end
	return mats
end

LibLazyCrafting.functionTable.GetMatRequirements = GetMatRequirements

local function LLC_CraftSmithingItem(self, patternIndex, materialIndex, materialQuantity, styleIndex, traitIndex, useUniversalStyleItem, stationOverride, setIndex, quality, autocraft, reference)
	dbug("FUNCTION:LLCSmithing")
	
	if reference == nil then reference = "" end
	if not self then d("Please call with colon notation") end
	if autocraft==nil then autocraft = self.autocraft end
	local station
	if type(self) == "number" then
		d("LLC: Please call using colon notation: e.g LLC:CraftSmithingItem(). If you are seeing this and you are not a developer please contact the author of the addon")
	end
	if not (stationOverride==CRAFTING_TYPE_BLACKSMITHING or stationOverride == CRAFTING_TYPE_WOODWORKING or stationOverride == CRAFTING_TYPE_CLOTHIER) then
		if GetCraftingInteractionType() == 0 then
			d("LLC: Invalid Station")
			return
		else
			station = GetCraftingInteractionType()
			if station == 0 then
				d("LLC: No station specified, and you are not at a crafting station")
				return
			end
		end
	else
		station =stationOverride
	end
	--Handle the extra values. If they're nil, assign default values.
	if not quality then setIndex = 0 end
	if not quality then quality = 0 end

	-- create smithing request table and add to the queue
	if self.addonName=="LLC_Global" then d("Item added") end
	local requestTable = {
		["type"] = "smithing",
		["pattern"] =patternIndex,
		["style"] = styleIndex,
		["trait"] = traitIndex,
		["materialIndex"] = materialIndex,
		["materialQuantity"] = materialQuantity,
		["station"] = station,
		["setIndex"] = setIndex,
		["quality"] = quality,
		["useUniversalStyleItem"] = useUniversalStyleItem,
		["timestamp"] = GetSmithingQueueOrder(),
		["autocraft"] = autocraft,
		["Requester"] = self.addonName,
		["reference"] = reference,
	}
	table.insert(craftingQueue[self.addonName][station],requestTable)

	--sortCraftQueue()
	if not IsPerformingCraftProcess() and GetCraftingInteractionType()~=0 then
		LibLazyCrafting.craftInteractionTables[GetCraftingInteractionType()]["function"](GetCraftingInteractionType()) 
	end
	
	return requestTable
end

local function isValidLevel(isCP, lvl)
	if isCP then
		if lvl %10 ~= 0 then  return  false end
		if lvl > 160 or lvl <10 then  return false  end
	else
		if lvl % 2 ~=0 and lvl ~= 1 then return false end
		if lvl <1 or lvl > 50 then return false end
	end
	return true
end

LibLazyCrafting.functionTable.isSmithingLevelValid = isValidLevel

local function LLC_CraftSmithingItemByLevel(self, patternIndex, isCP , level, styleIndex, traitIndex, useUniversalStyleItem, stationOverride, setIndex, quality, autocraft, reference)
	if isValidLevel( isCP ,level) then
		local materialIndex = findMatIndex(level, isCP)

		local materialQuantity = GetMatRequirements(patternIndex, materialIndex, stationOverride)

		return LLC_CraftSmithingItem(self, patternIndex, materialIndex, materialQuantity, styleIndex, traitIndex, useUniversalStyleItem, stationOverride, setIndex, quality, autocraft, reference)
	else
	end
end

LibLazyCrafting.functionTable.CraftSmithingItem = LLC_CraftSmithingItem
LibLazyCrafting.functionTable.CraftSmithingItemByLevel = LLC_CraftSmithingItemByLevel
-- /script local a = {1, 16, 36} for i = 1, 3 do LLC_Global:CraftSmithingItemByLevel(5, false, a[i],3 ,ITEM_TRAIT_TYPE_ARMOR_TRAINING ,false, CRAFTING_TYPE_CLOTHIER, 0, ITEM_QUALITY_ARCANE,true) end
-- /script LLC_Global:CraftSmithingItemByLevel(3, true, 150,3 ,1 ,false, CRAFTING_TYPE_CLOTHIER, 0, 3,true)
-- /script for i= 2, 25 do LLC_Global:CraftSmithingItemByLevel(3, false, i*2,3 ,1 ,false, CRAFTING_TYPE_CLOTHIER, 0, 3,true) end
-- /script LLC_Global:CraftSmithingItemByLevel(3, true, 140,3 ,1 ,false, CRAFTING_TYPE_CLOTHIER, 0, 5,true)


-- We do take the bag and slot index here, because we need to know what to upgrade
function LLC_ImproveSmithingItem(self, BagIndex, SlotIndex, newQuality, autocraft, reference)
	dbug("FUNCTION:LLCImprove")
	if reference == nil then reference = "" end
	--abc = abc + 1 if abc>50 then d("improve")return end
	local station = -1
	for i = 1, 6 do
		if CanItemBeSmithingImproved(BagIndex, SlotIndex,i) then
			station = i
		end
	end
	if station == -1 then d("Cannot be improved") return end
	if autocraft==nil then autocraft = self.autocraft end
	local station = GetRearchLineInfoFromRetraitItem(BagIndex, SlotIndex)
	local craftingRequestTable = {
	["type"] = "improvement",
	["Requester"] = self.addonName, -- ADDON NAME
	["autocraft"] = autocraft,
	["ItemLink"] = GetItemLink(BagIndex, SlotIndex),
	["ItemBagID"] = BagIndex,
	["ItemSlotID"] = SlotIndex,
	["ItemUniqueID"] = GetItemUniqueId(BagIndex, SlotIndex),
	["ItemCreater"] = GetItemCreatorName(BagIndex, SlotIndex),
	["quality"] = newQuality,
	["reference"] = reference,
	["station"] = station,
	["timestamp"] = GetSmithingQueueOrder(),}
	table.insert(craftingQueue[self.addonName][station], craftingRequestTable)
	--sortCraftQueue()
	if not IsPerformingCraftProcess() and GetCraftingInteractionType()~=0 and not LibLazyCrafting.isCurrentlyCrafting[1] then
		LibLazyCrafting.craftInteractionTables[GetCraftingInteractionType()]["function"](GetCraftingInteractionType())

	end
	return craftingRequestTable
end

LibLazyCrafting.functionTable.ImproveSmithingItem = LLC_ImproveSmithingItem
-- Examples
-- /script for i = 1, 200 do if GetItemTrait(1,i)==20 or GetItemTrait(1,i)==9 then LLC_Global:ImproveSmithingItem(1,i,3,true) d("Improve") end end
-- /script for i = 1, 200 do if GetItemTrait(1,i)==20 or GetItemTrait(1,i)==9 then LLC_ImproveSmithingItem(LLC_Global, 1,i,3,true) d("Improve") end end


local currentCraftAttempt = 
{
	["type"] = "smithing",
	["pattern"] = 3,
	["style"] = 2,
	["trait"] = 3,
	["materialIndex"] = 3,
	["materialQuantity"] = 5,
	["setIndex"] = 3,
	["quality"] = 2,
	["useUniversalStyleItem"] = true,
	["autocraft"] = true,
	["Requester"] = "",	
	["timestamp"] = 1234566789012345,
	["slot"]  = 0,
	["link"] = "",
	["callback"] = function() end,
	["position"] = 0,
}

-- Ideas to increase Queue Accuracy:
--		previousCraftAttempt/check for currentCraftAttempt = {}


-------------------------------------------------------
-- SMITHING INTERACTION FUNCTIONS

local hasNewItemBeenMade = false

local function LLC_SmithingCraftInteraction( station)

	dbug("EVENT:CraftIntBegin")

	--abc = abc + 1 if abc>50 then d("raft")return end

	local earliest, addon , position = LibLazyCrafting.findEarliestRequest(station)
	
	if earliest  and not IsPerformingCraftProcess() then
		if earliest.type =="smithing" then

			local parameters = {
			earliest.pattern, 
			earliest.materialIndex,
			earliest.materialQuantity, 
			earliest.style, 
			earliest.trait, 
			earliest.useUniversalStyleItem,
			LINK_STYLE_DEFAULT,
		}
		local setPatternOffset = {14, 15,[6]=6}
		if earliest.setIndex~=1 then
			parameters[1] = parameters[1] + setPatternOffset[station]	
		end
			dbug("CALL:ZOCraftSmithing")

			LibLazyCrafting.isCurrentlyCrafting = {true, "smithing", earliest["Requester"]}

			hasNewItemBeenMade = false 
			CraftSmithingItem(unpack(parameters))

			currentCraftAttempt = copy(earliest)
			currentCraftAttempt.position = position
			currentCraftAttempt.callback = LibLazyCrafting.craftResultFunctions[addon]
			currentCraftAttempt.slot = FindFirstEmptySlotInBag(BAG_BACKPACK)

			
			table.remove(parameters,6 )

			currentCraftAttempt.link = GetSmithingPatternResultLink(unpack(parameters))
			--d("Making reference #"..tostring(currentCraftAttempt.reference).." link: "..currentCraftAttempt.link)
		elseif earliest.type =="improvement" then
			local parameters = {}
			local skillIndex = station + 1 - math.floor(station/6)
			local currentSkill, maxSkill = GetSkillAbilityUpgradeInfo(SKILL_TYPE_TRADESKILL,skillIndex,6)
			if earliest.quality==GetItemLinkQuality(GetItemLink(earliest.ItemBagID, earliest.ItemSlotID))then
				dbug("ACTION:RemoveImprovementRequest")
				d("Bad improvement Request; this shouldn't appear, but it might.")
				local returnTable = table.remove(craftingQueue[addon][station],position )
				returnTable.bag = BAG_BACKPACK
				LibLazyCrafting.SendCraftEvent( LLC_CRAFT_SUCCESS ,  station,addon , returnTable )
				

				currentCraftAttempt = {}
				--sortCraftQueue()
				LLC_SmithingCraftInteraction(station)
				return
			end
			if currentSkill~=maxSkill then
				-- cancel if quality is already blue and skill is not max
				-- This is to save on improvement mats. 

				if earliest.quality>2 and GetItemLinkQuality(GetItemLink(earliest.ItemBagID, earliest.ItemSlotID)) >ITEM_QUALITY_MAGIC then
					d("Improvement skill is not at maximum. Improvement prevented to save mats.")
					return
				end
			end
			local numBooster = GetMaxImprovementMats( earliest.ItemBagID,earliest.ItemSlotID,station)
			if not numBooster then return end
			local _,_, stackSize = GetSmithingImprovementItemInfo(station, GetItemLinkQuality(GetItemLink(earliest.ItemBagID, earliest.ItemSlotID)))
			if stackSize< numBooster then 
				d("Not enough improvement mats")
				return end
			dbug("CALL:ZOImprovement")
			LibLazyCrafting.isCurrentlyCrafting = {true, "improve", earliest["Requester"]}
			ImproveSmithingItem(earliest.ItemBagID,earliest.ItemSlotID, numBooster)
			currentCraftAttempt = copy(earliest)
			currentCraftAttempt.position = position
			currentCraftAttempt.callback = LibLazyCrafting.craftResultFunctions[addon]
			
			currentCraftAttempt.link = GetSmithingImprovedItemLink(earliest.ItemBagID, earliest.ItemSlotID, station)
		end
		
			--ImproveSmithingItem(number itemToImproveBagId, number itemToImproveSlotIndex, number numBoostersToUse)
			--GetSmithingImprovedItemLink(number itemToImproveBagId, number itemToImproveSlotIndex, number TradeskillType craftingSkillType, number LinkStyle linkStyle)
	else
		-- LLC_NO_FURTHER_CRAFT_POSSIBLE
		LibLazyCrafting.SendCraftEvent( LLC_NO_FURTHER_CRAFT_POSSIBLE,  station)
	end
	
end
-- check ItemID and style

local function WasItemCrafted()
	dbug("CHECK:WasItemCrafted")
	--abc = abc + 1 if abc>50 then d("wascrafted")return end
	local checkPosition = {BAG_BACKPACK, currentCraftAttempt.slot}
	if GetItemName(unpack(checkPosition))==GetItemLinkName(currentCraftAttempt.link) then
		if GetItemLinkQuality(GetItemLink(unpack(checkPosition))) ==ITEM_QUALITY_NORMAL then
			if GetItemRequiredLevel(unpack(checkPosition))== GetItemLinkRequiredLevel(currentCraftAttempt.link) then
				if GetItemRequiredChampionPoints(unpack(checkPosition)) == GetItemLinkRequiredChampionPoints(currentCraftAttempt.link) then
					if GetItemId(unpack(checkPosition)) == GetItemIDFromLink(currentCraftAttempt.link) then
						if GetItemLinkItemStyle(GetItemLink(unpack(checkPosition))) ==GetItemLinkItemStyle(currentCraftAttempt.link) then
							return true
						else
							return false
						end
					else
						return false
					end
				else
					return false
				end
			else
				return false
			end
		else
			return false
		end
	else
		return false
	end

end
local function WasItemImproved(currentCraftAttempt)
		--GetItemLinkQuality(GetItemLink(earliest.ItemBagID, earliest.ItemSlotID))
	return GetItemLinkQuality(GetItemLink(currentCraftAttempt.ItemBagID,currentCraftAttempt.ItemSlotID))==currentCraftAttempt.quality

end
local backupPosition

local function removedRequest(station, timestamp)
	for addon, requestTable in pairs(craftingQueue) do
		for i = 1, #requestTable[station] do
			if requestTable[station][i]["timestamp"] == timestamp then
				return addon, i
			end
		end
	end
	d("Request to remove not found")
	return nil, 0
end

local function smithingCompleteNewItemHandler(station)

	dbug("ACTION:RemoveRequest")

	--d("Item found")
	local addonName, position = removedRequest(station, currentCraftAttempt.timestamp)
	local removedRequest
	if addonName then
		removedRequest =  table.remove(craftingQueue[addonName][station],position )
		if currentCraftAttempt.quality>1 then
			--d("Improving #".. tostring(currentCraftAttempt.reference))
			removedRequest.bag = BAG_BACKPACK
			removedRequest.slot = currentCraftAttempt.slot
			LibLazyCrafting.SendCraftEvent(LLC_INITIAL_CRAFT_SUCCESS, station, currentCraftAttempt.Requester, removedRequest)
			LLC_ImproveSmithingItem({["addonName"]=currentCraftAttempt.Requester}, BAG_BACKPACK, currentCraftAttempt.slot, currentCraftAttempt.quality, currentCraftAttempt.autocraft, currentCraftAttempt.reference)
		else
			removedRequest.bag = BAG_BACKPACK
			removedRequest.slot = currentCraftAttempt.slot

			LibLazyCrafting.SendCraftEvent(LLC_CRAFT_SUCCESS, station, currentCraftAttempt.Requester, removedRequest )
		end
	else
		d("Bad craft remove")
	end

end



local function SmithingCraftCompleteFunction(station)
	dbug("EVENT:CraftComplete")

	--d("complete at "..GetTimeStamp())
	--d(GetItemLink(BAG_BACKPACK, currentCraftAttempt.slot))
	if currentCraftAttempt.type == "smithing" and hasNewItemBeenMade then 
		hasNewItemBeenMade = false
		if WasItemCrafted() then
			smithingCompleteNewItemHandler(station)
		else
			
			if backupPosition then
				currentCraftAttempt.slot = backupPosition
				if WasItemCrafted() then
					
					smithingCompleteNewItemHandler(station)
				else
					
				end
			end
		end
		currentCraftAttempt = {}
		--sortCraftQueue()
		backupPosition = nil
		
	elseif currentCraftAttempt.type == "improvement" then

		if WasItemImproved(currentCraftAttempt) then
			local returnTable
			local addonName, position = removedRequest(station, currentCraftAttempt.timestamp)
			if addonName then
				returnTable =  table.remove(craftingQueue[addonName][station],position)
				
				returnTable.bag = BAG_BACKPACK

				LibLazyCrafting.SendCraftEvent( LLC_CRAFT_SUCCESS,  station,currentCraftAttempt.Requester, returnTable )
			else
				d("Bad request position")
			end
		end
		currentCraftAttempt = {}
		--sortCraftQueue()
		backupPosition = nil
	else
		return
	end
end



local function slotUpdateHandler(event, bag, slot, isNew, itemSoundCategory, inventoryUpdateReason, stackCountChange)
	
	if not isNew then return end

	if stackCountChange ~= 1 then return end
	local itemType = GetItemType(bag, slot)
	if itemType ==ITEMTYPE_ARMOR or itemType ==ITEMTYPE_WEAPON then else return end 
	hasNewItemBeenMade = true
	if LibLazyCrafting.IsPerformingCraftProcess() and ( currentCraftAttempt.slot ~= slot or not currentCraftAttempt.slot ) then
		backupPosition = slot
		
	end
	if currentCraftAttempt.slot ~= slot or not currentCraftAttempt.slot  then
		backupPosition = slot
		
	end
end
EVENT_MANAGER:UnregisterForEvent(LibLazyCrafting.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE)
EVENT_MANAGER:RegisterForEvent(LibLazyCrafting.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, slotUpdateHandler)
EVENT_MANAGER:AddFilterForEvent(LibLazyCrafting.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_INVENTORY_UPDATE_REASON, INVENTORY_UPDATE_REASON_DEFAULT)
EVENT_MANAGER:AddFilterForEvent(LibLazyCrafting.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_IS_NEW_ITEM, true)



local compileRequirements

LibLazyCrafting.craftInteractionTables[CRAFTING_TYPE_BLACKSMITHING] =
{
	["station"] = CRAFTING_TYPE_BLACKSMITHING,
	["check"] = function(self, station) return station == self.station end,
	['function'] = LLC_SmithingCraftInteraction,
	["complete"] = SmithingCraftCompleteFunction,
	["endInteraction"] = function(self, station) --[[endInteraction()]] end,
	["isItemCraftable"] = function(self, station, request) 
	
		if request["type"] == "improvement" then 
			local numBooster = GetMaxImprovementMats( request.ItemBagID,request.ItemSlotID,station)
			if not numBooster then return false end
			local _,_,stackSize = GetSmithingImprovementItemInfo(station, GetItemLinkQuality(GetItemLink(request.ItemBagID, request.ItemSlotID)))
			if stackSize< numBooster then
				return false 
			end
			return true
		end

		
		if canCraftItemHere(station, request["setIndex"]) and canCraftItem(request) and enoughMaterials(request) then

			return true
		else
			return false
		end 
	end,
	["materialRequirements"] = function(self, request) return compileRequirements(request, self.station) end 
}
-- Should be the same for other stations though. Except for the check
LibLazyCrafting.craftInteractionTables[CRAFTING_TYPE_WOODWORKING] = copy(LibLazyCrafting.craftInteractionTables[CRAFTING_TYPE_BLACKSMITHING]) 
LibLazyCrafting.craftInteractionTables[CRAFTING_TYPE_WOODWORKING]["station"] = CRAFTING_TYPE_WOODWORKING

LibLazyCrafting.craftInteractionTables[CRAFTING_TYPE_CLOTHIER] = copy(LibLazyCrafting.craftInteractionTables[CRAFTING_TYPE_BLACKSMITHING])
LibLazyCrafting.craftInteractionTables[CRAFTING_TYPE_CLOTHIER]["station"] = CRAFTING_TYPE_CLOTHIER


-- First is the name of the set. Second is a table of sample itemIds. Third is the number of required traits.
-- First itemId is for blacksmithing (axe, no trait), second is for clothing, (robe no trait) third is woodworking (Bow, no trait)
-- This is pretty much arbitrary, sorted by when the set was introduced, and how many traits are needed.
-- Declared at the end of the file for cleanliness

-- Language free!!!!

-- For brevity sake, sets are simply listed as 3 item IDs with the number of traits needed.	
-- The name of the set is then added in on initialization using the API.
SetIndexes =
{		--   Axe,  Robe,     Bow
	{{43529  , 43549 , [6] = 43543  },0},
	{{46499  , 43805 , [6] = 46518  },2},
	{{47265  , 47279 , [6] = 47287  },2},
	{{49563  , 49575 , [6] = 49583  },2},
	{{50708  , 43979 , [6] = 50727  },3},
	{{46882  , 43808 , [6] = 46901  },3},
	{{48031  , 48042 , [6] = 48050  },3},
	{{48797  , 43849 , [6] = 48816  },4},
	{{51090  , 51105 , [6] = 51113  },4},
	{{47648  , 47663 , [6] = 47671  },4},
	{{48414  , 48425 , [6] = 48433  },5},
	{{52233  , 52243 , [6] = 52251  },5},
	{{52614  , 52624 , [6] = 52632  },5},
	{{49180  , 49195 , [6] = 49203  },6},
	{{51471  , 51486 , [6] = 51494  },6},
	{{51852  , 51864 , [6] = 51872  },6},
	{{53757  , 53772 , [6] = 53780  },8},
	{{52995  , 53006 , [6] = 53014  },8},
	{{53376  , 44053 , [6] = 53393  },8},
	{{54138  , 54149 , [6] = 54157  },8},
	{{49946  , 43968 , [6] = 49964  },8},
	{{50327  , 43972 , [6] = 50345  },8},
	{{54965  , 54963 , [6] = 54971  },8},
	{{58175  , 58174 , [6] = 58182  },9},
	{{60261  , 60280 , [6] = 60268  },5},
	{{60611  , 60630 , [6] = 60618  },7},
	{{60961  , 60980 , [6] = 60968  },9},
	{{69949  , 69942 , [6] = 69956  },3},
	{{69599  , 69592 , [6] = 69606  },6},
	{{70649  , 70642 , [6] = 70656  },9},
	{{71813  , 71806 , [6] = 71820  },5},
	{{72163  , 72156 , [6] = 72170  },7},
	{{72513  , 72506 , [6] = 72520  },9},
	{{75386  , 75406 , [6] = 75393  },5},
	{{75736  , 75756 , [6] = 75743  },7},
	{{76086  , 76106 , [6] = 76093  },9},
	{{121551 , 121571, [6] = 121558 },3},
	{{122251 , 122271, [6] = 122258 },6},
	{{121901 , 121921, [6] = 121908 },8},
	{{131070 , 131090, [6] = 131077 },6},
	{{130370 , 130390, [6] = 130377 },2},
	{{130720 , 130740, [6] = 130727 },4},

}

for i = 1,#SetIndexes do 
	local _, a = GetItemLinkSetInfo(getItemLinkFromItemId(SetIndexes[i][1][1]),false)

	table.insert(SetIndexes[i],1,a)
end


function GetSetIndexes()

	return SetIndexes
end
LibLazyCrafting.functionTable.GetSetIndexes = GetSetIndexes

-- IDs for stuff like Sanded Ruby Ash, Iron Ingots, etc.
local materialItemIDs = 
{
	[CRAFTING_TYPE_BLACKSMITHING] = 
	{
		5413,
		4487,
		23107,
		6000,
		6001,
		46127,
		46128,
		46129,
		46130,
		64489,
	},
	[CRAFTING_TYPE_CLOTHIER] = 
	{
		811,
		4463,
		23125,
		23126,
		23127,
		46131,
		46132,
		46133,
		46134,
		64504,
	},
	[3] = -- Leather mats
	{
		794,
		4447,
		23099,
		23100,
		23101,
		46135,
		46136,
		46137,
		46138,
		64506,
	},
	[CRAFTING_TYPE_WOODWORKING] = 
	{
		803,
		533,
		23121,
		23122,
		23123,
		46139,
		46140,
		46141,
		46142,
		64502,
	},
}

-- Improvement mats
-- Use GetSmithingImprovementItemLink(number TradeskillType craftingSkillType, number improvementItemIndex, number LinkStyle linkStyle)

local improvementItemLinks = {}

for _, v in pairs({1,2,6}) do
	for i = 1, 4 do
		improvementItemLinks[#improvementItemLinks + 1] = GetSmithingImprovementItemLink(v, i, 0)
	end
end

local improvementSkillTextures = 
{
	[CRAFTING_TYPE_BLACKSMITHING] = "/esoui/art/icons/ability_smith_004.dds",
	[CRAFTING_TYPE_CLOTHIER] = "/esoui/art/icons/ability_tradecraft_004.dds",
	[CRAFTING_TYPE_WOODWORKING] = "/esoui/art/icons/ability_tradecraft_001.dds",
}

local improvementChances = 
{
	[0] = {5, 7,10,20},
	[1] = {4,5,7,14},
	[2] = {3,4,5,10},
	[3] = {2,3,4,8},
}

local abilityTextures = 
{
	[1] = "/esoui/art/icons/ability_smith_004.dds",
	[2] = "/esoui/art/icons/ability_tradecraft_004.dds",
	[6] = "/esoui/art/icons/ability_tradecraft_001.dds",
}

local function getImprovementLevel(station)

	for i = 1, 6 do
		local _, texture = GetSkillAbilityInfo(SKILL_TYPE_TRADESKILL, i, 6)
		if texture == abilityTextures[station] then
			local level = GetSkillAbilityUpgradeInfo(SKILL_TYPE_TRADESKILL, i, 6)
			return level
		end
	end
end

local function compileImprovementRequirements(request, station)
	local requirements = {}
	local currentQuality = GetItemQuality(request.ItemBagID, request.ItemSlotID)
	local improvementLevel = getImprovementLevel(station)
	
	for i  = 1, request.quality - 1 do
		requirements[GetItemIDFromLink( GetSmithingImprovementItemLink(station, i, 0) )] = improvementChances[improvementLevel][i]
	end
	return requirements
end

function compileRequirements(request, station)-- Ingot/style mat/trait mat/improvement mat
	local requirements = {}
	if request["type"] == "smithing" then
		
		local matId = materialItemIDs[station][findMatTierByIndex(request.materialIndex)]
		if station == CRAFTING_TYPE_CLOTHIER and request.pattern > 8 then
			matId = materialItemIDs[3][findMatTierByIndex(request.materialIndex)]
		end
		requirements[matId] = request.materialQuantity

		requirements[ GetItemIDFromLink( GetItemStyleMaterialLink(request.style , 0))] = 1

		local traitLink = GetSmithingTraitItemLink(request.trait, 0)
		if traitLink~="" then
			requirements[ GetItemIDFromLink( traitLink)] = 1
		end
		if request.quality==1 then return requirements end
	

		local improvementLevel = getImprovementLevel(station)

		for i  = 1, request.quality - 1 do
			requirements[GetItemIDFromLink( GetSmithingImprovementItemLink(station, i, 0) )] = improvementChances[improvementLevel][i]
		end

		return requirements
	else
		return compileImprovementRequirements(request, station)
	end
	
end

LibLazyCrafting.functionTable.CompileRequirements = compileRequirements
-- /script LibStub("LibLazyCrafting"):craftInteractionTables[CRAFTING_TYPE_CLOTHIER]["materialRequirements"]()
local itemSetIds ={ -- This table contains data on all the itemIds for crafted gear in the game! 
-- The first number in each table is the starting itemId. Thereafter, each even indexed number (indexes in lua start at 1)
-- denotes that the next x itemIds are part of the set. Each odd indexed number denotes the gap between an itemId of a set,
-- and the next one.
{43529, 6, 2, 23, 2, 2, 677, 0, 777, 260, 2, 17, 561, 0, 10168, 34, },
{43803, 3, 2347, 127, 71, 154, 2, 18, 2, 4, 8098, 3, 1471, 34, },
{43815, 1, 2, 0, 3097, 127, 71, 157, 2, 25, 8876, 34, },
{43871, 2, 5340, 127, 71, 158, 2, 24, 6788, 34, },
{43977, 2, 6379, 127, 71, 183, 5749, 34, },
{43807, 3, 2722, 127, 71, 158, 2, 18, 2, 4, 9224, 34, },
{43827, 3, 3851, 127, 71, 158, 2, 18, 2, 4, 8180, 34, },
{43847, 3, 4597, 127, 71, 158, 2, 18, 2, 4, 7484, 34, },
{43995, 5, 6740, 127, 71, 158, 2, 16, 2, 4, 5403, 34, },
{43819, 3, 3476, 127, 71, 158, 2, 18, 2, 4, 8528, 34, },
{43831, 3, 4230, 127, 71, 158, 2, 18, 2, 4, 7832, 34, },
{44013, 3, 2, 0, 7865, 127, 71, 157, 2, 23, 4365, 34, },
{44019, 5, 8240, 127, 71, 158, 2, 17, 2, 3, 4019, 34, },
{43859, 2, 4969, 127, 71, 158, 2, 24, 7136, 34, },
{44001, 5, 7115, 127, 71, 25, 2, 131, 2, 16, 2, 4, 2690, 0, 2367, 34, },
{44007, 2, 2, 1, 7490, 62, 2, 63, 71, 176, 2, 4, 2310, 0, 2401, 34, },
{44079, 5, 9323, 127, 71, 158, 2, 16, 2, 4, 2981, 34, },
{44031, 3, 2, 0, 8609, 127, 71, 158, 2, 22, 3673, 34, },
{44049, 5, 8972, 127, 71, 158, 2, 16, 2, 4, 3327, 34, },
{44099, 3, 2, 0, 9684, 127, 71, 158, 2, 22, 2635, 34, },
{43965, 4, 5627, 127, 71, 158, 2, 22, 6442, 34, },
{43971, 5, 6001, 127, 71, 158, 2, 17, 2, 3, 6096, 34, },
{54787, 35, 120, 34, 41, 243, 808, 34, },
{58153, 349, },
{59946, 349, },
{60296, 349, },
{60646, 349, },
{69927, 349, },
{69577, 349, },
{70627, 349, },
{71791, 349, },
{72141, 349, },
{72491, 349, },
{75386, 349, },
{75736, 349, },
{76086, 349, },
{121551, 349, },
{122251, 349, },
{121901, 349, },
{131070, 349, },
{130370, 349, },
{130720, 349, },
}

local function getQualityValue()
end

local function findItemId()
end
























-- This function takes the above table and returns a table of the item links.
function createSetItemIdTable(setId)
	local start = itemSetIds[setId][1]
	local start = 0
	local table = {}
	local numRanges = #itemSetIds[setId]/2
	for j = 1, numRanges do
		start = start + itemSetIds[setId][j*2 - 1]
		for i = 0, itemSetIds[setId][j*2] do
			table[#table + 1] = start + i
		end
		start = start + itemSetIds[setId][j*2]
	end
	for i = 1, #table do
		table[i] = getItemLinkFromItemId(table[i])
	end
	return table
end
-- Doubt these will ever again be needed but can't hurt to keep em

function checkTable(table)
	local _, set = GetItemLinkSetInfo(table[1])
	local test = true
	for i = 1, #table do
		local _,info = GetItemLinkSetInfo(table[i])
		if info ~= set then
			test = false
		end
	end
	d(test)
end

function checkItemIds()
	for i = 1, #itemSetIds do
		zo_callLater(function()checkTable(createSetItemIdTable(i)) end , 500*i)
	end
end
