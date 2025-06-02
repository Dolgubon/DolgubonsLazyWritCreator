-----------------------------------------------------------------------------------
-- Addon Name: Dolgubon's Lazy Writ Crafter
-- Creator: Dolgubon (Joseph Heinzle)
-- Addon Ideal: Simplifies Crafting Writs as much as possible
-- Addon Creation Date: March 14, 2016
--
-- File Name: Languages/de.lua
-- File Description: German Localization
-- Load Order Requirements: None
-- 
-----------------------------------------------------------------------------------

WritCreater = WritCreater or {}


function WritCreater.langWritNames() --Exacts!!!  I know for german alchemy writ is Alchemistenschrieb - so ["G"] = schrieb, and ["A"]=Alchemisten
	local names = {
	["G"] = "schrieb",
	[CRAFTING_TYPE_ENCHANTING] = "Verzauberer",
	[CRAFTING_TYPE_BLACKSMITHING] = "Schmiede",
	[CRAFTING_TYPE_CLOTHIER] = "Schneider",
	[CRAFTING_TYPE_PROVISIONING] = "Versorger",
	[CRAFTING_TYPE_WOODWORKING] = "Schreiner",
	[CRAFTING_TYPE_ALCHEMY] = "Alchemisten",
	[CRAFTING_TYPE_JEWELRYCRAFTING] = "SchmuckHandwerk",
	}
	return names
end

function WritCreater.writCompleteStrings()
	local strings = {
	["place"] = "Die Waren in die Kiste legen",
	["sign"] = "Das Manifest unterschreiben",
	["masterStart"] = "<Nehmt den Auftrag an.>",
	["masterSign"] = "<Auftrag abschließen.>",
	["masterPlace"] = "Ich habe den ",
	["Rolis Hlaalu"] = "Rolis Hlaalu",
	["Deliver"] = "Beliefer"
	}
	return strings
end

function WritCreater.langCraftKernels()
	return 
	{
		[CRAFTING_TYPE_ENCHANTING] = "verzauberung",
		[CRAFTING_TYPE_BLACKSMITHING] = "schmiede",
		[CRAFTING_TYPE_CLOTHIER] = "schneider",
		[CRAFTING_TYPE_PROVISIONING] = "versorger",
		[CRAFTING_TYPE_WOODWORKING] = "schreiner",
		[CRAFTING_TYPE_ALCHEMY] = "alchemi",
		[CRAFTING_TYPE_JEWELRYCRAFTING] = "schmuck",
	}
end

function WritCreater.langMasterWritNames()
	local names = {
	["M"] 							= "meisterhafte",
	["M1"]							= "meister",
	[CRAFTING_TYPE_ALCHEMY]			= "gebräu",
	[CRAFTING_TYPE_ENCHANTING]		= "glyphe",
	[CRAFTING_TYPE_PROVISIONING]	= "mahl",
	["plate"]						= "rüstung",
	["tailoring"]					= "gewand",
	["leatherwear"]					= "lederwaren",
	["weapon"]						= "waffe",
	["shield"]						= "schild",
	}
return names

end


function WritCreater.masterWritQuality()
	return {{"episch",4},{"legendär",5}}
end


local enExceptions = -- This is a slight misnomer. Not all are corrections - some are changes into english so that future functions will work
{
	["original"] =
	{
		[1] = "beschafft",
		[2] = "beliefert",
		[3] = "beliefer",
		[4] = "Beliefer",

	},
	["corrected"] = 
	{	
		[1] = "acquire",
		[2] = "deliver",
		[3] = "deliver",
		[4] = "deliver",

	},
}



function WritCreater.questExceptions(condition)
	condition = string.gsub(condition, " "," ")
	return condition
end

function WritCreater.enchantExceptions(condition)
	condition = string.gsub(condition, " "," ")
	condition = string.lower(condition)
	for i = 1, #enExceptions["original"] do
		condition = string.gsub(condition,enExceptions["original"][i],enExceptions["corrected"][i])
	
	end
	return condition
end


function WritCreater.langTutorial(i) --sentimental
	local t = {
		[5]="Hier noch ein paar Dinge die du wissen solltest.\nDer Chat-Befehl \'/dailyreset\' zeigt dir die Wartezeit an,\nbis du die nächsten Handwerksdailies machen kannst.",
		[4]="Als letzte Information: Im Standard ist das AddOn für alle Berufe aktiviert.\nDu kannst aber in den AddOn Einstellungen die gewünschten Berufe ein-/ausschalten.",
		[3]="Als Nächstes kannst du dich entscheiden, ob dieses Fenster angezeigt werden soll, solange du dich an einer Handwerksstation befindest.\nDieses Fenster zeigt dir wieviele Materialien für das Herstellen benötigt werden und wieviele du aktuell besitzt.",
		[2]="Wenn aktiv werden deine Sachen automatisch beim Betreten einer Handwerksstation hergestellt.",
		[1]="Willkommen zu Dolgubon's Lazy Writ Crafter!\nEs gibt ein paar Einstellungen die du zunächst festlegen\n solltest. Du kannst die Einstellungen jederzeit bei\nAddOn in Einstellungen >> Erweiterungen Menü ändern.",
	}
	return t[i]
end

function WritCreater.langTutorialButton(i,onOrOff) --sentimental and short pls
	local tOn = 
	{
		[1]="Standardoptionen",
		[2]="An",
		[3]="Zeigen",
		[4]="Weiter",
		[5]="Fertig",
	}
	local tOff=
	{
		[1]="Weiter",
		[2]="Aus",
		[3]="Verbergen",
	}
	if onOrOff then
		return tOn[i]
	else
		return tOff[i]
	end
end


local function runeMissingFunction(ta,essence,potency)
	local missing = {}
	if not ta["bag"] then
		missing[#missing + 1] = "|r"..ZO_CachedStrFormat("<<C:1>>","Ta").."|cf60000"
	end
	if not essence["bag"] then
		missing[#missing + 1] =  "|cffcc66"..ZO_CachedStrFormat("<<C:1>>",essence["slot"]).."|cf60000"
	end
	if not potency["bag"] then
		missing[#missing + 1] = "|c0066ff"..ZO_CachedStrFormat("<<C:1>>",potency["slot"]).."|r"
	end
	local text = ""
	for i = 1, #missing do
		if i ==1 then
			ZO_CachedStrFormat("<<C:1>>",missing[i])
			text = "|cff3333Glyphe kann nicht hergestellt werden.\nNicht genügend "..ZO_CachedStrFormat("<<C:1>>",missing[i])
		else
			text = text.." oder "..ZO_CachedStrFormat("<<C:1>>",missing[i])
		end
	end
	return text

	
end

WritCreater.strings = WritCreater.strings or {}

WritCreater.strings["runeReq"] 									= function (essence, potency) return zo_strformat("|c2dff00Benötigt 1 |rTa|c2dff00, 1 |cffcc66<<1>>|c2dff00 und ein |c0066ff<<2>>",essence, potency) end
WritCreater.strings["runeMissing"] 								= runeMissingFunction
WritCreater.strings["notEnoughSkill"]							= "Du hast nicht genügend Fertigkeitspunkte im Handwerk, um den Gegenstand herzustellen."
WritCreater.strings["smithingMissing"] 							= "\n|cf60000Nicht genügend Materialien|r"
WritCreater.strings["craftAnyway"] 								= "Trotzdem herstellen"
WritCreater.strings["smithingEnough"] 							= "\n|c2dff00Du hast genügend Materialien"
WritCreater.strings["craft"] 									= "|c00ff00Herstellen|r"
WritCreater.strings["smithingReqM"] 							= function(amount, type, more) return zo_strformat("Benötigt <<1>> <<2>> (|cf60000<<3>> benötigt|r)",amount,type,more) end
WritCreater.strings["smithingReqM2"] 							= function (amount,type,more) return zo_strformat("\n<<1>> <<2>> (|cf60000<<3>> benötigt|r)" , amount, type,more )end
WritCreater.strings["smithingReq"] 								= function (amount,type, current) return zo_strformat("Benötigt <<1>> <<2>> (|c2dff00<<3>> verfügbar|r)" , amount, type,zo_strformat(SI_NUMBER_FORMAT, ZO_AbbreviateNumber(current, NUMBER_ABBREVIATION_PRECISION_TENTHS, USE_LOWERCASE_NUMBER_SUFFIXES))) end
WritCreater.strings["smithingReq2"] 							= function (amount,type, current) return zo_strformat("\n<<1>> <<2>> (|c2dff00<<3>> verfügbar|r)" , amount, type,current )end
WritCreater.strings["crafting"] 								= "|cffff00Herstellung...|r"
WritCreater.strings["craftIncomplete"] 							= "|cf60000Die Herstellung konnte nicht abgeschlossen werden.\nDu benötigst mehr Materialien.|r"
WritCreater.strings["moreStyle"] 								= "|cf60000Du hast keine der ausgewählten Stilsteine vorhanden|r"
WritCreater.strings["moreStyleSettings"]						= "|cf60000Du hast keine verfügbaren Stylematerialien.\nWahrscheinlich musst du in den Settings weitere Handwerksstile aktivieren.|r"
WritCreater.strings["moreStyleKnowledge"]						= "|cf60000Du hast keine verfügbaren Stylematerialien.\nVielleicht musst du mehr Handwerksstile lernen|r"
WritCreater.strings["dailyreset"] 								= function (till) d(till["hour"].." Stunden und "..till["minute"].." Minuten bis zum Daily Reset") end
WritCreater.strings["complete"] 								= "|c00FF00Der Schrieb ist fertig|r"
WritCreater.strings["craftingstopped"] 							= "Herstellung gestoppt. Bitte überprüfe, ob das AddOn den richtigen Gegenstand herstellt."
WritCreater.strings["lootReceived"]								= "<<1>> erhalten (Du hast <<2>>)"
WritCreater.strings["lootReceivedM"]							= "<<1>> erhalten"
WritCreater.strings["countSurveys"]								= "Du hast <<1>> Gutachten"
WritCreater.strings["countVouchers"]							= "Du hast <<1>> offene Schriebscheine"
WritCreater.strings["includesStorage"] 							= "Zähle <<1>> in deinen Lagertruhen mit" 
WritCreater.strings["surveys"]									= "Handwerksgutachten"
WritCreater.strings["sealedWrits"]								= "Versiegelte Schriebe"
WritCreater.strings["missingLibraries"]							= "Dolgubon's Lazy Writ Crafter benötigt die folgenden Standalone-Libraries. Bitte installiere oder aktiviere diese Libraries: "
WritCreater.strings['fullBag']						= "Du hast keinen Platz mehr im Inventar. Bitte leere dein Inventar."
WritCreater.strings['masterWritSave']				= "Dolgubon's Lazy Writ Crafter hat verhindert, dass du versehentlich einen Meisterschrieb annimmst. Gehe in die Erweiterungseinstellungen, um diese Option zu deaktivieren."
WritCreater.strings['missingLibraries']			= "Dolgubon's Lazy Writ Crafter requires the following standalone libraries. Please download, install or turn on these libraries: "
WritCreater.strings['resetWarningMessageText']		= "Die täglichen Handwerksquests werden in <<1>> Stunde und <<2>> Minute zurückgesetzt\nDu kannst diese Warnung in den Einstellungen anpassen oder deaktivieren"
WritCreater.strings['resetWarningExampleText']		= "Die Warnung wird so aussehen"
WritCreater.strings["withdrawItem"]					= function(amount, link, remaining) return "Dolgubon's Lazy Writ Crafter entnahm "..amount.." "..link..". (Noch "..remaining.." in der Bank)" end -- in Bank for German


local DivineMats =
{
	{"Geisteraugen", "Vampirherzen", "Werwolfklauen", "'Spezielle' Süßigkeiten", "Abgetrennte Hände", "Zombieeingeweide", "Fledermauslebern", "Echsenhirne", "Hexenhüte", "Destillierte Buhs", "Singende Kröten"},
	{"Sockenpuppen", "Narrenhüte", "Lachanfälle", "Rote Heringe", "Faile Eier", "Gekrönte Hochstapler", "Schlammpasteten", "Otternasen"},
	{"Feuerwerk", "Geschenke", "Ewige Lichter", "Fichtennadeln", "Wichtelhüte", "Rentierklöten"},

}

local function shouldDivinityprotocolbeactivatednowornotitshouldbeallthetimebutwhateveritlljustbeforabit()
	
	if GetDate()%10000 == 1031 then return 1 end
	if GetDate()%10000 == 401 then return 2 end
	if GetDate()%10000 == 1231 then return 3 end
	return false
end
local function wellWeShouldUseADivineMatButWeHaveNoClueWhichOneItIsSoWeNeedToAskTheGodsWhichDivineMatShouldBeUsed() local a= math.random(1, #DivineMats ) return DivineMats[a] end
local l = shouldDivinityprotocolbeactivatednowornotitshouldbeallthetimebutwhateveritlljustbeforabit()

if l then
	DivineMats = DivineMats[l]
	local DivineMat = wellWeShouldUseADivineMatButWeHaveNoClueWhichOneItIsSoWeNeedToAskTheGodsWhichDivineMatShouldBeUsed()
	WritCreater.strings.smithingReqM = function (amount, _,more) return zo_strformat( "Crafting will use <<1>> <<4>> (|cf60000You need <<3>>|r)" ,amount, type, more, DivineMat) end
	WritCreater.strings.smithingReqM2 = function (amount, _,more) return zo_strformat( "As well as <<1>> <<4>> (|cf60000You need <<3>>|r)" ,amount, type, more, DivineMat) end
	WritCreater.strings.smithingReq = function (amount, _,more) return zo_strformat( "Crafting will use <<1>> <<4>> (|c2dff00<<3>> available|r)" ,amount, type, more, DivineMat) end
	WritCreater.strings.smithingReq2 = function (amount, _,more) return zo_strformat( "As well as <<1>> <<4>> (|c2dff00<<3>> available|r)" ,amount, type, more, DivineMat) end
end


WritCreater.optionStrings = WritCreater.optionStrings or {}


WritCreater.optionStrings["nowEditing"]						= "Du änderst %s Einstellungen"
WritCreater.optionStrings["accountWide"]					= "Gesamtes Konto"
WritCreater.optionStrings["characterSpecific"]				= "Charakter spezifisch"
WritCreater.optionStrings["useCharacterSettings"]			= "Nutze Charakter Einstellungen"
WritCreater.optionStrings["useCharacterSettingsTooltip"]	= "Speichert für diesen Charakter die Einstellungen spezifisch ab, nicht für das gesamte Konto."

WritCreater.optionStrings["style tooltip"]                            = function (styleName, styleStone) return zo_strformat("Allow the <<1>> style, which uses <<2>> to be used for crafting",styleName) end  
WritCreater.optionStrings["show craft window"]                        = "Zeige Writ Crafter Fenster"
WritCreater.optionStrings["show craft window tooltip"]                = "Zeige das Writ Crafter Fenster während du an einer Handwerksstation bist"
WritCreater.optionStrings["autocraft"]                                = "Automatisches herstellen"
WritCreater.optionStrings["autocraft tooltip"]                        = "Bei Aktivierung dieser Funktion wird Writ Crafter automatisch mit dem Herstellen beginnen, sobald ihr bei einer Handwerksstation seid. Wird das Writ Craft Fenster nicht angezeigt, wird diese Funktion eingeschaltet sein."
WritCreater.optionStrings["blackmithing"]                             = "Schmiede"
WritCreater.optionStrings["blacksmithing tooltip"]                    = "Addon für Schmiede ausschalten"
WritCreater.optionStrings["clothing"]                                 = "Schneider"
WritCreater.optionStrings["clothing tooltip"]                         = "Addon für Schneider ausschalten"
WritCreater.optionStrings["enchanting"]                               = "Verzauberer"
WritCreater.optionStrings["enchanting tooltip"]                       = "Addon für Verzauberer ausschalten"
WritCreater.optionStrings["alchemy"]                                  = "Alchemisten"
WritCreater.optionStrings["alchemy tooltip"]   	                  	  = "Addon für Alchemisten ausschalten"
WritCreater.optionStrings["provisioning"]                             = "Versorger"
WritCreater.optionStrings["provisioning tooltip"]                     = "Addon für Versorger ausschalten"
WritCreater.optionStrings["woodworking"]                              = "Schreiner"
WritCreater.optionStrings["woodworking tooltip"]                      = "Addon für Schreiner ausschalten"
WritCreater.optionStrings["woodworking"]                              = "Schreiner"
WritCreater.optionStrings["woodworking tooltip"]                      = "Addon für Schreiner ausschalten"
WritCreater.optionStrings["jewelry crafting"]							= "Schmuckhandwerk"
WritCreater.optionStrings["jewelry crafting tooltip"]					= "Addon für Schmuckhandwerk ausschalten"
WritCreater.optionStrings["style stone menu"]                         = "Stilmaterial"
WritCreater.optionStrings["style stone menu tooltip"]                 = "Wähle aus, welches Stilmaterial benutzt werden soll."
WritCreater.optionStrings["exit when done"]                           = "Schließe Handwerksfenster"
WritCreater.optionStrings["exit when done tooltip"]                   = "Schließe Handwerksfenster nachdem alle Aufgaben abgeschlossen sind"
WritCreater.optionStrings["automatic complete"]                       = "Automatischer Quest Dialog"
WritCreater.optionStrings["automatic complete tooltip"]					= "Automatisches annehmen und abschließen der Quests bei erreichen und einmaligem aktivieren des benötigten Ortes"
WritCreater.optionStrings["new container"]								= "Behalte neuen Status"
WritCreater.optionStrings["new container tooltip"]						= "Behalte neuen Status für Schrieb-Belohnungs-Behälter"
WritCreater.optionStrings["master"]										= "Meisterschriebe"
WritCreater.optionStrings["master tooltip"]								= "Ein/Ausschalten ob Meisterschriebe automatisch hergestellt werden"
WritCreater.optionStrings["right click to craft"]						= "Rechtsklick zum Craften"
WritCreater.optionStrings["right click to craft tooltip"]				= "Wenn diese Einstellung aktiv ist, wird das AddOn Masterwrits craften, nachdem sie durch einen Rechtsklick aktiviert wurden"
WritCreater.optionStrings["crafting submenu"]							= "Zu bearbeitende Handwerke"
WritCreater.optionStrings["crafting submenu tooltip"]					= "Ein/Ausschalten von bestimmten Handwerken"
WritCreater.optionStrings["timesavers submenu"]							= "Zeitsparer"
WritCreater.optionStrings["timesavers submenu tooltip"]					= "Diverse kleine Zeitsparer"
WritCreater.optionStrings["loot container"]								= "Plündern von Belohnungs-Behältern"
WritCreater.optionStrings["loot container tooltip"]						= "Automatisches Plündern der Handwerksschrieb-Belohnungs-Behälter bei Erhalt"
WritCreater.optionStrings["master writ saver"]							= "Meisterschriebe sperren"
WritCreater.optionStrings["master writ saver tooltip"]					= "Sperrt die Möglichkeit Meisterschriebe anzunehmen"
WritCreater.optionStrings["loot output"]								= "Wertvolle Belohnung Hinweis"
WritCreater.optionStrings["loot output tooltip"]						= "Gebe eine Nachricht aus sobald du wertvolle Gegenstände aus einem Schrieb erhälst"
WritCreater.optionStrings["writ grabbing"]								= "Gegenstände entnehmen"
WritCreater.optionStrings["writ grabbing tooltip"]						= "Entnimmt Gegenstände die für Schriebe benötigt werden (z.B. Nirnwurz, Ta, usw.) aus der Bank"
WritCreater.optionStrings["autoloot behaviour"]							= "Autoloot-Verhalten"
WritCreater.optionStrings["autoloot behaviour tooltip"]					= "Wann soll das Add-On Container looten"
WritCreater.optionStrings["autoloot behaviour choices"]					= {"Gameplay-Einstellung kopieren", "Automatisch looten", "Nie looten"}
-- WritCreater.optionStrings["container delay"]							= "Delay Container Looting"
-- WritCreater.optionStrings["container delay tooltip"]					= "Delay the autolooting of writ reward containers when you receive them"
WritCreater.optionStrings["hide when done"]								= "Verstecke Fenster anschließend"
WritCreater.optionStrings["hide when done tooltip"]						= "Verstecke das Writ Crafter Fenster an der Handwerksstation automatisch, nachdem die Gegenstände hergestellt wurden"
WritCreater.optionStrings['reticleColour'] 								= "Fadenkreuzfarbe ändern"
WritCreater.optionStrings['reticleColourTooltip'] 						= "Ändert die Farbe des Fadenkreuzes, falls es an der Station einen unvollständigen oder abgeschlossenen Schrieb gibt"
WritCreater.optionStrings['autoCloseBank']								= "Automatischer Bankdialog"
WritCreater.optionStrings['autoCloseBankTooltip']						= "Selbstständiges Öffnen und Schließen des Bankdialoges falls Gegenstände entnommen werden müssen"
WritCreater.optionStrings["jubilee"]									= "Jubiläumsboxen öffnen"
WritCreater.optionStrings["jubilee tooltip"]							= "Eure Jubiläumsboxen 2020 werden automatisch geöffnet."
WritCreater.optionStrings['despawnBanker']								= "Bankier einstecken"
WritCreater.optionStrings['despawnBankerTooltip']						= "Bankier automatisch einstecken, nachdem Gegenstände entnommen wurden"
WritCreater.optionStrings['dailyResetWarnTime']							= "Minuten vor der Zurücksetzung"
WritCreater.optionStrings['dailyResetWarnTimeTooltip']					= "Wie viele Minuten vor der täglichen Zurücksetzung soll die Warnung angezeigt werden"
WritCreater.optionStrings['dailyResetWarnType']							= "Warnung über tägliche Zurücksetzung"
WritCreater.optionStrings['dailyResetWarnTypeTooltip']					= "Welche Art Warnung soll angezeigt werden, wenn die tägliche Zurücksetzung bevorsteht"
WritCreater.optionStrings['dailyResetWarnTypeChoices']					= { "Keine","Typ 1", "Typ 2", "Typ 3", "Typ 4", "Alle"}
WritCreater.optionStrings['stealingProtection']							= "Diebstahlschutz"
WritCreater.optionStrings['stealingProtectionTooltip']					= "Verhindert, dass du etwas stehlen kannst, solange du aktive Handwerksquests im Journal hast"
WritCreater.optionStrings['noDELETEConfirmJewelry']						= "Einfache Schmuck-Zerstörung"
WritCreater.optionStrings['noDELETEConfirmJewelryTooltip']				= "Schreibt automatisch das Wort LÖSCHEN in den Bestätigungsdialog, wenn du Schmuck zerstören möchtest"
WritCreater.optionStrings['suppressQuestAnnouncements']					= "Verstecke Handwerksquests-Hinweise"
WritCreater.optionStrings['suppressQuestAnnouncementsTooltip']			= "Versteckt den Text auf der Bildschirmmitte, wenn du Handwerksquests annimmst oder Gegenstände herstellst"
WritCreater.optionStrings['hireling behaviour']							= "Mitarbeiter Mail Aktionen"
WritCreater.optionStrings['hireling behaviour tooltip']					= "Was sollte mit Mitarbeitermails geschehen?"
WritCreater.optionStrings['hireling behaviour choices']					= { "Nichts", "Aufnehmen und löschen", "Nur aufnehmen"}
WritCreater.optionStrings["skin"]										= "Writ Crafter Aussehen"
WritCreater.optionStrings["skinTooltip"]								= "Das Aussehen der Writ Crafter Oberfläche"
WritCreater.optionStrings["skinOptions"]								= {"Default", "Käsig", "Ziege"}
WritCreater.optionStrings["goatSkin"]									= "Ziege"
WritCreater.optionStrings["cheeseSkin"]									= "Käsig"
WritCreater.optionStrings["defaultSkin"]								= "Default"

 
function WritCreater.langStationNames()
	return
	{["Schmiedestelle"] = 1, ["Schneidertisch"] = 2, 
	 ["Verzauberungstisch"] = 3,["Alchemietisch"] = 4, ["Feuerstelle"] = 5, ["Schreinerbank"] = 6, ["Schmuckhandwerkstisch"] = 7, }
end

WritCreater.cheeseyLocalizations
=
{
	--German, by Baertram, 2023-03-09
	['menuName'] = "|cFFBF00Ritual|r",
	['endeavorName'] = "Ritual Bestrebungen",
	['tasks']={
		{original="Du hast eine seltsame Broschüre gefunden ... Vielleicht solltest du sie /lesen",name="Du hast einige Anweisungen zu einem Glücksritual gelesen", completion = "Du hast gelernt wie das Glücksritual durchgeführt wird!",
			description="Verwende das /lesen Emote"},

		{original="???", name = "Beschaffe die Eingeweide einer unschuldigen Ziege", completion = "Du Monster! Alles ist für's Glück erlaubt, denke ich...",
			description="Loote Eingeweide von einer toten Ziege. Du musst nicht derjenige sein, der sie tötet ... aber das ist der einfachste Weg"},

		{original="???", name = "Begib dich zum Ritualort, Arananga", completion = "Du hast es geschafft! Es scheint ein sehr strebsamer Ort zu sein",
			description="Nicht sicher, wo Arananga liegt? Vielleicht ist es eine 'begabte' Handwerksstation ..."},

		{original="???", name = "Zerstöre die Eingeweide der Ziege", completion = "Du hast das Opfer \'verbrannt\'.",
			description="Zerstöre die |H1:item:42870:30:1:0:0:0:0:0:0:0:0:0:0:0:16:0:0:0:1:0:0|h|h welche du gelooted hast"},

		{original="???", name = "Loben Sie RNGesus im Chat", completion = "Du fühlst dich seltsam glücklich, aber vielleicht ist es nur ein Gefühl...",
			description="Sie können nicht wirklich sagen, was es tatsächlich gesagt hat, aber es ist Ihre beste Vermutung"},

		-- {original="???", name = "Complete the ritual", completion = "Maybe you'll be just a little bit luckier... And Writ Crafter has a new skin!",
		-- description="Sheogorath will be very pleased if you complete them all!"},
	},
	["goatContextTextText"] = "Ziege^f",
	["extraGoatyContextTextText"] = "Ziege",
	["extraSlash"] = "/lesen",
	['allComplete'] = "Du hast das Ritual vollendet!",
	['allCompleteSubheading'] = "Auch wenn RNGesus Sie nächstes Jahr nicht bevorzugt, hat zumindest WritCrafter einen neuen Look!",
	["bookText"] = 
[[Dieses Ritual |L0:0:0:45%%:8%%:ignore|lwird|l könnte Ihnen viel Glück bringen. Achten Sie darauf, die folgenden Schritte genau zu befolgen!
1. Beschaffe Eingeweide von |L0:0:0:45%%:8%%:ignore|leinem Schaf|l einer Ziege
2. Suche den Ort |L0:0:0:45%%:8%%:ignore|lOblivion|l Arananga auf
3. Verbrenne die Eingeweide
4. Lobe [man kann nicht sagen, was hier geschrieben steht]

- Hochachtungsvoll,
|L0:0:0:45%%:8%%:ignore|lSheogorath|l Nicht Sheogorath]],
	["bookTitle"] = "Ein Ritual für Glück",
	["outOfRange"] = "Du bist nicht mehr innerhalb des Ritual Bereiches!",
	["closeEnough"] = "Du bist nah dran",
	["praiseHint "] = "Vielleicht musst du etwas über RNGesus sagen?",
}


WritCreater.lang = "de"

WritCreater.langIsMasterWritSupported = true
-- WritCreater.needTranslations = "https://www.esoui.com/forums/showpost.php?p=41147&postcount=9"