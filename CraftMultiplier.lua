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
}

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
    DolgubonsWrits:SetHidden(false)
    local stationQueue = WritCreater.LLCInteractionMultiplicator:getAddonCraftingQueue(station)
    local total = 0
    if not stationQueue then return end
    for k, v in pairs(stationQueue) do
        total = total + v.smithingQuantity or 1
    end
    if total == 0 and multiplierQueued then
        WritCreater.writCompleteUIHandle()
        multiplierQueued = false
        return
    end
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

function WritCreater.shouldUseSmartMultiplier()
    return WritCreater:GetSettings().craftMultiplier > 0 and not WritCreater:GetSettings().simpleMultiplier
end

local craftingProficiencyLevels = {
  [CRAFTING_TYPE_BLACKSMITHING] = NON_COMBAT_BONUS_BLACKSMITHING_LEVEL,
  [CRAFTING_TYPE_CLOTHIER] = NON_COMBAT_BONUS_CLOTHIER_LEVEL,
  [CRAFTING_TYPE_WOODWORKING] = NON_COMBAT_BONUS_WOODWORKING_LEVEL,
  [CRAFTING_TYPE_JEWELRYCRAFTING] = NON_COMBAT_BONUS_JEWELRYCRAFTING_LEVEL,
  [CRAFTING_TYPE_ENCHANTING] = NON_COMBAT_BONUS_ENCHANTING_LEVEL
}

-- Determines the number of required items currently in bag, so we don't overcraft
local function peekBagState()
	local runningTotal = {}
-- WritCreater.savedVarsAccountWide["craftLog"]=
	local playerName = GetUnitName("player")
	for i = 0, GetBagSize(BAG_BACKPACK) do
		-- so we can easily continue to the next iteration of the loop
		for x = 1, 1 do
			local creatorName = GetItemCreatorName(BAG_BACKPACK, i)
            -- if IsConsoleUI() then
            --     local link = GetItemLink(BAG_BACKPACK, i)
            --     if not IsItemLinkCrafted(link) then
            --         break
            --     end
            -- else
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
			local levelsToUse = station == CRAFTING_TYPE_JEWELRYCRAFTING and jewelryLevels or craftLevels
			local craftLevelInfo = levelsToUse[GetNonCombatBonus(craftingProficiencyLevels[station])]
			if craftLevelInfo[1] ~= isChampion or level ~= craftLevelInfo[2] then
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
			local levelsToUse = station == CRAFTING_TYPE_JEWELRYCRAFTING and jewelryLevels or craftLevels
			local craftLevelInfo = levelsToUse[GetNonCombatBonus(craftingProficiencyLevels[station])]
			local isChampion, level = craftLevelInfo[1], craftLevelInfo[2]
			local patternIndex = craftInfo[3]
            if level == 2 then
                level = 1 -- items of level 1 return level 2 from the api, so we need to correct for that here
            end
			local r = WritCreater.LLCInteractionMultiplicator:CraftSmithingItemByLevel(patternIndex, isChampion, level, LLC_FREE_STYLE_CHOICE, 1, false, station, INDEX_NO_SET, ITEM_FUNCTIONAL_QUALITY_NORMAL, WritCreater:GetSettings().autoCraft, itemId, nil, nil, nil, requiredAmount)
		end
	end
    updateOut(interactedStation)
end

local function stationClosed(event, station)
    if not WritCreater.shouldUseSmartMultiplier() or station == 0 then return end
    multiplierQueued = false
    WritCreater.LLCInteractionMultiplicator:cancelItem(station)
    DolgubonsWrits:SetHidden(true)
end

-- EVENT_MANAGER:RegisterForEvent(WritCreater.name.."multiplier", EVENT_CRAFTING_STATION_INTERACT, WritCreater.craftCheck)
EVENT_MANAGER:RegisterForEvent(WritCreater.name.."multiplier", EVENT_END_CRAFTING_STATION_INTERACT, stationClosed)
EVENT_MANAGER:RegisterForEvent(WritCreater.name.."multiplier", EVENT_CRAFT_COMPLETED, updateOut)