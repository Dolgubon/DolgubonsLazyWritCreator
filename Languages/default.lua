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
WritCreater = WritCreater or {}
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
{	-- english subject lines
	["Raw Enchanter Materials"] = true ,
	["Raw Clothier Materials"] = true ,
	["Raw Blacksmith Materials"] = true ,
	["Raw Woodworker Materials"] = true ,
	["Raw Provisioner Materials"] = true ,
	-- german subject lines
	["Schreinermaterial"] = true,
	["Versorgerzutaten"] = true,
	["Schneidermaterial"] = true,
	["Verzauberermaterial"] = true,
	["Schmiedematerial"] = true,
	-- french subject lines
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

-- Note for translators: I recommend translating this first dailyResetFunction only and skipping+removing the second dailyResetFunction.
local function dailyResetFunction(till) 
	d(zo_strformat("<<1>> hours and <<2>> minutes until the daily reset.",till["hour"],till["minute"])) 
end

local function dailyResetFunction(till, stamp)
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
	["Acquire"] = "acquire",
	}
	return strings
end

local function masterWritSmithCraft (link, trait, style, quality, writName, usedMimicStone)
	-- local partialString = zo_strformat("Crafting a CP150 <<t:6>> <<t:1>> from <<t:2>> with the <<t:3>> trait and <<t:4>> style at <<t:5>> quality",pat,set,trait,style,qual,mat)
	if usedMimicStone then
		return zo_strformat("<<t:5>>: Crafting a CP150 <<t:1>> with the <<t:2>> trait and <<t:3>> style at <<t:4>> quality with a mimic stone", link, trait, style, quality, writName)
	else
		return zo_strformat("<<t:5>>: Crafting a CP150 <<t:1>> with the <<t:2>> trait and <<t:3>> style at <<t:4>> quality", link, trait, style, quality, writName)
	end
end

WritCreater.missingTranslations = {}
WritCreater.missingTranslationsOrder = {}
local stringIndexTable = {}
local findMissingTranslationsMetatable = 
{
["__newindex"] = function(t,k,v) if not stringIndexTable[tostring(t)] then stringIndexTable[tostring(t)] = {} end stringIndexTable[tostring(t)][k] = v WritCreater.missingTranslations[k] = {k, v}
WritCreater.missingTranslationsOrder[#WritCreater.missingTranslationsOrder+1] = {k, v}
 end,
["__index"] = function(t, k) return stringIndexTable[tostring(t)][k] end,
}

WritCreater.strings = {}
setmetatable(WritCreater.strings, findMissingTranslationsMetatable)

WritCreater.strings["runeReq"] 						= function (essence, potency,taStack,essenceStack,potencyStack) 
	return zo_strformat("|c2dff00Crafting will require 1/<<3>> |rTa|c2dff00, 1/<<4>> |cffcc66<<1>>|c2dff00 and 1/<<5>> |c0066ff<<2>>|r", 
		essence, potency, taStack, essenceStack, potencyStack) 
end
WritCreater.strings["runeMissing"] 					= runeMissingFunction 
WritCreater.strings["notEnoughSkill"]				= "You do not have a high enough crafting skill to make the required equipment"
WritCreater.strings["smithingMissing"] 				= "\n|cf60000You do not have enough mats|r"
WritCreater.strings["craftAnyway"] 					= "Craft anyway"
WritCreater.strings["smithingEnough"] 				= "\n|c2dff00You have enough mats|r"
WritCreater.strings["craft"] 						= "|c00ff00Craft|r"
WritCreater.strings["crafting"] 					= "|c00ff00Crafting...|r"
WritCreater.strings["craftIncomplete"] 				= "|cf60000Crafting could not be completed.\nYou need more mats.|r"
WritCreater.strings["moreStyle"] 					= "|cf60000You do not have any usable style stones.\nCheck your inventory, achievements, and settings|r"
WritCreater.strings["moreStyleSettings"]			= "|cf60000You do not have any usable style stones.\nYou likely need to allow more in the Settings Menu|r"
WritCreater.strings["moreStyleKnowledge"]			= "|cf60000You do not have any usable style stones.\nYou might need to learn to craft more styles|r"
WritCreater.strings["dailyreset"] 					= dailyResetFunction
WritCreater.strings["complete"] 					= "|c00FF00Writ complete.|r"
WritCreater.strings["craftingstopped"]				= "Crafting stopped. Please check to make sure the addon is crafting the correct item."
WritCreater.strings["smithingReqM"] 				= function (amount, type, more) return zo_strformat( "Crafting will use <<1>> <<2>> (|cf60000You need <<3>>|r)" ,amount, type, more) end
WritCreater.strings["smithingReq"] 					= function (amount,type, current) return zo_strformat( "Crafting will use <<1>> <<2>> (|c2dff00<<3>> available|r)"  ,amount, type, 
														zo_strformat(SI_NUMBER_FORMAT, ZO_AbbreviateNumber(current, NUMBER_ABBREVIATION_PRECISION_TENTHS, USE_LOWERCASE_NUMBER_SUFFIXES))) end
WritCreater.strings["lootReceived"]					= "<<3>> <<1>> was received (You have <<2>>)"
WritCreater.strings["lootReceivedM"]				= "<<1>> was received "
WritCreater.strings["countSurveys"]					= "You have <<1>> surveys"
WritCreater.strings["countVouchers"]				= "You have <<1>> unearned Writ Vouchers"
WritCreater.strings["includesStorage"]				= function(type) local a= {"Surveys", "Master Writs"} a = a[type] return zo_strformat("Count includes <<1>> in house storage", a) end
WritCreater.strings["surveys"]						= "Crafting Surveys"
WritCreater.strings["sealedWrits"]					= "Sealed Writs"
-- This is the old one that was used. Since parameters have been changed, we remove this one and use the next one instead
-- WritCreater.strings["masterWritSmithToCraft"]		= masterWritEnchantToCraft
WritCreater.strings["newMasterWritSmithToCraft"]	= masterWritSmithCraft
WritCreater.strings["withdrawItem"]					= function(amount, link, remaining) return "Dolgubon's Lazy Writ Crafter retrieved "..amount.." "..link..". ("..remaining.." in bank)" end -- in Bank for German
WritCreater.strings['fullBag']						= "You have no open bag spaces. Please empty your bag."
WritCreater.strings['masterWritSave']				= "Dolgubon's Lazy Writ Crafter has saved you from accidentally accepting a master writ! Go to the settings menu to disable this option."
WritCreater.strings['missingLibraries']				= "Dolgubon's Lazy Writ Crafter requires the following standalone libraries. Please download, install or turn on these libraries: "
WritCreater.strings['resetWarningMessageText']		= "The daily reset for writs will be in <<1>> hour and <<2>> minutes\nYou can customize or turn off this warning in the settings"
WritCreater.strings['resetWarningExampleText']		= "The warning will look like this"
WritCreater.strings['lowInventory']					= "\nYou only have <<1>> free slots left and may not have enough free slots"
WritCreater.strings['masterWritQueueCleared']		= "Master Writ crafting queue cleared"
WritCreater.strings['multiplierCraftPrediction']	= "Crafting <<2>> items for <<1[nothing/$d cycle/$d cycles]>> of writs"

WritCreater.strings['alchemyNoCombo']				= "Could not find a cheap enough known reagent combo. Try acquiring other types of alchemy items"
WritCreater.strings['alchemyMissing']				= 
function(missingTable)
	local missingOut = "You are missing "
	for missingItemId, v in pairs(missing) do
		missingOut = missingOut..getItemLinkFromItemId(missingItemId).." "
	end
	missingOut = missingOut.." to craft the cheapest combo"
	return missingOut
end
WritCreater.strings['alchemyLowPassive']			= "You have selected to craft a full stack, but you do not have the craft multiplication passives active"
WritCreater.strings['alchemyCraftReqs']				= "Crafting will use <<t:4>> <<t:1>>, <<t:4>> <<t:2>>, and <<t:4>> <<t:3>>"
WritCreater.strings['alchemyMasterReqs']			= "<<t:1>>: Crafting a <<t:2>> using <<t:3>>, <<t:4>>, and <<t:5>>"
WritCreater.strings['depositGold']					= "Writ Crafter: Depositing <<1>> gold"
WritCreater.strings['depositItemMissing']			= "Writ Crafter: Could not find <<t:1>> to deposit. Item may have been destroyed or moved"
WritCreater.strings['depositItem']					= "Writ Crafter: Depositing <<t:1>>"
WritCreater.strings['welcomeMessage']				= "Thanks for installing Dolgubon's Lazy Writ Crafter! Please check out the settings to customize the behaviour of the addon"
WritCreater.strings['keybindStripBlurb']			= "Craft Writ Items"
WritCreater.strings['pressToCraft']					= "\nPress |t32:32:<<1>>|t to craft"
WritCreater.strings['goldenPursuitCraft']			= "Craft set items for unfinished golden pursuits?\n(May be unable to craft anything. Axe/Bow/Ring/Robe only, uses iron)"
WritCreater.strings['fullInventory']				= "Your inventory is full"
WritCreater.strings['provisioningUnknownRecipe']	= "You do not know the recipe for <<1>>"
WritCreater.strings['provisioningCraft']			= "Writ Crafter will craft <<1>>"
WritCreater.strings['transmuteLooted']				= "<<1>> Transmute Stone recieved (You have <<2>>)"
WritCreater.strings['transmuteLimitApproach']		= "You are approaching the transmute stone limit. If a box would put you over the transmute stone limit, Writ Crafter will not loot the stones."
WritCreater.strings['transmuteLimitHit']			= "Looting these transmute stones would put you over the maximum, so <<1>> transmute stones were not looted"
WritCreater.strings['lootingMarkJunk']				= "Writ Crafter: Marked <<1>> as junk"
WritCreater.strings['lootingDestroyItem']			= "Writ Crafter: Destroyed <<1>> because you told it to in the settings menu"
WritCreater.strings['lootingDeconItem']				= "Writ Crafter: Queued <<1>> for deconstruction"
WritCreater.strings['lootingDeposit']				= "Writ Crafter: <<1>> items queued up for bank deposit"
WritCreater.strings['mailComplete']					= "Writ Crafter: Mail Looting complete"
WritCreater.strings['mailNumLoot']					= "Writ Crafter: <<1>> hireling mails found"
WritCreater.strings['masterRecipeUnknown']			= "<<t:1>>: Could not queue as you do not know the recipe for <<t:2>>"
WritCreater.strings['masterEnchantCraft']			= "<<t:1>>: Crafting <<t:2>>"
WritCreater.strings['masterRecipeCraft']			= "<<t:1>>: Crafting <<t:3>>x<<t:2>>"
WritCreater.strings['masterRecipeError']			= "<<1>>: Could not queue for writ. You might not know the required recipe"
WritCreater.strings['masterQueueNotFound']			= "Could not determine how many items to craft. Try accepting the writ."
WritCreater.strings['masterQueueBlurb']				= "Craft Writ"
WritCreater.strings['masterQueueSummary']			= "Writ Crafter queued <<1>> sealed writs"
WritCreater.strings['abandonQuestBanItem']			= "Writ Crafter abandoned the <<1>> because it requires <<2>> which was disallowed for use in the settings"
WritCreater.strings['writBufferNotification']		= "The writ Quest Buffer from Lazy Writ Crafter™ is preventing you from accepting this quest"
WritCreater.strings['masterStopAcceptNoCraftSkill'] = "Lazy Writ Crafter™ prevented you from accepting this writ because you cannot craft it"
WritCreater.strings['stealingProtection'] 			= "The Lazy Writ Crafter™ has saved you from stealing while doing writs!"
WritCreater.strings['statsWitsDone']				= "Writs Done: <<1>> in the past <<2>> days"
WritCreater.strings['deconstructSuccess']			= "Writ Crafter: Deconstructed <<1>>"
WritCreater.strings['potion']						= "potion"
WritCreater.strings['poison']						= "poison"
WritCreater.strings['junkSold']						= "Writ Crafter: Sold all Junk items"




WritCreater.optionStrings = {}

setmetatable(WritCreater.optionStrings, findMissingTranslationsMetatable)

WritCreater.optionStrings.nowEditing                   = "You are changing %s settings"
WritCreater.optionStrings.accountWide                  = "Account Wide"
WritCreater.optionStrings.characterSpecific            = "Character Specific"
WritCreater.optionStrings.useCharacterSettings         = "Use character settings" -- de
WritCreater.optionStrings.useCharacterSettingsTooltip  = "Use character specific settings on this character only" --de
WritCreater.optionStrings["style tooltip"]								= function (styleName, styleStone) return zo_strformat("Allow the <<1>> style, which uses the "..styleStone.." style stone, to be used for crafting",styleName, styleStone) end 
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
WritCreater.optionStrings["alchemy tooltip"]							= "Turn the addon on for Alchemy. It's suggested to pre-craft stacks of required writ items, but crafting is supported"
WritCreater.optionStrings["alchemyChoices"]								= {"Off","All Features","Skip Autocraft"}
WritCreater.optionStrings["provisioning"]								= "Provisioning"
WritCreater.optionStrings["provisioning tooltip"]						= "Turn the addon on for Provisioning. It's suggested to pre-craft stacks of required writ items, but crafting is supported"
WritCreater.optionStrings["woodworking"]								= "Woodworking"
WritCreater.optionStrings["woodworking tooltip"]						= "Turn the addon on for Woodworking"
WritCreater.optionStrings["jewelry crafting"]							= "Jewelry Crafting"
WritCreater.optionStrings["jewelry crafting tooltip"]					= "Turn the addon on for Jewelry Crafting"
WritCreater.optionStrings["writ grabbing"]								= "Withdraw writ items"
WritCreater.optionStrings["writ grabbing tooltip"]						= "Grab items required for writs (e.g. nirnroot, Ta, etc.) from the bank"
WritCreater.optionStrings["style stone menu"]							= "Style Stones Used"
WritCreater.optionStrings["style stone menu tooltip"]					= "Choose which style stones the addon will use"
WritCreater.optionStrings["exit when done"]								= "Exit crafting window"
WritCreater.optionStrings["exit when done tooltip"]						= "Exit crafting window when all crafting is completed"
WritCreater.optionStrings["automatic complete"]							= "Automatic quest dialog"
WritCreater.optionStrings["automatic complete tooltip"]					= "Automatically accepts and completes quest dialog at writ boards and turnins"
WritCreater.optionStrings["new container"]								= "Keep new status"
WritCreater.optionStrings["new container tooltip"]						= "Keep the new status for writ reward containers"
WritCreater.optionStrings["master"]										= "Master Writs"
WritCreater.optionStrings["master tooltip"]								= "If this is ON the addon will craft Master Writs you have active"
WritCreater.optionStrings["right click to craft"]						= "Right Click to Craft"
WritCreater.optionStrings["right click to craft tooltip"]				= "If this is ON the addon will craft Master Writs you tell it to craft after right clicking a sealed writ. Turn LibCustomMenu on to enable"
WritCreater.optionStrings["crafting submenu"]							= "Daily Writs to Craft"
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
WritCreater.optionStrings['despawnBanker']								= "Despawn Banker (Withdrawals)"
WritCreater.optionStrings['despawnBankerTooltip']						= "Automatically exit and despawn the banker after withdrawing items"
WritCreater.optionStrings['despawnBankerDeposit']						= "Exit and Despawn Banker (Deposits)"
WritCreater.optionStrings['despawnBankerDepositTooltip']				= "Automatically despawn the banker after depositing items"
WritCreater.optionStrings['dailyResetWarnTime']							= "Minutes Before Reset"
WritCreater.optionStrings['dailyResetWarnTimeTooltip']					= "How many minutes before the daily reset the warning should be displayed"
WritCreater.optionStrings['dailyResetWarnType']							= "Daily Reset Warning"
WritCreater.optionStrings['dailyResetWarnTypeTooltip']					= "What type of warning should be displayed when the daily reset is about to occur"
WritCreater.optionStrings['dailyResetWarnTypeChoices']					={ "None","Announcement", "Top Right", "Chat", "Popup", "All"}
WritCreater.optionStrings['stealingProtection']							= "Stealing Protection"
WritCreater.optionStrings['stealingProtectionTooltip']					= "Prevent you from stealing while you have a writ in your journal"
WritCreater.optionStrings['noDELETEConfirmJewelry']						= "Easy Jewelry Writ Destruction"
WritCreater.optionStrings['noDELETEConfirmJewelryTooltip']				= "Automatically add the DELETE text confirmation to the delete Jewelry Writ dialog box"
WritCreater.optionStrings['suppressQuestAnnouncements']					= "Hide Writ Quest Announcements"
WritCreater.optionStrings['suppressQuestAnnouncementsTooltip']			= "Hides the text in the center of the screen when you start a writ or create an item for it"
WritCreater.optionStrings["questBuffer"]								= "Writ Quest Buffer"
WritCreater.optionStrings["questBufferTooltip"]							= "Keep a buffer of quests so you can always have room to pick up writs"
WritCreater.optionStrings["craftMultiplier"]							= "Craft multiplier (equipment and glyphs)"
WritCreater.optionStrings["craftMultiplierTooltip"]						= "Craft multiple copies of each required item so that you don't need to recraft them next time the writ comes up. Note: Save approximately 37 inventory slots for each increase above 1"
WritCreater.optionStrings["craftMultiplierConsumables"]					= "Craft multiplier (alchemy and provisioning)"
WritCreater.optionStrings["craftMultiplierConsumablesTooltip"]			= "Single craft will do one crafting action, which may be multiplied due to passives. Full Stack will craft 100 of the required item, if you have the multiplier passives"
WritCreater.optionStrings["craftMultiplierConsumablesChoices"]			= {"Single craft","Full Stack"}
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
WritCreater.optionStrings["currencyReward"]								= "Gold Currency"
WritCreater.optionStrings["currencyRewardTooltip"]						= "What to do with quest reward gold"
WritCreater.optionStrings["goldMatReward"]								= "Gold Mats (Non ESO+ only)"
WritCreater.optionStrings["goldMatRewardTooltip"]						= "What to do with gold mats from writ rewards. Ignored for ESO+ subscribers"



WritCreater.optionStrings["writRewards submenu"]						= "Writ Reward Handling"
WritCreater.optionStrings["writRewards submenu tooltip"]				= "What to do with all the rewards from writs"

WritCreater.optionStrings["jubilee"]									= "Loot Anniversary/Zenithar Boxes"
WritCreater.optionStrings["jubilee tooltip"]							= "Auto Loots Anniversary and Zenithar Boxes"
WritCreater.optionStrings["skin"]										= "Writ Crafter Skin"
WritCreater.optionStrings["skinTooltip"]								= "The skin for the Writ Crafter UI"
WritCreater.optionStrings["skinOptions"]								= {"Default", "Cheesy", "Goaty", "Fabulous"}
WritCreater.optionStrings["goatSkin"]									= "Goaty"
WritCreater.optionStrings["cheeseSkin"]									= "Cheesy"
WritCreater.optionStrings["fabulousSkin"]								= "Fabulous"
WritCreater.optionStrings["defaultSkin"]								= "Default"
WritCreater.optionStrings["rewardChoices"]								= {"Nothing","Deposit","Junk", "Destroy", "Deconstruct"}
WritCreater.optionStrings["scan for unopened"]							= "Open containers on Login"
WritCreater.optionStrings["scan for unopened tooltip"]					= "When you login, scan the bag for unopened writ containers and attempt to open them"

WritCreater.optionStrings["smart style slot save"]						= "Lowest amount first"
WritCreater.optionStrings["smart style slot save tooltip"]				= "Will attempt to minimize slots used if non ESO+ by using smaller stacks of style stones first"
WritCreater.optionStrings["abandon quest for item"]						= "Writs with 'deliver <<1>>'"
WritCreater.optionStrings["abandon quest for item tooltip"]				= "If OFF, will auto abandon writs requiring you to deliver <<1>>. Quests which require you to craft an item requireing <<1>> will never be abandoned"
WritCreater.optionStrings["status bar submenu"]							= "Status Bar"
WritCreater.optionStrings["status bar submenu tooltip"]					= "Options for the Writ Status Bar"
WritCreater.optionStrings['showStatusBar']								= "Show Status Bar"
WritCreater.optionStrings['showStatusBarTooltip']						= "Show or hide quest status bar"
WritCreater.optionStrings['statusBarIcons']								= "Use Icons"
WritCreater.optionStrings['statusBarIconsTooltip']						= "Shows Crafting Icons instead of letters for each writ type"
WritCreater.optionStrings['transparentStatusBar']						= "Transparent Status Bar"
WritCreater.optionStrings['transparentStatusBarTooltip']				= "Make the status bar transparent"
WritCreater.optionStrings['statusBarInventory']							= "Inventory Tracker"
WritCreater.optionStrings['statusBarInventoryTooltip']					= "Add an inventory tracker to the status bar"
WritCreater.optionStrings['incompleteColour']							= "Incomplete quest colour"
WritCreater.optionStrings['completeColour']								= "Complete quest colour"
WritCreater.optionStrings['smartMultiplier']							= "Smart Multiplier"
WritCreater.optionStrings['smartMultiplierTooltip']						= "If on, Writ Crafter will craft items for the full cycle of 3 days of writs. It will also check to see if you have any writ items"..
" already, and take that into consideration. If off, Writ Crafter will simply craft multiple items of the current day's writs"
WritCreater.optionStrings['craftHousePort']								= "Port to crafting house"
WritCreater.optionStrings['craftHousePortTooltip'] 						= "Port to a publicly available crafting house. If you use this often, you can use LibRadialMenu to have a shortcut"
WritCreater.optionStrings['craftHousePortButton']						= "Port"
WritCreater.optionStrings['reportBug']									= "Report a bug"
WritCreater.optionStrings['reportBugTooltip']							= "Open a thread to report bugs specifically with the console version of writ crafter. Please check to make sure the issue hasn't been reported yet."
WritCreater.optionStrings['openUrlButtonText']							= "Open URL"
WritCreater.optionStrings['donate']										= "Donate"
WritCreater.optionStrings['donateTooltip']								= "Donate to Dolgubon on Paypal"
WritCreater.optionStrings['writStats']									= "Writ Stats"
WritCreater.optionStrings['writStatsTooltip']							= "View historical writ reward statistics of writs done with the addon installed. If you use this often, you can use LibRadialMenu to have a shortcut"
WritCreater.optionStrings['writStatsButton']							= "Open window"
WritCreater.optionStrings['queueWrits']									= "Queue all sealed writs"
WritCreater.optionStrings['queueWritsTooltip']							= "Queue all sealed writs in your inventory. If you use this often, you can use LibRadialMenu to have a shortcut"
WritCreater.optionStrings['queueWritsButton']							= "Queue"
WritCreater.optionStrings['mainSettings']								= "Main Settings"
WritCreater.optionStrings['statusBarHorizontal']						= "Horizontal Position"
WritCreater.optionStrings['statusBarHorizontalTooltip']					= "Horizontal position of the status bar"
WritCreater.optionStrings['statusBarVertical']							= "Vertical Position"
WritCreater.optionStrings['statusBarVerticalTooltip']					= "Vertical position of the status bar"
WritCreater.optionStrings['keepItemWritFormat']							= "Keep <<1>>"
WritCreater.optionStrings["npcStyleStoneReminder"]						= "Reminder: You can purchase base racial style stones from any crafting NPC vendor for 15g each"
WritCreater.optionStrings['voucherCount']								= "Count # of unearned Writ Vouchers"
WritCreater.optionStrings['voucherCountTooltip']						= "Output the total number of writ vouchers of all sealed master writs in the player's inventory and bank"
WritCreater.optionStrings['surveyCount']								= "Count # of surveys"
WritCreater.optionStrings['surveyCountTooltip']							= "Outputs a breakdown of the number of surveys in the player's inventory and bank"
WritCreater.optionStrings["mimicStoneUse"]								= "Mimic stones for master writs"
WritCreater.optionStrings["mimicStoneUseTooltip"]						= "Defines the usage of mimic stones for master writs. Clears current master writ queue\nMimic stones will never be used for daily writs. (Buy for 15g ea. from NPC merchants)"
WritCreater.optionStrings['mimicStoneUseChoices']						= {"Do not use" , "Always use", "Use if no style stones", "Use if price > 1k", "Use if price > 3k"}
WritCreater.optionStrings['masterWritQueueCleared']						= "Master Writ crafting queue cleared"



findMissingTranslationsMetatable["__newindex"] = function(t,k,v)WritCreater.missingTranslations[k] = nil rawset(t,k,v)  end
WritCreater.missingTranslationMetatable = findMissingTranslationsMetatable
ZO_CreateStringId("SI_BINDING_NAME_WRIT_CRAFTER_CRAFT_ITEMS", "Craft items")
ZO_CreateStringId("SI_BINDING_NAME_WRIT_CRAFTER_OPEN", "Show Writ Crafter Stats window")
-- text for crafting a sealed writ in the keybind area. Only for Gamepad
ZO_CreateStringId("SI_CRAFT_SEALED_WRIT", "Craft writ")
																		-- CSA, ZO_Alert, chat message, window

function WritCreater.sortMissingTranslations()
	for i = 1, #WritCreater.missingTranslationsOrder do
		local v = WritCreater.missingTranslationsOrder[i]
		if WritCreater.missingTranslations[v[1]] then
			if type(v[2])=="table" then
				local s= ""
				for j = 1, #v[2] do
					s = s..v[2][j].." , "
				end
				d(v[1].." : "..s)
			else
				d(v[1].." : "..tostring(v[2]))
			end
		end
	end
	local sorted = {}
	for k, v in pairs(WritCreater.missingTranslations) do
		table.insert(sorted, v)
	end
	table.sort(sorted, function(a, b) return a[1] < b[1] end)
end
-- alchemyMissing : You are missing  <<list of items missing>>  to craft the cheapest combo
-- newMasterWritSmithToCraft : <<t:5>>: Crafting a CP150 <<t:1>> with the <<t:2>> trait and <<t:3>> style at <<t:4>> quality
-- /script local sorted = {} for k, v in pairs(WritCreater.missingTranslations) do table.insert(sorted, v) end table.sort(sorted, function(a, b) return a[1] > b[1] end) for i = 1, #sorted do d(sorted[i][1].." : "..tostring(sorted[i][2])) end


--------------------------------
--- THIS IS UNDER DEVELOPMENT. DO NOT TRANSLATE YET
--------------------------------
WritCreater.cheeseyLocalizations
=
{
	-- Note for translation: Anything on the same line after two -- should not be translated
	['menuName'] = "|cFFBF00Pyrite Pursuit|r",
	['initialDescription'] = "Why not just /read the pamphlet first?",
	['readDescription'] = "After discovering that his head crafter was using a Crafting Helper Add-on To Generate Processed Trash, the Lord of the Creatives is looking for a new lead crafter. Try your hand at getting the job!",
	['endeavorName'] = "Pyrite Pursuits",-- Note for translation: Pyrite, aka Fool's Gold. Play on Fool = Crazy =  Sheogorath, Fool in April Fools, and Golden Pursuits, bc that's where this lives
	['completionShout'] = "<<1>>/<<2>> |cFFBF00Pyrite Pursuit|r Completed!", -- e.g. 1/6 pyrite pursuit completed!
	['tasks']={
		-------------------------
		-- Note for translations:
		-- The list contains some wordplay on various daedric artefacts or other jokes. If they don't translate well (good chance) feel free to just do literal translations.
		-- Robber's Jack: Sounds like Wabbajack. Satisfied by creating a Jack from one of: the Redistributor set, the Daedric trickery set, or the Daring corsair set
		-- Amulet of Blings: Rhymes with Amulet of Kings. Satisfied by creating an electrum necklace
		-- Totally real ebony blade: Refers to the ebony blade (Mephala artefact, from crypt of hearts). Satisfied by, you guessed it, an ebony blade
		-- Staff of Magnus Gift: Gift is crossed out. Refers to the Staff of Magnus. Satisfied by a staff from the Magnus Gift set
		-- Cheesecake is a lie: Refers to 'the cake is a lie' and Sheogorath liking cheese. Satisfied by making a cheesecake
		-- Lord of the creatives, trickster, lord of the dranged, fourth corner (of the house of troubles), lord of the never there, and Dam Dog (Mad God backwards) are all names for sheogorath. 
		-- Translations can use any nickname for him, Uncle Sheo, or even just do Sheogorath if you can't find/don't know any

		-- Original: Shown prior to the completion of the first task
		-- Name: Shown in the pursuits window
		-- placehold: shown in place of name after completion (if present)
		-- completion: Shown as a popup when task is complete
		-- Description: Long form description. Should explain exactly what needs to be done. Shown as a tooltip on PC
		-- completedDescription: description after completion
		-------------------------
		{original="You found a pamphlet titled 'Help Wanted'... Maybe you should /read it",name="/Read the pamphlet you found",placehold="You found a Help Wanted pamphlet from the Lord of the Creatives", completion = "Seems like the Lord of the Creatives is hiring?",
			description="You found a pamphlet labelled 'Help Wanted'. You can use the /read emote to read it", completedDescription="You read the pamphlet"},

		{original="???", name = "Craft a Robber Jack", completion = "It might not transform anyone into cheese, but it'll still transform your look!",
			description="The Trickster likes to transform things. Transform yourself into a robber by crafting a jack from the Daring Corsair set", 
			completedDescription="Maybe in time, the Robbajack will become just as powerful as the Wabbajack."}, -- requires 3 traits

		{original="???", name = "Craft the Amulet of Blings", completion = "This necklace would probably look fabulous on you! If only you could see it when you wear it",
			description="The Lord of the Deranged is rich! Show him you can make use of his riches by making an Electrum Necklace",
		completedDescription="Despite being made of real metal, it seems to disappear when you wear it... a sign of power, maybe?"},

		{original="???", name = "Craft the Ebony Blade", completion = "Wasn't this supposed to steal your soul or something? Maybe you made it wrong",
			description="The Fourth Corner would love to replicate the Ebony Blade's ability to turn its users insane. Show that you can help by making a bladed Ebony weapon",
		completedDescription="The Ebony Blade. Such an unassuming name for such a... Actually, this blade is pretty mundane, so the name fits perfectly."},

		{original="???", name = "Craft a Staff of Magnus |L0:0:0:40%%:20%%:|lGift|l", completion = "The power of Magnus |L0:0:0:40%%:20%%:|lGift|l is yours!",
		description="The Lord of the Never-There's lead crafter needs to be able to create |L0:0:0:50%%:10%%:|lpowerful|l staves. Create a staff from the Magnus' Gift set",
		completedDescription="Unfortunately, ignoring that pesky |L0:0:0:50%%:10%%:|lgift|l in the name didn't make it anymore powerful"}, -- requires 4 traits

		{original="???", name = "Bake 1 Cheesecake is a lie", completion = "CHEEEEEESEcake.. It definitely seems real enough",
		description="Dam Dogs love to eat cheesecake! A lead crafter would need to be able to bake the BEST type of cake",completedDescription="You crafted a cheesecake and you're pretty sure it's real"},
	},
	["unknownMonumentalTask"] = "Read the pamphlet to reveal the task",
	['claimRewardHeader'] = "Hope you had fun doing some |cFFBF00Pyrite Pursuits|r!",
	['claimRewardSubheading'] = "Check out Writ Crafter's new look next time you do writs!",

	-- Note for translation: Crafting Helper Add-on To Generate Processed Trash = CHAT GPT. For translations, could also use/reference AI, Automation, etc.
	["bookText"] = 
[[
After discovering that his head crafter was using a Crafting Helper Add-on To Generate Processed Trash, the Lord of the Creatives is looking for a new lead crafter! (He still has a head crafter, but they're kinda useless without a body)

To apply, please craft the following:
1 Robber Jack
1 Amulet of Blings
1 Totally real Ebony Blade
1 Staff of Magnus |L0:0:0:40%%:20%%:|lGift|l
1 Cheesecake is a lie
]],
	["bookTitle"] = "Help Wanted",
	["superAmazingCraftSounds"] = { 
		-- Translation notes: These are displayed randomly when crafting around the screen
		{"CLANG","CLING","CLINK","CLUNK","PING"}, -- Blacksmithing sounds
		{"SNIP","RUSTLE"}, -- Clothing sounds
		{"ALAKAZAM","ABRACADABRA","HOCUS POCUS","PRESTO"}, -- Enchanting sounds
		{"SPLISH","SPLASH","PLOP","SLOSH"}, -- Alchemy sounds
		{"SIZZLE","POP","BUBBLE"}, -- Cooking sounds
		{"BUZZ","THUD","CRACK","WHACK"}, -- Woodworking sounds
		{"TING","PLINK","PING"}, -- Jewelry sounds
	},
	["extraSlash"] = nil, -- if your language has a translation for /read, put it here. 
}

-------------------------------
-- END TRANSLATIONS HERE, DO NOT TRANSLATE FURTHER
-- Deleted ideas:
-- Stuff of Worms
-- Ghastly Eye Bowl - Crafted using worms. So 'Stuff' of worms
-- Maybe replace craft result with 'new name'?
-- Alchemical mix of violet coprinus and Dragon's Bile - inert. Might need to rethink
-- Vile and dung/Bile an' Dung - imp stoll + Vile Coagulant or Dragon's Bile. But both are inert as well


--/esoui/art/icons/pet_041.dds
--/esoui/art/icons/pet_042.dds
--/esoui/art/icons/pet_sheepbrown.dds

