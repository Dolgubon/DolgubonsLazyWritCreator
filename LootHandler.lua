-----------------------------------------------------------------------------------
-- Addon Name: Dolgubon's Lazy Writ Crafter
-- Creator: Dolgubon (Joseph Heinzle)
-- Addon Ideal: Simplifies Crafting Writs as much as possible
-- Addon Creation Date: March 14, 2016
--
-- File Name: LootHandler.lua
-- File Description: This file handles the loot received from Writs. It opens containers, and logs the rewards
-- Load Order Requirements: None
-- 
-----------------------------------------------------------------------------------

WritCreater = WritCreater or {}

lootedItemLinks = {}
-- {itemLink, bag, slot}
local pendingItemActions = {}
WritCreater.pendingItemActions = pendingItemActions
-- if GetDisplayName() == "@Dolgubon" then
-- 	lootedItemLinks["|H0:item:57781:4:1:0:0:0:0:0:0:0:0:0:0:0:1:0:0:1:0:0:0|h|h"] = true
-- end

--Saves what the user got from the writ rewards

local function round(f)
    if not f then return f end
    return math.floor(0.5+f)
end
-- Convert a Master Writ item_link into the integer number of
-- writ vouchers it returns.
local function toVoucherCount(item_link)
	local x = { ZO_LinkHandler_ParseLink(item_link) }
	local writ_reward      = tonumber(x[24])
    local vc          = round(writ_reward/ 10000)
    return vc
end

WritCreater.toVoucherCount = toVoucherCount

local function updateSavedVars(vars, location, quantity)
	-- d("Saving "..location.." #"..quantity)
	if vars and vars[location]  then
		vars[location] = vars[location] + quantity
	elseif vars then
		vars[location] = quantity
	end
end

local function lootOutput(itemLink, itemType, quantity, isAnniversary)

	if WritCreater:GetSettings().lootOutput then
		local amountBag, amountBank, amountCraft = GetItemLinkStacks( itemLink)
		local amount = amountCraft + amountBank + amountBag + quantity
		local text
		if itemType then 
			text = zo_strformat( "1 "..WritCreater.strings.lootReceivedM.." ("..tostring(toVoucherCount(itemLink)).." v)", itemLink)
		else
			text = zo_strformat( WritCreater.strings.lootReceived, itemLink, amount, quantity)
		end
		if isAnniversary then
			text = text.. " (Anniversary Box)"
		else
			d(text)
		end
	end
end

--begin the save stat process. Also decides if a mail with current stats should be sent.
local function LootAllHook(boxType) -- technically not a hook.

	local vars = WritCreater.savedVarsAccountWide["rewards"][boxType]
	if vars==nil then return end
	local loot = {}
	for i = 1, GetNumLootItems() do

		local lootId, name, _, quantity = GetLootItemInfo(i)
		local itemLink = GetLootItemLink(lootId, 0)
		lootedItemLinks[GetItemLinkItemId(itemLink)] = true
		--d(itemLink)
		local itemType, specializedType = GetItemLinkItemType(itemLink) 
		-- if it's gear
		if name=="" then
		elseif itemType==ITEMTYPE_ARMOR or itemType==ITEMTYPE_WEAPON then
			if GetItemLinkTraitInfo(itemLink)==19 then
				updateSavedVars(vars, "ornate", quantity)
			else
				updateSavedVars(vars, "intricate", quantity)
			end
		elseif CanItemLinkBeVirtual(itemLink) then 
			updateSavedVars(vars, GetItemLinkItemId(itemLink), quantity)
			if GetItemLinkQuality(itemLink) == ITEM_QUALITY_LEGENDARY or GetItemLinkItemId(itemLink) ==135153 or GetItemLinkItemId(itemLink) == 135149 then
				lootOutput(itemLink, nil, quantity)
			end
		elseif itemType==ITEMTYPE_RECIPE then 
			local quality = GetItemLinkQuality(itemLink)
			if quality==ITEM_QUALITY_MAGIC then
				updateSavedVars(vars["recipe"], "green", quantity)
			elseif quality == ITEM_QUALITY_ARCANE then
				updateSavedVars(vars["recipe"], "blue", quantity)
			elseif quality == ITEM_QUALITY_ARTIFACT then
				updateSavedVars(vars["recipe"], "purple", quantity)
			elseif quality == ITEMITEM_QUALITY_NORMAL then
				updateSavedVars(vars["recipe"], "white", quantity)
			elseif quality == ITEM_QUALITY_LEGENDARY then
				updateSavedVars(vars["recipe"], "gold", quantity)
			else
				updateSavedVars(vars["recipe"], "unkownQuality", quantity)
			end
		elseif specializedType==SPECIALIZED_ITEMTYPE_TROPHY_SURVEY_REPORT then
			lootOutput(itemLink, nil , quantity)
			updateSavedVars(vars, "survey", quantity)
		elseif specializedType ==SPECIALIZED_ITEMTYPE_TROPHY_RECIPE_FRAGMENT then
			updateSavedVars(vars, "fragment", quantity)
		elseif itemType ==ITEMTYPE_CONTAINER then
			updateSavedVars(vars, "material", quantity)
		elseif itemType ==ITEMTYPE_TOOL then
			updateSavedVars(vars, "repair", quantity)
		elseif itemType ==ITEMTYPE_GLYPH_JEWELRY or itemType ==ITEMTYPE_GLYPH_ARMOR or itemType ==ITEMTYPE_GLYPH_WEAPON then
			updateSavedVars(vars, "glyph", quantity)
		elseif itemType == ITEMTYPE_SOUL_GEM then 
			updateSavedVars(vars, "soulGem", quantity)
		elseif itemType == ITEMTYPE_MASTER_WRIT then
			lootOutput(itemLink, ITEMTYPE_MASTER_WRIT, quantity)
			updateSavedVars(vars, "master", quantity)
			updateSavedVars(vars, "voucher", toVoucherCount(itemLink))
		elseif specializedType == SPECIALIZED_ITEMTYPE_RACIAL_STYLE_MOTIF_CHAPTER then
			lootOutput(itemLink, nil, quantity)
		elseif specializedType == SPECIALIZED_ITEMTYPE_CONTAINER_STYLE_PAGE then
			lootOutput(itemLink, nil, quantity)
		elseif specializedType == SPECIALIZED_ITEMTYPE_NONE then -- assume it's a lead I guess
			lootOutput(itemLink, nil, 1)
			vars["lead"] = vars["lead"] or 0
			updateSavedVars(vars, "lead", quantity)
		else
			if vars["other"]==nil then vars["other"] = 0 end
			updateSavedVars(vars, "other", quantity)
		end
	end
	WritCreater.updateList()
	--saveStats(loot,boxType,boxRank)
end

--if the stats should be saved, saves them

local function shouldSaveStats(boxType)
	if GetNumLootItems() < 2 then return false end
	if boxType == 0 then return false end -- then it's an anniversary box

	return true
end

local function shouldAutoLootContainerFromSettings()
	local autoLoot
	if WritCreater:GetSettings().ignoreAuto then
		autoLoot = WritCreater:GetSettings().autoLoot
	else
		autoLoot = GetSetting(SETTING_TYPE_LOOT,LOOT_SETTING_AUTO_LOOT) == "1"
	end
	return autoLoot
end

local fatiguedLoot = 
{

}

local completeTimes = 0
local cooldown = 0
local function clearLootFatigue()
	fatiguedLoot = {}
	EVENT_MANAGER:UnregisterForUpdate(WritCreater.name.."LootSavingFatigue")
end
local callFromSlotUpdated = false
--If the box/loot item that is open is a writ container, loot it and open the inventory again
local calledFromQuest = false
local containerHasTransmute = {}
local lastInteractedSlot = nil
local function OnLootUpdated(event)
	local ignoreAuto = WritCreater:GetSettings().ignoreAuto
	local autoLoot  = shouldAutoLootContainerFromSettings()

	local lootInfo = {GetLootTargetInfo()}
	local writRewardNames = WritCreater.boxNames
	if lootInfo[1] == "" and ((GetGameTimeMilliseconds() - cooldown) < 1000 )then
		-- zo_callLater(EndLooting, 100)
		return true
	end
	local boxInfo = writRewardNames[lootInfo[1]]
	if boxInfo then
		local boxRank = boxInfo[1]
		local boxCraft = boxInfo[2]
		if boxCraft == 0 and boxCraft > 0 then 
			local itemType = GetItemLinkItemType(GetLootItemLink(GetLootItemInfo(1),1))
			if not (itemType == 36 or itemType == 38 or itemType == 40 or itemType ==64) then
				return false
			end
		elseif boxCraft == 0 then
			if not WritCreater:GetSettings().lootJubileeBoxes then 
				return false
			end
		end
		--LOOT_SHARED:LootAllItems()
		local n = SCENE_MANAGER:GetCurrentScene().name
		
		local numTransmute = GetCurrencyAmount(CURT_CHAOTIC_CREATIA,CURRENCY_LOCATION_ACCOUNT)
		local numLootTransmute = GetLootCurrency(CURT_CHAOTIC_CREATIA)

		EVENT_MANAGER:UnregisterForUpdate(WritCreater.name.."LootSavingFatigue")
		EVENT_MANAGER:RegisterForUpdate(WritCreater.name.."LootSavingFatigue", 10000, clearLootFatigue)
		if shouldSaveStats(boxCraft) and not fatiguedLoot[boxCraft] and boxCraft~= 0 then 
			LootAllHook(boxCraft)
		else
			local loot = {}
			for j = 1, GetNumLootItems() do

				local lootId, name, _, quantity = GetLootItemInfo(j)
				local itemLink = GetLootItemLink(lootId, 0)
				local itemId = GetItemLinkItemId(itemLink)
				--d(itemLink)
				local quality = GetItemLinkQuality(itemLink)
				local itemType, specializedType = GetItemLinkItemType(itemLink) 
				if specializedType == SPECIALIZED_ITEMTYPE_RACIAL_STYLE_MOTIF_CHAPTER then
					lootOutput(itemLink, nil, quantity, true)
				elseif specializedType == SPECIALIZED_ITEMTYPE_CONTAINER_STYLE_PAGE then
					lootOutput(itemLink, nil, quantity, true)
				elseif quality>=ITEM_QUALITY_ARCANE then
					lootOutput(itemLink, nil, quantity, true)
				elseif itemId == 56863 or itemId == 56862 then
					lootOutput(itemLink, nil, quantity, true)
				end
			end
		end
		fatiguedLoot[boxCraft] = true
		if autoLoot then
			if numLootTransmute==0 or numTransmute + numLootTransmute <=GetMaxPossibleCurrency( 5 , CURRENCY_LOCATION_ACCOUNT) then
				if numLootTransmute > 0 then
					d(numLootTransmute.." Transmute Stone recieved (You have "..(numTransmute + numLootTransmute)..")")
					if GetMaxPossibleCurrency( 5 , CURRENCY_LOCATION_ACCOUNT) * 0.8 < numTransmute + numLootTransmute then
						d("You are approaching the transmute stone limit. If a box would put you over the transmute stone limit, Writ Crafter will not loot the stones.")
					end
				end
				LootAll()
			else
				-- GetLootItemInfo(number lootIndex)
				-- do not loot the transmute if it would go over max
				for i = 1, GetNumLootItems() do
					local lootId, name,_,_,_,_,_,_,lootType = GetLootItemInfo(i)
					LootItemById(lootId)
				end
				-- Then add the container to a 'blacklist' so we don't try to open it in a loop
				if lastInteractedSlot then
					containerHasTransmute[lastInteractedSlot] = true
					WritCreater:GetSettings().transmuteBlock[Id64ToString(GetItemUniqueId(1, lastInteractedSlot))] = numLootTransmute
				end
				d("Looting these transmute stones would put you over the maximum, so "..numLootTransmute.." transmute stones were not looted")
				EndLooting()
			end
		else
			return false
		end
		return true
	end
	calledFromQuest = false
	return false
end

local flavours = {
	[GetItemLinkFlavorText("|H1:item:121302:175:1:0:0:0:0:0:0:0:0:0:0:0:1:0:0:1:0:0:0|h|h")] = true, -- Normal reward
	[GetItemLinkFlavorText("|H1:item:138816:3:1:0:0:0:0:0:0:0:0:0:0:0:1:0:0:1:0:0:0|h|h")] = true, -- Jewelry shipment reward
	[GetItemLinkFlavorText("|H1:item:147603:3:1:0:0:0:0:0:0:0:0:0:0:0:1:0:0:1:0:0:0|h|h")] = true, -- Jewelry shipment reward type 2 (for German only)
	[GetItemLinkFlavorText("|H1:item:142175:3:1:0:0:0:0:0:0:0:0:0:0:0:1:0:0:1:0:0:0|h|h")] = true, -- Shipment reward
	
}
local anniversaryBoxie = GetItemLinkFlavorText("|H1:item:194428:124:1:0:0:0:2023:0:0:0:0:0:0:0:1:0:0:1:0:0:0|h|h")
local plunderSkulls = GetItemLinkFlavorText("|H1:item:153502:123:1:0:0:0:0:0:0:0:0:0:0:0:1:0:0:1:0:0:0|h|h")
local flavourTexts = {}
setmetatable(flavourTexts, {__index = function(t, i)
	if flavours[i] then return true end
	if i == anniversaryBoxie then
		return WritCreater:GetSettings().lootJubileeBoxes
	end
	if i==plunderSkulls and GetDisplayName()=="@Dolgubon" then
		return true
	end
end
})
-- local flavourTexts = {
-- 	[GetItemLinkFlavorText("|H1:item:121302:175:1:0:0:0:0:0:0:0:0:0:0:0:1:0:0:1:0:0:0|h|h")] = true, -- Normal reward
-- 	[GetItemLinkFlavorText("|H1:item:138816:3:1:0:0:0:0:0:0:0:0:0:0:0:1:0:0:1:0:0:0|h|h")] = true, -- Jewelry shipment reward
-- 	[GetItemLinkFlavorText("|H1:item:147603:3:1:0:0:0:0:0:0:0:0:0:0:0:1:0:0:1:0:0:0|h|h")] = true, -- Jewelry shipment reward type 2 (for German only)
-- 	[GetItemLinkFlavorText("|H1:item:142175:3:1:0:0:0:0:0:0:0:0:0:0:0:1:0:0:1:0:0:0|h|h")] = true, -- Shipment reward
-- 	[GetItemLinkFlavorText("|H1:item:147430:124:1:0:0:0:0:0:0:0:0:0:0:0:1:0:0:1:0:0:0|h|h")] = 1, -- anniversary
-- }
local scanBagForUnopenedContainers

local lootClosedTime
local slotUpdateHandler
-- _G[savedVariablesName][GetWorldName()][GetDisplayName()][characterName]
SLASH_COMMANDS['/transmuteboxtotal'] = function()
	local sum = 0
	for toon, v in pairs(_G["DolgubonsWritCrafterSavedVars"]["Default"][GetDisplayName()]) do
		local toonSum = 0
		if v.transmuteBlock then
			for boxId, numTransmutes in pairs(v.transmuteBlock) do
				sum = sum + numTransmutes
				toonSum = toonSum + numTransmutes
			end
			d("Total transmutes for "..tostring(v["$LastCharacterName"]).." : "..toonSum)
		end
	end
	d("Total transmutes for account : "..sum)
end
local function shouldOpenContainer(bag, slot)
	if not WritCreater:GetSettings().lootContainerOnReceipt then return false end

	if not shouldAutoLootContainerFromSettings() then return false end

	if FindFirstEmptySlotInBag(BAG_BACKPACK) == nil then return false end

	if containerHasTransmute[slot] then return false end

	local uniqueId = Id64ToString(GetItemUniqueId(bag, slot))
	if WritCreater:GetSettings().transmuteBlock[uniqueId] then
		local maxTransmutes = GetMaxPossibleCurrency( 5 , CURRENCY_LOCATION_ACCOUNT)
		local currentTransmutes = GetCurrencyAmount(CURT_CHAOTIC_CREATIA,CURRENCY_LOCATION_ACCOUNT)
		local transmuteSpace = maxTransmutes - currentTransmutes
		if WritCreater:GetSettings().transmuteBlock[uniqueId] > transmuteSpace then
			return false 
		end
	end

	local itemType, specialItemType = GetItemType(bag, slot)
	if itemType ~=ITEMTYPE_CONTAINER or specialItemType == SPECIALIZED_ITEMTYPE_CONTAINER_STYLE_PAGE then return false end

	local flavour = GetItemLinkFlavorText(GetItemLink(bag, slot))
	return flavourTexts[flavour]
end

local function openContainer(bag, slot)
	if not shouldOpenContainer(bag, slot) then return end
	lastInteractedSlot = slot
	cooldown = GetGameTimeMilliseconds()
	if IsProtectedFunction("UseItem") then
		CallSecureProtected("UseItem", bag, slot)
	else
		UseItem(bag, slot)
	end 
	calledFromQuest = true
	EVENT_MANAGER:RegisterForUpdate(WritCreater.name.."LootRescan", 100, scanBagForUnopenedContainers)
end

local cooldownTimer = 300

local function prepareToInteract()
	if IsUnitSwimming("player") then return true end
	if IsUnitInCombat("player") then return true end
	if not TRIBUTE.gameFlowState == TRIBUTE_GAME_FLOW_STATE_INACTIVE then return true end
	if IsLooting() then return true end
	if GetGameTimeMilliseconds() - cooldown < cooldownTimer then return true end
	local _, interact = GetGameCameraInteractableActionInfo()
	if interact and WritCreater.langWritNames() then
		local names =WritCreater.langWritNames()
		for i = 1, #WritCreater.langWritNames() do
			if string.find(interact, names[i]) then
				return true
			end
		end
	end
	if GetTimeStamp() <completeTimes + WritCreater:GetSettings().containerDelay then
		--d("Delay, complete time "..completeTimes)
		return true
	end
	return false
end

local function attemptOpenContainer(bag, slot)
	
	if GetSlotCooldownInfo( 1 )>0 or IsInteractionUsingInteractCamera() or SCENE_MANAGER:GetCurrentScene().name=='interact' or prepareToInteract() then
		zo_callLater(function()attemptOpenContainer(bag, slot) end , math.max(GetSlotCooldownInfo( 1 ) + cooldownTimer,300))
	else
		openContainer(bag, slot)
	end
end
-- bag, slot, itemId, action
WritCreater.rewardList = {
}

local function rewardHandler(bag, slot)
	local itemType, specializedType = GetItemLinkItemType(itemLink) 
	-- if it's gear
	if name=="" then
	elseif itemType==ITEMTYPE_ARMOR or itemType==ITEMTYPE_WEAPON then
		if GetItemLinkTraitInfo(itemLink)==19 then
			updateSavedVars(vars, "ornate", quantity)
		else
			updateSavedVars(vars, "intricate", quantity)
		end
	elseif CanItemLinkBeVirtual(itemLink) then 
		updateSavedVars(vars, GetItemLinkItemId(itemLink), quantity)
	elseif itemType==ITEMTYPE_RECIPE then 
		updateSavedVars(vars["recipe"], "green", quantity)
	elseif specializedType==SPECIALIZED_ITEMTYPE_TROPHY_SURVEY_REPORT then
		updateSavedVars(vars, "survey", quantity)
	elseif specializedType ==SPECIALIZED_ITEMTYPE_TROPHY_RECIPE_FRAGMENT then
		updateSavedVars(vars, "fragment", quantity)
	elseif itemType ==ITEMTYPE_CONTAINER then
		updateSavedVars(vars, "material", quantity)
	elseif itemType ==ITEMTYPE_TOOL then
		updateSavedVars(vars, "repair", quantity)
	elseif itemType ==ITEMTYPE_GLYPH_JEWELRY or itemType ==ITEMTYPE_GLYPH_ARMOR or itemType ==ITEMTYPE_GLYPH_WEAPON then
		updateSavedVars(vars, "glyph", quantity)
	elseif itemType == ITEMTYPE_SOUL_GEM then 
		updateSavedVars(vars, "soulGem", quantity)
	elseif itemType == ITEMTYPE_MASTER_WRIT then
		updateSavedVars(vars, "master", quantity)
	end
end

local handledItemTypes = 
{
	[ITEMTYPE_MASTER_WRIT] = "master",
	[SPECIALIZED_ITEMTYPE_TROPHY_SURVEY_REPORT] = "survey",
	[44879] = "repair",
	-- Subtracting 100 so that an item with an item type matching the item trait does not return intricate
	[ITEM_TRAIT_TYPE_ARMOR_INTRICATE-100] = "intricate",
	[ITEM_TRAIT_TYPE_JEWELRY_INTRICATE-100] = "intricate",
	[ITEM_TRAIT_TYPE_WEAPON_INTRICATE-100] = "intricate",
	[ITEM_TRAIT_TYPE_ARMOR_ORNATE-100] = "ornate",
	[ITEM_TRAIT_TYPE_JEWELRY_ORNATE-100] = "ornate",
	[ITEM_TRAIT_TYPE_WEAPON_ORNATE-100] = "ornate",
}

-- EVENT_MANAGER:RegisterForUpdate(WritCreater.name.."OpenAllContainers", 1000, scanBagForUnopenedContainers)
local function slotUpdateHandler(event, bag, slot, isNew,_,reason,changeAmount,...)

	if WritCreater.checkIfMasterWritWasStarted then WritCreater.checkIfMasterWritWasStarted(event, bag, slot, isNew,...) end
	local autoLoot
	if WritCreater:GetSettings().ignoreAuto then
		autoLoot = WritCreater:GetSettings().autoLoot
	else
		autoLoot = GetSetting(SETTING_TYPE_LOOT,LOOT_SETTING_AUTO_LOOT) == "1"
	end
	local link = GetItemLink(bag, slot)
	if isNew then
		if not bag or not slot then return end

		if WritCreater:GetSettings().lootContainerOnReceipt and shouldOpenContainer(bag, slot) then
			attemptOpenContainer(bag, slot)
			-- if not autoLoot then return end
		end
	end
	--|H1:item:194428:123:1:0:0:0:2024:0:0:0:0:0:0:0:1:0:0:1:0:0:0|h|h
	------
	-- REWARD HANDLING
	if isNew then --or GetDisplayName() == "@Dolgubon" then
		-- d(link.." "..tostring(isNew).." "..tostring(lootedItemLinks[link]))
		local itemId = GetItemLinkItemId(link)
		if lootedItemLinks[itemId] then
			-- d("Looted ".. link)
			if lootedItemLinks[itemId] == nil then
				-- d("Wasn't logged yet! "..link)
			else
				-- d("Was logged "..link)
			end
			lootedItemLinks[itemId] = false
			local itemType, specializedType = GetItemLinkItemType(link) 
			local itemName = GetItemLinkName(link)
			local itemTrait = GetItemLinkTraitInfo(link)
			local actionSourceName = handledItemTypes[itemType] or handledItemTypes[specializedType] or handledItemTypes[itemId] or handledItemTypes[itemTrait-100]
			if actionSourceName then
				-- d("Passed first check")
				local craftType
				craftType = WritCreater.getWritAndSurveyType(link)
				local actionSource = WritCreater:GetSettings().rewardHandling[actionSourceName]
				local action

				if actionSource.sameForAllCrafts then
					action = actionSource.all
				else
					action = actionSource[craftType]
				end
				if action == 1 then
					-- do nothing

					-- d("Do nothing")
				elseif action == 2 then
					d("Writ Crafter: Queued up to deposit "..link)
					table.insert(pendingItemActions, {link, 2, bag, slot, changeAmount})
				elseif action == 3 then
					SetItemIsJunk(bag, slot, true)
					d("Writ Crafter: Marked "..link.." as junk")
				elseif action == 4 then
					 DestroyItem(bag , slot)
					 d("Writ Crafter: Destroyed "..link.." because you told it to in the settings menu")
				elseif action == 5 then
					local id64 = GetItemUniqueId(bag, slot)
					local id64String = Id64ToString(id64)
					WritCreater.savedVars.deconstructList[id64String] = 
					{ 	
						["uniqueId"] = id64String , 
						["bag"] = bag, 
						["slot"] = slot,
						["timestamp"] = GetTimeStamp()
					}
					d("Writ Crafter: Queued "..link.." for deconstruction")
					WritCreater.LLCInteractionDeconstruct:DeconstructSmithingItem(bag, slot, true, id64String)
				end
				-- 1 nothing
				-- 2 deposit
				-- 3 Destroy
				-- 4 junk
				
			end
			-- determine type of item to find what we can do with it
			-- Can we do action right now?
				-- yes - do it
				-- No - queue it
		end
	end
end

function scanBagForUnopenedContainers( ... )
	if not FindFirstEmptySlotInBag(BAG_BACKPACK) then return end
	for i = 0, GetBagSize(BAG_BACKPACK) do 
		if shouldOpenContainer(BAG_BACKPACK, i) then
			slotUpdateHandler(1, BAG_BACKPACK, i, true)
		end
	end
	EVENT_MANAGER:UnregisterForUpdate(WritCreater.name.."LootRescan")
end
WritCreater.scanForUnopenedContainers = scanBagForUnopenedContainers



WritCreater.OnLootUpdated = OnLootUpdated

function WritCreater.LootHandlerInitialize()
	

	EVENT_MANAGER:RegisterForEvent(WritCreater.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, slotUpdateHandler)
	local oldfunc = ZO_SharedInventoryManager.ClearNewStatus
	ZO_SharedInventoryManager.ClearNewStatus = function(self, bag, slot) 

		if WritCreater:GetSettings().keepNewContainer and flavourTexts[ GetItemLinkFlavorText(GetItemLink(bag,slot))]then

		else
			oldfunc(self, bag, slot) 
		end 
	end
	EVENT_MANAGER:RegisterForEvent(WritCreater.name.."AddNewStatusContainers", EVENT_PLAYER_ACTIVATED, 
		function(e, first) 
			for k, v in pairs(PLAYER_INVENTORY.inventories[1].slots[1] ) do 
				if flavourTexts[ GetItemLinkFlavorText(GetItemLink(BAG_BACKPACK, v.searchData.slotIndex))] then
					v.brandNew = true
					v.age = 1
					v.statusSortOrder = 1
				end

				if GetDisplayName() =="@Dolgubon" and string.sub(GetItemLinkName(GetItemLink(BAG_BACKPACK, v.searchData.slotIndex)),16) == string.sub(GetItemLinkFlavorText("|H1:item:151602:4:1:0:0:0:0:0:0:0:0:0:0:0:1:0:0:1:0:0:0|h|h"),16) then
					-- DestroyItem(BAG_BACKPACK, v.searchData.slotIndex)
				end
			end
			-- PLAYER_INVENTORY.inventories[1].slots[1][149].brandNew = true 
			EVENT_MANAGER:UnregisterForEvent(WritCreater.name.."AddNewStatusContainers", EVENT_PLAYER_ACTIVATED)
			end )	
	ZO_PreHook(SYSTEMS:GetObject("loot"), "UpdateLootWindow", OnLootUpdated)
	
	EVENT_MANAGER:RegisterForEvent(WritCreater.name.."Deconstruct", EVENT_PLAYER_ACTIVATED,function() 

		for k, v in pairs(WritCreater.savedVars.deconstructList) do
			if v.timestamp and GetTimeStamp() - 60*60*24*30 > v.timestamp then
				WritCreater.savedVars.deconstructList[k] = nil
			elseif Id64ToString(GetItemUniqueId(v.bag, v.slot)) == v.uniqueId then
				local link = GetItemLink(v.bag, v.slot)
				d("Writ Crafter: Queued "..link.." for deconstruction")
				WritCreater.LLCInteractionDeconstruct:DeconstructSmithingItem(v.bag, v.slot, true, k)
			end
		end
		EVENT_MANAGER:UnregisterForEvent(WritCreater.name.."Deconstruct", EVENT_PLAYER_ACTIVATED)
	end )
	
end

--/script for k, v in pairs(SCENE_MANAGER:GetCurrentScene().callbackRegistry) do d(k) end
--SCENE_MANAGER:GetCurrentScene().callbackRegistry.tester = function() d("hudui") end

local originalLoot = LootItemById
function LootItemById(id)
	--d(id)
	originalLoot(id)
end
local originalLootAll = LootAll
function LootAll(id)
	--d("loot all")
	originalLootAll()
end
--[[
local f=true
local o=ZO_ActionBar_OnActionButtonDown 
ZO_ActionBar_OnActionButtonDown=function(s)if GetSlotName(s)=="Flames of Oblivion" then f=false else o(s)end end
z="ZO_ActionBar_OnActionButtonUp"
local p=_G[z]
_G[z]=function(s)f=true p(s)end
y="ZO_ActionBar_CanUseActionSlots"
local l=_G[y]
_G[y]=function(s)return f and l(s)end
]]
--[[
  local function UpdateLootWindow()

        local name, targetType, actionName, isOwned = GetLootTargetInfo()
        if name ~= "" then
            if targetType == INTERACT_TARGET_TYPE_ITEM then
                name = zo_strformat(SI_TOOLTIP_ITEM_NAME, name)
            elseif targetType == INTERACT_TARGET_TYPE_OBJECT then
                name = zo_strformat(SI_LOOT_OBJECT_NAME, name)
            elseif targetType == INTERACT_TARGET_TYPE_FIXTURE then
                name = zo_strformat(SI_TOOLTIP_FIXTURE_INSTANCE, name)
            end
        end

        SYSTEMS:GetObject("loot"):UpdateLootWindow(name, actionName, isOwned)
    end
]]

--[[
function CA.PrintBufferedXP()
    if g_xpCombatBufferValue > 0 and g_xpCombatBufferValue > CA.SV.XP.ExperienceFilter then
        local change = g_xpCombatBufferValue
        CA.PrintExperienceGain(change)
    end
    EVENT_MANAGER:UnregisterForUpdate(moduleName .. "BufferedXP")
    g_xpCombatBufferValue = 0
end
]]


WritCreater.rewardBoxes = { --To get exact name strings of boxes
	[57851] =  {1, CRAFTING_TYPE_BLACKSMITHING} , -- Blacksmithing
	[58131] =  {2, CRAFTING_TYPE_BLACKSMITHING} ,
	[58503] =  {3, CRAFTING_TYPE_BLACKSMITHING} ,
	[58504] =  {4, CRAFTING_TYPE_BLACKSMITHING} ,
	[58505] =  {5, CRAFTING_TYPE_BLACKSMITHING} ,
	[58506] =  {6, CRAFTING_TYPE_BLACKSMITHING} ,
	[58507] =  {7, CRAFTING_TYPE_BLACKSMITHING} ,
	[58508] =  {8, CRAFTING_TYPE_BLACKSMITHING} ,
	[58509] =  {9, CRAFTING_TYPE_BLACKSMITHING} ,
	[71234] =  {10, CRAFTING_TYPE_BLACKSMITHING} ,
	[121298] = {10, CRAFTING_TYPE_BLACKSMITHING} ,
	[142134] = {0, CRAFTING_TYPE_BLACKSMITHING} , -- shipments
	[142135] = {0, CRAFTING_TYPE_BLACKSMITHING} ,
	[142136] = {0, CRAFTING_TYPE_BLACKSMITHING} ,
	[142137] = {0, CRAFTING_TYPE_BLACKSMITHING} ,
	[142138] = {0, CRAFTING_TYPE_BLACKSMITHING} ,
	[142139] = {0, CRAFTING_TYPE_BLACKSMITHING} ,
	[142140] = {0, CRAFTING_TYPE_BLACKSMITHING} ,
	[142141] = {0, CRAFTING_TYPE_BLACKSMITHING} ,
	[142142] = {0, CRAFTING_TYPE_BLACKSMITHING} ,
	[142174] = {0, CRAFTING_TYPE_BLACKSMITHING} ,
	[58519] =  {1, CRAFTING_TYPE_CLOTHIER} , -- clothier, cloth
	[58520] =  {2, CRAFTING_TYPE_CLOTHIER} ,
	[58521] =  {3, CRAFTING_TYPE_CLOTHIER} ,
	[58522] =  {4, CRAFTING_TYPE_CLOTHIER} ,
	[58523] =  {5, CRAFTING_TYPE_CLOTHIER} ,
	[58524] =  {6, CRAFTING_TYPE_CLOTHIER} ,
	[58525] =  {7, CRAFTING_TYPE_CLOTHIER} ,
	[58526] =  {8, CRAFTING_TYPE_CLOTHIER} ,
	[58527] =  {9, CRAFTING_TYPE_CLOTHIER} ,
	[71233] =  {10, CRAFTING_TYPE_CLOTHIER} ,
	[121297] = {10, CRAFTING_TYPE_CLOTHIER} ,
	[142143] = {0, CRAFTING_TYPE_CLOTHIER } , -- shipments
	[142144] = {0, CRAFTING_TYPE_CLOTHIER } ,
	[142145] = {0, CRAFTING_TYPE_CLOTHIER } ,
	[142146] = {0, CRAFTING_TYPE_CLOTHIER } ,
	[142147] = {0, CRAFTING_TYPE_CLOTHIER } ,
	[142148] = {0, CRAFTING_TYPE_CLOTHIER } ,
	[142149] = {0, CRAFTING_TYPE_CLOTHIER } ,
	[142150] = {0, CRAFTING_TYPE_CLOTHIER } ,
	[142151] = {0, CRAFTING_TYPE_CLOTHIER } ,
	[142176] = {0, CRAFTING_TYPE_CLOTHIER } ,
	[147607] = {1, CRAFTING_TYPE_CLOTHIER } , -- leather
	[147608] = {2, CRAFTING_TYPE_CLOTHIER } ,
	[147609] = {3, CRAFTING_TYPE_CLOTHIER } ,
	[147610] = {4, CRAFTING_TYPE_CLOTHIER } ,
	[147611] = {5, CRAFTING_TYPE_CLOTHIER } ,
	[147612] = {6, CRAFTING_TYPE_CLOTHIER } ,
	[147613] = {7, CRAFTING_TYPE_CLOTHIER } ,
	[147614] = {8, CRAFTING_TYPE_CLOTHIER } ,
	[147615] = {9, CRAFTING_TYPE_CLOTHIER } ,
	[147616] = {10, CRAFTING_TYPE_CLOTHIER } ,
	[142152] = {0, CRAFTING_TYPE_CLOTHIER } , -- shipments
	[142153] = {0, CRAFTING_TYPE_CLOTHIER } ,
	[142154] = {0, CRAFTING_TYPE_CLOTHIER } ,
	[142155] = {0, CRAFTING_TYPE_CLOTHIER } ,
	[142156] = {0, CRAFTING_TYPE_CLOTHIER } ,
	[142157] = {0, CRAFTING_TYPE_CLOTHIER } ,
	[142158] = {0, CRAFTING_TYPE_CLOTHIER } ,
	[142159] = {0, CRAFTING_TYPE_CLOTHIER } ,
	[142160] = {0, CRAFTING_TYPE_CLOTHIER } ,
	[142177] = {0, CRAFTING_TYPE_CLOTHIER } ,
	[58528] = {1, CRAFTING_TYPE_ENCHANTING }, -- enchanting
	[58529] = {2, CRAFTING_TYPE_ENCHANTING },
	[58530] = {3, CRAFTING_TYPE_ENCHANTING },
	[58531] = {4, CRAFTING_TYPE_ENCHANTING },
	[58532] = {5, CRAFTING_TYPE_ENCHANTING },
	[58533] = {6, CRAFTING_TYPE_ENCHANTING },
	[58534] = {7, CRAFTING_TYPE_ENCHANTING },
	[59735] = {8, CRAFTING_TYPE_ENCHANTING },
	[59736] = {9, CRAFTING_TYPE_ENCHANTING },
	[71236] = {10, CRAFTING_TYPE_ENCHANTING },
	[59705] = {1, CRAFTING_TYPE_ALCHEMY } , -- alchemy
	[59706] = {2, CRAFTING_TYPE_ALCHEMY } ,
	[59707] = {3, CRAFTING_TYPE_ALCHEMY } ,
	[59708] = {4, CRAFTING_TYPE_ALCHEMY } ,
	[59709] = {5, CRAFTING_TYPE_ALCHEMY } ,
	[59710] = {6, CRAFTING_TYPE_ALCHEMY } ,
	[71238] = {7, CRAFTING_TYPE_ALCHEMY } ,
	[121302] ={7, CRAFTING_TYPE_ALCHEMY } ,
	[59714] =  {1, CRAFTING_TYPE_PROVISIONING} , -- provisioning
	[59715] =  {1, CRAFTING_TYPE_PROVISIONING} ,
	[59716] =  {1, CRAFTING_TYPE_PROVISIONING} ,
	[59717] =  {2, CRAFTING_TYPE_PROVISIONING} ,
	[59718] =  {2, CRAFTING_TYPE_PROVISIONING} ,
	[59719] =  {2, CRAFTING_TYPE_PROVISIONING} ,
	[59720] =  {3, CRAFTING_TYPE_PROVISIONING} ,
	[59721] =  {3, CRAFTING_TYPE_PROVISIONING} ,
	[59723] =  {4, CRAFTING_TYPE_PROVISIONING} ,
	[59724] =  {5, CRAFTING_TYPE_PROVISIONING} ,
	[59725] =  {6, CRAFTING_TYPE_PROVISIONING} ,
	[71237] =  {7, CRAFTING_TYPE_PROVISIONING} ,
	[121301] = {7, CRAFTING_TYPE_PROVISIONING} ,
	[58510] =  {1, CRAFTING_TYPE_WOODWORKING} , -- woodworking
	[58511] =  {2, CRAFTING_TYPE_WOODWORKING} ,
	[58512] =  {3, CRAFTING_TYPE_WOODWORKING} ,
	[58513] =  {4, CRAFTING_TYPE_WOODWORKING} ,
	[58514] =  {5, CRAFTING_TYPE_WOODWORKING} ,
	[58515] =  {6, CRAFTING_TYPE_WOODWORKING} ,
	[58516] =  {7, CRAFTING_TYPE_WOODWORKING} ,
	[58517] =  {8, CRAFTING_TYPE_WOODWORKING} ,
	[58518] =  {9, CRAFTING_TYPE_WOODWORKING} ,
	[71235] =  {10, CRAFTING_TYPE_WOODWORKING} ,
	[121299] = {10, CRAFTING_TYPE_WOODWORKING} ,
	[142161] = { 0, CRAFTING_TYPE_WOODWORKING} , -- shipments
	[142162] = { 0, CRAFTING_TYPE_WOODWORKING} ,
	[142163] = { 0, CRAFTING_TYPE_WOODWORKING} ,
	[142164] = { 0, CRAFTING_TYPE_WOODWORKING} ,
	[142165] = { 0, CRAFTING_TYPE_WOODWORKING} ,
	[142166] = { 0, CRAFTING_TYPE_WOODWORKING} ,
	[142167] = { 0, CRAFTING_TYPE_WOODWORKING} ,
	[142168] = { 0, CRAFTING_TYPE_WOODWORKING} ,
	[142169] = { 0, CRAFTING_TYPE_WOODWORKING} ,
	[142175] = { 0, CRAFTING_TYPE_WOODWORKING} ,
	[138801] = {1, CRAFTING_TYPE_JEWELRYCRAFTING} ,-- jewelry
	[138802] = {2, CRAFTING_TYPE_JEWELRYCRAFTING} ,
	[138803] = {3, CRAFTING_TYPE_JEWELRYCRAFTING} ,
	[138804] = {4, CRAFTING_TYPE_JEWELRYCRAFTING} ,
	[138805] = {5, CRAFTING_TYPE_JEWELRYCRAFTING} ,
	[142170] = {0, CRAFTING_TYPE_JEWELRYCRAFTING} , -- shipments
	[142171] = {0, CRAFTING_TYPE_JEWELRYCRAFTING} ,
	[142172] = {0, CRAFTING_TYPE_JEWELRYCRAFTING} ,
	[142173] = {0, CRAFTING_TYPE_JEWELRYCRAFTING} ,
	[147603] = {0, CRAFTING_TYPE_JEWELRYCRAFTING} ,
}
WritCreater.boxNames = {}
for boxId, boxRank in pairs (WritCreater.rewardBoxes) do 
	local name = GetItemLinkName(getItemLinkFromItemId(boxId))
	WritCreater.boxNames[name] = boxRank
end

local anniversaryBox = GetItemLinkName("|H1:item:183890:124:1:0:0:0:0:0:0:0:0:0:0:0:1:0:0:1:0:0:0|h|h") -- anniversary box/jubilee
anniversaryBox = string.gsub(anniversaryBox, "%(","%%%(")
anniversaryBox = string.gsub(anniversaryBox, "%)","%%%)")
WritCreater.boxNames[anniversaryBox] = {0, 0}