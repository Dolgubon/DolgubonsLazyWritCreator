-----------------------------------------------------------------------------------
-- Addon Name: Dolgubon's Lazy Writ Crafter
-- Creator: Dolgubon (Joseph Heinzle)
-- Addon Ideal: Simplifies Crafting Writs as much as possible
-- Addon Creation Date: March 14, 2016
--
-- File Name: Languages/en.lua
-- File Description: English Localization
-- Load Order Requirements: None
-- 
-----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------
--
-- TRANSLATION NOTES - PLEASE READ
--
-- If you are not looking to translate the addon you can ignore this. :D
--
-- If you ARE looking to translate this to something else then anything with a comment of Vital beside it is 
-- REQUIRED for a main feature to work properly. These strings should be TRANSLATED EXACTLY!
-- If only going for functionality, ctrl+f for Vital. Otherwise, you can just translate everything.
-- If you are going for a full translation, you must also translate defualt.lua and paste it into your localization file.
-- Some functions are marked as only required for master writs.
-- Master writs are not really supported anymore and are only kept to not remove a feature. It is highly recommended to not translate those functions, 
-- and instead point users torwards writ worthy.
--
-- For languages that do not use the Latin Alphabet, there is also an optional langParser() function. IF the language you are translating
-- requires some changes to the WritCreater.parser() function then write the optional langParser() function here, and the addon
-- will use that instead. Just below is a commented out langParser for English. Be sure to remove the surrounding comment if rewriting it. [[  ]]
--
-- If you run into problems, please feel free to contact me on ESOUI.
--
-----------------------------------------------------------------------------------
--

WritCreater = WritCreater or {}

local function proper(str)
	if type(str)== "string" then
		return zo_strformat("<<C:1>>",str)
	else
		return str
	end
end

function WritCreater.langWritNames() -- Not vital, but auto quest dialog probably won't work without it
	-- Exact!!!  For example, for german alchemy writ is Alchemistenschrieb - so ["G"] = schrieb, and ["A"]=Alchemisten
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

function WritCreater.langCraftKernels()
	return 
	{
		[CRAFTING_TYPE_ENCHANTING] = "Enchant",
		[CRAFTING_TYPE_BLACKSMITHING] = "Blacksmith",
		[CRAFTING_TYPE_CLOTHIER] = "Clothier",
		[CRAFTING_TYPE_PROVISIONING] = "Provision",
		[CRAFTING_TYPE_WOODWORKING] = "Woodwork",
		[CRAFTING_TYPE_ALCHEMY] = "Alchem",
		[CRAFTING_TYPE_JEWELRYCRAFTING] = "Jewelry",
	}
end

function WritCreater.writCompleteStrings() -- Vital for translation
	local strings = {
	["place"] = "Place the goods",
	["sign"] = "Sign the Manifest",
	["masterPlace"] = "I've finished the ",
	["masterSign"] = "<Finish the job.>",
	["masterStart"] = "<Accept the contract.>",
	["Rolis Hlaalu"] = "Rolis Hlaalu", -- This is the same in most languages but ofc chinese and japanese are different
	["Deliver"] = "Deliver",
	["Acquire"] = "acquire",
	}
	return strings
end

function WritCreater.questExceptions(condition)
	condition = string.gsub(condition, " "," ")
	return condition
end

function WritCreater.langStationNames()
	return
	{["Blacksmithing Station"] = 1, ["Clothing Station"] = 2, 
	 ["Enchanting Table"] = 3,["Alchemy Station"] = 4, ["Cooking Fire"] = 5, ["Woodworking Station"] = 6, ["Jewelry Crafting Station"] = 7, }
end


--------------------------------------------------------------------------------------------------------------------
-- Translators can skip these, if you want.
-- These are April 1 strings, so don't need to be translated, unless you really want to.


-- What is this??! This is just a fun 'easter egg' that is never activated on easter.
-- Replaces mat names with a random DivineMats on Halloween, New Year's, and April Fools day. You don't need this many! Just one is enough :D
-- Translate it or don't, completely up to you. If you don't translate it, just remove it
local DivineMats =
{
	{"Rusted Nails", "Ghost Robes", "","","", "Rotten Logs","Cursed Gold", "Chopped Liver", "Crumbled Gravestones", "Toad Eyes", "Werewolf Claws", "Zombie Guts", "Lizard Brains"},
	{"Buzzers","Sock Puppets", "Jester Hats","Otter Noses", "Red Herrings", "Wooden Snakes", "Gold Teeth", "Mudpies"},
	{"Coal", "Stockings", "","","","Evergreen Branches", "Golden Rings", "Bottled Time", "Reindeer Bells", "Elven Hats", "Pine Needles", "Cups of Snow"},
}

-- confetti?
-- random sounds?
-- 

local function shouldDivinityprotocolbeactivatednowornotitshouldbeallthetimebutwhateveritlljustbeforabit()
	if not DivineMats then
		return false
	end
	if GetDate()%10000 == 1031 then return 1 end
	if GetDate()%10000 == 401 then return 2 end
	if GetDate()%10000 == 1231 then return 3 end
	if GetDisplayName() == "@Dolgubon" or GetDisplayName() == "@Gitaelia" or GetDisplayName() == "@mithra62" or GetDisplayName() == "@PacoHasPants" then
		return 2
	end
	return false
end
WritCreater.shouldDivinityprotocolbeactivatednowornotitshouldbeallthetimebutwhateveritlljustbeforabit = shouldDivinityprotocolbeactivatednowornotitshouldbeallthetimebutwhateveritlljustbeforabit


local function wellWeShouldUseADivineMatButWeHaveNoClueWhichOneItIsSoWeNeedToAskTheGodsWhichDivineMatShouldBeUsed() local a= math.random(1, #DivineMats ) return DivineMats[a] end
local l = shouldDivinityprotocolbeactivatednowornotitshouldbeallthetimebutwhateveritlljustbeforabit()

if l then
	DivineMats = DivineMats[l]
	local DivineMat = wellWeShouldUseADivineMatButWeHaveNoClueWhichOneItIsSoWeNeedToAskTheGodsWhichDivineMatShouldBeUsed()
	
	WritCreater.strings.smithingReqM = function (amount, _,more)
		local craft = GetCraftingInteractionType()
		DivineMat = DivineMats[craft]
		return zo_strformat( "Crafting will use <<1>> <<4>> (|cf60000You need <<3>>|r)" ,amount, type, more, DivineMat) end
	WritCreater.strings.smithingReqM2 = function (amount, _,more)
		local craft = GetCraftingInteractionType()
		DivineMat = DivineMats[craft]
		return zo_strformat( "As well as <<1>> <<4>> (|cf60000You need <<3>>|r)" ,amount, type, more, DivineMat) end
	WritCreater.strings.smithingReq = function (amount, _,more) 
		local craft = GetCraftingInteractionType()
		DivineMat = DivineMats[craft]
		return zo_strformat( "Crafting will use <<1>> <<4>> (|c2dff00<<3>> available|r)" ,amount, type, more, DivineMat) end
	WritCreater.strings.smithingReq2 = function (amount, _,more) 
		local craft = GetCraftingInteractionType()
		DivineMat = DivineMats[craft]
		return zo_strformat( "As well as <<1>> <<4>> (|c2dff00<<3>> available|r)" ,amount, type, more, DivineMat) end
end


-- [[ /script local writcreater = {} local c = {a = 1} local g = {__index = c} setmetatable(writ, g) d(a.a) local e = {__index = {Z = 2}} setmetatable(c, e) d(a.Z)


-----------------------------------------------
-- Translators should skip all of the following. Will probably not be used again
local h = {__index = {}}
local t = {}
local g = {["__index"] = t}
setmetatable(t, h)
setmetatable(WritCreater, g) --]]

local function enableAlternateUniverse(override)

	if shouldDivinityprotocolbeactivatednowornotitshouldbeallthetimebutwhateveritlljustbeforabit() == 2 or override then
	--if true then
		local stations = 
			{"Blacksmithing Station", "Clothing Station", "Enchanting Table",
			"Alchemy Station",  "Cooking Fire", "Woodworking Station","Jewelry Crafting Station",  "Outfit Station", "Transmute Station", "Wayshrine"}
			local stationNames =  -- in the comments are other names that were also considered, though not all were considered seriously
			{"Wightsmithing Station", -- Popcorn Machine , Skyforge, Heavy Metal Station, Metal Clockwork Solid, Wightsmithing Station., Coyote Stopper
			 "Sock Puppet Theatre", -- Sock Distribution Center, Soul-Shriven Sock Station, Grandma's Sock Knitting Station, Knits and Pieces, Sock Knitting Station
			"Top Hats Inc.", -- Mahjong Station, Magic Store, Card Finder, Five Aces, Top Hat Store
			"Seedy Skooma Bar", -- Chemical Laboratory , Drugstore, White's Garage, Cocktail Bar, Med-Tek Pharmaceutical Company, Med-Tek Laboratories, Skooma Central, Skooma Backdoor Dealers, Sheogorath's Pharmacy
			 "McDaedra Order Kiosk",--"Khajit Fried Chicken", -- Khajit Fried Chicken, soup Kitchen, Some kind of bar, misspelling?, Roast Bosmer
			 "IKEA Assembly Station", -- Chainsaw Massace, Saw Station, Shield Corp, IKEA Assembly Station, Wood Splinter Removal Station
			 "April Fool's Gold",--"Diamond Scam Store", -- Lucy in the Sky, Wedding Planning Hub, Shiny Maker, Oooh Shiny, Shiny Bling Maker, Cubit Zirconia, Rhinestone Palace
			 -- April Fool's Gold
			 "Khajit Fur Trade Outpost", -- Jester Dressing Room Loincloth Shop, Khajit Walk, Khajit Fashion Show, Mummy Maker, Thalmor Spy Agency, Tamriel Catwalk, 
			 --	Tamriel Khajitwalk, second hand warehouse,. Dye for Me, Catfur Jackets, Outfit station "Khajiit Furriers", Khajit Fur Trading Outpost
			 "Sacrificial Goat Altar",-- Heisenberg's Station Correction Facility, Time Machine, Probability Redistributor, Slot Machine Rigger, RNG Countermeasure, Lootcifer Shrine, Whack-a-mole
			 -- Anti Salt Machine, Department of Corrections, Quantum State Rigger , Unnerf Station
			 "TARDIS" } -- Transporter, Molecular Discombobulator, Beamer, Warp Tunnel, Portal, Stargate, Cannon!, Warp Gate
			
			local crafts = {"Blacksmithing", "Clothing", "Enchanting","Alchemy","Provisioning","Woodworking","Jewelry Crafting" }
			local craftNames = {
				"Wightsmithing",
				"Sock Knitting",
				"Top Hat Tricks",
				"Skooma Brewing",
				"McDaedra",--"Chicken Frying",
				"IKEA Assembly",
				"Fool's Gold Creation",
			}
			local quest = {"Blacksmith", "Clothier", "Enchanter" ,"Alchemist", "Provisioner", "Woodworker", "Jewelry Crafting","Provisioner Writ"}
			local questNames = 	
			{
				"Wightsmith",
				"Sock Knitter",
				"Top Hat Trickster",
				"Skooma Brewer",
				"McDaedra",--"Chicken Fryer",
				"IKEA Assembly",
				"Fool's Gold",
				"McDaedra Delivery",
			}
			local items = {"Blacksmith", "Clothier", "Enchanter", "alchemical", "food and drink",  "Woodworker", "Jewelry"}
			local itemNames = {
				"Wight",
				"Sock Puppet",
				"Top Hat",
				"Skooma",
				"McDaedra Nuggets",--"Fried Chicken",
				"IKEA",
				"Fool's Gold",
			}
			local coffers = {"Blacksmith", "Clothier", "Enchanter" ,"Alchemist", "Provisioner's Pack", "Woodworker", "Jewelry Crafter's",}
			local cofferNames = {
				"Wightsmith",
				"Sock Knitter",
				"Top Hat Trickster",
				"Skooma Brewer",
				"McDaedra Takeout",--"Chicken Fryer",
				"IKEA Assembly",
				"Fool's Gold",
			}
			local ones = {"Jewelry Crafter"}
			local oneNames = {"Fool's Gold"}
		

		local t = {["__index"] = {}}
		function h.__index.alternateUniverse()
			return stations, stationNames
		end
		function h.__index.alternateUniverseCrafts()
			return crafts, craftNames
		end
		function h.__index.alternateUniverseQuests()
			return quest, questNames
		end
		function h.__index.alternateUniverseItems()
			return items, itemNames
		end
		function h.__index.alternateUniverseCoffers()
			return coffers, cofferNames
		end
		function h.__index.alternateUniverseOnes()
			return ones, oneNames
		end
		

		h.__metatable = "No looky!"
		local a = WritCreater.langStationNames()
		a[1] = 1
		for i = 1, 7 do
			a[stationNames[i]] = i
		end
		WritCreater.langStationNames = function() 
			return a
		end
		local b =WritCreater.langWritNames()
		for i = 1, 7 do
			b[i] = questNames[i]
		end
		-- WritCreater.langWritNames = function() return b end

	end
end

-- For Transmutation: "Well Fitted Forever"
-- So far, I like blacksmithing, clothing, woodworking, and wayshrine, enchanting
-- that leaves , alchemy, cooking, jewelry, outfits, and transmutation

local lastYearStations = 
{"Blacksmithing Station", "Clothing Station", "Woodworking Station", "Cooking Fire", 
"Enchanting Table", "Alchemy Station", "Outfit Station", "Transmute Station", "Wayshrine"}
local stationNames =  -- in the comments are other names that were also considered, though not all were considered seriously
{"Heavy Metal 112.3 FM", -- Popcorn Machine , Skyforge, Heavy Metal Station
 "Sock Knitting Station", -- Sock Distribution Center, Soul-Shriven Sock Station, Grandma's Sock Knitting Station, Knits and Pieces
 "Splinter Removal Station", -- Chainsaw Massace, Saw Station, Shield Corp, IKEA Assembly Station, Wood Splinter Removal Station
 "McSheo's Food Co.", 
 "Tetris Station", -- Mahjong Station
 "Poison Control Centre", -- Chemical Laboratory , Drugstore, White's Garage, Cocktail Bar, Med-Tek Pharmaceutical Company, Med-Tek Laboratories
 "Thalmor Spy Agency", -- Jester Dressing Room Loincloth Shop, Khajit Walk, Khajit Fashion Show, Mummy Maker, Thalmor Spy Agency, Morag Tong Information Hub, Tamriel Spy HQ, 
 "Department of Corrections",-- Heisenberg's Station Correction Facility, Time Machine, Probability Redistributor, Slot Machine Rigger, RNG Countermeasure, Lootcifer Shrine, Whack-a-mole
 -- Anti Salt Machine, Department of Corrections
 "Warp Gate" } -- Transporter, Molecular Discombobulator, Beamer, Warp Tunnel, Portal, Stargate, Cannon!, Warp Gate

-- enableAlternateUniverse(GetDisplayName()=="@Dolgubon")
enableAlternateUniverse()

local function alternateListener(eventCode,  channelType, fromName, text, isCustomerService, fromDisplayName)
	if not WritCreater.alternateUniverse and fromDisplayName == "@Dolgubon"and (text == "Let the Isles bleed into Nirn!" ) then	
		enableAlternateUniverse(true)
		WritCreater.WipeThatFrownOffYourFace(true)	
	end	
	-- if GetDisplayName() == "@Dolgubon" then
	-- 	enableAlternateUniverse(true)	
	-- 	WritCreater.WipeThatFrownOffYourFace(true)	
	-- end
end	
-- 20764
-- 21465

EVENT_MANAGER:RegisterForEvent(WritCreater.name,EVENT_CHAT_MESSAGE_CHANNEL, alternateListener)

--Hide craft window when done
--"Verstecke Fenster anschließend",
-- [tooltip ] = "Verstecke das Writ Crafter Fenster an der Handwerksstation automatisch, nachdem die Gegenstände hergestellt wurden"

WritCreater.optionStrings["alternate universe"] = "Turn off April"
WritCreater.optionStrings["alternate universe tooltip"] = "Turn off the renaming of crafts, crafting stations, and other interactables"

WritCreater.lang = "en"
WritCreater.langIsMasterWritSupported = true

WritCreater.cheeseyLocalizations["alreadyUnlocked"] = "Writ Crafter Skin unlocked"
WritCreater.cheeseyLocalizations["alreadyUnlockedTooltip"] = "You already unlocked the skin on April 1, 2023. Doing it again is just for fun!"
WritCreater.cheeseyLocalizations["settingsChooseSkin"] = "You can change the skin in the settings menu"


