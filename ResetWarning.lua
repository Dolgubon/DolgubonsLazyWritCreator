
local function dailyReset()
  local currentTime, secondsSinceMidnight = GetTimeStamp(), GetSecondsSinceMidnight()
  local midnightToday = currentTime - secondsSinceMidnight
  local midnightTomorrow = midnightToday + ZO_ONE_DAY_IN_SECONDS
  local cutoffOffset
  if GetWorldName() == 'NA Megaserver' then cutoffOffset = (6 * ZO_ONE_HOUR_IN_SECONDS) -- 06:00
  else cutoffOffset = (3 * ZO_ONE_HOUR_IN_SECONDS) end -- 03:00
  local resetTimeToday = midnightToday + cutoffOffset
  local resetTimeTomorrow = midnightTomorrow + cutoffOffset
  local secondsRemainingUntilReset
  local hasReset = currentTime >  resetTimeToday
  if hasReset then secondsRemainingUntilReset = resetTimeTomorrow - currentTime
  else secondsRemainingUntilReset = resetTimeToday - currentTime end

  local hours = math.floor(math.modf(secondsRemainingUntilReset / ZO_ONE_HOUR_IN_SECONDS))
  local remainingSeconds = secondsRemainingUntilReset - (hours * ZO_ONE_HOUR_IN_SECONDS)
  local minutes, remainder = math.modf(remainingSeconds / ZO_ONE_MINUTE_IN_SECONDS)
  if remainder > 0.5 then minutes = minutes + 1 end
  return hours, minutes
end

-- local msg = {}
-- msg.GetCategory = function () return CSA_CATEGORY_LARGE_TEXT end--CSA_CATEGORY_MAJOR_TEXT, CSA_CATEGORY_RAID_COMPLETE_TEXT
-- msg.key = ""
local colour = "FFFF33"
local warningText = ""
local testingText = ""

function showAnnouncement(msgText, sound)
	local secondText
	local split = string.find(msgText, "\n")
	if split then secondText = "|c"..colour..string.sub(msgText, split + 1) msgText = string.sub(msgText, 1,split).."|r" end
	sound = sound or SOUNDS.CHAMPION_POINT_GAINED
	local msg = CENTER_SCREEN_ANNOUNCE:CreateMessageParams(CSA_CATEGORY_LARGE_TEXT, sound)
	msg:SetText(msgText, secondText)
	msg:SetCSAType(CENTER_SCREEN_ANNOUNCE_TYPE_CHAMPION_POINT_GAINED)
	msg:MarkSuppressIconFrame()
	CENTER_SCREEN_ANNOUNCE:DisplayMessage(msg)
end

local function showAlert(msgText)
	ZO_Alert(nil,nil,msgText)
end
local function chatWarning(msgText)
	CHAT_SYSTEM:AddMessage(msgText)
end

local needsReset = false

local function windowWarning(msgText)
	DolgubonsLazyWritResetWarnerBackdropOutput:SetText(msgText)
	DolgubonsLazyWritResetWarner:SetHidden(false)
	DolgubonsLazyWritResetWarnerBackdropClose:SetText("Close")
	DolgubonsLazyWritResetWarnerBackdropClose:ClearAnchors()
	DolgubonsLazyWritResetWarnerBackdropClose:SetAnchor(BOTTOM,DolgubonsLazyWritResetWarnerBackdrop, BOTTOM, 0, -15 )
	DolgubonsLazyWritResetWarnerBackdropButton2:SetHidden(true)
end
local warningFunctions =
{
	["alert"] = showAlert,
	["chat"] = chatWarning,
	["announcement"] = showAnnouncement,
	["window"] = windowWarning,
	["none"] = function() end,
}

local function showWarnings(isExample)
	EVENT_MANAGER:UnregisterForUpdate(WritCreater.name.."DailyResetWarning")
	local hour, minute = dailyReset()
	local msgText = zo_strformat(warningText, hour, minute)
	if isExample=="Example" then
		msgText = "|c"..colour..WritCreater.strings['resetWarningExampleText'].."|r"
	end
	local warningType = WritCreater:GetSettings().dailyResetWarnType
	if warningType == "all" then
		for k, v in pairs(warningFunctions) do
			v(msgText)
		end
	else
		if not warningFunctions[warningType] then return end
		warningFunctions[warningType](msgText)
	end

end

WritCreater.showDailyResetWarnings = showWarnings

function WritCreater.refreshWarning()
  -- dailyResetWarnTime is in minutes
	local warnTime = WritCreater:GetSettings().dailyResetWarnTime * ZO_ONE_MINUTE_IN_SECONDS
	local hour, minute = dailyReset()
	local timeToWarning = hour*ZO_ONE_HOUR_IN_SECONDS + minute*ZO_ONE_MINUTE_IN_SECONDS - warnTime
	if timeToWarning < 0 then
		EVENT_MANAGER:RegisterForUpdate(WritCreater.name.."DailyResetWarning", 5000, showWarnings)
	else
		EVENT_MANAGER:RegisterForUpdate(WritCreater.name.."DailyResetWarning", timeToWarning*1000, showWarnings)
	end
end

function WritCreater.initializeResetWarnings()
	warningText = "|c"..colour..WritCreater.strings.resetWarningMessageText.."|r"
	-- windowWarning(warningText)
	WritCreater.refreshWarning()
end

function WritCreater.showSettingsChoice(question)
	DolgubonsLazyWritResetWarnerBackdropOutput:SetText(question)
	DolgubonsLazyWritResetWarner:SetHidden(false)
	-- DolgubonsLazyWritResetWarnerBackdropClose:SetText("On")
	-- DolgubonsLazyWritResetWarnerBackdropButton2:SetText("Off")
	-- DolgubonsLazyWritResetWarnerBackdropClose:ClearAnchors()
	-- DolgubonsLazyWritResetWarnerBackdropClose:SetAnchor(BOTTOM,DolgubonsLazyWritResetWarnerBackdrop, BOTTOM, -100, -15 )
	-- DolgubonsLazyWritResetWarnerBackdropButton2:SetHidden(false)
	needsReset = true
end


