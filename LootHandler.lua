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


local function saveStats(loot, boxType, boxRank)
	local vars = WritCreater.savedVarsAccountWide -- shortcut
	local location = boxType

	vars = vars["rewards"][location]
	if vars["level"] > boxRank then -- If it's a higher level of writ, then wipe all the old saved data
		WritCreater.savedVarsAccountWide["total"] = WritCreater.savedVarsAccountWide["total"] - vars["num"]
		vars = WritCreater.defaultAccountWide["rewards"][location]
		vars["level"] = boxRank
	elseif vars["level"] == boxRank then -- otherwise, add one to total
		WritCreater.savedVarsAccountWide["total"] = WritCreater.savedVarsAccountWide["total"] + 1
		vars["num"] = vars["num"] + 1
	else
		WritCreater.savedVarsAccountWide["skipped"] = WritCreater.savedVarsAccountWide["skipped"] + 1
		return
	end

	WritCreater.savedVarsAccountWide["rewards"][location] = vars
end

-- Converts a roman nummeral from 1 to 10 into an integer
function romanNumeral(number)
	if number == "X" then
		return 10
	elseif number == "IX" then
		return 9
	elseif string.sub(number,1,1) == "V" then
		return 5 + romanNumeral(string.sub(number,2))
	elseif number == "IV" then
		return 4
	elseif number == "III" then
		return 3
	elseif number == "II" then
		return 2
	elseif number =="I" then
		return 1
	else 
		return 0
	end
end

function GetItemIDFromLink(itemLink) return tonumber(string.match(itemLink,"|H%d:item:(%d+)")) end

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
			updateSavedVars(vars, GetItemIDFromLink(itemLink), quantity)
			if GetItemLinkQuality(itemLink) == ITEM_QUALITY_LEGENDARY or GetItemIDFromLink(itemLink) ==135153 or GetItemIDFromLink(itemLink) == 135149 then
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
	if boxType == 9 then return false end

	return true
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
	local autoLoot 
	if WritCreater:GetSettings().ignoreAuto then
		autoLoot = WritCreater:GetSettings().autoLoot
	else
		autoLoot = GetSetting(SETTING_TYPE_LOOT,LOOT_SETTING_AUTO_LOOT) == "1"
	end
	if calledFromQuest then autoLoot = true end

	local lootInfo = {GetLootTargetInfo()}
	local writRewardNames = WritCreater.langWritRewardBoxes ()
	if not writRewardNames[9] then
		-- |H1:item:171779:124:1:0:0:0:0:0:0:0:0:0:0:0:1:0:0:1:0:0:0|h|h
		writRewardNames[9] = GetItemLinkName("|H1:item:183890:124:1:0:0:0:0:0:0:0:0:0:0:0:1:0:0:1:0:0:0|h|h") -- anniversary box/jubilee
		writRewardNames[9] = string.gsub(writRewardNames[9], "%(","%%%(")
		writRewardNames[9] = string.gsub(writRewardNames[9], "%)","%%%)")
	end
	if lootInfo[1] == "" and ((GetGameTimeMilliseconds() - cooldown) < 1000 )then
		-- zo_callLater(EndLooting, 100)
		return true
	end
	for i = 1, #writRewardNames  do
		local a, b = string.find(string.lower(lootInfo[1]), string.lower(writRewardNames[i]))
		if a then
			if i == 8 then 
				local itemType = GetItemLinkItemType(GetLootItemLink(GetLootItemInfo(1),1))
				if not (itemType == 36 or itemType == 38 or itemType == 40 or itemType ==64) then
					return false
				end
			elseif i == 9 then
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

			if shouldSaveStats(i,boxRank) and not fatiguedLoot[i] and i~= 9 then 
				LootAllHook(i,boxRank)
			else
				local loot = {}
				for j = 1, GetNumLootItems() do

					local lootId, name, _, quantity = GetLootItemInfo(j)
					local itemLink = GetLootItemLink(lootId, 0)
					local itemId = GetItemIDFromLink(itemLink)
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
			fatiguedLoot[i] = true
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
	if interact then
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
		updateSavedVars(vars, GetItemIDFromLink(itemLink), quantity)
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
	------
	-- REWARD HANDLING
	if isNew and WritCreater.langCraftKernels then --or GetDisplayName() == "@Dolgubon" then
		-- d(link.." "..tostring(isNew).." "..tostring(lootedItemLinks[link]))
	-- if WritCreater.langCraftKernels then --or GetDisplayName() == "@Dolgubon" then
		if lootedItemLinks[GetItemLinkItemId(link)] then
			-- d("Looted ".. link)
			if lootedItemLinks[GetItemLinkItemId(link)] == nil then
				-- d("Wasn't logged yet! "..link)
			else
				-- d("Was logged "..link)
			end
			lootedItemLinks[link] = false
			local itemType, specializedType = GetItemLinkItemType(link) 
			local itemName = GetItemLinkName(link)
			if itemType == ITEMTYPE_MASTER_WRIT or specializedType == SPECIALIZED_ITEMTYPE_TROPHY_SURVEY_REPORT then
				-- d("Passed first check")
				local craftType
				craftType = WritCreater.getWritAndSurveyType(link)
				if craftType == nil then
					-- d("Craft type nil?")
					return
				end
				local actionSource
				local action
				if itemType == ITEMTYPE_MASTER_WRIT then
					actionSource = WritCreater:GetSettings().rewardHandling["master"]
				elseif specializedType == SPECIALIZED_ITEMTYPE_TROPHY_SURVEY_REPORT then
					actionSource = WritCreater:GetSettings().rewardHandling["survey"]
				elseif specializedType == SPECIALIZED_ITEMTYPE_TOOL then
					actionSource = WritCreater:GetSettings().rewardHandling["repair"]
				end

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
				else
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