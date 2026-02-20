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
WritCreater.strings['fullBag']									= "Du hast keinen Platz mehr im Inventar. Bitte leere dein Inventar."
WritCreater.strings['masterWritSave']							= "Dolgubon's Lazy Writ Crafter hat verhindert, dass du versehentlich einen Meisterschrieb annimmst. Gehe in die Erweiterungseinstellungen, um diese Option zu deaktivieren."
WritCreater.strings['missingLibraries']							= "Dolgubon's Lazy Writ Crafter requires the following standalone libraries. Please download, install or turn on these libraries: "
WritCreater.strings['resetWarningMessageText']					= "Die täglichen Handwerksquests werden in <<1>> Stunde und <<2>> Minute zurückgesetzt\nDu kannst diese Warnung in den Einstellungen anpassen oder deaktivieren"
WritCreater.strings['resetWarningExampleText']					= "Die Warnung wird so aussehen"
WritCreater.strings["withdrawItem"]								= function(amount, link, remaining) return "Dolgubon's Lazy Writ Crafter entnahm "..amount.." "..link..". (Noch "..remaining.." in der Bank)" end -- in Bank for German
WritCreater.strings["writBufferNotification"] 					= "Der Schrieb-Quest-Puffer des Lazy Writ Crafter™ hindert Euch daran, diese Aufgabe anzunehmen" --- Kontextural anders formulieren ---- "
WritCreater.strings["welcomeMessage"] 							= "Danke, dass Ihr Dolgubon's Lazy Writ Crafter installiert habt. Bitte ruft die Einstellungen auf, um das Addon auf Eure Vorlieben anzupassen"
WritCreater.strings["transmuteLooted"] 							= "<<1>> Transmute Stone recieved (You have <<2>>) <<1>> Transmut Kristall erhalten (Ihr habt <<2>>)" ---- mit dem benutzten Wort im deutschsprachigen Spiel abgleichen -----"
WritCreater.strings["transmuteLimitHit"] 						= "Das Einsammeln dieser Transmut-Kristalle übersteigt Euer Maximum! Nicht eingesammelte Kristalle: <<1>>"  ---- umformuliert, um mengenabhängige Unterschiede zu vermeiden --------"
WritCreater.strings["transmuteLimitApproach"] 					= "Euer Transmut-Kristall-Limit ist fast erreicht. Beim nächsten Behälter wird Writ-Crafter die [übersteigenden} Kristalle nicht einsammeln" ----- Kontext klären - anteilig nicht oder gar nicht ----- "
WritCreater.strings["statsWitsDone"] 							= "Hergestellte Schriebe: <<1>> in den letzten <<2>> Tagen"
WritCreater.strings["provisioningUnknownRecipe"] 				= "Ihr kennt das Rezept für <<1>> nicht"
WritCreater.strings["provisioningCraft"] 						= "Writ Crafter stellt <<1>> her"
WritCreater.strings["pressToCraft"] 							= "Zum Herstellen drückt |t32:32:<<1>>|t"



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
WritCreater.optionStrings["style stone menu"]							= "Stilmaterial"
WritCreater.optionStrings["style stone menu tooltip"]					= "Wähle aus, welches Stilmaterial benutzt werden soll."
WritCreater.optionStrings["exit when done"]								= "Schließe Handwerksfenster"
WritCreater.optionStrings["exit when done tooltip"]						= "Schließe Handwerksfenster nachdem alle Aufgaben abgeschlossen sind"
WritCreater.optionStrings["automatic complete"]							= "Automatischer Quest Dialog"
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
WritCreater.optionStrings["writStatsTooltip"]							= "Belohnungs-Statistik für Schriebe, die Ihr mithilfe des Addon hergestellt habt"
WritCreater.optionStrings["writStatsButton"] 							= "Öffnet das Addon-Menüfenster"
WritCreater.optionStrings["writStats"]									= "Schrieb-Statistik"
WritCreater.optionStrings["writRewards submenu tooltip"]				= "Was Ihr mit den Schrieb-Belohnungen tun könnt"
WritCreater.optionStrings["writRewards submenu"] 						= "Einstellungen für die Behandlung von Schrieb-Belohnungen"
WritCreater.optionStrings["transparentStatusBarTooltip"] 				= "Macht die Statusleiste transparent"
WritCreater.optionStrings["transparentStatusBar"] 						= "Transparente Statusleiste"
WritCreater.optionStrings["surveyRewardTooltip"] 						= "Wie mit Fundberichten umgegangen werden soll"
WritCreater.optionStrings["surveyReward"] 								= "Fundbericht-Belohnungen"
WritCreater.optionStrings["statusBarVerticalTooltip"] 					= "Vertikale Position auf der Statusleiste"
WritCreater.optionStrings["statusBarVertical"] 							= "Vertikale Position"
WritCreater.optionStrings["statusBarInventoryTooltip"] 					= "Fügt der Statusleiste einen Inventar-Tracker zu"
WritCreater.optionStrings["statusBarInventory"] 						= "Inventar-Tracker"
WritCreater.optionStrings["statusBarIconsTooltip"] 						= "Zeigt anstelle von Buchstaben Handwerkssymbole für jeden Schriebtypus an"
WritCreater.optionStrings["statusBarIcons"] 							= "Verwende Symbole"
WritCreater.optionStrings["statusBarHorizontalTooltip"]					= "Horizontale Position der Statusleiste"
WritCreater.optionStrings["statusBarHorizontal"]						= "Horizontale Position"
WritCreater.optionStrings["status bar submenu tooltip"]					= "Optionen für die Schrieb Statusleiste"
WritCreater.optionStrings["status bar submenu"]							= "Statusleiste"
WritCreater.optionStrings["soulGemTooltip"] 							= "Wie leere Seelensteine behandelt werden"
WritCreater.optionStrings["soulGemReward"] 								= "Leere Seelensteine"
WritCreater.optionStrings["smartMultiplierTooltip"] 					= "Eingeschaltet: Herstellung von Gegenständen für den vollen 3-Tages-Zyklus. Bereits vorhandene Gegenstände werden dabei berücksichtigt. Ausgeschaltet: Herstellung mehrere Gegenstände gemäß der Quest des Tages"
WritCreater.optionStrings["smartMultiplier"] 							= "Smart Multiplier"
WritCreater.optionStrings["smart style slot save tooltip"] 				= "Versucht, bei nicht ESO+ Anwendung Slots (Inventarplätze) einzusparen, indem bei Stilsteinen kleine Stapel zuerst verbraucht werden"
WritCreater.optionStrings["smart style slot save"] 						= "Geringste Anzahl zuerst"
WritCreater.optionStrings["showStatusBarTooltip"] 						= "Zeigt oder verbirgt die Anzeige für den Quest-Status"
WritCreater.optionStrings["showStatusBar"] 								= "Zeigt die Status-Leiste an"
WritCreater.optionStrings["scan for unopened tooltip"] 					= "Scannt beim Einloggen das Inventar nach ungeöffneten Meisterschrieb-Behältern und versucht sie zu entpacken"
WritCreater.optionStrings["scan for unopened"] 							= "Öffnet Container bei Login"
WritCreater.optionStrings["sameForALlCraftsTooltip"] 					= "Wendet die Regel für diesen Typ von Belohnung auf alle Handwerke an"
WritCreater.optionStrings["sameForALlCrafts"] 							= "Gleiche Regel für alle Handwerke"
WritCreater.optionStrings["rewardChoices"] 								= {"Nichts","Einlagern","Junk","Zerstöre","Zerlege"} ---- prüfe Junk auf deutschen Begriff -----"
WritCreater.optionStrings["reportBugTooltip"] 							= "Öffne einen Thread um speziell für die Konsolenversion des Writ Crafter Bugs zu berichten. Bitte prüft zuvor, ob der Fehler bereits berichtet worden ist."
WritCreater.optionStrings["reportBug"] 									= "Meldet einen Bug"
WritCreater.optionStrings["repairRewardTooltip"] 						= "Wie werden belohnte Reparatur-Kits behandelt"
WritCreater.optionStrings["repairReward"] 								= "Belohnte Reparatur-Kits"
WritCreater.optionStrings["recipeRewardTooltip"] 						= "Behandlung von Rezepten"
WritCreater.optionStrings["recipeReward"] 								= "Rezepte"
WritCreater.optionStrings["queueWritsTooltip"] 							= "Stellt alle verschlossenen Meisterschriebe des Inventars in die Warteschlange"
WritCreater.optionStrings["queueWritsButton"] 							= "Warteschlange"
WritCreater.optionStrings["queueWrits"] 								= "Stelle alle versiegelten Schriebe an"
WritCreater.optionStrings["questBufferTooltip"] 						= "Halte einen Quest-Puffer vor, so dass täglich alle Handwerksquests angenommen werden können"
WritCreater.optionStrings["questBuffer"] 								= "Questpuffer für tägliches Handwerk"
WritCreater.optionStrings["ornateRewardTooltip"] 						= "Wie wird mit 'ornate gear' - Belohnungen umgegangen"  ------ Spielvokabel für ornate und gear rausfinden -------"
WritCreater.optionStrings["ornateReward"] 								= "Ornate Gear-Belohnungen"
WritCreater.optionStrings["openUrlButtonText"] 							= "Öffne URL"

 


function WritCreater.langStationNames()
	return
	{["Schmiedestelle"] = 1, ["Schneidertisch"] = 2, 
	 ["Verzauberungstisch"] = 3,["Alchemietisch"] = 4, ["Feuerstelle"] = 5, ["Schreinerbank"] = 6, ["Schmuckhandwerkstisch"] = 7, }
end

WritCreater.cheeseyLocalizations
=
{ -- DE / German by Baertram 20260214
	['menuName'] = "|cFFBF00Pyrit-Vorhaben|r",
	['initialDescription'] = "Wie wäre es denn, wenn du einfach zuerst die Broschüre /liest?",
	['readDescription'] = "Nachdem der Herr der Kreativen herausgefunden hat, dass sein Oberhandwerker ein Handwerks-Helfer Add-On verwendet hat, um Müll zu erzeugen, sucht er nun einen neuen Oberhandwerker. Versuche dein Glück und bewirb dich!",
	['endeavorName'] = "Pyrit-Vorhaben", -- Pyrite, aka Fool's Gold. Play on Fool = Crazy =  Sheogorath, Fool in April Fools, and Golden Pursuits, bc that's where this lives
	['rewardName'] = "-1 Wahnsinn",
	['completionShout'] = "<<1>>/<<2>> |cFFBF00Pyrit-Vorhaben|r abgeschlossen!", -- z. B. 1/6 Pyrit-Vorhaben abgeschlossen!
	['tasks']={

		-- Lord of the creatives, trickster, lord of the dranged, fourth corner, lord of the never there, and Dam Dog (Mad God backwards) are all names for sheogorath.
		-- Translations can use any nickname for him, Uncle Sheo, or just do Sheogorath if you can't find/don't know any

		-- Original: Shown prior to the completion of the first task
		-- Name: Shown in the pursuits window
		-- placehold: shown in place of name after completion (if present)
		-- completion: Shown as a popup when task is complete
		-- Description: Long form description. Should explain exactly what needs to be done. Shown as a tooltip on PC
		-- completedDescription: description after completion
		{original="Du hast eine Broschüre mit dem Titel 'Hilfe gesucht' gefunden ... Vielleicht solltest du sie lesen",name="/Lies die gefundene Broschüre",placehold="Du hast eine Broschüre mit dem Titel 'Hilfe gesucht' vom Herrn der Kreativen gefunden", completion = "Scheint, als ob der Herr der Kreativen Leute sucht?",
		 description="Du hast eine Broschüre mit der Aufschrift 'Hilfe gesucht' gefunden. Du kannst die Emote /lies verwenden, um sie zu lesen", completedDescription="Du hast die Broschüre gelesen"},

		{original="???", name = "Stelle einen RäuberJack her", completion = "Er verwandelt vielleicht niemanden in Käse, aber er verändert trotzdem deinen Look!",
		 description="Der Trickster verwandelt gerne Dinge. Verwandle dich in einen Räuber, indem du eine Jack(e) aus dem Set 'Kühner Korsar' herstellst.",
		 completedDescription="Vielleicht wird der Robbajack mit der Zeit genauso mächtig wie der Wabbajack."}, -- benötigt 3 Eigenschaften

		{original="???", name = "Stelle das Amulett des Blings her", completion = "Diese Halskette würde dir bestimmt fabelhaft stehen! Wenn du sie nur sehen könntest, wenn du sie trägst.",
		 description="Der Herr der Verrückten ist reich! Zeig ihm, dass du seinen Reichtum nutzen kannst, indem du eine Elektrum-Halskette herstellst.",
		 completedDescription="Obwohl sie aus echtem Metall besteht, scheint sie zu verschwinden, wenn du sie trägst ... ein Zeichen der Macht, vielleicht?"},

		{original="???", name = "Stelle die Ebenklinge her", completion = "Sollte die Klinge nicht deine Seele stehlen oder so? Vielleicht hast du sie falsch hergestellt.",
		 description="Die Vierte Säule würde die Fähigkeit der Ebenklinge, ihre Benutzer in den Wahnsinn zu treiben, nur allzu gerne nachahmen. Zeig, dass du helfen kannst, indem du eine Klingenwaffe aus Ebenerz herstellst.",
		 completedDescription="Die Ebenklinge. So ein unscheinbarer Name für so eine ... Eigentlich ist diese Klinge ziemlich gewöhnlich, also passt der Name perfekt."},

		{original="???", name = "Stelle einen Stab von Magnus |L0:0:0:40%%:20%%:|lGabet|l", completion = "Die Macht von Magnus |L0:0:0:40%%:20%%:|lGabe|l gehört dir!",
		 description="Der leitende Handwerker des Herrn des Nimmerda muss in der Lage sein, |L0:0:0:50%%:10%%:|lmächtige|l Stäbe herzustellen. Stelle einen Stab aus dem Magnus-Gabe Set her.",
		 completedDescription="Leider hat das Ignorieren des lästigen |L0:0:0:50%%:10%%:|lGabe|l im Namen ihn nicht särker gemacht."}, -- benötigt 4 Eigenschaften

		{original="???", name = "Bake 1 Cheesecake is a lie", completion = "KÄÄÄÄÄÄSEkuchen.. Er sieht definitiv echt genug aus",
		 description="Verdammte Hunde lieben es, Käsekuchen zu essen! Ein leitender Handwerker müsste den BESTEN Kuchen backen",completedDescription="Du hast einen Käsekuchen kreiert und bist dir ziemlich sicher, dass er echt ist."
		},
	},
	["unknownMonumentalTask"] = "Lies die Broschüre, um die Aufgabe zu enthüllen.",
	['claimRewardHeader'] = "Hoffentlich hattest du Spaß bei deinen |cFFBF00Pyrite Vorhaben|r!",
	['claimRewardSubheading'] = "Sieh dir das neue Design von Writ Crafter an, wenn du das nächste Mal Aufträge erledigst!",

		-- Note for translations: The list contains some wordplay on various daedric artefacts or other jokes
		-- Robber's Jack: Sounds like Wabbajack. Satisfied by creating a Jack from one of: the Redistributor set, the Daedric trickery set, or the Daring corsair set
		-- Amulet of Blings: Rhymes with Amulet of Kings. Satisfied by creating an electrum necklace
		-- Totally real ebony blade: Refers to the ebony blade (Mephala artefact, from crypt of hearts). Satisfied by, you guessed it, an ebony blade
		-- Staff of Magnus Gift: Gift is crossed out. Refers to the Staff of Magnus. Satisfied by a staff from the Magnus Gift set
		-- Cheesecake is a lie: Refers to 'the cake is a lie' and Sheogorath liking cheese. Satisfied by making a cheesecake
	["bookText"] =
	[[
	Nachdem er herausgefunden hat, dass sein Oberhandwerker ein Handwerks-Helfer Add-On verwendet hat, um Müll zu erzeugen, sucht er nun einen neuen Oberhandwerker. Versuche dein Glück und bewirb dich! (Er hat zwar noch einen Chefhandwerker, aber der ist ohne Körper dorch irgendwie ziemlich nutzlos.)

	Um sich zu bewerben, fertige bitte Folgendes:
	1 Räuber Jack
	1 Amulett des Blings
	1 Absolut echte Ebenklinge
	1 Stab von Magnus |L0:0:0:40%%:20%%:|lGabe|l
	1 Cheese'cake is a lie'
	]],

	["bookTitle"] = "Hilfe gesucht",

	["superAmazingCraftSounds"] = { -- wird beim Herstellen zufällig angezeigt
		{"KLANG","KLING","KLINK","KLUNK","DÄNGEL"}, -- Schmiedekunst
		{"SCHNIPPEL","RASCHEL"}, -- Kleidung
		{"ALAKAZAM","ABRACADABRA","HOCUS POCUS FIDIBUS"}, -- Verzauberung
		{"SPLISCH","SPLASCH","PLOP","GLUCKS"}, -- Alchemie
		{"KÖCHEL","BLUBB, BLUBB"}, -- Kochen
		{"BZZZZ","SÄG","KNACK","WRRRRR"}, -- Holzbearbeitung
		{"TING","BLING","PING"}, -- Schmuck
	},
	["extraSlash"] = "/lies", -- Falls Ihre Sprache eine Übersetzung für /read hat, fügen Sie sie hier ein.
}


WritCreater.lang = "de"

WritCreater.langIsMasterWritSupported = true
-- WritCreater.needTranslations = "https://www.esoui.com/forums/showpost.php?p=41147&postcount=9"