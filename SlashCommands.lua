-- /abaondwrits removed


local function date(stamp)
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
	WritCreater.strings.dailyreset(till)
end

local function resetTime()
	date(GetTimeStamp())

end

local function countSurveys()
    local a = 0
    local i, j, bankNum
    for j, bankNum in ipairs({BAG_BACKPACK, BAG_BANK, BAG_SUBSCRIBER_BANK}) do
        for i = 1, GetBagSize(bankNum) do
            local _,special =  GetItemType(bankNum, i)
            if special ==SPECIALIZED_ITEMTYPE_TROPHY_SURVEY_REPORT then
                local _, count = GetItemInfo(bankNum,i)
                a = a + count
            end
        end
    end
    d("You have "..tostring(a).." surveys.")
end



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
    d("You have "..tostring(total).." unearned Writ Vouchers.")
end

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

local function resetSettings()
	WritCreater.savedVars = WritCreater.default d("settings reset")
end

local function activateDebug()
	WritCreater.savedVars.debug = not WritCreater.savedVars.debug d(WritCreater.savedVars.debug) 
end

local function abandonWrits()
	local a = WritCreater.writSearch d("Abandon Ship!!!") for i = 1, 6 do AbandonQuest(a[i]) end
end

local function findWrits(params)
	local locations = WritCreater.writSearch()
	for key, index in pairs(locations) do
		d(GetJournalQuestName(index).." has hournal index : "..index)
	end
end--]]

--------------------------------------------------
-- TIME TO RESET
SLASH_COMMANDS['/dailyreset'] = resetTime

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
SLASH_COMMANDS['/resetwritcraftersettings'] = resetSettings()
	-- Activates debug mode. Debug mode is not comprehensive.
SLASH_COMMANDS['/dlwcdebug'] = activateDebug
	-- Abandons all currently active writs.
SLASH_COMMANDS['/abandonwrits'] = abandonWrits
	-- Outputs all the writ journal quest IDs. Mainly a debug function
SLASH_COMMANDS['/dlwcfindwrit'] = findWrits