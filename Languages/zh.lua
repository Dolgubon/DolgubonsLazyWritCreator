

-- If you are looking to translate this to something else, and run into problems, please contact Dolgubon on ESOUI.
local function proper(str)
	if type(str)== "string" then
		return zo_strformat("<<C:1>>",str)
	else
		return str
	end
end

function WritCreater.langWritNames() --Exact!!!  I know for german alchemy writ is Alchemistenschrieb - so ["G"] = schrieb, and ["A"]=Alchemisten
	local names = {
	["G"] = "令状",
	[CRAFTING_TYPE_ENCHANTING] = "附魔",
	[CRAFTING_TYPE_BLACKSMITHING] = "锻造",
	[CRAFTING_TYPE_CLOTHIER] = "制衣",
	[CRAFTING_TYPE_PROVISIONING] = "烹饪",
	[CRAFTING_TYPE_WOODWORKING] = "木工",
	[CRAFTING_TYPE_ALCHEMY] = "炼金",
	}
	return names
end

function WritCreater.langMasterWritNames()
	local names = {
		["M"] 							= "大师",	--when complete master writ quest
		["M1"]							= "大师",
		[CRAFTING_TYPE_ALCHEMY]			= "药剂",
		[CRAFTING_TYPE_ENCHANTING]		= "附魔",
		[CRAFTING_TYPE_PROVISIONING]	= "食物",
		["plate"]						= "防具",
		["tailoring"]					= "衣服",
		["leatherwear"]					= "皮革",
		["weapon"]						= "武器",
		["shield"]						= "盾牌",
	}
	return names
end
--[[
function WritCreater.langMasterWritNames()
	local names = {
	["M"] 							= "masterful",	--when complete master writ quest
	["M1"]							= "master",
	[CRAFTING_TYPE_ALCHEMY]			= "concoction",
	[CRAFTING_TYPE_ENCHANTING]		= "glyph",
	[CRAFTING_TYPE_PROVISIONING]	= "feast",
	["plate"]						= "plate",
	["tailoring"]					= "tailoring",
	["leatherwear"]					= "leatherwear",
	["weapon"]						= "weapon",
	["shield"]						= "shield",
	}
return names
end]]

function WritCreater.writCompleteStrings()
	local strings = {
	["place"] = "将货物放入箱中",
	["sign"] = "签署货单",
	["masterPlace"] = "I've finished the ",
	["masterSign"] = "<Finish the job.>",
	["masterStart"] = "<Accept the contract.>",
	}
	return strings
end


function WritCreater.languageInfo() --exact!!!

local craftInfo = 
	{
		[ CRAFTING_TYPE_CLOTHIER] = 
		{
			["pieces"] = --exact!!
			{
				[1] = "长袍",
				[2] = "衬衣",
				[3] = "布鞋",
				[4] = "手套",
				[5] = "帽子",
				[6] = "长裤",
				[7] = "披肩",
				[8] = "腰带",
				[9] = "护胸",
				[10]= "长靴",
				[11]= "护腕",
				[12]= "头盔",
				[13]= "护腿",
				[14]= "护肩",
				[15]= "护腰",
			},
			["match"] = --exact!!! This is not the material, but rather the prefix the material gives to equipment. e.g. Homespun Robe, Linen Robe
			{
				[1] = "手编的", --lvtier one of mats
				[2] = "亚麻",	--l
				[3] = "棉布制",
				[4] = "蛛丝",
				[5] = "乌晶丝",
				[6] = "天蚕丝",
				[7] = "铁柳丝",
				[8] = "白银布",
				[9] = "虚空布制",
				[10]= "先祖之丝",
				[11]= "生皮",
				[12]= "毛皮",
				[13]= "皮革",
				[14]= "全革",
				[15]= "兽皮",
				[16]= "锁子甲",
				[17]= "精铁革",
				[18]= "上等的",
				[19]= "暗影皮制",
				[20]= "湮红皮制",
			},
			["names"] = --Does not strictly need to be exact, but people would probably appreciate it
			{
				[1] = "黄麻布",
				[2] = "亚麻",
				[3] = "棉布",
				[4] = "蛛丝",
				[5] = "乌晶布",
				[6] = "天蚕丝绸",
				[7] = "铁柳丝绸",
				[8] = "白银布",
				[9] = "虚空布",
				[10]= "先祖之绸",
				[11]= "生毛皮",
				[12]= "熟毛皮",
				[13]= "轻皮",
				[14]= "重皮",
				[15]= "兽皮",
				[16]= "精纹皮",
				[17]= "精铁皮",
				[18]= "奢华皮",
				[19]= "暗影毛皮",
				[20]= "湮红皮",
			}		
		},
		[CRAFTING_TYPE_BLACKSMITHING] = 
		{
			["pieces"] = --exact!!
			{
				[1] = "手斧",
				[2] = "矛锤",
				[3] = "长剑",
				[4] = "大斧",
				[5] = "大锤",
				[6] = "大剑",
				[7] = "匕首",
				[8] = "胸铠",
				[9] = "足铠",
				[10] = "手铠",
				[11] = "头铠",
				[12] = "腿铠",
				[13] = "肩铠",
				[14] = "腰铠",
			},
			["match"] = --exact!!! This is not the material, but rather the prefix the material gives to equipment. e.g. Iron Axe, Steel Axe
			{
				[1] = "铁制",
				[2] = "钢铁",
				[3] = "山铜制",
				[4] = "锻莫制",
				[5] = "乌晶制",
				[6] = "钙石制",
				[7] = "锰晶制",
				[8] = "水银制",
				[9] = "虚空钢制",
				[10]= "湮红矿制",
			},
			["names"] = --Does not strictly need to be exact, but people would probably appreciate it
			{
				[1] = "铁锭",
				[2] = "钢锭",
				[3] = "山铜锭",
				[4] = "锻莫锭",
				[5] = "乌晶锭",
				[6] = "钙石锭",
				[7] = "锰晶锭",
				[8] = "水银锭",
				[9] = "虚空锭",
				[10]= "湮红锭",
			}
		},
		[CRAFTING_TYPE_WOODWORKING] = 
		{
			["pieces"] = --Exact!!!
			{
				[1] ="长弓",
				[3] ="火焰法杖",
				[4] ="冰冻法杖",
				[5] ="闪电法杖",
				[6] ="恢复法杖",
				[2] ="盾牌",
			},
			["match"] = --exact!!! This is not the material, but rather the prefix the material gives to equipment. e.g. Maple Bow. Oak Bow.
			{
				[1] = "枫木",
				[2] =  "橡木",
				[3] =  "榉木",
				[4] = "胡桃木",
				[5] = "杉木",
				[6] =  "桦木",
				[7] = "灰木",
				[8] = "桃心木",
				[9] = "夜木",
				[10] = "湮红木制",
			},
			["names"] = --Does not strictly need to be exact, but people would probably appreciate it
			{
				[1] = "光滑的枫木",
				[2] = "光滑的橡木",
				[3] = "光滑的榉木",
				[4] = "光滑的胡桃木",
				[5] = "光滑的杉木",
				[6] = "光滑的桦木",
				[7] = "光滑的灰木",
				[8] = "光滑的桃心木",
				[9] = "光滑的夜木",
				[10]= "光滑的烬红木",
			}
		},
		[CRAFTING_TYPE_ENCHANTING] = 
		{
			["pieces"] = --exact!!
			{ --{String Identifier, ItemId, positive or negative}
				{"瘟疫", 45841,2},
				{"疾病抗性", 45841,1},
				{"耐力吸收", 45833,2},
				{"魔法吸收", 45832,2},
				{"生命吸收", 45831,2},
				{"冰冻抗性",45839,2},
				{"寒冰",45839,1},
				{"技耗缩减", 45836,2},
				{"耐力恢复", 45836,1},
				{"石化", 45842,1},
				{"冲击", 45842,2},
				{"onslaught", 68342,2},
				{"defence", 68342,1},
				{"防御",45849,2},
				{"强击",45849,1},
				{"毒素抗性",45837,2},
				{"毒系",45837,1},
				{"魔抗降低",45848,2},
				{"法术强化",45848,1},
				{"魔法恢复", 45835,1},
				{"魔耗缩减", 45835,2},
				{"闪电抗性",45840,2},
				{"闪电",45840,1},
				{"生命恢复",45834,1},
				{"生命减少",45834,2},
				{"衰弱",45843,2},
				{"强化攻击",45843,1},
				{"药剂强化",45846,1},
				{"药剂加速",45846,2},
				{"火焰抗性",45838,2},
				{"火焰",45838,1},
				{"物抗降低", 45847,2},
				{"物攻强化", 45847,1},
				{"耐力增强",45833,1},
				{"生命增强",45831,1},
				{"魔法增强",45832,1}
			},
			["match"] = --exact!!! The names of glyphs. The prefix (in English) So trifling glyph of magicka, for example
			{
				[1] = {"微不足道的", 45855},
				[2] = {"次等的",45856},
				[3] = {"琐碎的",45857},
				[4] = {"少量的",45806},
				[5] = {"一般的",45807},
				[6] = {"正常的",45808},
				[7] = {"正适的",45809},
				[8] = {"熟练的",45810},
				[9] = {"强力的",45811},
				[10]= {"优秀的",45812},
				[11]= {"稀有的",45813},
				[12]= {"至高的",45814},
				[13]= {"究极的",45815},
				[14]= {"传说的",45816},
				[15]= {"真实优秀的",{68341,68340,},},
				[16]= {"上等的",{64509,64508,},},
				
			},
			["quality"] = 
			{
				{"普通",45850},
				{"优秀",45851},
				{"精良",45852},
				{"史诗",45853},
				{"传说",45854},
				{"", 45850} -- default, if nothing is mentioned. Default should be Ta.
			}
		},
	} 

	return craftInfo

end





function WritCreater.langEssenceNames() --exact!

local essenceNames =  
	{
		[1] = "欧-科", --health
		[2] = "德尼", --stamina
		[3] = "玛克欧", --magicka
	}
	return essenceNames
end

function WritCreater.langPotencyNames() --exact!! Also, these are all the positive runestones - no negatives needed.
	local potencyNames = 
	{
		[1] = "玖-拉", --Lowest potency stone lvl
		[2] = "珀拉-德",
		[3] = "颉-拉",
		[4] = "颉玖-拉",
		[5] = "欧达-拉",
		[6] = "珀玖-拉",
		[7] = "伊多-拉",
		[8] = "贾伊-拉",
		[9] = "珀-拉",
		[10]= "德纳-拉",
		[11]= "瑞-拉",
		[12]= "德拉-多",
		[13]= "瑞库-拉",
		[14]= "库-拉",
		[15]= "瑞-颉-拉",
		[16]= "瑞-珀-拉", --v16 potency stone
		
	}
	return potencyNames
end


local exceptions = 
{
	[1] = 
	{
		["original"] = "运送",
		["corrected"] = "deliver",
	},
}


local bankExceptions = 
{
	["original"] = {
		
	},
	["corrected"] = {
		
	}
}

function WritCreater.bankExceptions(condition)
	if string.find(condition, "deliver") then
		return ""
	end
	condition = string.gsub(condition, ":", " ")
	for i = 1, #bankExceptions["original"] do
		condition = string.gsub(condition,bankExceptions["original"][i],bankExceptions["corrected"][i])
	end
	return condition
end

function WritCreater.exceptions(condition)
	condition = string.gsub(condition, " "," ")
	condition = string.lower(condition)

	for i = 1, #exceptions do

		if string.find(condition, exceptions[i]["original"]) then
			condition = string.gsub(condition, exceptions[i]["original"],exceptions[i]["corrected"])
		end
	end
	return condition
end

function WritCreater.questExceptions(condition)
	condition = string.gsub(condition, " "," ")
	return condition
end

function WritCreater.enchantExceptions(condition)
	condition = string.gsub(condition, " "," ")
	condition = string.gsub(condition, "运送", "deliver")
	condition = string.gsub(condition, "制作", "制作 ")
	condition = string.gsub(condition, "的", "的 ")
	return condition
end


function WritCreater.langTutorial(i) --sentimental
	local t = {
		[5]="还有一些事您需要知道.\n首先, /dailyreset 命令可以告诉您\n还有多久重置下次日常任务.",
		[4]="最后, 您可以单独针对某个制造专业激活或者\n取消激活这个插件.\n默认情况下, 所有可用的制造任务都是开启的.\n如果您想关闭某些功能, 请查看设置.",
		[3]="下一步, 您可以选择在工作台时\n是否希望看到这个窗口.\n这个窗口会提示您拥有多少可以\n用于制造的材料, 以及需要用多少材料来制造.",
		[2]="第一个可以选择的设置是\n您是否想开启自动制造功能.\n如果开启, 当您访问一个工作台时\n将会自动制造任务所需的装备.",
		[1]="欢迎使用 Dolgubon's Lazy Writ Crafter!\n首先您需要做一些设置.\n 您可以在任何时间在设置菜单中进行修改.",
	}
	return t[i]
end

function WritCreater.langTutorialButton(i,onOrOff) --sentimental and short pls
	local tOn = 
	{
		[1]="使用默认",
		[2]="开启",
		[3]="显示",
		[4]="继续",
		[5]="完成",
	}
	local tOff=
	{
		[1]="继续",
		[2]="关闭",
		[3]="不要显示",
	}
	if onOrOff then
		return tOn[i]
	else
		return tOff[i]
	end
end



local function dailyResetFunction(till)
	if till["hour"]==0 then
		if till["minute"]==1 then
			return "服务器日常时间将在 1 分钟后重置!"
		elseif till["minute"]==0 then
			if stamp==1 then
				return "日常将在"..stamp.." 秒后重置!"
			else
				return "真的吗... 请别问了. 你就这么没有耐心吗??? 还剩一秒重置. "
			end
		else
			return till["minute"].." 分钟后重置日常时间!"
		end
	elseif till["hour"]==1 then
		if till["minute"]==1 then
			return till["hour"].." 小时 "..till["minute"].." 分钟后重置日常时间"
		else
			return till["hour"].." 小时 "..till["minute"].." 分钟后重置日常时间"
		end
	else
		if till["minute"]==1 then
			return till["hour"].." 小时 "..till["minute"].." 分钟后重置日常时间"
		else
			return till["hour"].." 小时 "..till["minute"].." 分钟后重置日常时间"
		end
	end 
end

local function runeMissingFunction (ta,essence,potency)
	local missing = {}
	if not ta["bag"] then
		missing[#missing + 1] = "|r塔|cf60000"
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
			text = "|cf60000符文无法制造. 你没有 "..proper(missing[i])
		else
			text = text.." 或 "..proper(missing[i])
		end
	end
	return text
end


--Various strings 
WritCreater.strings = 
{
	["runeReq"] 					= function (essence, potency) return "|c2dff00制造需要 1个 |r塔|c2dff00, 1个 |cffcc66"..essence.."|c2dff00 和 1个 |c0066ff"..potency.."|r" end,
	["runeMissing"] 				= runeMissingFunction ,
	["notEnoughSkill"]				= "您的制造技能不足, 无法制造所需装备",
	["smithingMissing"] 			= "\n|cf60000您没有足够的材料|r",
	["craftAnyway"] 				= "仍然制造",
	["smithingEnough"] 				= "\n|c2dff00您拥有足够的材料|r",
	["craft"] 						= "|c00ff00制造|r",
	["crafting"] 					= "|c00ff00制造中...|r",
	["craftIncomplete"] 			= "|cf60000制造无法完成.\n您需要更多的材料.|r",
	["moreStyle"] 					= "|cf60000您没有足够的样式材料.\n检查您的物品栏，成就和设置|r",
	["dailyreset"] 					= dailyResetFunction,
	["complete"] 					= "|c00FF00制造任务完成.|r",
	["craftingstopped"]				= "停止制造. 请检查插件是否制造了正确的装备.",
	["smithingReqM"] 				= function (amount, type, more) return zo_strformat( "制造需要 <<1>> <<2>> (|cf60000您需要 <<3>>|r)" ,amount, type, more) end,
	["smithingReqM2"] 				= function (amount,type,more)     return zo_strformat( "\n以及 <<1>> <<2>> (|cf60000您需要 <<3>>|r)"          ,amount, type, more) end,
	["smithingReq"] 				= function (amount,type, current) return zo_strformat( "制造需要 <<1>> <<2>> (|c2dff00<<3>> 可用|r)"  ,amount, type, current) end,
	["smithingReq2"] 				= function (amount,type, current) return zo_strformat( "\n以及 <<1>> <<2>> (|c2dff00<<3>> 可用|r)"         ,amount, type, current) end,
	["lootReceived"]				= "<<1>> 已获得.",
	["countSurveys"]				= "您拥有 <<1>> 张调查报告",
	["countVouchers"]				= "您拥有 <<1>> 张可获得的大师令券",
}
local function shouldDivinityprotocolbeactivatednowornotitshouldbeallthetimebutwhateveritlljustbeforabit() return GetDate()==20170401 end
if shouldDivinityprotocolbeactivatednowornotitshouldbeallthetimebutwhateveritlljustbeforabit() then
	WritCreater.strings.smithingReqM = function (amount, _,more) return zo_strformat( "制造需要 <<1>> Vampire Heart (|cf60000您需要 -<<3>>|r)" ,amount, type, more) end
	WritCreater.strings.smithingReqM2 = function (amount, _,more) return zo_strformat( "制造需要 <<1>> Ghost Eyes (|cf60000您需要 -<<3>>|r)" ,amount, type, more) end
	WritCreater.strings.smithingReq = function (amount, _,more) return zo_strformat( "制造需要 <<1>> Clowns (|cf60000您需要 -<<3>>|r)" ,amount, type, more) end
	WritCreater.strings.smithingReq2 = function (amount, _,more) return zo_strformat( "制造需要 <<1>> Werewolf Claws (|cf60000您需要 -<<3>>|r)" ,amount, type, more) end
end

--Options table Strings
WritCreater.optionStrings = {}
WritCreater.optionStrings["style tooltip"]								= function (styleName, styleStone) return zo_strformat("允许 <<1>> 样式, 将用到 <<2>> 样式石用于制造",styleName, styleStone) end 
WritCreater.optionStrings["show craft window"]							= "显示制造窗口"
WritCreater.optionStrings["show craft window tooltip"]					= "当打开工作台时显示制造窗口"
WritCreater.optionStrings["autocraft"]									= "自动制造"
WritCreater.optionStrings["autocraft tooltip"]							= "选择这个功能, 当您打开工作台时会自动开始制造所需装备. 如果窗口没有显示, 将会开启."
WritCreater.optionStrings["blackmithing"]								= "锻造"
WritCreater.optionStrings["blacksmithing tooltip"]						= "关闭锻造功能"
WritCreater.optionStrings["clothing"]									= "裁缝"
WritCreater.optionStrings["clothing tooltip"]							= "关闭裁缝功能"
WritCreater.optionStrings["enchanting"]									= "附魔"
WritCreater.optionStrings["enchanting tooltip"]							= "关闭附魔功能"
WritCreater.optionStrings["alchemy"]									= "炼金"
WritCreater.optionStrings["alchemy tooltip"]							= "关闭炼金功能"
WritCreater.optionStrings["provisioning"]								= "烹饪"
WritCreater.optionStrings["provisioning tooltip"]						= "关闭烹饪功能"
WritCreater.optionStrings["woodworking"]								= "木工"
WritCreater.optionStrings["woodworking tooltip"]						= "关闭木工功能"
WritCreater.optionStrings["writ grabbing"]								= "取出任务所需物品"
WritCreater.optionStrings["writ grabbing tooltip"]						= "从银行取出所有任务所需的物品"
WritCreater.optionStrings["delay"]										= "取出物品延迟"
WritCreater.optionStrings["delay tooltip"]								= "从银行取出物品的等待延迟（毫秒）"
WritCreater.optionStrings["ignore autoloot"]							= "忽略自动拾取设置"
WritCreater.optionStrings["ignore autoloot tooltip"]					= "忽略游戏设置中的自动社区功能, 使用下面配置的日常奖励拾取功能"
WritCreater.optionStrings["autoloot containters"]						= "自动拾取日常奖励"
WritCreater.optionStrings["autoLoot containters tooltip"]				= "打开奖励箱时自动拾取"
WritCreater.optionStrings["style stone menu"]							= "可用样式石"
WritCreater.optionStrings["style stone menu tooltip"]					= "选择那些样式石可以给插件使用"
WritCreater.optionStrings["send data"]									= "发送数据"
WritCreater.optionStrings["send data tooltip"]							= "从奖励箱获得物品时发送数据. 不会发送其他数据."
WritCreater.optionStrings["exit when done"]								= "退出制造窗口"
WritCreater.optionStrings["exit when done tooltip"]						= "当所有制造任务结束时关闭制造窗口"
WritCreater.optionStrings["automatic complete"]							= "自动处理任务对话"
WritCreater.optionStrings["automatic complete tooltip"]					= "自动接任务、完成任务"
WritCreater.optionStrings["new container"]								= "保持新状态"
WritCreater.optionStrings["new container tooltip"]						= "保持日常奖励箱的新状态"
WritCreater.optionStrings["master"]										= "大师制造任务"
WritCreater.optionStrings["master tooltip"]								= "如果开启将自动制造大师任务需要的物品"
WritCreater.optionStrings["right click to craft"]						= "右键点击制造"
WritCreater.optionStrings["right click to craft tooltip"]				= "如果开启将在右键点击大师任务令状后制造物品"
WritCreater.optionStrings["crafting submenu"]							= "交易制造"
WritCreater.optionStrings["crafting submenu tooltip"]					= "对某些制造关闭功能"
WritCreater.optionStrings["timesavers submenu"]							= "节省时间"
WritCreater.optionStrings["timesavers submenu tooltip"]					= "多种节省时间"
WritCreater.optionStrings["loot container"]								= "获得容器时自动拾取"
WritCreater.optionStrings["loot container tooltip"]						= "获得日常奖励箱时自动拾取"
WritCreater.optionStrings["master writ saver"]							= "保存大师令状"
WritCreater.optionStrings["master writ saver tooltip"]					= "防止使用大师令状"
WritCreater.optionStrings["loot output"]								= "高价物品提醒"
WritCreater.optionStrings["loot output tooltip"]						= "当从奖励中获得高价物品时发送消息提醒"
WritCreater.optionStrings["autoloot behaviour"]							= "自动拾取行为"
WritCreater.optionStrings["autoloot behaviour tooltip"]					= "选择何时自动拾取奖励箱"
WritCreater.optionStrings["autoloot behaviour choices"]					= {"从游戏设置中复制", "自动拾取", "不使用自动拾取"}

function WritCreater.langWritRewardBoxes () return {
	[CRAFTING_TYPE_ALCHEMY] = "炼金奖励器皿",
	[CRAFTING_TYPE_ENCHANTING] = "附魔奖励箱",
	[CRAFTING_TYPE_PROVISIONING] = "烹饪奖励包裹",
	[CRAFTING_TYPE_BLACKSMITHING] = "锻造奖励箱",
	[CRAFTING_TYPE_CLOTHIER] = "制衣奖励包裹",
	[CRAFTING_TYPE_WOODWORKING] = "木工奖励箱",
	[7] = "箱",
}
end

--dual, lush, rich

function WritCreater.getTaString()
	return "塔"
end

WritCreater.lang = "zh"


--[[
SLASH_COMMANDS['/opencontainers'] = function()local a=WritCreater.langWritRewardBoxes() for i=1,200 do for j=1,6 do if a[j]==GetItemName(1,i) then if IsProtectedFunction("endUseItem") then
	CallSecureProtected("endUseItem",1,i)
else
	UseItem(1,i)
end end end end end]]
