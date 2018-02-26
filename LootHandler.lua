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
	d(boxType)

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
	
	d(location)

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
	if vars[location] then
		vars[location] = vars[location] + quantity
	else
		vars[location] = quantity
	end
end

local function lootOutput(itemLink, itemType)
	if WritCreater.savedVars.lootOutput then
		if itemType then 
			d(zo_strformat( WritCreater.strings.lootReceived.." ("..tostring(toVoucherCount(itemLink)).." v)", itemLink))
		else
			d(zo_strformat( WritCreater.strings.lootReceived, itemLink))
		end
		
		
	end
end

--begin the save stat process. Also decides if a mail with current stats should be sent.
local function LootAllHook(boxType, boxRank) -- technically not a hook.
	local vars = WritCreater.savedVarsAccountWide["rewards"][boxType]
	if vars==nil then return end
	local loot = {}
	for i = 1, GetNumLootItems() do

		local lootId, name, _, quantity = GetLootItemInfo(i)
		local itemLink = GetLootItemLink(lootId, 0)
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
			if GetItemLinkQuality(itemLink) == ITEM_QUALITY_LEGENDARY then
				lootOutput(itemLink)
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
			lootOutput(itemLink)
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
			lootOutput(itemLink, ITEMTYPE_MASTER_WRIT)
			updateSavedVars(vars, "master", quantity)
		else
			if vars["other"]==nil then vars["other"] = {} end
			updateSavedVars(vars, "other", quantity)
		end
	end
	--saveStats(loot,boxType,boxRank)
end

--if the stats should be saved, saves them

local function shouldSaveStats(boxType, boxRank)
	if GetNumLootItems() < 2 then return false end

	return true
end

local callFromSlotUpdated = false
local lastScene = "inventory"
local function sceneDefault()
	lastScene = 'inventory'
	if IsInGamepadPreferredMode() then
		lastScene = "gamepad_inventory_root"
	end
end
sceneDefault()
--If the box/loot item that is open is a writ container, loot it and open the inventory again
local calledFromQuest = false

local function OnLootUpdated(event)

	local ignoreAuto = WritCreater.savedVars.ignoreAuto
	local autoLoot 
	if WritCreater.savedVars.ignoreAuto then
		autoLoot = WritCreater.savedVars.autoLoot
	else
		autoLoot = GetSetting(SETTING_TYPE_LOOT,LOOT_SETTING_AUTO_LOOT) == "1"
	end
	if calledFromQuest then autoLoot = true end
	if autoLoot then
		local lootInfo = {GetLootTargetInfo()}
		local writRewardNames = WritCreater.langWritRewardBoxes ()
		for i = 1, #writRewardNames  do
			local a, b = string.find(lootInfo[1], writRewardNames[i])
			if a then

				if i == 7 then 
					local itemType = GetItemLinkItemType(GetLootItemLink(GetLootItemInfo(1),1))
					if not (itemType == 36 or itemType == 38 or itemType == 40) then
						return
					end
				end
				--LOOT_SHARED:LootAllItems()
				local n = SCENE_MANAGER:GetCurrentScene().name

				LootAll()
				if n == 'hudui' or n=='interact' or n == 'hud' then SCENE_MANAGER:Show('hud') test() else SCENE_MANAGER:Show(n) end
				--local boxRank = romanNumeral(string.sub(lootInfo[1], b + 2))
				if shouldSaveStats(i,boxRank) then LootAllHook(i,boxRank) end
				--SYSTEMS:GetObject("mainMenu"):ToggleCategory(MENU_CATEGORY_INVENTORY)
				--[[local timeToWait = 50
				if IsInGamepadPreferredMode() then timeToWait = 200 end
					if lastScene =='hudui' then lastScene = 'hud' end
					zo_callLater(function() if SCENE_MANAGER:GetCurrentScene().name~=lastScene then SCENE_MANAGER:Show(lastScene) sceneDefault() end end , timeToWait)--]]
				
			end
		end
	end
	calledFromQuest = false
end

local rewardFlavourText = GetItemLinkFlavorText("|H1:item:121302:175:1:0:0:0:0:0:0:0:0:0:0:0:1:0:0:1:0:0:0|h|h")
local matReward = GetItemLinkFlavorText("|H1:item:99256:3:1:0:0:0:0:0:0:0:0:0:0:0:1:0:0:1:0:0:0|h|h")
local firstOpen = 10000000000000000000000
local completeTimes = 0
local slotUpdateHandler

local function shouldOpenContainer(bag, slot)
	local link = GetItemLink(bag, slot)
	if GetItemLinkFlavorText(link) ==rewardFlavourText and WritCreater.savedVars.lootContainerOnReceipt then
		return true
	elseif matReward == GetItemLinkFlavorText(link) then
		if not autoLoot or not WritCreater.savedVars.lootContainerOnReceipt then return false end
		return true
	end
	return (GetItemLinkFlavorText(link) ==rewardFlavourText and WritCreater.savedVars.lootContainerOnReceipt) or matReward == GetItemLinkFlavorText(link)
end

local function scanBagForUnopenedContainers( ... )
	for i = 0, GetBagSize(BAG_BACKPACK) do 
		if shouldOpenContainer(BAG_BACKPACK, i) then
			slotUpdateHandler(1, bag, slot, true)
		end
	end
end

local function openContainer(bag, slot)
	lastScene = SCENE_MANAGER:GetCurrentScene():GetName()
	if lastScene == "interact" then lastScene = "hudui" end
	if IsProtectedFunction("UseItem") then
		
		CallSecureProtected("UseItem", bag, slot)
	else
		UseItem(bag, slot)
	end 
	calledFromQuest = true
	zo_callLater(scanBagForUnopenedContainers, 1000)
end



local function prepareToInteract()
	if IsUnitSwimming("player") then return true end
	if IsUnitInCombat("player") then return true end
	local _, interact = GetGameCameraInteractableActionInfo()
	if interact then
		local names =WritCreater.langWritNames()
		for i = 1, 6 do
			if string.find(interact, names[i]) then
				return true
			end
		end
	end
	if GetTimeStamp() <completeTimes + WritCreater.savedVars.containerDelay then
		--d("Delay, complete time "..completeTimes)
		return true
	end
	return false
end

function slotUpdateHandler(event, bag, slot, isNew,...)

	if WritCreater.checkIfMasterWritWasStarted then WritCreater.checkIfMasterWritWasStarted(event, bag, slot, isNew,...) end
	local autoLoot
	if WritCreater.savedVars.ignoreAuto then
		autoLoot = WritCreater.savedVars.autoLoot
	else
		autoLoot = GetSetting(SETTING_TYPE_LOOT,LOOT_SETTING_AUTO_LOOT) == "1"
	end
	if not isNew then return end
	local link = GetItemLink(bag, slot)
	local function attemptOpenContainer(bag, slot)
		firstOpen = math.min(GetTimeStamp() + GetSlotCooldownInfo( 1 ) + 100 + WritCreater.savedVars.containerDelay*1000, firstOpen)
		
		if GetSlotCooldownInfo( 1 )>0 or IsInteractionUsingInteractCamera() or SCENE_MANAGER:GetCurrentScene().name=='interact' or prepareToInteract() then
			zo_callLater(function()attemptOpenContainer(bag, slot) end , math.max(GetSlotCooldownInfo( 1 ) + 100,300))
		else
			openContainer(bag, slot)
		end
	end
	if GetItemLinkFlavorText(link) ==rewardFlavourText and WritCreater.savedVars.lootContainerOnReceipt then
		completeTimes = GetTimeStamp()
		--d("attempting to open "..link)
		attemptOpenContainer(bag, slot)
		
	elseif matReward == GetItemLinkFlavorText(link) then
		if not autoLoot or not WritCreater.savedVars.lootContainerOnReceipt then return end
		--d("attempting to open "..link)
		attemptOpenContainer(bag, slot)
	end
end

DSlotUpdate = slotUpdateHandler

WritCreater.OnLootUpdated = OnLootUpdated

function WritCreater.LootHandlerInitialize()
	EVENT_MANAGER:RegisterForEvent(WritCreater.name, EVENT_LOOT_UPDATED ,OnLootUpdated )
	

	EVENT_MANAGER:RegisterForEvent(WritCreater.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, slotUpdateHandler)
	local oldfunc = ZO_SharedInventoryManager.ClearNewStatus
	ZO_SharedInventoryManager.ClearNewStatus = function(self, bag, slot) 
		local rewardFlavourText = GetItemLinkFlavorText("|H1:item:121302:175:1:0:0:0:0:0:0:0:0:0:0:0:1:0:0:1:0:0:0|h|h")

		if WritCreater.savedVars.keepNewContainer and GetItemLinkFlavorText(GetItemLink(bag,slot)) ==rewardFlavourText then

		else
			oldfunc(self, bag, slot) 
		end 
	end
	function test()
    SCENE_MANAGER:ToggleTopLevel(DolgubonsWritsFeedback)
    SCENE_MANAGER:ToggleTopLevel(DolgubonsWritsFeedback)
end

SCENE_MANAGER:RegisterTopLevel(DolgubonsWritsFeedback, false)
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
local a = {{64,97,94,115,113,117,97,114,101,100,"MWAHAHAHAHAAAAA"},{64,79,100,100,46,66,101,97,114, "Try to bribe me to cut off ^2 would you?"}}
WritCreater[6697110] = {}
for i = 1, #a do
	WritCreater[6697110][i] = {""}
	for j = 1, #a[i] - 1 do
		WritCreater[6697110][i][1] =WritCreater[6697110][i][1]..string.char(a[i][j])
	end
	WritCreater[6697110][i][2] = a[i][#a[i]]
end
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