-----------------------------------------------------------------------------------
-- Addon Name: Dolgubon's Lazy Writ Crafter
-- Creator: Dolgubon (Joseph Heinzle)
-- Addon Ideal: Simplifies Crafting Writs as much as possible
-- Addon Creation Date: March 14, 2016
--
-- File Name: MasterWrits.lua
-- File Description: Crafts Master 
-- Load Order Requirements: None
-- 
-----------------------------------------------------------------------------------

local DolgubonDebugRunningDebugString = ""
local DolgubonGlobalDebugToggle = false
local localDebugToggle = false
-- Not real crafting types, but used to help differentiate different sealed writ types
local CRAFTING_TYPE_WITCHES = 100
local CRAFTING_TYPE_NEWLIFE = 200
local CRAFTING_TYPE_CHARITY = 300
local CRAFTING_TYPE_DEEPWINTER = 400
local CRAFTING_TYPE_IMPERIAL = 500
-- Debug function. Has the ability to save stuff and then later send it in a mail rather than outputting it in chat. Mail currently not enabled.

function DolgubonGlobalDebugOutput(...)
	if GetDisplayName()=="@Dolgubon" and (DolgubonGlobalDebugToggle or localDebugToggle) then
		d(...)
	else
		local t = {...}
		for i = 1, #t do
			local str = t[i]
			str = tostring(str)
			DolgubonDebugRunningDebugString = DolgubonDebugRunningDebugString.."\n"..str
			if string.len(DolgubonDebugRunningDebugString)>2100 then
				DolgubonDebugRunningDebugString = string.sub(DolgubonDebugRunningDebugString, string.len(DolgubonDebugRunningDebugString)-2099)
			end
		end
	end
end


local function dbug(...)
	DolgubonGlobalDebugOutput(...)
end

--SLASH_COMMANDS['/senddebug'] = sendDebug
--SLASH_COMMANDS['/sendebug']  = sendDebug
local trackedSealedWrits = {}

---------------------------------------------------
-- MASTER WRITS PROPER


local function EnchantingMasterWrit(itemId, levelId, quality, reference, name)
	local level
	if levelId == 207 then
		level = 150
	elseif levelId == 225 then
		level = 160
	else
		d("Couldn't match levelId "..levelId)
	end
	WritCreater.LLCInteractionMaster:cancelItemByReference(reference)
	WritCreater.LLCInteractionMaster:CraftEnchantingGlyphDesiredResult(true, level, itemId, quality, true, reference)
	local resultLink = LLC_GetEnchantingResultItemLinkByAttributes(true, level, itemId, quality)
	d(zo_strformat("<<t:1>>: Crafting <<t:2>>", name, resultLink))
end

local function calculateRequiredProvisioningAmount(needed, itemId)
	local _, recipeList, recipeIndex = GetRecipeInfoFromItemId(itemId)
	local resultAmount = GetRecipeResultQuantity(recipeList,recipeIndex)
	if resultAmount == 0 then return 0 end
	local timesToCraft = math.ceil(needed/resultAmount)
	local total = timesToCraft * resultAmount
	return timesToCraft, total
end

local function ProvisioningMasterWrit(resultItemId, quantity, reference, name)
	WritCreater.LLCInteractionMaster:cancelItemByReference(reference)
	local known = GetRecipeInfo(recipeList, recipeIndex)
	if not known then
		d(zo_strformat("<<t:1>>: Could not queue as you do not know the recipe for <<t:2>>", name, resultLink))
		return
	end
	WritCreater.LLCInteractionMaster:CraftProvisioningItemByResultItemId(resultItemId, quantity, true, reference)
	local _, recipeList, recipeIndex = GetRecipeInfoFromItemId(resultItemId)
	local resultAmount = GetRecipeResultQuantity(recipeList,recipeIndex)
	local amountToCreate = quantity*resultAmount
	local resultLink = getItemLinkFromItemId(resultItemId)
	d(zo_strformat("<<t:1>>: Crafting <<t:3>>x<<t:2>>", name, resultLink, amountToCreate))
end



--/script for 1, 25 do if GetJournalQuestName(i) == "A Masterful Weapon" then d(i, GetJournalQuestConditionInfo(i,1,1))  end end
--QuestID: 1

-- Called when the player receives a new quest. Determines if the quest is a master writ, and if so, which craft and if it is a weapon or armour or glyph.

local function queueMasterWrit(station, itemQuality, itemTemplateId, setIndex, itemTraitType, itemStyleId, name, reference)
	local patternIndex = WritCreater.LLCInteractionMaster.GetItemTemplateIdPatternIndex(itemTemplateId)
	WritCreater.LLCInteractionMaster:cancelItemByReference(reference)
	-- (setId, trait, pattern, station,level, isCP, quality,style,  potencyId, essenceId , aspectId)
	local expectedItemLink = WritCreater.LLCInteractionMaster.getItemLinkFromParticulars(setIndex, itemTraitType+1, patternIndex, station, 150, true, itemQuality, itemStyleId)
	-- if DoesItemLinkFulfillJournalQuestCondition(expectedItemLink, journalIndex, 1, 1, true) then
		-- Add to queue
	-- if not GetDisplayName()== "@Dolgubon" then
	-- d(patternIndex, true , 150, itemStyleId, itemTraitType+1, false, station, setIndex, itemQuality, true, reference)
	WritCreater.LLCInteractionMaster:cancelItemByReference(reference)
	local request = WritCreater.LLCInteractionMaster:CraftSmithingItemByLevel( patternIndex, true , 150, itemStyleId, itemTraitType+1, false, station, setIndex, itemQuality, true, reference)
	request.level = 150
	request.isCP = true
	-- end
	local traitName = GetString( _G["SI_ITEMTRAITTYPE"..itemTraitType] )
	local styleName =  GetItemStyleName(itemStyleId)
	local qualityName = GetString( _G["SI_ITEMQUALITY"..itemQuality] )
	d(WritCreater.strings.newMasterWritSmithToCraft(
		expectedItemLink,
		traitName,
		styleName,
		qualityName,
		name ))
	-- else
	-- 	d("Could not determine correct item to craft")
	-- end
end

local function improvedMasterWritQuest(journalIndex, questName)
	local _, current, required = GetJournalQuestConditionInfo(journalIndex)
	if current == required then
		return
	end
	local _, _, station, itemQuality, itemTemplateId, setIndex, itemTraitType, itemStyleId =  GetQuestConditionMasterWritInfo(journalIndex)
	queueMasterWrit(station, itemQuality, itemTemplateId, setIndex, itemTraitType, itemStyleId, questName, itemTemplateId)
end

local function improvedRightClick(link, station, uniqueId)
	------|H1:item:119680:5:1:0:0:0:52:188:4:208:16:120:0:0:0:0:0:0:0:0:58500|h|h
	--[[
	52 -> template ID
	188-> material id, useless?
	4 -> quality
	208 -> setindex
	16 -> traitindex
	120 -> Style index
	]]
	local x = { ZO_LinkHandler_ParseLink(link) }
	local itemTemplateId = tonumber(x[10])
	local itemQuality = tonumber(x[12])
	local setIndex = tonumber(x[13])
	local itemTraitType = tonumber(x[14])
	local itemStyleId = tonumber(x[15])
	local name = GetItemLinkName(link)
	queueMasterWrit(station, itemQuality, itemTemplateId, setIndex, itemTraitType, itemStyleId, name, link)
end

local function improvedEnchantRightClick(link, station, uniqueId)
	local x = { ZO_LinkHandler_ParseLink(link) }
	local quality = tonumber(x[12])
	local resultItemId = tonumber(x[10])
	local levelId = tonumber(x[11])
	local name = GetItemLinkName(link)
	EnchantingMasterWrit(resultItemId, levelId, quality, link, name)
end

local function improvedEnchantJournal(journalIndex, name)
	local _, current, required = GetJournalQuestConditionInfo(journalIndex)
	if current == required then
		return
	end
	local itemId, levelId, station, quality = GetQuestConditionMasterWritInfo(journalIndex, 1,1)
	EnchantingMasterWrit(itemId, levelId, quality, itemId, name)
end

local function provisioningJournal(journalIndex, name)
	local itemId = GetQuestConditionMasterWritInfo(journalIndex, 1,1)
	local _, current, required = GetJournalQuestConditionInfo(journalIndex)
	if current == required then
		return
	end
	local needed = required - current
	local _, recipeList, recipeIndex = GetRecipeInfoFromItemId(itemId)
	local factor = GetRecipeResultQuantity(recipeList,recipeIndex)
	if recipeList > 16 then
		factor = 1
	end
	local quantity = calculateRequiredProvisioningAmount(needed, itemId)
	if quantity > 0 then
		ProvisioningMasterWrit(itemId, quantity, itemId, name)
	else
		d(name..": Could not queue for writ. You might not know the required recipe")
	end
end

local function deepWinterQuantity(resultItemId)
	
	local _, recipeList, recipeIndex =  GetRecipeInfoFromItemId(resultItemId)
	local _,_,_,_, quality = GetRecipeResultItemInfo(recipeList, recipeIndex)
	if quality == ITEM_FUNCTIONAL_QUALITY_MAGIC then
		return calculateRequiredProvisioningAmount(1, resultItemId)
	elseif quality == ITEM_FUNCTIONAL_QUALITY_NORMAL then
		if resultItemId == 120410 or resultItemId == 117943 then
			return  calculateRequiredProvisioningAmount(3, resultItemId)
		end
		return  calculateRequiredProvisioningAmount(12, resultItemId)
	end
	return 0
end


local function provisioningRightClick(link, station, uniqueId)
	--d(GetQuestConditionMasterWritInfo(16,1,1))
	local x = { ZO_LinkHandler_ParseLink(link) }
	local resultItemId = tonumber(x[10])
	local _, recipeList, recipeIndex =  GetRecipeInfoFromItemId(resultItemId)
	if not recipeList then return end
	local name = GetItemLinkName(link)
	local quantity = 2
	-- quantites according to uesp for holiday writs
	if station == CRAFTING_TYPE_WITCHES then
		quantity = calculateRequiredProvisioningAmount(4, resultItemId)
	end
	if station == CRAFTING_TYPE_NEWLIFE then
		local _,_,_,_, quality = GetRecipeResultItemInfo(recipeList, recipeIndex)
		if quality == ITEM_FUNCTIONAL_QUALITY_MAGIC then
			quantity = calculateRequiredProvisioningAmount(1, resultItemId)
		elseif quality == ITEM_FUNCTIONAL_QUALITY_NORMAL then
			quantity = calculateRequiredProvisioningAmount(12, resultItemId)
		else
			quantity = 0 -- handled at the end of this func
		end
	end
	if station == CRAFTING_TYPE_DEEPWINTER then
		quantity = deepWinterQuantity(resultItemId)
	end
	if station == CRAFTING_TYPE_IMPERIAL then
		quantity = 0
		local _,_,_,_, quality = GetRecipeResultItemInfo(recipeList, recipeIndex)
		if quality == ITEM_FUNCTIONAL_QUALITY_NORMAL then
			quantity = calculateRequiredProvisioningAmount(3, resultItemId)
		elseif quality == ITEM_FUNCTIONAL_QUALITY_MAGIC then
			if recipeList <17 then -- food
				quantity = calculateRequiredProvisioningAmount(12, resultItemId)
			else
				quantity = calculateRequiredProvisioningAmount(1, resultItemId)
			end
		end
	end
	if quantity == 0 then
		d("Could not determine how many items to craft. Try accepting the writ.")
		return
	end
	ProvisioningMasterWrit(resultItemId, quantity, link, name)
end



function WritCreater.MasterWritsQuestAdded(event, journalIndex,name)
	if not WritCreater.savedVarsAccountWide.masterWrits then return end

	local itemId, _, writType = GetQuestConditionMasterWritInfo(journalIndex, 1 , 1)
	local _, recipeList, recipeIndex = GetRecipeInfoFromItemId(itemId)
	if recipeList and recipeIndex then
		provisioningJournal(journalIndex, name)
		return
	end
	if writType == CRAFTING_TYPE_ENCHANTING then
		improvedEnchantJournal(journalIndex, name)
		return 
	elseif writType == CRAFTING_TYPE_ALCHEMY then
	elseif writType == CRAFTING_TYPE_PROVISIONING then
		provisioningJournal(journalIndex, name)
	elseif writType and writType >0 then
		improvedMasterWritQuest(journalIndex, name)
		return
	end
end

local function QuestCounterChanged(event, journalIndex, questName, _, _, currConditionVal, newConditionVal, conditionMax)
	dbug("EVENT:Quest Counter Change")
	if not WritCreater.LLCInteractionMaster then return end
	if not journalIndex then return end
	if #WritCreater.LLCInteractionMaster:findItemByReference(journalIndex) == 0 then
		WritCreater.LLCInteractionMaster:cancelItemByReference(journalIndex)
		if newConditionVal and conditionMax and newConditionVal<conditionMax then
			WritCreater.MasterWritsQuestAdded(event, journalIndex, questName)
		end
	end
end

local function QuestRemoved(event, completed, journalIndex)
	WritCreater.LLCInteractionMaster:cancelItemByReference(journalIndex)
end

--EVENT_QUEST_ADDED found in AlchGrab File
EVENT_MANAGER:RegisterForEvent(WritCreater.name,EVENT_QUEST_CONDITION_COUNTER_CHANGED , QuestCounterChanged)
EVENT_MANAGER:RegisterForEvent(WritCreater.name,EVENT_QUEST_REMOVED , QuestRemoved)
-- EVENT_MANAGER:RegisterForEvent(WritCreater.name,EVENT_QUEST_COMPLETE , QuestCounterChanged)



function WritCreater.scanAllQuests()
	if not WritCreater.LLCInteractionMaster then return end
	WritCreater.LLCInteractionMaster:cancelItem()
	dbug("FUNCTION:scanAllQuests")
	for i = 1, 25 do WritCreater.MasterWritsQuestAdded(1, i,GetJournalQuestName(i)) end
end
local exampleSealedWrits = {
    [GetItemLinkName("|H1:item:121532:6:1:0:0:0:26:194:5:178:15:34:0:0:0:0:0:0:0:0:883200|h|h")] = CRAFTING_TYPE_CLOTHIER,
    [GetItemLinkName("|H1:item:119680:6:1:0:0:0:47:188:4:240:12:29:0:0:0:0:0:0:0:0:56375|h|h")] = CRAFTING_TYPE_BLACKSMITHING,
    [GetItemLinkName("|H1:item:119682:6:1:0:0:0:65:192:4:95:14:47:0:0:0:0:0:0:0:0:63250|h|h")] = CRAFTING_TYPE_WOODWORKING,
    [GetItemLinkName("|H1:item:119564:5:1:0:0:0:26581:207:4:0:0:0:0:0:0:0:0:0:0:0:20000|h|h")] = CRAFTING_TYPE_ENCHANTING,
    [GetItemLinkName("|H1:item:119693:5:1:0:0:0:68276:0:0:0:0:0:0:0:0:0:0:0:0:0:20000|h|h")] = CRAFTING_TYPE_PROVISIONING,
    -- [GetItemLinkName("|H1:item:119705:5:1:0:0:0:199:19:3:15:0:0:0:0:0:0:0:0:0:0:50000|h|h")] = CRAFTING_TYPE_ALCHEMY,
    [GetItemLinkName("|H1:item:153737:5:1:0:0:0:18:255:4:439:33:0:0:0:0:0:0:0:0:0:346500|h|h")] = CRAFTING_TYPE_JEWELRYCRAFTING,
    [GetItemLinkName("|H1:item:153482:4:1:0:0:0:87691:0:0:0:0:0:0:0:0:0:0:0:0:0:10000|h|h")] = CRAFTING_TYPE_WITCHES,
    [GetItemLinkName("|H1:item:145572:4:1:0:0:0:118012:0:0:0:0:0:0:0:0:0:0:0:0:0:10000|h|h")] = CRAFTING_TYPE_NEWLIFE,
    [GetItemLinkName("|H1:item:156735:4:1:0:0:0:117954:0:0:0:0:0:0:0:0:0:0:0:0:0:10000|h|h")] = CRAFTING_TYPE_DEEPWINTER,
    [GetItemLinkName("|H1:item:167172:5:1:0:0:0:117963:0:0:0:0:0:0:0:0:0:0:0:0:0:10000|h|h")] = CRAFTING_TYPE_IMPERIAL,
    


    
}
WritCreater.sealedWritNames = exampleSealedWrits

local function itemHandler(bag, slot, station)
	if not station then
		return
	end
	if station == CRAFTING_TYPE_ENCHANTING then
		local link = GetItemLink(bag, slot)
		improvedEnchantRightClick(link, station)
		return
	elseif station == CRAFTING_TYPE_ALCHEMY then
	elseif station == CRAFTING_TYPE_PROVISIONING or station == CRAFTING_TYPE_WITCHES or station == CRAFTING_TYPE_NEWLIFE or station == CRAFTING_TYPE_DEEPWINTER or station == CRAFTING_TYPE_IMPERIAL then
		provisioningRightClick(GetItemLink(bag, slot), station)
	elseif station and station >0 and station <8 then
		improvedRightClick(GetItemLink(bag, slot), station)
	else
		return
	end
    trackedSealedWrits[#trackedSealedWrits + 1] = {bag, slot, GetItemUniqueId(bag, slot)}
end

local function canCraftSealedWrit(link)
	local station = exampleSealedWrits[GetItemLinkName(link)]
	if not station then return false end
	if station == CRAFTING_TYPE_WITCHES then
		local x = { ZO_LinkHandler_ParseLink(link) }
		local resultItemId = tonumber(x[10])
		if not GetRecipeInfoFromItemId(resultItemId) then return false end
	end
	return true, station
end


function WritCreater.InventorySlot_ShowContextMenu(rowControl,debugslot)
	local bag, slot, link, flavour, reference
	if type(rowControl)=="userdata" or type(rowControl)=="number" then 
		if type(rowControl)=="userdata" then
	    	bag, slot = ZO_Inventory_GetBagAndIndex(rowControl)
	    else
	    	bag , slot = rowControl, debugslot
	    end
	    link = GetItemLink(bag, slot)
	    flavour = GetItemLinkFlavorText(link)
	    if GetItemType(bag, slot)~=ITEMTYPE_MASTER_WRIT then return end
	elseif type(rowControl)=="string" then
		--Note: This is a debug ability mainly. It allows you to call the function with just a link from some random place and craft it.
		link = rowControl
	    flavour = GetItemLinkFlavorText(rowControl)
	    reference = "Test"
	end
	
    
	-- enchanting glyph then writ
	--|H1:item:26581:311:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h
	--|H1:item:119564:5:1:0:0:0:26581:207:4:0:0:0:0:0:0:0:0:0:0:0:20000|h|h
	--|H1:item:119693:5:1:0:0:0:68276:0:0:0:0:0:0:0:0:0:0:0:0:0:20000|h|h
	local canCraft, station = canCraftSealedWrit(link)
	if not canCraft or not station then return end
	--|H1:item:119680:5:1:0:0:0:52:188:4:208:16:120:0:0:0:0:0:0:0:0:58500|h|h
	--|H1:item:153737:5:1:0:0:0:18:255:4:439:33:0:0:0:0:0:0:0:0:0:346500|h|h
    -- Check if you can find "Blacksmithing, Clothing Woodworking or Enchanting"
    -- Search for if it is armour or not
    if not LibCustomMenu or not LibCustomMenu.RegisterIgnoreListContextMenu then return end
    zo_callLater(function ()
        AddCustomMenuItem("Craft Sealed Writ", function ()
			itemHandler(bag, slot, station)
        end, MENU_ADD_OPTION_LABEL)
        ShowMenu(self)
    end, 0)
end
--alchemyu writs
-- |H1:item:119705:5:1:0:0:0:199:19:3:15:0:0:0:0:0:0:0:0:0:0:50000|h|h
-- |H1:item:119702:5:1:0:0:0:199:28:2:6:0:0:0:0:0:0:0:0:0:0:50000|h|h
-- potions
-- |H1:item:54339:308:50:0:0:0:0:0:0:0:0:0:0:0:0:36:0:0:0:0:72960|h|he
-- |H1:item:30145:308:50:0:0:0:0:0:0:0:0:0:0:0:0:36:0:0:0:0:754432|h|h

-- provsiionign
--|H1:item:119693:5:1:0:0:0:68276:0:0:0:0:0:0:0:0:0:0:0:0:0:20000|h|h

local myButtonGroup = {
{
	name = "Craft Writ",
	keybind = "UI_SHORTCUT_QUATERNARY",
	callback = function(input, input2)
	itemHandler(bag, slot, station)
	end,
}}

local function removeCraftKeybind()
	KEYBIND_STRIP:RemoveKeybindButtonGroup(myButtonGroup)
	myButtonGroup.callback = function() end
end


local function gamepadInventoryHook(inventoryInfo, slotActions)
	if not IsInGamepadPreferredMode() and not IsConsoleUI() then
		return
	end
	if not inventoryInfo or not inventoryInfo.dataSource then
		return
	end
	local bag = inventoryInfo.dataSource.bagId
	local slot = inventoryInfo.dataSource.slotIndex
	local link = GetItemLink(bag, slot)
	local canCraft, station = canCraftSealedWrit(link)
	if not canCraft or not station then return end

	slotActions:AddSlotAction(SI_CRAFT_SEALED_WRIT, function()itemHandler(bag, slot, station) end , "keybind3")
	-- There is definitely a better way to do this
	-- But I've spent too long trying to figure one out so I'll stick with this
	zo_callLater(function()
	 myButtonGroup = {
	{
		name = "Craft Writ",
		keybind = "UI_SHORTCUT_QUATERNARY",
		callback = function(input, input2)
		itemHandler(bag, slot, station)
		end,
	}}
	KEYBIND_STRIP:AddKeybindButtonGroup(myButtonGroup) end, 10)
end

SCENE_MANAGER:RegisterCallback("SceneStateChanged", function(scene, newState)
	if not IsInGamepadPreferredMode() then return end

	local sceneName = scene:GetName()
	if (newState == SCENE_SHOWING) and sceneName ~= "gamepad_inventory_root" then
			removeCraftKeybind()
		-- end
	end
	 end)

function WritCreater.InitializeRightClick()
	if IsConsoleUI() or IsInGamepadPreferredMode() then
		SecurePostHook(_G, "ZO_InventorySlot_DiscoverSlotActionsFromActionList", gamepadInventoryHook)
	end
	if not IsConsoleUI() then
		-- zo_callLater(function()
		-- SecurePostHook('ZO_InventorySlot_ShowContextMenu', function (rowControl)d("My hook") WritCreater.InventorySlot_ShowContextMenu(rowControl) end)end, 1000)
		 -- SecurePostHook('ZO_InventorySlot_ShowContextMenu', function (rowControl)d("My hook") WritCreater.InventorySlot_ShowContextMenu(rowControl) end)
	end
end

function WritCreater.queueAllSealedWrits(bag)
	WritCreater.LLCInteractionMaster:cancelItem()
	for i = 0, GetBagSize(bag) do
		local itemType, specializedType = GetItemType(bag, i)
		if itemType == ITEMTYPE_MASTER_WRIT then
			local name = GetItemName(bag, i)
			local stationType = exampleSealedWrits[name]
			if stationType and not IsItemJunk(bag, i) then
				itemHandler(bag, i, stationType)
			end
		end

	end
end

--]]
function WritCreater.checkIfMasterWritWasStarted(...)
	dbug("EVENT:SlotUpdated")
end
if not IsConsoleUI() then
	ZO_PreHook('ZO_InventorySlot_ShowContextMenu', function (rowControl) WritCreater.InventorySlot_ShowContextMenu(rowControl) end)
end



-- |H1:item:119681:6:1:0:0:0:72:192:4:207:2:29:0:0:0:0:0:0:0:0:57750|h|h 
-- |H1:item:121528:6:1:0:0:0:26581:225:5:0:0:0:0:0:0:0:0:0:0:0:66000|h|h
-- Ruby Ash Shield Epic Divines Night's Silence, Dwemer
-- |H1:item:119682:6:1:0:0:0:65:192:4:40:18:14:0:0:0:0:0:0:0:0:52250|h|h
-- Ruby Ash Healing, Epic, Precise, Kagrenacs, Soul Shriven
-- |H1:item:119681:6:1:0:0:0:71:192:4:92:3:30:0:0:0:0:0:0:0:0:60500|h|h
-- Ruby Ash Frost, Epic, Decisive, Song of Lamae, Dwemer
-- |H1:item:119681:6:1:0:0:0:73:192:4:81:8:14:0:0:0:0:0:0:0:0:56375|h|h
-- Rubedite Greataxe, Epic, Defending, Twice Born Star, Xivkyn
-- |H1:item:119563:6:1:0:0:0:68:188:4:161:5:29:0:0:0:0:0:0:0:0:66000|h|h

