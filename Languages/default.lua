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

local function proper(str)
	if type(str)== "string" then
		return zo_strformat("<<C:1>>",str)
	else
		return str
	end
end

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
			text = "|cf60000Glyph could not be crafted. You do not have any "..proper(missing[i])
		else
			text = text.." or "..proper(missing[i])
		end
	end
	return text
end


local function dailyResetFunction(till) -- You can translate the following simple version instead.
										-- function (till) d(zo_strformat("<<1>> hours and <<2>> minutes until the daily reset.",till["hour"],till["minute"])) end,
	if till["hour"]==0 then
		if till["minute"]==1 then
			return "1 minute until daily server reset!"
		elseif till["minute"]==0 then
			if stamp==1 then
				return "Daily reset in "..stamp.." seconds!"
			else
				return "Seriously... Stop asking. Are you that impatient??? It resets in one more second godammit. Stupid entitled MMO players. *grumble grumble*"
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

WritCreater.strings = 
{
	["runeReq"] 					= function (essence, potency) return zo_strformat("|c2dff00Crafting will require 1 |rTa|c2dff00, 1 |cffcc66<<1>>|c2dff00 and 1 |c0066ff<<2>>|r", essence, potency) end,
	["runeMissing"] 				= runeMissingFunction ,
	["notEnoughSkill"]				= "You do not have a high enough crafting skill to make the required equipment",
	["smithingMissing"] 			= "\n|cf60000You do not have enough mats|r",
	["craftAnyway"] 				= "Craft anyway",
	["smithingEnough"] 				= "\n|c2dff00You have enough mats|r",
	["craft"] 						= "|c00ff00Craft|r",
	["crafting"] 					= "|c00ff00Crafting...|r",
	["craftIncomplete"] 			= "|cf60000Crafting could not be completed.\nYou need more mats.|r",
	["moreStyle"] 					= "|cf60000You do not have any usable style stones.\nCheck your inventory, achievements, and settings|r",
	["moreStyleSettings"]			= "|cf60000You do not have any usable style stones.\nYou likely need to allow more in the Settings Menu|r",
	["moreStyleKnowledge"]			= "|cf60000You do not have any usable style stones.\nYou might need to learn to craft more styles|r",
	["dailyreset"] 					= dailyResetFunction,
	["complete"] 					= "|c00FF00Writ complete.|r",
	["craftingstopped"]				= "Crafting stopped. Please check to make sure the addon is crafting the correct item.",
	["smithingReqM"] 				= function (amount, type, more) return zo_strformat( "Crafting will use <<1>> <<2>> (|cf60000You need <<3>>|r)" ,amount, type, more) end,
	["smithingReqM2"] 				= function (amount,type,more)     return zo_strformat( "\nAs well as <<1>> <<2>> (|cf60000You need <<3>>|r)"          ,amount, type, more) end,
	["smithingReq"] 				= function (amount,type, current) return zo_strformat( "Crafting will use <<1>> <<2>> (|c2dff00<<3>> available|r)"  ,amount, type, current) end,
	["smithingReq2"] 				= function (amount,type, current) return zo_strformat( "\nAs well as <<1>> <<2>> (|c2dff00<<3>> available|r)"         ,amount, type, current) end,
	["lootReceived"]				= "<<1>> was received",
	["countSurveys"]				= "You have <<1>> surveys",
	["countVouchers"]				= "You have <<1>> unearned Writ Vouchers",
	["includesStorage"]				= function(type) local a= {"Surveys", "Master Writs"} a = a[type] return zo_strformat("Count includes <<1>> in house storage", a) end,
	["surveys"]						= "Crafting Surveys",
	["sealedWrits"]					= "Sealed Writs",

}


WritCreater.optionStrings = {}
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
WritCreater.optionStrings["writ grabbing"]								= "Grab writ items"
WritCreater.optionStrings["writ grabbing tooltip"]						= "Grab items required for writs (e.g. nirnroot, Ta, etc.) from the bank"
WritCreater.optionStrings["delay"]										= "Item Grab Delay"
WritCreater.optionStrings["delay tooltip"]								= "How long to wait before grabbing items from the bank (milliseconds)"
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
WritCreater.optionStrings["right click to craft tooltip"]				= "If this is ON the addon will craft Master Writs you tell it to craft after right clicking a sealed writ"
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
WritCreater.optionStrings["container delay"]							= "Delay Container Looting"
WritCreater.optionStrings["container delay tooltip"]					= "Delay the autolooting of writ reward containers when you receive them"
WritCreater.optionStrings["hide when done"]								= "Hide when done"
WritCreater.optionStrings["hide when done tooltip"]						= "Hide the addon window when all items have been crafted"
WritCreater.optionStrings['reticleColour']								= "Change Reticle Colour"
WritCreater.optionStrings['reticleColourTooltip']						= "Changes the Reticle colour if you have an uncompleted or completed writ at the station"
