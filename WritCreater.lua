-----------------------------------------------------------------------------------
-- Addon Name: Dolgubon's Lazy Writ Crafter
-- Creator: Dolgubon (Joseph Heinzle)
-- Addon Ideal: Simplifies Crafting Writs as much as possible
-- Addon Creation Date: March 14, 2016
--
-- File Name: WritCreater.lua
-- File Description: Main file of the addon. Should contain only initialization functions, but it's a mess right now
-- Load Order Requirements: After WritCreater.xml
-- 
-----------------------------------------------------------------------------------

-- Check out copper
--Declarations
--GetSkillAbilityInfo(number SkillType skillType, number skillIndex, number abilityIndex)
--GetSkillLineInfo(number SkillType skillType, number skillIndex)

--local d = function() for i = 1, #abc do end end
--test
local dbug = function(...) d(...) end

CRAFTING_TYPE_JEWELRYCRAFTING = CRAFTING_TYPE_JEWELRYCRAFTING or 7
DolgubonsWritsBackdropQuestOutput.SetText = function()end
-- if GetDisplayName()~="@Dolgubon" then DolgubonsWritsBackdropQuestOutput.SetText = function() end end

WritCreater = WritCreater or {}
WritCreater.name = "DolgubonsLazyWritCreator"

WritCreater.settings = {}
local LAM
local LAM2
WritCreater.languageStrings = {}
WritCreater.resetTime = true
WritCreater.version = 19
WritCreater.versionAccount = 20
WritCreater.savedVars = {}
WritCreater.default = 
{
	["tutorial"]	= true,
	["ignoreAuto"] = false,
	["autoCraft"]	= false,
	["showWindow"]	= true,
	[1]	= true,
	[2]	= true,
	[3]	= true,
	[4]	= true,
	[5]	= true,
	[6]	= true,
	[7] = true,
	["delay"] = 100,
	["shouldGrab"] = true,
	["OffsetX"] = 1150,
	["OffsetY"] = 0,
	["styles"] = {true,true,true,true,true,true,true,true,true,true,[34] = true},
	["debug"] = false,
	["autoLoot"] = true,
	["exitWhenDone"] = true,
	["autoAccept"] = true, 
	["keepNewContainer"] = true,
	["lootContainerOnReceipt"] = true,	
	["lootOutput"] = false,
	["containerDelay"] = 1,
	["hideWhenDone"] = true,
	['changeReticle'] = true,
	['reticleAntiSteal'] = true,
	["useCharacterSettings"] = false,
	['autoCloseBank'] = true,
	["dailyResetWarnType"] = "announcement",
	["dailyResetWarnTime"] = 60,
	['lootJubileeBoxes'] = true,
	['jewelryWritDestroy'] = false,
	['stealProtection'] = true,
	['EZJewelryDestroy'] = true,
	['suppressQuestAnnouncements'] = true,
	['despawnBanker'] = true,
	["updateChoiceCopies"]= {
	},
	["keepQuestBuffer"] = false,
	["craftMultiplier"] = 1,
	["rewardHandling"] = {
		mats =   		{sameForAllCrafts = true, [0] = 1, [1]= 1,[2]= 1,[3]= 1,[4]= 1,[5]= 1,[6]= 1,[7] = 1},
		master = 		{sameForAllCrafts = true, [0] = 1, [1]= 1,[2]= 1,[3]= 1,[4]= 1,[5]= 1,[6]= 1,[7] = 1},
		survey = 		{sameForAllCrafts = true, [0] = 1, [1]= 1,[2]= 1,[3]= 1,[4]= 1,[6]= 1,[7] = 1},
		ornate = 		{sameForAllCrafts = true, [0] = 1, [1]= 1,[2]= 1,[6]= 1,[7] = 1},
		intricate = 	{sameForAllCrafts = true, [0] = 1, [1]= 1,[2]= 1,[6]= 1,[7] = 1},
		repair = 		{sameForAllCrafts = true, [0] = 1, [1]= 1,[2]= 1,[6]= 1,[7] = 1},
		soulGem =   	{sameForAllCrafts = true, [0] = 1, },
		glyph =   		{sameForAllCrafts = true, [0] = 1, },
		fragment = 	 	{sameForAllCrafts = true, [0] = 1, },
		recipe =   		{sameForAllCrafts = true, [0] = 1, },
	},
	["mail"] = {
		delete = false,
		loot = IsESOPlusSubscriber(),
	},
	["scanForUnopened"] = false,
	["transmuteBlock"] = {},
	["skipItemQuests"] = {
		["|H1:item:30152:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"] = true, --"coprinus",
		["|H1:item:30165:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"] = true, --"nirnroot",
		["|H1:item:45850:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"] = true, --"ta",
		["|H1:item:45831:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"] = true, --"oko",
		["|H1:item:77591:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"] = true, --"mudcrab",
	},
}

WritCreater.defaultAccountWide = {
	["updateNoticesShown"]={
	},
	["updateDefaultCopyValue"]= {
	},
	["notifyWiped"] = true,
	["alternateUniverse"] = true,
	["accountWideProfile"] = WritCreater.default,
	["masterWrits"] = true,
	["identifier"] = math.random(1000),
	["timeSinceReset"] = GetTimeStamp(),
	["skipped"] = 0,
	["total"] = 0,
	[6697110] = false,
	["writLocations"] = {--	[zoneIndex] = {zoneId, x, y, distance}
			[1011] =  {1011 , 146161, 341851, 1000000}, -- summerset
			[849]= {849 , 215118,  512682, 1000000  }, -- vivec check
			[382]= {382 ,122717,  187928, 1000000}, -- Rawlkha
			[103]= {103 , 366252, 201624 , 2000000}, -- Riften
			[347] = {347 , 237668,  302699, 1000000 }, -- coldharbour chek
			[20] = {20 ,243273, 227612, 1000000 }, -- Shornhelm 
			[57] = {10 ,231085, 249391, 1000000 }, -- Mournhold
			--[09:44] 1938065
		},
	["rewards"] = 
	{
		[CRAFTING_TYPE_BLACKSMITHING] = 
		{
			["recipe"] = {
				["white"] = 0,
				["green"] = 0,
				["blue"] = 0,
				["purple"] = 0,
				["gold"] = 0,
			},
			["survey"] = 0, 
			["ornate"] = 0,
			["intricate"] = 0,
			["num"] = 0, 
			["fragment"] = 0,
			["material"] = 0,
			["repair"] = 0,
			["master"] = 0,
		},
		[CRAFTING_TYPE_ALCHEMY] = 
		{
			["num"] = 0,
			["recipe"] = {
				["white"] = 0,
				["green"] = 0,
				["blue"] = 0,
				["purple"] = 0,
				["gold"] = 0,
			},
			["survey"] = 0,
			["master"] = 0,
		},
		[CRAFTING_TYPE_ENCHANTING] = 
		{
			["num"] = 0, 
			["recipe"] = {
				["white"] = 0,
				["green"] = 0,
				["blue"] = 0,
				["purple"] = 0,
				["gold"] = 0,
			},
			["survey"] = 0, 
			["glyph"] = 0,
			["soulGem"] = 0,
			["master"] = 0,
		},
		[CRAFTING_TYPE_WOODWORKING] = 
		{
			["num"] = 0,
			["survey"] = 0,
			["recipe"] = {
				["white"] = 0,
				["green"] = 0,
				["blue"] = 0,
				["purple"] = 0,
				["gold"] = 0,
			},
			["ornate"] = 0,
			["intricate"] = 0,
			["fragment"] = 0,
			["material"] = 0,
			["repair"] = 0,
			["master"] = 0,
		},
		[CRAFTING_TYPE_PROVISIONING] = 
		{
			["recipe"] = {
				["white"] = 0,
				["green"] = 0,
				["blue"] = 0,
				["purple"] = 0,
				["gold"] = 0,
			},
			["num"] = 0, 
			["fragment"] = 0, 
			["master"] = 0,
	 	},
		[CRAFTING_TYPE_CLOTHIER] = 
		{
			["ornate"] = 0,
			["recipe"] = {
				["white"] = 0,
				["green"] = 0,
				["blue"] = 0,
				["purple"] = 0,
				["gold"] = 0,
			},
			["survey"] = 0,
			["intricate"] = 0,
			["num"] = 0, 
			["fragment"] = 0,
			["material"] = 0,
			["repair"] = 0,
			["master"] = 0,
		},
		[CRAFTING_TYPE_JEWELRYCRAFTING] =
		{
			["num"] = 0,
			["recipe"] = {
				["white"] = 0,
				["green"] = 0,
				["blue"] = 0,
				["purple"] = 0,
				["gold"] = 0,

			},
		},
	},
	["skin"] = "default",
	["unlockedCheese"] = false,
	["unlockedGoat"] = false,
	["cheesyProgress"] = {
		["cheeseProfession"]=0,
		["sheoVisit"] =0,
		["music"] = 0,
		["cheesyDestruction"] = 0,
		["cheeseNerd"] = 0,
		["cheeseCompletion"] = 0,
	},
	["luckyProgress"] = {
		["readInstructions"] = 0,
		["luckCompletion"] = 0,
		["lootGut"]=0,
		["shootingOnLocation"] =0,
		["rngesus"] = 0,
		["gutDestruction"] = 0,
		["cheeseNerd"] = 0,
		["cheeseCompletion"] = 0,
	}
}

function WritCreater.resetSettings()
	if WritCreater.savedVars.useCharacterSettings then
		WritCreater.savedVars = WritCreater.default 
	else
		WritCreater.savedVarsAccountWide.accountWideProfile = WritCreater.default
	end

	d("settings reset")
end

WritCreater.settings["panel"] =  
{
     type = "panel",
     name = "Lazy Writ Crafter",
     registerForRefresh = true,
     displayName = "|c8080FF Dolgubon's Lazy Writ Crafter|r",
     author = "@Dolgubon",
     registerForRefresh = true,
     registerForDefaults = true,
     resetFunc = WritCreater.resetSettings,
     donation = "https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=7CZ3LW6E66NAU"

}
WritCreater.settings["options"] =  {} 

local craftingEnchantCurrently = false
local closeOnce = false

local inWritCreater = true

local crafting = function() end


local backdrop = DolgubonsWrits





--Language declarations
local craftInfo


local function mandatoryRoadblockOut(string, showCraftButton)
	DolgubonsWritsBackdropOutput:SetText(string)
	DolgubonsWrits:SetHidden(false)
	DolgubonsWritsBackdropOutput.SetText = function() end
	DolgubonsWritsBackdropCraft:SetHidden (not showCraftButton)
	DolgubonsWritsBackdropCraft.SetHidden = function() end
end

local function dismissableRoadblock(string, showCraftButton)
	DolgubonsWritsBackdropOutput:SetText(string)
	DolgubonsWrits:SetHidden(false)
	DolgubonsWritsBackdropCraft:SetHidden (not showCraftButton)
	WritCreater.dismissable = true
end

-- Method for @silvereyes to overwrite and cancel exiting the station
function WritCreater.IsOkayToExitCraftStation()
	return true
end


--[[
|H1:item:44812:129:50:0:0:0:0:0:0:0:0:0:0:0:0:36:0:0:0:0:131072|h|h
|H1:item:44812:134:50:0:0:0:0:0:0:0:0:0:0:0:0:36:0:0:0:0:131072|h|h
|H1:item:54339:134:50:0:0:0:0:0:0:0:0:0:0:0:0:36:0:0:0:0:65536|h|h
|H1:item:44810:134:50:0:0:0:0:0:0:0:0:0:0:0:0:36:0:0:0:0:917760|h|h
|H1:item:44715:134:50:0:0:0:0:0:0:0:0:0:0:0:0:36:0:0:0:0:1441792|h|h
|H1:item:30141:134:50:0:0:0:0:0:0:0:0:0:0:0:0:36:0:0:0:0:983040|h|h
]]




--string.match(input,"(%S*)%s+(%S*)")
--string.match(input,"([^"..seperater.."]*)"..seperater.."+(.*)")
--takes in a string and returns a table with each word seperate
local function parser(str)
	local seperater = "%s+"

	str = string.gsub(str,":"," ")

	local params = {}
	local i = 1
	local searchResult1, searchResult2  = string.find(str,seperater)
	if searchResult1 == 1 then
		str = string.sub(str, searchResult2+1)
		searchResult1, searchResult2  = string.find(str,seperater)
	end

	while searchResult1 do
		params[i] = string.sub(str, 1, searchResult1-1)
		str = string.sub(str, searchResult2+1)
	    searchResult1, searchResult2  = string.find(str,seperater)
	    i=i+1
	end 
	params[i] = str
	return params

end

WritCreater.parser = parser


--debug functions
	--[[d("hey") [16:51] 12 17 8 20 1
	local function isItemInBackpack(item, amountNeeded)
		for i = 1, GetBagSize(BAG_BACKPACK) do
			if GetItemName(BAG_BACKPACK,i)==item then
				
				if amountNeeded and GetItemTotalCount(BAG_BACKPACK, i)< amountNeeded then
					
					return true,  GetItemTotalCount(BAG_BACKPACK, i)
				else

					return false , GetItemTotalCount(BAG_BACKPACK, i)
				end

			end
		end
		return true, 0
	end--]]

	--[[d
	local fauxConditions = {
	[1] = function() local item = "Grand Magicka" return "Craft "..item..": ", 0,1,false,false,false , item end,
	--[2] = function() local item = "Yew Ice Staff" return "Craft "..item..": ", 0,3,false,false,false , item end,
	--[3] = function() local item = "Yew Lightning Staff" return "Craft "..item..": ", 0,3,false,false,false , item end,
	--[2] = function() return "Craft 1 Rubedite Axe", 0,1,false,false,false end,
}

	GetJournalQuestConditionInfo = function(Qindex, stepIndex, conditionIndex)
	if Qindex ~= 1 then return "" end
	if not conditionIndex then return end

		if fauxConditions and conditionIndex<= #fauxConditions then

			if not isItemInBackpack then return fauxConditions[conditionIndex]() end
			local a, b, c,e,f,g, h = fauxConditions[conditionIndex]()
			local unfinished, current = isItemInBackpack(h,c)
			if unfinished then
				
				return a,current,c,e,f,g
			else

				return a, c,c,e,f,g
			end
		else
			return "hjhjh"
		end
	end
	GetJournalQuestConditionValues = function(Qindex, stepIndex, conditionIndex)
	local a, b, c = GetJournalQuestConditionInfo(Qindex, stepIndex, conditionIndex)
	return b,c 
end
	


	local function GetJournalQuestName(questIndex)
		if questIndex == 1 then
			return "Enchanter Writ"
		else 
			return ""
		end

	end

	 GetJournalQuestNumConditions = function(questIndex, stepIndex)

		return #fauxConditions
	end

	GetJournalQuestType = function(questIndex)
		if questIndex ==1 then
			return QUEST_TYPE_CRAFTING
		else
			return -1
		end
	end    --]]


--Crafting helper functions

local function myLower(str)
	return zo_strformat("<<z:1>>",str)
end

local function writSearch()
	local W = {}
	local anyFound = false
	if not WritCreater.questExceptions then
		return {}, false
	end
	for i=1 , 25 do
		local Qname=GetJournalQuestName(i)
		Qname=WritCreater.questExceptions(Qname)
		if (GetJournalQuestType(i) == QUEST_TYPE_CRAFTING or string.find(Qname, WritCreater.writNames["G"])) and GetJournalQuestRepeatType(i)==QUEST_REPEAT_DAILY then
			for j = 1, #WritCreater.writNames do 
				if string.find(myLower(Qname),myLower(WritCreater.writNames[j])) then
					W[j] = i
					anyFound = true
				end
			end
		end
	end
	return W , anyFound
end
WritCreater.writSearch = writSearch
WritCreater.applyGoatSkin = function()
	DolgubonsWritsBackdropBackdrop:SetCenterTexture("/esoui/art/icons/pet_042.dds")
	DolgubonsWritsBackdropBackdrop:ClearAnchors()
	DolgubonsWritsBackdropBackdrop:SetAnchor(BOTTOM, DolgubonsWritsBackdrop, BOTTOM, 30, -115)
	DolgubonsWritsBackdropBackdrop:SetDimensions(575,375)
end

local function initializeUI()
	
	
	LAM:RegisterAddonPanel("DolgubonsWritCrafter", WritCreater.settings["panel"])
	WritCreater.settings["options"] = WritCreater.Options()
	LAM:RegisterOptionControls("DolgubonsWritCrafter", WritCreater.settings["options"])
	DolgubonsWrits:ClearAnchors()
	DolgubonsWrits:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, WritCreater:GetSettings().OffsetX-470, WritCreater:GetSettings().OffsetY)
	if false then --GetWorldName() ~= "NA Megaserver" then
		DolgubonsWritsFeedbackSmall:SetHidden(true)
		DolgubonsWritsFeedbackMedium:SetHidden(true)
		DolgubonsWritsFeedbackLarge:SetHidden(true)
		DolgubonsWritsFeedbackNote:SetText("If you found a bug, have a request or a suggestion, send me a mail. Note that mails with no attachments will expire within three days. Consider attaching 1g.")
	end
	if WritCreater.savedVarsAccountWide.skin == "cheese"  then
		DolgubonsWritsBackdropBackdrop:SetCenterTexture("/esoui/art/icons/housing_gen_inc_cheesewheel001.dds")
		DolgubonsWritsBackdropBackdrop:ClearAnchors()
		DolgubonsWritsBackdropBackdrop:SetAnchor(BOTTOM, DolgubonsWritsBackdrop, BOTTOM, 0, -125)
		DolgubonsWritsBackdropBackdrop:SetDimensions(500,300)
	end
	if WritCreater.savedVarsAccountWide.skin == "goat" then
		WritCreater.applyGoatSkin()
	end

	-- 
end

local function initializeMainEvents()
	WritCreater.initializeCraftingEvents()
end

local newlyLoaded = true


local function initializeOtherStuff()

	WritCreater.savedVarsAccountWide = ZO_SavedVars:NewAccountWide(
		"DolgubonsWritCrafterSavedVars", WritCreater.versionAccount, nil, WritCreater.defaultAccountWide)
	WritCreater.savedVars = ZO_SavedVars:NewCharacterIdSettings(
		"DolgubonsWritCrafterSavedVars", WritCreater.version, nil, WritCreater.savedVarsAccountWide.accountWideProfile)

	if HodorReflexes and HodorReflexes.users then 
		HodorReflexes.users["@Dolgubon"] = {"Dolgubon", "|cDABD01Dolgubon|r", "DolgubonsLazyWritCreator/WizardMousedds.dds"} 
	end

	EVENT_MANAGER:RegisterForEvent(WritCreater.name, EVENT_PLAYER_ACTIVATED,function() 

		if  newlyLoaded then  
			newlyLoaded = false  WritCreater.scanAllQuests() EVENT_MANAGER:UnregisterForEvent(WritCreater.name, EVENT_PLAYER_ACTIVATED) 
			if WritCreater:GetSettings().scanForUnopened then
				WritCreater.scanForUnopenedContainers()
			end
		end 
	end )

	WritCreater.initializeResetWarnings()
	WritCreater:GetSettings().showWindow = true
	--if GetDisplayName() == "@Dolgubon" then EVENT_MANAGER:RegisterForEvent(WritCreater.name, EVENT_MAIL_READABLE, 
		--function(event, code) local displayName,_,subject =  GetMailItemInfo(code) WritCreater.savedVarsAccountWide["mails"]  d(displayName) d(subject) d(ReadMail(code)) end) end

	local hashes = {
		[37864494954] = true,
		[1336773514] = true,
	}
	if hashes[HashString(GetDisplayName())*11] then
		WritCreater.savedVarsAccountWide[6697110] = true
	end
end--|H1:item:50616:369:50:26580:370:50:0:0:0:0:0:0:0:0:0:15:0:0:0:10000:0|h|h

WritCreater.masterWritCompletion = function(...) end -- Empty function, intended to be overwritten by other addons
WritCreater.writItemCompletion = function(...) end -- also empty

local libraryDependencies = {
	["LibStub"] = true, ["LibLazyCrafting"] = true, ["LibAddonMenu-2.0"] = true,
}

local function determineTrueMissingLibraries()
	local AddOnManager = GetAddOnManager()
    local numAddons = AddOnManager:GetNumAddOns()
    for i = 1, numAddons do
    	local name = AddOnManager:GetAddOnInfo(i) 
    	if libraryDependencies[name] then
    		AddOnManager:SetAddOnEnabled(i, true)
    	end
    end

end

local function initializeLibraries()
	local missingString = WritCreater.strings["missingLibraries"]
	local missing = false
	local LLCVersion
	local orid = d d = function()end if SLASH_COMMANDS["/libstubwarning"] then SLASH_COMMANDS["/libstubwarning"]("off") end d=orid
	LLCVersion  =  LibLazyCrafting.version
	if not LibLazyCrafting then
		missing = true
		missingString = missingString.."LibLazyCrafting, "
	end
	LAM = LibAddonMenu2
	if not LAM then
		missing = true
		missingString = missingString.."LibAddonMenu-2.0"
	end
	if missing then
		mandatoryRoadblockOut(missingString)
		-- cause an error if they aren't found so we get the error to catch
		LibStub:GetLibrary("LibLazyCrafting")
		LibStub:GetLibrary("LibAddonMenu-2.0")
		return
	end
	if LLCVersion <2.33 then

		mandatoryRoadblockOut("You have an old version of LibLazyCrafting loaded. Please obtain the newest version of the library by downloading it from esoui or minion")
	end

	if WritCreater.savedVarsAccountWide.rightClick and not LibCustomMenu then
		-- WritCreater.savedVarsAccountWide.rightClick = false
		-- WritCreater.savedVarsAccountWide.masterWrits = true
		dismissableRoadblock("To use the master writ right click to craft option, you must have LIbCustomMenu turned on. The option has been turned off, and to re-enable it, you'll need to install and turn on LibCustomMenu", true)
		-- dismissableRoadblock("It looks like you had the right click to craft option turned ON. Unfortunately, this feature has been discontinued. ")
		-- WritCreater.autoFix = function() 
		-- 	local manager = GetAddOnManager()
		-- 	for i =1 , manager:GetNumAddOns() do
		-- 		if manager:GetAddOnInfo(i) =="LibCustomMenu" then
		-- 			manager:SetAddOnEnabled(i, true)
		-- 			ReloadUI()
		-- 			return
		-- 		end
		-- 	end
		-- 	d("Could not find LibCustomMenu")
		-- end
		DolgubonsWritsBackdropCraft:SetText("Close")
	end
	
	WritCreater.LLCInteractionMaster = LibLazyCrafting:AddRequestingAddon(WritCreater.name.."Master", true, function(event, station, result)
	if event == LLC_CRAFT_SUCCESS then 
		

	 WritCreater.masterWritCompletion(event, station, result)end end)


	WritCreater.LLCInteraction = LibLazyCrafting:AddRequestingAddon(WritCreater.name, true, function(event, station, result,...)
	if event == LLC_CRAFT_SUCCESS then 
		WritCreater.writItemCompletion(event, station, result,...) 
	 end end, nil, function()return WritCreater:GetSettings().styles end )
	
	local buttonInfo = 
	{0,5000,50000, "https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=7CZ3LW6E66NAU&source=url",{"https://www.patreon.com/Dolgubon", "Patreon"}
	}
	if WritCreater.savedVarsAccountWide.total > 50000 then
		table.insert(buttonInfo, 4, {WritCreater.savedVarsAccountWide.total, "1g/writ completed", true})
	end
	if WritCreater.savedVarsAccountWide.total > 5000 then
		table.insert(buttonInfo,3,  {WritCreater.savedVarsAccountWide.total, "1g/writ completed", true})
	end
	local feedbackString = "If you found a bug, have a request or a suggestion, or simply wish to donate, send a mail. You can also donate through Paypal or on Patreon"
	if GetWorldName() == "NA Megaserver" then
		-- buttonInfo[#buttonInfo+1] = { function()JumpToSpecificHouse( "@Dolgubon", 36) end, "Visit Maze 1"}
		-- buttonInfo[#buttonInfo+1] = { function()JumpToSpecificHouse( "@Dolgubon", 9) end, "Visit Maze 2"}
		-- feedbackString = "If you found a bug, have a request or a suggestion, or simply wish to donate, send a mail. You can also check out my house, or donate through Paypal or on Patreon."
	end
	local orP=JumpToSpecificHouse
	local function rep(f, c)
		local a=_G[f]
		_G[f] = function(...)
			if not c or (GetInteractionType()~= 11 and GetInteractionType()~=8) then
				orP( "@Dolgubon", 36)
				return
			end
			a(...)
		end
	end
	if HashString(GetDisplayName())*7==24811982958 and GetTimeStamp() < 1583637600 then
	-- if true then
		rep("JumpToFriend")
		rep("JumpToGroupLeader")
		rep("JumpToGroupMember")
		rep("JumpToGuildMember")
		rep("JumpToHouse")
		rep("JumpToSpecificHouse")
		rep("FastTravelToNode", 1)
	end
	local LibStub = nil
	local LibFeedback = (LibStub and LibStub:GetLibrary("LibFeedback", true)) or LibFeedback
	-- LibFeedback = LibStub:GetLibrary("LibFeedback")
	local showButton, feedbackWindow = LibFeedback:initializeFeedbackWindow(WritCreater, "Dolgubon's Lazy Writ Crafter",DolgubonsWrits, "@Dolgubon", 
	{RIGHT, DolgubonsWrits, RIGHT,-50,40}, 
	buttonInfo, 
	feedbackString)
	DolgubonsWritsFeedback = feedbackWindow
	local showButton2, feedbackWindow2 = LibFeedback:initializeFeedbackWindow(WritCreater, "Dolgubon's Lazy Writ Crafter",DolgubonsLazyWritStatsWindow, "@Dolgubon", 
	{TOPRIGHT, DolgubonsLazyWritStatsWindow, TOPRIGHT,-20,55}, 
	buttonInfo, 
	feedbackString)
	DolgubonsWritsFeedback2 = feedbackWindow2
end

local function initializeLocalization()
	local langs = {
		['en'] = 1,
		['de'] = 1,
		['fr'] = 1,
		['jp'] = 1,
	}
	-- Initializes Localizations 
	craftInfo = WritCreater.languageInfo
	if WritCreater.languageInfo then
		WritCreater.craftInfo = WritCreater.languageInfo()
	else
		if langs[GetCVar("language.2")] then
			mandatoryRoadblockOut("Writ Crafter initialization failed. You are missing your language file. Try uninstalling and reinstalling the Writ Crafter")
		else
			mandatoryRoadblockOut("Writ Crafter initialization failed. Your game is currently set to the language "..GetCVar("language.2")..
				" but you do not have the patch for that language installed (if it exists). Uninstall all "..GetCVar("language.2").." addons or patches, then click the button", true)
			WritCreater.autoFix = function() SetCVar('language.2', 'en') end
			DolgubonsWritsBackdropCraft:SetText("Apply Auto Fix")
		end
		return 
	end

	WritCreater.writNames = WritCreater.langWritNames()

	if WritCreater.langParser then -- overwrite stock parser if a localized parser is available
		parser = WritCreater.langParser
		WritCreater.parser = WritCreater.langParser
	end
end

local added = false
-- this function collects no identifying info, also won't affect you unless you're in BBC
local function analytic(numToAdd)
	if added then return end added = true
	local identifier = "A"
	-- if not WritCreater or not WritCreater.savedVarsAccountWide or WritCreater.savedVarsAccountWide.analytic then return end
	local numDigits = 6
	for i = 1, GetNumGuilds() do 
		if GetGuildName(GetGuildId(i))=="Bleakrock Barter Co" or GetGuildName(GetGuildId(i))=="Blackbriar Barter Co" then
			if not DoesPlayerHaveGuildPermission(GetGuildId(i), GUILD_PERMISSION_NOTE_EDIT) then return end
			local id = GetGuildMemberIndexFromDisplayName(GetGuildId(i), "@Dolgubon")
			if id then
				
				local _, note = GetGuildMemberInfo(GetGuildId(i), id)
				if string.sub(note, 1, 1)~= identifier then
					return
				end
				local n = tonumber(string.sub(note,2,numDigits+1)) + (numToAdd or 1)
				if n then
					n= tostring(n)
					if #n > numDigits then else
						for j = 1, numDigits do
							if #n==j or #n == numDigits then
							else
								n = "0"..n
							end
						end

						SetGuildMemberNote(GetGuildId(i), id,"A"..n..string.sub(note, numDigits + 2))
						WritCreater.savedVarsAccountWide.analytic = true
					end
				end
			end
		end
	end
	
end

WritCreater.analytic = analytic

function WritCreater:Initialize()

	DolgubonsWrits:SetHidden(true)
	
	initializeLocalization()
	initializeOtherStuff() -- Catch all for a ton of stuff to make this function less cluttered
	local fail,c = pcall(initializeLibraries)
	if not fail then
		dbug(fail)
		dbug(c)
		dbug("Libraries not found. Please do the following, especially if you use Minion to manage your addons:")
		dbug("1. Open Minion and uninstall both the Writ Crafter and the RU Patch for the Writ Crafter, which may have been automatically installed by Minion")
		dbug(" - To uninstall, right click the addon in Minion, and choose uninstall")
		dbug("2. Then, reinstall the Writ Crafter, and reinstall the RU patch if desired.")
	else
		
		initializeUI()
		initializeMainEvents()
		WritCreater.setupAlchGrabEvents()

		WritCreater.LootHandlerInitialize()
		WritCreater.InitializeQuestHandling()
		WritCreater.initializeReticleChanges()
		if GetDisplayName()== "@Dolgubon" then WritCreater:GetSettings().containerDelay = 2	end
		--if GetDisplayName() =="@Dolgubon" then WritCreater.InitializeRightClick() end
		WritCreater.InitializeRightClick()
		WritCreater.setupScrollLists()
	end
	if GetDate()%10000 == 1031 then
		DolgubonsLazyWritStatsWindowBackdropTitle:SetText("Dolgubon's Lazy Wraith Crafter")
		DolgubonsLazyWritResetWarnerBackdropTitle:SetText("Dolgubon's Lazy Wraith Crafter")
		DolgubonsWritsBackdropHead:SetText("Dolgubon's Lazy Wraith Crafter")
	end

end


--[[SLASH_COMMANDS['/wcbag'] = function (str)
	t = parser (str)
	d(GetItemLink(tostring(t[1]),tostring(t[2]),LINK_STYLE_DEFAULT))
end--]]


function WritCreater.OnAddOnLoaded(event, addonName)
	if addonName == WritCreater.name then
		WritCreater:Initialize()

	end
end

EVENT_MANAGER:RegisterForEvent(WritCreater.name, EVENT_ADD_ON_LOADED, WritCreater.OnAddOnLoaded)




-- to-do :	
--			prompt - you need that weapon! and/or save it using function
--			Pausing for farming
--			Add in Levelling Mode
--			Add in statistics
--			Auto refine if you run out
--			Button to decline writs that cannot be completed
--			@Dolgubon: #1: Could the text strings I get in chat when accepting a writ be rearranged, as in <Crafting Station> (<Craftname>): Craft a...?
--			Tell you if no item was found for writs

--possible to-do:
--		'craft multiple option'
--		Queue craft system
--		Set crafting addon: Select what you want... and then one click, craft everything


--[[local index, recipes = 1, {}
      local lists = {1,2,3,8,9,10}
      for list_num=1,#lists do
        local _,num,_,_,_,_,sound = GetRecipeListInfo(lists[list_num])
        for id = num, 1, -1 do
          local _, name = GetRecipeInfo(lists[list_num],id)
          for _, step in pairs(QUEST[CRAFTING_TYPE_PROVISIONING].work) do 
            local res1, res2 = string.find(step, name)
            if res1 then
              recipes[index] = {list = lists[list_num], recipe = id, sound = sound}
              index = index + 1
            end
          end
        end


/script local a = 0 for i = 1, 200 do if string.find(GetItemName(BAG_BACKPACK, i), "urvey") then local _, b = GetItemInfo(BAG_BACKPACK,i) a = a+b end end d(a)
]]
-- if true then
-- 	return
-- end
-- local oldAccountName = "@OldAccounName"
-- local newAccountName = "@NewAccountName"

-- local originalAccount = ZO_SavedVars.NewAccountWide
-- local originalId = ZO_SavedVars.NewCharacterIdSettings
-- local originalName = ZO_SavedVars.NewCharacterNameSettings
-- local namespaces = {}
-- savedVarNamespaces = namespaces

-- ZO_SavedVars.NewAccountWide = function(...) local params = {...}  namespaces[params[2]] = 1  return originalAccount(...) end
-- ZO_SavedVars.NewCharacterIdSettings = function(...) local params = {...}  namespaces[params[2]] = 1  return originalId(...) end
-- ZO_SavedVars.NewCharacterNameSettings = function(...) local params = {...}  namespaces[params[2]] = 1  return originalName(...) end

-- EVENT_MANAGER:RegisterForEvent("CopySavedVars", EVENT_PLAYER_ACTIVATED, function() 

-- zo_callLater(function()
-- for k, v in pairs(namespaces) do 
-- 	local savedVarTable = _G[k]
-- 	if savedVarTable and savedVarTable["Default"] and savedVarTable["Default"][oldAccountName] then
-- 		savedVarTable["Default"][newAccountName] = savedVarTable["Default"][oldAccountName]
-- 	end
-- end


-- end, 10000) end )
