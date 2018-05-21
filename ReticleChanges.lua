
if not WritCreater.langStationNames then return end
local stations = WritCreater.langStationNames()
local originalReticleFunction = ZO_ReticleContainerInteractContext.SetText
local deliverText = WritCreater.writCompleteStrings()["Deliver"]

local function isQuestComplete(questIndex, numConditions)
	local numConditions = GetJournalQuestNumConditions(questIndex)
	for i = 1, numConditions do

		local cur, max =  GetJournalQuestConditionValues(questIndex,1,i)

		local s = GetJournalQuestConditionInfo(questIndex,1,i)

		if string.find(s, deliverText) then  return true
		end
	end
	return false
end


local function setupReplacement(object, functionName)

	local original = object[functionName]
	object[functionName] = function(self, text)
	-- If the setting is off exit

	if not WritCreater:GetSettings().changeReticle then  original(self, text) return end
		-- if not a station exit
		local craftingType = stations[text]
		if not craftingType then  original(self, text) return end

		-- Otherwise, do we have a writ on?
		local writs = WritCreater.writSearch()
		if writs[craftingType] then

			-- we have a writ. Do we need the reticle green or red
			if isQuestComplete(writs[craftingType]) or GetJournalQuestIsComplete(writs[craftingType]) then
				text = "|c66ff66"..text.."|r"
			else
				text = "|cff6666"..text.."|r"
			end

			original(self, text)
		else
			original(self, text)
		end
	end
end

setupReplacement(ZO_ReticleContainerInteractContext, "SetText")
