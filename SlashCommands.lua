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
local function date()
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
	output = WritCreater.strings.dailyreset(till)
	d(output)
end

-- countSurveys counts how many surveys the user has in their bank and inventory
-- Breaks it down further into types of surveys

local function determineSurveyType(bag, slot, names)
	local name = GetItemName(bag, slot)
	for i = 1, 6 do

		if string.find(name,names[i]) then
			return i
		end
	end
	
	return 7
end

local function countSurveys()
	local names = WritCreater.langWritNames()
	if WritCreater.lang == "fr" then
		names[CRAFTING_TYPE_ALCHEMY] = "enchanteur"
		names[CRAFTING_TYPE_ENCHANTING] = "alchimiste"
	end
    local total = 0
    local i, j, bankNum
    local detailedCount = 
    {
    	[CRAFTING_TYPE_ENCHANTING] = 0,
		[CRAFTING_TYPE_BLACKSMITHING] = 0,
		[CRAFTING_TYPE_CLOTHIER] = 0,
		[CRAFTING_TYPE_PROVISIONING] = 0,
		[CRAFTING_TYPE_WOODWORKING] = 0,
		[CRAFTING_TYPE_ALCHEMY] = 0,
		[7] = 0, -- This is for internal purposes, mainly to bypass if statements checking if a survey type was found. 
	}
    for j, bankNum in ipairs({BAG_BACKPACK, BAG_BANK, BAG_SUBSCRIBER_BANK}) do
        for i = 1, GetBagSize(bankNum) do
            local _,special =  GetItemType(bankNum, i)
            if special ==SPECIALIZED_ITEMTYPE_TROPHY_SURVEY_REPORT then
                local _, count = GetItemInfo(bankNum,i)
                total = total + count
                local surveyType = determineSurveyType(bankNum, i, names)
                detailedCount[surveyType] = detailedCount[surveyType] + count
            end
        end
    end
    d(zo_strformat(WritCreater.strings.countSurveys,total))
    for i = 1, 6 do
    	if detailedCount[i] >0 then
    		d(names[i].." : "..detailedCount[i])
    	end
    end
end

-- countVouchers counts how many unearned vouchers the user has in sealed writs

local function countVouchers()
    local total= 0
    local i, j, bankNum
    for j, bankNum in ipairs({BAG_BACKPACK, BAG_BANK, BAG_SUBSCRIBER_BANK}) do
        for i = 1, GetBagSize(bankNum) do
            local itemType =  GetItemType(bankNum, i)
            if itemType == ITEMTYPE_MASTER_WRIT then
                total = total + WritCreater.toVoucherCount(GetItemLink(bankNum, i))
            end
        end
    end
    d(zo_strformat(WritCreater.strings.countVouchers,total))
    
end

-- outputStats outputs the user's writ rewards in a (mildly) readable fashion

local function outputStats()
	for k, v in pairs(WritCreater.savedVarsAccountWide["rewards"]) do 
		if type(v) == "table" and WritCreater.writNames[k] then
			d("--------------------------------")
			d(WritCreater.writNames[k].." Stats")
			for statType, stats in pairs(v) do 
				if stats==0 then
				elseif type(stats)=="table" then
					for quality, amount in pairs(stats) do
						if amount~=0 then
							d(quality.." recipes: "..amount)
						end
					end
				else
					if type(statType)=="number" then
						d(getItemLinkFromItemId(statType)..": "..tostring(stats))
					else
						d(statType..": "..tostring(stats))
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

-- Resets the user's writ reward statistics

local function resetStats() 
	for k, v in pairs(WritCreater.defaultAccountWide) do
		if k == "masterWrits" then
		else
			WritCreater.savedVarsAccountWide[k] = WritCreater.defaultAccountWide[k]
		end
	end
	WritCreater.savedVarsAccountWide.timeSinceReset = GetTimeStamp() 
	d("Writ statistics reset.")
end

-- Resets the user's character specific settings

local function resetSettings()
	WritCreater.savedVars = WritCreater.default d("settings reset")
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
		
		WritCreater.savedVars.debug = not WritCreater.savedVars.debug 
		d("Craft Debug is ".. tostring(WritCreater.savedVars.debug))
	end
end

-- Abandons all writs

local function abandonWrits()
	local a = WritCreater.writSearch d("Abandon Ship!!!") for i = 1, 6 do AbandonQuest(a[i]) end
end

-- Outputs the indexes of all the writs the user has. This is another debug function. It has not been used in a while, but 
-- I'm keeping it here just in case. Usecase is to have someone I'm working with to debug stuff use this function
-- NOTE: Does not output locations of master writs.

local function findWrits(params)
	local locations = WritCreater.writSearch()
	for key, index in pairs(locations) do
		d(GetJournalQuestName(index).." has hournal index : "..index)
	end
end--]]


--------------------------------------------------
-- TIME TO RESET
SLASH_COMMANDS['/dailyreset'] = date

--------------------------------------------------
-- COUNTING FUNCTIONS
SLASH_COMMANDS['/countunearnedvouchers'] = countVouchers
SLASH_COMMANDS['/countsurveys'] = countSurveys


--------------------------------------------------
-- WRIT STATISTICS
SLASH_COMMANDS['/outputwritstats'] = outputStats
SLASH_COMMANDS['/resetwritstatistics'] = resetStats

--------------------------------------------------
-- MASTER WRITS
SLASH_COMMANDS['/rerunmasterwrits'] = WritCreater.scanAllQuests
--SLASH_COMMANDS['/craftitems'] = function() WritCreater.LLCInteraction:CraftAllItems() end -- Redundant right now

--------------------------------------------------
-- GENERAL COMMANDS
	-- Resets character specific settings settings
SLASH_COMMANDS['/resetwritcraftersettings'] = resetSettings
SLASH_COMMANDS['/resetwcsettings'] = resetSettings
	-- Activates debug mode. Debug mode is not comprehensive.
SLASH_COMMANDS['/dlwcdebug'] = activateDebug
	-- Abandons all currently active writs.
SLASH_COMMANDS['/abandonwrits'] = abandonWrits
	-- Outputs all the writ journal quest IDs. Mainly a debug function
SLASH_COMMANDS['/dlwcfindwrit'] = findWrits



