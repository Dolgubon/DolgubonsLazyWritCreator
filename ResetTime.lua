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

function WritCreater.resetTime()
	date(GetTimeStamp())

end

local function CountSurveys()
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

SLASH_COMMANDS['/countsurveys'] = CountSurveys