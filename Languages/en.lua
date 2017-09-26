

-- If you are looking to translate this to something else, and run into problems, please contact Dolgubon on ESOUI.
local function proper(str)
	if type(str)== "string" then
		return zo_strformat("<<C:1>>",str)
	else
		return str
	end
end

function WritCreater.langWritNames() --Exact!!!  I know for german alchemy writ is Alchemistenschrieb - so ["G"] = schrieb, and ["A"]=Alchemisten
	local names = {
	["G"] = "Writ",
	[CRAFTING_TYPE_ENCHANTING] = "Enchanter",
	[CRAFTING_TYPE_BLACKSMITHING] = "Blacksmith",
	[CRAFTING_TYPE_CLOTHIER] = "Clothier",
	[CRAFTING_TYPE_PROVISIONING] = "Provisioner",
	[CRAFTING_TYPE_WOODWORKING] = "Woodworker",
	[CRAFTING_TYPE_ALCHEMY] = "Alchemist",
	}
	return names
end

function WritCreater.langMasterWritNames()
	local names = {
	["M"] 							= "masterful",
	["M1"]							= "master",
	[CRAFTING_TYPE_ALCHEMY]			= "concoction",
	[CRAFTING_TYPE_ENCHANTING]		= "glyph",
	[CRAFTING_TYPE_PROVISIONING]	= "feast",
	["plate"]						= "plate",
	["tailoring"]					= "tailoring",
	["leatherwear"]					= "leatherwear",
	["weapon"]						= "weapon",
	["shield"]						= "shield",
	}
return names

end

function WritCreater.writCompleteStrings()
	local strings = {
	["place"] = "Place the goods",
	["sign"] = "Sign the Manifest",
	["masterPlace"] = "I've finished the ",
	["masterSign"] = "<Finish the job.>",
	["masterStart"] = "<Accept the contract.>",
	}
	return strings
end


function WritCreater.languageInfo() --exact!!!

local craftInfo = 
	{
		[ CRAFTING_TYPE_CLOTHIER] = 
		{
			["pieces"] = --exact!!
			{
				[1] = "robe",
				[2] = "jerkin",
				[3] = "shoes",
				[4] = "gloves",
				[5] = "hat",
				[6] = "breeches",
				[7] = "epaulet",
				[8] = "sash",
				[9] = "jack",
				[10]= "boots",
				[11]= "bracers",
				[12]= "helmet",
				[13]= "guards",
				[14]= "cops",
				[15]= "belt",
			},
			["match"] = --exact!!! This is not the material, but rather the prefix the material gives to equipment. e.g. Homespun Robe, Linen Robe
			{
				[1] = "Homespun", --lvtier one of mats
				[2] = "Linen",	--l
				[3] = "Cotton",
				[4] =  "Spidersilk",
				[5] = "Ebonthread",
				[6] = "Kresh",
				[7] = "Ironthread",
				[8] = "Silverweave",
				[9] = "Shadowspun",
				[10]= "Ancestor",
				[11]= "Rawhide",
				[12]= "Hide",
				[13]= "Leather",
				[14]= "Full-Leather",
				[15]= "Fell",
				[16]= "Brigandine",
				[17]= "Ironhide",
				[18]= "Superb",
				[19]= "Shadowhide",
				[20]= "Rubedo",
			},
	
		},
		[CRAFTING_TYPE_BLACKSMITHING] = 
		{
			["pieces"] = --exact!!
			{
				[1] = "axe",
				[2] = "mace",
				[3] = "sword",
				[4] = "battle",
				[5] ="maul",
				[6] ="greatsword",
				[7] = "dagger",
				[8] = "cuirass",
				[9] = "sabatons",
				[10] = "gauntlets",
				[11] = "helm",
				[12] = "greaves",
				[13] = "pauldron",
				[14] = "girdle",
			},
			["match"] = --exact!!! This is not the material, but rather the prefix the material gives to equipment. e.g. Iron Axe, Steel Axe
			{
				[1] = "Iron",
				[2] = "Steel",
				[3] = "Orichalc",
				[4] = "Dwarven",
				[5] = "Ebon",
				[6] = "Calcinium",
				[7] = "Galatite",
				[8] = "Quicksilver",
				[9] = "Voidsteel",
				[10]= "Rubedite",
			},

		},
		[CRAFTING_TYPE_WOODWORKING] = 
		{
			["pieces"] = --Exact!!!
			{
				[1] = "bow",
				[3] = "inferno",
				[4] ="Ice",
				[5] ="lightning",
				[6] ="restoration",
				[2] ="shield",
			},
			["match"] = --exact!!! This is not the material, but rather the prefix the material gives to equipment. e.g. Maple Bow. Oak Bow.
			{
				[1] = "Maple",
				[2] =  "Oak",
				[3] =  "Beech",
				[4] = "Hickory",
				[5] = "Yew",
				[6] =  "Birch",
				[7] = "Ash",
				[8] = "Mahogany",
				[9] = "Nightwood",
				[10] = "Ruby",
			},

		},
		[CRAFTING_TYPE_ENCHANTING] = 
		{
			["pieces"] = --exact!!
			{ --{String Identifier, ItemId, positive or negative}
				{"disease", 45841,2},
				{"foulness", 45841,1},
				{"absorb stamina", 45833,2},
				{"absorb magicka", 45832,2},
				{"absorb health", 45831,2},
				{"frost resist",45839,2},
				{"frost",45839,1},
				{"feat", 45836,2},
				{"stamina recovery", 45836,1},
				{"hardening", 45842,1},
				{"crushing", 45842,2},
				{"onslaught", 68342,2},
				{"defense", 68342,1},
				{"shielding",45849,2},
				{"bashing",45849,1},
				{"poison resist",45837,2},
				{"poison",45837,1},
				{"spell harm",45848,2},
				{"magical",45848,1},
				{"magicka recovery", 45835,1},
				{"spell cost", 45835,2},
				{"shock resist",45840,2},
				{"shock",45840,1},
				{"health recovery",45834,1},
				{"decrease health",45834,2},
				{"weakening",45843,2},
				{"weapon",45843,1},
				{"boost",45846,1},
				{"speed",45846,2},
				{"flame resist",45838,2},
				{"flame",45838,1},
				{"decrease physical", 45847,2},
				{"increase physical", 45847,1},
				{"stamina",45833,1},
				{"health",45831,1},
				{"magicka",45832,1}
			},
			["match"] = --exact!!! The names of glyphs. The prefix (in English) So trifling glyph of magicka, for example
			{
				[1] = {"trifling", 45855},
				[2] = {"inferior",45856},
				[3] = {"petty",45857},
				[4] = {"slight",45806},
				[5] = {"minor",45807},
				[6] = {"lesser",45808},
				[7] = {"moderate",45809},
				[8] = {"average",45810},
				[9] = {"strong",45811},
				[10]= {"major",45812},
				[11]= {"greater",45813},
				[12]= {"grand",45814},
				[13]= {"splendid",45815},
				[14]= {"monumental",45816},
				[15]= {"truly",{68341,68340,},},
				[16]= {"superb",{64509,64508,},},
				
			},
			["quality"] = 
			{
				{"normal",45850},
				{"fine",45851},
				{"superior",45852},
				{"epic",45853},
				{"legendary",45854},
				{"", 45850} -- default, if nothing is mentioned. Default should be Ta.
			}
		},
	} 

	return craftInfo

end





function WritCreater.langEssenceNames() --exact!

local essenceNames =  
	{
		[1] = "Oko", --health
		[2] = "Deni", --stamina
		[3] = "Makko", --magicka
	}
	return essenceNames
end

function WritCreater.langPotencyNames() --exact!! Also, these are all the positive runestones - no negatives needed.
	local potencyNames = 
	{
		[1] = "Jora", --Lowest potency stone lvl
		[2] = "Porade",
		[3] = "Jera",
		[4] = "Jejora",
		[5] = "Odra",
		[6] = "Pojora",
		[7] = "Edora",
		[8] = "Jaera",
		[9] = "Pora",
		[10]= "Denara",
		[11]= "Rera",
		[12]= "Derado",
		[13]= "Rekura",
		[14]= "Kura",
		[15]= "Rejera",
		[16]= "Repora", --v16 potency stone
		
	}
	return potencyNames
end


local exceptions = 
{
	[1] = 
	{
		["original"] = "rubedo leather",
		["corrected"] = "rubedo",
	},
	[2] = 
	{
		["original"] = "ancestor silk",
		["corrected"] = "ancestor",
	},
	[3] = 
	{
		["original"] = "ebony",
		["corrected"] = "ebon",
	},
	[4] = 
	{
		["original"] = "orichalcum",
		["corrected"] = "orichalc",
	},
	[5] = 
	{
		["original"] = "ruby ash",
		["corrected"] = "ruby",
	},
	[6] = 
	{
		["original"] = "dwarven pauldrons",
		["corrected"] = "dwarven pauldron",
	},
	[7] = 
	{
		["original"] = "epaulets",
		["corrected"] = "epaulet",
	}
}


local bankExceptions = 
{
	["original"] = {
		
	},
	["corrected"] = {
		
	}
}

function WritCreater.bankExceptions(condition)
	if string.find(condition, "deliver") then
		return ""
	end
	condition = string.gsub(condition, ":", " ")
	for i = 1, #bankExceptions["original"] do
		condition = string.gsub(condition,bankExceptions["original"][i],bankExceptions["corrected"][i])
	end
	return condition
end

function WritCreater.exceptions(condition)
	condition = string.gsub(condition, " "," ")
	condition = string.lower(condition)

	for i = 1, #exceptions do

		if string.find(condition, exceptions[i]["original"]) then
			condition = string.gsub(condition, exceptions[i]["original"],exceptions[i]["corrected"])
		end
	end
	return condition
end

function WritCreater.questExceptions(condition)
	condition = string.gsub(condition, " "," ")
	return condition
end

function WritCreater.enchantExceptions(condition)
	condition = string.gsub(condition, " "," ")
	return condition
end


function WritCreater.langTutorial(i) --sentimental
	local t = {
		[5]="There's also a few things you should know.\nFirst, /dailyreset is a slash command that will tell you\nhow long until the next daily server reset.",
		[4]="Finally, you can also choose to deactivate or\nactivate this addon for each profession.\nBy default, all applicable crafts are on.\nIf you wish to turn some off, please check the settings.",
		[3]="Next, you need to choose if you wish to see this\nwindow when using a crafting station.\nThe window will tell you how many mats the writ will require, as well as how many you currently have.",
		[2]="The first setting to choose is if you\nwant to useAutoCraft.\nIf on, when you enter a crafting station, the addon will start crafting.",
		[1]="Welcome to Dolgubon's Lazy Writ Crafter!\nThere are a few settings you should choose first.\n You can change the settings at any\n time in the settings menu.",
	}
	return t[i]
end

function WritCreater.langTutorialButton(i,onOrOff) --sentimental and short pls
	local tOn = 
	{
		[1]="Use Defaults",
		[2]="On",
		[3]="Show",
		[4]="Continue",
		[5]="Finish",
	}
	local tOff=
	{
		[1]="Continue",
		[2]="Off",
		[3]="Do not show",
	}
	if onOrOff then
		return tOn[i]
	else
		return tOff[i]
	end
end



local function dailyResetFunction(till)
	if till["hour"]==0 then
		if till["minute"]==1 then
			d("1 minute until daily server reset!")
		elseif till["minute"]==0 then
			if stamp==1 then
				d("Daily reset in "..stamp.." seconds!")
			else
				d("Seriously... Stop asking. Are you that impatient??? It resets in one more second godammit. Stupid entitled MMO players. *grumble grumble*")
			end
		else
			d(till["minute"].." minutes until daily reset!")
		end
	elseif till["hour"]==1 then
		if till["minute"]==1 then
			d(till["hour"].." hour and "..till["minute"].." minute until daily reset")
		else
			d(till["hour"].." hour and "..till["minute"].." minutes until daily reset")
		end
	else
		if till["minute"]==1 then
			d(till["hour"].." hours and "..till["minute"].." minute until daily reset")
		else
			d(till["hour"].." hours and "..till["minute"].." minutes until daily reset")
		end
	end 
end

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


--Various strings 
WritCreater.strings = 
{
	["runeReq"] 					= function (essence, potency) return "|c2dff00Crafting will require 1 |rTa|c2dff00, 1 |cffcc66"..essence.."|c2dff00 and 1 |c0066ff"..potency.."|r" end,
	["runeMissing"] 				= runeMissingFunction ,
	["notEnoughSkill"]				= "You do not have a high enough crafting skill to make the required equipment",
	["smithingMissing"] 			= "\n|cf60000You do not have enough mats|r",
	["craftAnyway"] 				= "Craft anyway",
	["smithingEnough"] 				= "\n|c2dff00You have enough mats|r",
	["craft"] 						= "|c00ff00Craft|r",
	["crafting"] 					= "|c00ff00Crafting...|r",
	["craftIncomplete"] 			= "|cf60000Crafting could not be completed.\nYou need more mats.|r",
	["moreStyle"] 					= "|cf60000You do not have any usable racial stones.\nCheck your inventory, achievements, and settings|r",
	["dailyreset"] 					= dailyResetFunction,
	["complete"] 					= "|c00FF00Writ complete.|r",
	["craftingstopped"]				= "Crafting stopped. Please check to make sure the addon is crafting the correct item.",
	["smithingReqM"] 				= function (amount, type, more) return zo_strformat( "Crafting will use <<1>> <<2>> (|cf60000You need <<3>>|r)" ,amount, type, more) end,
	["smithingReqM2"] 				= function (amount,type,more)     return zo_strformat( "\nAs well as <<1>> <<2>> (|cf60000You need <<3>>|r)"          ,amount, type, more) end,
	["smithingReq"] 				= function (amount,type, current) return zo_strformat( "Crafting will use <<1>> <<2>> (|c2dff00<<3>> available|r)"  ,amount, type, current) end,
	["smithingReq2"] 				= function (amount,type, current) return zo_strformat( "\nAs well as <<1>> <<2>> (|c2dff00<<3>> available|r)"         ,amount, type, current) end,
	["lootReceived"]				= "<<1>> was received",
}
local function shouldDivinityprotocolbeactivatednowornotitshouldbeallthetimebutwhateveritlljustbeforabit() return GetDate()==20170401 end
if shouldDivinityprotocolbeactivatednowornotitshouldbeallthetimebutwhateveritlljustbeforabit() then
	WritCreater.strings.smithingReqM = function (amount, _,more) return zo_strformat( "Crafting will use <<1>> Jester Hats (|cf60000You need -<<3>>|r)" ,amount, type, more) end
	WritCreater.strings.smithingReqM2 = function (amount, _,more) return zo_strformat( "Crafting will use <<1>> High Elven Heart (|cf60000You need -<<3>>|r)" ,amount, type, more) end
	WritCreater.strings.smithingReq = function (amount, _,more) return zo_strformat( "Crafting will use <<1>> Sock Puppet (|cf60000You need -<<3>>|r)" ,amount, type, more) end
	WritCreater.strings.smithingReq2 = function (amount, _,more) return zo_strformat( "Crafting will use <<1>> Jolly Bean (|cf60000You need -<<3>>|r)" ,amount, type, more) end
end

--Options table Strings
WritCreater.optionStrings = {}
WritCreater.optionStrings["style tooltip"]								= function (styleName, styleStone) return zo_strformat("Allow the <<1>> style, which uses the <<2>> style stone, to be used for crafting",styleName, styleStone) end 
WritCreater.optionStrings["show craft window"]							= "Show Craft Window"
WritCreater.optionStrings["show craft window tooltip"]					= "Shows the crafting window when a crafting station is open"
WritCreater.optionStrings["autocraft"]									= "AutoCraft"
WritCreater.optionStrings["autocraft tooltip"]							= "Selecting this will cause the addon to begin crafting immediately upon entering a crafting station. If the window is not shown, this will be on."
WritCreater.optionStrings["blackmithing"]								= "Blacksmithing"
WritCreater.optionStrings["blacksmithing tooltip"]						= "Turn the addon off for Blacksmithing"
WritCreater.optionStrings["clothing"]									= "Clothing"
WritCreater.optionStrings["clothing tooltip"]							= "Turn the addon off for Clothing"
WritCreater.optionStrings["enchanting"]									= "Enchanting"
WritCreater.optionStrings["enchanting tooltip"]							= "Turn the addon off for Enchanting"
WritCreater.optionStrings["alchemy"]									= "Alchemy"
WritCreater.optionStrings["alchemy tooltip"]							= "Turn the addon off for Alchemy"
WritCreater.optionStrings["provisioning"]								= "Provisioning"
WritCreater.optionStrings["provisioning tooltip"]						= "Turn the addon off for Provisioning"
WritCreater.optionStrings["woodworking"]								= "Woodworking"
WritCreater.optionStrings["woodworking tooltip"]						= "Turn the addon off for Woodworking"
WritCreater.optionStrings["writ grabbing"]								= "Grab writ items"
WritCreater.optionStrings["writ grabbing tooltip"]						= "Grab items required for writs (e.g. nirnroot, Ta, etc.) from the bank"
WritCreater.optionStrings["delay"]										= "Item Grab Delay"
WritCreater.optionStrings["delay tooltip"]								= "How long to wait before grabbing items from the bank (milliseconds)"
WritCreater.optionStrings["ignore autoloot"]							= "Ignore AutoLoot Setting"
WritCreater.optionStrings["ignore autoloot tooltip"]					= "Ignore the Autoloot setting found in the gameplay menu, and use the custom setting below for writ containers"
WritCreater.optionStrings["autoloot containters"]						= "Autoloot Writ Containers"
WritCreater.optionStrings["autoLoot containters tooltip"]				= "Loot writ containers when they are opened"
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
WritCreater.optionStrings["autoloot behaviour"]							= "Autoloot Behaviour"
WritCreater.optionStrings["autoloot behaviour tooltip"]					= "Choose when the addon will autoloot writ reward containers"
WritCreater.optionStrings["autoloot behaviour choices"]					= {"Copy the setting under the Gameplay settings", "Autoloot", "Never Autoloot"}

function WritCreater.langWritRewardBoxes () return {
	[CRAFTING_TYPE_ALCHEMY] = "Alchemist's Vessel",
	[CRAFTING_TYPE_ENCHANTING] = "Enchanter's Coffer",
	[CRAFTING_TYPE_PROVISIONING] = "Provisioner's Pack",
	[CRAFTING_TYPE_BLACKSMITHING] = "Blacksmith's Crate",
	[CRAFTING_TYPE_CLOTHIER] = "Clothier's Satchel",
	[CRAFTING_TYPE_WOODWORKING] = "Woodworker's Case",
	[7] = "Shipment",
}
end

--dual, lush, rich

function WritCreater.getTaString()
	return "ta"
end

WritCreater.lang = "en"


--[[
SLASH_COMMANDS['/opencontainers'] = function()local a=WritCreater.langWritRewardBoxes() for i=1,200 do for j=1,6 do if a[j]==GetItemName(1,i) then if IsProtectedFunction("endUseItem") then
	CallSecureProtected("endUseItem",1,i)
else
	UseItem(1,i)
end end end end end]]
