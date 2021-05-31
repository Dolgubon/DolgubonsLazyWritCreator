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
DolgubonGlobalDebugToggle = false
local localDebugToggle = false

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

-- Sends the saved debug lines
local function sendDebug()
	d("Sending mails")
	local len = string.len(DolgubonDebugRunningDebugString)
	local t = {}
	-- Is this a good way to do it? well no ofc not but it was quickest at the time
	-- At the moment, this function is restricted from use, so I'll keep it as is for now.
	if len<700 then
		RequestOpenMailbox()
		zo_callLater(function() SendMail("@Dolgubon", "WRIT DEBUG OUTPUT", DolgubonDebugRunningDebugString)end , 500)
		DolgubonDebugRunningDebugString = ''
		zo_callLater( CloseMailbox, 1000)
	elseif len<1400 then
		RequestOpenMailbox()
		zo_callLater(function() SendMail("@Dolgubon", "WRIT DEBUG OUTPUT2", string.sub(DolgubonDebugRunningDebugString,700))end , 500)
		zo_callLater(function() SendMail("@Dolgubon", "WRIT DEBUG OUTPUT1", string.sub(DolgubonDebugRunningDebugString,1,700))end , 1500)
		DolgubonDebugRunningDebugString = ""
		zo_callLater( CloseMailbox, 2000)
	else
		RequestOpenMailbox()
		zo_callLater(function() SendMail("@Dolgubon", "WRIT DEBUG OUTPUT3", string.sub(DolgubonDebugRunningDebugString, 1400,2100))end , 500)
		zo_callLater(function() SendMail("@Dolgubon", "WRIT DEBUG OUTPUT2", string.sub(DolgubonDebugRunningDebugString, 700,1400))end , 1500)
		zo_callLater(function() SendMail("@Dolgubon", "WRIT DEBUG OUTPUT1", string.sub(DolgubonDebugRunningDebugString, 1,700))end , 2500)
		DolgubonDebugRunningDebugString = ""
		zo_callLater( CloseMailbox, 3000)
	end

end

local function dbug(...)
	DolgubonGlobalDebugOutput(...)
end

--SLASH_COMMANDS['/senddebug'] = sendDebug
--SLASH_COMMANDS['/sendebug']  = sendDebug
local trackedSealedWrits = {}
--------------------------------------------------
-- HACKING OF USEITEM

---------------------------------------------------
-- MASTER WRITS PROPER


-- Capitalize the first letter, lowercase for the rest
local function proper(str)
	if type(str)== "string" then
		return zo_strformat("<<C:1>>",str)
	else
		return str
	end
end

-- Lowers everything. Uses the ZO function because theirs is more robust

local function myLower(str)
	return zo_strformat("<<z:1>>",str)-- "Rüstung der Verführung^f"
end

-- Remove various special characters, lowers the strings, and removes the dash which messes with string.find.

local function standardizeString(str)
	str = myLower(str)
	str = string.gsub(str,"-"," ")
	str = string.gsub(str,"ä","a")
	str = string.gsub(str,"ü","u")
	str = string.gsub(str,"ö","o")
	return str
end

local function strFind(str, str2find, a, b, c)
	
	str = standardizeString(str)
	str2find = standardizeString(str2find)
	return string.find(str, str2find, a, b, c)


end

local weaponTraits ={}
local armourTraits = {}
------------------------------------
-- TRAIT DECLARATION

-- Run once on addon load. Grabs the name of traits and the trait constant


armourTraits = {}
weaponTraits ={}
for i = 0, 8 do --create the weapon trait table
	--Takes the strings starting at SI_ITEMTRAITTYPE0 == no trait, # 897 to SI_ITEMTRAITTYPE8 === Divines, #905
	--Then saves the proper trait index used for crafting to it. The offset of 1 is due to ZOS; the offset of STURDY is so they start at 12
	weaponTraits[i + 1] = {[2]  = i + 1, [1] = myLower(GetString(SI_ITEMTRAITTYPE0 + i)),}
end


for i = 0, 7 do --create the armour trait table
	--Takes the strings starting at SI_ITEMTRAITTYPE11 == Sturdy, # 908 to SI_ITEMTRAITTYPE18 === Divines, #915
	--Then saves the proper trait index used for crafting to it. The offset of 1 is due to ZOS; the offset of STURDY is so they start at 12
	armourTraits[i + 1] = {[2] = i + 1 + ITEM_TRAIT_TYPE_ARMOR_STURDY, [1] = myLower(GetString(SI_ITEMTRAITTYPE11 + i))}
end
--Add a few missing traits to the tables - i.e., nirnhoned, and no trait
armourTraits[#armourTraits + 1] = {[2] = ITEM_TRAIT_TYPE_NONE + 1, [1] = myLower(GetString(SI_ITEMTRAITTYPE0))} -- No Trait to armour traits
armourTraits[#armourTraits + 1] = {[2] = ITEM_TRAIT_TYPE_ARMOR_NIRNHONED + 1, [1] = myLower(GetString(SI_ITEMTRAITTYPE26))} -- Nirnhoned
weaponTraits[#weaponTraits + 1] = {[2] = ITEM_TRAIT_TYPE_WEAPON_NIRNHONED + 1, [1] = myLower(GetString(SI_ITEMTRAITTYPE25))}  -- Nirnhoned

-- Deals with styles and style constants

styles = {}
for i = 1, GetNumValidItemStyles() do
	local styleItemIndex = GetValidItemStyleId(i)
	local itemName = GetItemStyleName(styleItemIndex)
	styles[#styles + 1] = {itemName,styleItemIndex }
end

-- Input:
--	table: {{ string traitName, traitItemId }...}
--	string journalQuestCondition
-- Output:
--	nilable table: {string matchingTraitName, matchingTraitItemId}

local function enchantSearch(info,condition)
	for i = 1, #info do
		if strFind(condition, info[i][1]) then
			
			return info[i]
		end

	end

	return nil
end

-- Checks if all the traits of the glyph required were found. If one is not found, outputs an error message to chat.

local function foundAllEnchantingRequirements(essence, potency, aspect)
	if not WritCreater.langIsMasterWritSupported then return false end
	local foundAll = true
	if not essence then
		foundAll = false
		d("Error: Essence/Effect not found")
	end
	if not potency then
		foundAll = false
		d("Error: Level not found")
	end
	if not aspect or aspect[1]=="" then
		foundAll = false
		d("Error: Quality not found")
	end
	return foundAll
end

-- Tells LLC to craft a glyph for the given master writ.
-- Writs can be specified by the journal index or the text of the sealed writ
-- Reference should be the journal index or the uniqueItemId of the sealed writ.

local function EnchantingMasterWrit(journalIndex, sealedText, reference)
	--d(journalIndex, sealedText, reference)
	dbug("FUNCTION:EnchantingMasterHandler")
	if not reference then reference = journalIndex end
	
	local condition, complete
	if sealedText then
		condition, complete = sealedText, false
	else
		condition, complete, outOf = GetJournalQuestConditionInfo(journalIndex, 1)
	end
	-- If it's a journal quest and the quest is complete exit
	if complete == outOf then return end
	-- If the condition is empty exit
	if condition =="" then return end

	local craftInfo = WritCreater.craftInfo[CRAFTING_TYPE_ENCHANTING]

	local essence = enchantSearch(craftInfo["pieces"], condition)
	local potency = enchantSearch(craftInfo["match"], condition)
	local aspect = enchantSearch(craftInfo["quality"], condition)

	if foundAllEnchantingRequirements(essence, potency, aspect) then
		local lvl = potency[1]
		-- Output what we're making.
		if potency[1]=="truly" then lvl = "truly superb" end
		-- Actually add the glyph to the queue
		
		d(WritCreater.strings.masterWritEnchantToCraft( lvl, essence[1], aspect[1],
			WritCreater.langWritNames()[CRAFTING_TYPE_ENCHANTING],
			WritCreater.langMasterWritNames()["M1"],
			WritCreater.langWritNames()["G"]))
		if not WritWorthy then 
			d("The Master Writ crafting feature of Dolgubon's Lazy Writ Crafter will no longer be supported. Please download and use Writ Worthy by Ziggr from Minion or Esoui if you wish to do Master Writs.")
		end

		WritCreater.LLCInteractionMaster:CraftEnchantingItemId(potency[2][essence[3]], essence[2], aspect[2], true, reference)

		dbug("CALL:LLCENchantCraft")
		
	else
	end
end

-- Smithing Search function

-- Input: string condition, table info {{itemName, itemValue}...}
-- Outputs a table of {itemName, itemValue}. The output is the pair for the longest itemName found in the condition

-- TODO: Change the function so that it finds the longest string in one pass only, without the if statements at the end.

-- debug is used so that I can output a specific d() but only for one call of the function (e.g. when we're looking for quality)
local function smithingSearch(condition, info, debug)

	--if debug then d(info) end
	-- Inital run through: Check to see if each itemName is found in the condition. Save it to a placeholder table
	local matches = {}
	for i, v in pairs(info) do
		local str = string.gsub(info[i][1], "-"," ")
		if strFind(condition, str) then
			matches[#matches+1] = {info[i] , i}
		end
	end
	-- Check the matches. If no matches return a default value
	-- If one match, return that.
	-- If two or more matches, find the longest one.
	if #matches== 0 then
		return {"",0} , -1
	elseif #matches==1 then
		return matches[1][1], matches[1][2]
	else
		local longest = 0
		local position = 0
		for i = 1, #matches do
			if ZoUTF8StringLength(matches[i][1][1])>longest then
				longest = ZoUTF8StringLength(matches[i][1][1])
				position = i
			end
		end
		return matches[position][1], matches[position][2]
	end

end

-- Checks to see if all the parameters are valid

local function foundAllRequirements(pattern, style, setIndex, trait, quality)
	local foundAllRequirements = true
	if setIndex==-1 then 
		foundAllRequirements = false
		d("Set not found") 
	end
	if pattern[1] =="" then 
		foundAllRequirements = false
		d("Pattern not found")
	end
	if trait[1]=="" then
		foundAllRequirements = false
		d("Trait not found")
	end
	if style[1]=="" then
		foundAllRequirements = false
		d("Style not found")
	end
	if quality[1]=="" then
		foundAllRequirements = false
		d("Quality not found")
	end
	return foundAllRequirements
end

local function germanRemoveEN (str)
	str = standardizeString(str)
	return string.sub(str, 1 , string.len(str) - 2)

end


-- Split the quest condition up into parts, each of which contains one writ requirement.
-- This will help to reduce false positives. Probably doesn't reduce it by much, but it gives me
-- more peace of mind
local function splitCondition(condition, isQuest)
	local seperator = "A"
	if isQuest or WritCreater.lang=="de" then seperator = "\n" else seperator = ";" end
	local a = 1
	local t = {}
	while strFind(condition , seperator) and a<50 do
		a = a+1
		t[#t+1] = string.gsub(string.sub(condition, 1, strFind(condition, seperator)),"\n","")
		condition = string.sub(condition, strFind(condition,seperator) + 1, string.len(condition) ) 
		if string.len(t[#t])<5 then t[#t] = nil end
	end
	t[#t+1] = condition
	if WritCreater.lang =="de" and not isQuest then table.remove(t, 1 ) end
	return unpack(t)
end

-- Adds a master writ crafting request to the LLC queue
-- Either journalIndex, or sealedText and reference must be passed. The reference should be 
-- either the journalquestindex or the unique itemid of the sealed writ.
-- table info is {{itemName, itemValue}...}
-- station is the station that the writ is associated with (or a best guess for woodworking/blacksmithing weapons)
-- isArmour is a boolean
-- material is the string name of the material used. Not necessary; will be used for output only


local function SmithingMasterWrit(journalIndex, info, station, isArmour, material, reference, sealedText)
	dbug("FUNCTION:SmithingMasterHandler")
	-- If this is nil, then the language the game is currently in is not supported.
	if not WritCreater.masterWritQuality then d("Language not supported for Master Writs") return end 
	if WritCreater.lang == "de" then for i = 1, #info do  info[i][1] = germanRemoveEN(info[i][1])   end end
	local condition, complete =GetJournalQuestConditionInfo(journalIndex, 1)
	condition = standardizeString(condition)
	local isQuest = true
	-- if the sealedText was passed then it's not a journal quest
	if sealedText then
		isQuest = false
		condition, complete = sealedText, false
	else
	if WritCreater.savedVarsAccountWide[6697110] then return -1 end -- no comment
	end
	-- Text condition value
	--"Craft a Rubedite Greataxe with the following Properties:\n • Quality: Epic\n • Trait: Powered\n • Set: Oblivion's Foe\n • Style: Imperial\n • Progress: 0 / 1", false--
	condition = string.gsub(condition, "-" , " ")

	if complete == 1 then return end
	if condition =="" then return end
	local conditionStrings = {}
	local a= splitCondition(condition, isQuest)
	-- The order of the conditions are different in German for some reason.
	if WritCreater.lang =="de" then
		conditionStrings["pattern"], conditionStrings["set"], conditionStrings["style"],
		  conditionStrings["trait"], conditionStrings["quality"] = splitCondition(condition, isQuest)
	else
		conditionStrings["pattern"], conditionStrings["quality"], conditionStrings["trait"],
		  conditionStrings["set"], conditionStrings["style"] = splitCondition(condition, isQuest)
	end

	--for k, v in pairs(conditionStrings) do
	--	d(k, v)
	--end
	--d(conditionStrings["pattern"])
	local pattern =  smithingSearch(conditionStrings["pattern"], info) --search pattern

	-- If armour, uses one trait table, otherwise uses the weapont trait table
	local trait
	if isArmour then
		trait = smithingSearch(conditionStrings["trait"], armourTraits )
	else
		trait = smithingSearch(conditionStrings["trait"], weaponTraits)
	end
	local style = smithingSearch(conditionStrings["style"], styles)
	local _,setIndex = smithingSearch(conditionStrings["set"], GetSetIndexes())
	
	local quality = smithingSearch(conditionStrings["quality"],WritCreater.masterWritQuality()) --search quality

	if foundAllRequirements(pattern, style, setIndex, trait, quality) then
		-- too many variable stuff so need to do multiple calls to zo_strformat
		d(WritCreater.strings.masterWritSmithToCraft(
			pattern[1], 
			GetSetIndexes()[setIndex][1],
			trait[1],
			style[1], 
			quality[1],
			material,
			WritCreater.langWritNames()[station],
			WritCreater.langMasterWritNames()["M1"],
			WritCreater.langWritNames()["G"]
			))
		if not WritWorthy then 
			d("The Master Writ crafting feature of Dolgubon's Lazy Writ Crafter will no longer be supported. Please download and use Writ Worthy by Ziggr from Minion or Esoui if you wish to do Master Writs.")
		end
		dbug("CALL:LLCCraftSmithing")
		-- Cancel any previously added items with the same reference so we don't craft twice
		WritCreater.LLCInteractionMaster:cancelItemByReference(reference)
		-- Add to queue
		WritCreater.LLCInteractionMaster:CraftSmithingItemByLevel( pattern[2], true , 150, style[2], trait[2], false, station, setIndex, quality[2], true, reference)
		return true
	else
		dbug("ERROR:RequirementMissing")
	end
end

-- Since some of the info tables are not in the proper format, this changes it so that they are:
-- Input table:
--{  [itemTraitValue] = "itemtraitString"}
-- output:
-- { [1] = {"itemTraitString", itemTraitValue}}

local function keyValueTable(t)
	local temp = {}
	for k, v in pairs(t) do

		temp[#temp + 1] = {myLower(v),k}

	end
	return temp
end

-- Cuts a table, from start to ending
-- start inclusive

local function partialTable(t, start, ending)

	local temp = {}
	for i = start or 1, ending or #t do 
		temp[i] = t[i]
	end
	return temp
end

--/script for 1, 25 do if GetJournalQuestName(i) == "A Masterful Weapon" then d(i, GetJournalQuestConditionInfo(i,1,1))  end end
--QuestID: 1

-- Called when the player receives a new quest. Determines if the quest is a master writ, and if so, which craft and if it is a weapon or armour or glyph.


function WritCreater.MasterWritsQuestAdded(event, journalIndex,name)
	if not WritCreater.langMasterWritNames or not WritCreater.savedVarsAccountWide.masterWrits then return end
	local writNames = WritCreater.langMasterWritNames()
	local isMasterWrit = false
	local writType = ""
	for k, v in pairs(writNames) do
		if strFind(name, v) then
			if k == "M" then
				isMasterWrit = true
			elseif k == "M1" then
			else
				writType = k
			end

		end
	end
	--if not isMasterWrit then return end
	if not isMasterWrit then return end
	dbug("FUNCTION:MasterWritStart")
	local langInfo = WritCreater.languageInfo()
	--local info = {}
	if writType =="" then 
		return
	else
		
		if writType=="weapon" then

			local info = partialTable(langInfo[CRAFTING_TYPE_BLACKSMITHING]["pieces"] , 1, 7)
			info = keyValueTable(info)
			table.insert(info, {"greataxe",4})
			--local patternBlacksmithing =  smithingSearch(condition, info) --search pattern

			if SmithingMasterWrit(journalIndex, info, CRAFTING_TYPE_BLACKSMITHING, false, "Rubedite",journalIndex) then
				return
			end

			info = partialTable(langInfo[CRAFTING_TYPE_WOODWORKING]["pieces"] , 1, 6)
			info = keyValueTable(info)

			SmithingMasterWrit(journalIndex, info, CRAFTING_TYPE_WOODWORKING, false, "Ruby Ash",journalIndex)

		elseif writType == CRAFTING_TYPE_ALCHEMY then
		elseif writType == CRAFTING_TYPE_ENCHANTING then
			EnchantingMasterWrit(journalIndex)
		elseif writType == CRAFTING_TYPE_PROVISIONING then
		elseif writType == "shield" then
			local info = {{"shield",2}}

			if WritCreater.lang=="de" then info[1][1] ="schilden" end
			if WritCreater.lang=="fr" then info[1][1] = "bouclier" end
			SmithingMasterWrit(journalIndex, info, CRAFTING_TYPE_WOODWORKING, true, "Ruby Ash",journalIndex)
		elseif writType == "plate" then
			local info = partialTable(langInfo[CRAFTING_TYPE_BLACKSMITHING]["pieces"] , 8, 14)
			info = keyValueTable(info)

			SmithingMasterWrit(journalIndex, info, CRAFTING_TYPE_BLACKSMITHING, true, "Rubedite",journalIndex)
		elseif writType == "leatherwear" then
			local info = partialTable(langInfo[CRAFTING_TYPE_CLOTHIER]["pieces"] , 9, 15)
			info = keyValueTable(info)
			SmithingMasterWrit(journalIndex, info, CRAFTING_TYPE_CLOTHIER, true, "Rubedo Leather",journalIndex)
		elseif writType == "tailoring" then

			local info = partialTable(langInfo[CRAFTING_TYPE_CLOTHIER]["pieces"] , 1, 8)
			info = keyValueTable(info)
			SmithingMasterWrit(journalIndex, info, CRAFTING_TYPE_CLOTHIER, true, "Ancestor Silk",journalIndex)
		end

	end

end

local function QuestCounterChanged(event, journalIndex, questName, _, _, currConditionVal, newConditionVal, conditionMax)
	dbug("EVENT:Quest Counter Change")
	if not WritCreater.LLCInteractionMaster then return end
	if #WritCreater.LLCInteractionMaster:findItemByReference(journalIndex) == 0 then
		WritCreater.LLCInteractionMaster:cancelItemByReference(journalIndex)
		if newConditionVal<conditionMax then
			
			WritCreater.MasterWritsQuestAdded(event, journalIndex, questName)
		end
	end
end


--EVENT_QUEST_ADDED found in AlchGrab File
EVENT_MANAGER:RegisterForEvent(WritCreater.name,EVENT_QUEST_CONDITION_COUNTER_CHANGED , QuestCounterChanged)

function WritCreater.scanAllQuests()
	if not WritCreater.LLCInteractionMaster then return end
	WritCreater.LLCInteractionMaster:cancelItem()
	dbug("FUNCTION:scanAllQuests")
	for i = 1, 25 do WritCreater.MasterWritsQuestAdded(1, i,GetJournalQuestName(i)) end
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
	
    local exampleSealedWrits = {
    [CRAFTING_TYPE_CLOTHIER] = "|H1:item:121532:6:1:0:0:0:26:194:5:178:15:34:0:0:0:0:0:0:0:0:883200|h|h",
    [CRAFTING_TYPE_BLACKSMITHING] = "|H1:item:119680:6:1:0:0:0:47:188:4:240:12:29:0:0:0:0:0:0:0:0:56375|h|h",
    [CRAFTING_TYPE_WOODWORKING] = "|H1:item:119682:6:1:0:0:0:65:192:4:95:14:47:0:0:0:0:0:0:0:0:63250|h|h",
    [CRAFTING_TYPE_ENCHANTING] = "|H1:item:121528:6:1:0:0:0:26581:225:5:0:0:0:0:0:0:0:0:0:0:0:66000|h|h",
	}
	local writText = GenerateMasterWritBaseText(link)
	local station

	for k, v in pairs(exampleSealedWrits) do
		if GetItemLinkName(link) == GetItemLinkName(v) then
			station = k
		end
	end
	if not station then return end
    -- Check if you can find "Blacksmithing, Clothing Woodworking or Enchanting"
    -- Search for if it is armour or not
    if not WritCreater.savedVarsAccountWide.rightClick or not LibCustomMenu then return end
    zo_callLater(function ()
        AddCustomMenuItem("Craft Sealed Writ", function ()
            if station == CRAFTING_TYPE_ENCHANTING then
            	EnchantingMasterWrit(nil, writText,  GetItemUniqueId(bag, slot))
            else
            	local langInfo = WritCreater.languageInfo()
            	local material = ""
            	local info = partialTable(langInfo[station]["pieces"])
				info = keyValueTable(info)
				local isArmour
				if station == CRAFTING_TYPE_BLACKSMITHING then
					if flavour == GetItemLinkFlavorText(exampleSealedWrits[CRAFTING_TYPE_BLACKSMITHING]) then
						isArmour = true
					end
					material = "Rubedite"
					table.insert(info, {"greataxe",4})
				elseif station == CRAFTING_TYPE_WOODWORKING then
					if flavour == GetItemLinkFlavorText(exampleSealedWrits[CRAFTING_TYPE_WOODWORKING]) then
						isArmour = true
					end
					table.insert(info,{"healing",6}) 
					table.insert(info,{"frost",4}) 

					material = "Ruby Ash"
				elseif station == CRAFTING_TYPE_CLOTHIER then

					if flavour == GetItemLinkFlavorText(exampleSealedWrits[CRAFTING_TYPE_CLOTHIER]) then
						material = "Ancestor Silk"
					else
						material = "Rubedo Leather"
					end
					isArmour = true
				end
				SmithingMasterWrit(nil, info, station, isArmour, material, GetItemUniqueId(bag, slot), writText)
            end
            trackedSealedWrits[#trackedSealedWrits + 1] = {bag, slot, GetItemUniqueId(bag, slot)}
        end, MENU_ADD_OPTION_LABEL)
        ShowMenu(self)
    end, 50)
end
function WritCreater.InitializeRightClick()
	ZO_PreHook('ZO_InventorySlot_ShowContextMenu', function (rowControl) WritCreater.InventorySlot_ShowContextMenu(rowControl) end)

end

--]]
function WritCreater.checkIfMasterWritWasStarted(...)
	dbug("EVENT:SlotUpdated")
end



EVENT_MANAGER:RegisterForEvent(WritCreater.name, EVENT_ADD_ON_LOADED, WritCreater.OnAddOnLoaded)





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

