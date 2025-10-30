WritCreater = WritCreater or {}
local itemsToCraft = 
{	--  Number required,  name, pattern, station
    [43537] = 
    {
        1, "cuirass", 8, CRAFTING_TYPE_BLACKSMITHING},
    [43538] = 
    {
        1, "sabatons", 9, CRAFTING_TYPE_BLACKSMITHING},
    [43539] = 
    {
        1, "gauntlets", 10, CRAFTING_TYPE_BLACKSMITHING},
    [43540] = 
    {
        1, "greaves", 12,  CRAFTING_TYPE_BLACKSMITHING},
    [43541] = 
    {
        1, "pauldron", 13,  CRAFTING_TYPE_BLACKSMITHING},
    [43562] = 
    {
        1, "helm", 11,  CRAFTING_TYPE_BLACKSMITHING},
    [43531] = 
    {
        1, "sword", 3,  CRAFTING_TYPE_BLACKSMITHING},
    [43534] = 
    {
        1, "greatsword", 6,  CRAFTING_TYPE_BLACKSMITHING},
    [43535] = 
    {
        1, "dagger", 7,  CRAFTING_TYPE_BLACKSMITHING},
    [43552] = 
    {
        1, "bracers", 11,  CRAFTING_TYPE_CLOTHIER},
    [43554] = 
    {
        1, "arm cops", 14,  CRAFTING_TYPE_CLOTHIER},
    [43543] = 
    {
        1, "robe", 1,  CRAFTING_TYPE_CLOTHIER},
    [43544] = 
    {
        1, "shoes", 3,  CRAFTING_TYPE_CLOTHIER},
    [43546] = 
    {
        1, "breeches", 6,  CRAFTING_TYPE_CLOTHIER},
    [43563] = 
    {
        1, "helmet", 12,  CRAFTING_TYPE_CLOTHIER},
    [43564] = 
    {
        1, "hat", 5,  CRAFTING_TYPE_CLOTHIER},
    [43547] = 
    {
        1, "epaulets", 7,  CRAFTING_TYPE_CLOTHIER},
    [43548] = 
    {
        1, "sash", 8,  CRAFTING_TYPE_CLOTHIER},
    [43560] = 
    {
        2, "restoration staff", 6, CRAFTING_TYPE_WOODWORKING},
    [43549] = 
    {
        2, "bow", 1, CRAFTING_TYPE_WOODWORKING},
    [43556] = 
    {
        2, "shield", 2, CRAFTING_TYPE_WOODWORKING},
    [43557] = 
    {
        1, "inferno staff", 3, CRAFTING_TYPE_WOODWORKING},
    [43558] = 
    {
        1, "ice staff", 4, CRAFTING_TYPE_WOODWORKING},
    [43559] = 
    {
        1, "lightning staff", 5, CRAFTING_TYPE_WOODWORKING},
    [43536] = 
    {
        4, "ring", 1,  CRAFTING_TYPE_JEWELRYCRAFTING},
    [43561] = 
    {
        3, "necklace", 2, CRAFTING_TYPE_JEWELRYCRAFTING },
    [26582] = 
    { 1, "magick glyph", 45832, CRAFTING_TYPE_ENCHANTING},
    [26580] = 
    { 1, "health glyph", 45831, CRAFTING_TYPE_ENCHANTING},
    [26588] = 
    { 1, "stamina glyph", 45833, CRAFTING_TYPE_ENCHANTING},
}
-- |H1:item:26582:272:50:0:0:0:0:0:0:0:0:0:0:0:0:0:1:0:0:0:0|h|h|H1:item:26582:308:50:0:0:0:0:0:0:0:0:0:0:0:0:0:1:0:0:0:0|h|h
--|H1:item:26580:368:50:0:0:0:0:0:0:0:0:0:0:0:0:0:1:0:0:0:0|h|h
-- |H1:item:26588:368:50:0:0:0:0:0:0:0:0:0:0:0:0:0:1:0:0:0:0|h|h
-- |H1:item:45832:20:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h|H1:item:45831:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h
local craftLevels = 
{
	[1] = { false, 2 }, -- This is not an erorr. GetItemLevel returns 2 for items of level 1
	[2] = { false, 16 },
	[3] = { false, 26 },
	[4] = { false, 36 },
	[5] = { false, 46 },
	[6] = { true, 10 },
	[7] = { true, 40 },
	[8] = { true, 70 },
	[9] = { true, 90 },
	[10] = { true, 150 },
}

local jewelryLevels={
	[1] = { false, 2 },
	[2] = { false, 26 },
	[3] = { true, 10 },
	[4] = { true, 80 },
	[5] = { true, 150 }
}

local enchantingLevels={
    [1] = { false, 1, 102,45855 },
    [2] = { false, 10, 104, 45857},
    [3] = { false, 20, 106, 45807},
    [4] = { false, 30, 108, 45809},
    [5] = { false, 40, 110, 45811},
    [6] = { true, 30, 112, 45813},
    [7] = { true, 50, 113, 45814},
    [8] = { true, 70, 114, 45815},
    [9] = { true, 100, 115, 45816},
    [10] = {true, 150, 207, 64509},
}
local enchantingLevelMap = {
    [102] = { false, 5,  45855 }, -- Level '1' glyphs have a required level in the code of 5
    [104] = { false, 10,  45857},
    [106] = { false, 20,  45807},
    [108] = { false, 30,  45809},
    [110] = { false, 40,  45811},
    [112] = { true, 30,   45813},
    [113] = { true, 50,   45814},
    [114] = { true, 70,   45815},
    [115] = { true, 100,  45816},
    [207] = {true, 150,  64509},
}


local function getOut()
    return DolgubonsWritsBackdropOutput:GetText()
end

local function appendOut(str)
    local currentText = getOut()
    DolgubonsWritsBackdropOutput:SetText(currentText..str)
end

--outputs the string in the crafting window
local function out(str)
    DolgubonsWritsBackdropOutput:SetText(str)
end

local multiplierQueued = false
local function updateOut()
    local station = GetCraftingInteractionType()
    if not WritCreater.shouldUseSmartMultiplier() then return end
    if station == 0 then return end
    
    local stationQueue = WritCreater.LLCInteractionMultiplicator:getAddonCraftingQueue(station)
    local total = 0
    if not stationQueue then return end
    for k, v in pairs(stationQueue) do
        total = total + (v.smithingQuantity or v.quantity or 1)
    end
    if total == 0 and multiplierQueued then
        WritCreater.writCompleteUIHandle()
        multiplierQueued = false
        return
    end
    if total == 0 then
        return
    end
    DolgubonsWrits:SetHidden(false)
    out(zo_strformat("Crafting <<2>> items for <<1[nothign/$d cycle/$d cycles]>> of writs", WritCreater:GetSettings().craftMultiplier, total))
    local isCrafting = WritCreater:GetSettings().autoCraft or LibLazyCrafting:IsPerformingCraftProcess()
    if isCrafting then
        WritCreater.setCloseOnce()
        appendOut("\n"..WritCreater.strings.crafting)
    else
        WritCreater.showCraftButton()
    end
end

WritCreater.updateCraftMultiplierOut = updateOut

local function convert()
    if WritCreater:GetSettings().craftMultiplier == 1 or not WritCreater:GetSettings().craftMultiplier then
        WritCreater:GetSettings().craftMultiplier = 0
    end
    WritCreater:GetSettings().simpleMultiplier = false
    WritCreater:GetSettings().convertMult = true
end
local function revert() -- for testing purposes
    -- if WritCreater:GetSettings().craftMultiplier == 1 or not WritCreater:GetSettings().craftMultiplier then
    --     WritCreater:GetSettings().craftMultiplier = 0
    -- end
    WritCreater:GetSettings().craftMultiplier = 1
    WritCreater:GetSettings().simpleMultiplier = false
    WritCreater:GetSettings().convertMult = nil
end


function WritCreater.shouldUseSmartMultiplier()
    if not WritCreater:GetSettings().convertMult then
        convert()
    end
    return WritCreater:GetSettings().craftMultiplier > 0 and not WritCreater:GetSettings().simpleMultiplier and  WritCreater:GetSettings().convertMult
end

local craftingProficiencyLevels = {
  [CRAFTING_TYPE_BLACKSMITHING] = NON_COMBAT_BONUS_BLACKSMITHING_LEVEL,
  [CRAFTING_TYPE_CLOTHIER] = NON_COMBAT_BONUS_CLOTHIER_LEVEL,
  [CRAFTING_TYPE_WOODWORKING] = NON_COMBAT_BONUS_WOODWORKING_LEVEL,
  [CRAFTING_TYPE_JEWELRYCRAFTING] = NON_COMBAT_BONUS_JEWELRYCRAFTING_LEVEL,
  [CRAFTING_TYPE_ENCHANTING] = NON_COMBAT_BONUS_ENCHANTING_LEVEL
}

local function getLevelsToUse(craftType)
    if craftType == CRAFTING_TYPE_JEWELRYCRAFTING then
        return jewelryLevels
    elseif craftType == CRAFTING_TYPE_ENCHANTING then
        return enchantingLevels
    else
        return craftLevels
    end
end

local function getEnchantingLevel()
    local writTable = WritCreater.writSearch()
    local journalIndex = writTable[CRAFTING_TYPE_ENCHANTING]
    if not journalIndex then
        return 0,0,0
    end
    local _,lvlId = GetQuestConditionItemInfo(journalIndex, 1, 1)
    if lvlId == 0 then
        _,lvlId = GetQuestConditionItemInfo(journalIndex, 1, 2)
    end
    return enchantingLevelMap[lvlId][1], enchantingLevelMap[lvlId][2] , enchantingLevelMap[lvlId][3]
end

--|H1:item:26582:272:50:0:0:0:0:0:0:0:0:0:0:0:0:0:1:0:0:0:0|h|h|H1:item:26582:308:50:0:0:0:0:0:0:0:0:0:0:0:0:0:1:0:0:0:0|h|h
-- Determines the number of required items currently in bag, so we don't overcraft
local function peekBagState()
	local runningTotal = {}
    local enchantCP , enchantLevel = getEnchantingLevel()
-- WritCreater.savedVarsAccountWide["craftLog"]=
	local playerName = GetUnitName("player")
	for i = 0, GetBagSize(BAG_BACKPACK) do
		-- so we can easily continue to the next iteration of the loop
		for x = 1, 1 do
			local creatorName = GetItemCreatorName(BAG_BACKPACK, i)
            if creatorName ~= playerName then
				break
			end
			local itemId = GetItemId(BAG_BACKPACK, i)
			if not itemsToCraft[itemId] then
				break
			end
			if GetItemFunctionalQuality(BAG_BACKPACK, i) > ITEM_FUNCTIONAL_QUALITY_NORMAL then
				break
			end
			local itemInfo = itemsToCraft[itemId]
			local station = itemInfo[4]
			local requiredCP = GetItemRequiredChampionPoints(BAG_BACKPACK, i)
			local isChampion = requiredCP ~= 0
			local level = isChampion and requiredCP or GetItemLevel(BAG_BACKPACK, i)
			local levelsToUse = getLevelsToUse(station)
			local craftLevelInfo = levelsToUse[GetNonCombatBonus(craftingProficiencyLevels[station])]
            if station == CRAFTING_TYPE_ENCHANTING then
                local glyphLevel  = isChampion and requiredCP or GetItemRequiredLevel(BAG_BACKPACK, i)
                if enchantCP ~=isChampion or glyphLevel ~= enchantLevel then
                    break
                end
			elseif craftLevelInfo[1] ~= isChampion or level ~= craftLevelInfo[2] then
				break
			end
			runningTotal[itemId] = (runningTotal[itemId] or 0) + 1
		end
	end
	return runningTotal
end
-- LLC_CraftSmithingItemByLevel(self, patternIndex, isCP , level, styleIndex, traitIndex, 
-- 	useUniversalStyleItem, stationOverride, setIndex, quality, autocraft, reference, potencyId, essenceId, aspectId, smithingQuantity)

function WritCreater.preCraftMultiple(interactedStation)
    -- d("Smart craft multiple")
    if multiplierQueued then
        return
    end
    multiplierQueued = true
	local currentBagState = peekBagState()
	local craftMultiplier = WritCreater:GetSettings().craftMultiplier
	for itemId, craftInfo in pairs(itemsToCraft) do
		local existingAmount = currentBagState[itemId] or 0
		local expectedAmount = craftInfo[1] * craftMultiplier
		local requiredAmount = math.max(expectedAmount - existingAmount, 0)
		if requiredAmount > 0 and interactedStation == craftInfo[4] then
			local station = craftInfo[4]
			local levelsToUse = getLevelsToUse(station)
			local craftLevelInfo = levelsToUse[GetNonCombatBonus(craftingProficiencyLevels[station])]
			local isChampion, level = craftLevelInfo[1], craftLevelInfo[2]
			local patternIndex = craftInfo[3]
            if level == 2 then
                level = 1 -- items of level 1 return level 2 from the api, so we need to correct for that here
            end
            if interactedStation== CRAFTING_TYPE_ENCHANTING then
                local isCP, level, potencyItemID = getEnchantingLevel()
                WritCreater.LLCInteractionMultiplicator:CraftEnchantingItemId(potencyItemID, craftInfo[3], 45850, WritCreater:GetSettings().autoCraft, reference, nil, requiredAmount)
            else
			 local r = WritCreater.LLCInteractionMultiplicator:CraftSmithingItemByLevel(patternIndex, isChampion, level, LLC_FREE_STYLE_CHOICE, 1, false, station, INDEX_NO_SET, ITEM_FUNCTIONAL_QUALITY_NORMAL, WritCreater:GetSettings().autoCraft, itemId, nil, nil, nil, requiredAmount)
            end
		end
	end
    updateOut(interactedStation)
end

local function stationClosed(event, station)
    if not WritCreater.shouldUseSmartMultiplier() or station == 0 or station >7 then return end
    multiplierQueued = false
    WritCreater.LLCInteractionMultiplicator:cancelItem(station)
    DolgubonsWrits:SetHidden(true)
end

-- EVENT_MANAGER:RegisterForEvent(WritCreater.name.."multiplier", EVENT_CRAFTING_STATION_INTERACT, WritCreater.craftCheck)
EVENT_MANAGER:RegisterForEvent(WritCreater.name.."multiplier", EVENT_END_CRAFTING_STATION_INTERACT, stationClosed)
EVENT_MANAGER:RegisterForEvent(WritCreater.name.."multiplier", EVENT_CRAFT_COMPLETED, updateOut)