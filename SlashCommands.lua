-----------------------------------------------------------------------------------
-- Addon Name: Dolgubon's Lazy Writ Crafter
-- Creator: Dolgubon (Joseph Heinzle)
-- Addon Ideal: Simplifies Crafting Writs as much as possible
-- Addon Creation Date: March 14, 2016
--
-- File Name: SlashCommands.lua
-- File Description: This file contains all the slash commands in the addon
-- Load Order Requirements: None
-- 
-----------------------------------------------------------------------------------


-- date outputs a string teling the user how long until the daily reset.
-- Note that English and Japanese have support for a slightly more 'fun' version :D
local function dailyReset()
	stamp = GetTimeStamp()
	local date = {}
	local day = 86400
	local hour = 3600
	local till = {}
	stamp = stamp-1451606400
	stamp = stamp%day
	date["hour"] = math.floor(stamp/3600)
	stamp = stamp%hour
	date["minute"] = math.floor(stamp/60)
	stamp = stamp%60
	if date["hour"]>5 then 
		till["hour"] = 24-date["hour"]+5
	else
		till["hour"] = 6- date["hour"] -1
	end
	till["minute"] = 60-date["minute"]
	output = WritCreater.strings.dailyreset(till, stamp)
	d(output)
end

-- countSurveys counts how many surveys the user has in their bank and inventory
-- Breaks it down further into types of surveys

local function determineSurveyType(bag, slot, names)
	local name = GetItemName(bag, slot)
	for i = 1, 7 do

		if string.find(zo_strformat("<<z:1>>",name),zo_strformat("<<z:1>>",names[i])) then
			return i
		end
	end
	if string.find(name, "Jewelry Crafting") then
		return 7
	end

	return 8
end

local bags = {BAG_BANK, BAG_SUBSCRIBER_BANK,BAG_BACKPACK, BAG_HOUSE_BANK_EIGHT ,BAG_HOUSE_BANK_FIVE ,BAG_HOUSE_BANK_FOUR,
	BAG_HOUSE_BANK_ONE ,BAG_HOUSE_BANK_SEVEN ,BAG_HOUSE_BANK_SIX  ,BAG_HOUSE_BANK_THREE ,BAG_HOUSE_BANK_TWO ,}
-- local bags = {BAG_BACKPACK}


local function countSurveys()
	local names = WritCreater.langWritNames()
	if WritCreater.lang == "fr" then
		names[CRAFTING_TYPE_ALCHEMY] = "enchanteur"
		names[CRAFTING_TYPE_ENCHANTING] = "alchimiste"
	end
    local total = 
    {
    	overall = 0,
    	bank = 0,
    	inventory = 0,
    	storage = 0,
    }
    local i, j, bankNum
    local detailedCount = 
    {
    	[CRAFTING_TYPE_ENCHANTING] = 0,
		[CRAFTING_TYPE_BLACKSMITHING] = 0,
		[CRAFTING_TYPE_CLOTHIER] = 0,
		[CRAFTING_TYPE_PROVISIONING] = 0,
		[CRAFTING_TYPE_WOODWORKING] = 0,
		[CRAFTING_TYPE_ALCHEMY] = 0,
		[CRAFTING_TYPE_JEWELRYCRAFTING] = 0,
		[8] = 0, -- This is for internal purposes, mainly to bypass if statements checking if a survey type was found. 
	}
	local storageIncluded = false

	local bagCounts = 
	{
		["bank"] = ZO_DeepTableCopy(detailedCount),
		["inventory"] = ZO_DeepTableCopy(detailedCount),
		["storage"] = ZO_DeepTableCopy(detailedCount),
	}

    for j, bankNum in ipairs(bags) do
        for i = 1, GetBagSize(bankNum) do
            local _,special =  GetItemType(bankNum, i)
            if special ==SPECIALIZED_ITEMTYPE_TROPHY_SURVEY_REPORT then
            	if j > 3 then
            		storageIncluded = true
            	end
                local _, count = GetItemInfo(bankNum,i)
                total.overall = total.overall + count
                local surveyType = determineSurveyType(bankNum, i, names)
                -- d(""..GetItemLink(bankNum, i).." : "..count)
                detailedCount[surveyType] = detailedCount[surveyType] + count
                if surveyType == 8 then
                	d("Could not determine survey type for "..GetItemLink(bankNum, i))
                end
                if bankNum == BAG_BACKPACK then
                	bagCounts["inventory"][surveyType] = bagCounts["inventory"][surveyType] + count
                	total.inventory = total.inventory + count
                elseif bankNum ==  BAG_SUBSCRIBER_BANK or bankNum ==BAG_BANK then
                	bagCounts["bank"][surveyType] = bagCounts["bank"][surveyType] + count
                	total.bank = total.bank + count
                else
                	bagCounts["storage"][surveyType] = bagCounts["storage"][surveyType] + count
                	total.storage = total.storage + count
                end

            end
        end
    end
    if storageIncluded then
    	d(WritCreater.strings.includesStorage(1))
    	d(zo_strformat(WritCreater.strings.countSurveys,total.overall).." (Inventory : "..total["inventory"].." , Bank : "..total["bank"].." Storage : "..total["storage"]..")")
	else
		d(zo_strformat(WritCreater.strings.countSurveys,total.overall).." (Inventory : "..total["inventory"].." , Bank : "..total["bank"]..")")
    end
    
    for i = 1, 7 do
    	if detailedCount[i] >0 then
    		if storageIncluded then
    			d(names[i].." : "..detailedCount[i] .. " (Inventory : "..bagCounts["inventory"][i].." , Bank : "..bagCounts["bank"][i].." Storage : "..bagCounts["storage"][i]..")")
    		else
    			d(names[i].." : "..detailedCount[i] .. " (Inventory : "..bagCounts["inventory"][i].." , Bank : "..bagCounts["bank"][i]..")")
    		end
    	end
    end
end

-- countVouchers counts how many unearned vouchers the user has in sealed writs
local masterWritTextures  = {
	["/esoui/art/icons/master_writ_blacksmithing.dds"] = CRAFTING_TYPE_BLACKSMITHING,   
	["/esoui/art/icons/master_writ_clothier.dds"     ] = CRAFTING_TYPE_CLOTHIER,
	["/esoui/art/icons/master_writ_woodworking.dds"  ] = CRAFTING_TYPE_WOODWORKING,
	["/esoui/art/icons/master_writ_jewelry.dds"      ] = CRAFTING_TYPE_JEWELRYCRAFTING,
	["/esoui/art/icons/master_writ_alchemy.dds"      ] = CRAFTING_TYPE_ALCHEMY,
	["/esoui/art/icons/master_writ_enchanting.dds"   ] = CRAFTING_TYPE_ENCHANTING,
	["/esoui/art/icons/master_writ_provisioning.dds" ] = CRAFTING_TYPE_PROVISIONING,
	["/esoui/art/icons/master_writ-newlife.dds"] 	   = nil,
}


local function countVouchers()

    local total= 0
    local i, j, bankNum
    local craftTotals = {}
    local sealedTotals = {}
    local totalSealed = 0
    for j, bankNum in ipairs(bags) do
        for i = 1, GetBagSize(bankNum) do
            local itemType =  GetItemType(bankNum, i)
            if itemType == ITEMTYPE_MASTER_WRIT then
            	if j > 3 then
            		storageIncluded = true
            	end
            	local numVouchers = WritCreater.toVoucherCount(GetItemLink(bankNum, i))
                total = total + numVouchers
                totalSealed = totalSealed + 1
                local icon = GetItemLinkInfo(GetItemLink(bankNum, i))
                local craft = masterWritTextures[icon]
                if craft then
                	craftTotals[craft] = (craftTotals[craft] or 0) + numVouchers
                	sealedTotals[craft] = (sealedTotals[craft] or 0) + 1
                end
            end
        end
    end
    if storageIncluded then
    	d(WritCreater.strings.includesStorage(2))
    end
    local names = WritCreater.langWritNames()
	if WritCreater.lang == "fr" then
		names[CRAFTING_TYPE_ALCHEMY] = "enchanteur"
		names[CRAFTING_TYPE_ENCHANTING] = "alchimiste"
	end
    for k, v in pairs(craftTotals) do 
    	d(names[k].." : "..v.." ("..sealedTotals[k].." sealed writs)")
    end
    d(zo_strformat(WritCreater.strings.countVouchers,total).." ("..totalSealed.." sealed writs)")
    
end

-- outputStats outputs the user's writ rewards in a (mildly) readable fashion
local function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end


local function outputStats(showChances)
	if not showChances  then
		WritCreater.updateList()
		DolgubonsLazyWritStatsWindow:SetHidden(not DolgubonsLazyWritStatsWindow:IsHidden())
		return
	end
	for k, v in pairs(WritCreater.savedVarsAccountWide["rewards"]) do 
		if type(v) == "table" and WritCreater.writNames[k] then
			d("--------------------------------")
			d(WritCreater.writNames[k].." Stats")
			local numberOfWritType = v.num
			for statType, stats in pairs(v) do 
				if stats==0 then
				elseif type(stats)=="table" then
					for quality, amount in pairs(stats) do
						if amount~=0 then
							if showChances then
								d(quality.." recipes: 1 in "..round(numberOfWritType/amount, 2))
							else
								d(quality.." recipes: "..amount)
							end
						end
					end
				else
					if type(statType)=="number" then
						if showChances then
							d(getItemLinkFromItemId(statType)..": 1 in "..round(numberOfWritType/stats, 2))
						else
							d(getItemLinkFromItemId(statType)..": "..tostring(stats))
						end
					else
						if showChances and statType~="num" then
							d(statType..": 1 in "..round(numberOfWritType/stats, 2))
						else
							d(statType..": "..tostring(stats))
						end
					end
				end
			end
		elseif type(v)=="function" then
		else
			d(k..": "..tostring(v))
		end
	end
	local daysSinceReset = math.floor((GetTimeStamp() - WritCreater.savedVarsAccountWide.timeSinceReset)/86400*100)/100
	d("Total Writs Completed: "..WritCreater.savedVarsAccountWide.total.." in the past "..tostring(daysSinceReset).." days")
end
WritCreater.ShowStatsWindow = function() outputStats(false) end
-- Resets the user's writ reward statistics

local function resetStats() 
	for k, v in pairs(WritCreater.defaultAccountWide) do
		if k == "masterWrits" then
		else
			WritCreater.savedVarsAccountWide[k] = WritCreater.defaultAccountWide[k]
		end
	end
	WritCreater.savedVarsAccountWide.timeSinceReset = GetTimeStamp()
	WritCreater.updateList()
	d("Writ statistics reset.")
end

-- Resets the user's character specific settings

local function resetSettings()
	if WritCreater.savedVars.useCharacterSettings then
		WritCreater.savedVars = WritCreater.default 
	else
		WritCreater.savedVarsAccountWide.accountWideProfile = WritCreater.default
	end

	d("settings reset")
end

-- Activates the debug mode. Debug mode is not comprehensive. It mainly only works in the crafting functions of master writs

local function activateDebug(str)
	if string.lower(str) == "bank" then
		WritCreater.savedVarsAccountWide.bankDebug = not WritCreater.savedVarsAccountWide.bankDebug 
		d("Bank debug is "..tostring( WritCreater.savedVarsAccountWide.bankDebug) )
	elseif string.lower(str) == "delay" then
		WritCreater.savedVarsAccountWide.masterDebugDelay = not WritCreater.savedVarsAccountWide.masterDebugDelay
		d("Delay debug is "..tostring( WritCreater.savedVarsAccountWide.bankDebug) )
	else
		
		WritCreater:GetSettings().debug = not WritCreater:GetSettings().debug 
		d("Craft Debug is ".. tostring(WritCreater:GetSettings().debug))
	end
end

-- Abandons all writs

local function abandonWrits()
	local a = WritCreater.writSearch() d("Abandon Ship!!!") for i = 1, 7 do AbandonQuest(a[i]) end
end

-- Outputs the indexes of all the writs the user has. This is another debug function. It has not been used in a while, but 
-- I'm keeping it here just in case. Usecase is to have someone I'm working with to debug stuff use this function
-- NOTE: Does not output locations of master writs.

local function findWrits(params)
	local locations = WritCreater.writSearch()
	for key, index in pairs(locations) do
		d(GetJournalQuestName(index).." has journal index : "..index)
	end
end--]]

local function activateStatWindowDebug()
	WritCreater:GetSettings().debugMode = not WritCreater:GetSettings().debugMode
end
local function goToTranslationSite()
	RequestOpenUnsafeURL(WritCreater.needTranslations)
end

--------------------------------------------------
-- TIME TO RESET
SLASH_COMMANDS['/dailyreset'] = dailyReset

--------------------------------------------------
-- COUNTING FUNCTIONS
SLASH_COMMANDS['/countunearnedvouchers'] = countVouchers
SLASH_COMMANDS['/countsurveys'] = countSurveys


--------------------------------------------------
-- WRIT STATISTICS
SLASH_COMMANDS['/outputwritstats'] = function() outputStats(false) end
SLASH_COMMANDS['/writstats'] = function() outputStats(false) end
SLASH_COMMANDS['/lazywritstats'] = function() outputStats(false) end
SLASH_COMMANDS['/dolgubonlazywritstats'] = function() outputStats(false) end
SLASH_COMMANDS['/outputwritchances'] = function() outputStats(true) end
SLASH_COMMANDS['/resetwritstatistics'] = resetStats

--------------------------------------------------
-- MASTER WRITS
SLASH_COMMANDS['/rerunmasterwrits'] = WritCreater.scanAllQuests
--SLASH_COMMANDS['/craftitems'] = function() WritCreater.LLCInteraction:CraftAllItems() end -- Redundant right now

--------------------------------------------------
-- GENERAL COMMANDS
	-- Resets character specific settings settings
SLASH_COMMANDS['/resetwritcraftersettings'] = WritCreater.resetSettings
	-- Activates debug mode. Debug mode is not comprehensive.
SLASH_COMMANDS['/dlwcdebug'] = activateDebug
SLASH_COMMANDS['/dlwcstatwindowdebug'] = activateStatWindowDebug
	-- Abandons all currently active writs.
SLASH_COMMANDS['/abandonwrits'] = abandonWrits
	-- Outputs all the writ journal quest IDs. Mainly a debug function
SLASH_COMMANDS['/dlwcfindwrit'] = findWrits

if WritCreater.needTranslations and GetTimeStamp()<1590361774 then
	SLASH_COMMANDS['/writcraftertranslations'] = goToTranslationSite
end
if GetDisplayName() == "@Dolgubon" then
	SLASH_COMMANDS['/loothirelings'] = function() SLASH_COMMANDS['/dcsbar']("lootmail") end
end

-- local bags2 = {BAG_BANK, BAG_SUBSCRIBER_BANK,BAG_BACKPACK, BAG_HOUSE_BANK_EIGHT ,BAG_HOUSE_BANK_FIVE ,BAG_HOUSE_BANK_FOUR,
-- 	BAG_HOUSE_BANK_ONE ,BAG_HOUSE_BANK_SEVEN ,BAG_HOUSE_BANK_SIX  ,BAG_HOUSE_BANK_THREE ,BAG_HOUSE_BANK_TWO ,}
-- local function newBagTable()
-- return  { [BAG_HOUSE_BANK_EIGHT]={} ,[BAG_HOUSE_BANK_FIVE]={} ,[BAG_HOUSE_BANK_FOUR]={},
-- 	[BAG_HOUSE_BANK_ONE] ={},[BAG_HOUSE_BANK_SEVEN]={} ,[BAG_HOUSE_BANK_SIX] ={} ,[BAG_HOUSE_BANK_THREE] ={},[BAG_HOUSE_BANK_TWO]={} ,}
-- end
-- function reregister()
-- SCENE_MANAGER.scenes.houseBank.RegisterCallback("StateChange",   function(oldState, newState)
--                                                     if newState == SCENE_SHOWING then
--                                                         --initialize the slots and banking bag fresh here since there are many different house bank bags and only one is active at a time
--                                                         local inventory = self.inventories[INVENTORY_HOUSE_BANK]
--                                                         local bankingBag = GetBankingBag()
--                                                         inventory.slots = newBagTable()
--                                                         inventory.backingBags = bags2
--                                                         self:RefreshAllInventorySlots(INVENTORY_HOUSE_BANK)
--                                                         self:UpdateFreeSlots(INVENTORY_HOUSE_BANK)
--                                                         self:UpdateFreeSlots(INVENTORY_BACKPACK)
--                                                         houseBankFragmentBar:SelectFragment(SI_BANK_WITHDRAW)
--                                                         TriggerTutorial(TUTORIAL_TRIGGER_HOME_STORAGE_OPENED)
--                                                     elseif newState == SCENE_HIDDEN then
--                                                         ZO_InventorySlot_RemoveMouseOverKeybinds()
--                                                         ZO_PlayerInventory_EndSearch(ZO_HouseBankSearchBox)
--                                                         houseBankFragmentBar:Clear()
--                                                         --Wipe out the inventory slot data and connection to a bag
--                                                         local inventory = self.inventories[INVENTORY_HOUSE_BANK]
--                                                         inventory.slots = nil
--                                                         inventory.backingBags = nil
--                                                         inventory.hasAnyQuickSlottableItems = nil
--                                                     end
--                                                 end)
-- end
-- reregister()