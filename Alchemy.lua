


local function myLower(str)
	return zo_strformat("<<z:1>>",str)
end

local function getOut()
	return DolgubonsWritsBackdropOutput:GetText()
end

--outputs the string in the crafting window
local function out(string)
	DolgubonsWritsBackdropOutput:SetText(string)
end

local prices = {
	[77583] = 80 ,
	[30157] = 60,
	[30148] = 30,
	[30160] = 200,
	[77585] = 60,
	[150669] = 380,
	[139020] = 300, 
	[30164] = 900,
	[30161] = 80,
	[150672] = 125,
	[150789] = 99,
	[150731] = 2300,
	[150671] = 2200,
	[30162] = 60,
	[30151] = 60,
	[77587] = 45,
	[30156] = 60,
	[30158] = 60,
	[30155] = 70,
	[30163] = 160,
	[77591] = 540,
	[30153] = 50,
	[77590] = 80,
	[30165] = 40,
	[139019] = 930,
	[77589] = 250,
	[77584] = 60,
	[30149] = 70,
	[77581] = 590,
	[150670] = 200,
	[30152] = 450, 
	[30166] = 45,
	[30154] = 36,
	[30159] = 52,
}

WritCreater.effectMap = {
  [1] = "Restore Health",
  [2] = "Ravage Health",
  [3] = "Restore Magicka",
  [4] = "Ravage Magicka",
  [5] = "Restore Stamina",
  [6] = "Ravage Stamina",
  [7] = "Increase Spell Resist",
  [8] = "Breach",
  [9] = "Increase Armor",
  [10] = "Fracture",
  [11] = "Increase Spell Power",
  [12] = "Cowardice",
  [13] = "Increase Weapon Power",
  [14] = "Maim",
  [15] = "Spell Critical",
  [16] = "Uncertainty",
  [17] = "Weapon Critical",
  [18] = "Enervation",
  [19] = "Unstoppable",
  [20] = "Entrapment",
  [21] = "Detection",
  [22] = "Invisible",
  [23] = "Speed",
  [24] = "Hindrance",
  [25] = "Protection",
  [26] = "Vulnerability",
  [27] = "Lingering Health",
  [28] = "Gradual Ravage Health",
  [29] = "Vitality",
  [30] = "Defile",
  [31] = "Heroism",
  [32] = "Timidity",
}

local reagentInfo = {
	[30148] = {[3]=-1,[11]=-1,[1]=1,[21]=-1,},
	[30149] = {[9]=-1,[1]=-1,[13]=1,[5]=-1,},
	[30151] = {[1]=-1,[3]=-1,[5]=-1,[19]=-1,},
	[30152] = {[7]=-1,[1]=-1,[11]=1,[3]=-1,},
	[30153] = {[15]=1,[23]=1,[21]=-1,[19]=1,},
	[30154] = {[11]=-1,[3]=-1,[7]=1,[21]=1,},
	[150731] = {[27]=1,[5]=1,[31]=1,[29]=-1,},
	[30156] = {[13]=-1,[5]=-1,[9]=1,[17]=-1,},
	[77581] = {[9]=-1,[17]=-1,[21]=1,[29]=1,},
	[30158] = {[11]=1,[3]=1,[7]=-1,[15]=1,},
	[77583] = {[7]=-1,[9]=1,[25]=1,[29]=1,},
	[77584] = {[23]=-1,[21]=-1,[27]=1,[29]=-1,},
	[77585] = {[1]=1,[15]=-1,[27]=1,[29]=1,},
	[30162] = {[13]=1,[5]=1,[9]=-1,[17]=1,},
	[30163] = {[9]=1,[1]=1,[13]=-1,[5]=1,},
	[30164] = {[1]=1,[3]=1,[5]=1,[19]=1,},
	[30165] = {[1]=-1,[15]=-1,[17]=-1,[21]=-1,},
	[30166] = {[1]=1,[15]=1,[17]=1,[19]=-1,},
	[77591] = {[7]=1,[9]=1,[25]=1,[29]=-1,},
	[77587] = {[5]=-1,[25]=-1,[27]=-1,[29]=1,},
	[77590] = {[1]=-1,[25]=1,[27]=-1,[29]=-1,},
	[150671] = {[3]=1,[17]=-1,[31]=1,[23]=1,},
	[30160] = {[7]=1,[1]=1,[11]=-1,[3]=1,},
	[77589] = {[3]=-1,[23]=1,[25]=-1,[27]=1,},
	[139019] = {[27]=1,[23]=1,[29]=1,[25]=1,},
	[150789] = {[31]=1,[25]=-1,[21]=-1,[29]=1,},
	[139020] = {[7]=1,[23]=-1,[25]=-1,[29]=-1,},
	[30155] = {[5]=-1,[13]=-1,[1]=1,[23]=-1,},
	[30157] = {[5]=1,[13]=1,[1]=-1,[23]=1,},
	[150670] = {[31]=-1,[1]=-1,[3]=1,[25]=1,},
	[30159] = {[17]=1,[23]=-1,[21]=1,[19]=1,},
	[150672] = {[31]=-1,[15]=1,[27]=-1,[1]=1,},
	[30161] = {[3]=1,[11]=1,[1]=-1,[21]=1,},
	[150669] = {[31]=-1,[3]=-1,[5]=1,[21]=1,},
}

local function determinePotionResult(reagent1, reagent2, reagent3)
	local reagents = {reagent1, reagent2, reagent3}
	local interimEffects = {}
	for i = 1, #reagents do
		for effectId, parity in pairs(reagentInfo[reagents[i]]) do
			interimEffects[effectId] = (interimEffects[effectId] or 0) + parity
		end
	end
	local finalEffects = {}
	for effectId, total in pairs(interimEffects) do
		if total > 1 then
			finalEffects[effectId] = 1
		elseif total < -1 then
			finalEffects[effectId] = -1
		end
	end
	return finalEffects, NonContiguousCount(finalEffects)
end

local function getShortlist(...)
	local params = {...}
	if #params > 3 then d("Searching for too many parameters") return end
	local searchEffects = {}
	for i = 1, #params do
		if params[i] % 2 == 0 then
			searchEffects[params[i]-1] = -1
		else
			searchEffects[params[i]] = 1
		end
	end
	local shortList = {}
	for reagentId, reagentEffects in pairs(reagentInfo) do
		for eff, parity in pairs(reagentEffects) do
			if searchEffects[eff] == parity then
				shortList[reagentId] =  reagentEffects
			end
		end
	end
	return shortList
end
--GetTraitIdFromBasePotion(54341)

function WritCreater.alchemyWrit(solvent, reagents, requiredItemId, craftingWrits)
	-- not working atm. Need to figure out why
	-- if IsInGamepadPreferredMode() then return end
	-- determine cheapest
	-- first lets get all prices
	if LibPrice then
		for k, v in pairs(reagents) do
			local price, source = LibPrice.ItemLinkToPriceGold(getItemLinkFromItemId(k))
			if source ~= "npc" then
				prices[k] = price
			end
		end
		
	else
		-- we use the default hardcoded prices
		-- Not the best prices but will at least give rough relational value
		-- if you don't use a price addon you deserve what you get
	end
	-- since we only find known combos, we could miss much cheaper combos
	-- so if it costs over 2k it won't allow the use of that combo
	-- this may need to be tuned more
	-- Probably shouldn't come up much though
	local minCost = 2000
	local minCombo
	for reagent1, v in pairs(reagents) do
		for reagent2, _ in pairs(v) do
			local cost = prices[reagent1] + prices[reagent2]
			if cost < minCost then
				minCost = cost
				minCombo = {reagent1, reagent2}
			end
		end
	end
	if solvent and not minCombo then
		out("Could not find a cheap enough known reagent combo. Try acquiring other types of alchemy items")
		return
	end

	if solvent and solvent.itemId and minCombo then
		local missing = {}
		for k, stockItemIdCheck in pairs({solvent.itemId, minCombo[1], minCombo[2]}) do
			local bag, slot = findItemLocationById(solvent.itemId)
			if not bag then
				missing[stockItemIdCheck] = true
			end
		end
		if NonContiguousCount(missing) > 0 then
			local missingOut = "You are missing "
			for missingId, v in pairs(missing) do
				missingOut = missingOut..getItemLinkFromItemId(missingId).." "
			end
			missingOut = missingOut.." to craft the cheapest combo"
			out(missingOut)
			return 
		end
		
		if craftingWrits then
			out(getOut().."\n"..WritCreater.strings.crafting)
			shouldShowGamepadPrompt = false
		else
			shouldShowGamepadPrompt = true
		end
		WritCreater.gpCraftOutOriginalText = getOut()
		local factor = GetAlchemyResultQuantity(findItemLocationById(solvent.itemId))
		local quantity = 1
		-- DolgubonsWritsBackdropCraft:SetHidden(craftingWrits)
		if WritCreater:GetSettings().consumableMultiplier == 25 then
			if factor == 4 then
				quantity = 25
			elseif factor == 16 then
				quantity = 6
			else
				d("You have selected to craft a full stack, but you do not have the craft multiplication passives active")
			end
		end
		out(zo_strformat("Crafting will use <<t:4>> <<t:1>>, <<t:4>> <<t:2>>, and <<t:4>> <<t:3>>", getItemLinkFromItemId(solvent.itemId), getItemLinkFromItemId(minCombo[1]), getItemLinkFromItemId(minCombo[2]), quantity))
		DolgubonsWritsBackdropCraft:SetText(WritCreater.strings.craft)
		WritCreater.showCraftButton(craftingWrits)
		WritCreater.LLCInteraction:CraftAlchemyItemId(solvent.itemId, minCombo[1], minCombo[2], nil, quantity, craftingWrits)
		WritCreater.setCloseOnce()
	else
		WritCreater.writCompleteUIHandle()
	end
end

local function getConditionIndex(journalIndex)
	for i = 1, 5 do
		local requiredItemId, materialItemId = GetQuestConditionItemInfo(journalIndex, 1, i)
		if materialItemId>0 then
			return i
		end
	end
	return 1
end


local function searchDailyCombos(journalIndex)
	local conditionIndex = getConditionIndex(journalIndex)
	local requiredItemId, materialItemId = GetQuestConditionItemInfo(journalIndex, 1, conditionIndex)
	local _,current, max = GetJournalQuestConditionInfo(journalIndex,1,conditionIndex)
	if current == max then
		return nil
	end
	local effectId = GetTraitIdFromBasePotion(requiredItemId)
	local shortList = getShortlist(effectId)
	local parity = (effectId % 2 == 0) and -1 or 1
	effectId = effectId + ((effectId % 2 == 0) and -1 or 0)
	local finalCombos = {reagents = {}}
	for reagent1, effects1 in pairs(shortList) do
		for reagent2, effects2 in pairs(shortList) do
			if reagent2~= reagent1 then
				local result, numTraits = determinePotionResult(reagent1,reagent2)
				if numTraits == 1 and result[effectId] == parity then
					finalCombos.reagents[reagent1] = finalCombos.reagents[reagent1] or {}
					finalCombos.reagents[reagent1][reagent2] = true
					-- table.insert(finalCombos[reagent1], reagent2)
				end

			end
		end
	end
	-- local itemType = GetItemType(v.bag, v.index)
	-- 	if not IsAlchemySolvent(itemType) then
	for k, v in pairs(WritCreater.alchemyList) do
		if IsAlchemySolventForItemAndMaterialId(v.bag,v.index,requiredItemId,materialItemId) then
			local solventId = GetItemId(v.bag, v.index)
			finalCombos.solvent = {bagId = v.bag, slotIndex = v.index, itemId = solventId}
		end
	end
	return finalCombos
end



local function startAlchemy(journalIndex, craftingWrits)
	local journalIndex = WritCreater.writSearch()[CRAFTING_TYPE_ALCHEMY]
	if not journalIndex then
		DolgubonsWrits:SetHidden(true)
		return
	end
	DolgubonsWrits:SetHidden(not WritCreater:GetSettings().showWindow)

	local alchemyInfo
	local isMasterWrit = GetQuestConditionMasterWritInfo(journalIndex,1,1) ~= nil

	local conditionText, curCount, maxCount = GetJournalQuestConditionInfo(journalIndex, QUEST_MAIN_STEP_INDEX, 1)
	local deliverString = string.lower(WritCreater.writCompleteStrings()["Deliver"]) or "deliver"
	local acquireString = string.lower(WritCreater.writCompleteStrings()["Acquire"]) or "acquire"
	conditionText = myLower(conditionText)
	if curCount == 1 or string.find(conditionText,deliverString) or string.find(conditionText,"deliver") then
		WritCreater.writCompleteUIHandle()
		return
	end

	--First, generate the alchemy info table that zos would generate
	if isMasterWrit then
		local itemId, materialItemId, craftType, _,_,_,_,_,encodedAlchemyTraits = GetQuestConditionMasterWritInfo(journalIndex, 1, 1)
	    if encodedAlchemyTraits and curCount < maxCount then
	        alchemyInfo =
	        {
	            basePotionItemId = itemId,
	            materialItemId = materialItemId,
	            encodedTraits = encodedAlchemyTraits,
	            isMasterWrit = true
	        }
	    else
	        craftingQuestIndices.alchemyInfo =
	        {
	            hasDesiredPotion = curCount >= maxCount
	        }
	    end
	else
	end
	--[[
 GetAlchemyResultingItemIdIfKnown(Bag solventBagId, integer solventSlotIndex, Bag reagent1BagId, integer reagent1SlotIndex, Bag reagent2BagId, integer reagent2SlotIndex, Bag:nilable reagent3BagId, integer:nilable reagent3SlotIndex, integer:nilable desiredEncodedTraits)
Returns: integer:nilable resultingItemId
Search on ESOUI Source Code GetAlchemyResultingItemInfo(Bag solventBagId, integer solventSlotIndex, Bag reagent1BagId, integer reagent1SlotIndex, Bag reagent2BagId, integer reagent2SlotIndex, Bag:nilable reagent3BagId, integer:nilable reagent3SlotIndex)
Returns: string name, textureName icon, integer stack, integer sellPrice, bool meetsUsageRequirement, EquipType equipType, integer itemStyleId, ItemDisplayQuality displayQuality, ProspectiveAlchemyResult prospectiveAlchemyResult
Search on ESOUI Source Code GetAlchemyResultingItemLink(Bag solventBagId, integer solventSlotIndex, Bag reagent1BagId, integer reagent1SlotIndex, Bag reagent2BagId, integer reagent2SlotIndex, Bag:nilable reagent3BagId, integer:nilable reagent3SlotIndex, LinkStyle linkStyle)
Returns: string link, ProspectiveAlchemyResult prospectiveAlchemyResult

	]]

	local predicate = ZO_Alchemy_IsAlchemyItem
	local list = PLAYER_INVENTORY:GenerateListOfVirtualStackedItems(INVENTORY_BACKPACK, predicate)
	PLAYER_INVENTORY:GenerateListOfVirtualStackedItems(INVENTORY_BANK, predicate, list)
	PLAYER_INVENTORY:GenerateListOfVirtualStackedItems(INVENTORY_CRAFT_BAG, predicate, list)
	-- ALCHEMY:UpdatePotentialQuestItems(list, alchemyInfo)
	WritCreater.alchemyList = list
	-- local itemType = 

	-- now we have our list
	local questItems = {}
	if not isMasterWrit then
		questItems = searchDailyCombos(journalIndex)
		if not questItems then
			WritCreater.writCompleteUIHandle()
			return
		end
	end
	local reagents = questItems.reagents
	local solvent = questItems.solvent
	if not isMasterWrit then
		local itemId, materialItemId = GetQuestConditionItemInfo(journalIndex, 1, 1)
		if ZO_IsTableEmpty(reagents) or not solvent then
			out("Could not find a known reagent combo. Try learning or acquiring more alchemy items")
			return
		end
		WritCreater.alchemyWrit(solvent, reagents, itemId, craftingWrits)
		return
	end
end
WritCreater.startAlchemy = startAlchemy
-- |H1:item:119703:5:1:0:0:0:199:8:11:15:0:0:0:0:0:0:0:0:0:0:50000|h|h
-- |H1:item:119701:5:1:0:0:0:239:27:1:4:0:0:0:0:0:0:0:0:0:0:20000|h|h

local typeMap = 
{
	[64501] = "potion",
	[75365] = "poison",
}

local function queueAlchemyMasterWrit(solvent, r1, r2, r3, quantity, reference, name)
	WritCreater.LLCInteractionMaster:cancelItemByReference(reference)
	WritCreater.LLCInteractionMaster:CraftAlchemyItemId(solvent, r1, r2, r3, quantity, true, reference)
	local type = typeMap[solvent]

	-- local resultLink = LLC_GetEnchantingResultItemLinkByAttributes(true, level, itemId, quality)
	d(zo_strformat("<<t:1>>: Crafting a <<t:2>> using <<t:3>>, <<t:4>>, and <<t:5>>", name, type, getItemLinkFromItemId(r1), getItemLinkFromItemId(r2), getItemLinkFromItemId(r3)))

end


local function checkCombo(effect1, effect2, effect3, r1, r2, r3)
	local result, numTraits = determinePotionResult(r1, r2, r3)
	if numTraits < 3 then
		return false
	end
	local p1 = (effect1 % 2 == 0) and -1 or 1
	local e1 = effect1 + ((effect1 % 2 == 0) and -1 or 0)
	local p2 = (effect2 % 2 == 0) and -1 or 1
	local e2 = effect2 + ((effect2 % 2 == 0) and -1 or 0)
	local p3 = (effect3 % 2 == 0) and -1 or 1
	local e3 = effect3 + ((effect3 % 2 == 0) and -1 or 0)
	local e1Match = result[e1] == p1
	local e2Match = result[e2] == p2
	local e3Match = result[e3] == p3
	return e1Match and e2Match and e3Match
end

local function findMasterWritReagents(materialId, effect1, effect2, effect3)
	local shortList = getShortlist(effect1, effect2, effect3)
	local r1, r2, r3
	for r1, _ in pairs(shortList) do
		for r2, _ in pairs(shortList) do
			if r1 ~= r2 then
				for r3, _ in pairs(shortList) do
					if r1 ~= r3 and r2 ~= r3 then
						local valid = checkCombo(effect1, effect2, effect3, r1, r2, r3)
						if valid then
							return r1, r2, r3
						end
					end
				end
			end
		end
	end
end


function WritCreater.alchemySealedWrit(bag, slot)
	local itemLink = GetItemLink(bag, slot)
	local x = { ZO_LinkHandler_ParseLink(itemLink) }
	local materialId = tonumber(x[10])
	local effect1 = tonumber(x[11])
	local effect2 = tonumber(x[12])
	local effect3 = tonumber(x[13])
	local r1, r2, r3 = findMasterWritReagents(materialId, effect1, effect2, effect3)
	-- d(getItemLinkFromItemId(r1))
	-- d(getItemLinkFromItemId(r2))
	-- d(getItemLinkFromItemId(r3))
	local solvent
	local quantity
	if materialId == 199 then
		solvent = 64501
		quantity = 4
	else
		solvent = 75365
		quantity = 1
	end
	queueAlchemyMasterWrit(solvent, r1, r2, r3, quantity, itemLink, GetItemLinkName(itemLink))
	-- 
end
-- 395549
local function decodeEffects(encodedTraits)

	local e1 = (math.floor(encodedTraits / 65536) % 64)
	local e2 = (math.floor(encodedTraits / 256) % 64)
	local e3 = (encodedTraits % 64)
	return e1, e2, e3
end

function WritCreater.alchemyMasterQuestAdded(journalIndex, name)
	local _, current, required = GetJournalQuestConditionInfo(journalIndex)
	if current == required then
		return
	end
	local itemId, materialId, _, _, _, _, _, _, encodedTraits =  GetQuestConditionMasterWritInfo(journalIndex)
	local solvent
	local quantity
	if materialId == 199 then
		solvent = 64501
		quantity = 4
	else
		solvent = 75365
		quantity = 1
	end
	local effect1, effect2, effect3 = decodeEffects(encodedTraits)
	local r1, r2, r3 = findMasterWritReagents(materialId, effect1, effect2, effect3)
	queueAlchemyMasterWrit(solvent, r1, r2, r3, quantity, journalIndex, name)
end





	-- WritCreater.reagentList = {}
	-- for k, v in pairs(WritCreater.alchemyList) do
	-- 	local itemType = GetItemType(v.bag, v.index)
	-- 	if not IsAlchemySolvent(itemType) then
	-- 		local link2 = GetItemLinkItemId(GetItemLink(v.bag, v.index))
	-- 		WritCreater.reagentList[link2] = v
	-- 		v.link = link2
	-- 	end
	-- end
	-- for k, v in pairs(WritCreater.reagentList) do
	-- 	for i = 1, 4 do
	-- 		-- v[i] = GetItemLinkReagentTraitInfo(k, i)
	-- 	end
	-- 	local info = {GetAlchemyItemTraits(v.bag, v.index)}
	-- 	v[1] = {info[1], info[4]}
	-- 	v[2] = {info[6], info[9]}
	-- 	v[3] = {info[11], info[14]}
	-- 	v[4] = {info[16], info[19]}
	-- 	for i = 1, 4 do
	-- 		v[i][3] = WritCreater.effectNumbers[v[i][1]]
	-- 		v[i][4] = WritCreater.effectNumbers[v[i][2]]
	-- 		local dif = v[i][3] - v[i][4]
	-- 		if dif ~= 1 and dif ~= -1 then
	-- 			d(dif)
	-- 		end

	-- 	end
	-- end
	-- for k, v in pairs(WritCreater.reagentList) do
	-- 	local out = "["..k.."] = {"
	-- 	for i = 1, 4 do
	-- 		local dif = v[i][3] - v[i][4]
	-- 		if dif == -1 then
	-- 			out = out.."["..v[i][3].."]=1,"
	-- 		else
	-- 			out = out.."["..v[i][4].."]=-1,"
	-- 		end
	-- 	end
	-- 	out = out.."},"
	-- 	-- d(out)
	-- end

-- local a = PLAYER_INVENTORY
-- PLAYER_INVENTORY.b = GenerateListOfVirtualStackedItems
-- local predicate = ZO_Alchemy_IsAlchemyItem
-- local list = a:b(INVENTORY_BACKPACK, predicate)
-- a:b(INVENTORY_BANK, predicate, list)
-- a:b(INVENTORY_CRAFT_BAG, predicate, list)

-- ALCHEMY.owner:UpdatePotentialQuestItems(list, self.alchemyQuestInfo)