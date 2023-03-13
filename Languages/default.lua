-----------------------------------------------------------------------------------
-- Addon Name: Dolgubon's Lazy Writ Crafter
-- Creator: Dolgubon (Joseph Heinzle)
-- Addon Ideal: Simplifies Crafting Writs as much as possible
-- Addon Creation Date: March 14, 2016
--
-- File Name: Languages/default.lua
-- File Description: Default language file
-- Load Order Requirements: Before the language file
-- 
-----------------------------------------------------------------------------------

function WritCreater.language()

	return false

end

local function myLower(str)
	return zo_strformat("<<z:1>>",str)
end

function WritCreater.getWritAndSurveyType(link)
	if not WritCreater.langCraftKernels then return end
	local itemName = GetItemLinkName(link)
	local kernels = WritCreater.langCraftKernels()
	local craftType
	for craft, kernel in pairs(kernels) do
		if string.find(myLower(itemName), myLower(kernel)) then
			craftType = craft
		end
	end
	return craftType
end

local function proper(str)
	if type(str)== "string" then
		return zo_strformat("<<C:1>>",str)
	else
		return str
	end
end

WritCreater.hirelingMailSubjects = 
{
	["Raw Enchanter Materials"] = true ,
	["Raw Clothier Materials"] = true ,
	["Raw Blacksmith Materials"] = true ,
	["Raw Woodworker Materials"] = true ,
	["Raw Provisioner Materials"] = true ,
	["Schreinermaterial"] = true,
	["Versorgerzutaten"] = true,
	["Schneidermaterial"] = true,
	["Verzauberermaterial"] = true,
	["Schmiedematerial"] = true,
	["Matériaux bruts d'enchantement"] = true,
	["Matériaux bruts de forge"] = true,
	["Matériaux bruts de travail du bois"] = true,
	["Matériaux bruts de couture"] = true,
	["Matériaux bruts de cuisine"] = true,
}

WritCreater.lang = "none"

-- This is in the default, so that if a new setting is added an error is not thrown, 
-- and the addon instead uses the English option strings for any that are missing.

local function runeMissingFunction (ta,essence,potency)
	local missing = {}
	if not ta["bag"] then
		missing[#missing + 1] = "|rTa|cf60000"
	end
	if not essence["bag"] then
		missing[#missing + 1] =  "|cffcc66"..essence["slot"].."|cf60000"
	end
	if not potency["bag"] then
		missing[#missing + 1] = "|c0066ff"..potency["slot"].."|r"
	end
	local text = ""
	for i = 1, #missing do
		if i ==1 then
			text = "|cff3333Glyph could not be crafted. You do not have any "..proper(missing[i])
		else
			text = text.." or "..proper(missing[i])
		end
	end
	return text
end


local function dailyResetFunction(till, stamp) -- You can translate the following simple version instead.
										-- function (till) d(zo_strformat("<<1>> hours and <<2>> minutes until the daily reset.",till["hour"],till["minute"])) end,
	if till["hour"]==0 then
		if till["minute"]==1 then
			return "1 minute until daily server reset!"
		elseif till["minute"]==0 then
			if stamp==1 then
				return "Daily reset in "..stamp.." seconds!"
			else
				return "Seriously... Stop asking. Are you that impatient??? It resets in one more second! *grumble grumble*"
			end
		else
			return till["minute"].." minutes until daily reset!"
		end
	elseif till["hour"]==1 then
		if till["minute"]==1 then
			return till["hour"].." hour and "..till["minute"].." minute until daily reset"
		else
			return till["hour"].." hour and "..till["minute"].." minutes until daily reset"
		end
	else
		if till["minute"]==1 then
			return till["hour"].." hours and "..till["minute"].." minute until daily reset"
		else
			return till["hour"].." hours and "..till["minute"].." minutes until daily reset"
		end
	end 
end

function WritCreater.langWritNames() -- Vital to translate
	-- Exact!!!  I know for german alchemy writ is Alchemistenschrieb - so ["G"] = schrieb, and ["A"]=Alchemisten
	local names = {
	["G"] = "Writ",
	[CRAFTING_TYPE_ENCHANTING] = "Enchanter",
	[CRAFTING_TYPE_BLACKSMITHING] = "Blacksmith",
	[CRAFTING_TYPE_CLOTHIER] = "Clothier",
	[CRAFTING_TYPE_PROVISIONING] = "Provisioner",
	[CRAFTING_TYPE_WOODWORKING] = "Woodworker",
	[CRAFTING_TYPE_ALCHEMY] = "Alchemist",
	[CRAFTING_TYPE_JEWELRYCRAFTING] = "Jewelry",
	}
	return names
end

function WritCreater.writCompleteStrings() -- Vital for translation
	local strings = {
	["place"] = "Place the goods",
	["sign"] = "Sign the Manifest",
	["masterPlace"] = "I've finished the ",
	["masterSign"] = "<Finish the job.>",
	["masterStart"] = "<Accept the contract.>",
	["Rolis Hlaalu"] = "Rolis Hlaalu", -- This is the same in most languages but ofc chinese and japanese
	["Deliver"] = "Deliver",
	}
	return strings
end

function WritCreater.langWritRewardBoxes () return {
	[CRAFTING_TYPE_ALCHEMY] = "Alchemist's Vessel",
	[CRAFTING_TYPE_ENCHANTING] = "Enchanter's Coffer",
	[CRAFTING_TYPE_PROVISIONING] = "Provisioner's Pack",
	[CRAFTING_TYPE_BLACKSMITHING] = "Blacksmith's Crate",
	[CRAFTING_TYPE_CLOTHIER] = "Clothier's Satchel",
	[CRAFTING_TYPE_WOODWORKING] = "Woodworker's Case",
	[CRAFTING_TYPE_JEWELRYCRAFTING] = "Jewelry Crafter's Coffer",
	[8] = "Shipment",
}
end

local function masterWritEnchantToCraft (pat,set,trait,style,qual,mat,writName,Mname,generalName)
	local partialString = zo_strformat("Crafting a CP150 <<t:6>> <<t:1>> from <<t:2>> with the <<t:3>> trait and style <<t:4>> at <<t:5>> quality",pat,set,trait,style,qual,mat)
	return zo_strformat("<<t:2>> <<t:3>> <<t:4>>: <<1>>",partialString,writName,Mname,generalName )
end

WritCreater.missingTranslations = {}
local stringIndexTable = {}
local findMissingTranslationsMetatable = 
{
["__newindex"] = function(t,k,v) if not stringIndexTable[tostring(t)] then stringIndexTable[tostring(t)] = {} end stringIndexTable[tostring(t)][k] = v WritCreater.missingTranslations[k] = {k, v} end,
["__index"] = function(t, k) return stringIndexTable[tostring(t)][k] end,
}

WritCreater.strings = {}
setmetatable(WritCreater.strings, findMissingTranslationsMetatable)

WritCreater.strings["runeReq"] 					= function (essence, potency) return zo_strformat("|c2dff00Crafting will require 1 |rTa|c2dff00, 1 |cffcc66<<1>>|c2dff00 and 1 |c0066ff<<2>>|r", essence, potency) end
WritCreater.strings["runeMissing"] 				= runeMissingFunction 
WritCreater.strings["notEnoughSkill"]				= "You do not have a high enough crafting skill to make the required equipment"
WritCreater.strings["smithingMissing"] 			= "\n|cf60000You do not have enough mats|r"
WritCreater.strings["craftAnyway"] 				= "Craft anyway"
WritCreater.strings["smithingEnough"] 				= "\n|c2dff00You have enough mats|r"
WritCreater.strings["craft"] 						= "|c00ff00Craft|r"
WritCreater.strings["crafting"] 					= "|c00ff00Crafting...|r"
WritCreater.strings["craftIncomplete"] 			= "|cf60000Crafting could not be completed.\nYou need more mats.|r"
WritCreater.strings["moreStyle"] 					= "|cf60000You do not have any usable style stones.\nCheck your inventory, achievements, and settings|r"
WritCreater.strings["moreStyleSettings"]			= "|cf60000You do not have any usable style stones.\nYou likely need to allow more in the Settings Menu|r"
WritCreater.strings["moreStyleKnowledge"]			= "|cf60000You do not have any usable style stones.\nYou might need to learn to craft more styles|r"
WritCreater.strings["dailyreset"] 					= dailyResetFunction
WritCreater.strings["complete"] 					= "|c00FF00Writ complete.|r"
WritCreater.strings["craftingstopped"]				= "Crafting stopped. Please check to make sure the addon is crafting the correct item."
WritCreater.strings["smithingReqM"] 				= function (amount, type, more) return zo_strformat( "Crafting will use <<1>> <<2>> (|cf60000You need <<3>>|r)" ,amount, type, more) end
WritCreater.strings["smithingReq"] 				= function (amount,type, current) return zo_strformat( "Crafting will use <<1>> <<2>> (|c2dff00<<3>> available|r)"  ,amount, type, current) end
WritCreater.strings["lootReceived"]				= "<<3>> <<1>> was received (You have <<2>>)"
WritCreater.strings["lootReceivedM"]				= "<<1>> was received "
WritCreater.strings["countSurveys"]				= "You have <<1>> surveys"
WritCreater.strings["countVouchers"]				= "You have <<1>> unearned Writ Vouchers"
WritCreater.strings["includesStorage"]				= function(type) local a= {"Surveys", "Master Writs"} a = a[type] return zo_strformat("Count includes <<1>> in house storage", a) end
WritCreater.strings["surveys"]						= "Crafting Surveys"
WritCreater.strings["sealedWrits"]					= "Sealed Writs"
WritCreater.strings["masterWritEnchantToCraft"]	= function(lvl, type, quality, writCraft, writName, generalName) 
										return zo_strformat("<<t:4>> <<t:5>> <<t:6>>: Crafting a <<t:1>> Glyph of <<t:2>> at <<t:3>> quality",lvl, type, quality,
											writCraft,writName, generalName) end
WritCreater.strings["masterWritSmithToCraft"]		= masterWritEnchantToCraft
WritCreater.strings["withdrawItem"]				= function(amount, link, remaining) return "Dolgubon's Lazy Writ Crafter retrieved "..amount.." "..link..". ("..remaining.." in bank)" end -- in Bank for German
WritCreater.strings['fullBag']						= "You have no open bag spaces. Please empty your bag."
WritCreater.strings['masterWritSave']				= "Dolgubon's Lazy Writ Crafter has saved you from accidentally accepting a master writ! Go to the settings menu to disable this option."
WritCreater.strings['missingLibraries']			= "Dolgubon's Lazy Writ Crafter requires the following standalone libraries. Please download, install or turn on these libraries: "
WritCreater.strings['resetWarningMessageText']		= "The daily reset for writs will be in <<1>> hour and <<2>> minutes\nYou can customize or turn off this warning in the settings"
WritCreater.strings['resetWarningExampleText']		= "The warning will look like this"




WritCreater.optionStrings = {}

setmetatable(WritCreater.optionStrings, findMissingTranslationsMetatable)

WritCreater.optionStrings.nowEditing                   = "You are changing %s settings"
WritCreater.optionStrings.accountWide                  = "Account Wide"
WritCreater.optionStrings.characterSpecific            = "Character Specific"
WritCreater.optionStrings.useCharacterSettings         = "Use character settings" -- de
WritCreater.optionStrings.useCharacterSettingsTooltip  = "Use character specific settings on this character only" --de
WritCreater.optionStrings["style tooltip"]								= function (styleName, styleStone) return zo_strformat("Allow the <<1>> style, which uses the <<2>> style stone, to be used for crafting",styleName, styleStone) end 
WritCreater.optionStrings["show craft window"]							= "Show Craft Window"
WritCreater.optionStrings["show craft window tooltip"]					= "Shows the crafting window when a crafting station is open"
WritCreater.optionStrings["autocraft"]									= "AutoCraft"
WritCreater.optionStrings["autocraft tooltip"]							= "Selecting this will cause the addon to begin crafting immediately upon entering a crafting station. If the window is not shown, this will be on."
WritCreater.optionStrings["blackmithing"]								= "Blacksmithing"
WritCreater.optionStrings["blacksmithing tooltip"]						= "Turn the addon on for Blacksmithing"
WritCreater.optionStrings["clothing"]									= "Clothing"
WritCreater.optionStrings["clothing tooltip"]							= "Turn the addon on for Clothing"
WritCreater.optionStrings["enchanting"]									= "Enchanting"
WritCreater.optionStrings["enchanting tooltip"]							= "Turn the addon on for Enchanting"
WritCreater.optionStrings["alchemy"]									= "Alchemy"
WritCreater.optionStrings["alchemy tooltip"]							= "Turn the addon on for Alchemy (Bank Withdrawal only)"
WritCreater.optionStrings["provisioning"]								= "Provisioning"
WritCreater.optionStrings["provisioning tooltip"]						= "Turn the addon on for Provisioning (Bank Withdrawal only)"
WritCreater.optionStrings["woodworking"]								= "Woodworking"
WritCreater.optionStrings["woodworking tooltip"]						= "Turn the addon on for Woodworking"
WritCreater.optionStrings["jewelry crafting"]							= "Jewelry Crafting"
WritCreater.optionStrings["jewelry crafting tooltip"]					= "Turn the addon on for Jewelry Crafting"
WritCreater.optionStrings["writ grabbing"]								= "Withdraw writ items"
WritCreater.optionStrings["writ grabbing tooltip"]						= "Grab items required for writs (e.g. nirnroot, Ta, etc.) from the bank"
WritCreater.optionStrings["style stone menu"]							= "Style Stones Used"
WritCreater.optionStrings["style stone menu tooltip"]					= "Choose which style stones the addon will use"
WritCreater.optionStrings["send data"]									= "Send Writ Data"
WritCreater.optionStrings["send data tooltip"]							= "Send information on the rewards received from your writ boxes. No other information is sent."
WritCreater.optionStrings["exit when done"]								= "Exit crafting window"
WritCreater.optionStrings["exit when done tooltip"]						= "Exit crafting window when all crafting is completed"
WritCreater.optionStrings["automatic complete"]							= "Automatic quest dialog"
WritCreater.optionStrings["automatic complete tooltip"]					= "Automatically accepts and completes quests when at the required place"
WritCreater.optionStrings["new container"]								= "Keep new status"
WritCreater.optionStrings["new container tooltip"]						= "Keep the new status for writ reward containers"
WritCreater.optionStrings["master"]										= "Master Writs"
WritCreater.optionStrings["master tooltip"]								= "If this is ON the addon will craft Master Writs you have active"
WritCreater.optionStrings["right click to craft"]						= "Right Click to Craft"
WritCreater.optionStrings["right click to craft tooltip"]				= "If this is ON the addon will craft Master Writs you tell it to craft after right clicking a sealed writ. Turn LibCustomMenu on to enable"
WritCreater.optionStrings["crafting submenu"]							= "Trades to Craft"
WritCreater.optionStrings["crafting submenu tooltip"]					= "Turn the addon off for specific crafts"
WritCreater.optionStrings["timesavers submenu"]							= "Timesavers"
WritCreater.optionStrings["timesavers submenu tooltip"]					= "Various small timesavers"
WritCreater.optionStrings["loot container"]								= "Loot container when received"
WritCreater.optionStrings["loot container tooltip"]						= "Loot writ reward containers when you receive them"
WritCreater.optionStrings["master writ saver"]							= "Save Master Writs"
WritCreater.optionStrings["master writ saver tooltip"]					= "Prevents Master Writs from being accepted"
WritCreater.optionStrings["loot output"]								= "Valuable Reward Alert"
WritCreater.optionStrings["loot output tooltip"]						= "Output a message when valuable items are received from a writ"
WritCreater.optionStrings["autoloot behaviour"]							= "Autoloot Behaviour" -- Note that the following three come early in the settings menu, but becuse they were changed
WritCreater.optionStrings["autoloot behaviour tooltip"]					= "Choose when the addon will autoloot writ reward containers" -- they are now down below (with untranslated stuff)
WritCreater.optionStrings["autoloot behaviour choices"]					= {"Copy the setting under the Gameplay settings", "Autoloot", "Never Autoloot"}
WritCreater.optionStrings["hide when done"]								= "Hide when done"
WritCreater.optionStrings["hide when done tooltip"]						= "Hide the addon window when all items have been crafted"
WritCreater.optionStrings['reticleColour']								= "Change Reticle Colour"
WritCreater.optionStrings['reticleColourTooltip']						= "Changes the Reticle colour if you have an uncompleted or completed writ at the station"
WritCreater.optionStrings['autoCloseBank']								= "Automatic Bank Dialog"
WritCreater.optionStrings['autoCloseBankTooltip']						= "Automatically enter and exit the banking dialogue if there are items to be withdrawn"
WritCreater.optionStrings['despawnBanker']								= "Despawn Banker"
WritCreater.optionStrings['despawnBankerTooltip']						= "Automatically despawn the banker after withdrawing items"
WritCreater.optionStrings['dailyResetWarnTime']							= "Minutes Before Reset"
WritCreater.optionStrings['dailyResetWarnTimeTooltip']					= "How many minutes before the daily reset the warning should be displayed"
WritCreater.optionStrings['dailyResetWarnType']							= "Daily Reset Warning"
WritCreater.optionStrings['dailyResetWarnTypeTooltip']					= "What type of warning should be displayed when the daily reset is about to occur"
WritCreater.optionStrings['dailyResetWarnTypeChoices']					={ "None","Type 1", "Type 2", "Type 3", "Type 4", "All"}
WritCreater.optionStrings['stealingProtection']							= "Stealing Protection"
WritCreater.optionStrings['stealingProtectionTooltip']					= "Prevent you from stealing while you have a writ in your journal"
WritCreater.optionStrings['noDELETEConfirmJewelry']						= "Easy Jewelry Writ Destruction"
WritCreater.optionStrings['noDELETEConfirmJewelryTooltip']				= "Automatically add the DELETE text confirmation to the delete Jewelry Writ dialog box"
WritCreater.optionStrings['suppressQuestAnnouncements']					= "Hide Writ Quest Announcements"
WritCreater.optionStrings['suppressQuestAnnouncementsTooltip']			= "Hides the text in the center of the screen when you start a writ or create an item for it"
WritCreater.optionStrings["questBuffer"]								= "Writ Quest Buffer"
WritCreater.optionStrings["questBufferTooltip"]							= "Keep a buffer of quests so you can always have room to pick up writs"
WritCreater.optionStrings["craftMultiplier"]							= "Craft multiplier"
WritCreater.optionStrings["craftMultiplierTooltip"]						= "Craft multiple copies of each required item so that you don't need to recraft them next time the writ comes up. Note: Save approximately 37 slots for each increase above 1"
WritCreater.optionStrings['hireling behaviour']							= "Hireling Mail Actions"
WritCreater.optionStrings['hireling behaviour tooltip']					= "What should be done with hireling mails"
WritCreater.optionStrings['hireling behaviour choices']					= { "Nothing","Loot and Delete", "Loot only"}


WritCreater.optionStrings["allReward"]									= "All Crafts"
WritCreater.optionStrings["allRewardTooltip"]							= "Action to take for all crafts"

WritCreater.optionStrings['sameForALlCrafts']							= "Use the same option for all"
WritCreater.optionStrings['sameForALlCraftsTooltip']					= "Use the same option for rewards of this type for all crafts"
WritCreater.optionStrings['1Reward']									= "Blacksmithing"
WritCreater.optionStrings['2Reward']									= "Use for all"
WritCreater.optionStrings['3Reward']									= "Use for all"
WritCreater.optionStrings['4Reward']									= "Use for all"
WritCreater.optionStrings['5Reward']									= "Use for all"
WritCreater.optionStrings['6Reward']									= "Use for all"
WritCreater.optionStrings['7Reward']									= "Use for all"

WritCreater.optionStrings["matsReward"]									= "Mat Rewards"
WritCreater.optionStrings["matsRewardTooltip"]							= "What to do with crafting material rewards"
WritCreater.optionStrings["surveyReward"]								= "Survey Rewards"
WritCreater.optionStrings["surveyRewardTooltip"]						= "What to do with survey rewards"
WritCreater.optionStrings["masterReward"]								= "Master Writ Rewards"
WritCreater.optionStrings["masterRewardTooltip"]						= "What to do with master writ rewards"
WritCreater.optionStrings["repairReward"]								= "Repair Kit Rewards"
WritCreater.optionStrings["repairRewardTooltip"]						= "What to do with repair kit rewards"
WritCreater.optionStrings["ornateReward"]								= "Ornate Gear Rewards"
WritCreater.optionStrings["ornateRewardTooltip"]						= "What to do with ornate gear rewards"
WritCreater.optionStrings["intricateReward"]							= "Intricate Gear Rewards"
WritCreater.optionStrings["intricateRewardTooltip"]						= "What to do with intricate gear rewards"
WritCreater.optionStrings["soulGemReward"]								= "Empty Soul Gems"
WritCreater.optionStrings["soulGemTooltip"]								= "What to do with empty soul gems"
WritCreater.optionStrings["glyphReward"]								= "Glyphs"
WritCreater.optionStrings["glyphRewardTooltip"]							= "What to do with glyphs"
WritCreater.optionStrings["recipeReward"]								= "Recipes"
WritCreater.optionStrings["recipeRewardTooltip"]						= "What to do with recipes"
WritCreater.optionStrings["fragmentReward"]								= "Psijic Fragments"
WritCreater.optionStrings["fragmentRewardTooltip"]						= "What to do with psijic fragments"


WritCreater.optionStrings["writRewards submenu"]						= "Writ Reward Handling"
WritCreater.optionStrings["writRewards submenu tooltip"]				= "What to do with all the rewards from writs"

WritCreater.optionStrings["jubilee"]									= "Loot Anniversary Boxes"
WritCreater.optionStrings["jubilee tooltip"]							= "Auto Loot Anniversary Boxes"
WritCreater.optionStrings["skin"]										= "Writ Crafter Skin"
WritCreater.optionStrings["skinTooltip"]								= "The skin for the Writ Crafter UI"
WritCreater.optionStrings["skinOptions"]								= {"Default", "Cheesy"}

WritCreater.optionStrings["rewardChoices"]								= {"Nothing","Deposit","Junk", "Destroy"}
WritCreater.optionStrings["scan for unopened"]							= "Open containers on Login"
WritCreater.optionStrings["scan for unopened tooltip"]					= "When you login, scan the bag for unopened writ containers and attempt to open them"

WritCreater.optionStrings["smart style slot save"]							= "Smart Style Slot Save"
WritCreater.optionStrings["smart style slot save tooltip"]					= "Will attempt to minimize slots used if non ESO+ by using smaller stacks of style stones first"

findMissingTranslationsMetatable["__newindex"] = function(t,k,v)WritCreater.missingTranslations[k] = nil rawset(t,k,v)  end
ZO_CreateStringId("SI_BINDING_NAME_WRIT_CRAFTER_CRAFT_ITEMS", "Craft items")
ZO_CreateStringId("SI_BINDING_NAME_WRIT_CRAFTER_OPEN", "Show Writ Crafter Stats window")
																		-- CSA, ZO_Alert, chat message, window

WritCreater.cheeseyLocalizations
=
{
	['menuName'] = "Ritual",
	['endeavorName'] = "Ritual Endeavors",
	['tasks']={
		{original="You found a strange pamphlet... Maybe you should /read it",name="You read some instructions on a ritual for luck", completion = "You learned how to do a ritual for luck!",
			description="Use the /read emote"},

		{original="???", name = "Obtain an innocent goat's guts", completion = "You monster! Anything for luck, I guess",
			description="Loot guts from a dead livestock goat. You don't have be the one to kill it... but that's the easiest way"},

		{original="???", name = "Head to the ritual site, Arananga", completion = "You made it! It seems like a very industrious place",
			description="Not sure where Arananga is? Maybe it's a 'gifted' crafting station..."},

		{original="???", name = "Destroy the goat guts", completion = "You 'burnt' the sacrifice",
			description="Destroy the |H1:item:42870:30:1:0:0:0:0:0:0:0:0:0:0:0:16:0:0:0:1:0:0|h|h you looted"},

		{original="???", name = "Praise RNGesus in chat", completion = "You feel strangely lucky, but maybe it's just a feeling...",
			description="You can't really tell what it actually said, but it's your best guess"},
				-- Or Nocturnal, or Fortuna, Tyche as easter eggs?

		-- {original="???", name = "Complete the ritual", completion = "Maybe you'll be just a little bit luckier... And Writ Crafter has a new skin!",
		-- description="Sheogorath will be very pleased if you complete them all!"},
	},
	["completePrevious"] = "You should probably complete the previous steps first",
	['allComplete'] = "You completed the ritual!",
	['allCompleteSubheading'] = "Even if RNGesus doesn't favour you next year, at least Writ Crafter has a new look!",
	["goatContextTextText"] = "Goat",
	["bookText"] = 
[[
This ritual  |L0:0:0:45%%:8%%:ignore|lwill|l might give you great luck. Make sure to follow these steps exactly!
1. Obtain some guts from a |L0:0:0:45%%:8%%:ignore|lsheep|l goat
2. Go to |L0:0:0:45%%:8%%:ignore|lOblivion|l Arananga
3. Burn the guts
4. Praise [the name here is illegible]

- Sincerely,
|L0:0:0:45%%:8%%:ignore|lSheogorath|l Not Sheogorath]],
["bookTitle"] = "A ritual for luck",
["outOfRange"] = "You're not in the ritual area anymore!",
["closeEnough"] = "Close enough",
["praiseHint "] = "Maybe you need to say something about RNGesus?",
}
--/esoui/art/icons/pet_041.dds
--/esoui/art/icons/pet_042.dds
--/esoui/art/icons/pet_sheepbrown.dds
