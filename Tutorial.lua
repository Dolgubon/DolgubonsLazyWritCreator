-----------------------------------------------------------------------------------
-- Addon Name: Dolgubon's Lazy Writ Crafter
-- Creator: Dolgubon (Joseph Heinzle)
-- Addon Ideal: Simplifies Crafting Writs as much as possible
-- Addon Creation Date: March 14, 2016
--
-- File Name: Tutorial.lua
-- File Description: Shows the initial 'tutorial' on addon install
-- Load Order Requirements: None
-- 
-----------------------------------------------------------------------------------

WritCreater = WritCreater or {}

local function out(string)
	--d(string)
	DolgubonsWritsBackdropOutput:SetText(string)
end

local currentTutorialStep = 0

local function tutorial5()
	WritCreater:GetSettings().tutorial = false

	currentTutorialStep = 5
	out(WritCreater.langTutorial(5))
	DolgubonsWritsBackdropSettingOn:SetText(WritCreater.langTutorialButton(5,true))

end

local function tutorial4()
	currentTutorialStep = 4
	out(WritCreater.langTutorial(4))
	DolgubonsWritsBackdropSettingOn:SetText(WritCreater.langTutorialButton(4,true))
	DolgubonsWritsBackdropSettingOff:SetHidden(true)
	DolgubonsWritsBackdropSettingOn:ClearAnchors()
	DolgubonsWritsBackdropSettingOn:SetAnchor(BOTTOM,DolgubonsWritsBackdrop,BOTTOM,0,-230)
end

local function tutorial3()
	currentTutorialStep = 3
	out(WritCreater.langTutorial(3))
	DolgubonsWritsBackdropSettingOff:SetText(WritCreater.langTutorialButton(3,false))
	DolgubonsWritsBackdropSettingOn:SetText(WritCreater.langTutorialButton(3,true))
end

local function tutorial2()
	currentTutorialStep = 2
	out(WritCreater.langTutorial(2))
	DolgubonsWritsBackdropSettingOff:SetText(WritCreater.langTutorialButton(2,false))
	DolgubonsWritsBackdropSettingOn:SetText(WritCreater.langTutorialButton(2,true))
end

tutorial1 = function()
	DolgubonsWritsBackdrop:SetDimensions (500,500)
	currentTutorialStep = 1
	DolgubonsWritsBackdropCraft:SetHidden(true)
	out(WritCreater.langTutorial(1))
	DolgubonsWritsBackdropSettingOn:SetHidden(false)
	DolgubonsWritsBackdropSettingOff:SetHidden(false)
	DolgubonsWritsBackdropSettingOn:SetText(WritCreater.langTutorialButton(1,true))
	DolgubonsWritsBackdropSettingOff:SetText(WritCreater.langTutorialButton(1,false))

	DolgubonsWritsBackdropSettingOn:ClearAnchors()
	DolgubonsWritsBackdropSettingOn:SetAnchor(BOTTOM,DolgubonsWritsBackdrop,BOTTOM,-80,-230)

	DolgubonsWritsBackdropSettingOff:ClearAnchors()
	DolgubonsWritsBackdropSettingOff:SetAnchor(BOTTOM,DolgubonsWritsBackdrop,BOTTOM,80,-230)

	DolgubonsWritsBackdropOutput:ClearAnchors()
 	DolgubonsWritsBackdropOutput:SetAnchor(TOPLEFT,PARENT, TOPLEFT, 35, 100)

	DolgubonsWritsBackdropHead:ClearAnchors()
 	DolgubonsWritsBackdropHead:SetAnchor(TOPLEFT, PARENT, TOPLEFT, 160,70)
	
end
local function resetWindowElements()
	DolgubonsWritsBackdrop:SetDimensions (500,400)
	DolgubonsWritsBackdropOutput:ClearAnchors()
 	DolgubonsWritsBackdropOutput:SetAnchor(TOP,PARENT, TOP, -10,80)

	DolgubonsWritsBackdropHead:ClearAnchors()
 	DolgubonsWritsBackdropHead:SetAnchor(TOP, PARENT, TOP, 0,55)
	WritCreater.craftCheck(1,GetCraftingInteractionType())
end
local function onButton()
	if currentTutorialStep ==5 then
		DolgubonsWrits:SetHidden(true)
		
		WritCreater:GetSettings().tutorial = false
		DolgubonsWritsBackdropSettingOn:SetHidden(true)
		resetWindowElements()
	elseif currentTutorialStep ==4 then
		tutorial5()
	elseif currentTutorialStep ==3 then
		WritCreater:GetSettings().showWindow=true
		tutorial4()
	elseif currentTutorialStep ==2 then
		WritCreater:GetSettings().autoCraft=true
		tutorial3()
	elseif currentTutorialStep ==1 then
		WritCreater:GetSettings().tutorial = false
		DolgubonsWrits:SetHidden(true)

		DolgubonsWritsBackdropSettingOn:SetHidden(true)
		DolgubonsWritsBackdropSettingOff:SetHidden(true)
		resetWindowElements()
		
	end
	
end

local function offButton()

	if currentTutorialStep ==3 then
		WritCreater:GetSettings().showWindow=false
		tutorial4()
	end
	if currentTutorialStep ==2 then
		WritCreater:GetSettings().autoCraft=false
		WritCreater:GetSettings().showWindow=true
		tutorial4()
	end
	if currentTutorialStep ==1 then
		tutorial2()
	end
end

WritCreater.on=onButton

WritCreater.off=offButton
WritCreater.tutorial = tutorial1

--[[
EVENT_MANAGER:RegisterForEvent("test",EVENT_RESURRECT_REQUEST,function(...)d("reserect request") d(...) end ) -- Person has completed a resserection. The player/target can now accept it and rez
EVENT_MANAGER:RegisterForEvent("test",EVENT_START_SOUL_GEM_RESURRECTION,function(...)d("soul reserect start") d(...) end ) -- Player has begun reserecting someone
-- Also consider EVENT_END_SOUL_GEM_RESURRECTION
EVENT_MANAGER:RegisterForEvent("test",EVENT_RESURRECT_RESULT,function(...)d("reserect result") d(...) end ) -- The player completed rezzing someone, and the target accepted (or declined)
EVENT_MANAGER:RegisterForEvent("test",EVENT_UNIT_DEATH_STATE_CHANGED, function(...)d("death changed") d(...) end )
-- Player has died, or has come to lige
]]
-- GUILD CHAT SWAPPING!!!!!!!
--[[
SafeAddString(SI_CHANNEL_SWITCH_GUILD_1, "/guild2 /g2", 2)  
SafeAddString(SI_CHANNEL_SWITCH_GUILD_2, "/guild1 /g1", 2) ]]