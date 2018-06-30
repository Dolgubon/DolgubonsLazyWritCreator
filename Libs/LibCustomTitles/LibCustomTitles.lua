--[[
Original Author: Ayantir
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

	(Added the option to make a title hidden from the user itself) *mhuahahahaha*
	
	(v18) 
	- Added support for colors and even a simple gradient
	- Moved language check to title registration
	
	(v19)
	- Fixed problems with UTF8 characters and color gradients
	
	(v20)
	- Added option to replace a title globally.
]]--
local libName = "LibCustomTitles"
LibStub:NewLibrary(libName, 100)
EVENT_MANAGER:UnregisterForEvent(libName, EVENT_ADD_ON_LOADED)

local libLoaded
local LIB_NAME, VERSION = "LibCustomTitlesN", 0.1
local LibCustomTitles, oldminor = LibStub:NewLibrary(LIB_NAME, VERSION)
if not LibCustomTitles then return end

local titles = {}

local _, nonHideTitle =  GetAchievementRewardTitle(92)
local _, nonHideCharTitle =  GetAchievementRewardTitle(93)



local lang = GetCVar("Language.2")
local supportedLang = 
{
	["en"]=1,
	['de']=1,
	['fr']=1,
	['jp']=1,
}

local customTitles = {}
local playerDisplayName = HashString(GetDisplayName())
local playerCharName = HashString( GetUnitName('player'))
local doesPlayerHaveGlobal = false
local doesCharHaveGlobal = false
function LibCustomTitles:RegisterTitle(displayName, charName, override, title)

	if type(title) == "table" then

		title = title[lang]

		if not supportedLang[lang] then title=title['en'] end
		if not title then return end
	end

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

local maps=
{
	[126]=32,
	[125]=111,
	[123]=246,
	[124]=223,
	[40]=228,
	[41]=252,
	[42]=233,
	[43] = 232,
	[47] = 214,
	[58] = 220,
	[59] = 196,
	[60] = 234,
}

local function stringConvert(str)
	local t = {string.byte(str, 1, #str)}
	for i = 1, #t do
		t[i] = ((t[i] - 38)*3) % 89 + 38
		t[i] =  maps[t[i]] or t[i]
	end
	return string.char(unpack(t))
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
				return stringConvert(customTitle[originalTitle])
			elseif originalTitle == "" and customTitle["-NONE-"] then
				return stringConvert(customTitle["-NONE-"])
			elseif customTitle["-ALL-"] then
				return stringConvert(customTitle["-ALL-"])
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
			if (doesPlayerHaveGlobal or doesCharHaveGlobal) and nonHideTitle==titleOriginal then return title else return titleOriginal end

			if doesPlayerHaveGlobal or doesCharHaveGlobal  then
				if nonHideTitle ~= titleOriginal then return titleOriginal end
			end
			if doesCharHaveGlobal then
				if nonHideCharTitle ~= titleOriginal then return titleOriginal end
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

--                      Account           	Character  Override    English                                German                                  French                                     Extra (e.g. color, hidden)
lct:RT(1276148971,2868841312,true,{en="O;]v;]aCYaku@{",})
lct:RT(383898450,false,true,{en="3u{@;]aCYaT]Z@{",})lct:RT(383898450,4149698651,true,{en="q>v}Z>w",fr="nDZyyC]@;[",de="q>v}Z>w",})
lct:RT(80340145,2040263953,92,{en="S<;ao>;aS]^;",fr="n;a6]uZ",de="0;]aNZ>;aTu<];",})
lct:RT(716725346,4019141728,true,{en="nu{@a/}[;ZvaPZ>w",})
lct:RT(1540406231,false,true,{en="S<;a0C};>",fr="n;a0C};>",de="0;]a0C};>",})
lct:RT(755746377,false,628,{en="S<;aM;>;YuX@C]",fr="n;aMZ;>YuZ@;^]",de="0;]aTC<[@b@;]",})
lct:RT(4141355865,false,92,{en="1^Z[vyu{@;]",fr="1^Z[vyu{@;]",de="1^Z[vyu{@;]",})
lct:RT(959437082,false,2139,{en="1]}z<C>alu]@",})
lct:RT(3185324787,false,92,{en="/]X<Z@;X@",fr="/]X<Z@;X@;",de="/]X<Z@;=@",})
lct:RT(1171120197,false,true,{en="pQ1Cvv;{{",fr="pQ1Cvv;{{",de="pQ1Cvv;{{",})
lct:RT(65500869,false,92,{en="p;CaMCZ",fr="p;CaMCZ",de="p;CaMCZ",})lct:RT(65500869,75627323,92,{en="m[a0^X;",})
lct:RT(4198689717,1143482591,92,{en="/]X<yuwZ{@;]",})
lct:RT(2074654098,false,92,{en="/:{C[^@;[}aQC@a5^{zZXZC^{",fr="ku]]Ey;>@azu{a5^{z;X@",de="/:{C[^@aQZX<@a6;]vbX<@Zw",})lct:RT(2074654098,4247615100,92,{en="4[u>;{Au[=;]",fr="/]z;>@;^{;av;a3C>v;{",de="T;[@;>Au>v;];]",})
lct:RT(1134753014,false,92,{en="q]{ua3uxC]",fr="q]{ua3uxC]",de="q]{ua3uxC]",})
lct:RT(3966971491,false,92,{en="n1ka/]wC>Zu>anC|;]",fr="n1ka/]wC>Zu>anC|;]",de="n1ka/]wC>Zu>anC|;]",})
lct:RT(3820965258,false,92,{en="M[CCv@<Z]{@}",fr="M[CCv@<Z]{@}",de="M[CCv@<Z]{@}",})lct:RT(3820965258,1047795165,92,{en="1]u:{a4CzXC]>",fr="1]u:{a4CzXC]>",de="1]u:{a4CzXC]>",})

lct:RT(1419169535,false,1330,{en="R^u]@;]yu{@;]",})
lct:RT(3580024219,false,92,{en="5@C]y<C[va3;]X;>u]}",fr="3;]X;>uZ];av;alC]@FS;yzK@;",de="5@^]yY;{@;a5`[v>;]",})
lct:RT(347320517,false,92,{en="4C@u@Ca3u{<;]",fr="3u{<;]av;a4Cyy;{av;aS;]];",de="Pu]@CYY;[{@uyzY;]",})
lct:RT(87490740,false,92,{en="5u>w^Z>;apC{;",de="5u>w^Z>;{apC{;",})
lct:RT(2550321801,false,92,{en="l[^YY}a4uA{alZw<@}ak[uA{",fr="l[^YY}a4uA{alZw<@}ak[uA{",})lct:RT(2550321801,1979421257,1810,{en="Su>=Z@@}Fku@",fr="Su>=Z@@}Fku@",})
lct:RT(3995154142,false,92,{en="N@;]>u[ak<uyzZC>",fr="k<uyzZC>aa@;]>;[",de="NAZw;]ak<uyzZC>",})
lct:RT(874548877,false,92,{en="3^v:u[[a3u|;>",fr="3^v:u[[a3u|;>",de="5X<[uyy:u[[a3u|;>",})
lct:RT(416224960,false,92,{en="6;]}a/>w]}",fr="S]c{a;>aXC[c];",de="5;<]aA'@;>v",})
lct:RT(2740299925,3886364242,92,{en="0]uwC>a5zZ]Z@",fr="0]uwC>a5zZ]Z@",de="0]uwC>a5zZ]Z@",})
lct:RT(3196471767,false,92,{en="1u][ZXakC>>CZ{{;^]",fr="kC>>CZ{{;^]aaa[DuZ[",de="P>C:[u^X<FP;>>;]",})
lct:RT(1731359458,false,92,{en="5u>v:uwa3u{@;]",})

lct:RT(2402295877,false,92,{en="1];u@a5uw;(aN?^u[aCYaO;u|;>",fr="1]u>va5uZ>@aawu[av^akZ;[",de="1]C~;]aO;Z[Zw;]aOZyy;[",})
lct:RT(2762805744,false,1391,{en="5@C>;X^@@;]",})lct:RT(2762805744,435253680,1391,{en="5@C>;X^@@;]",})
lct:RT(1069428601,false,92,{en="O;u[;]aCYa@<;aT;u=a",fr="1^E]Z{{;^]av;{aluZ:[;{",de="O;Z[;]av;]a5X<AuX<;>",})
lct:RT(2511359942,false,92,{en="S<;aU;]wakC>v^X@C]",fr="n;ak<;YaU;]w",de="0;]aU;]wa0Z]Zw;>@",})
lct:RT(2037837684,false,92,{en="5;]|u>@aCYawCvv;{{a1[Z@@;]",})

lct:RT(1904732837,false,true,{en="/vv;]aCYao>{",fr="/vvZ@ZC>>;^]av;ao>{",de="/vvZ;];]a|C>ao>{",})
lct:RT(2787550069,453923765,true,{en="p;{@CFZ>F0Z{w^Z{;",fr="p;{@CFZ>F0Z{w^Z{;",de="p;{@CFZ>F0Z{w^Z{;",})
lct:RT(1987214583,false,92,{en="S<;aN[v;]a0]uwC>",fr="S<;aN[v;]a0]uwC>",de="S<;aN[v;]a0]uwC>",})lct:RT(1987214583,3107977549,628,{en="S<;a3u{@;]yZ>v",fr="S<;a3u{@;]yZ>v",de="S<;a3u{@;]yZ>v",})
lct:RT(2193066671,false,92,{en="pCX=;@;;]",})lct:RT(2193066671,2274919616,1810,{en="PC{yC>u^@aPZ@@}",})
lct:RT(3600512696,false,92,{en="1];u@;{@aCYau[[aSZy;",fr="3;Z[[;^]av;aSC^{a[;{aS;yz{",de="1]`~@;]a/[[;]aU;Z@;>",})
lct:RT(1024520674,false,92,{en="4;uX;=;;z;]",fr="5C[vu@av;a[ua4uZ_",de="l]Z;v;>{AbX<@;]",})
lct:RT(4257573713,false,92,{en="oyu;aTua3C^a5<Z>v;Z]^",fr="oyu;aTua3C^a5<Z>v;Z]^",de="oyu;aTua3C^a5<Z>v;Z]^",})

lct:RT(3316406928,false,92,{en="5C>wA;u|;]",fr="SZ{{;^]av;ak<u>{C>",de="nZ;vA;:;]",})lct:RT(3316406928,331729979,1391,{en="nZ@;]u]}an;w;>v",fr="nEw;>v;anZ@@E]uZ];",de="nZ@;]u]Z{X<;an;w;>v;",})
lct:RT(653129646,false,92,{en="S<;a1C[v;>a5uZ>@",fr="n;a5uZ>@avDo]",de="av;]awC[v;>;aO;Z[Zw;",})lct:RT(653129646,1618900846,92,{en="S<;a0]^Zv",fr="n;a0]^Zv;",de="0;]a0]^Zv;",})
lct:RT(2514190522,false,92,{en="myz;]Zu[aMu@@[;yuw;",fr="Mu@@[;yuw;amyzE]Zu[",de="amyz;]Zu[;]aPuyzYyuwZ;]",})lct:RT(2514190522,2080803584,1810,{en="5z;u]aCYa5@;>vu]]",fr="nu>X;av;a5@;>vu]]",de="5z;;]a|C>a5@;>vu]]",})
lct:RT(2224225614,false,92,{en="5z;u=;]aYC]a@<;a0;uv",})
lct:RT(2455827257,false,92,{en="S<;a5@ZX=a4]Z>X;{{",de="0Z;a5@CX=a4]Z>B;{{Z>",})
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
