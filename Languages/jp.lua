-----------------------------------------------------------------------------------
-- Addon Name: Dolgubon's Lazy Writ Crafter
-- Creator: Dolgubon (Joseph Heinzle)
-- Addon Ideal: Simplifies Crafting Writs as much as possible
-- Addon Creation Date: March 14, 2016
--
-- File Name: Languages/jp.lua
-- File Description: Japanese Localization
-- Load Order Requirements: None
-- 
-----------------------------------------------------------------------------------

function WritCreater.langParser(str)
	local seperater  = ":"
	str = string.gsub(str,"の",":")
	str = string.gsub(str,"を",":")
	str = string.gsub(str,"な",":")
	str = string.gsub(str, "（ノーマル）","")

	local params = {}
	local i = 1
	local searchResult1, searchResult2  = string.find(str,seperater)
	if searchResult1 == 1 then
		str = string.sub(str, searchResult2+1)
		searchResult1, searchResult2  = string.find(str,seperater)
	end

	while searchResult1 do

		params[i] = string.sub(str, 1, searchResult1-1)
		str = string.sub(str, searchResult2+1)
	    searchResult1, searchResult2  = string.find(str,seperater)
	    i=i+1
	end 
	params[i] = str
	return params

end


function WritCreater.langWritNames() --Exacts!!!  I know for german alchemy writ is Alchemistenschrieb - so ["G"] = schrieb, and ["A"]=Alchemisten
	local names = {
	["G"] = "令状",
	[CRAFTING_TYPE_ENCHANTING] = "付呪",
	[CRAFTING_TYPE_BLACKSMITHING] = "鍛冶",
	[CRAFTING_TYPE_CLOTHIER] = "仕立",
	[CRAFTING_TYPE_PROVISIONING] = "調理",
	[CRAFTING_TYPE_WOODWORKING] = "木工",
	[CRAFTING_TYPE_ALCHEMY] = "錬金術",
	}
	return names
end

function WritCreater.writCompleteStrings()
	local strings = {
	["place"] = "Place the goods",
	["sign"] = "Sign the Manifest",
	["masterPlace"] = "",
	["masterSign"] = "",
	["masterStart"] = "<契約を受諾する>",,
	["Rolis Hlaalu"] = "ロリス・フラール",
	}
	return strings
end

function WritCreater.langMasterWritNames()
	local names = {
	["M"] 							= "masterful",
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

end

function WritCreater.languageInfo() --exacts!!!

local craftInfo = 
	{
		[CRAFTING_TYPE_CLOTHIER] = 
		{
			["pieces"] = --exact!!
			{
				[1] = "ローブ",
				[2] = "シャツ",
				[3] = "靴",
				[4] = "手袋",
				[5] = "帽子",
				[6] = "パンツ",
				[7] = "肩当て",
				[8] = "サッシュ",
				[9] = "胴当て",
				[10]= "ブーツ",
				[11]= "腕当て",
				[12]= "兜",
				[13]= "すね当て",
				[14]= "アームカップ",
				[15]= "ベルト",
			},
			["match"] = --exact!!! This is not the material, but rather the prefix the material gives to equipment. e.g. Homespun Robe, Linen Robe
			{
				[1] = "手織り布", --lvtier one of mats
				[2] = "リネン",	--l
				[3] = "コットン",
				[4] = "スパイダーシルク",
				[5] = "エボンスレッド",
				[6] = "クレッシュ",
				[7] = "アイアンスレッド",
				[8] = "シルバーウィーブ",
				[9] = "影",
				[10]= "先人",
				[11]= "生皮",
				[12]= "皮",
				[13]= "革",
				[14]= "フルレザー",
				[15]= "フェルハイド",
				[16]= "ブリガンダイン",
				[17]= "アイアンハイド",
				[18]= "最上",
				[19]= "シャドウハイド",
				[20]= "ルベドレザー",
			},
			["names"] = --Does not strictly need to be exact, but people would probably appreciate it
			{
				[1] = "黄麻", --lvtier one of mats
				[2] = "亜麻",	--l
				[3] = "コットン",
				[4] = "スパイダーシルク",
				[5] = "エボンスレッド",
				[6] = "クレッシュ繊維",
				[7] = "アイアンスレッド",
				[8] = "シルバーウィーブ",
				[9] = "虚無の布",
				[10]= "先人のシルク",
				[11]= "生皮",
				[12]= "皮",
				[13]= "革",
				[14]= "重厚な革",
				[15]= "フェルハイド",
				[16]= "トップグレインハイド",
				[17]= "鉄の皮",
				[18]= "最上なる皮",
				[19]= "シャドウハイド",
				[20]= "ルベドレザー",
			}
		},
		[CRAFTING_TYPE_BLACKSMITHING] = 
		{
			["pieces"] = --exact!!
			{
				[1] = "斧",
				[2] = "戦棍",
				[3] = "剣",
				[4] = "両手斧",
				[5] = "大槌",
				[6] = "大剣",
				[7] = "短剣",
				[8] = "胸当て",
				[9] = "サバトン",
				[10] = "篭手",
				[11] = "兜",
				[12] = "グリーヴ",
				[13] = "ポールドロン",
				[14] = "ガードル",
			},
			["match"] = --exact!!! This is not the material, but rather the prefix the material gives to equipment. e.g. Iron Axe, Steel Axe
			{
				[1] = "鉄",
				[2] = "鋼鉄",
				[3] = "オリハルコン",
				[4] = "ドワーフ",
				[5] = "黒檀",
				[6] = "カルシニウム",
				[7] = "ガラタイト",
				[8] = "水銀",
				[9] = "虚無",
				[10]= "ルベダイト",
			},
			["names"] = --Does not strictly need to be exact, but people would probably appreciate it
			{
				[1] = "鉄のインゴット",
				[2] = "鋼鉄のインゴット",
				[3] = "オリハルコンのインゴット",
				[4] = "ドワーフのインゴット",
				[5] = "黒檀のインゴット",
				[6] = "カルシニウムのインゴット",
				[7] = "ガラタイトのインゴット",
				[8] = "水銀のインゴット",
				[9] = "虚無の鉄のインゴット",
				[10]= "ルベダイトのインゴット",
			}
		},
		[CRAFTING_TYPE_WOODWORKING] = 
		{
			["pieces"] = --Exact!!!
			{
				[1] = "弓",
				[3] = "業火",
				[4] = "氷",
				[5] = "稲妻",
				[6] = "回復",
				[2] = "盾",
			},
			["match"] = --exact!!! This is not the material, but rather the prefix the material gives to equipment. e.g. Maple Bow. Oak Bow.
			{
				[1] = "カエデ",
				[2] = "カシ",
				[3] = "ブナノキ",
				[4] = "ヒッコリー",
				[5] = "イチイ",
				[6] = "カバノキ",
				[7] = "アッシュ",
				[8] = "マホガニー",
				[9] = "ナイトウッド",
				[10] = "ルビーアッシュ",
			},
			["names"] = --Does not strictly need to be exact, but people would probably appreciate it
			{
				[1] = "上質なカエデ材",
				[2] = "上質なカシ材",
				[3] = "上質なブナ材",
				[4] = "上質なヒッコリー材",
				[5] = "上質なイチイ材",
				[6] = "上質なカバ材",
				[7] = "上質なアッシュ材",
				[8] = "上質なマホガニー材",
				[9] = "上質なナイトウッド材",
				[10]= "上質なルビーアッシュ材",
			}
		},
		[CRAFTING_TYPE_ENCHANTING] = 
		{
			["pieces"] = --exact!!
			{
				[2] = {"グリフ(スタミナ)",45833,1},
				[1] = {"グリフ(体力)",45831,1},
				[3] = {"グリフ(マジカ)",45832,1},
			},
			["match"] = --exact!!! The names of glyphs. The prefix (in English) So trifling glyph of magicka, for example
			{
				{"初歩,",45855},
				{"未熟,",45856},
				{"不出来,",45857},
				{"未完,",45806},
				{"一般的,",45807},
				{"適正,",45808},
				{"中堅,",45809},
				{"熟練,",45810},
				{"強力,",45811},
				{"優秀,",45812},
				{"希少,",45813},
				{"至高,",45814},
				{"伝説,",45815},
				{"壮麗,",45816},
				{"最上,",64509},
				{"真に最上,",68341},
			},
		},
	}

	return craftInfo

end

function WritCreater.langEssenceNames() --exact!

local essenceNames =  
	{
		[1] = "オコ", --health
		[2] = "デニ", --stamina
		[3] = "マッコ", --magicka
	}
	return essenceNames
end

function WritCreater.langPotencyNames() --exact!! Also, these are all the positive runestones - no negatives needed.
	local potencyNames = 
	{
		[1] = "ジョラ", --Lowest potency stone lvl
		[2] = "ポラデ",
		[3] = "ジェラ",
		[4] = "ジェジョラ",
		[5] = "オドラ",
		[6] = "ポジョラ",
		[7] = "エドラ",
		[8] = "ジャエラ",
		[9] = "ポラ",
		[10]= "デナラ",
		[11]= "レラ",
		[12]= "デラド",
		[13]= "レクラ",
		[14]= "クラ",
		[15]= "レジェラ",
		[16]= "レポラ", --v16 potency stone
		
	}
	return potencyNames
end


local exceptions = 
{
	[1] = 
	{
		["original"] = "影の布",
		["corrected"] = "影",
	},
	[2] = 
	{
		["original"] = "先人のシルク",
		["corrected"] = "先人",
	},
	[3] = 
	{
		["original"] = "虚無の鉄",
		["corrected"] = "虚無",
	},
	[4] = 
	{
		["original"] = "業火の杖",
		["corrected"] = "業火",
	},
	[5] = 
	{
		["original"] = "氷の杖",
		["corrected"] = "氷",
	},
	[6] = 
	{
		["original"] = "稲妻の杖",
		["corrected"] = "稲妻",
	},
	[7] = 
	{
		["original"] = "回復の杖",
		["corrected"] = "回復",
	},
	[8] = 
	{
		["original"] = "ルベダイトのヘルム",
		["corrected"] = "ルベダイト",
	}
}


local bankExceptions = 
{
	["original"] = {
		
	},
	["corrected"] = {
		
	}
}

function WritCreater.bankExceptions(condition)
	condition = string.gsub(condition, ":", " ")
	for i = 1, #bankExceptions["original"] do
		condition = string.gsub(condition,bankExceptions["original"][i],bankExceptions["corrected"][i])
	end
	return condition
end

function WritCreater.exceptions(condition)
	condition = string.gsub(condition, "?"," ")
	condition = string.lower(condition)

	for i = 1, #exceptions do

		if string.find(condition, exceptions[i]["original"]) then
			condition = string.gsub(condition, exceptions[i]["original"],exceptions[i]["corrected"])
		end
	end
	return condition
end

function WritCreater.questExceptions(condition)
	condition = string.gsub(condition, "?"," ")
	return condition
end

function WritCreater.enchantExceptions(condition)
	condition = string.gsub(condition, "?"," ")
	return condition
end



function WritCreater.langTutorial(i) --sentimental
	local t = {
		[5]="最初に、/dailyreset というコマンドで、毎日の\nサーバのリセットまでの時間を知ることができます。\n最後に、このアドオンは9種類の\n種族（同盟）スタイルの素材のみ使用します。",
		[4]="最後に、それぞれの職業に対してアドオンを活性化\nするか非活性にするかを選択できます。\nデフォルトは全ての生産がオンになっています。\nもし、いくつかをオフにしたい場合、設定を確認してください。\nまた、あなたが知っておくべきことがあります。",
		[3]="次に、生産設備を使用する時にこのウィンドウを\n表示するかどうかを選択する必要があります。\nこのウィンドウでは必要な材料の数と\n現在いくつ持っているかが分かります。",
		[2]="最初の設定は自動生産を使用するかどうかです。\nオンにした時は生産設備に入った時に\nアドオンが自動的に生産を開始します。",
		[1]="Dolgubon's Lazy Writ Crafterへようこそ!\n最初にいくつかの設定を行います。\nこの設定は設定メニューからいつでも変更できます。"
	}
	return t[i]
end

function WritCreater.langTutorialButton(i,onOrOff) --sentimental and short pls
	local tOn = 
	{
		[1]="デフォルトを使用",
		[2]="オン",
		[3]="表示する",
		[4]="続ける",
		[5]="終了する",
	}
	local tOff=
	{
		[1]="続ける",
		[2]="オフ",
		[3]="表示しない",
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
		missing[#missing + 1] = ta["slot"].."|cf60000"
	end
	if not essence["bag"] then
		missing[#missing + 1] =  "|cffcc66"..essence["slot"].."|cf60000"
	end
	if not potency["bag"] then
		missing[#missing + 1] = "|c0066ff"..potency["slot"].."|r|cf60000"
	end
	local text = ""
	for i = 1, #missing do
		if i ==1 then
			text = "|cf60000グリフが生産できませんでした。\n|r"..missing[i]
		else
			text = text.."\n"..missing[i]
		end
	end
	return text

end

local function dailyResetFunction(till)
	if till["hour"]==0 then
		if till["minute"]==1 then
			d("毎日のサーバーリセットまであと1分です！")
		elseif till["minute"]==0 then
			if stamp==1 then
				d("毎日のリセットまであと"..stamp.."秒！")
			else
				d("真剣に... 問い合わせをやめてください。あなたはせっかちですね！")
			end
		else
			d("毎日のリセットまであと" .. till["minute"] .."分！")
		end
	else
		d("毎日のリセットまであと" .. till["hour"].."時間".. till["minute"] .."分")
	end 
end

WritCreater.strings = {
	["runeReq"] 								= function (essence, potency) return "|c2dff00生産には1個の|r ター |c2dff00と1個の |cffcc66"..essence.."|c2dff00 と\n1個の |c0066ff"..potency.."|r|c2dff00 が必要です。" end,
	["runeMissing"] 							= runeMissingFunction,
	["notEnoughSkill"]							= "必要な装備を作るための十分に高い生産スキルを有していません。",
	["smithingMissing"] 						= "\n|cf60000十分な材料を持っていません|r",
	["craftAnyway"]								= "強制的に作成",
	["smithingEnough"] 							= "\n|c2dff00十分な材料を持っています|r",
	["craft"] 									= "|c00ff00作成|r",
	["smithingReqM"] 							= function(amount, type, more) return "生産には" .. type .. "を" .. amount .. "個使用します\n (|cf60000あと" .. more .. "個必要|r)" end,
	["smithingReqM2"] 							= function (amount,type,more) return "\n同様に" .. type .. "を" .. amount .. "個使用します\n (|cf60000あと" .. more .. "個必要|r)" end,
	["smithingReq"] 							= function (amount,type, current) return "生産には" .. type .. "を" .. amount .. "個使用します\n (|c2dff00現在" .. current .. "個使用可能|r)" end,
	["smithingReq2"] 							= function (amount,type, current) return "\n同様に" .. type .. "を" .. amount .."個使用します\n (|c2dff00現在" .. current .. "個使用可能|r)" end,
	["crafting"] 								= "|c00ff00作成中...|r",
	["craftIncomplete"] 						= "|cf60000生産が完全に終わりませんでした。\nさらに材料が必要です。|r",
	["moreStyle"] 								= "|cf60000使用可能な9種類の基本種族（帝国は含まない）の\nスタイル素材がありません|r",
	["dailyreset"] 								= dailyResetFunction,
	["complete"] 								= "|c00FF00令状完了|r",
	["craftingstopped"] 						= "生産を中止しました。アドオンが正しいアイテムを生産しているかチェックしてください",
}



WritCreater.optionStrings = {}
WritCreater.optionStrings["style tooltip"]                            = function (styleName, styleStone) return zo_strformat("Allow the <<1>> style, which uses <<2>> to be used for crafting",styleName) end 
WritCreater.optionStrings["show craft window"]                        = "生産ウィンドウを表示"
WritCreater.optionStrings["show craft window tooltip"]                = "生産設備が開いたときに生産ウィンドウを表示する"
WritCreater.optionStrings["autocraft"]                                = "自動生産"
WritCreater.optionStrings["autocraft tooltip"]                        = "これを選択すると生産設備に入った時にアドオンが即時に生産を開始する。ウィンドウが非表示の場合でもこの機能は有効です。"
WritCreater.optionStrings["blackmithing"]                             = "鍛冶"
WritCreater.optionStrings["blacksmithing tooltip"]                    = "鍛冶のアドオンをオフにする"
WritCreater.optionStrings["clothing"]                                 = "縫製"
WritCreater.optionStrings["clothing tooltip"]                         = "縫製のアドオンをオフにする"
WritCreater.optionStrings["enchanting"]                               = "付呪"
WritCreater.optionStrings["enchanting tooltip"]                       = "付呪のアドオンをオフにする"
WritCreater.optionStrings["alchemy"]                                  = "Alchemy"
WritCreater.optionStrings["alchemy tooltip"]   	                  	  = "Turn the addon off for Alchemy"
WritCreater.optionStrings["provisioning"]                             = "Provisioning"
WritCreater.optionStrings["provisioning tooltip"]                     = "Turn the addon off for Provisioning"
WritCreater.optionStrings["woodworking"]                              = "木工"
WritCreater.optionStrings["woodworking tooltip"]                      = "木工のアドオンをオフにする"
WritCreater.optionStrings["writ grabbing"]                            = "令状アイテムを取り込む"
WritCreater.optionStrings["writ grabbing tooltip"]                    = "令状に必要なアイテム（ニルンルート、ターなど）銀行から取り込みます"

WritCreater.optionStrings["style stone menu"]                         = "使用するスタイルストーン"
WritCreater.optionStrings["style stone menu tooltip"]                 = "アドオンでどのスタイルストーンを使用するか選択する"
WritCreater.optionStrings["exit when done"]							  = "Exit crafting window"
WritCreater.optionStrings["exit when done tooltip"]					  = "Exit crafting window when all crafting is completed"
WritCreater.optionStrings["automatic complete"]						  = "Automatic quest dialog"
WritCreater.optionStrings["automatic complete tooltip"]				  = "Automatically accepts and completes quests when at the required place"
WritCreater.optionStrings["new container"]							  = "Keep new status"
WritCreater.optionStrings["new container tooltip"]					  = "Keep the new status for writ reward containers"
WritCreater.optionStrings["master"]									  = "Master Writs"
WritCreater.optionStrings["master tooltip"]							  = "Turn the addon off for Master Writs"
WritCreater.optionStrings["right click to craft"]						= "Right Click to Craft"
WritCreater.optionStrings["right click to craft tooltip"]				= "If this is ON the addon will craft Master Writs you tell it to craft after right clicking a sealed writ"
WritCreater.optionStrings["crafting submenu"]						  = "Trades to Craft"
WritCreater.optionStrings["crafting submenu tooltip"]				  = "Turn the addon off for specific crafts"
WritCreater.optionStrings["timesavers submenu"]						  = "Timesavers"
WritCreater.optionStrings["timesavers submenu tooltip"]				  = "Various small timesavers"
WritCreater.optionStrings["loot container"]						  		= "Loot container when received"
WritCreater.optionStrings["loot container tooltip"]				  		= "Loot writ reward containers when you receive them"
WritCreater.optionStrings["master writ saver"]							= "Save Master Writs"
WritCreater.optionStrings["master writ saver tooltip"]					= "Prevents Master Writs from being accepted"
WritCreater.optionStrings["loot output"]								= "Valuable Reward Alert"
WritCreater.optionStrings["loot output tooltip"]						= "Output a message when valuable items are received from a writ"
WritCreater.optionStrings["autoloot"]									= "Autoloot Behaviour"
WritCreater.optionStrings["autoloot tooltip"]							= "Choose when the addon will autoloot writ reward containers"
WritCreater.optionStrings["autoloot choices"]							= {"Copy the setting under the Gameplay settings", "Autoloot", "Never Autoloot"}

function WritCreater.langWritRewardBoxes () 
local WritRewardNames = { -- these are the containers you receive as writ rewards
	[1] = "錬金術師の器",
	[2] = "付呪師の貴品箱",
	[3] = "仕立師のかばん",
	[4] = "鍛冶師の木枠箱",
	[5] = "調理師のバック",
	[6] = "木工師のケース",
	[7] = "1111111111",
}


	return WritRewardNames
end


function WritCreater.getTaString()
	return "ター"
end

WritCreater.lang = "jp"
