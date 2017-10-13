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
	}
	return names
end

function WritCreater.writCompleteStrings()
	local strings = {
	["place"] = "Placer les produits dans la caisse",
	["sing"] = "Signer le manifeste",
	["masterStart"] = "<Accepter le contrat>",
	["masterSign"] = "<Finir le travail.>",
	["masterPlace"] = "J'ai accompli la t",
	}
	return strings
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
				[14]= "d'épaules",
				[15]= "ceinture",
			},
			["match"] = --exact!!! This is not the material, but rather the prefix the material gives to equipment. e.g. Homespun Robe, Linen Robe
			{
				[1] = "artisanal", --lvtier one of mats
				[2] = "lin",	--l
				[3] = "coton",
				[4] = "d'araignée",
				[5] = "d'ébonite",
				[6] = "kresh",
				[7] = "fer",
				[8] = "d'argent",
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
				[19]= "d'ombre",
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
				[5] = "d'arme",
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
				{"superbe",{64509,64508}},
				{"vraiment",{68341,68340}},
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

local exceptions = -- This is a slight misnomer. Not all are corrections - some are changes into english so that future functions will work
{
	["original"] = {
	[1] = "artisanales",
	[2] = "artisanale",
	[3] = "artisanaux",
	[5] = "dwemère",
	[4] = "dwemères",
	[6] = "dwemers",
	[7] = "brutes",
	[8] = "brute",
	[9] = "bruts",
	[10]= "cuir brut",
	[11]= "complètes",
	[13]= "complet",
	[12]= "complets",
	[14]= "cuir complète",
	[17]= "déchu",
	[15]= "déchues",
	[16]= "déchus",
	[20]= "cloutées",
	[19]= "cloutés",
	[18]= "cloutée",
	[21]= "cuir clouté",
	[22]= "peau de fer",
	[23]= "superbe",
	[24]= "cuir pourpre",
	[25]= "peau d'ombre",
	[26]= "livrez",
	[27]= "acier de vide",
	[28]= "casque en cuprite",
	[29]= "spallières",
	[30]= "néant",
	[31]= "gantelets",
	[32]= "déchu",


	},
	["corrected"] = {
	[1] = "artisanal",
	[2] = "artisanal",
	[3] = "artisanal",
	[4] = "dwemer",
	[5] = "dwemer",
	[6] = "dwemer",
	[7] = "brut",
	[8] = "brut",
	[9] = "brut",
	[10]= "brut",
	[11]= "complète",
	[12]= "complète",
	[13]= "complète",
	[14]= "complète",
	[15]= "déchue",
	[16]= "déchue",
	[17]= "déchue",
	[18]= "clouté",
	[19]= "clouté",
	[20]= "clouté",
	[21]= "clouté",
	[22]= "ferhide",
	[23]= "superbes",
	[24]= "pourpre",
	[25]= "d'ombre",
	[26]= "deliver",
	[27]= "vide",
	[28]= "heaume en cuprite",
	[29]= "spallière",
	[30]= "vide",
	[31]= "gantelet",
	[32]= "déchue",
	}

}
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


local bankExceptions = 
{
	["original"] = {
		"dégâts",
		
	},
	["corrected"] = {
		"ravage",
		
	}
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

function WritCreater.exceptions(condition)
	condition = string.lower(condition)

	for i = 1, #exceptions["original"] do
		if string.find(condition, exceptions["original"][i]) then
			condition = string.gsub(condition, exceptions["original"][i],exceptions["corrected"][i])
		end
	end
	condition = string.gsub(condition, " "," ")
	condition = string.lower(condition)
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


WritCreater.strings  = {
	["runeReq"] 						= function (essence, potency) return "|c2dff00L'artisanat requiert 1 |rTa|c2dff00, 1 |cffcc66"..essence.."|c2dff00 et 1 |c0066ff"..potency.."|r" end,
	["runeMissing"]						= runeMissingFunction,
	["notEnoughSkill"]					= "You do not have a high enough crafting skill to make the required equipment",
	["smithingMissing"] 				= "\n|cf60000Vous n'avez pas assez de matériaux|r",
	["craftAnyway"] 					= "Crafter quand même",
	["smithingEnough"] 					= "\n|c2dff00Vous avez suffisamment de matériaux|r",
	["craft"] 							= "|c00ff00Fabriquer|r",
	["complete"] 						= "|c00FF00Commande réalisée.|r",
	["craftingstopped"] 				= "Crat interrompu. Veuillez vérifier que l'addon a crafté le bon objet.",
	["crafting"] 						= "|c00ff00Fabrication ...|r",
	["craftIncomplete"] 				= "|cf60000La fabrication ne peux être réalisée.\nMatériaux insuffisants.|r",
	["moreStyle"] 						= "|cf60000Vous n'avez aucune pierre de style utilisable de définie|r",
	["smithingReqM"] 					= function (amount, type, more) return zo_strformat( "La fabrication utilisera <<1>> <<2>> (|cf60000Vous en avez besoin de <<3>>|r)"    ,amount, type, more) end,
	["smithingReqM2"] 					= function (amount,type,more)     return zo_strformat( "\nMais aussi <<1>> <<2>> (|cf60000Vous en avez besoin de <<3>>|r)" ,amount, type, more) end,
	["smithingReq"] 					= function (amount,type, current) return zo_strformat( "La fabrication utilisera <<1>> <<2>> (|c2dff00<<3>> disponible|r)"  ,amount, type, current) end,
	["smithingReq2"] 					= function (amount,type, current) return zo_strformat( "\nMais aussi <<1>> <<2>> (|c2dff00<<3>> disponible|r)" ,amount, type, current) end,
	["dailyreset"] 						= function (till) d(zo_strformat("<<1>> heures et <<2>> minutes avant le reset journalier.",till["hour"],till["minute"])) end,
	["lootReceived"]					= "<<1>> was received",
}



WritCreater.optionStrings = {}
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
WritCreater.optionStrings["woodworking"]                              = "Trvail du Bois"
WritCreater.optionStrings["woodworking tooltip"]                      = "Activer l'addon pour le travail du bois"
WritCreater.optionStrings["ignore autoloot"]                          = "Outrepasser l'autoloot"
WritCreater.optionStrings["ignore autoloot tooltip"]                  = "Ignorer le paramètre d'autoloot des paramètres de Gameplay mais utiliser le paramètre personnalisé ci-dessous pour les conteneurs d'artisanat"
WritCreater.optionStrings["autoloot containters"]                     = "Conteneurs de quête d'artisanat"
WritCreater.optionStrings["autoLoot containters tooltip"]             = "Looter automatiquement les conteneurs d'artisanat lorsqu'ils sont ouverts"
WritCreater.optionStrings["style stone menu"]                         = "Utilisation des pierres de style"
WritCreater.optionStrings["style stone menu tooltip"]                 = "Sélectionnez quelles pierres de style utiliser"
WritCreater.optionStrings["exit when done"]							  = "Quitter l'atelier lorsque terminé"
WritCreater.optionStrings["exit when done tooltip"]					  = "Quitter l'atelier automatiquement lorsque toutes les fabrications ont été réalisées"
WritCreater.optionStrings["automatic complete"]						  = "Interactions automatiques de quêtes"
WritCreater.optionStrings["automatic complete tooltip"]				  = "Accepte et valide automatiquement les quêtes en interagissant avec les panneaux et coffres d'artisanat."
WritCreater.optionStrings["new container"]							  = "Keep new status"
WritCreater.optionStrings["new container tooltip"]					  = "Keep the new status for writ reward containers"
WritCreater.optionStrings["master"]									  = "Master Writs"
WritCreater.optionStrings["master tooltip"]							  = "Turn the addon off for Master Writs"
WritCreater.optionStrings["right click to craft"]						= "Right Click to Craft"
WritCreater.optionStrings["right click to craft tooltip"]				= "If this is ON the addon will craft Master Writs you tell it to craft after right clicking a sealed writ"
WritCreater.optionStrings["crafting submenu"]							= "Trades to Craft"
WritCreater.optionStrings["crafting submenu tooltip"]					= "Turn the addon off for specific crafts"
WritCreater.optionStrings["timesavers submenu"]							= "Timesavers"
WritCreater.optionStrings["timesavers submenu tooltip"]					= "Various small timesavers"
WritCreater.optionStrings["loot container"]						  		= "Loot container when received"
WritCreater.optionStrings["loot container tooltip"]				  		= "Loot writ reward containers when you receive them"
WritCreater.optionStrings["master writ saver"]							= "Save Master Writs"
WritCreater.optionStrings["master writ saver tooltip"]					= "Prevents Master Writs from being accepted"
WritCreater.optionStrings["loot output"]								= "Alerte sur les récompenses précieuses"
WritCreater.optionStrings["loot output tooltip"]						= "Afficher un message lorsque des objets de grande valeur sont reçus d'une commande d'artisanat"
WritCreater.optionStrings["writ grabbing"]								= "Grab writ items"
WritCreater.optionStrings["writ grabbing tooltip"]						= "Grab items required for writs (e.g. nirnroot, Ta, etc.) from the bank"



function WritCreater.langWritRewardBoxes () return {
	[1] = "Récipient d'alchimiste",
	[2] = "coffre d'enchanteur",
	[3] = "paquet de cuisinier",
	[4] = "caisse de forgeron",
	[5] = "sacoche de tailleur",
	[6] = "caisse de travailleur du bois",
	[7] = "cargaison",
}
end

function WritCreater.getTaString()
	return "ta"
end

WritCreater.lang = "fr"