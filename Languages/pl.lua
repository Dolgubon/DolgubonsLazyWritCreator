-----------------------------------------------------------------------------------
-- Addon Name: Dolgubon's Lazy Writ Crafter
-- Creator: Dolgubon (Joseph Heinzle)
-- Addon Ideal: Simplifies Crafting Writs as much as possible
-- Addon Creation Date: March 14, 2016
--
-- File Name: Languages/pl.lua
-- File Description: Polish Localization (Skrybowie Tamriel EsoPL)
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
-- required for a feature to work properly. But these features are mostly minor.
-- If only going for functionality, ctrl+f for Vital. Otherwise, you can just translate everything.
-- If you are going for a full translation, you should also translate defualt.lua and paste it into your localization file. (Espcially lines starting with WritCreater.strings or WritCreater.optionStrings)
--
-- If you run into problems, please feel free to contact me on ESOUI.
--
-----------------------------------------------------------------------------------

WritCreater = WritCreater or {}
-- Sprawdzić czy potrzebne
local function proper(str)
	if type(str)== "string" then
		return zo_strformat("<<C:1>>",str)
	else
		return str
	end
end

WritCreater.hirelingMailSubjects = 
{
    ["Surowce kowalskie"] = true,
    ["Surowce krawieckie"] = true,
    ["Surowce stolarskie"] = true,
    ["Surowce do zaklinania"] = true,
    ["Surowce aprowizacyjne"] = true,
}

function WritCreater.langWritNames() -- Not vital, but auto quest dialog probably won't work without it
	-- Exact!!!  For example, for german alchemy writ is Alchemistenschrieb - so ["G"] = schrieb, and ["A"]=Alchemisten
	local names = {
	["G"] = "zlecenia",
    	[CRAFTING_TYPE_ENCHANTING] = "Zaklinacza", -- 249936564-0-6495 <Examine the Enchanter Writs.> - <Sprawdź zlecenia dla zaklinacza.>
	[CRAFTING_TYPE_BLACKSMITHING] = "Kowala",
	[CRAFTING_TYPE_CLOTHIER] = "Krawca",
	[CRAFTING_TYPE_PROVISIONING] = "Aprowizatora",
	[CRAFTING_TYPE_WOODWORKING] = "Stolarza",
	[CRAFTING_TYPE_ALCHEMY] = "Alchemika",
	[CRAFTING_TYPE_JEWELRYCRAFTING] = "Jubilera",
	}
	return names
end

function WritCreater.writCompleteStrings() -- Vital for translation
	local strings = {
	["place"] = "Umieść towary w skrzyni",
	["sign"] = "Podpisz potwierdzenie",
	["masterPlace"] = "Skończył",
	["masterSign"] = "<Ukończ zlecenie.>", -- 232026500-0-12524
	["masterStart"] = "<Zaakceptuj umowę.>",
	["Rolis Hlaalu"] = "Rolis Hlaalu", -- This is the same in most languages but ofc chinese and japanese
	["Deliver"] = "Dostarcz", -- 121487972-0-12653
	["Acquire"] = "acquire",
	}
	return strings
end

function WritCreater.langStationNames() -- Vital for reticle changes
	return
	{["Kuźnia"] = 1, ["Stanowisko krawieckie"] = 2, 
	 ["Stół do zaklinania"] = 3,["Stanowisko alchemiczne"] = 4, ["Palenisko do gotowania"] = 5, ["Stanowisko stolarskie"] = 6, ["Stanowisko jubilerskie"] = 7, }
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

WritCreater.lang = "pl"
WritCreater.langIsMasterWritSupported = true

WritCreater.cheeseyLocalizations["alreadyUnlocked"] = "Writ Crafter Skin unlocked"
WritCreater.cheeseyLocalizations["alreadyUnlockedTooltip"] = "You already unlocked the skin on April 1, 2023. Doing it again is just for fun!"
WritCreater.cheeseyLocalizations["settingsChooseSkin"] = "You can change the skin in the settings menu"


WritCreater.strings = WritCreater.strings or {}

WritCreater.strings["runeReq"] 						= function (essence, potency,taStack,essenceStack,potencyStack) 
	return zo_strformat("|c2dff00Wytworzenie wymaga 1/<<3>> |rTa|c2dff00, 1/<<4>> |cffcc66<<1>>|c2dff00 i 1/<<5>> |c0066ff<<2>>|r", 
		essence, potency, taStack, essenceStack, potencyStack) 
end
WritCreater.strings["runeMissing"] 					= runeMissingFunction 
WritCreater.strings["notEnoughSkill"]				= "Nie posiadasz wystarczająco wysokich umiejętności rzemiosła, aby wykonać wymagane wyposażenie"
WritCreater.strings["smithingMissing"] 				= "\n|cf60000Nie masz wystarczającej liczby materiałów|r"
WritCreater.strings["craftAnyway"] 					= "Wytwórz mimo to"
WritCreater.strings["smithingEnough"] 				= "\n|c2dff00Masz wystarczająco dużo materiałów|r"
WritCreater.strings["craft"] 						= "|c00ff00Wytwórz|r"
WritCreater.strings["crafting"] 					= "|c00ff00Wytwarzanie...|r"
WritCreater.strings["craftIncomplete"] 				= "|cf60000Wytwarzanie nie zostało ukończone.\nPotrzebujesz więcej materiałów.|r"
WritCreater.strings["moreStyle"] 					= "|cf60000Nie masz żadnych użytecznych kamieni stylu.\nSprawdź swój ekwipunek, osiągnięcia i ustawienia|r"
WritCreater.strings["moreStyleSettings"]			= "|cf60000Nie masz żadnych użytecznych kamieni stylu.\nPrawdopodobnie musisz zezwolić na więcej w menu Ustawienia|r"
WritCreater.strings["moreStyleKnowledge"]			= "|cf60000Nie masz żadnych użytecznych kamieni stylu.\nByć może będziesz musiał nauczyć się wytwarzać więcej stylów|r"
WritCreater.strings["dailyreset"] 					= dailyResetFunction
WritCreater.strings["complete"] 					= "|c00FF00Zlecenie ukończone.|r"
WritCreater.strings["craftingstopped"]				= "Wytwarzanie zostało zatrzymane. Sprawdź, czy dodatek wytwarza prawidłowy przedmiot."
WritCreater.strings["smithingReqM"] 				= function (amount, type, more) return zo_strformat( "Wytworzenie zużyje <<1>> <<2>> (|cf60000Potrzebujesz <<3>>|r)" ,amount, type, more) end
WritCreater.strings["smithingReq"] 					= function (amount,type, current) return zo_strformat( "Wytworzenie zużyje <<1>> <<2>> (|c2dff00<<3>> dostępne|r)"  ,amount, type, current) end
WritCreater.strings["smithingReqM2"] 				= function (amount,type,more) return zo_strformat( "\nOraz <<1>> <<2>> (|cf60000Potrzebujesz <<3>>|r)" ,amount, type, more) end
WritCreater.strings["smithingReq2"] 				= function (amount,type, current) return zo_strformat( "\nOraz <<1>> <<2>> (|c2dff00<<3>> dostępne|r)"  ,amount, type, current) end

WritCreater.strings["lootReceived"]					= "<<3>> <<1>> został odebrany (masz <<2>>)"
WritCreater.strings["lootReceivedM"]				= "Odebrano <<1>> "
WritCreater.strings["countSurveys"]					= "Ilość posiadanych raportów z badań: <<1>>"
WritCreater.strings["countVouchers"]				= "Niezarobione talony za zlecenia: <<1>>"
WritCreater.strings["includesStorage"]				= function(type) local a= {"Raportów", "Mistrzowskich Zleceń"} a = a[type] return zo_strformat("Liczba obejmuje <<1>> w magazynie domowym", a) end
WritCreater.strings["surveys"]						= "Raporty z badań"
WritCreater.strings["sealedWrits"]					= "Zapieczętowane zlecenia"
WritCreater.strings["masterWritSmithToCraft"]		= function(lvl, type, quality, writCraft, writName, generalName) 
	return zo_strformat("<<t:4>> <<t:5>> <<t:6>>: Wytwarzanie <<t:1>> Glifu <<t:2>> o jakości <<t:3>>", lvl, type, quality, writCraft, writName, generalName) 
end
WritCreater.strings["masterWritEnchantToCraft"]		= WritCreater.strings["masterWritSmithToCraft"]
WritCreater.strings["newMasterWritSmithToCraft"]	= function(link, trait, style, quality, writName)
	return zo_strformat("<<t:5>>: Wytwarzanie CP150 <<t:1>> z cechą <<t:2>> i stylem <<t:3>> o jakości <<t:4>>", link, trait, style, quality, writName)
end
WritCreater.strings["withdrawItem"]					= function(amount, link, remaining) return "Dolgubon's Lazy Writ Crafter pobrał "..amount.." "..link..". (W banku: "..remaining..")" end
WritCreater.strings['fullBag']						= "Nie masz wolnych miejsc w plecaku. Opróżnij swój plecak."
WritCreater.strings['masterWritSave']				= "Dolgubon's Lazy Writ Crafter uchronił cię przed przypadkowym zaakceptowaniem Mistrzowskiego zlecenia! Przejdź do menu ustawień, aby wyłączyć tę opcję."
WritCreater.strings['missingLibraries']				= "Dolgubon's Lazy Writ Crafter wymaga następujących samodzielnych bibliotek. Prosimy o pobranie, zainstalowanie lub włączenie tych bibliotek: "
WritCreater.strings['resetWarningMessageText']		= "Codzienne resetowanie zleceń nastąpi za <<1>> godz. i <<2>> min.\nMożesz dostosować lub wyłączyć to ostrzeżenie w ustawieniach"
WritCreater.strings['resetWarningExampleText']		= "Ostrzeżenie będzie wyglądać następująco"
WritCreater.strings['lowInventory']					= "\nIlość wolnego miejsca wynosi: <<1>>, może nie starczyć ci miejsca w plecaku"
WritCreater.strings['masterWritQueueCleared']		= "Kolejka wytwarzania Mistrzowskich Zleceń wyczyszczona"
WritCreater.strings['multiplierCraftPrediction']	= "Wytwarzanie <<2>> przedmiotów dla <<1[niczego/$d cyklu/$d cykli]>> zleceń"

WritCreater.strings['alchemyNoCombo']				= "Nie znaleziono wystarczająco taniej kombinacji składników. Spróbuj zdobyć inne rodzaje składników alchemicznych"
WritCreater.strings['alchemyMissing']				= function(missing)
	local missingOut = "Brakuje Ci "
	for missingItemId, v in pairs(missing) do
		missingOut = missingOut..getItemLinkFromItemId(missingItemId).." "
	end
	missingOut = missingOut.." aby wytworzyć najtańszą kombinację"
	return missingOut
end
WritCreater.strings['alchemyLowPassive']			= "Wybrałeś wytworzenie pełnego stosu, ale nie masz aktywnych pasywnych umiejętności mnożących wytwarzanie"
WritCreater.strings['alchemyCraftReqs']				= "Wytworzenie zużyje <<t:4>> <<t:1>>, <<t:4>> <<t:2>> i <<t:4>> <<t:3>>"
WritCreater.strings['alchemyMasterReqs']			= "<<t:1>>: Wytwarzanie <<t:2>> używając <<t:3>>, <<t:4>> i <<t:5>>"
WritCreater.strings['depositGold']					= "Writ Crafter: Deponowanie <<1>> złota"
WritCreater.strings['depositItemMissing']			= "Writ Crafter: Nie można znaleźć <<t:1>> do zdeponowania. Przedmiot mógł zostać zniszczony lub przeniesiony"
WritCreater.strings['depositItem']					= "Writ Crafter: Deponowanie <<t:1>>"
WritCreater.strings['welcomeMessage']				= "Dziękujemy za zainstalowanie Dolgubon's Lazy Writ Crafter! Sprawdź ustawienia, aby dostosować zachowanie dodatku"
WritCreater.strings['keybindStripBlurb']			= "Wytwórz przedmioty zlecenia"
WritCreater.strings['pressToCraft']					= "\nNaciśnij |t32:32:<<1>>|t aby wytworzyć"
WritCreater.strings['goldenPursuitCraft']			= "Wytworzyć przedmioty zestawu dla nieukończonych złotych dążeń?\n(Może nie być w stanie wytworzyć wszystkiego. Tylko Topór/Łuk/Pierścień/Szata, używa żelaza)"
WritCreater.strings['fullInventory']				= "Twój ekwipunek jest pełny"
WritCreater.strings['provisioningUnknownRecipe']	= "Nie znasz przepisu na <<1>>"
WritCreater.strings['provisioningCraft']			= "Writ Crafter wytworzy <<1>>"
WritCreater.strings['transmuteLooted']				= "Otrzymano <<1>> Kryształów Transmutacji (Masz <<2>>)"
WritCreater.strings['transmuteLimitApproach']		= "Zbliżasz się do limitu kryształów transmutacji. Jeśli skrzynia spowoduje przekroczenie limitu, Writ Crafter nie podniesie kamieni."
WritCreater.strings['transmuteLimitHit']			= "Podniesienie tych kryształów transmutacji spowodowałoby przekroczenie maksimum, więc <<1>> kryształów nie zostało podniesionych"
WritCreater.strings['lootingMarkJunk']				= "Writ Crafter: Oznaczono <<1>> jako śmieć"
WritCreater.strings['lootingDestroyItem']			= "Writ Crafter: Zniszczono <<1>> zgodnie z ustawieniami"
WritCreater.strings['lootingDeconItem']				= "Writ Crafter: Dodano <<1>> do kolejki dekonstrukcji"
WritCreater.strings['lootingDeposit']				= "Writ Crafter: <<1>> przedmiotów w kolejce do depozytu bankowego"
WritCreater.strings['mailComplete']					= "Writ Crafter: Zakończono przeszukiwanie poczty"
WritCreater.strings['mailNumLoot']					= "Writ Crafter: Znaleziono <<1>> wiadomości od dostawców"
WritCreater.strings['masterRecipeUnknown']			= "<<t:1>>: Nie można dodać do kolejki, ponieważ nie znasz przepisu na <<t:2>>"
WritCreater.strings['masterEnchantCraft']			= "<<t:1>>: Wytwarzanie <<t:2>>"
WritCreater.strings['masterRecipeCraft']			= "<<t:1>>: Wytwarzanie <<t:3>>x<<t:2>>"
WritCreater.strings['masterRecipeError']			= "<<1>>: Nie można dodać do kolejki. Możesz nie znać wymaganego przepisu"
WritCreater.strings['masterQueueNotFound']			= "Nie można ustalić, ile przedmiotów wytworzyć. Spróbuj zaakceptować zlecenie."
WritCreater.strings['masterQueueBlurb']				= "Wytwórz Zlecenie"
WritCreater.strings['masterQueueSummary']			= "Writ Crafter dodał do kolejki <<1>> zapieczętowanych zleceń"
WritCreater.strings['abandonQuestBanItem']			= "Writ Crafter porzucił <<1>>, ponieważ wymaga <<2>>, co zostało zablokowane w ustawieniach"
WritCreater.strings['writBufferNotification']		= "Bufor zadań Lazy Writ Crafter™ uniemożliwia przyjęcie tego zlecenia"
WritCreater.strings['masterStopAcceptNoCraftSkill'] = "Lazy Writ Crafter™ zapobiegł przyjęciu tego zlecenia, ponieważ nie możesz go wytworzyć"
WritCreater.strings['stealingProtection'] 			= "Lazy Writ Crafter™ uchronił cię przed kradzieżą podczas wykonywania zleceń!"
WritCreater.strings['statsWitsDone']				= "Wykonane zlecenia: <<1>> w ciągu ostatnich <<2>> dni"
WritCreater.strings['deconstructSuccess']			= "Writ Crafter: Zdekonstruowano <<1>>"
WritCreater.strings['potion']						= "mikstura"
WritCreater.strings['poison']						= "trucizna"




WritCreater.optionStrings = {}
-- Ustawienie metatabeli, aby obsługiwać brakujące tłumaczenia, jeśli zajdzie taka potrzeba
local stringIndexTable = {}
local findMissingTranslationsMetatable = 
{
	["__newindex"] = function(t,k,v) if not stringIndexTable[tostring(t)] then stringIndexTable[tostring(t)] = {} end stringIndexTable[tostring(t)][k] = v end,
	["__index"] = function(t, k) return stringIndexTable[tostring(t)][k] end,
}
setmetatable(WritCreater.optionStrings, findMissingTranslationsMetatable)

WritCreater.optionStrings.nowEditing                   = "Zmieniasz ustawienia dla: %s"
WritCreater.optionStrings.accountWide                  = "Całego konta"
WritCreater.optionStrings.characterSpecific            = "Obecnej postaci"
WritCreater.optionStrings.useCharacterSettings         = "Użyj ustawień specyficznych dla postaci"
WritCreater.optionStrings.useCharacterSettingsTooltip  = "Używaj ustawień specyficznych tylko dla tej postaci"
WritCreater.optionStrings["style tooltip"]             = function (styleName, styleStone) return zo_strformat("Pozwól na użycie stylu <<1>>, który wykorzystuje kamień stylu <<2>>, do wytwarzania", styleName, styleStone) end 
WritCreater.optionStrings["show craft window"]         = "Pokaż okno wytwarzania"
WritCreater.optionStrings["show craft window tooltip"] = "Pokazuje okno wytwarzania, gdy stacja rzemieślnicza jest otwarta"
WritCreater.optionStrings["autocraft"]                 = "Automatyczne wytwarzanie"
WritCreater.optionStrings["autocraft tooltip"]         = "Wybranie tej opcji spowoduje, że dodatek rozpocznie wytwarzanie natychmiast po przejściu do stanowiska rzemieślniczego. Jeśli okno nie jest wyświetlane, opcja jest włączona."
WritCreater.optionStrings["blackmithing"]              = "Kowalstwo"
WritCreater.optionStrings["blacksmithing tooltip"]     = "Włącz dodatek dla Kowalstwa"
WritCreater.optionStrings["clothing"]                  = "Krawiectwo"
WritCreater.optionStrings["clothing tooltip"]          = "Włącz dodatek dla Krawiectwa"
WritCreater.optionStrings["enchanting"]                = "Zaklinanie"
WritCreater.optionStrings["enchanting tooltip"]        = "Włącz dodatek dla Zaklinania"
WritCreater.optionStrings["alchemy"]                   = "Alchemia"
WritCreater.optionStrings["alchemy tooltip"]           = "Włącz dodatek dla Alchemii (Tylko pobieranie z banku)"
WritCreater.optionStrings["provisioning"]              = "Aprowizacja"
WritCreater.optionStrings["provisioning tooltip"]      = "Włącz dodatek dla Aprowizacji (Tylko pobieranie z banku)"
WritCreater.optionStrings["woodworking"]               = "Stolarstwo"
WritCreater.optionStrings["woodworking tooltip"]       = "Włącz dodatek dla Stolarstwa"
WritCreater.optionStrings["jewelry crafting"]          = "Jubilerstwo"
WritCreater.optionStrings["jewelry crafting tooltip"]  = "Włącz dodatek dla Jubilerstwa"
WritCreater.optionStrings["writ grabbing"]             = "Wyjmowanie przedmiotów do zleceń"
WritCreater.optionStrings["writ grabbing tooltip"]     = "Pobieranie z banku przedmiotów wymaganych do zleceń (np. Korzeń nirnu, Ta itp.)."
WritCreater.optionStrings["style stone menu"]          = "Używane Kamienie Stylu"
WritCreater.optionStrings["style stone menu tooltip"]  = "Wybierz, które kamienie stylu będą używane przez dodatek"
WritCreater.optionStrings["exit when done"]            = "Zamknij okno po zakończeniu"
WritCreater.optionStrings["exit when done tooltip"]    = "Zamyka okno rzemiosła po zakończeniu wszystkich prac"
WritCreater.optionStrings["automatic complete"]        = "Automatyczny dialog zadań"
WritCreater.optionStrings["automatic complete tooltip"] = "Automatycznie akceptuje i kończy zadania w odpowiednim miejscu"
WritCreater.optionStrings["new container"]             = "Zachowaj status nowości"
WritCreater.optionStrings["new container tooltip"]     = "Zachowuje status nowości dla pojemników z nagrodami za zlecenia"
WritCreater.optionStrings["master"]                    = "Mistrzowskie Zlecenia"
WritCreater.optionStrings["master tooltip"]            = "Jeśli WŁĄCZONE, dodatek będzie wytwarzał aktywne Mistrzowskie Zlecenia"
WritCreater.optionStrings["right click to craft"]      = "Prawy klik by wytworzyć"
WritCreater.optionStrings["right click to craft tooltip"] = "Jeśli WŁĄCZONE, dodatek wytworzy Mistrzowskie Zlecenia po kliknięciu prawym przyciskiem myszy na zapieczętowane zlecenie. Wymaga włączenia LibCustomMenu"
WritCreater.optionStrings["crafting submenu"]          = "Zlecenia do wytworzenia"
WritCreater.optionStrings["crafting submenu tooltip"]  = "Wyłącz dodatek dla określonych rzemiosł"
WritCreater.optionStrings["timesavers submenu"]        = "Oszczędność czasu"
WritCreater.optionStrings["timesavers submenu tooltip"] = "Różne ułatwienia oszczędzające czas"
WritCreater.optionStrings["loot container"]            = "Otwórz pojemnik po otrzymaniu"
WritCreater.optionStrings["loot container tooltip"]    = "Otwiera pojemniki z nagrodami za zlecenia po ich otrzymaniu"
WritCreater.optionStrings["master writ saver"]         = "Ochrona Mistrzowskich Zleceń"
WritCreater.optionStrings["master writ saver tooltip"] = "Zapobiega przypadkowemu zaakceptowaniu Mistrzowskich Zleceń"
WritCreater.optionStrings["loot output"]               = "Alert o cennych nagrodach"
WritCreater.optionStrings["loot output tooltip"]       = "Wyświetla wiadomość, gdy otrzymasz cenne przedmioty ze zlecenia"
WritCreater.optionStrings["autoloot behaviour"]        = "Zachowanie automatycznego podnoszenia"
WritCreater.optionStrings["autoloot behaviour tooltip"] = "Wybierz, kiedy dodatek ma automatycznie podnosić przedmioty z pojemników z nagrodami"
WritCreater.optionStrings["autoloot behaviour choices"] = {"Kopiuj ustawienia gry", "Automatyczne podnoszenie", "Nigdy nie podnoś"}
WritCreater.optionStrings["hide when done"]            = "Ukryj po zakończeniu"
WritCreater.optionStrings["hide when done tooltip"]    = "Ukrywa okno dodatku po wytworzeniu wszystkich przedmiotów"
WritCreater.optionStrings['reticleColour']             = "Zmiana koloru celownika"
WritCreater.optionStrings['reticleColourTooltip']      = "Zmienia kolor celownika, jeśli na stacji rzemieślniczej znajduje się niezakończone lub zakończone Zlecenie"
WritCreater.optionStrings['autoCloseBank']             = "Automatyczne okno dialogowe banku"
WritCreater.optionStrings['autoCloseBankTooltip']      = "Automatyczne wchodzenie i wychodzenie z dialogu bankowego, jeśli istnieją przedmioty do umieszczenia w banku"
WritCreater.optionStrings['despawnBanker']             = "Odwołanie Bankiera/ Bankierki"
WritCreater.optionStrings['despawnBankerTooltip']      = "Automatyczne odwołanie bankiera / bankierki po wyciągnięciu przedmiotów"
WritCreater.optionStrings['despawnBankerDeposit']      = "Odwołanie Bankiera (Depozyt)"
WritCreater.optionStrings['despawnBankerDepositTooltip'] = "Automatyczne odwołanie bankiera / bankierki po zdeponowaniu przedmiotów"
WritCreater.optionStrings['dailyResetWarnTime']        = "Minuty przed resetem"
WritCreater.optionStrings['dailyResetWarnTimeTooltip'] = "Na ile minut przed codziennym resetem powinno zostać wyświetlone ostrzeżenie"
WritCreater.optionStrings['dailyResetWarnType']        = "Ostrzeżenie przed dziennym resetem"
WritCreater.optionStrings['dailyResetWarnTypeTooltip'] = "Jaki rodzaj ostrzeżenia powinien być wyświetlany, gdy ma nastąpić codzienne resetowanie?"
WritCreater.optionStrings['dailyResetWarnTypeChoices'] = { "Brak","Typ 1", "Typ 2", "Typ 3", "Typ 4", "Wszystkie"}
WritCreater.optionStrings['stealingProtection']        = "Ochrona przed kradzieżą"
WritCreater.optionStrings['stealingProtectionTooltip'] = "Uniemożliwienie kradzieży podczas posiadania aktywnego zlecenia."
WritCreater.optionStrings['noDELETEConfirmJewelry']    = "Łatwe niszczenie Zleceń Jubilerskich"
WritCreater.optionStrings['noDELETEConfirmJewelryTooltip'] = "Automatycznie dodaj potwierdzenie tekstowe DELETE do okna dialogowego niszczenia zlecenia jubilerskiego"
WritCreater.optionStrings['suppressQuestAnnouncements'] = "Ukrycie ogłoszeń o zleceniach"
WritCreater.optionStrings['suppressQuestAnnouncementsTooltip'] = "Ukrywa tekst na środku ekranu po rozpoczęciu zlecenia lub utworzeniu dla niego elementu."
WritCreater.optionStrings["questBuffer"]               = "Bufor dla Zleceń"
WritCreater.optionStrings["questBufferTooltip"]        = "Zachowaj bufor w dzienniku zadań, aby zawsze mieć miejsce na pobranie zleceń"
WritCreater.optionStrings["craftMultiplier"]           = "Mnożnik wytwarzania (wyposażenie i glify)"
WritCreater.optionStrings["craftMultiplierTooltip"]    = "Wytwórz kilka kopii każdego wymaganego przedmiotu, aby nie musieć ich wytwarzać ponownie przy następnym zleceniu. Uwaga: Rezerwuje około 37 miejsc w ekwipunku na każdy stopień powyżej 1"
WritCreater.optionStrings["craftMultiplierConsumables"] = "Mnożnik wytwarzania (alchemia i prowiantowanie)"
WritCreater.optionStrings["craftMultiplierConsumablesTooltip"] = "Pojedyncze wytworzenie wykona jedną akcję, co może zostać pomnożone przez pasywne umiejętności. Pełny stos wytworzy 100 wymaganych przedmiotów, jeśli masz odpowiednie pasywne umiejętności"
WritCreater.optionStrings["craftMultiplierConsumablesChoices"] = {"Pojedyncze wytworzenie", "Pełny stos"}
WritCreater.optionStrings['hireling behaviour']        = "Akcje poczty od dostawców"
WritCreater.optionStrings['hireling behaviour tooltip'] = "Co robić z wiadomościami od dostawców"
WritCreater.optionStrings['hireling behaviour choices'] = { "Nic nie rób", "Odbierz i usuń", "Tylko odbierz"}
WritCreater.optionStrings["alchemyChoices"]            = {"Wyłączone", "Wszystkie funkcje", "Pomiń autowytwarzanie"}

WritCreater.optionStrings["allReward"]                 = "Wszystkie rzemiosła"
WritCreater.optionStrings["allRewardTooltip"]          = "Działania do podjęcia dla wszystkich rzemiosł"
WritCreater.optionStrings['sameForALlCrafts']          = "Użyj tej samej opcji dla wszystkich"
WritCreater.optionStrings['sameForALlCraftsTooltip']   = "Użyj tej samej opcji dla nagród tego typu dla wszystkich rzemiosł"
WritCreater.optionStrings['1Reward']                   = "Kowalstwo"
WritCreater.optionStrings['2Reward']                   = "Zastosowanie dla wszystkich"
WritCreater.optionStrings['3Reward']                   = "Zastosowanie dla wszystkich"
WritCreater.optionStrings['4Reward']                   = "Zastosowanie dla wszystkich"
WritCreater.optionStrings['5Reward']                   = "Zastosowanie dla wszystkich"
WritCreater.optionStrings['6Reward']                   = "Zastosowanie dla wszystkich"
WritCreater.optionStrings['7Reward']                   = "Zastosowanie dla wszystkich"

WritCreater.optionStrings["matsReward"]                = "Nagroda w postaci materiałów"
WritCreater.optionStrings["matsRewardTooltip"]         = "Co zrobić z nagrodami za rzemiosło"
WritCreater.optionStrings["surveyReward"]              = "Nagrody: mapy składników"
WritCreater.optionStrings["surveyRewardTooltip"]       = "Co zrobić z nagrodami w postaci map składników"
WritCreater.optionStrings["masterReward"]              = "Nagrody w postaci Mistrzowskich Zleceń"
WritCreater.optionStrings["masterRewardTooltip"]       = "Co zrobić z nagrodami w postaci Mistrzowskich Zleceń"
WritCreater.optionStrings["repairReward"]              = "Nagrody w postaci zestawów naprawczych"
WritCreater.optionStrings["repairRewardTooltip"]       = "Co zrobić z nagrodami w postaci zestawów naprawczych"
WritCreater.optionStrings["ornateReward"]              = "Nagrody: Wyposażenie ozdobne (Ornate)"
WritCreater.optionStrings["ornateRewardTooltip"]       = "Co robić z wyposażeniem ozdobnym"
WritCreater.optionStrings["intricateReward"]           = "Nagrody: Wyposażenie zawiłe (Intricate)"
WritCreater.optionStrings["intricateRewardTooltip"]    = "Co robić z wyposażeniem zawiłym"
WritCreater.optionStrings["soulGemReward"]             = "Puste klejnoty duszy"
WritCreater.optionStrings["soulGemTooltip"]            = "Co zrobić z pustymi klejnotami duszy"
WritCreater.optionStrings["glyphReward"]               = "Glify"
WritCreater.optionStrings["glyphRewardTooltip"]        = "Co zrobić z glifami"
WritCreater.optionStrings["recipeReward"]              = "Przepisy"
WritCreater.optionStrings["recipeRewardTooltip"]       = "Co zrobić z przepisami"
WritCreater.optionStrings["fragmentReward"]            = "Fragmenty Psijic"
WritCreater.optionStrings["fragmentRewardTooltip"]     = "Co zrobić z fragmentami psijic"
WritCreater.optionStrings["currencyReward"]            = "Nagroda w złocie"
WritCreater.optionStrings["currencyRewardTooltip"]     = "Co zrobić ze złotem z nagród za zadania"
WritCreater.optionStrings["goldMatReward"]             = "Złote ulepszacze (Tylko bez ESO+)"
WritCreater.optionStrings["goldMatRewardTooltip"]      = "Co robić ze złotymi ulepszaczami z nagród. Ignorowane dla subskrybentów ESO+"

WritCreater.optionStrings["writRewards submenu"]       = "Obsługa nagród za zlecenia"
WritCreater.optionStrings["writRewards submenu tooltip"] = "Co robić z wszystkimi nagrodami ze zleceń"
WritCreater.optionStrings["jubilee"]                   = "Rocznicowe skrzynki z łupami"
WritCreater.optionStrings["jubilee tooltip"]           = "Automatycznie otwieraj rocznicowe skrzynki z łupami"
WritCreater.optionStrings["skin"]                      = "Skórka dla Zleceń rzemieślnika"
WritCreater.optionStrings["skinTooltip"]               = "Skórka dla interfejsu Zleceń rzemieślnika"
WritCreater.optionStrings["skinOptions"]               = {"Domyślny", "Serowy", "Koza"}
WritCreater.optionStrings["goatSkin"]                  = "Koza"
WritCreater.optionStrings["cheeseSkin"]                = "Serowy"
WritCreater.optionStrings["defaultSkin"]               = "Domyślny"
WritCreater.optionStrings["rewardChoices"]             = {"Nic nie rób", "Deponuj", "Śmieci", "Zniszcz", "Dekonstruuj"}
WritCreater.optionStrings["scan for unopened"]         = "Otwórz pojemniki przy logowaniu"
WritCreater.optionStrings["scan for unopened tooltip"] = "Po zalogowaniu skanuje plecak w poszukiwaniu nieotwartych pojemników ze zleceń i próbuje je otworzyć"
WritCreater.optionStrings["smart style slot save"]     = "Najmniejsza ilość najpierw"
WritCreater.optionStrings["smart style slot save tooltip"] = "Spróbuje zminimalizować użyte miejsca, jeśli nie masz ESO+, używając najpierw mniejszych stosów kamieni stylu"
WritCreater.optionStrings["abandon quest for item"]    = "Zlecenia wymagające <<1>>"
WritCreater.optionStrings["abandon quest for item tooltip"] = "Jeśli WYŁĄCZONE, automatycznie porzuci zlecenia wymagające <<1>>"
WritCreater.optionStrings["status bar submenu"]        = "Opcje paska stanu"
WritCreater.optionStrings["status bar submenu tooltip"] = "Opcje paska stanu"
WritCreater.optionStrings['showStatusBar']             = "Pokaż pasek stanu"
WritCreater.optionStrings['showStatusBarTooltip']      = "Wyświetlanie lub ukrywanie paska stanu Zadania"
WritCreater.optionStrings['statusBarIcons']            = "Użyj ikon"
WritCreater.optionStrings['statusBarIconsTooltip']     = "Pokazuje ikony rzemiosła zamiast liter dla każdego typu Zlecenia"
WritCreater.optionStrings['transparentStatusBar']      = "Przezroczysty pasek stanu"
WritCreater.optionStrings['transparentStatusBarTooltip'] = "Przezroczysty pasek stanu"
WritCreater.optionStrings['statusBarInventory']        = "Śledzenie Ekwipunku"
WritCreater.optionStrings['statusBarInventoryTooltip'] = "Dodanie śledzenia ekwipunku do paska stanu"
WritCreater.optionStrings['incompleteColour']          = "Kolor nieukończonych zadań"
WritCreater.optionStrings['completeColour']            = "Kolor ukończonych zadań"
WritCreater.optionStrings['smartMultiplier']           = "Inteligentny mnożnik"
WritCreater.optionStrings['smartMultiplierTooltip']    = "Jeśli włączone, Writ Crafter wytworzy przedmioty na pełny cykl 3 dni zleceń. Sprawdzi również, czy masz już przedmioty do zleceń i weźmie to pod uwagę. Jeśli wyłączone, Writ Crafter wytworzy tylko wielokrotność przedmiotów na bieżący dzień"
WritCreater.optionStrings['craftHousePort']            = "Teleport do domu rzemieś."
WritCreater.optionStrings['craftHousePortTooltip']     = "Teleportuje do publicznie dostępnego domu rzemieślniczego"
WritCreater.optionStrings['craftHousePortButton']      = "Teleportuj"
WritCreater.optionStrings['reportBug']                 = "Zgłoś błąd"
WritCreater.optionStrings['reportBugTooltip']          = "Otwórz wątek, aby zgłosić błędy (szczególnie dla wersji konsolowej). Sprawdź najpierw, czy problem nie został już zgłoszony."
WritCreater.optionStrings['openUrlButtonText']         = "Otwórz URL"
WritCreater.optionStrings['donate']                    = "Wesprzyj"
WritCreater.optionStrings['donateTooltip']             = "Wesprzyj Dolgubona na Paypal"
WritCreater.optionStrings['writStats']                 = "Statystyki zleceń"
WritCreater.optionStrings['writStatsTooltip']          = "Zobacz historyczne statystyki nagród za zlecenia wykonane z zainstalowanym dodatkiem"
WritCreater.optionStrings['writStatsButton']           = "Otwórz okno"
WritCreater.optionStrings['queueWrits']                = "Kolejkuj zapieczętowane zlec."
WritCreater.optionStrings['queueWritsTooltip']         = "Dodaj do kolejki wszystkie zapieczętowane zlecenia z ekwipunku"
WritCreater.optionStrings['queueWritsButton']          = "Kolejkuj"
WritCreater.optionStrings['mainSettings']              = "Ustawienia główne"
WritCreater.optionStrings['statusBarHorizontal']       = "Pozycja pozioma"
WritCreater.optionStrings['statusBarHorizontalTooltip'] = "Pozioma pozycja paska stanu"
WritCreater.optionStrings['statusBarVertical']         = "Pozycja pionowa"
WritCreater.optionStrings['statusBarVerticalTooltip']  = "Pionowa pozycja paska stanu"
WritCreater.optionStrings['keepItemWritFormat']        = "Zatrzymaj <<1>>"
WritCreater.optionStrings["npcStyleStoneReminder"]     = "Przypomnienie: Możesz kupić podstawowe rasowe kamienie stylu u każdego sprzedawcy rzemieślniczego za 15g sztuka"
WritCreater.optionStrings["alternate universe"]        = "Wyłącz Prima Aprilis"
WritCreater.optionStrings["alternate universe tooltip"] = "Wyłącz zmianę nazw rzemiosł, stacji rzemieślniczych i innych interaktywnych elementów"

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

WritCreater.cheeseyLocalizations
=
{
	['menuName'] = "Rytuał",
	['endeavorName'] = "Starania o Rytuał",
	['tasks']={
		{original="Znalazłeś dziwną broszurę... Może powinieneś ją przeczytać /read",name="You read some instructions on a ritual for luck", completion = "You learned how to do a ritual for luck!",
			description="Użyj emotki /read"},

		{original="???", name = "Obtain an innocent goat's guts", completion = "You monster! Anything for luck, I guess",
			description="Wygrzeb wnętrzności z martwej kozy. Nie musisz być tym, który ją zabił... ale to najprostszy sposób"},

		{original="???", name = "Head to the ritual site, Arananga", completion = "You made it! It seems like a very industrious place",
			description="Nie wiesz, gdzie jest Arananga? Może to 'obdarzona' stacja rzemiosła..."},

		{original="???", name = "Destroy the goat guts", completion = "You 'burnt' the sacrifice",
			description="Zniszcz przedmiot |H1:item:42870:30:1:0:0:0:0:0:0:0:0:0:0:0:16:0:0:0:1:0:0|h|h you looted"},

		{original="???", name = "Praise RNGesus in chat", completion = "You feel strangely lucky, but maybe it's just a feeling...",
			description="Nie możesz powiedzieć, co tak naprawdę powiedział, ale to najlepsze przypuszczenie"},
				-- Or Nocturnal, or Fortuna, Tyche as easter eggs?

		-- {original="???", name = "Complete the ritual", completion = "Maybe you'll be just a little bit luckier... And Writ Crafter has a new skin!",
		-- description="Sheogorath will be very pleased if you complete them all!"},
	},
	["completePrevious"] = "W pierwszej kolejności powinieneś wykonać",
	['allComplete'] = "Ukończyłeś Rytuał!",
	['allCompleteSubheading'] = "Nawet jeśli RNGesus nie będzie ci sprzyjał w przyszłym roku, przynajmniej Zlecenia rzemieślnika mają nowy wygląd!",
	["goatContextTextText"] = "Koza",
	["bookText"] = 
[[
This ritual  |L0:0:0:45%%:8%%:ignore|lwill|l might give you great luck. Make sure to follow these steps exactly!
1. Obtain some guts from a |L0:0:0:45%%:8%%:ignore|lsheep|l goat
2. Go to |L0:0:0:45%%:8%%:ignore|lOblivion|l Arananga
3. Burn the guts
4. Praise [the name here is illegible]

- Sincerely,
|L0:0:0:45%%:8%%:ignore|lSheogorath|l Not Sheogorath]],
["bookTitle"] = "Rytuał na szczęście",
["outOfRange"] = "Nie jesteś już w obszarze Rytuału!",
["closeEnough"] = "Wystarczająco blisko",
["praiseHint "] = "Może musisz powiedzieć coś o RNGesus?",
}
--/esoui/art/icons/pet_041.dds
--/esoui/art/icons/pet_042.dds
--/esoui/art/icons/pet_sheepbrown.dds

