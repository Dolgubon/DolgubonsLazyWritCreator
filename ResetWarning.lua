
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
	return till["hour"], till["minute"]
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
	local warnTime = WritCreater:GetSettings().dailyResetWarnTime
	local hour, minute = dailyReset()
	local timeToWarning = hour*3600 + minute*60 - warnTime*60
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


