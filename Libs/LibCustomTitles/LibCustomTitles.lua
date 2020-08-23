--[[
Original Author: Aysdsdsantir
Current Author: Dolgubon
Past Author: Kyoma
Filename: LibCustomTitles.lua
Version: 10
]]--

--[[

This software is under : CreativeCommons CC BY-NC-SA 4.0
Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0)

You are free to:

    Share — copy and redistribute the material in any medium or format
    Adapt — remix, transform, and build upon the material
    The licensor cannot revoke these freedoms as long as you follow the license terms.


Under the following terms:

    Attribution — You must give appropriate credit, provide a link to the license, and indicate if changes were made. You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.
    NonCommercial — You may not use the material for commercial purposes.
    ShareAlike — If you remix, transform, or build upon the material, you must distribute your contributions under the same license as the original.
    No additional restrictions — You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.


Please read full licence at : 
http://creativecommons.org/licenses/by-nc-sa/4.0/legalcode

]]--


--[[

Author: Dolgubon
NOTE: Used Kyoma's version as a base. Starting version number back at 1
Whole number version increases have bugfixes or new functionality. 
Decimal version increases merely have new titles.
Version 4:
	- Changed what the u umlaut character was mapped to. With the previous one, when encoded it was a ' which provided issues

Version 3:
	- Fixed some issues with language and players using a non official langauge

Version 2:
	- Fixed an issue where titles that did not globally replace were not showing up for the player with the title

Version 1:
	- Global titles will now show up only once in the list of titles, replacing 'Volunteer'
	- The title will still be shown to other players regardless of what is selected
	- If no title is given for a player in a certain language, then no custom title will be used
	- The only exception is non official game translations - In that case, the English title will be used
	- Removed the Modules from Kyoma's version
	- Fixed a bug with titles for specific characters
	- Only has test titles
	- Removed many of the titles in the titleLocale


Author: Kyoma
Version 20
Changes: Rewrote how custom titles are added and stored to help reduce conflict between authors
	- Moved table with custom titles into seperate section with register function
	- Use achievementId instead of raw title name to make it work with all languages
	- Make it default to english custom title if nothing is specified for the user's language
	- Support for LibTitleLocale to fix issues with title differences for males and females
	
	(v18) 
	- Added support for colors and even a simple gradient
	- Moved language check to title registration
	
	(v19)
	- Fixed problems with UTF8 characters and color gradients
	
	(v20)
	- Added option to replace a title globally.
]]--
local libName = "LibCustomTitles"
if not LibStub then return end
LibStub:NewLibrary(libName, 100)
EVENT_MANAGER:UnregisterForEvent(libName, EVENT_ADD_ON_LOADED)

local libLoaded
local LIB_NAME, VERSION = "LibCustomTitlesN", 4.6
local LibCustomTitles, oldminor = LibStub:NewLibrary(LIB_NAME, VERSION)
if not LibCustomTitles then return end

local titles = {}

local _, nonHideTitle =  GetAchievementRewardTitle(92)
local _, nonHideCharTitle =  GetAchievementRewardTitle(93)



local lang = GetCVar("Language.2")
local supportedLang = 
{
	['en']=1,
	['de']=1,
	['fr']=1,
}


local customTitles = {}
local playerDisplayName = HashString(GetDisplayName())
local playerCharName = HashString( GetUnitName('player'))
local doesPlayerHaveGlobal 
local doesCharHaveGlobal 
function LibCustomTitles:RegisterTitle(displayName, charName, override, title)
	local titleToUse
	if type(title) == "table" then
		if title[lang] then
			titleToUse = title[lang]
		end

		if not supportedLang[lang] then titleToUse=title['en'] end
		if not titleToUse then return end
	end
	title = titleToUse
	--local hidden = (extra == true) --support old format

	if override == true  then
		if playerDisplayName == displayName then

			if charName == playerCharName then
				doesCharHaveGlobal = true
			elseif not charName then
				doesPlayerHaveGlobal = true
			end -- otherwise, it's another character

		end
	end

	local playerGender = GetUnitGender("player")
	local genderTitle

	if type(override) == "boolean" then --override all titles
		override = override and "-ALL-" or "-NONE-"
	elseif type(override) == "number" then --get override title from achievementId
		local hasRewardOfType, titleName = GetAchievementRewardTitle(override, playerGender) --gender is 1 or 2
		if hasRewardOfType and titleName then
			genderTitle = select(2, GetAchievementRewardTitle(override, 3 - playerGender))  -- cuz 3-2=1 and 3-1=2
			override = titleName
		end
	elseif type(override) == "table" then --use language table with strings
		override = override[lang] or override["en"]
	end

	if type(override) == "string" then 
		if not customTitles[displayName] then 
			customTitles[displayName] = {}
		end
		local charOrAccount = customTitles[displayName]
		if charName then
			if not customTitles[displayName][charName]  then 
				customTitles[displayName][charName] = {}
			end
			charOrAccount = customTitles[displayName][charName]
		end
		charOrAccount[override] = title
		if genderTitle and genderTitle ~= override then
			charOrAccount[genderTitle] = title
		end
	end
end

--= MOD(C1 +24,89)+38
--= MOD(E1 +78,89)+38

--iferror(char(VLOOKUP(mid(I1,1,1),B1:C,2,false)),"")&iferror(char(VLOOKUP(mid(I1,2,1),B1:C,2,false)),"")&iferror(char(VLOOKUP(mid(I1,3,1),B1:C,2,false)),"")&iferror(char(VLOOKUP(mid(I1,4,1),B1:C,2,false)),"")&iferror(char(VLOOKUP(mid(I1,5,1),B1:C,2,false)),"")&iferror(char(VLOOKUP(mid(I1,6,1),B1:C,2,false)),"")&iferror(char(VLOOKUP(mid(I1,7,1),B1:C,2,false)),"")&iferror(char(VLOOKUP(mid(I1,8,1),B1:C,2,false)),"")&iferror(char(VLOOKUP(mid(I1,9,1),B1:C,2,false)),"")&iferror(char(VLOOKUP(mid(I1,10,1),B1:C,2,false)),"")&iferror(char(VLOOKUP(mid(I1,11,1),B1:C,2,false)),"")&iferror(char(VLOOKUP(mid(I1,12,1),B1:C,2,false)),"")&iferror(char(VLOOKUP(mid(I1,13,1),B1:C,2,false)),"")&iferror(char(VLOOKUP(mid(I1,14,1),B1:C,2,false)),"")&iferror(char(VLOOKUP(mid(I1,15,1),B1:C,2,false)),"")&iferror(char(VLOOKUP(mid(I1,16,1),B1:C,2,false)),"")&iferror(char(VLOOKUP(mid(I1,17,1),B1:C,2,false)),"")&iferror(char(VLOOKUP(mid(I1,18,1),B1:C,2,false)),"")&iferror(char(VLOOKUP(mid(I1,19,1),B1:C,2,false)),"")&iferror(char(VLOOKUP(mid(I1,20,1),B1:C,2,false)),"")&iferror(char(VLOOKUP(mid(I1,21,1),B1:C,2,false)),"")&iferror(char(VLOOKUP(mid(I1,22,1),B1:C,2,false)),"")&iferror(char(VLOOKUP(mid(I1,23,1),B1:C,2,false)),"")&iferror(char(VLOOKUP(mid(I1,24,1),B1:C,2,false)),"")&iferror(char(VLOOKUP(mid(I1,25,1),B1:C,2,false)),"")&iferror(char(VLOOKUP(mid(I1,26,1),B1:C,2,false)),"")&iferror(char(VLOOKUP(mid(I1,27,1),B1:C,2,false)),"")&iferror(char(VLOOKUP(mid(I1,28,1),B1:C,2,false)),"")&iferror(char(VLOOKUP(mid(I1,29,1),B1:C,2,false)),"")&iferror(char(VLOOKUP(mid(I1,30,1),B1:C,2,false)),"")&iferror(char(VLOOKUP(mid(I1,31,1),B1:C,2,false)),"")
function LibCustomTitles:Init()
	

	local CT_NO_TITLE = 0
	local CT_TITLE_ACCOUNT = 1
	local CT_TITLE_CHARACTER = 2

	local function GetCustomTitleType(displayName, unitName)
		if customTitles[displayName] then
			if customTitles[displayName][unitName] then
				return CT_TITLE_CHARACTER
			end
			return CT_TITLE_ACCOUNT
		end
		return CT_NO_TITLE
	end

	local function GetCustomTitle(originalTitle, customTitle)

		if customTitle then 
			if customTitle[originalTitle] then
				return customTitle[originalTitle]
			elseif originalTitle == "" and customTitle["-NONE-"] then
				return customTitle["-NONE-"]
			elseif customTitle["-ALL-"] then
				return customTitle["-ALL-"]
			end
		end
	end

	local function GetModifiedTitle(originalTitle, displayName, charName)

		-- check for global override
		local returnTitle = GetCustomTitle(originalTitle, customTitles["-GLOBAL-"]) or originalTitle
		-- check for player override
		local registerType = GetCustomTitleType(displayName, charName)

		if registerType == CT_TITLE_CHARACTER then
			return GetCustomTitle(originalTitle, customTitles[displayName][charName]) or returnTitle
		elseif registerType == CT_TITLE_ACCOUNT then 
			return GetCustomTitle(originalTitle, customTitles[displayName]) or returnTitle
		end
		return returnTitle
	end

	local GetUnitTitle_original = GetUnitTitle
	GetUnitTitle = function(unitTag)
		local unitTitleOriginal = GetUnitTitle_original(unitTag)
		local unitDisplayName = HashString(GetUnitDisplayName(unitTag))
		local unitCharacterName = HashString(GetUnitName(unitTag))

		return GetModifiedTitle(unitTitleOriginal, unitDisplayName, unitCharacterName)
	end

	local GetTitle_original = GetTitle
	GetTitle = function(index)
		local titleOriginal = GetTitle_original(index)
		local displayName = HashString(GetDisplayName())
		local characterName = HashString(GetUnitName("player"))
		local title = GetModifiedTitle(titleOriginal, displayName, characterName )

		if title ~= titleOriginal then 
			-- We don't want the title to overwrite everything in the dropdown
			-- So we only replace volunteer

			if nonHideTitle ~= titleOriginal then 
				if doesPlayerHaveGlobal or doesCharHaveGlobal then
					return titleOriginal
				else
					return title 
				end
			end

			return title
		else
			return title
		end
	end

end

local function OnAddonLoaded()
	if not libLoaded then
		libLoaded = true
		local LCC = LibStub(LIB_NAME)
		LCC:Init()
		EVENT_MANAGER:UnregisterForEvent(LIB_NAME, EVENT_ADD_ON_LOADED)
	end
end

EVENT_MANAGER:RegisterForEvent(LIB_NAME, EVENT_ADD_ON_LOADED, OnAddonLoaded)

local lct=LibCustomTitles
lct.RT = lct.RegisterTitle
lct:RT(1276148971,2868841312,true,{en="Herder of Cats",})
lct:RT(383898450,false,true,{en="Master of Writs",})lct:RT(383898450,4149698651,true,{en="Undying",fr="L'immortel",de="Undying",})
lct:RT(80340145,2040263953,92,{en="The One True",fr="Le Vrai",de="Der Eine Wahre",})
lct:RT(716725346,4019141728,true,{en="Last Ayleid King",})
lct:RT(1540406231,false,true,{en="The Doyen",fr="Le Doyen",de="Der Doyen",})
lct:RT(755746377,false,628,{en="The Benefactor",fr="Le Bienfaiteur",de="Der Wohltäter",})
lct:RT(4141355865,false,92,{en="Guildmaster",fr="Guildmaster",de="Guildmaster",})
lct:RT(3185324787,false,92,{en="Architect",fr="Architecte",de="Architekt",})
lct:RT(1171120197,false,true,{en="RNGoddess",fr="RNGoddess",de="RNGoddess",})
lct:RT(65500869,false,92,{en="Seal Boi",fr="Seal Boi",de="Seal Boi",})lct:RT(65500869,75627323,92,{en="Il Duce",})
lct:RT(4198689717,1143482591,92,{en="Archmagister",})
lct:RT(2074654098,false,92,{en="Absolutely Not Suspicious",fr="Carrément pas Suspect",de="Absolut Nicht Verdächtig",})lct:RT(2074654098,4247615100,92,{en="Planeswalker",fr="Arpenteuse de Mondes",de="Weltenwanderer",})
lct:RT(3966971491,false,92,{en="LGC Argonian Lover",fr="LGC Argonian Lover",de="LGC Argonian Lover",})
lct:RT(3820965258,false,92,{en="Bloodthirsty",fr="Bloodthirsty",de="Bloodthirsty",})lct:RT(3820965258,1047795165,92,{en="Grabs Popcorn",fr="Grabs Popcorn",de="Grabs Popcorn",})
lct:RT(3782668513,3337670239,92,{en="Guardian",})
lct:RT(1419169535,false,1330,{en="Quartermaster",})
lct:RT(3580024219,false,92,{en="Stormhold Mercenary",fr="Mercenaire de Fort-Tempête",de="Sturmfeste Söldner",})
lct:RT(347320517,false,92,{en="Potato Masher",fr="Masher de Pommes de Terre",de="Kartoffelstampfer",})
lct:RT(87490740,false,92,{en="Sanguine Rose",de="Sanguines Rose",})
lct:RT(2550321801,false,92,{en="Fluffy Paws Fighty Claws",fr="Fluffy Paws Fighty Claws",})lct:RT(2550321801,1979421257,1810,{en="Tankitty-Cat",fr="Tankitty-Cat",})
lct:RT(874548877,false,92,{en="Mudball Maven",fr="Mudball Maven",de="Schlammball Maven",})
lct:RT(416224960,false,92,{en="Very Angry",fr="Très en colère",de="Sehr wütend",})
lct:RT(2740299925,3886364242,92,{en="Dragon Spirit",fr="Dragon Spirit",de="Dragon Spirit",})
lct:RT(3196471767,false,92,{en="Garlic Connoisseur",fr="Connoisseur à l'ail",de="Knoblauch-Kenner",})
lct:RT(1731359458,false,92,{en="Sandbag Master",})
lct:RT(2392316419,false,true,{en="Fistikli Baklava",fr="Canne Baklava",de="Zuckerrohr Baklava",})lct:RT(2392316419,1701693549,true,{en="Pistachio Baklava",fr="Canne Baklava",de="Zuckerrohr Baklava",})
lct:RT(2402295877,false,92,{en="Great Sage, Equal of Heaven",fr="Grand Saint Égal du Ciel",de="Großer Heiliger Himmel",})
lct:RT(2762805744,false,1391,{en="Stonecutter",})
lct:RT(1069428601,false,92,{en="Healer of the Weak ",fr="Guérisseur des Faibles",de="Heiler der Schwachen",})
lct:RT(2511359942,false,92,{en="The Zerg Conductor",fr="Le Chef Zerg",de="Der Zerg Dirigent",})
lct:RT(2037837684,false,92,{en="Servant of Goddess Glitter",})
lct:RT(1904732837,false,true,{en="Adder of Ons",fr="Additionneur de Ons",de="Addierer von Ons",})
lct:RT(2787550069,453923765,true,{en="Resto-in-Disguise",fr="Resto-in-Disguise",de="Resto-in-Disguise",})
lct:RT(1987214583,false,92,{en="The Elder Dragon",fr="The Elder Dragon",de="The Elder Dragon",})lct:RT(1987214583,3107977549,628,{en="The Mastermind",fr="The Mastermind",de="The Mastermind",})
lct:RT(2193066671,false,92,{en="Rocketeer",})lct:RT(2193066671,2274919616,1810,{en="Kosmonaut Kitty",})
lct:RT(3600512696,false,92,{en="|ca65cffLightning Form|r",})
lct:RT(1024520674,false,92,{en="Peacekeeper",fr="Soldat de la Paix",de="Friedenswächter",})
lct:RT(4257573713,false,92,{en="Omae Wa Mou Shindeiru",fr="Omae Wa Mou Shindeiru",de="Omae Wa Mou Shindeiru",})
lct:RT(300272211,1867375193,92,{en="Steaming Hot",})
lct:RT(3316406928,false,92,{en="Songweaver",fr="Tisseur de Chanson",de="Liedweber",})lct:RT(3316406928,331729979,1391,{en="Literary Legend",fr="Légende Littéraire",de="Literarische Legende",})
lct:RT(653129646,false,92,{en="The Golden Saint",fr="Le Saint d'Or",de="Der Goldene Heilige",})lct:RT(653129646,1618900846,92,{en="The Druid",fr="Le Druide",de="Der Druide",})
lct:RT(2514190522,false,92,{en="Imperial Battlemage",fr="Battlemage Impérial",de="Imperialer Kampfmagier",})lct:RT(2514190522,2080803584,1810,{en="Spear of Stendarr",fr="Lance de Stendarr",de="Speer von Stendarr",})
lct:RT(2224225614,false,92,{en="Speaker for the Dead",})
lct:RT(3879977139,false,92,{en="The Assembly General",})lct:RT(3879977139,189200680,92,{en="Cannot Pad Five",})
lct:RT(3957423493,false,92,{en="The Swole Patrol",})
lct:RT(3198987902,false,92,{en="The Gifted",})lct:RT(3198987902,3050075638,92,{en="The Awakened",})
lct:RT(265543675,false,92,{en="Icebreaker",fr="Icebreaker",de="Eisbrecher",})lct:RT(265543675,1652025059,92,{en="The Cure for Death",fr="Le Remède Contre la Mort",de="Die Heilung für den Tod",})
lct:RT(1517585757,false,92,{en="Bachelas BFF",})
lct:RT(2188837655,false,92,{en="Top Priority",fr=" Priorité",})lct:RT(2188837655,2836585406,51,{en="Shrek",})
lct:RT(2083511209,false,92,{en="Dark Emerald",fr="Emeraude Sombre",})
lct:RT(2050501477,false,92,{en="Wandering Adventurer",})lct:RT(2050501477,3768515314,51,{en="Holy Priest of Meridia",})
lct:RT(658966427,false,92,{en="Artificer of Zenithar",fr="Artificier de Zenithar",de="Kunsthandwerker von Zenithar",})lct:RT(658966427,532842436,628,{en="Red Diamond",fr="Diamant Rouge",de=" Roter Diamant",})
lct:RT(188206946,false,92,{en="Master of Memes",fr="Maître des Mèmes",de="Meister der Memes",})
lct:RT(3235505263,false,92,{en="Ginger",fr="Rouquin",de="Rotkopf",})
lct:RT(397091973,false,true,{en="Merciless Resolve",fr="Résolution Impitoyable",de="Gnadenlose Entschlossenheit",})
lct:RT(2660919200,false,92,{en="Mentor",})
lct:RT(3929357616,721680880,92,{en="The Beamplar",})
lct:RT(1527484276,false,92,{en="Stormbreaker",})
lct:RT(452725322,false,92,{en="Divine Executioner",fr="Divin Bourreau",de="Göttlicher Scharfrichter",})lct:RT(452725322,3541899474,2079,{en="The Machine",fr="La Machine",de="Die Maschine",})
lct:RT(671038416,false,2079,{en="Silver Zerg Surfer",fr="Argent Surfeur Zerg",de="Silber Zerg Surfer",})
lct:RT(391627066,false,92,{en="Guardian Angel",fr="Ange Gardien",de="Schutzengel",})
lct:RT(1449947651,false,92,{en="Scrubtastic Carebear",})
lct:RT(1143345413,false,92,{en="FG1 Progression Team",fr="FG1 Progression Team",de="FG1 Progression Team",})
lct:RT(3396402417,false,51,{en="The Living Shadow",fr="L'ombre Vivante",de="Der Rastlose Schatten",})lct:RT(3396402417,401432131,628,{en="White Fang",fr="Croc Blanc",de="Weißer Fangzahn",})
lct:RT(2837968354,false,92,{en="One Man Army",fr="Un Homme Armée",de="Ein-mann-armee",})
lct:RT(173478323,2881560666,92,{en="Strong Smelling Orc",de="Stark Miefender Ork",})
lct:RT(1804301692,false,92,{en="Lady of the South Island",fr="Dame de l'Ile du Sud",de="Dame der Südinsel",})
lct:RT(1044122497,false,92,{en="The Loremaster",fr="Loremaster",de="Loremaster",})lct:RT(1044122497,2763479321,1330,{en="DC Spy",fr="Espion DC",de="DC Spion",})
lct:RT(3836251840,false,true,{en="Cakes By The Ocean",fr="Gâteau au Bord de L'océan",de="Kuchen am Meer",})lct:RT(3836251840,3297937951,1330,{en="Queen of Cakes",fr="Reine des Gâteaux",de="Königin der Kuchen",})
lct:RT(1059334478,false,92,{en="Coaxes Metal",fr="Coaxes Métal",de="Koaxes Metall",})
lct:RT(1076342159,false,92,{en="The Honorable",fr="L'Honorable",de="Die Ehrhaften",})
lct:RT(130665165,false,92,{en="The Bogeyman",fr="Le Croque-mitaine",de="Der Buhmann",})
lct:RT(244717510,false,92,{en="La Conquérante pas Implaquable",fr="La Conquérante pas Implaquable",de="La Conquérante pas Implaquable",})lct:RT(244717510,1184782488,92,{en="Pharmacienne",fr="Pharmacienne",de="Pharmacienne",})
lct:RT(1342813983,2721735970,92,{en="The Ripper",fr="L'Eventreur",de="Der Aufreißer",})
lct:RT(1627745582,false,92,{en="Skooma Addict",fr="Le Skooma Addict",de="Skooma Abhängigen",})
lct:RT(2487628104,false,92,{en="|cff69b4Desu Desu ~|r",fr="|cff69b4Desu Desu ~|r",de="|cff69b4Desu Desu ~|r",})lct:RT(2487628104,2978586387,1810,{en="|cff69b4Te Tanqueo Papi ~|r",fr="|cff69b4Je vais vous Tanker Papa|r",de="|cff69b4Ich werde Panzer dich Papa|r",})
lct:RT(2183832415,1367751853,92,{en="XO Tour Llif3",})
lct:RT(210728403,270455745,92,{en="The Methodical",})
lct:RT(3252834201,false,92,{en="The Simon Express",fr="Le Simon Express",de="Der Simon Express",})
lct:RT(1365579521,false,628,{en="Wipes on Trash",})
lct:RT(2822666538,false,true,{en="|cFF0000Soul Reaper|r",fr="|cFF0000Soul Reaper|r",de="|cFF0000L'Ankou|r",})
lct:RT(1507726281,3541509713,92,{en="Javelin of Stendarr",fr="Javelot de Stendarr",de="Speerwurf von Stendarr",})
lct:RT(1158594345,false,92,{en="Protector of the Realm",})
lct:RT(4267095257,false,92,{en="|c800080Cloud Chaser|r",fr="|c800080Nuage Chasse|r",de="|c800080Wolkenjäger|r",})
lct:RT(109224740,1737010384,92,{en="Dream Killer",fr="Tueur de Rêve",de="Traum-Killer",})
lct:RT(713456003,false,1330,{en="The Flawless Gladiator",fr="Gladiateur Implacable",})lct:RT(713456003,3775367921,1330,{en="The Flawless Gladiator",fr="Gladiateur Implacable",})
lct:RT(3750747221,false,92,{en="Guardian of the Galaxy",})lct:RT(3750747221,2918372644,51,{en="The Bird from Misfortune",fr="Oiseau du Malheur",})
lct:RT(2864716338,false,92,{en="Mistress of the Dark",})
lct:RT(1013558538,false,1391,{en="Enterprising Memelord",fr="Enterprising Memelord",de="Enterprising Memelord",})lct:RT(1013558538,3510921308,2079,{en="Disband Disband Disband",fr="Disband Disband Disband",de="Disband Disband Disband",})
lct:RT(4120068347,false,92,{en="Tea Maker",fr="Théière",de="Teekocher",})lct:RT(4120068347,2030795112,1810,{en="DoOoD",})
lct:RT(841517891,false,92,{en="Worthy",})
lct:RT(0,0,92,{en="SITH LORD",})
lct:RT(810384984,238394253,92,{en="Apex",})
lct:RT(4052732411,false,92,{en="Casual",})lct:RT(4052732411,671906596,92,{en="Casual",})
lct:RT(3204068434,false,92,{fr="Dragonfire Rider",})lct:RT(3204068434,2083966292,51,{en="Storm Rider",})
lct:RT(425871172,false,92,{en="Sword Of Shannara",})
lct:RT(4292278260,false,92,{en="The Ring Bearer",})lct:RT(4292278260,2488928266,2079,{en="The Illuminated",})
lct:RT(3101213993,false,true,{en="|c2763d8The Immortal",fr="|c2763d8L'immortel",de="|c2763d8Der Unsterbliche",})
lct:RT(2014809841,2978736366,92,{en="Curio Collector",fr="Collectionneur de Curiosités",de="Kuriositätensammler",})
lct:RT(2063947617,false,92,{en="Queen Of Lizards",fr="reine des lézards",de=" Königin der Eidechsen",})lct:RT(2063947617,341020706,92,{en="Emperor Of Lizards",fr=" Empereur Des Lézards",de="Kaiser der Eidechsen",})
lct:RT(3128590789,false,92,{en="Bacon Destroyer",fr="Destructeur de bacon",de="Speckzerstörer",})
lct:RT(4293973946,3056998748,1330,{en="Holy Crusader",de="makellose Eroberin",})
lct:RT(1161506350,false,92,{en="Dizzying Spammer",fr="Dizzying Spammer",de="Dizzying Spammer",})
lct:RT(3733334153,false,92,{en="Grand War Chief Supreme",})
lct:RT(3130962581,false,494,{en="Moon Light",fr="Clair de lune",de="Mondlicht",})lct:RT(3130962581,4261844445,494,{en="Moon Light",fr="Clair de lune",de="Mondlicht",})
lct:RT(2127935949,false,628,{en="The Sassmancer",})lct:RT(2127935949,3789400369,92,{en="The Terrible Snowmer",fr=" Le Terrible Neigemer",de="Der Schreckliche Schneemer",})
lct:RT(4044176894,false,92,{en="The Cursed One",})
lct:RT(1403951427,false,92,{en="The Unforgiven",})
lct:RT(2709370135,false,92,{en="Silvery Darkness",fr="Obscurité argentée",de="Silbrige Dunkelheit",})
lct:RT(4281723531,false,92,{en="Wipes on Trash",fr="Lingettes sur la Corbeille",de="Wischt im Mull",})lct:RT(4281723531,306136156,1330,{en="Stamplar will never die",fr="Stamplar ne mourra jamais",de=" Stamplar wird niemals sterben",})
lct:RT(3619172715,false,92,{en="Master Zerg Surfer",fr="Master Zerg Surfer",de="Master Zerg Surfer",})
lct:RT(3188788347,false,92,{en="Fabulous",fr="Fabuleux",de="Fabelhaft",})lct:RT(3188788347,1700138827,92,{en="Just a bit Mieh",fr="Just a bit Mieh",de="Just a bit Mieh",})
lct:RT(4048208493,1185902972,92,{en="Sinister Turkey",})
lct:RT(2858992612,false,92,{en="Master of Knowledge",fr="Maître de la Connaissance",de="Meister des Wissens",})
lct:RT(4124279317,false,92,{en="Elegantly Wasted",fr="Élégamment Gaspillé",de="Elegant Vergeudet",})lct:RT(4124279317,1022046773,628,{en="Spoiled Brat",fr="Gamin Gâté",de="Verzogenes Gör",})
lct:RT(2119731248,1017899260,true,{en="Shadow of the West",fr="Ombre de l'Ouest",de="Schatten des Westens",})
lct:RT(1298377073,false,92,{en="Master Chef",})lct:RT(1298377073,599246026,92,{en="Master Chef",})
lct:RT(763457523,false,1810,{en="Ardent Flame",fr="Flamme ardente",de="Gluhende Flamme",})
lct:RT(798111974,false,92,{en="Sin of Greed",})
lct:RT(3085595752,2582039471,92,{en="Golden Guardian",})
lct:RT(1953523750,3270432679,92,{en="Battlemage",})
lct:RT(3506149602,false,92,{en="Coding Cat",fr="Coding Cat",de="Coding Cat",})lct:RT(3506149602,2311532378,1810,{en="The Ever-Living",fr="The Ever-Living",de="The Ever-Living",})
lct:RT(533751404,false,92,{en="Muthsera",fr="Muthsera",de="Muthsera",})
lct:RT(2513617898,3008522260,92,{en="Ashkhan",})
lct:RT(1703460885,false,92,{en="Friendly Neighbour",})lct:RT(1703460885,3210043349,92,{en="Wings of Wonder",})
lct:RT(760593166,false,92,{en="Black Widow",fr="Veuve Noir",de="Schwarze Witwe",})
lct:RT(1134753014,false,92,{en="Urs Major",fr="Urs Major",de="Urs Major",})lct:RT(1134753014,2223000998,92,{en="Professor at Ankh-Morpork",fr="Professeur à Ankh-Morpork",de="Professor in Ankh-Morpork",})
lct:RT(1838172566,false,92,{en="Living Legend",fr="Légende Vivante",de="Lebende Legende",})
lct:RT(3091229980,false,92,{en="Vulxsedx",fr="Vulxsedx",de="Vulxsedx",})lct:RT(3091229980,4134294656,92,{en="Claymore I I X",fr="Claymore I I X",de="Claymore I I X",})
lct:RT(2845909476,false,92,{en="The NonPlusUltra",fr="Le NonPlusUltra",de="Das NonPlusUltra",})lct:RT(2845909476,2216570798,705,{en="No Mercy",fr="Sans pitié ",de="Keine Gnade",})
lct:RT(2359969152,false,2079,{en="O Mago é Implacável",fr="Le magicien est Implacable",de="Der Zauberer ist Unerbittlich",})
lct:RT(2455827257,false,92,{en="Real mvp Stick P",fr="Real mvp Stick P",de="Real mvp Stick P",})lct:RT(2455827257,1298336713,92,{en="Real mvp Stick P",fr="Real mvp Stick P",de="Real mvp Stick P",})
lct:RT(3436387716,false,705,{en="Scourge Of Cyrodiil",fr="Fléau Du Cyrodiil",de="Geißel von Cyrodiil",})
lct:RT(3990524561,false,92,{en="Punk Bunny",fr="Punk Lapin",de="Punk-Hase",})
lct:RT(2995614219,false,92,{en="Chief of Eques Noctis ",de="Eques Noctis Chefin ",})lct:RT(2995614219,3531621777,92,{en="Chief of Eques Noctis",de="Eques Noctis Chefin",})
lct:RT(2589474561,false,92,{en="The Entheogenic",fr="L'Entheogenic",de="Die Entheogene",})
lct:RT(1375307746,2374834210,true,{en="Amazon Queen",fr="Reine Amazone",de="Amazonenkönigin",})
lct:RT(1616012896,false,92,{en="Top-Notch Newbie",})
lct:RT(453266517,false,92,{en="Clearly Confused",})
lct:RT(1545464185,4007320154,92,{en="Scooma Dealer",fr="Concessionnaire Scooma",de="Scooma Händler",})
lct:RT(2648996415,false,92,{en="Happy Dreamer",fr="Heureux Rêveur",de="Glücklicher Träumer",})lct:RT(2648996415,2708407449,628,{en="Born to be Wild",})
lct:RT(989799715,false,628,{en="The Light of Dawn",fr="La lumière de l'aube",de="Das Licht der Dämmerung",})lct:RT(989799715,155839631,628,{en="The Light of Dawn",fr="La lumière de l'aube",de=" Das Licht der Dämmerung",})
lct:RT(1536721951,false,true,{en="Diva Emo Goth Of Darkness",})lct:RT(1536721951,2936424338,true,{en="Diva Emo Goth Of Darkness",})
lct:RT(701268649,false,true,{en="Dreaming Light",fr="Rêver Lumière",de="Träumendes Licht",})
lct:RT(83156374,641865682,92,{en="Thieves Guild Master",fr="Maître de guilde des voleurs",de=" Meister der Diebesgilde",})
lct:RT(1256140351,4217760066,705,{en="Shield Stacker",})
lct:RT(1584171560,false,92,{en="Consul of Padomay",fr="Délégué de Padomay",de="Konsul von Padomay",})lct:RT(1584171560,2855390806,1330,{en="The Dragon of Valenwood",fr="Le Dragon de la Forêt",de="Der Drache aus dem Wald",})
lct:RT(2092303465,false,92,{en="Crowd Puller",fr="Attraction",de="Zugpferd",})
lct:RT(3936655003,false,92,{en="The Butcher",fr="Le Bouche",de="Der Metzger",})lct:RT(3936655003,3829163913,92,{en="The Butcher",fr="Le Boucher",de="Der Metzger",})
lct:RT(3415080388,false,92,{en="Jackaleen",fr="Jackaleen",de="Jackaleen",})lct:RT(3415080388,1977445892,92,{en="Jackaleen",fr="Jackaleen",de="Jackaleen",})
lct:RT(1497236838,false,628,{en="The Harbinger",fr="Le Précurseur",de="Der Vorbote",})lct:RT(1497236838,3464652070,628,{en="The Harbinger",fr="Le Précurseur",de="Der Vorbote",})
lct:RT(3409167202,false,628,{en="Banana King",fr="Roi des Bananes",de="Bananenkönig",})lct:RT(3409167202,3950693890,1810,{en="The Bananaborn",fr="Bananaborn",de="Bananaborn",})
lct:RT(1264525618,false,92,{en="Dominion Blade",fr="Lame de Dominion",de="Dominion Klinge",})
lct:RT(2414560110,false,92,{en="Warchief",})lct:RT(2414560110,3234044858,92,{en="Warchief of the Ebonheart Pact",})
lct:RT(248279039,false,92,{en="Septims in the Club",fr="Septims au Club",de="Septime im Club",})
lct:RT(534369183,false,92,{en="Professional Pleb",})
lct:RT(3919596526,false,92,{en="The Fallen Immortal",})lct:RT(3919596526,3173817294,92,{en="The Fallen Immortal",})
lct:RT(3635291151,false,92,{en="Magnificent Lady Ugh",fr="Magnificent Lady Ugh",de="Magnificent Lady Ugh",})
lct:RT(1272131356,false,92,{en="Voice of the Sixth House",fr="Voix de la sixième maison",de="Stimme des sechsten Hauses",})lct:RT(1272131356,3288291811,92,{en="Voice of the Sixth House",fr="Voix de la sixième maison",de="Stimme des sechsten Hauses",})
lct:RT(3495921003,false,92,{en="Rage of Malacath",})lct:RT(3495921003,2459526581,628,{en="Brute Force",})
lct:RT(3883481251,1315661075,92,{en="Mother of Bandits",fr="Mère des bandits",de="Mutter Banditen",})
lct:RT(3074602708,false,92,{en="ThatCupcakeParse",})
lct:RT(3900843181,false,92,{en="The Law",})lct:RT(3900843181,656328164,92,{en="The Law",})
lct:RT(4173094023,false,92,{en="The Dying Star",fr="The Dying Star",de="Der Sterbende Stern",})
lct:RT(3918082306,1017899260,true,{en="Shadow of the West",fr="L'ombre de L'ouest",de="Schatten des Westens",})
lct:RT(565393473,false,92,{en="A Bag of Tea",fr="Sachet de Thé",de="eine Tüte Tee",})
lct:RT(869020,false,705,{en="Nukeror ",fr="Nukeror",de="Nukeror",})
lct:RT(3321147144,3541509713,92,{en="Javelin of Stendarr",fr="Javelot von Stendarr",de="Wurfspeer von Stendarr",})
lct:RT(4244617125,false,92,{en="The Twice-Told Legend",fr="La Légende à Deux Reprises",de="Die Zweimalige Legende",})
lct:RT(1493993355,3382123468,92,{en="the Savior of Daggerfall",fr="le sauveur de Daguefil",de="der Erlöser des Dolchfalls",})
lct:RT(3251540786,false,92,{en="Flame Lord",fr="Flame Lord",de="Flame Lord",})lct:RT(3251540786,2002721095,705,{en="Dragonleaper",fr="Dragonleaper",de="Dragonleaper",})
lct:RT(400266253,false,92,{en="Queen of Roses",fr="Reine des roses",de="Königin der Rosen",})lct:RT(400266253,1481202516,51,{en="HeartBreaker",fr="Briseur de coeur",de="Herzensbrecher",})
lct:RT(1374693540,1095349348,true,{en="Avatar of Shor",fr="Avatar of Shor",de="Avatar of Shor",})
lct:RT(4148559867,false,true,{en="Danik 'teach me' PROK",fr="Danik 'teach me' PROK",de="Danik 'teach me' PROK",})
lct:RT(1613231931,false,92,{en="Legendary Knight",fr="Chevalier Légendaire",de="Legendärer Ritter",})lct:RT(1613231931,3097208535,51,{en="Lord of the Hurricane",fr="Seigneur de L'Ouragan",de="Herr des Hurrikans",})
lct:RT(2301445127,false,1838,{en="Flying Squirrel",})lct:RT(2301445127,3495986748,1810,{en="Ninja Squirrel",})
lct:RT(2733327571,false,92,{en="The Merciless Dark Shadow",})
lct:RT(3169614001,1627090513,92,{en="Skooma Lord",})
lct:RT(4258323732,false,92,{en="Tchunai",fr="Tchunai",de="Tchunai",})lct:RT(4258323732,3515111219,51,{en="Pontiff",fr="Pontife",de="Pontifex",})
lct:RT(738364324,false,1391,{en="Meow Meow Tank",fr="Meow Meow Tank",de="Meow Meow Tank",})lct:RT(738364324,3987934248,1391,{en="Meow Meow Tank",fr="Meow Meow Tank",de="Meow Meow Tank",})
lct:RT(998240473,false,92,{en="The Bloody Shadow",fr="L'Ombre Sanglante",de="Der Blutige Schatten",})
lct:RT(2966235117,false,92,{en="Trainer",fr="Entraîneur",de="Der Ausbilder",})
lct:RT(647316119,false,92,{en="Clever Boy",fr="Garçon Intelligent",de="Schlauer Junge",})
lct:RT(2929427093,false,628,{en="The Light of Dawn",fr="Lumière de L'Aube",de="Morgendämmerung",})lct:RT(2929427093,1621733346,true,{en="Light of Dawn",fr="Lumière de Laube",de="Morgendämmerung",})
lct:RT(1748718792,false,92,{en="Special Snowflake",fr="Special Snowflake",de="Special Snowflake",})
lct:RT(1521429983,false,92,{en="The One and Only",fr="Le Seul et Unique",de="Der Einzig Wahre",})lct:RT(1521429983,1607376665,1810,{en="Razor Sharp",fr="Lame de Rasoir",de="Gestochen Scharf",})
lct:RT(1196984281,false,92,{en="The Awkward Turtle",fr="Tortue Maladroite",de="Unbeholfene Schildkröte",})
lct:RT(1714783862,1205993075,92,{en="Mudcrab Destroyer",})
lct:RT(962898823,false,92,{en="The Mischievous",fr="Le Malicieux",de="Die Schelmischen",})
lct:RT(553097444,3049246149,92,{en="Hopebringer",})
lct:RT(3305610464,false,92,{en="Blood Warlock",fr="Mage de Sang",de="Blutmagier",})
lct:RT(4163903184,false,92,{en="Nuclear Throne",})
lct:RT(2736560286,false,92,{en="Bright Sun",})lct:RT(2736560286,4237557027,92,{en="Bright Sun",fr="Soleil brillant",de="Helle Sonne",})
lct:RT(3592663263,false,51,{en="Dat Boi Kobra",fr="Dat Boi Kobra",de="Dat Boi Kobra",})
lct:RT(1491195782,false,1330,{en="Boneman Conjurer",fr="Boneman Conjurer",de="Boneman Conjurer",})
lct:RT(467409067,false,92,{en="The Undying Savior ",})
lct:RT(2930545375,false,92,{en="Undying Silver",fr="Argent Immortel",de="Unsterbliches Silber",})
lct:RT(3617475312,279806614,1330,{en="Inquisitor",fr="Inquisitrice",de="Inquisitor",})
lct:RT(3006396456,false,true,{en="The One Who Loves Argonians",fr="Celui qui Aime Argonians",de=" Einer der Liebt Argonians",})
lct:RT(2803118975,false,92,{en="The Arbiter",fr="L'Arbitre",de="Der Schiedsrichter",})
lct:RT(1411915213,false,92,{en="Vegan BTW",fr="Vegan BTW",de="Vegan BTW",})
lct:RT(2961786947,false,92,{en="The Eternal Knight",fr="L'Aternel Chevalier",de="Der Ewige Ritter",})
lct:RT(1376131009,false,92,{en="Preliator",fr="Preliator",de="Preliator",})
lct:RT(543615770,false,92,{en="Kage",fr="L'Ombre",de="Schatten",})lct:RT(543615770,562930931,1330,{en="Hikage",fr="Ombre de Feu",de="Feuerschatten",})
lct:RT(2012291598,false,1330,{en="God of The Arena",fr="Le Conquerant Implacable",})
lct:RT(1555668529,false,92,{en="General of The Army",fr="Général de l'Armée",de="General der Armee",})
lct:RT(3322797540,false,92,{en="Blackwater Overseer",fr="Blackwater Surveillant",de="Blackwater Aufseher",})lct:RT(3322797540,2855390806,1330,{en="The Dragon of Valenwood",})
lct:RT(43881250,false,92,{en="Kra'gh Destroyer",fr="Kra'gh Destructeur",de="Kra'gh Zerstörer",})
lct:RT(2688043370,false,92,{en="the Chaotic-good Samaritan",})
lct:RT(2710756286,769305140,628,{en="Tiniest Tank in Tamriel",})
lct:RT(1560809148,false,628,{en="The Stranger",fr="L’Étranger",de="Der Fremde",})
lct:RT(4205939985,2207352609,92,{en="Man of Bears",de="Man of Bears",})
lct:RT(1533296560,false,92,{en="Queen of Wrath",fr="Reine de la Colère",de="Königin des Zorns",})
lct:RT(3032597911,false,92,{en="Conquest of Tamriel Founder",fr="Conquest of Tamriel Founder",de="Conquest of Tamriel Founder",})lct:RT(3032597911,4157141714,51,{en="Conquest of Tamriel Founder",fr="Conquest of Tamriel Founder",de="Conquest of Tamriel Founder",})
lct:RT(1409655317,false,92,{en="Gravity Crusher",})
lct:RT(3419971260,false,92,{en="Master of Wipes",fr="Maître des Lingettes",de="Meister der Tücher",})
lct:RT(3290209100,false,1330,{en="Immortal Pantera",fr="Immortal Pantera",de="Immortal Pantera",})
lct:RT(1480157670,false,92,{en="Salt Miner",fr="Mineurs de Sel",de="Salzbergarbeiter",})lct:RT(1480157670,1705260929,92,{en="Biggest Zergling",fr="Plus Gros Zergling",de="Größter Zergling",})
lct:RT(368935633,false,92,{en="The Absolutely Fabulous",fr="Le Absolument Fabuleux",de="Der Absolut Fabulöse",})
lct:RT(1507333836,3474749068,2079,{en="Stormhaven Champion ",fr="Stormhaven Champion ",de="Stormhaven-Meister",})
lct:RT(3844654364,false,92,{en="Whats up Whats up",})
lct:RT(3758872979,false,92,{en="Astronomer",fr="Astronomer",de="Astronomer",})
lct:RT(2569074171,false,92,{en="Dead Game",})lct:RT(2569074171,4217760066,705,{en="Shield Stacker",})
lct:RT(3643932999,4022954265,92,{en="Rogue Shadow",})
lct:RT(227397729,false,92,{en="Accident's Art",fr="Art de l'Accident",de="Unfall Kunst",})
lct:RT(1982274374,false,92,{en="Achievement Hunter",})
lct:RT(336163399,3749086479,92,{en="WHY YOU ALWAYS LYIN",fr=" POURQUOI TOUJOURS LYIN",de="WARUM SIE IMMER LYIN",})
lct:RT(2159679822,3408723977,92,{en="Titan Slayer",fr="Titan Slayer",de="Titan Slayer",})
lct:RT(3869133289,false,628,{en="Goatherder",fr="Pâtre",})lct:RT(3869133289,2359395542,628,{en="Where are you?",fr="Où es-tu?",})
lct:RT(2868002523,false,92,{en="Golden Guardian of Shor",fr="Gardien d'or de Shor",de="Goldener Wächter von Shor",})
lct:RT(2980488211,false,92,{en="Leonessa Suprema",fr="Lionne suprême",de="Oberste Löwin",})
lct:RT(293948390,false,92,{en="The Aberrant Finder of Daisies",fr="The Aberrant Finder of Daisies",de="The Aberrant Finder of Daisies",})
lct:RT(2880292413,false,92,{en="Fallout Boy",fr="Fallout Boy",de="Fallout Boy",})lct:RT(2880292413,1646548948,92,{en="Fallout Boy",fr="Fallout Boy",de="Fallout Boy",})
lct:RT(1313177490,false,92,{en="The Invincible",fr="L'invincible",})
lct:RT(3056781926,false,92,{en="Cadwell's Platinum Member",})
lct:RT(1161907310,false,1391,{en="Tinker",})
lct:RT(1222365137,3142621338,92,{en="Sanguinaire",fr="Sanguinaire",de="Sanguinaire",})
lct:RT(2012667774,575033278,92,{en="Sanguiness",fr="Sanguiness",de="Sanguiness",})
lct:RT(4123739079,false,92,{en="The Mane",})
lct:RT(868608183,1420896692,51,{en="Osthato Chetowä",fr="Le Sage En Deuil",de="Der Trauer Weise",})
lct:RT(2553360053,false,2079,{en="The Panic Mage",})lct:RT(2553360053,794632023,2079,{en="The Panic Wizard",})
lct:RT(89193783,false,92,{en="Darkness",fr="Ténèbres",de="Dunkelheit",})
lct:RT(3436166594,1922328293,628,{en="Mother of Vampires",fr="Mère de Vampires",de="Mutter von Vampiren",})
lct:RT(3204312368,false,92,{en="Grand Coffee Lord",})
lct:RT(606118324,false,true,{en="Living Legend",fr="Légende Vivante",de="Lebende Legende",})
lct:RT(954221767,false,true,{en="Seeker of Forbidden Knowledge",fr="Chercheurs de Savoir Interdit",de="Sucher des Verbotenen Wissens",})lct:RT(954221767,530591113,true,{en="Storyteller from Ashlands",fr="Le Conteur des Terres-Cendres",de="Märchenerzähler aus Aschland",})
lct:RT(2664002978,false,92,{en="Master Ninja",})
lct:RT(1939977988,false,92,{en="Lunar Champion",})
lct:RT(1228265292,false,92,{en="Bad Bard Aficionado",fr="Passionné de Mauvais Bardes ",})
lct:RT(2655948113,478375269,1330,{en="Skeevatons-Destroyer",})
lct:RT(1324202907,false,92,{en="Of the Red Sands",})lct:RT(1324202907,3248849783,92,{en="Of the Red Sands",})
lct:RT(1616494166,false,92,{en="The Red Witch",})lct:RT(1616494166,2000978796,92,{en="The Red Witch",})
lct:RT(3490435460,false,92,{en="Battleground Conquerer",})lct:RT(3490435460,2626432313,92,{en="Master Of Ice",})
lct:RT(4025643251,false,92,{en="Warrior of Sunlight",de="Krieger der Sonnenlicht",})
lct:RT(876757338,false,92,{en="Enfolder Of Darkness",})
lct:RT(978363252,false,2136,{en="The Sixth Imperial Legion",})lct:RT(978363252,1979309473,92,{en="The Sixth Imperial Legion",})
lct:RT(3337363968,false,92,{en="Triple Agent",})
lct:RT(3303600301,false,92,{en="Master of None",fr="Maitre de Rien",de="Stehts Bemühter",})
lct:RT(463565339,false,92,{en="Turtle Witch",fr="La Sorcière Tortue",de="Schildkrötenhexe",})
lct:RT(2027559765,false,51,{en="Cadwell's Kitchen Help",fr="Aide de cuisine de Cadwell",de="Cadwells's Küchenhilfe",})
lct:RT(2725350425,false,1391,{en="Margrave of Aspern",})
lct:RT(2273011628,false,92,{en="Grand Enchantress",fr="Grande Enchanteresse",de="Großverzauberin",})
lct:RT(2563341608,1087919345,51,{en="Humidifier",})
lct:RT(2184782117,1188715368,92,{en="Longin",fr="Longin",de="Longin",})
lct:RT(4047084960,false,92,{en="Star Lord",})
lct:RT(3245915300,false,92,{en="Master of the Stoned Fist",fr="Maitre de la Stoned Fist",de="Meister des Stoned Fist",})
lct:RT(345493239,false,92,{en="The One and Only",fr="Le Seul et Unique",de=" Der Einzig Wahre",})
lct:RT(356919767,false,92,{en="Metal Warrior",fr="Metal Warrior",de="Metal Warrior",})lct:RT(356919767,3260564010,92,{en="Stone Keeper",fr="Gardien de Pierre",de="Steinwächter",})
lct:RT(958730344,false,1810,{en="the Nihilist",fr="le Nihiliste",de="die Nihilistin",})
lct:RT(1055829041,3783356330,92,{en="Vaermina's Scamp",})
lct:RT(406247130,false,92,{en="Hellsing",fr="Hellsing",})
lct:RT(4032446867,false,92,{en="Crow of Judgment",fr="Corbeau de Jugement",de="Krähe des Gerichts",})
lct:RT(3908965003,false,1391,{en="Dragon Destroyer",fr="Dévastateur des Dragons",de="Vernichter der Drachen",})
lct:RT(3830295714,false,92,{en="Bounty Hunter",fr=" Chasseur de Primes",de="Kopfgeldjäger",})lct:RT(3830295714,2739851226,92,{en="Bounty Hunter",fr="Chasseur de Primes",de="Kopfgeldjäger",})
lct:RT(798732954,3058436596,92,{en="The plague of Attila",fr="Le fléau d'Attila",de="Die Pest von Attila",})
lct:RT(1901867816,4011260989,92,{en="Godfather",})
lct:RT(1405090802,false,92,{en="King of Wrath",})
lct:RT(1183658927,false,92,{en="The Pacifist",fr=" Le Pacifiste",de="Der Pazifist",})lct:RT(1183658927,3440415553,92,{en="The Runner",fr="Le Coureur",de="Der Läufer",})
lct:RT(2175566571,false,92,{en="Emperor Hel Ra Citadel",fr="Empereur Hel Ra la Citadelle",de="Kaiser Hel Ra Zitadelle",})lct:RT(2175566571,3175093035,92,{en="Emperor Hel Ra Citadel",fr="Empereur Hel Ra de Citadelle",de="Kaiser Hel Ra der Zitadelle",})
lct:RT(2083290332,3210546897,1330,{en="Wizard Lizard",})
lct:RT(3862807513,3783356330,628,{en="Disgraced Hortator",fr="Le Bafoué Hortator",de="Der Beschämter Hortator",})
lct:RT(4153392899,false,92,{en="Avocado Heart",})lct:RT(4153392899,2739851226,1391,{en="Dromathra Avocado",})
lct:RT(2954123608,false,705,{en="Oathkeeper",fr=" Guardián de promesas",de="Eidwahrer",})
lct:RT(503303981,4011260989,51,{en="Lone Wanderer",fr="Nomade Solitaire",de="Einsamer Umherziehender",})
lct:RT(2862503551,3440415553,92,{en="Flame Incarnate",fr="Flame Incarnate",de="Flame Incarnate",})
lct:RT(4069611208,false,92,{en="Skooma Addict",})lct:RT(4069611208,3175093035,92,{en="Skooma Addict",})
lct:RT(3855693150,3572326225,92,{en="The Hoarfrost Hunter",fr="Le chasseur de givre",})
lct:RT(3215497473,false,92,{en="Shadow Master",})lct:RT(3215497473,2145654398,92,{en="Shadow Master",})
lct:RT(2029483333,false,628,{en="CEO of Constitutional Warriors",})
lct:RT(1322074685,false,92,{en="Warrior of Darkness",fr="Warrior of Darkness",de="Warrior of Darkness",})
lct:RT(1708071790,false,92,{en="I Heart Unicorns",})
lct:RT(3732411662,2272798337,92,{en="Demi-God",})
lct:RT(2303175925,2873087251,92,{en="Madame",fr="Madame",de="Frau",})
lct:RT(3550666866,false,92,{en="The Goatlike",})lct:RT(3550666866,99471649,92,{en="Durin's Bane",})
lct:RT(62645408,false,2467,{en="Slayer of False Gods",})
lct:RT(329996214,false,92,{en="Skipmaster",})
lct:RT(2760823504,3673957442,92,{en="Godplar",fr="Dieuplar",de="Gottplar",})
lct:RT(1026540765,false,92,{en="DPS like ShuiWang",})
lct:RT(2097261633,false,628,{en="Young Scrolls",fr="Young Scrolls",de="Young Scrolls",})
lct:RT(3577146438,false,494,{en="Flayer of Fishes",})lct:RT(3577146438,3490075530,494,{en="Flayer of Fishes",})
lct:RT(1523827001,false,92,{en="General of the Imperial Legion",fr="Général de la Légion impériale",de="General der imperialen Legion",})
lct:RT(4041455212,false,92,{en="King Of Lizards",fr="Roi des Lézards",de="König der Eidechsen",})
lct:RT(2569105891,false,true,{en="Chief Addon Borker",})
lct:RT(4214596307,false,1330,{en="Maelstrom Tormentor",})lct:RT(4214596307,2631338109,92,{en="Tanking Walls Well",})
lct:RT(178543469,false,92,{en="Champion of Stendarr",})lct:RT(178543469,2931762339,51,{en="Arch-Curate",})
lct:RT(873298121,false,92,{en="The Bear",})lct:RT(873298121,2275034664,92,{en="The Bear",})
lct:RT(3077479002,false,92,{en="Camel Whisperer",fr="l'oreille des chameaux",de="Camelflüsterer",})
lct:RT(359275554,false,1838,{en="Mancos Tormentor",})lct:RT(359275554,4214757878,2139,{en="Manco Heart",})
lct:RT(2608950231,false,92,{en="Flaming Rascal",fr="Flaming Coquin",de="Flammender Schurke",})lct:RT(2608950231,3114015609,92,{en="Flaming Rascal",fr="Flaming Coquin",de="Flammender Schurke",})
lct:RT(2830441086,3311190470,92,{en="Godsent",})
lct:RT(2337952014,false,92,{en="Bad Girl",})
lct:RT(2269516296,false,92,{en="The Indeterminate",fr="L'indéterminé",de="Das Unbestimmte",})
lct:RT(4143086157,2511439052,628,{en="Grand Adjudicator",fr="Juge Suprême",de="Hoher Richter",})
lct:RT(1134580626,false,494,{en="Sleeping Dragon",})
lct:RT(3015558745,false,true,{en="Imperial Grand Field Marshal",fr="Grand Maréchal Impérial",de="Imperialer Großfeldmarschall",})
lct:RT(943250108,false,92,{en="Professional Pleb",fr="Professional Pleb",de="Professional Pleb",})
lct:RT(2641928740,false,92,{en="Architect",})lct:RT(2641928740,4148511204,51,{en="Eternal",})
lct:RT(2660935563,false,92,{en="Dark Emerald",fr="Emeraude Noire",})
lct:RT(3395979201,false,92,{en="Grand Sugar Daddy",})lct:RT(3395979201,1413032936,92,{en="Grand Sugar Daddy",})
lct:RT(984052525,false,true,{en="|cFF33FFDrama Queen|r",fr="|cFF33FFDrama Queen|r",de="|cFF33FFDrama Queen|r",})
lct:RT(1262783318,false,92,{en="Master of the Stoned Fist",fr="maître du stoned poing",de="Meister der stoned Fist",})
lct:RT(1724873301,3854315966,92,{en="The Crimson King",fr="Le roi écarlate",})
lct:RT(1650789143,false,92,{en="Tax Collector",fr="Receveur des Impôts",de="Steuereintreiber",})
lct:RT(3533593082,false,92,{en="Fortune favors the brave",fr="Fortune favors the brave",de="Fortune favors the brave",})lct:RT(3533593082,3761384242,92,{en="Fortune favors the brave",fr="Fortune favors the brave",de="Fortune favors the brave",})
lct:RT(1423373856,false,92,{en="Unlimited By Metagame",fr="Unlimited By Metagame",de="Unlimited By Metagame",})
lct:RT(914824185,false,92,{en="Very Dangerous",de="Sehr Gefährlich",})
lct:RT(1391848216,false,true,{en="Sneaking Carr",})
lct:RT(65717617,false,92,{en="Demon",fr="Demon",de="Demon",})
lct:RT(1278749862,2668260047,2079,{en="Teamaker from Woodland",fr=" Teamaker de Woodland",de=" Teamaker aus Woodland",})
lct:RT(713456765,1029352311,92,{en="Onee Chan",})
lct:RT(2916871193,3401103424,92,{en="gamers-community.net Founder",fr="gamers-community.net Fondateur",de="gamers-community.net Gründer",})
lct:RT(3491497586,false,true,{en="Camel Smuggler",})
lct:RT(2245455069,856468944,92,{en="Mother of Dragons",fr="Mère des Dragons",de="Mutter der Drachen",})
lct:RT(3355625020,false,92,{en="Friendly Neighbourhood Healer",})
lct:RT(2203551725,false,92,{en="Fungal grotto 1 conqueror",fr="conquérant  de la champi",})
lct:RT(2893563397,false,92,{en="Ghost Sea Pirate",fr=" Pirate de la Mer Fantôme",de=" Pirat des Geistermeeres",})lct:RT(2893563397,4229598108,92,{en="Never Dead",fr="Jamais Mort",de="Niemals Tot",})
lct:RT(151045828,false,92,{en="Spams All Skills",})lct:RT(151045828,1846953924,1810,{en="Deeps for Dollars",})
lct:RT(935575748,false,92,{en="Starving Artist",fr="Artiste Affamé",de=" Verhungernder Künstler",})
lct:RT(3521725168,false,92,{en="The Endurer",})
lct:RT(1889871608,false,92,{en="Kinlord",fr="Kinlord",de="Kinlord",})lct:RT(1889871608,1554932340,628,{en="Justiciar",fr="Justiciar",de="Justiciar",})
lct:RT(4022921457,false,92,{en="Midget Healer",fr="Guérisseur Nain",de="Zwergheiler",})
lct:RT(3540120284,false,1810,{en="Flame of Akatosh",})lct:RT(3540120284,2935056129,1810,{en="Flame of Akatosh",})
lct:RT(2618202197,2332277357,92,{en="Queen In The North",})
lct:RT(1965679628,887809184,92,{en="Daughter Of Meridia",fr="Daughter Of Meridia",de="Daughter Of Meridia",})
lct:RT(967119722,false,92,{en="The Sapient",fr="La Sage",de="Die Weise",})
lct:RT(3127137285,1587566057,92,{en="The Nerevarine",fr="La Nerevarine",de="Der Nerevarine",})
lct:RT(2328936267,3758011349,92,{en="Master Assassin",fr="Maître Assassin",de=" Meister Attentäter",})
lct:RT(3932146712,false,92,{en="Bugz Bunny",})lct:RT(3932146712,515674925,92,{en="The Real Bhop Legend",})
lct:RT(963571677,2231421979,1330,{en="Poseidon",fr="Poseidon",de="Poseidon",})
lct:RT(1907076472,false,92,{en="Golden One",})lct:RT(1907076472,2963348866,92,{en="Golden One",})
lct:RT(2383562118,false,92,{en="Kinlord",fr="Kinlord",de="Kinlord",})
lct:RT(2544039907,false,92,{en="Scrubgari",})lct:RT(2544039907,4016167826,92,{en="The Liberator",})
lct:RT(3421028733,false,92,{en="Follower of M'aiq the Liar",})
lct:RT(1627930508,3494351202,92,{en="I can't heal through stupid",})
lct:RT(2051331670,2705012021,494,{en="Fake-Taxi Driver",fr="Fake-Taxi Driver",de="Fake-Taxi Driver",})
lct:RT(3254762646,false,92,{en="Pesky Hornet",fr="Frelon Embêtant",de="Lästige Hornisse",})
lct:RT(2424975577,false,92,{en="skulls for the skull throne",fr="crânes pour le trône du crâne",de="Schädel für den Schädeltron",})lct:RT(2424975577,3700429125,92,{en="skulls for the skull throne",fr="crânes pour le trône du crâne",de="Schädel für den Schädeltron",})
lct:RT(2050829764,false,92,{en="Dark Flaminika",fr="Flaminika Noire",de="Dunkle Flaminika",})
lct:RT(49631428,27371127,92,{en="Italian Dong",fr="Italian Dong",de="Italian Dong",})
lct:RT(3995154142,2506084000,51,{en="Eternal Champion",fr="Champion Éternel",de="Ewiger Champion",})
lct:RT(3178648388,false,92,{en="The Nine-Breaker",fr="Le Neuf-Breaker",de="Der Neunbrecher",})
lct:RT(3001208688,false,628,{en="The Blame Guy",fr="Le Mec Responsable",de="Er Schuldige",})
lct:RT(1283539786,2307703999,92,{en="Glass Tank",})
lct:RT(2489615138,false,92,{en="Packleader",de="Rudelführer",})lct:RT(2489615138,841543750,92,{en="Packleader",de="Rudelführer",})
lct:RT(63370110,false,92,{en="Troll's Uncle",fr="Trolles Oncle",de="Trolls Onkel",})
lct:RT(353832012,false,92,{en="The Wind in the Willows",fr="La Vent dans les Saules",de="Der Wind in den Weiden",})
lct:RT(610259872,false,51,{en="Snoooooooooz",})
lct:RT(1824232300,false,92,{en="Dwemer Enthusiast ",fr="Enthousiaste Dwemer",de="Dwemer Enthusiast",})
lct:RT(556930264,2524345496,92,{en="Master-At-Arms",})
lct:RT(3495556974,false,1391,{en="Dum-m'athra Lizud",fr="Dum-m'Athra Lizud",de="Dum-m'Athra Lizud",})
lct:RT(3457805212,false,92,{en="Healer",de="Heiler",})
lct:RT(2851184981,143807975,628,{en="Aldmeri Dominion",fr="Aldmeri Dominion",de="Aldmeri Dominion",})
lct:RT(2224897098,false,92,{en="Meaxy d'Arkadium",fr="Meaxy d'Arkadium",de="Meaxy d'Arkadium",})lct:RT(2224897098,4186238090,92,{en="Meaxy d'Arkadium",fr="Meaxy d'Arkadium",de="Meaxy d'Arkadium",})
lct:RT(1091751491,false,92,{en="The Hungry",fr="Les Affamés",de="Der Hungrige",})
lct:RT(3846634842,1289522990,51,{en="Tower's Might",fr="La puissance de la tour",de="Die Kraft des Turms",})
lct:RT(370381869,false,92,{en="Battlemagus",fr="Magie de combat",})
lct:RT(2404289493,false,92,{en="The Benevolent",})
lct:RT(2082549644,false,92,{en="Clockwork Oblivion Adept",fr="L'adepte de l'Oubli Mécanique",de="Adept der Uhrwerkvergessenheit",})
lct:RT(3267768945,3953457466,92,{en="Golden Witch",})
lct:RT(3692844061,1983768019,92,{en="Angel-Emperor of Science",fr="Ange-Empereur des Sciences",de="Engel-Kaiser der Wissenschaft",})
lct:RT(173415841,3805750726,1391,{en="Super Potato",})
lct:RT(4272678963,false,true,{en="Sneaking Carr",})
lct:RT(298775252,false,92,{en="The Unyielding One",fr="L'inébranlable",de="Der Unnachgiebige",})
lct:RT(608125318,false,92,{en="Master Chef",fr="Chef Cuisinier",de="Meisterkoch",})lct:RT(608125318,2569466310,51,{en="Orc Chef",fr="Chef Orc",de="Ork Koch",})
lct:RT(1491516552,53882021,92,{en="Empress",fr="Impératrice",de="Kaiserin",})
lct:RT(3296454518,false,92,{en="Crow friend",fr="L'ami des Corneilles",de="Krähenfreund",})
lct:RT(2490301228,false,92,{en="The Frightful",fr="L'effroyable",de="Der Schreckliche",})
lct:RT(3940000096,4022329632,628,{en="Relentless Raider",fr="Raider implacable",de="Unerbittlicher Räuber",})
lct:RT(1320854092,false,92,{en="The Baker",})
lct:RT(1340280976,2205997100,1330,{en="Tempest of Wayrest",})
lct:RT(4146633540,false,92,{en="Patriarch of House Vile",})
lct:RT(3361749433,207335149,true,{en="The Burning Flower",fr="La Fleur Brûlante",de="Die Brennende Blume",})
lct:RT(2280898987,475587336,92,{en="The Contrary",fr="Le contraire",de=" Das Gegenteil",})
lct:RT(2075028506,294672661,1391,{en="Oh Lawd He Comin'",})
lct:RT(3224110116,2002775267,1391,{en="Clever Girl",fr="Fille Intelligente",de="Kluges Mädchen",})
lct:RT(1743165394,false,92,{en="Great Architect",fr="Grand Architecte",de="Großartiger Architekt",})
lct:RT(939706819,false,92,{en="The Gypsy Goat",})
lct:RT(596311246,false,92,{en="The Lord of Light",fr="Le seigneur de la lumière",de="Der Herr des Lichts",})lct:RT(596311246,2068190245,51,{en="Requiem of R'hllor",fr=" Requiem de R'hllor",de=" Requiem von R'hllor",})
lct:RT(2263168182,false,92,{en="Dead Title",})
lct:RT(3241490901,false,92,{en="Bringer of Wipe",})
lct:RT(2487631548,false,92,{en="ERP Queen of the Rift",fr="La Reine d'ERP de la Brèche ",de="Die Königin des ERP von Rift",})
lct:RT(91759769,false,92,{en="Supremidade",fr="Supremidade",de="Supremidade",})
lct:RT(3100924539,false,92,{en="|c26d2edMaster of the wilds|r",})
lct:RT(3813613722,false,92,{en="Legendary Tick Leecher",fr="Legendaire Tick Leecher",de="Legendärer Tick Leecher",})
lct:RT(3511976695,false,51,{en="Sahib-Kiran",fr="Sahib-Kiran",de="Sahib-Kiran",})
lct:RT(584683784,false,92,{en="Rice Farmer",fr="Riziculteur",de="Reisfeldbauer",})
lct:RT(1990040950,false,92,{en="Sith",fr="Sith",de="Sith",})lct:RT(1990040950,346894472,494,{en="Mass Murderer",fr="Le meurtrier de masse",de="Massenmörder",})
lct:RT(3181361115,false,92,{en="Swamp Heart",fr="Сoeur de Marais",de="Sumpfherz",})lct:RT(3181361115,4091313387,2079,{en="Voice from the Swamp",})
lct:RT(3378965337,2044881963,true,{en="|cC20600Sword Dancer|r",})
lct:RT(1015788549,false,2079,{en="Dragon King",})lct:RT(1015788549,2241137664,2079,{en="Dragon Lord",})
lct:RT(3960021287,2998339043,92,{en="Goatslayer",})
lct:RT(1198087126,2197613590,628,{en="The Last Nightblade",de="Die letzte Nachtklinge",})
lct:RT(1803502933,false,92,{en="Ring of the Moons",fr="Anneau des Lunes",de="Ring der Monde",})
lct:RT(3487844604,false,92,{en="Evil Incarnate",fr="Mal incarné",de=" Das Böse inkarnieren",})lct:RT(3487844604,1913372510,true,{en="Footpad",fr="Footpad",de="Fußpolster",})
lct:RT(422321056,false,92,{en="Raid Teacher",fr="Raid professeur",de="Raid Lehrer",})
lct:RT(4125764835,false,92,{en="|cff0a0aGlorious Leader|r",fr="|cff0a0aChef glorieux|r",de="|cff0a0aHerrlicher Anführer|r",})
lct:RT(549597314,false,1330,{en="Completely Quackers",fr="Complètement Quackers",de="Komplett Quackers",})lct:RT(549597314,3161851025,1330,{en="The Quack Doctor",fr="Le Docteur Quack",de="Der Quacksalber",})
lct:RT(198006013,false,628,{en="Patissiere",fr="Pâtissière",de="Teig",})
lct:RT(425998998,false,92,{en="Night Walker",fr="Night Walker",de="Nachtwandler",})lct:RT(425998998,2372780267,51,{en="Divine Deleter",fr="Deleter Divin",de="Divine Deleter",})
lct:RT(1992273336,false,true,{en="Gentle Like Moonlight",})
lct:RT(492437800,false,92,{en="Cat Whisperer",fr="Chat Chuchoteur",de="Katzenflüsterer",})
lct:RT(883529958,false,92,{en="|c57fff1Eyasluna|r",de="Eyasluna",})lct:RT(883529958,2125993677,92,{en="|c57fff1Eyasluna|r",})
lct:RT(1106107739,false,92,{en="Guildmaster of Oberon",fr="Chef de guilde Oberon",de="Gildenmeister von Oberon",})
lct:RT(3186726290,false,1330,{en="|cffd700Warrior of Light|r",fr="|cffd700Guerrier du Feu|r",de="|cffd700Krieger des Lichts|r",})
lct:RT(3271473921,881752467,628,{en="Mage Butcher",fr="Mage boucher",de="Magierschlächterin",})
lct:RT(4261585000,2205997100,1330,{en="The Tempest",fr="La Tempête",de=" Der Sturm",})
lct:RT(1238557531,3205972763,92,{en="Bear-Friend",fr="Bear-Friend",de="Bärenfreund",})
lct:RT(3783722333,false,92,{en="Actual Trash Bin Human",})
lct:RT(383659839,false,92,{en="The Warrior's Code",fr=" Le code du guerrier",de="Der Kodex des Kriegers",})
lct:RT(2881929103,3474224030,92,{en="Unterterror",fr="Unterterror",de="Unterterror",})
lct:RT(81378792,false,92,{en="Scarab Lord",fr="Scarab Lord",})
lct:RT(1139715726,894016924,92,{en="Prince of Crows",fr="Prince des Corbeaux",de="Prinz der Krähen",})
lct:RT(893306158,false,92,{en="Kore ga requiem da",})
lct:RT(1488161712,false,92,{en="Dead Game",})lct:RT(1488161712,4217760066,705,{en="Hysteria",})
lct:RT(2422119465,false,1810,{en="Fire Dragon King",})lct:RT(2422119465,2277120804,1810,{en="Fire Dragon King",})
lct:RT(1232387807,1674580438,92,{en="Sensei",})
lct:RT(3598113073,false,92,{en="Dragon's Treasure ",fr="Trésor des Dragons",de="Des Drachens Schatz",})
lct:RT(534535578,false,92,{en="Grand Armiger",fr="Grand Armiger",de="Großarmiger",})
lct:RT(396284474,1576580691,51,{en="Fallen star",})
lct:RT(3349219570,false,92,{en="Zerglord-Mangler",})
lct:RT(1158790674,false,92,{en="Cuendillar",fr="Cuendillar",de="Cuendillar",})
lct:RT(1163689919,false,92,{en="The Elder Council",fr="Le Сonseil Des Aînés",de="Der Ältestenrat",})
lct:RT(479297755,2607875565,92,{en="The Wall",fr="Le Mur",de="Die Wand",})
lct:RT(2268651163,2772142394,92,{en="Amphibians Curse",fr="La malédiction des amphibiens",de="Amphibien Fluch",})
lct:RT(3967789623,false,92,{en="Sandbag",fr="Sandbag",de="Sandbag",})lct:RT(3967789623,1920620254,51,{en="Smooth-Brained",fr="Smooth-Brained",de="Smooth-Brained",})
lct:RT(2487171937,false,92,{en="Artisan",fr="Artisane",de="Handwerkerin",})lct:RT(2487171937,733710972,1391,{en="Forgemaster",fr="Forgemaster",de="Schmiedemeister",})
lct:RT(468589689,false,92,{en="Kinlord",})lct:RT(468589689,2005545254,51,{en="Necromage",fr="Necromage",de="Totenmagier",})
lct:RT(3090883268,false,92,{en="Psychonaut",fr="Psychonaut",de="Psychonaut",})
lct:RT(384990765,false,92,{en="The Nothern Storm",fr="La tempête du Nord",de="Der nördliche Sturm",})
lct:RT(249180276,554773102,628,{en="Hand of the Tribunal",})
lct:RT(3094618315,false,92,{en="Seafarer",})lct:RT(3094618315,3633630442,true,{en="Admiral",})
lct:RT(392991350,false,628,{en="|cFF0080The Fluffy Warrior|r",})
lct:RT(1089672112,false,628,{en="|cEFFF00Torval Skooma Dealer|r",fr="|cEFFF00Torval Skooma Dealer|r",de="|cEFFF00Torval Skooma Dealer|r",})
lct:RT(661397542,false,92,{en="Sin of Greed",fr="Péché de cupidité",de="Sünde der Gier",})
lct:RT(542218471,false,51,{en="Elder Vampire",fr="Elder Vampire",de="Elder Vampire",})
lct:RT(2091287832,false,92,{en="|C661919MarkedOne|r",fr="|C661919MarkedOne|r",de="|C661919MarkedOne|r",})lct:RT(2091287832,2293332014,628,{en="|C661919Mistery|r",fr="|C661919Mistery|r",de="|C661919Mistery|r",})
lct:RT(3394725117,2576804759,92,{en="Best Bomblade EU",})
lct:RT(3666218718,353685125,1391,{en="Fluffy Khajiit Healer",fr="Moelleux Khajiit Guérisseur ",de="Flauschiger Khajiit Heiler",})
lct:RT(4043014545,false,92,{en="Pocket Healer",fr="Guérisseur de poche",de="Taschenheiler",})
lct:RT(1629007230,false,92,{en="Mistress of Sorcery",fr="Maîtresse de la Sorcellerie",})
lct:RT(423699263,false,92,{en="Fave Knows",})
lct:RT(1851684295,false,92,{en="|c42B9FFPenguin Emp-error|r",fr="|c42B9FFPenguin Emp-error|r",de="|c42B9FFPenguin Emp-error|r",})
lct:RT(2149105516,false,92,{en="Snow leopard",})lct:RT(2149105516,262813840,92,{en="Snow leopard",})
lct:RT(4220436107,false,true,{en="Virsaitis",fr=" Chef de clan",de="Häuptling",})
lct:RT(3019280613,false,1810,{en="Hircine's Huntmaster",})
lct:RT(2015461159,false,92,{en="Vampire Killer",fr="Tueur de Vampires",de="Vampir-Mörder",})
lct:RT(3611298311,false,92,{en="Burden",fr="Fardeau",de="Belastung",})
lct:RT(3125933377,3194506007,true,{de="lila Blitzgewitter",})
lct:RT(1511750762,false,true,{en="Belkin",})
lct:RT(1987022784,1125033682,92,{en="Gank Daddy",})
lct:RT(3297025163,false,92,{en="Descended",fr="Descendu",de="Abstieg",})
lct:RT(411194770,false,92,{en="Unicorn",fr="Licorne",de="Einhorn",})
lct:RT(172741049,3060006054,51,{en="Cold Paws",})
lct:RT(2834675285,false,92,{en="Psycho",fr="Fou",de="Verrückt",})
lct:RT(483342799,360675305,92,{en="General of Roebeck Keep",fr="Général du donjon de Roebeck",de="General der Burg Roebeck",})
lct:RT(3307984231,false,92,{en="Virtue of Rage",fr="Vertu de Rage",de="Tugend der Wut",})
lct:RT(3759188197,false,92,{en="Hyper Beast",fr="Hyper Bete",de="Hyper Biest",})lct:RT(3759188197,87877866,51,{en="Shield Guardian",fr="Gardien de Bouclier",de="Schild Wächter",})
lct:RT(3608880531,false,1330,{en="The Holy Blade",})lct:RT(3608880531,2018825702,2139,{en="Dragon of the North",})
lct:RT(1234649574,false,92,{en="Witch Hunter Captain",fr="Chasseur de sorcières",de="Hexenjäger Hauptmann",})
lct:RT(3893063318,false,51,{en="Overload Spammer",})
lct:RT(2967589286,false,92,{en="Provider of Stabbies",})
lct:RT(4102437509,false,92,{en="Men of Letters",})lct:RT(4102437509,2857517926,628,{en="Telvanni Magister",})
lct:RT(2751570155,false,92,{en="Skoomapriester",de="Skoomapriester",})
lct:RT(182432361,false,92,{en="Banisher of Shadows",fr="Bannisseur d'ombres",de="Verbannter der Schatten",})
lct:RT(630298678,false,92,{en="Gothic Healer",fr="Guérisseur Gothique",de="Gotischer Heiler",})
lct:RT(2513775523,1075222641,92,{en="Dragon Master",})
lct:RT(888305497,false,92,{en="The Rogue's Boss Lady",})
lct:RT(4180531129,false,92,{en="The Night We Met",})lct:RT(4180531129,1624173899,92,{en="Señorita",})
lct:RT(3979506048,945736053,true,{en="The Purificant",fr="La Purificant",de="Die Purificant",})
lct:RT(305669729,false,92,{en="Guardian of Death",fr="Guardian of Death",de="Guardian of Death",})
lct:RT(1210113671,false,494,{en="Exemplar of Harmony",fr="Exemple d'harmonie",de="Vorbild für Harmonie",})
lct:RT(574638066,false,92,{en="Master Zerg Surfer",})lct:RT(574638066,349298527,92,{en="Master Zerg Surfer",})
lct:RT(654897182,1567669092,true,{en="The Countess (Exiled)",fr="La Comtesse (Exilée)",de="Die Gräfin (Verbannt)",})
lct:RT(221598279,false,92,{en="Guardian of Moons",fr="Gardien des Lunes",de="Wächter der Monde",})lct:RT(221598279,1148039024,51,{en="Fangs of Marsh",fr="Crocs du Marais",de="Sumpf Reißzahn",})
lct:RT(3735772642,850072621,51,{en="Necrotic Fork",fr="Fourchette nécrotique",de="Nekrotische Gabel",})
lct:RT(3471987444,1206869137,92,{en="Shadow Blade Master",fr="Maître de la lame de l'ombre",de="Schattenklingenmeister",})
lct:RT(521619546,false,92,{en="Mundus Architect",fr="l'architecte de Mundus",de="Mundus Architekt",})lct:RT(521619546,2327804322,92,{en="Mundus Architect",fr="L'architecte de Mundus",de="Mundus Architekt",})
lct:RT(840089880,false,92,{en="|C89d23dWinter's Bounty|r",fr="|C89d23dWinter's Bounty|r",de="|C89d23dWinter's Bounty|r",})
lct:RT(3635491251,false,92,{en="Spice Islander",})lct:RT(3635491251,3420982753,1391,{en="The Spice Man",})
lct:RT(1227391989,false,1810,{en="|cFF6600Most Wanted|r",})lct:RT(1227391989,1606268249,92,{en="|cFF0000Rain|r|c00FF00blower|r",})
lct:RT(3184639910,false,1330,{en="|cB40431Wakey Wakey|r",fr="|cB40431Wakey Wakey|r",de="|cB40431Wakey Wakey|r",})lct:RT(3184639910,1028168549,1391,{en="|cB40431Kriid do fin Rah|r",fr="|cB40431Kriid do fin Rah|r",de="|cB40431Kriid do fin Rah|r",})
lct:RT(507831021,106805231,92,{en="Maelstrom Destroyer ",fr="Destructeur de Maelstrom",})
lct:RT(107572326,false,92,{en="Spartan",})lct:RT(107572326,2931323604,2079,{en="Charlie Hotel",})
lct:RT(1896301187,false,92,{en="De Stamtafel herbergierster",fr="De Stamtafel Aubergiste",de="De Stamtafel Gastwirt",})lct:RT(1896301187,1838441515,1838,{en="Scientist",fr="Scientifique",de="Wissenschaftler",})
lct:RT(866834824,false,92,{en="|cbf0000Nice Zerg Dude|r",fr="|cbf0000Nice Zerg Dude|r",de="|cbf0000Nice Zerg Dude|r",})
lct:RT(2416466832,false,92,{en="|c2213B6Mana|r|cCF01D4Agarm|r",fr="|c2213B6Mana|r|cCF01D4Agarm|r",de="|c2213B6Mana|r|cCF01D4Agarm|r",})
lct:RT(2264389971,2763825886,true,{en="Professional Colossusizer",})
lct:RT(3928852695,1040767617,92,{en="Aka-hh",})
lct:RT(2558447424,32647195,628,{en="Captain-General",fr="Capitaine-Général",de="Generalkapitän",})
lct:RT(60570649,1696067831,92,{en="Bane of the Undead",})
lct:RT(3293654262,false,92,{en="Undo Never Works",})
lct:RT(2340595043,false,92,{en="Balrog Banisher",})lct:RT(2340595043,3869058700,92,{en="Balrog Banisher",})
lct:RT(2942030735,false,92,{en="Trainer",fr="Entraîneur",})
lct:RT(4033312797,false,92,{en="Red Dawn",})lct:RT(4033312797,3985188503,92,{en="Luminary",})
lct:RT(2125815698,false,92,{en="EXILED",fr="EXILED",de="EXILED",})
lct:RT(1843658878,false,92,{en="The Burliest of Monsters",fr="The Burliest of Monsters",de="The Burliest of Monsters",})
lct:RT(305016762,2731335823,1391,{en="The Lord of the Storms",})
lct:RT(138450998,false,92,{en="The Ever Helpful",fr="Le Toujours Serviable",de="Das Immer Hilfreich",})
lct:RT(327371559,false,92,{en="Hero of Riften",fr="Héros des failles",de="Held von Riften",})
lct:RT(4038326356,false,92,{en="Feeling your pain",})lct:RT(4038326356,933030223,92,{en="Can you see me",})
lct:RT(1610273556,false,92,{en="|c4c6ca5Rampant Evil|r",fr="|c4c6ca5Rampant Mal|r",de="Grassierendes Ubel",})
lct:RT(3498415000,1972206922,92,{en="The Perfectionist",fr="Le Perfectionniste",de="Der Perfektionist",})
lct:RT(20380977,310238337,92,{en="Knightess",fr="Chevalier",de="Ritterin",})
lct:RT(2602509941,10716245,92,{en="Listener",fr="Auditeur",de="Zuhörer",})
lct:RT(774901155,false,92,{en="Feline Overlord",fr="Suzerain Félin",de="Katzenoberherr",})
lct:RT(1323501887,false,92,{en="The Assassin`s Will",fr="La Volonté de L'assassin",de="Der Wille des Attentäters",})
lct:RT(2369465556,false,92,{en="Sword of the Morning",fr="L'épée du Matin",de="Schwert des Morgens",})
lct:RT(2479919183,false,51,{en="Witcher",})lct:RT(2479919183,4072137726,1330,{en="Exploosion",})
lct:RT(649977383,false,92,{en="Warrior Of Ashina ",})lct:RT(649977383,2940491340,1391,{en="The Yokai Demolisher",})
lct:RT(4141100835,2810839709,51,{en="|c8B2F37Bringer of Flames|r",fr="|c8B2F37Porteur de Flammes|r",de="|c8B2F37Flammenbringerin|r",})
lct:RT(1611397257,2009442189,92,{en="Knight Of REE",})
lct:RT(2618202593,false,92,{en="|4DA8EFZerg Master|r",})
lct:RT(1142489855,3622228079,92,{en="Wanderluster",fr="Esprit d'aventurer",de="Fernweher",})
lct:RT(772928884,false,92,{en="Acolyte of Oblivion",fr="Acolyte of Oblivion",de="Acolyte of Oblivion",})lct:RT(772928884,4161175155,92,{en="Acolyte of Oblivion",fr="Acolyte of Oblivion",de="Acolyte of Oblivion",})
lct:RT(3940850400,false,92,{en="Unchained Soul",})lct:RT(3940850400,2925589637,51,{en="Supreme Battlemage",})
lct:RT(1008669454,false,92,{en="Ankh-Morpork Citizen",fr="Citoyen d'Ankh-Morpork",de="Ankh-Morpork Bürger",})
lct:RT(304255045,3199308219,1330,{en="Solo Dungeoneer",})
lct:RT(2224882338,false,true,{en="Princess ",fr="Princesse",de="Prinzessin",})
lct:RT(1597374859,false,true,{en="Keepers Of Avalon",fr="Gardiens d'Avalon",de="Bewahrer von Avalon",})lct:RT(1597374859,159740363,true,{en="Keepers of Avalon",fr="Gardiens d'Avalon",de="Bewahrer von Avalon",})
lct:RT(506532586,false,92,{en="Kartoffel",fr="Kartoffel",de="Kartoffel",})lct:RT(506532586,944864427,2079,{en="Lizard Man",fr="Lizard Man",de="Lizard Man",})
lct:RT(269792996,false,92,{en="Green Balance",})
lct:RT(1866706565,2396632947,true,{en="Shadowmancer",fr="Shadowmancer",de="Shadowmancer",})
lct:RT(3787971540,false,92,{en="Meridian Matriarch",})
lct:RT(3694912525,false,92,{en="The Special Boi",})lct:RT(3694912525,1941227167,2079,{en="Bansorc",})
lct:RT(3725154470,424076504,92,{en="StayAtHome",fr="ResteALaMaison",de="BleibZuhause",})
lct:RT(339939997,false,92,{en="The Pursuer",fr="Le poursuivant",de="Der Verfolger",})
lct:RT(1576905870,false,92,{en="Big Boy",fr="Big Boy",de="Großer Junge",})lct:RT(1576905870,218670402,92,{en="CoolCat",fr="Chat Cool ",de="Coole Katze",})
lct:RT(1454581892,false,true,{en="Bahenol Lord",fr="Bahenol Lord",de="Bahenol Lord",})lct:RT(1454581892,3821440991,true,{en="Bahenol Lord",fr="Bahenol Lord",de="Bahenol Lord",})
lct:RT(3190688181,false,92,{en="Chosen of Mystra",})
lct:RT(2416031295,false,92,{en="Chosen of Mystra",})
lct:RT(884883345,false,2079,{en="Voice of Lagging",fr="Voix de décalage",de="Stimme des Nacheilens",})lct:RT(884883345,4072137726,92,{en="Sanguine Rose",})
lct:RT(2702387715,false,92,{en="Si Ganteng Maut",})lct:RT(2702387715,1882165100,92,{en="Si Ganteng Maut",})
lct:RT(1810746501,359471724,92,{en="Scourge of Akatosh",fr="Fléau d'Akatosh",de="Geißel von Akatosh",})
lct:RT(1752320614,2562747699,92,{en="The Wolf Queen",})
lct:RT(2660969882,false,2079,{en="Bugslayer",})
lct:RT(3590293997,3532525041,92,{en="WonderWoman",fr="MerveilleFemme",de="WunderFrau",})
lct:RT(145009377,false,92,{en="Saber of Red",fr="Sabre de Rouge",de="Säbel aus Rot",})
lct:RT(1990642725,3289488347,628,{en="Imperator",fr="Imperator",de="Imperator",})
lct:RT(1325419224,731831251,1810,{en="Bastion of Light",fr="Bastion de Lumière",de="Bastion des Lichts",})
lct:RT(1745936448,false,92,{en="Paragon of Laziness",})
lct:RT(172316663,false,92,{en="Big Boy",fr="Big Boy",de="Großer Junge",})lct:RT(172316663,2803783031,92,{en="Lovely Boy",fr="Beau garçon",de="Reizender junge",})
lct:RT(1833408884,940019197,92,{en="Wildlife's Tamer",})
lct:RT(2839876947,2022381622,92,{en="Hircine's Puppy",fr="Chiot d'Hircine",de="Hircines Welpe",})
lct:RT(4157924696,false,92,{en="|c8c00b8ALPHA|r",fr="|c8c00b8ALPHA|r",de="|c8c00b8ALPHA|r",})
lct:RT(172649679,false,true,{en="Thick Snowball",})lct:RT(172649679,1886603305,1838,{en="Tick-Tok Tickler",})
lct:RT(2569193097,false,92,{en="The OT ",})lct:RT(2569193097,205990381,92,{en="The OT ",})
lct:RT(3394541549,false,true,{en="Roleplayer",})
lct:RT(1433162170,3858462587,92,{en="The Dragon Reborn",})
lct:RT(2875532055,138339107,92,{en="Sorcerer Commander",fr="Commandant Sorcier",de="Sorcerer Commander",})
lct:RT(3069260494,837831919,92,{en="Night Butterfly",fr="Papillon De Nuit",de="Nacht-Schmetterling",})
lct:RT(733254432,2683754618,1330,{en="Giver of Frosty Toes",fr="Donneur d'orteils givrés",})
lct:RT(959437082,false,92,{en="Retired Raider",})
lct:RT(2319123623,false,92,{en="|cf2e1faDream|r |cf2e1faSpear|r",fr="|cf2e1faDream|r |cf2e1faSpear|r",de="|cf2e1faDream|r |cf2e1faSpear|r",})
lct:RT(723620576,false,92,{en="|c0000FFShakespeare|r",fr="|c0000FFShakespeare|r",de="|c0000FFShakespeare|r",})lct:RT(723620576,4012558769,92,{en="|c0000FFShakespeare|r ",fr="|c0000FFShakespeare|r",de="|c0000FFShakespeare|r",})
lct:RT(2632958814,false,92,{en="The Invincible",})lct:RT(2632958814,2192481466,51,{en="The Legionless",})
lct:RT(4113499427,false,92,{en="Knight of the Rose",fr="Chevalier de la Rose",de="Ritter der Rose",})lct:RT(4113499427,2799375876,628,{en="Sorceress of Varamar",fr="Sorcière de Varamar",de="Zauberin der Varamar",})
lct:RT(141331653,3138453819,92,{en="|cFFE900Grandmaster|r",fr="Grandmaître",de="Großmeister",})
lct:RT(1438082880,false,628,{en="Unholy Guar Lord",fr="Unholy Guar Lord",de="Unholy Guar Lord",})
lct:RT(1621318291,false,92,{en="DPS101",})lct:RT(1621318291,1466571066,1838,{en="FlipFlopTormentor",})
lct:RT(2233183240,false,92,{en="Warmage",fr="Mage De Guerre",de="Kriegsmagier",})lct:RT(2233183240,685381007,92,{en="Caretaker",fr="Le Concierge",de="Hausmeisterin",})
lct:RT(2514836359,false,92,{en="Backflip Healer",fr="Guérisseuse Backflip",de="Backflip Heilerin",})
lct:RT(843089977,false,92,{en="The Custodian",fr="Le Custodien",de="Die Custodian",})lct:RT(843089977,49344133,92,{en="The Custodian",fr="Le Custodien",de="Die Custodian",})
lct:RT(1001060050,false,92,{en="Crazy Cat Lady",fr="Dame de chat fou",de="Verrückte Katzenfrau",})lct:RT(1001060050,1568127501,92,{en="Huldra Skogvættir",fr="Huldra Esprit forêt",de="Huldra Waldgeist",})
lct:RT(1684236168,false,92,{en="The Awkward",de="Der Komische",})lct:RT(1684236168,3757575215,92,{en="The Grumpy",})
lct:RT(3656526464,false,2139,{en="Dungeon Master",})lct:RT(3656526464,1322900160,2075,{en="Boy Next Door",})
lct:RT(440683284,false,2136,{en="|c581845Shadow|r",})lct:RT(440683284,870783540,1330,{en="|cD700FFI|r |cFF00B3love|r tea",})


--[[
Author: Kyoma
Filename: LibTitleLocale.lua
Version: 3 (Horns of the Reach)
Total: 95 titles
]]--

local LocaleTitles =
{
	["de"] = 
	{
		[2] = 
		{
			[1810] = "Divayth Fyrs Gehilfe",
			[1838] = "Der Tick-Tack-Peiniger",
			[1330] = "makelloser Eroberer",
			[51] = "Monsterjäger",
			[705] = "Großfeldherr",
			[92] = "Freiwilliger",
			[494] = "Meisterangler",
			[1391] = "dro-m'Athra-Zerstörer",
			[628] = "Held Tamriels",
			[1910] = "Held der Eroberung",
			[1913] = "Großchampion",
			[2139] = "Greifenherz",
			[2079] = "Stimme der Vernunft",
			[2136] = "Lichtbringer",
			[2075] = "Unsterblicher Erlöser",
		},
		[1] = 
		{
			[1810] = "Divayth Fyrs Gehilfin",
			[1838] = "Die Tick-Tack-Peinigerin",
			[1330] = "makellose Eroberin",
			[51] = "Monsterjägerin",
			[705] = "Großfeldherrin",
			[92] = "Freiwillige",
			[494] = "Meisteranglerin",
			[1391] = "dro-m'Athra-Zerstörerin",
			[628] = "Heldin Tamriels",
			[1910] = "Heldin der Eroberung",
			[1913] = "Großchampion",
		},
	},
	["en"] = 
	{
		[2] = 
		{
			[1810] = "Divayth Fyr's Coadjutor",
			[1838] = "Tick-Tock Tormentor",
			[1330] = "The Flawless Conqueror",
			[51] = "Monster Hunter",
			[705] = "Grand Overlord",
			[628] = "Tamriel Hero",
			[1391] = "Dro-m'Athra Destroyer",
			[494] = "Master Angler",
			[92] = "Volunteer",
			[1910] = "Conquering Hero",
			[1913] = "Grand Champion",
			[2079] = "Voice of Reason",
			[2075] = "Immortal Redeemer",
			[2139] = "Gryphon Heart",
			[2136] = "Bringer of Light",
		},
		[1] = 
		{
			[1810] = "Divayth Fyr's Coadjutor",
			[1838] = "Tick-Tock Tormentor",
			[1330] = "The Flawless Conqueror",
			[51] = "Monster Hunter",
			[705] = "Grand Overlord",
			[628] = "Tamriel Hero",
			[1391] = "Dro-m'Athra Destroyer",
			[494] = "Master Angler",
			[92] = "Volunteer",
			[1910] = "Conquering Hero",
			[1913] = "Grand Champion",

		},
	},
	["fr"] = 
	{
		[2] = 
		{
			[1810] = "Coadjuteur de Divayth Fyr",
			[1838] = "Tourmenteur des Tic-tac",
			[1330] = "Le conquérant implacable",
			[51] = "Chasseur de monstres",
			[705] = "Grand maréchal",
			[628] = "Héros de Tamriel",
			[1391] = "Destructeur des dro-m'Athra",
			[494] = "Maître de pêche",
			[92] = "Volontaire",
			[1910] = "Héros conquérant",
			[1913] = "Grand champion",
			[2075] = "Rédempteur immortel",
			[2139] = "Cœur-de-griffon",
			[2136] = "Porteur de lumière",
			[2079] = "Voix de la raison",


		},
		[1] = 
		{

			[1810] = "Coadjutrice de Divayth Fyr",
			[1838] = "Tourmenteuse des Tic-tac",
			[1330] = "La conquérante implacable",
			[51] = "Chasseuse de monstres",
			[1391] = "Destructrice des dro-m'Athra",
			[494] = "Maîtresse de pêche",
			[705] = "Grand maréchal",
			[628] = "Héroïne de Tamriel",
			[92] = "Volontaire",
			[1910] = "Héroïne conquérante",
			[1913] = "Grande championne",
		},
	},
}

local GetAchievementRewardTitle_original

local function Unload()
	GetAchievementRewardTitle = GetAchievementRewardTitle_original
end

local function Load()

	GetAchievementRewardTitle_original = GetAchievementRewardTitle
	GetAchievementRewardTitle = function(achievementId, gender)
		local hasTitle, title = GetAchievementRewardTitle_original(achievementId, gender)
		if (hasTitle and gender) then
			if (LocaleTitles[lang] and LocaleTitles[lang][gender] and LocaleTitles[lang][gender][achievementId]) then
				title = LocaleTitles[lang][gender][achievementId]
			end
		end
		return hasTitle, title
	end

	LibCustomTitles.Unload = Unload
end

if(LibCustomTitles.Unload) then LibCustomTitles.Unload() end
Load()
