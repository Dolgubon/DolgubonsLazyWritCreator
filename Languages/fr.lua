-----------------------------------------------------------------------------------
-- Addon Name: Dolgubon's Lazy Writ Crafter
-- Creator: Dolgubon (Joseph Heinzle)
-- Addon Ideal: Simplifies Crafting Writs as much as possible
-- Addon Creation Date: March 14, 2016
--
-- File Name: Languages/fr.lua
-- File Description: French Localization
-- Load Order Requirements: None
-- 
-----------------------------------------------------------------------------------

function WritCreater.langWritNames() --Exacts!!!  I know for german alchemy writ is Alchemistenschrieb - so ["G"] = schrieb, and ["A"]=Alchemisten
	local names = {
	["G"] = "Commande",
	[CRAFTING_TYPE_ENCHANTING] = "d'enchantement",
	[CRAFTING_TYPE_BLACKSMITHING] = "forge",
	[CRAFTING_TYPE_CLOTHIER] = "tailleur",
	[CRAFTING_TYPE_PROVISIONING] = "cuisine",
	[CRAFTING_TYPE_WOODWORKING] = "bois",
	[CRAFTING_TYPE_ALCHEMY] = "d'alchimie",
	[CRAFTING_TYPE_JEWELRYCRAFTING] = "joaillerie",
	}
	return names
end

function WritCreater.writCompleteStrings()
	local strings = {
	["place"] = "Placer les produits dans la caisse",
	["sign"] = "Signer le manifeste",
	["masterStart"] = "<Accepter le contrat>",
	["masterSign"] = "<Finir le travail.>",
	["masterPlace"] = "J'ai accompli la t",
	["Rolis Hlaalu"] = "Rolis Hlaalu",
	["Deliver"] = "Livre",
	}
	return strings
end


local function myLower(str)
	return zo_strformat("<<z:1>>",str)
end

function WritCreater.langCraftKernels()
	return 
	{
		["enchante"] = CRAFTING_TYPE_ENCHANTING,
		["forge"] = CRAFTING_TYPE_BLACKSMITHING,
		["couture"] = CRAFTING_TYPE_CLOTHIER,
		["tailleur"] = CRAFTING_TYPE_CLOTHIER,
		["cuisine"] = CRAFTING_TYPE_PROVISIONING,
		["bois"] = CRAFTING_TYPE_WOODWORKING,
		["alchimi"] = CRAFTING_TYPE_ALCHEMY,
		["joaillier"] = CRAFTING_TYPE_JEWELRYCRAFTING,
	}
end

function WritCreater.getWritAndSurveyType()
	if not WritCreater.langCraftKernels then return end
	
	local kernels = WritCreater.langCraftKernels()
	local craftType
	for kernel, craft in pairs(kernels) do
		if string.find(myLower(itemName), myLower(kernel)) then
			craftType = craft
		end
	end
	return craftType
end

function WritCreater.langMasterWritNames()
	local names = {
	["M"] 							= "magistral",
	["M1"] 							= "magistral",
	[CRAFTING_TYPE_ALCHEMY]			= "concoction",
	[CRAFTING_TYPE_ENCHANTING]		= "glyphe",
	[CRAFTING_TYPE_PROVISIONING]	= "festin",
	["plate"]						= "protection",
	["tailoring"]					= "tenue",
	["leatherwear"]					= "vêtement",
	["weapon"]						= "arme",
	["shield"]						= "bouclier",
	}
return names

end

function WritCreater.languageInfo() --exacts!!!

local craftInfo = 
	{
		[ CRAFTING_TYPE_CLOTHIER] = 
		{
			["pieces"] = --exact!!
			{
				[1] = "robe",
				[2] = "pourpoint",
				[3] = "chaussures",
				[4] = "gants",
				[5] = "chapeau",
				[6] = "braies",
				[7] = "épaulettes",
				[8] = "baudrier",
				[9] = "gilet",
				[10]= "bottes",
				[11]= "brassards",
				[12]= "casque",
				[13]= "gardes",
				[14]= "épaules",
				[15]= "ceinture",
			},
			["match"] = --exact!!! This is not the material, but rather the prefix the material gives to equipment. e.g. Homespun Robe, Linen Robe
			{
				[1] = "artisanal", --lvtier one of mats
				[2] = "lin",	--l
				[3] = "coton",
				[4] = "araignée",
				[5] = "ébonite",
				[6] = "kresh",
				[7] = "fer",
				[8] = "argent",
				[9] = "tissombre",
				[10]= "ancestrale",
				[11]= "brut",
				[12]= "peau",
				[13]= "cuir",
				[14]= "complète",
				[15]= "déchue",
				[16]= "clouté",
				[17]= "ferhide",
				[18]= "superbes",
				[19]= "ombre",
				[20]= "pourpre",
			},
			["names"] = --Does not strictly need to be exact, but people would probably appreciate it
			{
				[1] = "Jute",
				[2] = "Flax",
				[3] = "Cotton",
				[4] = "Spidersilk",
				[5] = "Ebonthread",
				[6] = "Kresh Fiber",
				[7] = "Ironthread",
				[8] = "Silverweave",
				[9] = "Void Cloth",
				[10]= "Ancestor Silk",
				[11]= "Rawhide",
				[12]= "Hide",
				[13]= "Leather",
				[14]= "Thick Leather",
				[15]= "Fell Hide",
				[16]= "Topgrain Hide",
				[17]= "Iron Hide",
				[18]= "Superb Hide",
				[19]= "Shadowhide",
				[20]= "Rubedo Leather",
			}		
		},
		[CRAFTING_TYPE_BLACKSMITHING] = 
		{
			["pieces"] = --exact!!
			{
				[1] = "hache",
				[2] = "masse",
				[3] = "épée",
				[4] = "bataille",
				[5] = "arme",
				[6] = "longue",
				[7] = "dague",
				[8] = "cuirasse",
				[9] = "solerets",
				[10] = "gantelet",
				[11] = "heaume",
				[12] = "grèves",
				[13] = "spallière",
				[14] = "gaine",
			},
			["match"] = --exact!!! This is not the material, but rather the prefix the material gives to equipment. e.g. Iron Axe, Steel Axe
			{
				[1] = "fer",
				[2] = "acier",
				[3] = "orichalque",
				[4] = "dwemer",
				[5] = "ébonite",
				[6] = "calcinium",
				[7] = "galatite",
				[8] = "mercure",
				[9] = "vide",
				[10]= "cuprite",
			},
			["names"] = --Does not strictly need to be exact, but people would probably appreciate it
			{
				[1] = "Iron Ingots",
				[2] = "Steel Ingots",
				[3] = "Orichalc Ingots",
				[4] = "Dwarven Ingots",
				[5] = "Ebony Ingots",
				[6] = "Calcinium Ingots",
				[7] = "Galatite Ingots",
				[8] = "Quicksilver Ingots",
				[9] = "Voidsteel Ingots",
				[10]= "Rubedite Ingots",
			}
		},
		[CRAFTING_TYPE_WOODWORKING] = 
		{
			["pieces"] = --Exact!!!
			{
				[1] = "arc",
				[3] = "infernal",
				[4] ="glace",
				[5] ="foudre",
				[6] ="rétablissement",
				[2] ="bouclier",
			},
			["match"] = --exact!!! This is not the material, but rather the prefix the material gives to equipment. e.g. Maple Bow. Oak Bow.
			{
				[1] = "érable",
				[2] =  "chêne",
				[3] =  "hêtre",
				[4] = "noyer",
				[5] = "if",
				[6] =  "bouleau",
				[7] = "frêne",
				[8] = "acajou",
				[9] = "nuit",
				[10] = "roux",
			},
			["names"] = --Does not strictly need to be exact, but people would probably appreciate it
			{
				[1] = "Sanded Maple",
				[2] = "Sanded Oak",
				[3] = "Sanded Beech",
				[4] = "Sanded Hickory",
				[5] = "Sanded Yew",
				[6] = "Sanded Birch",
				[7] = "Sanded Ash",
				[8] = "Sanded Mahogany",
				[9] = "Sanded Nightwood",
				[10]= "Sanded Ruby Ash",
			}
		},
		[CRAFTING_TYPE_JEWELRYCRAFTING] = 
		{
			["pieces"] = --Exact!!!
			{
				[1] = "anneau",
				[2] = "collier",

			},
			["match"] = --exact!!! This is not the material, but rather the prefix the material gives to equipment. e.g. Maple Bow. Oak Bow.
			{
				[1] = "étain", -- 1
				[2] = "cuivre", -- 26
				[3] = "argent", -- CP10
				[4] = "électrum", --CP80
				[5] = "platine", -- CP150
			},

		},
		[CRAFTING_TYPE_ENCHANTING] = 
		{
			["pieces"] = --exact!!
			{
				{"vigoureux",45833,1},
				{"vital",45831,1},
				{"magie",45832,1},
			},
			["match"] = --exact!!! The names of glyphs. The prefix (in English) So trifling glyph of magicka, for example
			{
				{"insignifiant",45855},
				{"inférieur",45856},
				{"petit",45857},
				{"léger",45806},
				{"mineur",45807},
				{"lesser",45808},
				{"modéré",45809},
				{"moyen",45810},
				{"fort",45811},
				{"bon",45812},
				{"majeur",45813},
				{"grandiose",45814},
				{"splendide",45815},
				{"monumental",45816},
				{"vraiment",{68341,68340}},
				{"superbe",{64509,64508}},
				
			},
			["quality"] = 				
			{
				{"épique",45853},
				{"légendaire",45854},
				{"", 45850} -- default, if nothing is mentioned
			}
		},
	}

	return craftInfo

end

function WritCreater.masterWritQuality()
	return {{"épique",4},{"légendaire",5}}
end


function WritCreater.langEssenceNames() --exact!

local essenceNames =  
	{
		[1] = "oko", --health
		[2] = "deni", --stamina
		[3] = "makko", --magicka
	}
	return essenceNames
end

function WritCreater.langPotencyNames() --exact!! Also, these are all the positive runestones - no negatives needed.
	local potencyNames = 
	{
		[1] = "Jora", --Lowest potency stone lvl
		[2] = "Porade",
		[3] = "Jéra",
		[4] = "Jejora",
		[5] = "Odra",
		[6] = "Pojora",
		[7] = "Edora",
		[8] = "Jaera",
		[9] = "Pora",
		[10]= "Denara",
		[11]= "Réra",
		[12]= "Dérado",
		[13]= "Rekura",
		[14]= "Kura",
		[15]= "Rejera",
		[16]= "Repora", --v16 potency stone
		
	}
	return potencyNames
end

local enExceptions = {
	["original"]  = {
		[1] = "santé",
		[2] = "vigueur",
		[3] = "magique",
	},
	["corrected"] = {
		[1] = "vital",
		[2] = "vigoureux",
		[3] = "magie",
	},
}


function WritCreater.bankExceptions(condition)
	if string.find(condition, "livrez") then
		return ""
	end
	condition = string.gsub(condition, ":", " ")
	for i = 1, #bankExceptions["original"] do
		condition = string.gsub(condition,bankExceptions["original"][i],bankExceptions["corrected"][i])
	end
	return condition
end


function WritCreater.questExceptions(condition)
	condition = string.gsub(condition, " "," ")
	condition = string.lower(condition)
	condition = string.gsub(condition,"commandes","commande")
	return condition
end

function WritCreater.enchantExceptions(condition)
	condition = string.lower(condition)
	condition = string.gsub(condition, " "," ")
	condition = string.gsub(condition,"livrez","deliver")
	for i = 1, #enExceptions["original"] do
		if string.find(condition, enExceptions["original"][i]) then
			condition = string.gsub(condition, enExceptions["original"][i],enExceptions["corrected"][i])
		end
	end
	return condition
end


function WritCreater.langTutorial(i) --sentimental
	local t = {
		[5]="Une dernière chose à savoir.\n/dailyreset est une commande vous indiquant le temps avant le reset des quêtes d'artisanat.",
		[4]="Pour finir, vous pouvez choisir d'activer ou non cet addon pour chaque profession.\nPar défaut, les fonctionnalitées sont activés.\nSi vous souhaitez les désactiver, vous pouvez le faire via le panneau d'options.",
		[3]="Vous devez également décider si cette fenêtre doit être affichée à la station d'artisanat.\nLa fenêtre vous indiquera combien de matériaux sont nécessaires la commande demande mais aussi leur nombre en votre possession.",
		[2]="Le premier paramètre est l'activation du craft automatique.\nS'il est activé lors de l'interaction avec une station d'artisanat, l'addon fabriquera automatiquement les objets requis.",
		[1]="Merci d'utiliser Dolgubon's Lazy Writ Crafter!\nIl y a quelques paramètres à définir avant de commencer.\nVous pourrez changer ceux-ci à tout moment dans le panneau d'options.",
 	}
	return t[i]
end

function WritCreater.langTutorialButton(i,onOrOff) --sentimental and short pls
	local tOn = 
	{
		[1]="Par défaut",
		[2]="Activé",
		[3]="Afficher",
		[4]="Continuer",
		[5]="Terminer",
	}
	local tOff=
	{
		[1]="Continuer",
		[2]="Désactivé",
		[3]="Ne pas afficher",
	}
	if onOrOff then
		return tOn[i]
	else
		return tOff[i]
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
			text = "|cf60000La glyphe ne peux être craftée. Vous n'avez aucune "..missing[i]
		else
			text = text.." ou "..missing[i]
		end
	end
	return text

end

WritCreater.strings = WritCreater.strings or {}

WritCreater.strings["runeReq"] 						= function (essence, potency) return zo_strformat("|c2dff00L'artisanat requiert 1 |rTa|c2dff00, 1 |cffcc66<<1>>|c2dff00 et 1 |c0066ff<<2>>|r",essence ,potency) end
WritCreater.strings["runeMissing"]						= runeMissingFunction
WritCreater.strings["notEnoughSkill"]					= "Votre compétence d’artisanat n’est pas assez élevée pour fabriquer l’équipement requis"
WritCreater.strings["smithingMissing"] 				= "\n|cf60000Vous n'avez pas assez de matériaux|r"
WritCreater.strings["craftAnyway"] 					= "Crafter quand même"
WritCreater.strings["smithingEnough"] 					= "\n|c2dff00Vous avez suffisamment de matériaux|r"
WritCreater.strings["craft"] 							= "|c00ff00Fabriquer|r"
WritCreater.strings["complete"] 						= "|c00FF00Commande réalisée.|r"
WritCreater.strings["craftingstopped"] 				= "Crat interrompu. Veuillez vérifier que l'addon a crafté le bon objet."
WritCreater.strings["crafting"] 						= "|c00ff00Fabrication ...|r"
WritCreater.strings["craftIncomplete"] 				= "|cf60000La fabrication ne peux être réalisée.\nMatériaux insuffisants.|r"
WritCreater.strings["moreStyle"] 						= "|cf60000Vous n'avez aucune pierre de style utilisable de définie|r"
WritCreater.strings["moreStyleSettings"]				= "|cf60000Vous n'avez pas de pierre de style utilisable.\nVous devriez probablement en autoriser plus dans le menu Réglages > Extensions.|r"
WritCreater.strings["moreStyleKnowledge"]				= "|cf60000Vous n'avez pas de pierre de style utilisable.\nIl se pourrait que vous ayez besoin d'apprendre à fabriquer plus de styles.|r"
WritCreater.strings["smithingReqM"] 					= function (amount, type, more) return zo_strformat( "La fabrication utilisera <<1>> <<2>> (|cf60000Vous en avez besoin de <<3>>|r)"    ,amount, type, more) end
WritCreater.strings["smithingReqM2"] 					= function (amount,type,more)     return zo_strformat( "\nMais aussi <<1>> <<2>> (|cf60000Vous en avez besoin de <<3>>|r)" ,amount, type, more) end
WritCreater.strings["smithingReq"] 					= function (amount,type, current) return zo_strformat( "La fabrication utilisera <<1>> <<2>> (|c2dff00<<3>> disponible|r)"  ,amount, type, current) end
WritCreater.strings["smithingReq2"] 					= function (amount,type, current) return zo_strformat( "\nMais aussi <<1>> <<2>> (|c2dff00<<3>> disponible|r)" ,amount, type, current) end
WritCreater.strings["dailyreset"] 						= function (till) d(zo_strformat("<<1>> heures et <<2>> minutes avant le reset journalier.",till["hour"],till["minute"])) end
WritCreater.strings["lootReceived"]					= "<<1>> a été reçu (You have <<2>>)"
WritCreater.strings["lootReceivedM"]					= "<<1>> a été reçu"
WritCreater.strings["countSurveys"]					= "Vous avez <<1>> repérages"
WritCreater.strings["countVouchers"]					= "Vous avez <<1>> Coupons de Commande non-acquis"
WritCreater.strings["includesStorage"]				= "Le total inclus <<1>> qui sont dans les coffres de domicile"
WritCreater.strings["surveys"]						= "Repérages d'artisanat"
WritCreater.strings["sealedWrits"]					= "Commandes scellées"
WritCreater.strings["withdrawItem"]				= function(amount, link, remaining) return "Dolgubon's Lazy Writ Crafter a récupéré " .. amount .. " " .. link .. " (reste en banque : " .. remaining .. ")." end -- in Bank for German
WritCreater.strings['fullBag']						= "Vous n’avez plus de place dans votre sac. Merci de le vider."
WritCreater.strings['masterWritSave']				= "Dolgubon's Lazy Writ Crafter vous a évité d’accepter accidentellement une commande de maître ! Allez dans le menu Réglages > Extensions pour désactiver cette option."
WritCreater.strings['missingLibraries']			= "Dolgubon's Lazy Writ Crafter a besoin des librairies indépendantes suivantes. Merci de télécharger, installer ou activer ces librairies :"
WritCreater.strings['resetWarningMessageText']		= "La réinitialisation quotidienne des commandes aura lieu dans <<1>> heure(s) et <<2>> minute(s).\nVous pouvez personnaliser ou désactiver cet avertissement dans les réglages."
WritCreater.strings['resetWarningExampleText']		= "L’avertissement ressemblera à ça"



local DivineMats =
{
	{"Ghost Eyes", "Vampire Hearts", "Werewolf Claws", "'Special' Candy", "Chopped Hands", "Zombie Guts", "Bat Livers", "Lizard Brains", "Witches Hats", "Distilled Boos", "Singing Toads"},
	{"Sock Puppets", "Jester Hats", "Pure Laughter", "Tempering Alloys", "Red Herrings", "Rotten Tomatoes", "Pint Real Axe Links", "Crowned Imposters", "Mudpies"},
	{"Fireworks", "Presents", "Crackers", "Reindeer Bells", "Elven Hats", "Pine Needles", "Essences of Time", "Ephemeral Lights"},

}

local function shouldDivinityprotocolbeactivatednowornotitshouldbeallthetimebutwhateveritlljustbeforabit()
	if true then return false end
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

WritCreater.optionStrings.nowEditing                   = "Vous modifier le réglage de %s"
WritCreater.optionStrings.accountWide                  = "Configuration Globale"
WritCreater.optionStrings.characterSpecific            = " Configuration Specifique par personnage"
WritCreater.optionStrings.useCharacterSettings         = "Utiliser des options de personnage" -- de
WritCreater.optionStrings.useCharacterSettingsTooltip  = "Utilise des options spécifiques pour ce personnage uniquement" --de

WritCreater.optionStrings["style tooltip"]                            = function (styleName, styleStone) return zo_strformat("Allow the <<1>> style, which uses <<2>> to be used for crafting",styleName) end 
WritCreater.optionStrings["show craft window"]                        = "Afficher la fenêtre de craft"
WritCreater.optionStrings["show craft window tooltip"]                = "Afficher la fenêtre de craft automatique lorsque la station d'artisanat est ouverte"
WritCreater.optionStrings["autocraft"]                                = "Craft automatique"
WritCreater.optionStrings["autocraft tooltip"]                        = "Activer cette option lancera automatiquement la fabrication des objets lors de l'interaction avec la station d'artisanat. Si la fenêtre n'est pas affichée, cette option sera activée."
WritCreater.optionStrings["blackmithing"]                             = "Forge"
WritCreater.optionStrings["blacksmithing tooltip"]                    = "Activer l'addon à la forge"
WritCreater.optionStrings["clothing"]                                 = "Tailleur"
WritCreater.optionStrings["clothing tooltip"]                         = "Activer l'addon au tailleur"
WritCreater.optionStrings["enchanting"]                               = "Enchantement"
WritCreater.optionStrings["enchanting tooltip"]                       = "Activer l'addon à la table d'enchantement"
WritCreater.optionStrings["alchemy"]                                  = "Alchimie"
WritCreater.optionStrings["alchemy tooltip"]   	                  	  = "Activer l'addon à la table d'alchimie"
WritCreater.optionStrings["provisioning"]                             = "Cuisine"
WritCreater.optionStrings["provisioning tooltip"]                     = "Activer l'addon à la table cuisine"
WritCreater.optionStrings["woodworking"]                              = "Travail du Bois"
WritCreater.optionStrings["woodworking tooltip"]                      = "Activer l'addon pour le travail du bois"
WritCreater.optionStrings["jewelry crafting"]							= "Joaillerie"
WritCreater.optionStrings["jewelry crafting tooltip"]					= "Activer l'addon pour Joaillerie"
WritCreater.optionStrings["style stone menu"]                         = "Utilisation des matériaux de style"
WritCreater.optionStrings["style stone menu tooltip"]                 = "Sélectionnez quelles pierres de style utiliser"
WritCreater.optionStrings["exit when done"]							  = "Quitter l'atelier lorsque terminé"
WritCreater.optionStrings["exit when done tooltip"]					  = "Quitter l'atelier automatiquement lorsque toutes les fabrications ont été réalisées"
WritCreater.optionStrings["automatic complete"]						  = "Interactions automatiques de quêtes"
WritCreater.optionStrings["automatic complete tooltip"]				  = "Accepte et valide automatiquement les quêtes en interagissant avec les panneaux et coffres d'artisanat."
WritCreater.optionStrings["new container"]							  = "Conserver le statut nouveau"
WritCreater.optionStrings["new container tooltip"]					  = "Conserver le statut nouveau pour les conteneurs de récompenses de commande"
WritCreater.optionStrings["master"]									  = "Commandes de maître"
WritCreater.optionStrings["master tooltip"]							  = "Désactiver l’extension pour les Commandes de maître"
WritCreater.optionStrings["right click to craft"]						= "Clic-Droit pour Fabriquer"
WritCreater.optionStrings["right click to craft tooltip"]				= "Si cela est sur ON, l’extension fabriquera les commandes de maître que vous lui dites de faire après avoir clic-droit sur une commande scellée"
WritCreater.optionStrings["crafting submenu"]							= "Fabrication des objets de commande"
WritCreater.optionStrings["crafting submenu tooltip"]					= "Désactiver l’extension pour des commandes spécifiques"
WritCreater.optionStrings["timesavers submenu"]							= "Économies de temps"
WritCreater.optionStrings["timesavers submenu tooltip"]					= "Divers économies de temps"
WritCreater.optionStrings["loot container"]						  		= "Ouvrir le conteneur quand reçu"
WritCreater.optionStrings["loot container tooltip"]				  		= "Ouvrir le conteneur de récompenses de commande lorsque vous les recevez"
WritCreater.optionStrings["master writ saver"]							= "Sauvegarder commande de maître"
WritCreater.optionStrings["master writ saver tooltip"]					= "Empêcher l’acceptation de Commande de maître"
WritCreater.optionStrings["loot output"]								= "Alerte sur les récompenses précieuses"
WritCreater.optionStrings["loot output tooltip"]						= "Afficher un message lorsque des objets de grande valeur sont reçus d'une commande d'artisanat"
WritCreater.optionStrings["writ grabbing"]								= "Prendre les matériaux de commande"
WritCreater.optionStrings["writ grabbing tooltip"]						= "Prendre les matériaux requis pour les commandes (ex. Nirnroot, Ta, etc.) de la banque" 
WritCreater.optionStrings["autoloot behaviour"]							= "Loot automatique"
WritCreater.optionStrings["autoloot behaviour tooltip"]					= "Sélectionner comment l'addon loote les conteneurs de récompense de quête"
WritCreater.optionStrings["autoloot behaviour choices"]					= {"Paramètres du menu d'options Gameplay", "Loot automatique", "Ne pas looter"}
WritCreater.optionStrings["style tooltip"]                            = function (styleName, styleStone) return zo_strformat("Autoriser le style <<1>> , qui utilise <<2>> lors de la création",styleName) end 
WritCreater.optionStrings["hide when done"]								= "Cacher quand terminé"
WritCreater.optionStrings["hide when done tooltip"]						= "Cacher la fenêtre de l'extension quand tous les objets ont été fabriqués"
WritCreater.optionStrings['reticleColour']								= "Changer la couleur du réticule"
WritCreater.optionStrings['reticleColourTooltip']						= "Change la couleur du réticule si vous avez une commande, terminée ou non, à l’atelier"
WritCreater.optionStrings['autoCloseBank']								= "Dialogue automatique à la banque"
WritCreater.optionStrings['autoCloseBankTooltip']						= "Entre et sort automatiquement du dialogue à la banque, s’il y a des objet à en retirer"
WritCreater.optionStrings['despawnBanker']								= "Renvoyer le banquier"
WritCreater.optionStrings['despawnBankerTooltip']						= "Renvoie automatiquement l’assistant banquier après avoir retiré les objets"
WritCreater.optionStrings['dailyResetWarnTime']							= "Minutes avant réinitialisation"
WritCreater.optionStrings['dailyResetWarnTimeTooltip']					= "Combien de minutes avant la réinitialisation quotidienne l’avertissement doit être affiché"
WritCreater.optionStrings['dailyResetWarnType']							= "Avertissement de réinitialisation quotidienne"
WritCreater.optionStrings['dailyResetWarnTypeTooltip']					= "Quel type d’avertissement doit être affiché quand la réinitialisation des quêtes quotidienne est sur le point d’avoir lieu"
WritCreater.optionStrings['dailyResetWarnTypeChoices']					={ "Aucun", "Type 1", "Type 2", "Type 3", "Type 4", "Tous"}
WritCreater.optionStrings['stealingProtection']							= "Protection contre le vol"
WritCreater.optionStrings['stealingProtectionTooltip']					= "Vous empêche de voler tant qu’une commande est dans votre journal"
WritCreater.optionStrings['noDELETEConfirmJewelry']						= "Destruction de joaillerie facile"
WritCreater.optionStrings['noDELETEConfirmJewelryTooltip']				= "Ajouter automatiquement le texte de confirmation DETRUIRE à la boîte de dialogue de destruction de joaillerie"
WritCreater.optionStrings['suppressQuestAnnouncements']					= "Cacher les annonces de quête des commandes"
WritCreater.optionStrings['suppressQuestAnnouncementsTooltip']			= "Cache le texte au centre de l’écran quand vous commencez une commande, ou que vous créez un objet pour une commande."



WritCreater.optionStrings["questBuffer"]								= "Tampon Quête de Commande"
WritCreater.optionStrings["questBufferTooltip"]							= "Conserver un tampon de quêtes pour que vous puissiez toujours avoir de l’espace pour prendre des commandes"
WritCreater.optionStrings["craftMultiplier"]							= "Multiplicateur Fabrication"
WritCreater.optionStrings["craftMultiplierTooltip"]						= "Fabriquer plusieurs copies de chaque objet requis pour que vous n’ayez pas besoin de les refabriquer la prochaine fois que la commande apparait. Note: Sauvegarder approximativement 37 espaces pour chaque augmentation au-dessus de 1"
WritCreater.optionStrings['hireling behaviour']							= "Actions Courrier Fournisseur"
WritCreater.optionStrings['hireling behaviour tooltip']					= "Ce qui devrait être fait avec les courriers de fournisseur"
WritCreater.optionStrings['hireling behaviour choices']					= { "Rien","Piller et Supprimer ", "Piller seulement"}


WritCreater.optionStrings["allReward"]									= "Tous les Artisanats"
WritCreater.optionStrings["allRewardTooltip"]							= "Action à prendre pour tous artisanats"

WritCreater.optionStrings['sameForALlCrafts']							= "Utiliser la même option pour tout"
WritCreater.optionStrings['sameForALlCraftsTooltip']					= "Utiliser la même option pour les récompenses de ce type pour tous les artisanats"
WritCreater.optionStrings['1Reward']									= "Forge"
WritCreater.optionStrings['2Reward']									= "Utiliser pour tout"
WritCreater.optionStrings['3Reward']									= "Utiliser pour tout"
WritCreater.optionStrings['4Reward']									= "Utiliser pour tout"
WritCreater.optionStrings['5Reward']									= "Utiliser pour tout"
WritCreater.optionStrings['6Reward']									= "Utiliser pour tout"
WritCreater.optionStrings['7Reward']									= "Utiliser pour tout"

WritCreater.optionStrings["matsReward"]									= "Récompenses Matériel d'artisanat"
WritCreater.optionStrings["matsRewardTooltip"]							= "Quoi faire avec les récompenses de matériel d’artisanat "
WritCreater.optionStrings["surveyReward"]								= "Récompenses Repérages"
WritCreater.optionStrings["surveyRewardTooltip"]						= "Quoi faire avec les récompenses repéragess"
WritCreater.optionStrings["masterReward"]								= "Récompenses Commande de Maître"
WritCreater.optionStrings["masterRewardTooltip"]						= "Quoi faire avec les récompenses de commande de maître"
WritCreater.optionStrings["repairReward"]								= "Récompenses Nécessaires de Réparation"
WritCreater.optionStrings["repairRewardTooltip"]						= "Quoi faire avec les récompenses de nécessaires de réparation"
WritCreater.optionStrings["ornateReward"]								= "Récompenses d’Équipement Orné"
WritCreater.optionStrings["ornateRewardTooltip"]						= "Quoi faire avec les récompenses d’équipement orné"
WritCreater.optionStrings["intricateReward"]							= "Récompenses Équipement Complexe"
WritCreater.optionStrings["intricateRewardTooltip"]						= "Quoi faire avec les récompenses d’équipement complexe"
WritCreater.optionStrings["soulGemReward"]								= "Pierres d’âme vides"
WritCreater.optionStrings["soulGemTooltip"]								= "Quoi faire avec des pierres d’âme vides"
WritCreater.optionStrings["glyphReward"]								= "Glyphes"
WritCreater.optionStrings["glyphRewardTooltip"]							= "Quoi faire avec des glyphes"
WritCreater.optionStrings["recipeReward"]								= "Recettes"
WritCreater.optionStrings["recipeRewardTooltip"]						= "Quoi faire avec les recettes"
WritCreater.optionStrings["fragmentReward"]								= "Fragments Psijiques"
WritCreater.optionStrings["fragmentRewardTooltip"]						= "Quoi faire avec les fragments psijiques"


WritCreater.optionStrings["writRewards submenu"]						= "Gestion Récompense Commande"
WritCreater.optionStrings["writRewards submenu tooltip"]				= "Quoi faire avec toutes les récompenses de commandes"

WritCreater.optionStrings["jubilee"]									= "Piller Boîtes d’Anniversaire"
WritCreater.optionStrings["jubilee tooltip"]							= "Piller Automatiquement Boîtes d’Anniversaire"
WritCreater.optionStrings["skin"]										= "Peau Writ Crafter"
WritCreater.optionStrings["skinTooltip"]								= "La peau pour l'interface Writ Crafter"
WritCreater.optionStrings["skinOptions"]								= {"Défaut", "Gratiné"}

WritCreater.optionStrings["rewardChoices"]								= {"Rien","Déposer","Rebut", "Détruire"}


function WritCreater.langStationNames()
	return
	{["Atelier de forge"] = 1, ["Atelier de couture"] = 2, 
	 ["Table d'enchantement"] = 3,["Établi d'alchimie"] = 4, ["Feu de cuisine"] = 5, ["Atelier de travail du bois"] = 6, ["Atelier de joaillerie"] = 7, }
end

function WritCreater.langWritRewardBoxes () return {
	[1] = "Récipient d'alchimiste",
	[2] = "coffre d'enchanteur",
	[3] = "paquet de cuisinier",
	[4] = "caisse de forgeron",
	[5] = "sacoche de tailleur",
	[6] = "caisse de travailleur du bois",
	[7] = "coffre de joailler",
	[8] = "cargaison",
}
end

WritCreater.cheeseyLocalizations
=
{
	['reward'] = "-1 Santé mentale",
	['rewardStylized'] = "-1 |cFFFFFF[Santé mentale]|",
	['finalReward'] = "Complétez-les tous et découvrez par vous-même!",
	['menuName'] = "Gratiné",
	['endeavorName'] = "Efforts Gratinés",
	['tasks']={
		{name = "Professez votre amour pour le fromage", completion = "Maintenant le monde entier sait combien vous adorez le fromage!", 
			description="Dites 'J’adore le fromage!' dans le chat", },
		{name = "Visitez l’Oncle Shéo", completion = "L’Oncle Shéo est heureux de vous avoir vu! Et triste. Et gratiné. Et dynamique!", 
			description="Trouvez et parlez à Shéogorath. Il se sent seul et a envie de vous revoir!"},
		{name = "Jouez de la musique terrible", completion = "Aouch! Vos oreilles ont mal dû à cette terrible musique.", description="Utilisez une émote de musique", 
},
		{name = "Jetez du fromage", completion = "Vous avez jeté du fromage. Il était probablement moisi de toute façon...", description="Détruisez 1 |H1:item:27057:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h. Oui, c’est fou, mais c’est le but!", 
},
		{ name = "Lisez un livre gratiné", completion = "Quelle chaussette réconfortante. Fromage - non, je veux dire livre!",
            description="Lisez le livre <lien d’objet pour le livre |H0:item:121046:364:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:10000:0|h|h",},
		{name = "Complétez tous les autres Efforts Gratinés", completion = "Fromage! Fromage! Du fromage partout! Même... en faisant des commandes?", description="Shéogorath sera très heureux si vous les complétez tous!"
},
	},
	['allComplete'] = "Tous les efforts gratinés complétés!",
	['chatbingo'] = "jadorelefromage",
	["cheatyCheeseBook"] = "Peut-être devenez-vous fou, mais vous ne semblez pas reconnaître ce livre...",
}



function WritCreater.getTaString()
	return "ta"
end

WritCreater.lang = "fr"

-- WritCreater.needTranslations = "https://www.esoui.com/forums/showpost.php?p=41147&postcount=9"