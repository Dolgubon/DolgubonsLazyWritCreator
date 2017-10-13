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
local sortCraftQueue = LibLazyCrafting.sortCraftQueue
SetIndexes ={}
local abc = 1
local MaterialitemIDTable = {}
local improvementChances = {}
local function dbug(...)
	if DolgubonGlobalDebugOutput then
		DolgubonGlobalDebugOutput(...)
	end
end

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


local function copy(t)
	local a = {}
	for k, v in pairs(t) do
		a[k] = v
	end
	return a
end

local function getItemLinkFromItemId(itemId) local name = GetItemLinkName(ZO_LinkHandler_CreateLink("Test Trash", nil, ITEM_LINK_TYPE,itemId, 1, 26, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 10000, 0)) 
	return ZO_LinkHandler_CreateLink(zo_strformat("<<t:1>>",name), nil, ITEM_LINK_TYPE,itemId, 1, 26, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 10000, 0) end


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
			if GetCurrentSmithingMaterialItemCount(craftRequestTable["pattern"],craftRequestTable["materialIndex"])>craftRequestTable["materialQuantity"] then
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
	if craftRequestTable["setIndex"] == 0 then
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
	
	if not setIndex then setIndex = 0 end
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
	for i = 1, requirementJumps do
		if index < requirementJumps[i] then
		else
			return i
		end
	end
end


local function GetMatRequirements(pattern, index, station)
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


local function LLC_CraftSmithingItem(self, patternIndex, materialIndex, materialQuantity, styleIndex, traitIndex, useUniversalStyleItem, stationOverride, setIndex, quality, autocraft, reference)
	dbug("FUNCTION:LLCSmithing")
	if reference == nil then reference = "" end
	if not self then d("Please call with colon notation") end
	if autocraft==nil then autocraft = self.autocraft end
	local station
	if type(self) == "number" then
		d("Please call using colon notation: e.g LLC:CraftSmithingItem(). If you are seeing this and you are not a developer please contact the author of the addon")
	end
	if not (stationOverride==CRAFTING_TYPE_BLACKSMITHING or stationOverride == CRAFTING_TYPE_WOODWORKING or stationOverride == CRAFTING_TYPE_CLOTHIER) then
		if GetCraftingInteractionType() == 0 then
			d("Invalid Station")
			return
		else
			station = GetCraftingInteractionType()
		end
	else
		station =stationOverride
	end
	--Handle the extra values. If they're nil, assign default values.
	if not quality then setIndex = 0 end
	if not quality then quality = 0 end

	-- create smithing request table and add to the queue
	if self.addonName=="LLC_Global" then d("Item added") end
	table.insert(craftingQueue[self.addonName][station],
	{
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
		["timestamp"] = GetTimeStamp(),
		["autocraft"] = autocraft,
		["Requester"] = self.addonName,
		["reference"] = reference,
	})

	sortCraftQueue()
	if not IsPerformingCraftProcess() and GetCraftingInteractionType()~=0 then  
		LibLazyCrafting.craftInteractionTables[GetCraftingInteractionType()]["function"](GetCraftingInteractionType()) 
	end
end

local function LLC_CraftSmithingItemByLevel(self, patternIndex, isCP , level, styleIndex, traitIndex, useUniversalStyleItem, stationOverride, setIndex, quality, autocraft, reference)
	local materialIndex = findMatIndex(level, isCP)

	local materialQuantity = GetMatRequirements(patternIndex, materialIndex, stationOverride)

	LLC_CraftSmithingItem(self, patternIndex, materialIndex, materialQuantity, styleIndex, traitIndex, useUniversalStyleItem, stationOverride, setIndex, quality, autocraft, reference)
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
	local a = {
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
	["timestamp"] = GetTimeStamp(),}
	table.insert(craftingQueue[self.addonName][station], a)
	sortCraftQueue()

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




-------------------------------------------------------
-- SMITHING INTERACTION FUNCTIONS

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
			CraftSmithingItem(unpack(parameters))

			currentCraftAttempt = copy(earliest)
			currentCraftAttempt.position = position
			currentCraftAttempt.callback = LibLazyCrafting.craftResultFunctions[addon]
			currentCraftAttempt.slot = FindFirstEmptySlotInBag(BAG_BACKPACK)
			currentCraftAttempt.timestamp = GetTimeStamp()
			table.remove(parameters,6 )

			currentCraftAttempt.link = GetSmithingPatternResultLink(unpack(parameters))
			--d("Making reference #"..tostring(currentCraftAttempt.reference).." link: "..currentCraftAttempt.link)
		elseif earliest.type =="improvement" then
			local parameters = {}
			local skillIndex = station + 1 - math.floor(station/6)
			local currentSkill, maxSkill = GetSkillAbilityUpgradeInfo(SKILL_TYPE_TRADESKILL,skillIndex,6)
			if earliest.quality==GetItemLinkQuality(GetItemLink(earliest.ItemBagID, earliest.ItemSlotID))then
				dbug("ACTION:RemoveImprovementRequest")
				LibLazyCrafting.craftResultFunctions[earliest.Requester](LLC_CRAFT_SUCCESS, earliest.station, 
					{["bag"] = BAG_BACKPACK,["slot"] = currentCraftAttempt.slot,["reference"] = earliest.reference} )
				craftingQueue[addon][station][position] = nil
				sortCraftQueue()
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
			ImproveSmithingItem(earliest.ItemBagID,earliest.ItemSlotID, numBooster)
			currentCraftAttempt = copy(earliest)
			currentCraftAttempt.position = position
			currentCraftAttempt.callback = LibLazyCrafting.craftResultFunctions[addon]
			currentCraftAttempt.timestamp = GetTimeStamp()
			currentCraftAttempt.link = GetSmithingImprovedItemLink(earliest.ItemBagID, earliest.ItemSlotID, station)
		end
		
			--ImproveSmithingItem(number itemToImproveBagId, number itemToImproveSlotIndex, number numBoostersToUse)
			--GetSmithingImprovedItemLink(number itemToImproveBagId, number itemToImproveSlotIndex, number TradeskillType craftingSkillType, number LinkStyle linkStyle)
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

local function SmithingCraftCompleteFunction(station)
	dbug("EVENT:CraftComplete")
	--d("complete at "..GetTimeStamp())
	if currentCraftAttempt.type == "smithing" then
		if WasItemCrafted() then
			
			dbug("ACTION:RemoveRequest")
			
			--d("Item found")
			table.remove(craftingQueue[currentCraftAttempt.Requester][station],currentCraftAttempt.position )
			if currentCraftAttempt.quality>1 then
				--d("Improving #".. tostring(currentCraftAttempt.reference))
				LLC_ImproveSmithingItem({["addonName"]=currentCraftAttempt.Requester}, BAG_BACKPACK, currentCraftAttempt.slot, currentCraftAttempt.quality, currentCraftAttempt.autocraft, currentCraftAttempt.reference)
			else
				local errorFound, err =  pcall(function()LibLazyCrafting.craftResultFunctions[currentCraftAttempt.Requester](LLC_CRAFT_SUCCESS, station, 
					{["bag"] = BAG_BACKPACK,["slot"] = currentCraftAttempt.slot,["reference"] = currentCraftAttempt.reference} )end)
					if not errorFound then
						d("Callback to LLC resulted in an error. Please contact the author of "..currentCraftAttempt.Requester)
						d(err)
					end
			end
			currentCraftAttempt = {}
			sortCraftQueue()

		end
	elseif currentCraftAttempt.type == "improvement" then

		if WasItemImproved(currentCraftAttempt) then

			table.remove(craftingQueue[currentCraftAttempt.Requester][station],currentCraftAttempt.position )
			LibLazyCrafting.craftResultFunctions[currentCraftAttempt.Requester](LLC_CRAFT_SUCCESS, station, 
					{["bag"] = BAG_BACKPACK,["slot"] = currentCraftAttempt.slot,["reference"] = currentCraftAttempt.reference} )
		end
		currentCraftAttempt = {}
		sortCraftQueue()
	else

		return
	end
end

local function compileRequirements(request, station)-- Ingot/style mat/trait mat/improvement mat
	local requirements = {}
	requirements[MaterialitemIDTable[station][findMatTierByIndex(request.materialIndex)]] = request.materialQuantity
	requirements[ GetItemIDFromLink( GetSmithingStyleItemLink(request.style , 0))] = 1
	requirements[GetItemIDFromLink( GetSmithingTraitItemLink(request.trait, 0))] = 1
	if request.quality==1 then return requirements end
	

end

LibLazyCrafting.craftInteractionTables[CRAFTING_TYPE_BLACKSMITHING] =
{
	["check"] = function(station) return station == CRAFTING_TYPE_BLACKSMITHING end,
	['function'] = LLC_SmithingCraftInteraction,
	["complete"] = SmithingCraftCompleteFunction,
	["endInteraction"] = function(station) --[[endInteraction()]] end,
	["isItemCraftable"] = function(station, request) 
	
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
	["materialRequirements"] = function(request) return compileRequirements(request, CRAFTING_TYPE_BLACKSMITHING) end 
}
-- Should be the same for other stations though. Except for the check
LibLazyCrafting.craftInteractionTables[CRAFTING_TYPE_WOODWORKING] = copy(LibLazyCrafting.craftInteractionTables[CRAFTING_TYPE_BLACKSMITHING]) 
LibLazyCrafting.craftInteractionTables[CRAFTING_TYPE_WOODWORKING]["check"] = function(station) return station == CRAFTING_TYPE_WOODWORKING end 
LibLazyCrafting.craftInteractionTables[CRAFTING_TYPE_WOODWORKING]["materialRequirements"] = function(request) return compileRequirements(CRAFTING_TYPE_WOODWORKING) end 

LibLazyCrafting.craftInteractionTables[CRAFTING_TYPE_CLOTHIER] = copy(LibLazyCrafting.craftInteractionTables[CRAFTING_TYPE_BLACKSMITHING])
LibLazyCrafting.craftInteractionTables[CRAFTING_TYPE_CLOTHIER]["check"] = function(station) return station == CRAFTING_TYPE_CLOTHIER end 
LibLazyCrafting.craftInteractionTables[CRAFTING_TYPE_CLOTHIER]["materialRequirements"] = function(request) return compileRequirements(CRAFTING_TYPE_CLOTHIER) end 



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
}

for i = 1,#SetIndexes do 
	local _, a = GetItemLinkSetInfo(getItemLinkFromItemId(SetIndexes[i][1][1]),false)
	table.insert(SetIndexes[i],1,a)
end


function GetSetIndexes()

	return SetIndexes
end

-- IDs for stuff like Sanded Ruby Ash, Iron Ingots, etc.
MaterialitemIDTable = 
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
	43543,
	43543,
	43543,
	43543,
	43543,
	},
	[CRAFTING_TYPE_WOODWORKING] = 
	{
	803,
	533,
	23121,
	23122,
	23123,
	43549,
	43549,
	43549,
	43549,
	43549,
	},
}

improvementChances = 
{
	[1] = {5, 7,10,20},
	[2] = {4,5,7,14},
	[3] = {3,4,5,10},
	[4] = {2,3,4,8},
}