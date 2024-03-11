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

WritCreater = WritCreater or {}

local function proper(str)
    if type(str) == "string" then
        return zo_strformat("<<C:1>>", str)
    else
        return str
    end
end

WritCreater.hirelingMailSubjects = {
    ["Raw Enchanter Materials"] = true,
    ["Raw Clothier Materials"] = true,
    ["Raw Blacksmith Materials"] = true,
    ["Raw Woodworker Materials"] = true,
    ["Raw Provisioner Materials"] = true,
    ["Schreinermaterial"] = true,
    ["Versorgerzutaten"] = true,
    ["Schneidermaterial"] = true,
    ["Verzauberermaterial"] = true,
    ["Schmiedematerial"] = true,
    ["Matériaux bruts d'enchantement"] = true,
    ["Matériaux bruts de forge"] = true,
    ["Matériaux bruts de travail du bois"] = true,
    ["Matériaux bruts de couture"] = true,
    ["Matériaux bruts de cuisine"] = true,
    ["Materiales de encantamiento no refinados"] = true,
    ["Materiales de sastrería no refinados"] = true,
    ["Materiales de herrería no refinados"] = true,
    ["Materiales de carpintería no refinados"] = true,
    ["Materiales de cocina crudos"] = true
}

function WritCreater.langWritNames()
    local names = {
        --@formatter:off
        ["G"]                           = "Encargo",
        [CRAFTING_TYPE_ENCHANTING]      = "encantamiento",
        [CRAFTING_TYPE_BLACKSMITHING]   = "herrería",
        [CRAFTING_TYPE_CLOTHIER]        = "sastrería",
        [CRAFTING_TYPE_PROVISIONING]    = "cocina",
        [CRAFTING_TYPE_WOODWORKING]     = "carpintería",
        [CRAFTING_TYPE_ALCHEMY]         = "alquimia",
        [CRAFTING_TYPE_JEWELRYCRAFTING] = "joyería"
        --@formatter:on
    }
    return names
end

function WritCreater.langCraftKernels()
    return
    {
        --@formatter:off
        [CRAFTING_TYPE_ENCHANTING]      = "encantamiento",
        [CRAFTING_TYPE_BLACKSMITHING]   = "herrería",
        [CRAFTING_TYPE_CLOTHIER]        = "sastrería",
        [CRAFTING_TYPE_PROVISIONING]    = "cocina",
        [CRAFTING_TYPE_WOODWORKING]     = "carpintería",
        [CRAFTING_TYPE_ALCHEMY]         = "alquimia",
        [CRAFTING_TYPE_JEWELRYCRAFTING] = "joyería"
        --@formatter:on
    }
end

function WritCreater.langMasterWritNames()
    local names = {
        --@formatter:off
        ["M"]                           = "magistral",
        ["M1"]                          = "maestro",
        [CRAFTING_TYPE_ALCHEMY]         = "mezcla",
        [CRAFTING_TYPE_ENCHANTING]      = "glifo",
        [CRAFTING_TYPE_PROVISIONING]    = "festín",
        ["plate"]                       = "protección",
        ["tailoring"]                   = "prenda de tela",
        ["leatherwear"]                 = "prenda de cuero",
        ["weapon"]                      = "arma",
        ["shield"]                      = "escudo"
        --@formatter:on
    }
    return names

end

function WritCreater.writCompleteStrings()
    local strings = {
        --@formatter:off
        ["place"]           = "Colocar los objetos",
        ["sign"]            = "Firmar el manifiesto",
        ["masterPlace"]     = "He terminado el ",
        ["masterSign"]      = "<Terminar el trabajo>",
        ["masterStart"]     = "<Aceptar el contrato>",
        ["Rolis Hlaalu"]    = "Rolis Hlaalu",
        ["Deliver"]         = "Entregas"
        --@formatter:on
    }
    return strings
end

function WritCreater.languageInfo()

    local craftInfo = {
        [CRAFTING_TYPE_CLOTHIER] = {
            ["pieces"] = {
                [1] = "Túnica",
                [2] = "Jubón",
                [3] = "Zapatos",
                [4] = "Guantes",
                [5] = "Capucha",
                [6] = "Calzones",
                [7] = "Cubrehombros",
                [8] = "Banda",
                [9] = "Pechera",
                [10] = "Botas",
                [11] = "Brazales",
                [12] = "Casco",
                [13] = "Musleras",
                [14] = "Hombreras",
                [15] = "Cinturón"
            },
            ["match"] = {
                [1] = "Tejido Artesanal",
                [2] = "Lino",
                [3] = "Algodón",
                [4] = "Seda de Araña",
                [5] = "Hilo de Ébano",
                [6] = "Kresh",
                [7] = "Hilo de Hierro",
                [8] = "Hilo de Plata",
                [9] = "Sombrío",
                [10] = "Ancestral",
                [11] = "Piel Cruda",
                [12] = "Piel",
                [13] = "Cuero",
                [14] = "Cuero Tratado",
                [15] = "Impía",
                [16] = "Brigantina",
                [17] = "Piel Férrea",
                [18] = "Soberbio",
                [19] = "Piel Sombría",
                [20] = "Rubedo"
            },
        },
        [CRAFTING_TYPE_BLACKSMITHING] = {
            ["pieces"] = {
                [1] = "Hacha",
                [2] = "Maza",
                [3] = "Espada",
                [4] = "Batalla",
                [5] = "Maza",
                [6] = "Mandoble",
                [7] = "Daga",
                [8] = "Coraza",
                [9] = "Escarpes",
                [10] = "Guanteletes",
                [11] = "Yelmo",
                [12] = "Grebas",
                [13] = "Espaldarones",
                [14] = "Faja"
            },
            ["match"] = {
                [1] = "Hierro",
                [2] = "Acero",
                [3] = "Oricalco",
                [4] = "Enano",
                [5] = "Ébano",
                [6] = "Calcinio",
                [7] = "Galatita",
                [8] = "Azoge",
                [9] = "Acero del Vacio",
                [10] = "Rubedita"
            },
        },
        [CRAFTING_TYPE_WOODWORKING] = {
            ["pieces"] = {
                [1] = "Arco",
                [3] = "Infernal",
                [4] = "Glaciar",
                [5] = "Eléctrica",
                [6] = "Restauradora",
                [2] = "Escudo"
            },
            ["match"] = {
                [1] = "Arce",
                [2] = "Roble",
                [3] = "Haya",
                [4] = "Nogal",
                [5] = "Tejo",
                [6] = "Abedul",
                [7] = "Fresno",
                [8] = "Caoba",
                [9] = "Nocteca",
                [10] = "Rubí"
            },
        },
        [CRAFTING_TYPE_JEWELRYCRAFTING] = {
            ["pieces"] = {
                [1] = "Anillo",
                [2] = "Collar"
            },
            ["match"] = {
                [1] = "Peltre", -- 1
                [2] = "Cobre", -- 26
                [3] = "Plata", -- CP10
                [4] = "Electro", -- CP80
                [5] = "Platino" -- CP150
            },
        },
        [CRAFTING_TYPE_ENCHANTING] = {
            ["pieces"] = { --{String Identificador, Id del objeto, positivo o negativo}
                { "Enfermedad", 45841, 2 },
                { "Podredumbre", 45841, 1 },
                { "Absorción de Aguante", 45833, 2 },
                { "Absorción de Magia", 45832, 2 },
                { "Absorción de Vida", 45831, 2 },
                { "Resistencia al frio", 45839, 2 },
                { "Hielo", 45839, 1 },
                { "Virtuosidad", 45836, 2 },
                { "Regeneración de Aguante", 45836, 1 },
                { "Robustez", 45842, 1 },
                { "Aplastamiento", 45842, 2 },
                { "Enbate", 68342, 2 },
                { "defense", 68342, 1 },
                { "Protección", 45849, 2 },
                { "Percutante", 45849, 1 },
                { "Resistencia a al Veneno", 45837, 2 },
                { "Veneno", 45837, 1 },
                { "Daño Mágico", 45848, 2 },
                { "Mágico", 45848, 1 },
                { "Regeneración de Magia", 45835, 1 },
                { "Brujería", 45835, 2 },
                { "Resistencia a la Electricidad", 45840, 2 },
                { "Descarga", 45840, 1 },
                { "Regeneración de Vida", 45834, 1 },
                { "Disminución de Vida", 45834, 2 },
                { "Debilidad", 45843, 2 },
                { "Arma", 45843, 1 },
                { "Alquimista", 45846, 1 },
                { "Aceleración", 45846, 2 },
                { "Resistencia al Fuego", 45838, 2 },
                { "Fuego", 45838, 1 },
                { "Disminución del Daño Físico", 45847, 2 },
                { "Aumento de Daño Físico", 45847, 1 },
                { "Aguante", 45833, 1 },
                { "Vida", 45831, 1 },
                { "Magia", 45832, 1 }
            },
            ["match"] = {
                [1] = { "Mediocre", 45855 },
                [2] = { "Inferior", 45856 },
                [3] = { "Insignificante", 45857 },
                [4] = { "Leve", 45806 },
                [5] = { "Menor", 45807 },
                [6] = { "Minusculo", 45808 },
                [7] = { "Moderado", 45809 },
                [8] = { "Medio", 45810 },
                [9] = { "Fuerte", 45811 },
                [10] = { "Mayor", 45812 },
                [11] = { "Superior", 45813 },
                [12] = { "Gran", 45814 },
                [13] = { "Espléndido", 45815 },
                [14] = { "Monumental", 45816 },
                [15] = { "Realmente", { 68341, 68340 } },
                [16] = { "Soberbio", { 64509, 64508 } }
            },
            ["quality"] = {
                { "Base", 45850 },
                { "Bueno", 45851 },
                { "Superior", 45852 },
                { "Épico", 45853 },
                { "Legendario", 45854 },
                { "", 45850 } -- Por defecto, si no es mencionado. Por defecto deberia ser Ta.
            }
        },
    }
    return craftInfo
end

function WritCreater.masterWritQuality()
    return {
        { "Épico", 4 },
        { "Legendario", 5 }
    }
end

function WritCreater.langEssenceNames()

    local essenceNames = {
        [1] = "Oko", -- vida
        [2] = "Deni", -- aguante
        [3] = "Makko" -- magia
    }
    return essenceNames
end

function WritCreater.langPotencyNames()
    local potencyNames = {
        [1] = "Jora", -- El menor nivel de piedra de potencia
        [2] = "Porade",
        [3] = "Jera",
        [4] = "Jejora",
        [5] = "Odra",
        [6] = "Pojora",
        [7] = "Edora",
        [8] = "Jaera",
        [9] = "Pora",
        [10] = "Denara",
        [11] = "Rera",
        [12] = "Derado",
        [13] = "Rekura",
        [14] = "Kura",
        [15] = "Rejera",
        [16] = "Repora", -- Piedra de potencia de v16
    }
    return potencyNames
end

local function runeMissingFunction(ta, essence, potency)
    local missing = {}
    if not ta["bag"] then
        missing[#missing + 1] = "|rTa|cf60000"
    end
    if not essence["bag"] then
        missing[#missing + 1] = "|cffcc66" .. essence["slot"] .. "|cf60000"
    end
    if not potency["bag"] then
        missing[#missing + 1] = "|c0066ff" .. potency["slot"] .. "|r"
    end
    local text = ""
    for i = 1, #missing do
        if i == 1 then
            text = "|cff3333El Glifo no pudo ser elaborado. No tienes ningun " ..
                    proper(missing[i])
        else
            text = text .. " y " .. proper(missing[i])
        end
    end
    return text
end

local function dailyResetFunction(till, stamp)
    if till["hour"] == 0 then
        if till["minute"] == 1 then
            return "¡1 minuto hasta el reinicio diario del servidor!"
        elseif till["minute"] == 0 then
            if stamp == 1 then
                return "¡Reinicio diario en  " .. stamp .. " segundos!"
            else
                return
                "En serio... deja de preguntar. ¿Eres tan impaciente? Se reinicia en un segundo Godammit más. Estúpidos jugadores titulados en MMO's. * refunfuñar gruñendo *"
            end
        else
            return till["minute"] .. " minutos hasta que reinicie el día"
        end
    elseif till["hour"] == 1 then
        if till["minute"] == 1 then
            return till["hour"] .. " hora y " .. till["minute"] ..
                    " minuto hasta el reinicio diario"
        else
            return till["hour"] .. " hora y " .. till["minute"] ..
                    " minutos hasta el reinicio diario"
        end
    else
        if till["minute"] == 1 then
            return till["hour"] .. " horas y " .. till["minute"] ..
                    " minuto hasta el reinicio diario"
        else
            return till["hour"] .. " horas y " .. till["minute"] ..
                    " minutos hasta el reinicio diario"
        end
    end
end

local function masterWritEnchantToCraft(pat, set, trait, style, qual, mat,
                                        writName, Mname, generalName)
    local partialString = zo_strformat(
            "Elaborando un CP150 <<t:6>> <<t:1>> desde <<t:2>>  con el <<t:3>> rasgo y estilo <<t:4>> a <<t:5>> calidad",
            pat, set, trait, style, qual, mat)
    return zo_strformat("<<t:2>> <<t:3>> <<t:4>>: <<1>>", partialString,
            writName, Mname, generalName)
end

local enExceptions = -- This is a slight misnomer. Not all are corrections - some are changes into english so that future functions will work
{
    ["original"] =
    {
        [1] = "consigue",
        [2] = "entrega",

    },
    ["corrected"] = 
    {   
        [1] = "acquire",
        [2] = "deliver",

    },
}

function WritCreater.questExceptions(condition)
    condition = string.gsub(condition, " ", " ")
    for i = 1, #enExceptions["original"] do
        condition = string.gsub(condition,enExceptions["original"][i],enExceptions["corrected"][i])
    
    end
    return condition
end


function WritCreater.enchantExceptions(condition)

    condition = string.gsub(condition, " ", " ")
    return condition
end

function WritCreater.langTutorial(i)
    local t = {
        [5] = "También hay algunas cosas que debes saber.\nPrimero, /dailyreset es un comando de barra que te dirá\ncuánto tiempo hasta el próximo reinicio diario del servidor.",
        [4] = "Finalmente, también puede optar por desactivar o\nactivar este complemento para cada profesión\nPor defecto, todas las profesiones están activadas.\nSi desea desactivarlo, verifique la configuración.",
        [3] = "A continuación, Necesitas elegir si deseas ver esta\nventana cuando se usa una estación de artesanía.\nLa ventana le dirá cuántos materiales requerirá el encargo, y cuantos tienes actualmente.",
        [2] = "La primera opción para elegir es si\nquieres usar AutoCraft.\nSi está ACTIVO, cuando ingresa a una estación de artesanía, el complemento comenzará a elaborar automaticamente el encargo.",
        [1] = "¡Bienvenido a Dolgubon's Lazy Writ Crafter! (Traducido por Kelsucristo & Gambasoxd)\nHay algunas opciones que debe elegir primero.\nPuede cambiar la configuración en cualquier\nmomento en el menú de configuración."
    }
    return t[i]
end

function WritCreater.langTutorialButton(i, onOrOff)
    local tOn = {
        [1] = "Uso predeterminado",
        [2] = "ACTIVO",
        [3] = "Mostrar",
        [4] = "Continuar",
        [5] = "Terminar"
    }
    local tOff = {
        [1] = "Continuar",
        [2] = "Apagado",
        [3] = "No mostrar"
    }

    if onOrOff then
        return tOn[i]
    else
        return tOff[i]
    end
end

function WritCreater.langStationNames()
    return {
        ["Taller de herrería"] = 1,
        ["Taller de sastrería"] = 2,
        ["Mesa de encantamientos"] = 3,
        ["Estación de alquimia"] = 4,
        ["Fogón"] = 5,
        ["Taller de carpintería"] = 6,
        ["Taller de joyería"] = 7
    }
end

local DivineMats = {
    {
        "Rusted Nails",
        "Ghost Robes",
        "",
        "",
        "",
        "Rotten Logs",
        "Cursed Gold",
        "Chopped Liver",
        "Crumbled Gravestones",
        "Toad Eyes",
        "Werewolf Claws",
        "Zombie Guts",
        "Lizard Brains"
    }, {
        "Buzzers",
        "Sock Puppets",
        "Jester Hats",
        "Otter Noses",
        "Red Herrings",
        "Wooden Snakes",
        "Fool's Gold",
        "Mudpies"
    }, {
        "Coal",
        "Stockings",
        "",
        "",
        "",
        "Evergreen Branches",
        "Golden Rings",
        "Bottled Time",
        "Reindeer Bells",
        "Elven Hats",
        "Pine Needles",
        "Cups of Snow"
    }
}

local function shouldDivinityprotocolbeactivatednowornotitshouldbeallthetimebutwhateveritlljustbeforabit()
    if GetDate() % 10000 == 1031 then
        return 1
    end
    if GetDate() % 10000 == 401 then
        return 2
    end
    if GetDate() % 10000 == 1231 then
        return 3
    end
    if GetDisplayName() == "@Dolgubon" or GetDisplayName() == "@Gitaelia" or GetDisplayName() == "@mithra62" or GetDisplayName() == "@PacoHasPants" then
        return 2
    end
    return false
end

local function wellWeShouldUseADivineMatButWeHaveNoClueWhichOneItIsSoWeNeedToAskTheGodsWhichDivineMatShouldBeUsed()
    local a = math.random(1, #DivineMats)
    return DivineMats[a]
end
local l = shouldDivinityprotocolbeactivatednowornotitshouldbeallthetimebutwhateveritlljustbeforabit()

if l then
    DivineMats = DivineMats[l]
    local DivineMat = wellWeShouldUseADivineMatButWeHaveNoClueWhichOneItIsSoWeNeedToAskTheGodsWhichDivineMatShouldBeUsed()

    WritCreater.strings.smithingReqM = function(amount, _, more)
        local craft = GetCraftingInteractionType()
        DivineMat = DivineMats[craft]
        return zo_strformat(
                "La elaboración usará <<1>> <<4>> (|cf60000Necesitas <<3>>|r)",
                amount,
                type,
                more,
                DivineMat
        )
    end
    WritCreater.strings.smithingReqM2 = function(amount, _, more)
        local craft = GetCraftingInteractionType()
        DivineMat = DivineMats[craft]
        return zo_strformat(
                "Al igual que <<1>> <<4>> (|cf60000Necesitas <<3>>|r)",
                amount,
                type,
                more,
                DivineMat
        )
    end
    WritCreater.strings.smithingReq = function(amount, _, more)
        local craft = GetCraftingInteractionType()
        DivineMat = DivineMats[craft]
        return zo_strformat(
                "La elaboración usará <<1>> <<4>> (|c2dff00<<3>> disponible|r)",
                amount,
                type,
                more,
                DivineMat
        )
    end
    WritCreater.strings.smithingReq2 = function(amount, _, more)
        local craft = GetCraftingInteractionType()
        DivineMat = DivineMats[craft]
        return zo_strformat(
                "Al igual que <<1>> <<4>> (|c2dff00<<3>> disponible|r)",
                amount,
                type,
                more,
                DivineMat
        )
    end
end

local h = { __index = {} }
local t = {}
local g = { ["__index"] = t }
setmetatable(t, h)
setmetatable(WritCreater, g) --]]

-- @todo Falta traducir alternate universe
local function enableAlternateUniverse(override)

    if shouldDivinityprotocolbeactivatednowornotitshouldbeallthetimebutwhateveritlljustbeforabit() == 2 or override then
        --if true then
        local stations = {
            "Taller de herrería",
            "Taller de sastrería",
            "Mesa de encantamientos",
            "Estación de alquimia",
            "Fogón",
            "Taller de carpintería",
            "Taller de joyería",
            "Taller de atuendos",
            "Taller de transmutación",
            "Ermita"
        }
        local stationNames = -- in the comments are other names that were also considered, though not all were considered seriously
        {
            "Wightsmithing Station", -- Popcorn Machine , Skyforge, Heavy Metal Station, Metal Clockwork Solid, Wightsmithing Station., Coyote Stopper
            "Sock Puppet Theatre", -- Sock Distribution Center, Soul-Shriven Sock Station, Grandma's Sock Knitting Station, Knits and Pieces, Sock Knitting Station
            "Top Hats Inc.", -- Mahjong Station, Magic Store, Card Finder, Five Aces, Top Hat Store
            "Seedy Skooma Bar", -- Chemical Laboratory , Drugstore, White's Garage, Cocktail Bar, Med-Tek Pharmaceutical Company, Med-Tek Laboratories, Skooma Central, Skooma Backdoor Dealers, Sheogorath's Pharmacy
            "McDaedra Order Kiosk", --"Khajit Fried Chicken", -- Khajit Fried Chicken, soup Kitchen, Some kind of bar, misspelling?, Roast Bosmer
            "IKEA Assembly Station", -- Chainsaw Massace, Saw Station, Shield Corp, IKEA Assembly Station, Wood Splinter Removal Station
            "April Fool's Gold", --"Diamond Scam Store", -- Lucy in the Sky, Wedding Planning Hub, Shiny Maker, Oooh Shiny, Shiny Bling Maker, Cubit Zirconia, Rhinestone Palace
            -- April Fool's Gold
            "Khajit Fur Trade Outpost", -- Jester Dressing Room Loincloth Shop, Khajit Walk, Khajit Fashion Show, Mummy Maker, Thalmor Spy Agency, Tamriel Catwalk,
            --	Tamriel Khajitwalk, second hand warehouse,. Dye for Me, Catfur Jackets, Outfit station "Khajiit Furriers", Khajit Fur Trading Outpost
            "Sacrificial Goat Altar", -- Heisenberg's Station Correction Facility, Time Machine, Probability Redistributor, Slot Machine Rigger, RNG Countermeasure, Lootcifer Shrine, Whack-a-mole
            -- Anti Salt Machine, Department of Corrections, Quantum State Rigger , Unnerf Station
            "TARDIS" -- Transporter, Molecular Discombobulator, Beamer, Warp Tunnel, Portal, Stargate, Cannon!, Warp Gate
        }

        local crafts = {
            "Blacksmithing",
            "Clothing",
            "Enchanting",
            "Alchemy",
            "Provisioning",
            "Woodworking",
            "Jewelry Crafting"
        }
        local craftNames = {
            "Wightsmithing",
            "Sock Knitting",
            "Top Hat Tricks",
            "Skooma Brewing",
            "McDaedra", --"Chicken Frying",
            "IKEA Assembly",
            "Fool's Gold Creation",
        }
        local quest = {
            "Blacksmith",
            "Clothier",
            "Enchanter",
            "Alchemist",
            "Provisioner",
            "Woodworker",
            "Jewelry Crafting",
            "Provisioner Writ"
        }
        local questNames = {
            "Wightsmith",
            "Sock Knitter",
            "Top Hat Trickster",
            "Skooma Brewer",
            "McDaedra", --"Chicken Fryer",
            "IKEA Assembly",
            "Fool's Gold",
            "McDaedra Delivery",
        }
        local items = { "Blacksmith", "Clothier", "Enchanter", "alchemical", "food and drink", "Woodworker", "Jewelry" }
        local itemNames = {
            "Wight",
            "Sock Puppet",
            "Top Hat",
            "Skooma",
            "McDaedra Nuggets", --"Fried Chicken",
            "IKEA",
            "Fool's Gold",
        }
        local coffers = { "Blacksmith", "Clothier", "Enchanter", "Alchemist", "Provisioner's Pack", "Woodworker", "Jewelry Crafter's", }
        local cofferNames = {
            "Wightsmith",
            "Sock Knitter",
            "Top Hat Trickster",
            "Skooma Brewer",
            "McDaedra Takeout", --"Chicken Fryer",
            "IKEA Assembly",
            "Fool's Gold",
        }
        local ones = { "Jewelry Crafter" }
        local oneNames = { "Fool's Gold" }

        local t = { ["__index"] = {} }
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
        local b = WritCreater.langWritNames()
        for i = 1, 7 do
            b[i] = questNames[i]
        end
    end
end

local lastYearStations = {
    "Taller de herrería",
    "Taller de sastrería",
    "Taller de carpintería",
    "Fogón",
    "Mesa de encantamiento",
    "Estación de alquimia",
    "Taller de atuendos",
    "Taller de transmutación",
    "Ermita"
}
local stationNames = -- in the comments are other names that were also considered, though not all were considered seriously
{
    "Heavy Metal 112.3 FM", -- Popcorn Machine , Skyforge, Heavy Metal Station
    "Sock Knitting Station", -- Sock Distribution Center, Soul-Shriven Sock Station, Grandma's Sock Knitting Station, Knits and Pieces
    "Splinter Removal Station", -- Chainsaw Massace, Saw Station, Shield Corp, IKEA Assembly Station, Wood Splinter Removal Station
    "McSheo's Food Co.",
    "Tetris Station", -- Mahjong Station
    "Poison Control Centre", -- Chemical Laboratory , Drugstore, White's Garage, Cocktail Bar, Med-Tek Pharmaceutical Company, Med-Tek Laboratories
    "Thalmor Spy Agency", -- Jester Dressing Room Loincloth Shop, Khajit Walk, Khajit Fashion Show, Mummy Maker, Thalmor Spy Agency, Morag Tong Information Hub, Tamriel Spy HQ,
    "Department of Corrections", -- Heisenberg's Station Correction Facility, Time Machine, Probability Redistributor, Slot Machine Rigger, RNG Countermeasure, Lootcifer Shrine, Whack-a-mole
    -- Anti Salt Machine, Department of Corrections
    "Warp Gate" } -- Transporter, Molecular Discombobulator, Beamer, Warp Tunnel, Portal, Stargate, Cannon!, Warp Gate

-- enableAlternateUniverse(GetDisplayName()=="@Dolgubon")
enableAlternateUniverse()

local function alternateListener(eventCode, channelType, fromName, text, isCustomerService, fromDisplayName)
    if not WritCreater.alternateUniverse and fromDisplayName == "@Dolgubon" and (text == "¡Que las islas se desangren en Nirn!") then
        enableAlternateUniverse(true)
        WritCreater.WipeThatFrownOffYourFace(true)
    end
end

EVENT_MANAGER:RegisterForEvent(WritCreater.name, EVENT_CHAT_MESSAGE_CHANNEL, alternateListener)

function WritCreater.langWritRewardBoxes ()
    return {
        --@formatter:off
        [CRAFTING_TYPE_ALCHEMY]         = "Recipiente de alquimista",
        [CRAFTING_TYPE_ENCHANTING]      = "Cofre de encantador",
        [CRAFTING_TYPE_PROVISIONING]    = "Paquete de cocinero",
        [CRAFTING_TYPE_BLACKSMITHING]   = "Caja de herrero",
        [CRAFTING_TYPE_CLOTHIER]        = "Morral de sastre",
        [CRAFTING_TYPE_WOODWORKING]     = "Valija de carpintero",
        [CRAFTING_TYPE_JEWELRYCRAFTING] = "Baúl de joyero",
        [8]                             = "Cargamento"
        --@formatter:on
    }
end

function WritCreater.getTaString()
    return "ta"
end

WritCreater.strings = WritCreater.strings or {}

--@formatter:off
WritCreater.strings["runeReq"] 					    = function (essence, potency) return zo_strformat("|c2dff00La elaboración requerirá 1 |rTa|c2dff00, 1 |cffcc66<<1>>|c2dff00 y 1 |c0066ff<<2>>|r", essence, potency) end
WritCreater.strings["runeMissing"] 				    = runeMissingFunction
WritCreater.strings["notEnoughSkill"]				= "No tienes una habilidad de artesanía lo suficientemente alta como para hacer el equipo requerido"
WritCreater.strings["smithingMissing"] 			    = "\n|cf60000No tienes suficientes materiales.|r"
WritCreater.strings["craftAnyway"]                  = "Elaborar de todos modos"
WritCreater.strings["smithingEnough"]               = "\n|c2dff00Tienes suficientes materiales|r"
WritCreater.strings["craft"]                        = "|c00ff00Elaborar|r"
WritCreater.strings["crafting"]                     = "|c00ff00Elaborando...|r"
WritCreater.strings["craftIncomplete"]              = "|cf60000La elaboración no pudo ser completada.\nNecesitas más materiales.|r"
WritCreater.strings["moreStyle"]                    = "|cf60000No tienes ninguna piedra de estilo utilizable.\nRevisa tu inventario, logros y configuraciones|r"
WritCreater.strings["moreStyleSettings"]            = "|cf60000No tienes ninguna piedra de estilo utilizable.\nEs probable que tengas que permitir más estilos en el menú de configuración.|r"
WritCreater.strings["moreStyleKnowledge"]           = "|cf60000No tienes ninguna piedra de estilo utilizable.\nEs posible que tengas que aprender a crear más estilos.|r"
WritCreater.strings["dailyreset"]                   = dailyResetFunction
WritCreater.strings["complete"]                     = "|c00FF00Encargo completo.|r"
WritCreater.strings["craftingstopped"]              = "La elaboración se detuvo. Por favor, compruebe para asegurarse de que el complemento está creando el artículo correcto."
WritCreater.strings["smithingReqM"] 				= function (amount, type, more) return zo_strformat( "La elaboración utilizará <<1>> <<2>> (|cf60000Necesitas <<3>>|r)" ,amount, type, more) end
WritCreater.strings["smithingReq"] 				    = function (amount,type, current) return zo_strformat( "La elaboración utilizará <<1>> <<2>> (|c2dff00<<3>> disponible|r)"  ,amount, type, current) end
WritCreater.strings["lootReceived"]                 = "Has recibido <<3>> <<1>> (Tienes <<2>>)"
WritCreater.strings["lootReceivedM"]                = "Has recibido <<1>> "
WritCreater.strings["countSurveys"]                 = "Tienes <<1>> prospecciones"
WritCreater.strings["countVouchers"]                = "Tienes <<1>> vales de escritura no ganados"
WritCreater.strings["includesStorage"]				= function(type) local a= {"Surveys", "Master Writs"} a = a[type] return zo_strformat("El recuento incluye <<1>> en el almacenamiento de las casas", a) end
WritCreater.strings["surveys"]						= "Prospecciones"
WritCreater.strings["sealedWrits"]					= "Encargos sellados"
WritCreater.strings["masterWritEnchantToCraft"]	    = function(lvl, type, quality, writCraft, writName, generalName)
                                                        return zo_strformat("<<t:4>> <<t:5>> <<t:6>>: Elaboración de un <<t:1>> Glifo de <<t:2>> a <<t:3>> calidad",lvl, type, quality, writCraft,writName, generalName) end
WritCreater.strings["masterWritSmithToCraft"]		= masterWritEnchantToCraft
WritCreater.strings["withdrawItem"]				    = function(amount, link, remaining) return "Dolgubon's Lazy Writ Crafter retiró "..amount.." "..link..". ("..remaining.." en el banco)" end
WritCreater.strings['fullBag']                      = "No tienes espacio en el inventario. Por favor, vacíe su inventario."
WritCreater.strings['masterWritSave']               = "¡Dolgubon's Lazy Writ Crafter te ha salvado de aceptar accidentalmente un encargo maestro! Ve al menú de configuración para deshabilitar esta opción."
WritCreater.strings['missingLibraries']             = "Dolgubon's Lazy Writ Crafter requiere las siguientes librarías independientes. Por favor descargue, instale o active estas librarías: "
WritCreater.strings['resetWarningMessageText']      = "El reinicio diario de los encargos será en <<1>> hora y <<2>> minutos\nPuede personalizar o desactivar esta advertencia en la configuración"
WritCreater.strings['resetWarningExampleText']      = "La advertencia se verá así"
WritCreater.strings['lowInventory']					= "\nSolamente tienes <<1>> espacios libres por lo que no tienes suficiente espacio."

--@formatter:on

WritCreater.optionStrings = WritCreater.optionStrings or {}

--@formatter:off
WritCreater.optionStrings.nowEditing                                    = "Estas cambiando %s ajustes"
WritCreater.optionStrings.accountWide                                   = "Configuración de Cuenta"
WritCreater.optionStrings.characterSpecific                             = "Personaje específico"
WritCreater.optionStrings.useCharacterSettings                          = "Usar la configuración de personajes"
WritCreater.optionStrings.useCharacterSettingsTooltip                   = "Use configuraciones específicas de personajes solo en este personaje"

WritCreater.optionStrings["style tooltip"]								= function (styleName, styleStone) return zo_strformat("Permitir la <<1>> estilo, que utiliza el <<2>> piedra estilo, para ser utilizado para la elaboración",styleName, styleStone) end
WritCreater.optionStrings["show craft window"]                          = "Mostrar la ventana de elaboración"
WritCreater.optionStrings["show craft window tooltip"]                  = "Muestra la ventana de elaboración cuando en las estación de elaboración cuando están abiertas"
WritCreater.optionStrings["autocraft"]                                  = "Elaboración automática"
WritCreater.optionStrings["autocraft tooltip"]                          = "Seleccionar esto hará que el complemento comience a elaborar de forma inmediata al ingresar a una estación de elaboración. Si la ventana no se muestra, esto estará ACTIVO."
WritCreater.optionStrings["blackmithing"]                               = "Herrería"
WritCreater.optionStrings["blacksmithing tooltip"]                      = "Enciende el complemento para Herrería"
WritCreater.optionStrings["clothing"]                                   = "Sastrería"
WritCreater.optionStrings["clothing tooltip"]                           = "Encienda el complemento para Sastrería"
WritCreater.optionStrings["enchanting"]                                 = "Encantamiento"
WritCreater.optionStrings["enchanting tooltip"]                         = "Enciende el complemento para Encantamiento"
WritCreater.optionStrings["alchemy"]                                    = "Alquimia"
WritCreater.optionStrings["alchemy tooltip"]                            = "Activar el complemento para Alquimia (solo para retiros bancarios)"
WritCreater.optionStrings["provisioning"]                               = "Cocina"
WritCreater.optionStrings["provisioning tooltip"]                       = "Activar el complemento para Cocina (solo para retiros bancarios)"
WritCreater.optionStrings["woodworking"]                                = "Carpintería"
WritCreater.optionStrings["woodworking tooltip"]                        = "Encienda el complemento para la Carpintería"
WritCreater.optionStrings["jewelry crafting"]                           = "Joyería"
WritCreater.optionStrings["jewelry crafting tooltip"]                   = "Encienda el complemento para Joyería"
WritCreater.optionStrings["writ grabbing"]                              = "Retirar artículos"
WritCreater.optionStrings["writ grabbing tooltip"]                      = "Retirar los artículos requeridos para los encargos (por ejemplo, raíz de nirn, Ta, etc.) del banco"
WritCreater.optionStrings["style stone menu"]                           = "Piedras de estilo"
WritCreater.optionStrings["style stone menu tooltip"]                   = "Elija qué piedras de estilo usará el complemento"
WritCreater.optionStrings["send data"]                                  = "Enviar datos"
WritCreater.optionStrings["send data tooltip"]                          = "Envíe información sobre las recompensas recibidas de sus cajas de elaboración. No se envía ninguna otra información."
WritCreater.optionStrings["exit when done"]                             = "Salir de la ventana de elaboración"
WritCreater.optionStrings["exit when done tooltip"]                     = "Salir de la ventana de elaboración cuando se haya completado todo el encargo"
WritCreater.optionStrings["automatic complete"]                         = "Diálogo automático"
WritCreater.optionStrings["automatic complete tooltip"]                 = "Acepta y completa automáticamente las misiones"
WritCreater.optionStrings["new container"]                              = "Mantener nuevo estado"
WritCreater.optionStrings["new container tooltip"]                      = "Mantener el nuevo estado para las recompensa de elaboración"
WritCreater.optionStrings["master"]                                     = "Encargos Maestros"
WritCreater.optionStrings["master tooltip"]                             = "Si está ACTIVO, el complemento creará los Encargos Maestros que tenga activos (No funciona del todo bien\nRecomiendo hacer esto con el juego en Inglés)"
WritCreater.optionStrings["right click to craft"]                       = "Haga clic derecho para crear"
WritCreater.optionStrings["right click to craft tooltip"]               = "Si está ACTIVO, el complemento creará Encargos Maestros que usted le indicará que realice después de hacer clic derecho en un Encargo Sellado"
WritCreater.optionStrings["crafting submenu"]                           = "Artesanía"
WritCreater.optionStrings["crafting submenu tooltip"]                   = "Apague el complemento para encargos específicos"
WritCreater.optionStrings["timesavers submenu"]                         = "Ahorradores de tiempo"
WritCreater.optionStrings["timesavers submenu tooltip"]                 = "Varios ahorradores de tiempo"
WritCreater.optionStrings["loot container"]                             = "Recoger el contenedor cuando se recibe"
WritCreater.optionStrings["loot container tooltip"]                     = "Saquea los contenedores de recompensa de encargo cuando los recibas"
WritCreater.optionStrings["master writ saver"]                          = "Guardar las Escrituras Maestras"
WritCreater.optionStrings["master writ saver tooltip"]                  = "Evita que se acepten las Escrituras Maestras"
WritCreater.optionStrings["loot output"]                                = "Alerta de recompensa valiosa"
WritCreater.optionStrings["loot output tooltip"]                        = "Enviar un mensaje cuando se reciben artículos valiosos de encargo"
WritCreater.optionStrings["autoloot behaviour"]                         = "Comportamiento de saqueo automático" -- Tenga en cuenta que los tres siguientes aparecen al principio del menú de configuración, debido a que se cambiaron
WritCreater.optionStrings["autoloot behaviour tooltip"]                 = "Elija cuándo el complemento saqueará automáticamente los contenedores de recompensa" -- Ellas ahora están abajo (con cosas no traducidas)
WritCreater.optionStrings["autoloot behaviour choices"]                 = { "Copia la configuración del juego.", "Saqueo Automático", "Nunca se inicia automáticamente" }
WritCreater.optionStrings["hide when done"]                             = "Ocultar cuando termine"
WritCreater.optionStrings["hide when done tooltip"]                     = "Ocultar la ventana del complemento cuando todos los elementos hayan sido creados"
WritCreater.optionStrings['reticleColour']                              = "Cambiar el color de la retícula"
WritCreater.optionStrings['reticleColourTooltip']                       = "Cambia el color de la retícula si tiene un encargo incompleto o completo en la estación"
WritCreater.optionStrings['autoCloseBank']                              = "Diálogo de banco automático"
WritCreater.optionStrings['autoCloseBankTooltip']                       = "Entrar y salir automáticamente del diálogo del banco si hay elementos para retirar"
WritCreater.optionStrings['despawnBanker']                              = "Desaparecer al banquero"
WritCreater.optionStrings['despawnBankerTooltip']                       = "Desaparecer automáticamente al banquero después de retirar los artículos"
WritCreater.optionStrings['dailyResetWarnTime']                         = "Minutos antes de reiniciar"
WritCreater.optionStrings['dailyResetWarnTimeTooltip']                  = "Cuántos minutos antes del reinicio diario debe aparecer la advertencia"
WritCreater.optionStrings['dailyResetWarnType']                         = "Advertencia de reinicio diario"
WritCreater.optionStrings['dailyResetWarnTypeTooltip']                  = "¿Qué tipo de advertencia se debe mostrar cuando el reinicio diario está a punto de ocurrir?"
WritCreater.optionStrings['dailyResetWarnTypeChoices']                  = { "Ninguno", "Tipo 1", "Tipo 2", "Tipo 3", "Tipo 4", "Todos" }
WritCreater.optionStrings['stealingProtection']                         = "Protección de robo"
WritCreater.optionStrings['stealingProtectionTooltip']                  = "Evita que robes mientras estás cerca de un turno de escritura en la ubicación"
WritCreater.optionStrings['noDELETEConfirmJewelry']                     = "Destrucción fácil de la orden de joyería"
WritCreater.optionStrings['noDELETEConfirmJewelryTooltip']              = "Agregue automáticamente la confirmación de texto BORRAR al cuadro de diálogo Eliminar escritura de joyería"
WritCreater.optionStrings['suppressQuestAnnouncements']                 = "Ocultar notificaciones de misiones escritas"
WritCreater.optionStrings['suppressQuestAnnouncementsTooltip']          = "Oculta el texto en el centro de la pantalla cuando inicia un escrito o crea un elemento para él"
WritCreater.optionStrings["questBuffer"]                                = "Búfer de búsqueda de escritura"
WritCreater.optionStrings["questBufferTooltip"]                         = "Mantenga un búfer de misiones para que siempre pueda tener espacio para recoger encargos"
WritCreater.optionStrings["craftMultiplier"]                            = "Multiplicador de artesanía"
WritCreater.optionStrings["craftMultiplierTooltip"]                     = "Elabore varias copias de cada elemento requerido para que no necesite volver a crearlos la próxima vez que surja la orden. Nota: Guarde aproximadamente 37 espacios por cada aumento por encima de 1"
WritCreater.optionStrings['hireling behaviour']                         = "Acciones de correo"
WritCreater.optionStrings['hireling behaviour tooltip']                 = "¿Qué se debe hacer con los mensajes de encargos?"
WritCreater.optionStrings['hireling behaviour choices']                 = { "Nada", "Recoger y Eliminar", "Solo recoger" }

WritCreater.optionStrings["allReward"]                                  = "Todas las profesiones"
WritCreater.optionStrings["allRewardTooltip"]                           = "Acción a tomar para todas las profesiones"

WritCreater.optionStrings['sameForALlCrafts']                           = "Use la misma opción para todos"
WritCreater.optionStrings['sameForALlCraftsTooltip']                    = "Usa la misma opción para recompensas de este tipo para todas las profesiones."
WritCreater.optionStrings['1Reward']                                    = "Herrería"
WritCreater.optionStrings['2Reward']                                    = "Usar para todos"
WritCreater.optionStrings['3Reward']                                    = "Usar para todos"
WritCreater.optionStrings['4Reward']                                    = "Usar para todos"
WritCreater.optionStrings['5Reward']                                    = "Usar para todos"
WritCreater.optionStrings['6Reward']                                    = "Usar para todos"
WritCreater.optionStrings['7Reward']                                    = "Usar para todos"

WritCreater.optionStrings["matsReward"]                                 = "Recompensas del tapete"
WritCreater.optionStrings["matsRewardTooltip"]                          = "Qué hacer con las recompensas de material de artesanía"
WritCreater.optionStrings["surveyReward"]                               = "Recompensas de la encuesta"
WritCreater.optionStrings["surveyRewardTooltip"]                        = "Qué hacer con las recompensas de la encuesta"
WritCreater.optionStrings["masterReward"]                               = "Recompensas de escritura maestra"
WritCreater.optionStrings["masterRewardTooltip"]                        = "Qué hacer con las recompensas de escritura maestra"
WritCreater.optionStrings["repairReward"]                               = "Recompensas del kit de reparación"
WritCreater.optionStrings["repairRewardTooltip"]                        = "Qué hacer con las recompensas del kit de reparación"
WritCreater.optionStrings["ornateReward"]                               = "Recompensas de equipo ornamentado"
WritCreater.optionStrings["ornateRewardTooltip"]                        = "Qué hacer con las recompensas de equipo ornamentado"
WritCreater.optionStrings["intricateReward"]                            = "Recompensas de equipo intrincadas"
WritCreater.optionStrings["intricateRewardTooltip"]                     = "Qué hacer con las recompensas de equipo intrincadas"
WritCreater.optionStrings["soulGemReward"]                              = "Gemas de alma vacías"
WritCreater.optionStrings["soulGemTooltip"]                             = "Qué hacer con las gemas del alma vacías"
WritCreater.optionStrings["glyphReward"]                                = "Glifos"
WritCreater.optionStrings["glyphRewardTooltip"]                         = "Que hacer con los glifos"
WritCreater.optionStrings["recipeReward"]                               = "Recetas"
WritCreater.optionStrings["recipeRewardTooltip"]                        = "Que hacer con las recetas"
WritCreater.optionStrings["fragmentReward"]                             = "Fragmentos Psijic"
WritCreater.optionStrings["fragmentRewardTooltip"]                      = "Que hacer con los fragmentos psijic"

WritCreater.optionStrings["writRewards submenu"]                        = "Manejo de recompensas por escrito"
WritCreater.optionStrings["writRewards submenu tooltip"]                = "Qué hacer con todas las recompensas de los escritos"

WritCreater.optionStrings["jubilee"]                                    = "Cajas de aniversario de botín"
WritCreater.optionStrings["jubilee tooltip"]                            = "Cajas de aniversario de botín automático"
WritCreater.optionStrings["skin"]										= "Estilo de Writ Crafter"
WritCreater.optionStrings["skinTooltip"]								= "El estilo de la interfaz de Writ Crafter"
WritCreater.optionStrings["skinOptions"]								= {"Por Defecto", "Cheesy", "Goaty"}
WritCreater.optionStrings["goatSkin"]									= "Goaty"
WritCreater.optionStrings["cheeseSkin"]									= "Cheesy"
WritCreater.optionStrings["defaultSkin"]								= "Por Defecto"
WritCreater.optionStrings["rewardChoices"]                              = { "Nada", "Guardar en el inventario", "Marcar como Basura", "Destruir" }
WritCreater.optionStrings["scan for unopened"]							= "Abrir contenedor al iniciar sesión"
WritCreater.optionStrings["scan for unopened tooltip"]					= "Cuando inicias sesión, se escanea la mochila en busca de contenedores de encargo no abiertos y se intenta abrirlos"

WritCreater.optionStrings["smart style slot save"]						= "El de menor monto primero"
WritCreater.optionStrings["smart style slot save tooltip"]				= "Se intentará minimizar los espacios utilizados si no es ESO+ usando primero los de menor monto de piedras de estilo."
WritCreater.optionStrings["abandon quest for item"]						= "Encargo que requiere <<1>>"
WritCreater.optionStrings["abandon quest for item tooltip"]				= "Si esta DESACTIVADO, automáticamente abandonara los encargos que requieran <<1>>"
WritCreater.optionStrings["status bar submenu"]							= "Opciones de Barra de Estado"
WritCreater.optionStrings["status bar submenu tooltip"]					= "Opciones de Barra de Estado"
WritCreater.optionStrings['showStatusBar']								= "Mostrar la barra de estado"
WritCreater.optionStrings['showStatusBarTooltip']						= "Muestra o Oculta la barra de estado"
WritCreater.optionStrings['statusBarIcons']								= "Usar iconos"
WritCreater.optionStrings['statusBarIconsTooltip']						= "Muestra los iconos de elaboración(crafting) en vez de letras segun el tipo de encargo"
WritCreater.optionStrings['transparentStatusBar']						= "Barra de Estado transparente"
WritCreater.optionStrings['transparentStatusBarTooltip']				= "Hace la barra de estado transparente"
WritCreater.optionStrings['statusBarInventory']							= "Estado del Inventario"
WritCreater.optionStrings['statusBarInventoryTooltip']					= "Se podrá visualizar la cantidad de objetos que tiene el inventario en la barra de estado"

WritCreater.optionStrings["alternate universe"]                         = "Apaga abril"
WritCreater.optionStrings["alternate universe tooltip"]                 = "Desactivar el cambio de nombre de artesanías, estaciones de artesanía y otros artículos interactivos"

--@formatter:on

ZO_CreateStringId("SI_BINDING_NAME_WRIT_CRAFTER_CRAFT_ITEMS", "Artículos de artesanía")
ZO_CreateStringId("SI_BINDING_NAME_WRIT_CRAFTER_OPEN", "Muestra los stats de los artículos de artesanía en una ventana")

-- @todo Falta traducir endeavors
WritCreater.cheeseyLocalizations = {
    ['menuName'] = "Ritual",
    ['endeavorName'] = "Ritual Endeavors",
    ['tasks'] = {
        { original = "You found a strange pamphlet... Maybe you should /read it", name = "You read some instructions on a ritual for luck", completion = "You learned how to do a ritual for luck!",
          description = "Use the /read emote" },

        { original = "???", name = "Obtain an innocent goat's guts", completion = "You monster! Anything for luck, I guess",
          description = "Loot guts from a dead livestock goat. You don't have be the one to kill it... but that's the easiest way" },

        { original = "???", name = "Head to the ritual site, Arananga", completion = "You made it! It seems like a very industrious place",
          description = "Not sure where Arananga is? Maybe it's a 'gifted' crafting station..." },

        { original = "???", name = "Destroy the goat guts", completion = "You 'burnt' the sacrifice",
          description = "Destroy the |H1:item:42870:30:1:0:0:0:0:0:0:0:0:0:0:0:16:0:0:0:1:0:0|h|h you looted" },

        { original = "???", name = "Praise RNGesus in chat", completion = "You feel strangely lucky, but maybe it's just a feeling...",
          description = "You can't really tell what it actually said, but it's your best guess" },
        -- Or Nocturnal, or Fortuna, Tyche as easter eggs?

        -- {original="???", name = "Complete the ritual", completion = "Maybe you'll be just a little bit luckier... And Writ Crafter has a new skin!",
        -- description="Sheogorath will be very pleased if you complete them all!"},
    },
    ["completePrevious"] = "You should probably complete the previous steps first",
    ['allComplete'] = "You completed the ritual!",
    ['allCompleteSubheading'] = "Even if RNGesus doesn't favour you next year, at least Writ Crafter has a new look!",
    ["goatContextTextText"] = "Goat",
    ["bookText"] = [[
    This ritual  |L0:0:0:45%%:8%%:ignore|lwill|l might give you great luck. Make sure to follow these steps exactly!
    1. Obtain some guts from a |L0:0:0:45%%:8%%:ignore|lsheep|l goat
    2. Go to |L0:0:0:45%%:8%%:ignore|lOblivion|l Arananga
    3. Burn the guts
    4. Praise [the name here is illegible]

    - Sincerely,
    |L0:0:0:45%%:8%%:ignore|lSheogorath|l Not Sheogorath]],
    ["bookTitle"] = "A ritual for luck",
    ["outOfRange"] = "You're not in the ritual area anymore!",
    ["closeEnough"] = "Close enough",
    ["praiseHint "] = "Maybe you need to say something about RNGesus?",
}

WritCreater.lang = "es"
WritCreater.langIsMasterWritSupported = true

