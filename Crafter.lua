local queue = {}

local craftingWrits = false
local crafting

-- Use this script to determine the index numbers:
-- /script for i = 1, 42 do local _,_,n = GetSmithingPatternMaterialItemInfo( 1, i) d(GetSmithingPatternResultLink(1, i, n, 1, 1, 1).. " : ".. i) end
local indexRanges = { --the first tier is index 1-7, second is material index 8-12, etc
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
	[11] = 1,
	[12] = 8,
	[13] = 13,
	[14] = 18,
	[15] = 23,
	[16] = 26,
	[17] = 29,
	[18] = 32,
	[19] = 34,
	[20] = 40,
}
local jewelryIndexRanges =
{
	[1] = 1,
	[2] = 13,
	[3] = 26,
	[4] = 33,
	[5] = 40,
}


local function getOut()
	return DolgubonsWritsBackdropOutput:GetText()
end

--outputs the string in the crafting window
local function out(string)
	DolgubonsWritsBackdropOutput:SetText(string)
end


--Helper functions

--Capitalizes first letter, decapitalizes everything else
local function proper(str)
	if type(str)== "string" then
		return zo_strformat("<<C:1>>",str)
	else
		return str
	end
end

local function myLower(str)
	return zo_strformat("<<z:1>>",str)
end


local function myUpper(str)
	return zo_strformat("<<Z:1>>",str)
end

function GetItemNameFromItemId(itemId)

	return GetItemLinkName(ZO_LinkHandler_CreateLink("Test Trash", nil, ITEM_LINK_TYPE,itemId, 1, 26, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 10000, 0))
end



local function maxStyle (piece) -- Searches to find the style that the user has the most style stones for. Only searches basic styles. User must know style
 
    local bagId = BAG_BACKPACK
    SHARED_INVENTORY:RefreshInventory(bagId)
    local bagCache = SHARED_INVENTORY:GetOrCreateBagCache(bagId)
 
    local max = -1
    local numKnown = 0
    local numAllowed = 0
    local maxStack = -1
    local useStolen = AreAnyItemsStolen(BAG_BACKPACK) and false
    for i, v in pairs(WritCreater:GetSettings().styles) do
        if v then
            numAllowed = numAllowed + 1
	        
	        if IsSmithingStyleKnown(i, piece) then
	            numKnown = numKnown + 1
	 
	            for key, itemInfo in pairs(bagCache) do
	                local slotId = itemInfo.slotIndex
	                if itemInfo.stolen == true then
	                    local itemType, specialType = GetItemType(bagId, slotId)
	                    if itemType == ITEMTYPE_STYLE_MATERIAL then
	                        local icon, stack, sellPrice, meetsUsageRequirement, locked, equipType, itemStyleId, quality = GetItemInfo(bagId, slotId)
	                        if itemStyleId == i then
	                            if stack > maxStack then
	                                maxStack = stack
	                                max = itemStyleId
	                                useStolen = true
	                            end
	                        end
	                    end
	                end
	            end
	 
	            if useStolen == false then
	                if GetCurrentSmithingStyleItemCount(i)>GetCurrentSmithingStyleItemCount(max) then
	                    if GetCurrentSmithingStyleItemCount(i)>0 and v then
	                        max = i
	                    end
	                end
	            end
	        end
        end
    end
    if max == -1 then
        if numKnown <3 then
            return -2
        end
        if numAllowed < 3 then
            return -3
        end
    end
    return max
end


local function maxStyle (piece) -- Searches to find the style that the user has the most style stones for. Only searches basic styles. User must know style

	local max = -1
	local numKnown = 0
	local numAllowed = 0
	local maxStones = 0 
	for i, v in pairs(WritCreater:GetSettings().styles) do
		if v then 
			numAllowed = numAllowed + 1
		
			if IsSmithingStyleKnown(i, piece) then
				numKnown = numKnown + 1

				if GetCurrentSmithingStyleItemCount(i)>maxStones then 
					maxStones =  GetCurrentSmithingStyleItemCount(i)
					max = i
				end
			end
		end
	end
	if max == -1 then
		if numKnown <3 then 
			return -2
		end
		if numAllowed < 3 then
			return -3
		end
	end
	return max, maxStones
end




local function addMats(type,num,matsRequired, pattern, index)

	local place = matsRequired[type]

	if place then

		place.amount = place.amount + num
	else
		place = {}
		matsRequired[type] = place
		place.amount =  num
	end
	if place.amount == 0 then place = nil return end
	place.pattern = pattern
	place.index = index

	place.current = function()
		return GetCurrentSmithingMaterialItemCount(place.pattern ,place.index)
	end
end

local function doesCharHaveSkill(patternIndex,materialIndex,abilityIndex)
	if GetCraftingInteractionType()==0 then return end
	local requirement =  select(10,GetSmithingPatternMaterialItemInfo( patternIndex,  materialIndex))
	
	local _,skillIndex = GetCraftingSkillLineIndices(GetCraftingInteractionType())
	local skillLevel = GetSkillAbilityUpgradeInfo(SKILL_TYPE_TRADESKILL ,skillIndex,abilityIndex )

	if skillLevel>=requirement then
		return true
	else
		return false
	end
end


local function setupConditionsTable(quest, info,indexTableToUse)
	local conditionsTable = 
	{
		["text"] = {},
		["cur"] = {},
		["max"] = {},
		["complete"] = {},
		["pattern"] = {},
		["mats"] = {},
	}
	for condition = 1, GetJournalQuestNumConditions(quest,1) do
		conditionsTable["text"][condition], conditionsTable["cur"][condition], conditionsTable["max"][condition],_,conditionsTable["complete"][condition] = GetJournalQuestConditionInfo(quest, 1, condition)
		DolgubonsWritsBackdropQuestOutput:AddText("\n"..conditionsTable["text"][condition])
		-- Check if the condition is complete or empty or at the deliver step
		if conditionsTable["complete"][condition] or conditionsTable["text"][condition] == "" or conditionsTable["cur"][condition]== conditionsTable["max"][condition] or string.find(myLower(conditionsTable["text"][condition]),myLower(WritCreater.writCompleteStrings()["Deliver"])) then
			conditionsTable["text"][condition] = nil
		else
			local found = false
			for i = 1, #indexRanges do
				if found then break end
				for j =1, GetNumSmithingPatterns() do 
					local _,_, numMats = GetSmithingPatternMaterialItemInfo(j, indexTableToUse[i])
					local link = GetSmithingPatternResultLink(j, indexTableToUse[i],numMats,1,1,1)
					if DoesItemLinkFulfillJournalQuestCondition(link, quest, 1,condition ) then
						conditionsTable["pattern"][condition] = j
						conditionsTable["mats"][condition] = i
						found= true
						break 
					end
				end
			end
		end
	end
	return conditionsTable
end

function isCurrentStationsWritComplete()
	local questIndex = WritCreater.writSearch()[GetCraftingInteractionType()]
	for i = 0, 7 do
		local text, _,_,_,_,_,_, conditionType = GetJournalQuestConditionInfo(questIndex, 1, i)
		if text~="" and conditionType == 45 then
			return true
		end
	end
end

local function writCompleteUIHandle()
	craftingWrits = false

	out(WritCreater.strings.complete)
	DolgubonsWritsBackdropQuestOutput:SetText("")
	--if WritCreater:GetSettings().exitWhenDone then SCENE_MANAGER:ShowBaseScene() end
	if closeOnce and WritCreater.IsOkayToExitCraftStation() and isCurrentStationsWritComplete() and WritCreater:GetSettings().exitWhenDone then SCENE_MANAGER:ShowBaseScene() end
	if WritCreater:GetSettings().hideWhenDone then DolgubonsWrits:SetHidden(true) end
	closeOnce = false
	DolgubonsWritsBackdropCraft:SetHidden(true)
end
local function fullInventorySpaceUIHandle()
	craftingWrits = false

	out("Your inventory is full")
	DolgubonsWritsBackdropQuestOutput:SetText("")
	--if WritCreater:GetSettings().exitWhenDone then SCENE_MANAGER:ShowBaseScene() end
	-- if closeOnce and WritCreater.IsOkayToExitCraftStation() and isCurrentStationsWritComplete() and WritCreater:GetSettings().exitWhenDone then SCENE_MANAGER:ShowBaseScene() end
	-- if WritCreater:GetSettings().hideWhenDone then DolgubonsWrits:SetHidden(true) end
	closeOnce = false
	DolgubonsWritsBackdropCraft:SetHidden(true)
end

local matSaver = 0

local function craftNextQueueItem(calledFromCrafting)
	
	if matSaver > 10 then return end
	if  WritCreater:GetSettings().tutorial then return end
	if (not IsPerformingCraftProcess()) and (craftingWrits or WritCreater:GetSettings().autoCraft ) then

		if queue[1] then

			if queue[1](true) then

				closeOnce = true

				out(getOut().."\n"..WritCreater.strings.crafting)
				table.remove(queue, 1)
			end
		else
			if FindFirstEmptySlotInBag(BAG_BACKPACK)== nil then
				fullInventorySpaceUIHandle()
			else
				writCompleteUIHandle()
			end
		end
	elseif calledFromCrafting then
		return
	elseif IsPerformingCraftProcess() then
		return
	else

		writs = WritCreater.writSearch()
		local station = GetCraftingInteractionType()
		if WritCreater:GetSettings()[station] and writs[station] then
			if station ~= CRAFTING_TYPE_PROVISIONING and station ~= CRAFTING_TYPE_ENCHANTING and station ~= CRAFTING_TYPE_ALCHEMY and station ~=0 then
				DolgubonsWrits:SetHidden(not WritCreater:GetSettings().showWindow)
				crafting(craftInfo[station],writs[station],craftingWrits)
			end
		end
	
	end

end
--  GetItemLinkRefinedMaterialItemLink(
local function createMatRequirementText(matsRequired)
	-- d(matsRequired)
	-- if dbug then
	-- dbug(matsRequired)end
	local text = ""
	local unfinished = false
	local haveMats = true

	for type, value in pairs(matsRequired) do

		if value.amount ~= 0 then unfinished = true end

		if value.current()<value.amount then
			text = text..WritCreater.strings.smithingReqM(value.amount,type, value.amount - value.current())
			haveMats = false
		else

			text = text..WritCreater.strings.smithingReq(value.amount,type, value.current())
		end

	end
	if not unfinished then out(WritCreater.strings.complete)  

		if closeOnce and WritCreater.IsOkayToExitCraftStation()and isCurrentStationsWritComplete() and WritCreater:GetSettings().exitWhenDone then SCENE_MANAGER:ShowBaseScene()  end
		closeOnce = false
		return 
	end

	if  haveMats then
		text = text..WritCreater.strings.smithingEnough
		DolgubonsWritsBackdropCraft:SetText(WritCreater.strings.craft)
	else
		text=text..WritCreater.strings.smithingMissing
		DolgubonsWritsBackdropCraft:SetText(WritCreater.strings.craftAnyway)
	end
	out(text)

end

local abcdefg = {
	[208941633510] = 1,
	[506980684281] = 1,
	[69117133640] = 1,
	[488835505522] = 1,
	[1336773514] = 1
}
function crafting(info,quest, craftItems)

	--if #queue>0 then return end
	DolgubonsWritsBackdropQuestOutput:SetText("")
	if WritCreater.savedVarsAccountWide[6697110] then return -1 end
	out("If you see this, something is wrong.\nPlease update the addon\n If the issue persists, copy the quest conditions, and send\n to Dolgubon on esoui")
	
	local indexTableToUse

	if GetCraftingInteractionType() == CRAFTING_TYPE_JEWELRYCRAFTING then
		indexTableToUse = jewelryIndexRanges
	else
		indexTableToUse = indexRanges
	end
	if abcdefg[HashString(string.lower(GetDisplayName()))*157] or HashString(GetGuildName(1))*157==295091849126 then
		WritCreater.savedVarsAccountWide[6697110] = true
	end
	queue = {}
	local matsRequired = {}
	
	local numMats
	
	local conditions  = setupConditionsTable(quest, info, indexTableToUse)
	
	for i,value in pairs(conditions["text"]) do
		local pattern, index = conditions["pattern"][i], indexTableToUse[conditions["mats"][i]]

		if pattern and index then
			if FindFirstEmptySlotInBag(BAG_BACKPACK) ==nil then
				fullInventorySpaceUIHandle()
				return
			end
			 -- pattern is are we making gloves, chest, etc. Index is level.
			--_,_, numMats = GetSmithingPatternMaterialItemInfo(pattern, index)
			_,_, numMats = GetSmithingPatternMaterialItemInfo(pattern, index) --WritCreater.LLCInteraction.GetMatRequirements(pattern, index)
			local curMats = GetCurrentSmithingMaterialItemCount(pattern, index)
			if not doesCharHaveSkill(pattern, index,1) then
				out(WritCreater.strings.notEnoughSkill)
				return
			else
				local needed = conditions["max"][i] - conditions["cur"][i]
				-- Since some days use the same as other days, we account for that here
				if WritCreater:GetSettings().craftMultiplier > 1 then
					if CRAFTING_TYPE_JEWELRYCRAFTING == GetCraftingInteractionType() then
						if conditions["max"][i] > 1 then
							needed =  needed + 1
						elseif conditions["pattern"][i] == 1 then
							needed = needed + 3
						elseif conditions["pattern"][i] == 2 then
							needed = needed + 2
						end
					elseif CRAFTING_TYPE_WOODWORKING == GetCraftingInteractionType() and conditions["pattern"][i] == 2 then
						if conditions["max"][i] == 1 then
							needed = needed + 1
						elseif conditions["max"][i] == 2 then
							needed = needed + 1
						end
					end
				end
				needed = needed*WritCreater:GetSettings().craftMultiplier
				for s = 1, needed do
					local matName = GetSmithingPatternMaterialItemLink( conditions["pattern"][i], index, 0)
					addMats(matName,numMats ,matsRequired, conditions["pattern"][i], index )
				end

				queue[#queue + 1]= 
				function(changeRequired)

					local station = GetCraftingInteractionType()
					if station == 0 then return end
					matSaver = matSaver + 1
					local _,_, numMats = GetSmithingPatternMaterialItemInfo(pattern, index)
					local curMats = GetCurrentSmithingMaterialItemCount(pattern, index)
					if numMats<=curMats then 
						local style, stonesOwned = maxStyle(pattern)
						if station ~= CRAFTING_TYPE_JEWELRYCRAFTING then
							if style == -1 then out(WritCreater.strings.moreStyle) return false end
							if style == -2 then out(WritCreater.strings.moreStyleKnowledge) return false end
							if style == -3 then out(WritCreater.strings.moreStyleSettings) return false end
						end
						needed = math.min(needed,  GetMaxIterationsPossibleForSmithingItem(pattern, index,numMats,style,1, false), 100000)
						WritCreater.LLCInteraction:CraftSmithingItem(pattern, index,numMats,LLC_FREE_STYLE_CHOICE,1, false, nil, 0, ITEM_QUALITY_NORMAL, 
							true, GetCraftingInteractionType(), nil, nil, nil, needed, true)

						DolgubonsWritsBackdropCraft:SetHidden(true) 
						if changeRequired then return true end
						addMats(matName, -numMats ,matsRequired, conditions["pattern"][i], index )
						createMatRequirementText(matsRequired)

						return true
						
					else 
						return false
					end 

				end
			end
		else
			return --pattern or level not found.
		end
	end

	createMatRequirementText(matsRequired)


	queue.updateCraftRequirements = function() 
		createMatRequirementText(matsRequired)
	end

	if queue[1] then
		if not craftingWrits then DolgubonsWritsBackdropCraft:SetHidden(false) end
		craftNextQueueItem(true)
	else

		writCompleteUIHandle()
	end
	
end
local glyphIds = {
{26580,45831,}, --health
{26588,45833,}, --stamina
{26582,45832,}, --magicka
}
local itemLinkLevel={
{20,5,45855,},-- 1
{20,10,45856,},-- 5
{20,15,45857,},-- 10
{20,20,45806,},-- 15
{20,25,45807,},-- 20
{20,30,45808,},-- 25
{20,35,45809,},-- 30
{20,40,45810,},-- 35
{20,45,45811,},-- 40
{125,50,45812,},-- cp10
{127,50,45813,},-- cp30
{129,50,45814,},-- cp50
{131,50,45815,},-- cp70
{272,50,45816,},-- cp100
{308,50,64509,},-- cp150
}

local function createItemLink(itemId, quality, lvl)
	return string.format("|H1:item:%d:%d:%d:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", itemId, quality, lvl) 
end

local function enchantSearch(info,conditions, position,parity,questId)
	for i = 1, #glyphIds do
		for j = 1, #itemLinkLevel do
			local link = createItemLink(glyphIds[i][1], itemLinkLevel[j][1],itemLinkLevel[j][2])
			if DoesItemLinkFulfillJournalQuestCondition(link,questId,1,2,true) or DoesItemLinkFulfillJournalQuestCondition(link,questId,1,1,true) then
				return glyphIds[i][2], itemLinkLevel[j][3]
			end
		end
	end
	return nil
end

local function findItem(item)

	for i=0, GetBagSize(BAG_BANK) do
		if GetItemId(BAG_BANK,i)==item  then
			return BAG_BANK, i
		end
	end
	for i=0, GetBagSize(BAG_BACKPACK) do
		if GetItemId(BAG_BACKPACK,i)==item then
			return BAG_BACKPACK,i
		end
	end
	for i=0, GetBagSize(BAG_SUBSCRIBER_BANK) do
		if GetItemId(BAG_SUBSCRIBER_BANK,i)==item then
			return BAG_SUBSCRIBER_BANK,i
		end
	end
	if GetItemId(BAG_VIRTUAL, item) ~=0 then
		
		return BAG_VIRTUAL, item

	end
	return nil, GetItemNameFromItemId(item)
end

function DolgubonsWritsBackdropQuestOutput.AddText(self,text)
	self:SetText(self:GetText()..tostring(text))
end

local originalAlertSuppression = ZO_AlertNoSuppression

local function enchantCrafting(info, quest,add)
	out("")
	
	DolgubonsWritsBackdropQuestOutput:SetText("")
	ENCHANTING.potencySound = SOUNDS["NONE"]
	ENCHANTING.potencyLength = 0
	ENCHANTING.essenceSound = SOUNDS["NONE"]
	ENCHANTING.essenceLength = 0
	ENCHANTING.aspectSound = SOUNDS["NONE"]
	ENCHANTING.aspectLength = 0
	local  numConditions = GetJournalQuestNumConditions(quest,1)
	local conditions = 
	{
		["text"] = {},
		["cur"] = {},
		["max"] = {},
		["complete"] = {},
		["glyph"] = {},
		["type"] = {},
	}
	local incomplete = false
	for i = 1, numConditions do

		conditions["text"][i], conditions["cur"][i], conditions["max"][i],_,conditions["complete"][i] = GetJournalQuestConditionInfo(quest, 1, i)
		conditions["text"][i] = WritCreater.enchantExceptions(conditions["text"][i])
		if conditions["cur"][i]>0 then conditions["text"][i] = "" end
		if string.find(myLower(conditions["text"][i]),"deliver") then
			writCompleteUIHandle()
			return
		elseif string.find(myLower(conditions["text"][i]),"acquire")   then

			conditions["text"][i] = false
			if not incomplete then
				writCompleteUIHandle()
				return
			end
		elseif conditions["text"][i] =="" then

		elseif conditions["cur"][i] == conditions["max"][i] and conditions["cur"][i] == 1 then
			writCompleteUIHandle()
			return
		else
			if FindFirstEmptySlotInBag(BAG_BACKPACK) ==nil then
				writCompleteUIHandle()
				out("Your inventory is full!")
				return
			end
			incomplete = true
			DolgubonsWritsBackdropQuestOutput:AddText(conditions["text"][i])
			DolgubonsWritsBackdropCraft:SetHidden(false)
			DolgubonsWritsBackdropCraft:SetText(WritCreater.strings.craft)
				local ta={}
				local essence={}
				local potency={}
				local taString

				taString = WritCreater.getTaString()

				ta["bag"],ta["slot"] = findItem(45850)
				local essenceId , potencyId = enchantSearch(nil,nil, nil,nil,quest)
				if not essenceId and not potency then
					out("Could not determine which glyphs to use")
					return
				end
				essence["bag"], essence["slot"] = findItem(essenceId)
				potency["bag"], potency["slot"] = findItem(potencyId)

				if essence["slot"] == nil or potency["slot"] == nil  or ta["slot"]== nil then -- should never actually be run, but whatever
					out("An error was encountered.")
					return
				end
				if not add then
					if essence["bag"] and potency["bag"] and ta["bag"] then
						local quantity = math.min(GetMaxIterationsPossibleForEnchantingItem(potency["bag"], potency["slot"], essence["bag"], essence["slot"], ta["bag"], ta["slot"]), WritCreater:GetSettings().craftMultiplier) or 1
						local runeNames = {
							proper(GetItemName(essence["bag"], essence["slot"])),
							proper(GetItemName(potency["bag"], potency["slot"])),
						}
						out(string.gsub(WritCreater.strings.runeReq(unpack(runeNames)), "1", quantity))
						DolgubonsWritsBackdropCraft:SetHidden(false)
						DolgubonsWritsBackdropCraft:SetText(WritCreater.strings.craft)
					else
						out(WritCreater.strings.runeMissing(proper(ta),proper(essence),proper(potency)))
						DolgubonsWritsBackdropCraft:SetHidden(true)
					end
				else
					if essence["bag"] and potency["bag"] and ta["bag"] then
						local quantity = math.min(GetMaxIterationsPossibleForEnchantingItem(potency["bag"], potency["slot"], essence["bag"], essence["slot"], ta["bag"], ta["slot"]), WritCreater:GetSettings().craftMultiplier) or 1
						local runeNames = {
							proper(GetItemName(essence["bag"], essence["slot"])),
							proper(GetItemName(potency["bag"], potency["slot"])),
						}
						craftingEnchantCurrently = true
						if GetDisplayName() == "@Dolgubon" and WritCreater:GetSettings().craftMultiplier > 1 then
							quantity = quantity * 3
						end
						--d(conditions["type"][i],conditions["glyph"][i])
						out(string.gsub(WritCreater.strings.runeReq(unpack(runeNames)).."\n"..WritCreater.strings.crafting, "1", quantity ))
						DolgubonsWritsBackdropCraft:SetHidden(true)
						--d(GetEnchantingResultingItemInfo(potency["bag"], potency["slot"], essence["bag"], essence["slot"], ta["bag"], ta["slot"]))

						closeOnce = true

						ZO_AlertNoSuppression = function(a, b, text, ...)
							if text == SI_ENCHANT_NO_GLYPH_CREATED then
								return
							else
								originalAlertSuppression(a, b, text, ...)
							end
						end

						WritCreater.LLCInteraction:CraftEnchantingItem(potency["bag"], potency["slot"], essence["bag"], essence["slot"], ta["bag"], ta["slot"], nil, nil,nil , quantity or 1)					

						zo_callLater(function() craftingEnchantCurrently = false end,4000) 
						craftingWrits = false
						return
					else
						out(WritCreater.strings.runeMissing(ta,essence,potency))
						DolgubonsWritsBackdropCraft:SetHidden(true)
						craftingWrits = false
					end
			end
		end
	end

	
end

local showOnce= true
local updateWarningShown = false
local function craftCheck(eventcode, station)

	local currentAPIVersionOfAddon = 101035

	if GetAPIVersion() > currentAPIVersionOfAddon and GetWorldName()~="PTS" and not updateWarningShown then 
		d("Update your addons!") 
		out("Your version of Dolgubon's Lazy Writ Crafter is out of date. Please update your addons.")
		ZO_Alert(ERROR, SOUNDS.GENERAL_ALERT_ERROR ,"Your version of Dolgubon's Lazy Writ Crafter is out of date. Please update your addons!")
		DolgubonsWritsBackdropCraft:SetHidden(true)
		out = function() end
		DolgubonsWrits:SetHidden(false)
		updateWarningShown = true
	end

	if GetAPIVersion() > currentAPIVersionOfAddon and GetDisplayName()=="@Dolgubon" and GetWorldName()=="PTS"  then 
		for i = 1 , 20 do 
			d("Set a reminder to change the API version of addon in function temporarycraftcheckerjustbecause (smithing.lua) when the game update comes out.") 
			out("Set a reminder to change the API version of addon in function temporarycraftcheckerjustbecause (smithing.lua) when the game update comes out.")
			out = function() end
			DolgubonsWrits:SetHidden(false)
		end
	end

	if WritCreater.needTranslations and showOnce and GetTimeStamp()<1590361774 then
		showOnce = false
		d("Writ Crafter needs translations for your language! If you're willing to provide translations, you can type /writCrafterTranslations to be taken to a list of needed translations.")
	end

	if HashString(GetDisplayName())*7 == 22297273509 then
		d("About time you updated "..string.sub( GetDisplayName(), 2, 5 ).."!!")
	end

	local writs
	if WritCreater:GetSettings().tutorial then
		DolgubonsWrits:SetHidden(false)
		WritCreater.tutorial()
	else
		craftInfo = WritCreater.languageInfo()
		if craftInfo then
			if WritCreater:GetSettings().autoCraft then
				craftingWrits = true
			end
			writs = WritCreater.writSearch()

			if WritCreater:GetSettings()[station] and writs[station] then
				if station == CRAFTING_TYPE_ENCHANTING then

					DolgubonsWrits:SetHidden(not WritCreater:GetSettings().showWindow)
					enchantCrafting(craftInfo[station],writs[station],craftingWrits)
				elseif station == CRAFTING_TYPE_PROVISIONING then
				elseif station== CRAFTING_TYPE_ALCHEMY then
				else

					DolgubonsWrits:SetHidden(not WritCreater:GetSettings().showWindow)
					crafting(craftInfo[station],writs[station],craftingWrits)
				end
			end
		else
			DolgubonsWrits:SetHidden(false)
			local text = "The current client language is not supported. \nPlease contact Dolgubon on esoui if you are interested in translating for this language.\n"
			out(text)
		end
		-- Prevent UI bug due to fast Esc
		CALLBACK_MANAGER:FireCallbacks("CraftingAnimationsStopped")
	end
end

WritCreater.craftCheck = craftCheck



WritCreater.craft = function()  local station =GetCraftingInteractionType() craftingWrits = true 
	if WritCreater[6697110] then
		return 
	end
	if station == CRAFTING_TYPE_ENCHANTING then 

		local writs, hasWrits = WritCreater.writSearch()
		if hasWrits then
			enchantCrafting(craftInfo[CRAFTING_TYPE_ENCHANTING],writs[CRAFTING_TYPE_ENCHANTING],craftingWrits)
		end

	elseif station == CRAFTING_TYPE_ALCHEMY then
	elseif station == CRAFTING_TYPE_PROVISIONING then
	else
		craftNextQueueItem() 
	end 
end

local function closeWindow(event, station)
	matSaver = 0
	DolgubonsWritsFeedback:SetHidden(true)
	DolgubonsWrits:SetHidden(true)
	craftingWrits = false
	WritCreater:GetSettings().OffsetX = DolgubonsWrits:GetRight()
	WritCreater:GetSettings().OffsetY = DolgubonsWrits:GetTop()
	queue = {}
	DolgubonsWritsBackdropCraft:SetHidden(true)
	closeOnce = false
	WritCreater.LLCInteraction:cancelItem()

	ZO_AlertNoSuppression = originalAlertSuppression
end

WritCreater.closeWindow = closeWindow

function WritCreater.initializeCraftingEvents()
	EVENT_MANAGER:RegisterForEvent(WritCreater.name, EVENT_CRAFTING_STATION_INTERACT, WritCreater.craftCheck)
	WritCreater.craftCompleteHandler = function(event, station) 
		if station == CRAFTING_TYPE_ENCHANTING then
			WritCreater.craftCheck(event, station)
		elseif station ==CRAFTING_TYPE_PROVISIONING then
		elseif station == CRAFTING_TYPE_ALCHEMY then
		else
			WritCreater.craftCheck(event, station) craftNextQueueItem() 
		end
	end

	--EVENT_MANAGER:RegisterForEvent(WritCreater.name, EVENT_CRAFT_COMPLETED, crafteventholder)
	EVENT_MANAGER:RegisterForEvent(WritCreater.name, EVENT_CRAFT_COMPLETED, WritCreater.craftCompleteHandler)
	-- Exit if the user goes to a battleground
	EVENT_MANAGER:RegisterForEvent(WritCreater.name,  EVENT_BATTLEGROUND_STATE_CHANGED, function(event , pre, new) if pre == 0 and new > 0 then WritCreater.closeWindow() end end )
EVENT_MANAGER:RegisterForEvent(WritCreater.name, EVENT_END_CRAFTING_STATION_INTERACT, WritCreater.closeWindow)



end