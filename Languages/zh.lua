-----------------------------------------------------------------------------------
-- Addon Name: Dolgubon's Lazy Writ Crafter
-- Creator: Dolgubon (Joseph Heinzle)
-- Addon Ideal: Simplifies Crafting Writs as much as possible
-- Addon Creation Date: March 14, 2016
--
-- File Name: Languages/zh.lua
-- File Description: Chinese Localization
-- Load Order Requirements: None
-- 
-----------------------------------------------------------------------------------

WritCreater = WritCreater or {}

local function proper(str)
	if type(str)== "string" then
 return zo_strformat("<<C:1>>",str)
	else
 return str
	end
end

function WritCreater.langWritNames() -- Vital
	-- Exact!!! I know for german alchemy writ is Alchemistenschrieb - so ["G"] = schrieb, and ["A"]=Alchemisten
	local names = {
	["G"] = "委托",
	[CRAFTING_TYPE_ENCHANTING] = "附魔师",
	[CRAFTING_TYPE_BLACKSMITHING] = "铁匠",
	[CRAFTING_TYPE_CLOTHIER] = "制衣",
	[CRAFTING_TYPE_PROVISIONING] = "烹饪师",
	[CRAFTING_TYPE_WOODWORKING] = "木匠",
	[CRAFTING_TYPE_ALCHEMY] = "炼金术士",
	[CRAFTING_TYPE_JEWELRYCRAFTING] = "珠宝",
	}
	return names
end

function WritCreater.langCraftKernels()
	return 
	{
 [CRAFTING_TYPE_ENCHANTING] = "附魔",
 [CRAFTING_TYPE_BLACKSMITHING] = "锻造",
 [CRAFTING_TYPE_CLOTHIER] = "衣服",
 [CRAFTING_TYPE_PROVISIONING] = "烹饪",
 [CRAFTING_TYPE_WOODWORKING] = "木工",
 [CRAFTING_TYPE_ALCHEMY] = "炼金术",
 [CRAFTING_TYPE_JEWELRYCRAFTING] = "珠宝制作",
	}
end

function WritCreater.langMasterWritNames() -- Vital
	local names = {
	["M"] = "masterful",
	["M1"] = "master",
	[CRAFTING_TYPE_ALCHEMY] = "concoction",
	[CRAFTING_TYPE_ENCHANTING] = "雕文",
	[CRAFTING_TYPE_PROVISIONING]	= "feast",
	["plate"] = "plate",
	["tailoring"]	= "tailoring",
	["leatherwear"]	= "leatherwear",
	["weapon"] = "武器",
	["shield"] = "盾牌",
	}
return names
end

function WritCreater.writCompleteStrings() -- Vital for translation
	local strings = {
	["place"] = "<将货物放进箱子。>",
	["sign"] = "Sign the Manifest",
	["masterPlace"] = "I've finished the ",
	["masterSign"] = "<完成制作任务>",
	["masterStart"] = "<接受契约。>",
	["Rolis Hlaalu"] = "Rolis Hlaalu", -- This is the same in most languages but ofc chinese and japanese
	["Deliver"] = "交付",
	}
	return strings
end

function WritCreater.languageInfo() -- Vital
	local craftInfo = 
	{
		[ CRAFTING_TYPE_CLOTHIER] = 
		{
			["pieces"] = --exact!!
			{
				[1] = "长袍",
				[2] = "短衣",
				[3] = "鞋子",
				[4] = "手套",
				[5] = "帽子",
				[6] = "长裤",
				[7] = "肩饰",
				[8] = "饰带",
				[9] = "上衣",
				[10]= "靴子",
				[11]= "护腕",
				[12]= "头盔",
				[13]= "护腿",
				[14]= "护肩",
				[15]= "腰带",
			},
			["match"] = --exact!!! This is not the material, but rather the prefix the material gives to equipment. e.g. Homespun Robe, Linen Robe
			{
				[1] = "手工", --lvtier one of mats
				[2] = "亚麻",	--l
				[3] = "棉",
				[4] = "蛛丝",
				[5] = "乌丝",
				[6] = "克雷什",
				[7] = "紫苑草织物",
				[8] = "银叶花织物",
				[9] = "影织",
				[10]= "先祖丝绸",
				[11]= "生皮",
				[12]= "兽皮",
				[13]= "皮革",
				[14]= "全皮",
				[15]= "兽皮",
				[16]= "布莱根丁防弹衣",
				[17]= "铁皮",
				[18]= "超级",
				[19]= "暗影兽皮",
				[20]= "发红皮革",
			},	
		},
		[CRAFTING_TYPE_BLACKSMITHING] = 
		{
			["pieces"] = --exact!!
			{
				[1] = "斧头",
				[2] = "钉锤",
				[3] = "剑",
				[4] = "战斧",
				[5] ="重锤",
				[6] ="巨剑",
				[7] = "匕首",
				[8] = "胸铠",
				[9] = "足铠",
				[10] = "手铠",
				[11] = "重盔",
				[12] = "腿铠",
				[13] = "肩铠",
				[14] = "腰铠",
			},
			["match"] = --exact!!! This is not the material, but rather the prefix the material gives to equipment. e.g. Iron Axe, Steel Axe
			{
				[1] = "铁",
				[2] = "钢",
				[3] = "山铜",
				[4] = "矮人",
				[5] = "乌木",
				[6] = "月长石铜",
				[7] = "水银钢",
				[8] = "水银",
				[9] = "虚无之钢",
				[10]= "赤晶",
			},
		},
		[CRAFTING_TYPE_WOODWORKING] = 
		{
			["pieces"] = --Exact!!!
			{
				[1] = "弓",
				[3] = "炼狱法杖",
				[4] = "寒冰法杖",
				[5] = "闪电法杖",
				[6] = "恢复法杖",
				[2] = "盾牌",
			},
			["match"] = --exact!!! This is not the material, but rather the prefix the material gives to equipment. e.g. Maple Bow. Oak Bow.
			{
				[1] = "枫木",
				[2] = "橡木",
				[3] = "榉木",
				[4] = "山核桃木",
				[5] = "紫杉木",
				[6] = "桦木",
				[7] = "梣木",
				[8] = "红木",
				[9] = "夜木",
				[10] = "赤晶梣木",
			},
		},
		[CRAFTING_TYPE_JEWELRYCRAFTING] = 
		{
			["pieces"] = --Exact!!!
			{
				[1] = "戒指",
				[2] = "项链",
			},
			["match"] = --exact!!! This is not the material, but rather the prefix the material gives to equipment. e.g. Maple Bow. Oak Bow.
			{
				[1] = "锡", -- 1
				[2] = "铜", -- 26
				[3] = "银", -- CP10
				[4] = "银金", --CP80
				[5] = "铂金", -- CP150
			},
		},
		[CRAFTING_TYPE_ENCHANTING] = 
		{
			["pieces"] = --exact!!
			{ --{String Identifier, ItemId, positive or negative}
				{"disease", 45841,2},
				{"污染", 45841,1},
				{"absorb stamina", 45833,2},
				{"absorb magicka", 45832,2},
				{"absorb health", 45831,2},
				{"frost resist",45839,2},
				{"frost",45839,1},
				{"feat", 45836,2},
				{"耐力恢复", 45836,1},
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
				{"魔法恢复", 45835,1},
				{"spell cost", 45835,2},
				{"shock resist",45840,2},
				{"shock",45840,1},
				{"生命恢复",45834,1},
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
				{"普通",45850},
				{"优良",45851},
				{"上乘",45852},
				{"史诗",45853},
				{"传说",45854},
				{"", 45850} -- default, if nothing is mentioned. Default should be Ta.
			}
		},
	} 
	return craftInfo
end

function WritCreater.masterWritQuality() -- Vital . This is probably not necessary, but it stays for now because it works
	return {{"上乘",3},{"史诗",4},{"传说",5}}
end

function WritCreater.langEssenceNames() -- Vital
	local essenceNames = 
	{
		[1] = "奥科", --health
		[2] = "德尼", --stamina
		[3] = "马可", --magicka
	}
	return essenceNames
end

function WritCreater.langPotencyNames() -- Vital
	--exact!! Also, these are all the positive runestones - no negatives needed.
	local potencyNames = 
	{
		[1] = "乔拉", --Lowest potency stone lvl
		[2] = "伯拉德",
		[3] = "杰拉",
		[4] = "杰乔拉",
		[5] = "欧达",
		[6] = "伯乔拉",
		[7] = "艾多拉",
		[8] = "杰尔拉",
		[9] = "伯拉",
		[10]= "德纳拉",
		[11]= "雷拉",
		[12]= "德拉多",
		[13]= "雷库拉",
		[14]= "库拉",
		[15]= "勒杰拉",
		[16]= "雷波拉", --v16 potency stone
	}
	return potencyNames
end

function WritCreater.questExceptions(condition)
	condition = string.gsub(condition, " "," ")
	return condition
end

function WritCreater.enchantExceptions(condition)
	condition = string.gsub(condition, " "," ")
	return condition
end

function WritCreater.langTutorial(i) 
	local t = {
		[5]="你还应该了解的这些。\n首先，/dailyreset 是一个斜杠命令，可以查看距离服务器重置每日委托任务还有多长时间。",
		[4]="最后，你还可以为每个委托类别单独开启或关闭此插件。\n默认情况下，所有适用的委托类别都处于开启状态。\n如果你想对某些委托类别关闭，请到设置中进行修改。",
		[3]="接下来，你需要选择是否希望在使用制作站时看到此窗口。\n该窗口将告诉制作委托需要多少材料，以及你当前拥有多少材料。",
		[2]="要选择的第一个设置是是否要开启自动制作，\n如果设置为开启，当打开制作站时，插件将自动开始制作。",
		[1]="欢迎使用 Dolgubon's Lazy Writ Crafter!\n你应该首先选择一些设置。\n 你可以随时在设置菜单中更改设置。",
	}
	return t[i]
end

function WritCreater.langTutorialButton(i,onOrOff) -- sentimental and short please. These must fit on a small button
	local tOn = 
	{
		[1]="默认",
		[2]="开",
		[3]="显示",
		[4]="继续",
		[5]="完成",
	}
	local tOff=
	{
		[1]="继续",
		[2]="关闭",
		[3]="不显示",
	}
	if onOrOff then
		return tOn[i]
	else
		return tOff[i]
	end
end

-- 制作站名称
function WritCreater.langStationNames()
	return
	{
		["锻造台"] = 1, 
		["制衣台"] = 2, 
		["附魔台"] = 3,
		["炼金台"] = 4, 
		["烹饪火焰"] = 5, 
		["木工台"] = 6, 
		["珠宝制作台"] = 7, 
	}
end

-- 制作任务奖励容器名称
function WritCreater.langWritRewardBoxes () return {
	[CRAFTING_TYPE_ALCHEMY] = "炼金术士的器皿",
	[CRAFTING_TYPE_ENCHANTING] = "附魔师的宝箱",
	[CRAFTING_TYPE_PROVISIONING] = "烹饪师的包裹",
	[CRAFTING_TYPE_BLACKSMITHING] = "铁匠的木箱",
	[CRAFTING_TYPE_CLOTHIER] = "制衣匠的背包",
	[CRAFTING_TYPE_WOODWORKING] = "木匠的箱子",
	[CRAFTING_TYPE_JEWELRYCRAFTING] = "珠宝工匠盒",
	[8] = "箱",
}
end

function WritCreater.getTaString()
	return "塔"
end

WritCreater.lang = "zh"
WritCreater.langIsMasterWritSupported = true

-- 距离服务器每日重置时长查询
local function dailyResetFunction(till)
	if till["hour"]==0 then
		if till["minute"]==1 then
			return "距离服务器每日重置还剩 1 分钟！"
		elseif till["minute"]==0 then
			if stamp==1 then
				return "距离每日重置"..stamp.."秒！"
			else
				return "巧了，服务器正在重置每日制作委托任务。"
			end
		else
			return "距离每日重置" .. till["minute"] .."分钟！"
		end
	else
		return "距离每日重置" .. till["hour"].."小时".. till["minute"] .."分钟！"
	end 
end

local function masterWritEnchantToCraft (pat,set,trait,style,qual,mat,writName,Mname,generalName)
	local partialString = zo_strformat("<<t:6>>的<<t:1>> 套装：<<t:2>> 特性：<<t:3>> 样式：<<t:4>> 品质:<<t:5>> 已制作",pat,set,trait,style,qual,mat)
	return zo_strformat("<<t:2>>的<<t:3>><<t:4>>: <<1>>",partialString,writName,Mname,generalName )
end

local function runeMissingFunction (ta,essence,potency)
	local missing = {}
	if not ta["bag"] then
		missing[#missing + 1] = "|r"..ZO_CachedStrFormat("<<C:1>>",ta["slot"]).."|cf60000"
	end
	if not essence["bag"] then
		missing[#missing + 1] = "|cffcc66"..ZO_CachedStrFormat("<<C:1>>",essence["slot"]).."|cf60000"
	end
	if not potency["bag"] then
		missing[#missing + 1] = "|c0066ff"..ZO_CachedStrFormat("<<C:1>>",potency["slot"]).."|r"
	end
	local text = ""
	for i = 1, #missing do
		if i ==1 then
			ZO_CachedStrFormat("<<C:1>>",missing[i])
			text = "|cff3333无法制作雕文\n缺少: "..ZO_CachedStrFormat("<<C:1>>",missing[i])
		else
			text = text.." 或 "..ZO_CachedStrFormat("<<C:1>>",missing[i])
		end
	end
	return text
end

WritCreater.strings = WritCreater.strings or {}
WritCreater.strings["runeReq"] = function (essence, potency) return zo_strformat("|c2dff00需要 1 |r塔|c2dff00, 1 |cffcc66<<1>>|c2dff00 和 1 |c0066ff<<2>>|r", essence, potency) end
WritCreater.strings["runeMissing"] = runeMissingFunction 
WritCreater.strings["notEnoughSkill"]	= "你的制作技能等级不足以制作所需物品！"
WritCreater.strings["smithingMissing"] = "\n|cf60000材料不足！|r"
WritCreater.strings["craftAnyway"] = "强制制作"
WritCreater.strings["smithingEnough"] = "\n|c2dff00材料数量已满足要求|r"
WritCreater.strings["craft"] = "|c00ff00制作|r"
WritCreater.strings["crafting"] = "|c00ff00制作中...|r"
WritCreater.strings["craftIncomplete"] = "|cf6000制作未完成，材料不足。|r"
WritCreater.strings["moreStyle"] = "|cf60000没有可用的样式材料。\n检查你的背包、成就和设置。|r"
WritCreater.strings["moreStyleSettings"] = "|cf60000没有可用的样式材料。\n你可能需要在“设置”中允许使用更多种样式材料。|r"
WritCreater.strings["moreStyleKnowledge"] = "|cf60000没有可用的样式材料。\n你的角色可能需要学习更多的样式。|r"
WritCreater.strings["dailyreset"] = dailyResetFunction
WritCreater.strings["complete"] = "|c00FF00完成委托任务。|r"
WritCreater.strings["craftingstopped"]= "制作已停止，请检查插件正在制作的物品是否正确。"
WritCreater.strings["smithingReqM"] = function (amount, type, more) return zo_strformat( "制作需要 <<1>> <<2>> (|cf60000还差 <<3>>|r)" ,amount, type, more) end
WritCreater.strings["smithingReq"] = function (amount,type, current) return zo_strformat( "制作需要 <<1>> <<2>> (|c2dff00<<3>> 可用|r)" ,amount, type, current) end
WritCreater.strings["lootReceived"]= "获得 <<3>> <<1>> (你有 <<2>>)"
WritCreater.strings["lootReceivedM"]= "获得 <<1>> "
WritCreater.strings["countSurveys"]= "你有 <<1>> surveys"
WritCreater.strings["countVouchers"]= "你有 <<1>> unearned Writ Vouchers"
WritCreater.strings["includesStorage"]= function(type) local a= {"Surveys", "Master Writs"} a = a[type] return zo_strformat("Count includes <<1>> in house storage", a) end
WritCreater.strings["surveys"] = "Crafting Surveys"
WritCreater.strings["sealedWrits"]	= "密封委托"
WritCreater.strings["masterWritEnchantToCraft"]	= function(lvl, type, quality, writCraft, writName, generalName) 
	return zo_strformat("<<t:4>> <<t:5>> <<t:6>>: 制作 <<t:3>> 品质 <<t:1>> <<t:2>> 的雕文 ",lvl, type, quality,writCraft,writName, generalName) 
end
WritCreater.strings["masterWritSmithToCraft"] = masterWritEnchantToCraft
WritCreater.strings["withdrawItem"]= function(amount, link, remaining) return "Dolgubon's Lazy Writ Crafter retrieved "..amount.." "..link..". ("..remaining.." in bank)" end -- in Bank for German
WritCreater.strings['fullBag'] = "背包已满，请先清理背包。"
WritCreater.strings['masterWritSave']= "Dolgubon's Lazy Writ Crafter 使你避免意外接受大师委托！ 可以到设置中关闭此选项。"
WritCreater.strings['missingLibraries'] = "Dolgubon's Lazy Writ Crafter 依赖以下库。请下载、安装这些库： "
WritCreater.strings['resetWarningMessageText'] = "委托任务的每日重置时间为 <<1>> 小时 <<2>> 分钟\n你可以在设置中自定义或关闭此提醒。"
WritCreater.strings['resetWarningExampleText'] = "提醒将如下所示"
WritCreater.strings['lowInventory']	= "\n你的背包剩余 <<1>> 格空间，可能装不下本次制作的物品。"


WritCreater.optionStrings = {}
WritCreater.optionStrings.nowEditing = "你正在更改 %s 设置"
WritCreater.optionStrings.accountWide = "帐户范围"
WritCreater.optionStrings.characterSpecific = "特定角色"
WritCreater.optionStrings.useCharacterSettings = "使用角色设置" -- de
WritCreater.optionStrings.useCharacterSettingsTooltip = "仅对此角色使用特定的设置" --de
WritCreater.optionStrings["style tooltip"] = function (styleName, styleStone)	return zo_strformat("允许插件使用样式材料 <<1>> 制作 <<2>> 样式。", styleStone, styleName) end
WritCreater.optionStrings["show craft window"] = "显示制作窗口"
WritCreater.optionStrings["show craft window tooltip"]	= "打开制作站时显示制作窗口"
WritCreater.optionStrings["autocraft"]	= "自动制作"
WritCreater.optionStrings["autocraft tooltip"] = "启用后，在进入制作站后插件将立即开始制作。如果未显示该窗口，则该窗口将打开。"
WritCreater.optionStrings["blackmithing"]= "锻造"
WritCreater.optionStrings["blacksmithing tooltip"] = "开/关锻造插件"
WritCreater.optionStrings["clothing"]	= "制衣"
WritCreater.optionStrings["clothing tooltip"] = "开/关制衣插件"
WritCreater.optionStrings["enchanting"]	= "附魔"
WritCreater.optionStrings["enchanting tooltip"] = "开/关附魔插件"
WritCreater.optionStrings["alchemy"]	= "炼金"
WritCreater.optionStrings["alchemy tooltip"] = "开/关炼金插件（仅限从银行取出）"
WritCreater.optionStrings["provisioning"]= "烹饪"
WritCreater.optionStrings["provisioning tooltip"] = "开/关烹饪插件（仅限从银行取出）"
WritCreater.optionStrings["woodworking"]= "木工"
WritCreater.optionStrings["woodworking tooltip"] = "开/关木工插件"
WritCreater.optionStrings["jewelry crafting"] = "珠宝制作"
WritCreater.optionStrings["jewelry crafting tooltip"]	= "开/关珠宝制作插件"
WritCreater.optionStrings["writ grabbing"]= "取出所需物品"
WritCreater.optionStrings["writ grabbing tooltip"] = "从银行取出委托任务所需物品（如：奈恩根、塔等）。"
WritCreater.optionStrings["style stone menu"] = "使用样式材料"
WritCreater.optionStrings["style stone menu tooltip"]	= "选择允许插件使用的样式材料"
WritCreater.optionStrings["send data"]	= "发送委托任务数据"
WritCreater.optionStrings["send data tooltip"] = "发送获得的委托任务奖励容器中的物品信息。不发送其他信息。"
WritCreater.optionStrings["exit when done"]= "退出制作窗口"
WritCreater.optionStrings["exit when done tooltip"] = "完成所有制作后退出制作窗口"
WritCreater.optionStrings["automatic complete"] = "自动接任务"
WritCreater.optionStrings["automatic complete tooltip"]	= "到达所需位置时自动接受并完成任务"
WritCreater.optionStrings["new container"]= "保持新状态"
WritCreater.optionStrings["new container tooltip"] = "保持委托奖励容器的新状态"
WritCreater.optionStrings["master"] = "大师委托"
WritCreater.optionStrings["master tooltip"]= "如果开启，插件将制作接受的大师委托。"
WritCreater.optionStrings["right click to craft"] = "右击制作"
WritCreater.optionStrings["right click to craft tooltip"]= "如果开启，插件将制作大师委托，右键点击一个大师委托，选择密封委托后制作。（启用 LibCustomMenu 插件后可用）"
WritCreater.optionStrings["crafting submenu"] = "制作委托"
WritCreater.optionStrings["crafting submenu tooltip"]	= "开/关特定制作委托的插件"
WritCreater.optionStrings["timesavers submenu"] = "节省时间"
WritCreater.optionStrings["timesavers submenu tooltip"]	= "各种节省时间设置"
WritCreater.optionStrings["loot container"]= "打开委托任务奖励"
WritCreater.optionStrings["loot container tooltip"] = "自动打开收到的委托任务奖励"
WritCreater.optionStrings["master writ saver"] = "保存大师委托"
WritCreater.optionStrings["master writ saver tooltip"]	= "阻止接受大师委托"
WritCreater.optionStrings["loot output"]= "有价值的奖励提醒"
WritCreater.optionStrings["loot output tooltip"] = "从委托奖励中收到贵重物品时输出消息"
WritCreater.optionStrings["autoloot behaviour"] = "自动打开行为" -- Note that the following three come early in the settings menu, but becuse they were changed
WritCreater.optionStrings["autoloot behaviour tooltip"]	= "设置插件如何打开容器" -- they are now down below (with untranslated stuff)
WritCreater.optionStrings["autoloot behaviour choices"]	= {"使用游戏默认的设置", "自动打开", "不自动打开"}
WritCreater.optionStrings["hide when done"]= "完成后隐藏"
WritCreater.optionStrings["hide when done tooltip"] = "制作完所有物品后隐藏插件窗口"
WritCreater.optionStrings['reticleColour']= "更改制作站名称颜色"
WritCreater.optionStrings['reticleColourTooltip'] = "如果在制作站有未完成的委托，则会更改制作站名字颜色。"
WritCreater.optionStrings['autoCloseBank']= "自动银行对话框"
WritCreater.optionStrings['autoCloseBankTooltip'] = "如果有要从银行取出的材料，则自动打开和退出银行对话框"
WritCreater.optionStrings['despawnBanker']= "解散银行家"
WritCreater.optionStrings['despawnBankerTooltip'] = "取出需要的材料后自动解散银行家"
WritCreater.optionStrings['dailyResetWarnTime'] = "提前多少分钟提醒"
WritCreater.optionStrings['dailyResetWarnTimeTooltip']	= "提前多少分钟提醒每日委托任务将要重置"
WritCreater.optionStrings['dailyResetWarnType'] = "每日委托任务重置提醒"
WritCreater.optionStrings['dailyResetWarnTypeTooltip']	= "即将重置每日委托任务时，显示哪种类型的提醒"
WritCreater.optionStrings['dailyResetWarnTypeChoices']	={ "None","Type 1", "Type 2", "Type 3", "Type 4", "All"}
WritCreater.optionStrings['stealingProtection'] = "偷窃保护"
WritCreater.optionStrings['stealingProtectionTooltip']	= "防止在有委托任务时偷取和扒窃"
WritCreater.optionStrings['noDELETEConfirmJewelry'] = "轻松销毁珠宝委托"
WritCreater.optionStrings['noDELETEConfirmJewelryTooltip']= "自动将“DELETE”文本确认添加到“删除珠宝委托”对话框中"
WritCreater.optionStrings['suppressQuestAnnouncements']	= "隐藏委托任务公告"
WritCreater.optionStrings['suppressQuestAnnouncementsTooltip'] = "开始委托或为所作物品时，隐藏在屏幕中央显示的文字"
WritCreater.optionStrings["questBuffer"]= "预留任务空间"
WritCreater.optionStrings["questBufferTooltip"] = "限制接取任务数，以便有空间可以接受委托任务。"
WritCreater.optionStrings["craftMultiplier"] = "制作倍数"
WritCreater.optionStrings["craftMultiplierTooltip"] = "一次制作多个物品，这样下次需要时就不需要重新制作。\n注意：每增加 1 个以上大约可以节省 37 格背包空间。"
WritCreater.optionStrings['hireling behaviour'] = "雇员邮件操作"
WritCreater.optionStrings['hireling behaviour tooltip']	= "雇员邮件应该怎么做"
WritCreater.optionStrings['hireling behaviour choices']	= { "无","获取附件并删除", "仅获取附件"}


WritCreater.optionStrings["allReward"]	= "所有制作类别"
WritCreater.optionStrings["allRewardTooltip"] = "对所有制作类别生效"

WritCreater.optionStrings['sameForALlCrafts'] = "使用相同的选项"
WritCreater.optionStrings['sameForALlCraftsTooltip']	= "对所有制作类别使用相同的选项来处理此类奖励"
WritCreater.optionStrings['1Reward']	= "锻造"
WritCreater.optionStrings['2Reward']	= "适用于所有"
WritCreater.optionStrings['3Reward']	= "适用于所有"
WritCreater.optionStrings['4Reward']	= "适用于所有"
WritCreater.optionStrings['5Reward']	= "适用于所有"
WritCreater.optionStrings['6Reward']	= "适用于所有"
WritCreater.optionStrings['7Reward']	= "适用于所有"

WritCreater.optionStrings["matsReward"]	= "材料奖励"
WritCreater.optionStrings["matsRewardTooltip"] = "如何处理奖励的制作材料"
WritCreater.optionStrings["surveyReward"]= "调查奖励"
WritCreater.optionStrings["surveyRewardTooltip"] = "如何处理奖励的调查"
WritCreater.optionStrings["masterReward"]= "大师委托奖励"
WritCreater.optionStrings["masterRewardTooltip"] = "如何处理奖励的大师委托"
WritCreater.optionStrings["repairReward"]= "修理包奖励"
WritCreater.optionStrings["repairRewardTooltip"] = "如何处理奖励的维修包"
WritCreater.optionStrings["ornateReward"]= "华丽装备奖励"
WritCreater.optionStrings["ornateRewardTooltip"] = "如何处理奖励的华丽装备"
WritCreater.optionStrings["intricateReward"] = "精巧装备奖励"
WritCreater.optionStrings["intricateRewardTooltip"] = "如何处理奖励的精巧装备"
WritCreater.optionStrings["soulGemReward"]= "空灵魂石"
WritCreater.optionStrings["soulGemTooltip"]= "如何处理奖励的空灵魂石"
WritCreater.optionStrings["glyphReward"]= "雕文"
WritCreater.optionStrings["glyphRewardTooltip"] = "如何处理奖励的雕文"
WritCreater.optionStrings["recipeReward"]= "配方"
WritCreater.optionStrings["recipeRewardTooltip"] = "如何处理奖励的配方"
WritCreater.optionStrings["fragmentReward"]= "塞伊克碎片"
WritCreater.optionStrings["fragmentRewardTooltip"] = "如何处理奖励的塞伊克碎片"
WritCreater.optionStrings["writRewards submenu"] = "委托任务奖励处理"
WritCreater.optionStrings["writRewards submenu tooltip"]= "如何处理委托任务的奖励"
WritCreater.optionStrings["jubilee"]	= "打开周年纪念箱"
WritCreater.optionStrings["jubilee tooltip"] = "自动打开周年纪念箱"
WritCreater.optionStrings["skin"] = "Writ Crafter Skin"
WritCreater.optionStrings["skinTooltip"]= "The skin for the Writ Crafter UI"
WritCreater.optionStrings["skinOptions"]= {"Default", "Cheesy", "Goaty"}
WritCreater.optionStrings["goatSkin"]	= "Goaty"
WritCreater.optionStrings["cheeseSkin"]	= "Cheesy"
WritCreater.optionStrings["defaultSkin"]= "Default"
WritCreater.optionStrings["rewardChoices"]= {"不自动处理","放入银行","标记为废品", "摧毁"}
WritCreater.optionStrings["scan for unopened"] = "上线时打开容器"
WritCreater.optionStrings["scan for unopened tooltip"]	= "上线时尝试打开背包中的委托任务奖励容器。"

WritCreater.optionStrings["smart style slot save"] = "优先使用数量少的样式材料"
WritCreater.optionStrings["smart style slot save tooltip"]= "如果不是 ESO Plus，将尝试优先使用数量较少的样式材料，尽量减少占用背包空间。"
WritCreater.optionStrings["abandon quest for item"] = "需要 <<1>> 的委托"
WritCreater.optionStrings["abandon quest for item tooltip"]= "如果关闭，将自动放弃需要 <<1>> 的委托"
WritCreater.optionStrings["status bar submenu"] = "状态栏选项"
WritCreater.optionStrings["status bar submenu tooltip"]	= "状态栏选项"
WritCreater.optionStrings['showStatusBar']= "显示状态栏"
WritCreater.optionStrings['showStatusBarTooltip'] = "显示或隐藏任务状态栏"
WritCreater.optionStrings['statusBarIcons']= "显示图标"
WritCreater.optionStrings['statusBarIconsTooltip'] = "显示每种委托类型的图标而不是字母"
WritCreater.optionStrings['transparentStatusBar'] = "透明状态条"
WritCreater.optionStrings['transparentStatusBarTooltip']= "将状态条背景设置为透明"
WritCreater.optionStrings['statusBarInventory'] = "背包跟踪器"
WritCreater.optionStrings['statusBarInventoryTooltip']	= "在状态条中显示背包总容量及已使用量"
