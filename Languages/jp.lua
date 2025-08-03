-----------------------------------------------------------------------------------
-- Addon Name: Dolgubon's Lazy Writ Crafter
-- Creator: Dolgubon (Joseph Heinzle)
-- Addon Ideal: Simplifies Crafting Writs as much as possible
-- Addon Creation Date: March 14, 2016
--
-- File Name: Languages/jp.lua
-- File Description: Japanese Localization (Translated by qoqo and Calamath)
-- Load Order Requirements: None
-- 
-----------------------------------------------------------------------------------

function WritCreater.langParser(str)
	local seperater  = ":"
	str = string.gsub(str,"の",":")
	str = string.gsub(str,"を",":")
	str = string.gsub(str,"な",":")
	str = string.gsub(str, "%(ノーマル%)","")
	str = string.gsub(str, "グリフ%(","")
	str = string.gsub(str, "%)","")
--	str = string.gsub(str, "%s","")
	str = string.gsub(str, " ","")

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

WritCreater = WritCreater or {}

-- for automatic hireling looting feature in Japanese language mode
WritCreater.hirelingMailSubjects = WritCreater.hirelingMailSubjects or {}
WritCreater.hirelingMailSubjects["付呪師用素材"] = true		-- Raw Enchanter Materials
WritCreater.hirelingMailSubjects["仕立師用素材"] = true		-- Raw Clothier Materials
WritCreater.hirelingMailSubjects["鍛冶師用素材"] = true		-- Raw Blacksmith Materials
WritCreater.hirelingMailSubjects["木工師用素材"] = true		-- Raw Woodworker Materials
WritCreater.hirelingMailSubjects["調理師用素材"] = true		-- Raw Provisioner Materials

function WritCreater.langWritNames() -- Vital
	-- Exact!!!  I know for german alchemy writ is Alchemistenschrieb - so ["G"] = schrieb, and ["A"]=Alchemisten
	local names = {
	["G"] = "依頼",
	[CRAFTING_TYPE_ENCHANTING] = "付呪",
	[CRAFTING_TYPE_BLACKSMITHING] = "鍛冶",
	[CRAFTING_TYPE_CLOTHIER] = "仕立",
	[CRAFTING_TYPE_PROVISIONING] = "調理",
	[CRAFTING_TYPE_WOODWORKING] = "木工",
	[CRAFTING_TYPE_ALCHEMY] = "錬金術",
	[CRAFTING_TYPE_JEWELRYCRAFTING] = "宝飾",
	}
	return names
end

function WritCreater.langCraftKernels()
	return 
	{
		[CRAFTING_TYPE_ENCHANTING] = "付呪",
		[CRAFTING_TYPE_BLACKSMITHING] = "鍛冶",
		[CRAFTING_TYPE_CLOTHIER] = "仕立",
		[CRAFTING_TYPE_PROVISIONING] = "調理",
		[CRAFTING_TYPE_WOODWORKING] = "木工",
		[CRAFTING_TYPE_ALCHEMY] = "錬金術",
		[CRAFTING_TYPE_JEWELRYCRAFTING] = "宝飾",
	}
end

function WritCreater.langMasterWritNames() -- Vital
	local names = {
	["M"] 							= "優れた",
	["M1"]							= "マスター",
	[CRAFTING_TYPE_ALCHEMY]			= "調合薬",
	[CRAFTING_TYPE_ENCHANTING]		= "グリフ",
	[CRAFTING_TYPE_PROVISIONING]	= "料理",
	["plate"]						= "防具",
	["tailoring"]					= "服",
	["leatherwear"]					= "革装備",
	["weapon"]						= "武器",
	["shield"]						= "盾",
	["jewelry"]						= "宝飾",
	}
return names

end

function WritCreater.writCompleteStrings() -- Vital for translation
	local strings = {
	["place"] = "品物を(.+)の中に置く",
	["sign"] = "<伝票に署名する>",
	["masterPlace"] = "の仕事を終えた",
	["masterSign"] = "<仕事を終える>",
	["masterStart"] = "<契約を受諾する>",
	["Rolis Hlaalu"] = "ロリス・フラール",
	["Deliver"] = "届ける",
	}
	return strings
end

function WritCreater.questExceptions(condition)
	condition = string.gsub(condition, "?"," ")
	return condition
end

function WritCreater.langStationNames()
	return
	{["鍛冶台"] = 1, ["仕立台"] = 2, 
	 ["付呪台"] = 3,["錬金台"] = 4, ["調理用の火"] = 5, ["木工台"] = 6, ["宝飾台"] = 7, }
end

WritCreater.lang = "jp"
--WritCreater.needTranslations = "https://www.esoui.com/forums/showpost.php?p=41147&postcount=9"


local function runeMissingFunction (ta,essence,potency)
	local missing = {}
	if not ta["bag"] then
		missing[#missing + 1] = "|r"..ZO_CachedStrFormat("<<C:1>>",ta["slot"]).."|cf60000"
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
			text = "|cff3333グリフが生産できませんでした。\n不足: "..ZO_CachedStrFormat("<<C:1>>",missing[i])
		else
			text = text.." または "..ZO_CachedStrFormat("<<C:1>>",missing[i])
		end
	end
	return text

end


local function dailyResetFunction(till)
	if till["hour"]==0 then
		if till["minute"]==1 then
			return "サーバーのデイリーリセットまであと１分です！"
		elseif till["minute"]==0 then
			if stamp==1 then
				return "デイリーリセットまであと"..stamp.."秒！"
			else
				return "マジで... 尋ねないでください。そんなにせっかちなの？　あと１秒でリセットされます！　*ぶつぶつ*"
			end
		else
			return "デイリーリセットまであと" .. till["minute"] .."分！"
		end
	else
		return "デイリーリセットまであと" .. till["hour"].."時間".. till["minute"] .."分"
	end 
end

local function masterWritEnchantToCraft (link, trait, style, quality, writName)
	local partialString = zo_strformat("<<t:5>>: CP150の <<t:1>> (特性:<<t:2>> スタイル:<<t:3>> 品質:<<t:4>>) を作成する", link, trait, style, quality, writName)
	return partialString
end


WritCreater.strings = WritCreater.strings or {}

WritCreater.strings["runeReq"] 					= function (essence, potency, taStack, essenceStack, potencyStack) 
	if taStack and essenceStack and potencyStack then
		return zo_strformat("|c2dff00クラフトには|r ター|c2dff00(<<3>>個 所持)と |r|cffcc66<<1>>|r|c2dff00(<<4>>個 所持)と |r|c0066ff<<2>>|r|c2dff00(<<5>>個 所持) が各1個必要|r", essence, potency, taStack, essenceStack, potencyStack)
	else
		return zo_strformat("|c2dff00クラフトには|r ター |c2dff00と |cffcc66<<1>>|c2dff00 と |c0066ff<<2>>|r|c2dff00 が各1個必要|r", essence, potency)
	end
end
WritCreater.strings["runeMissing"] 				= runeMissingFunction
WritCreater.strings["notEnoughSkill"]			= "必要な装備を作るための十分に高いクラフトスキルを有していません。"
WritCreater.strings["smithingMissing"] 			= "\n|cf60000十分な材料を持っていません|r"
WritCreater.strings["craftAnyway"]				= "強制的に作成"
WritCreater.strings["smithingEnough"] 			= "\n|c2dff00十分な材料を持っています|r"
WritCreater.strings["craft"] 					= "|c00ff00クラフト|r"
WritCreater.strings["crafting"] 				= "|c00ff00クラフト中...|r"
WritCreater.strings["craftIncomplete"] 			= "|cf60000クラフトが完全に終わりませんでした。\nさらに材料が必要です。|r"
WritCreater.strings["moreStyle"] 				= "|cf60000使用可能なスタイル素材がありません。\nインベントリや実績やアドオン設定をご確認ください。|r"
WritCreater.strings["moreStyleSettings"]		= "|cf60000使用可能なスタイル素材がありません。\n使用可能なスタイル素材をアドオン設定で追加する必要があります。|r"
WritCreater.strings["moreStyleKnowledge"]		= "|cf60000使用可能なスタイル素材がありません。\nもっとスタイルを習得する必要があるかもしれません。|r"
WritCreater.strings["dailyreset"] 				= dailyResetFunction
WritCreater.strings["complete"] 				= "|c00FF00令状完了|r"
WritCreater.strings["craftingstopped"] 			= "クラフトを中止しました。アドオンが正しいアイテムをクラフトしていたかチェックしてください"
WritCreater.strings["smithingReqM"] 			= function(amount, type, more) return zo_strformat("クラフトには<<1>>を<<2>>個使用 (|cf60000あと<<3>>個必要|r)", type, amount, more) end
WritCreater.strings["smithingReqM2"] 			= function (amount,type,more) return zo_strformat("\n同様に<<1>>を<<2>>個使用 (|cf60000あと<<3>>個必要|r)", type, amount, more) end
WritCreater.strings["smithingReq"] 				= function (amount,type, current) return zo_strformat("クラフトには<<1>>を<<2>>個使用 (|c2dff00<<3>>個使用可能|r)", type, amount, 
														zo_strformat(SI_NUMBER_FORMAT, ZO_AbbreviateNumber(current, NUMBER_ABBREVIATION_PRECISION_TENTHS, USE_LOWERCASE_NUMBER_SUFFIXES))) end
WritCreater.strings["smithingReq2"] 			= function (amount,type, current) return zo_strformat("\n同様に<<1>>を<<2>>個使用 (|c2dff00<<3>>個使用可能|r)", type, amount, current) end
WritCreater.strings["lootReceived"]				= "<<1>> <<3>>個 を受け取った (<<2>>個 所持)"
WritCreater.strings["lootReceivedM"]			= "<<1>> を受け取った "
WritCreater.strings["countSurveys"]				= "You have <<1>> surveys"
WritCreater.strings["countVouchers"]			= "You have <<1>> unearned Writ Vouchers"
WritCreater.strings["includesStorage"]			= function(type) local a= {"Surveys", "Master Writs"} a = a[type] return zo_strformat("Count includes <<1>> in house storage", a) end
WritCreater.strings["surveys"]					= "Crafting Surveys"
WritCreater.strings["sealedWrits"]				= "Sealed Writs"
WritCreater.strings["masterWritEnchantToCraft"]	= function(lvl, type, quality, writCraft, writName, generalName) 
													return zo_strformat("<<t:4>>の<<t:5>><<t:6>>: <<t:1>>のグリフ(<<t:2>>) 品質:<<t:3>>を作成する",lvl, type, quality,
													writCraft,writName, generalName) end
WritCreater.strings["newMasterWritSmithToCraft"]	= masterWritEnchantToCraft
WritCreater.strings["withdrawItem"]				= function(amount, link, remaining) return link.."を"..amount.."個取り出した(銀行に"..remaining.."個)" end
WritCreater.strings['fullBag']					= "バッグに空きがありません。バッグに空きを作ってください。"
WritCreater.strings['masterWritSave']			= "Dolgubon's Lazy Writ Crafterは、あなたが誤ってマスター依頼を受諾してしまうのを防ぎました! 設定メニューでこの機能をオフにできます"
WritCreater.strings['missingLibraries']			= "Dolgubon's Lazy Writ Crafterには次のスタンドアロンライブラリが必要です。ダウンロードしてインストールするかライブラリをオンにしてください: "
WritCreater.strings['resetWarningMessageText']	= "デイリー依頼のリセットまで<<1>>時間<<2>>分です\n設定でこのワーニング表示のカスタマイズができます"
WritCreater.strings['resetWarningExampleText']	= "ワーニングはこのように表示されます"
WritCreater.strings['lowInventory']				= "\n空きスロットが <<1>>しか残っておらず、空きスロットが不足している可能性があります。"




WritCreater.optionStrings = WritCreater.optionStrings or {}
WritCreater.optionStrings.nowEditing                   = "%sの設定を変更しています"
WritCreater.optionStrings.accountWide                  = "アカウント共通"
WritCreater.optionStrings.characterSpecific            = "キャラクター固有"
WritCreater.optionStrings.useCharacterSettings         = "キャラクター固有の設定を使用する" -- de
WritCreater.optionStrings.useCharacterSettingsTooltip  = "このキャラクターのみの固有の設定を使用します" --de
WritCreater.optionStrings["style tooltip"]								= function (styleName, styleStone) return zo_strformat("スタイル素材「"..styleStone.."」を用いる「<<1>>スタイル」を、クラフト時に使用できるようにします。",styleName, styleStone) end 
WritCreater.optionStrings["show craft window"]							= "クラフトウィンドウを表示"
WritCreater.optionStrings["show craft window tooltip"]					= "クラフト台を開いたときにクラフトウィンドウを表示します"
WritCreater.optionStrings["autocraft"]									= "クラフトの自動化"
WritCreater.optionStrings["autocraft tooltip"]							= "これを選択するとクラフト台を使った時にアドオンは即座にクラフトを開始します。ウィンドウが非表示の場合もこの機能はオンになります"
WritCreater.optionStrings["blackmithing"]								= "鍛冶"
WritCreater.optionStrings["blacksmithing tooltip"]						= "鍛冶を自動化する"
WritCreater.optionStrings["clothing"]									= "縫製"
WritCreater.optionStrings["clothing tooltip"]							= "縫製を自動化する"
WritCreater.optionStrings["enchanting"]									= "付呪"
WritCreater.optionStrings["enchanting tooltip"]							= "付呪を自動化する"
WritCreater.optionStrings["alchemy"]									= "錬金"
WritCreater.optionStrings["alchemy tooltip"]							= "錬金を自動化する（令状に必要なアイテムを事前にクラフトしておくことが推奨されますが、クラフトの自動化もサポートされています）"
WritCreater.optionStrings["alchemyChoices"]								= {"オフ","全機能オン","自動クラフトを飛ばす"}
WritCreater.optionStrings["provisioning"]								= "調理"
WritCreater.optionStrings["provisioning tooltip"]						= "調理を自動化する（令状に必要なアイテムを事前にクラフトしておくことが推奨されますが、クラフトの自動化もサポートされています）"
WritCreater.optionStrings["woodworking"]								= "木工"
WritCreater.optionStrings["woodworking tooltip"]						= "木工を自動化する"
WritCreater.optionStrings["jewelry crafting"]							= "宝飾"
WritCreater.optionStrings["jewelry crafting tooltip"]					= "宝飾を自動化する"
WritCreater.optionStrings["writ grabbing"]								= "令状アイテムを取り込む"
WritCreater.optionStrings["writ grabbing tooltip"]						= "令状に必要なアイテム（ニルンルート、ターなど）を銀行から取り込みます"
WritCreater.optionStrings["delay"]										= "アイテム取り込みディレイ"
WritCreater.optionStrings["delay tooltip"]								= "銀行からアイテムを取り込むときの待ち時間（ミリ秒）"
WritCreater.optionStrings["style stone menu"]							= "使用するスタイル素材"
WritCreater.optionStrings["style stone menu tooltip"]					= "アドオンでどのスタイル素材を使用するか選択します"
WritCreater.optionStrings["send data"]									= "Send Writ Data"
WritCreater.optionStrings["send data tooltip"]							= "Send information on the rewards received from your writ boxes. No other information is sent."
WritCreater.optionStrings["exit when done"]								= "クラフトウィンドウを自動的に閉じる"
WritCreater.optionStrings["exit when done tooltip"]						= "すべてのクラフトが完了したら、自動的にクラフトウィンドウを閉じます"
WritCreater.optionStrings["automatic complete"]							= "クエストダイアログの自動化"
WritCreater.optionStrings["automatic complete tooltip"]					= "クエストの受諾・完了するダイアログ画面を自動的に進める"
WritCreater.optionStrings["new container"]								= "「新しい」ステータスを保持"
WritCreater.optionStrings["new container tooltip"]						= "クラフト依頼の報酬コンテナから取り出したアイテムに、「新しい」アイテムであることを示すステータスを保持します"
WritCreater.optionStrings["master"]										= "マスター依頼"
WritCreater.optionStrings["master tooltip"]								= "これをオンにすると、受諾されたマスター依頼の納品物をクラフト台で自動的にクラフトします"
WritCreater.optionStrings["right click to craft"]						= "右クリックでクラフト"
WritCreater.optionStrings["right click to craft tooltip"]				= "これをオンにすると、密封された依頼をインベントリで右クリックして「密封された依頼をクラフトする」指示をしたときだけ、マスター依頼の納品物を自動的にクラフトします。本機能には、アドオンLibCustomMenuが必要です"
WritCreater.optionStrings["crafting submenu"]							= "デイリークラフト依頼の自動化"
WritCreater.optionStrings["crafting submenu tooltip"]					= "クラフトの職制別に、クラフト依頼のデイリークエストの自動化のオンオフを切り替えます"
WritCreater.optionStrings["timesavers submenu"]							= "時間短縮"
WritCreater.optionStrings["timesavers submenu tooltip"]					= "時間短縮のための設定"
WritCreater.optionStrings["loot container"]								= "報酬を取り出す"
WritCreater.optionStrings["loot container tooltip"]						= "クラフト依頼完了の報酬コンテナからアイテムを自動的に取り出します"
WritCreater.optionStrings["master writ saver"]							= "マスター依頼を保持"
WritCreater.optionStrings["master writ saver tooltip"]					= "マスター依頼のクエストが自動的に受諾されることを防止します"
WritCreater.optionStrings["loot output"]								= "価値の高い報酬を受けた時の通知"
WritCreater.optionStrings["loot output tooltip"]						= "クラフト依頼完了の報酬コンテナから価値の高いアイテムを受け取ったとき、メッセージを表示します"
WritCreater.optionStrings["autoloot behaviour"]							= "自動取得の動作"
WritCreater.optionStrings["autoloot behaviour tooltip"]					= "令状の報酬コンテナをアドオンが自動取得するか選択します"
WritCreater.optionStrings["autoloot behaviour choices"]					= {"ゲームプレイメニュー内の設定に従う", "自動取得する", "自動取得しない"}
WritCreater.optionStrings["container delay"]							= "報酬コンテナの取り出しディレイ"
WritCreater.optionStrings["container delay tooltip"]					= "報酬コンテナを受け取ってから中身を自動取得するまでの待ち時間"
WritCreater.optionStrings["hide when done"]								= "Hide when done"
WritCreater.optionStrings["hide when done tooltip"]						= "すべてのアイテムがクラフトされたら自動的にアドオンのウィンドウを閉じます"
WritCreater.optionStrings['reticleColour']								= "レティクルの色を変える"
WritCreater.optionStrings['reticleColourTooltip']						= "依頼を受けている場合に完了か未完了かで、クラフト台のレティクルの色を変えます"
WritCreater.optionStrings['autoCloseBank']								= "銀行ダイアログの自動化"
WritCreater.optionStrings['autoCloseBankTooltip']						= "令状に必要なアイテムがあれば、自動的に銀行からアイテムを取り出して銀行のダイアログを閉じます"
WritCreater.optionStrings['despawnBanker']								= "助手の頭取の解放 (引き出し)"
WritCreater.optionStrings['despawnBankerTooltip']						= "銀行からアイテムを引き出した後で、助手の頭取を自動的に解放します"
WritCreater.optionStrings['despawnBankerDeposit']						= "助手の頭取の解放 (預け入れ)"
WritCreater.optionStrings['despawnBankerDepositTooltip']				= "銀行にアイテムを預け入れた後で、助手の頭取を自動的に解放します"
WritCreater.optionStrings['dailyResetWarn']								= "Writ Reset Warning"
WritCreater.optionStrings['dailyResetWarnTooltip']						= "その日の令状がリセットされる前に警告を表示します"
WritCreater.optionStrings['dailyResetWarnTime']							= "リセットの何分前に表示"
WritCreater.optionStrings['dailyResetWarnTimeTooltip']					= "デイリーリセットの何分前にワーニングを表示するか"
WritCreater.optionStrings['dailyResetWarnType']							= "デイリーリセットのワーニング表示"
WritCreater.optionStrings['dailyResetWarnTypeTooltip']					= "デイリーリセットが起ころうとしたときにどの種類のワーニングを表示するか"
WritCreater.optionStrings['dailyResetWarnTypeChoices']					={ "なし","画面中央に告知", "画面右上に表示", "チャット欄に表示", "ポップアップ", "すべて"}
WritCreater.optionStrings['stealingProtection']							= "盗み行為防止"
WritCreater.optionStrings['stealingProtectionTooltip']					= "ジャーナルに令状クエストを持っている間、あなたが誤って盗むのを防ぎます"
WritCreater.optionStrings['jewelryWritDestroy']							= "Destroy Jewelry Sealed Writs"
WritCreater.optionStrings['jewelryWritDestroyTooltip']					= "Destroy looted Jewelry Sealed writs. WARNING: There is no prompt!"
WritCreater.optionStrings['jewelryWritDestroyWarning']					= "WARNING: There is no prompt when destroying jewelry writs! Enable at your own risk!"
WritCreater.optionStrings['noDELETEConfirmJewelry']						= "宝飾のマスター依頼を破壊する操作の簡略化"
WritCreater.optionStrings['noDELETEConfirmJewelryTooltip']				= "宝飾のマスター依頼（密封された宝飾依頼）を破壊するときの確認ダイアログに DELETE の文字を自動で入力します"
WritCreater.optionStrings['suppressQuestAnnouncements']					= "令状クエストのアナウンス表示の抑制"
WritCreater.optionStrings['suppressQuestAnnouncementsTooltip']			= "クラフト依頼の令状クエスト受諾時やアイテムのクラフト時にセンタースクリーンに表示されるメッセージ を抑制します"
WritCreater.optionStrings["questBuffer"]								= "令状クエストバッファー"
WritCreater.optionStrings["questBufferTooltip"]							= "令状クエストをいつでも受諾できるように、クエスト受諾枠の中にバッファー（令状クエスト用の予約枠）を確保します"
WritCreater.optionStrings["craftMultiplier"]							= "マルチクラフト[装備とグリフ]（2以上のとき）"
WritCreater.optionStrings["craftMultiplierTooltip"]						= "これを2以上に設定し、必要なアイテムごとに複数のコピーを余分に作成しておくと、次に令状クエストがきたときに再度クラフトする必要がなくなります。\n注意：設定値を1増やすごとに、インベントリに約37スロットを確保します。"
WritCreater.optionStrings["craftMultiplierConsumables"]					= "マルチクラフト[錬金と調理]"
WritCreater.optionStrings["craftMultiplierConsumablesTooltip"]			= "クラフト1回を選ぶと、クラフト台で1回だけクラフト操作を実行します。パッシブスキルの効果により余分にアイテムがクラフトされることがあります。フルスタックを選ぶと、令状に必要なアイテムが100個クラフトされます（パッシブスキルの効果が最大のとき）。"
WritCreater.optionStrings["craftMultiplierConsumablesChoices"]			= {"クラフト1回","フルスタック"}
WritCreater.optionStrings['hireling behaviour']							= "助手のメールの取り扱い"
WritCreater.optionStrings['hireling behaviour tooltip']					= "クラフトスキルで雇った助手からのメールをどのようにするか（メールから素材を自動で取り出すかどうか）"
WritCreater.optionStrings['hireling behaviour choices']					= { "何もしない","取り出して削除", "取り出すだけ" }

WritCreater.optionStrings["allReward"]									= "全クラフト職制"
WritCreater.optionStrings["allRewardTooltip"]							= "全てのクラフト職制に共通して取るべき動作"

WritCreater.optionStrings['sameForALlCrafts']							= "全クラフト職制で同じオプションを使用する"
WritCreater.optionStrings['sameForALlCraftsTooltip']					= "全クラフト職制について、このタイプの報酬に同じオプションを使用する"
WritCreater.optionStrings['1Reward']									= "Blacksmithing"
WritCreater.optionStrings['2Reward']									= "Use for all"
WritCreater.optionStrings['3Reward']									= "Use for all"
WritCreater.optionStrings['4Reward']									= "Use for all"
WritCreater.optionStrings['5Reward']									= "Use for all"
WritCreater.optionStrings['6Reward']									= "Use for all"
WritCreater.optionStrings['7Reward']									= "Use for all"

WritCreater.optionStrings["matsReward"]									= "Mat Rewards"
WritCreater.optionStrings["matsRewardTooltip"]							= "What to do with crafting material rewards"
WritCreater.optionStrings["surveyReward"]								= "調査報告の報酬"
WritCreater.optionStrings["surveyRewardTooltip"]						= "調査報告の報酬をどうするか"
WritCreater.optionStrings["masterReward"]								= "マスター依頼の報酬"
WritCreater.optionStrings["masterRewardTooltip"]						= "マスター依頼の報酬をどうするか"
WritCreater.optionStrings["repairReward"]								= "修理キットの報酬"
WritCreater.optionStrings["repairRewardTooltip"]						= "修理キットの報酬をどうするか"
WritCreater.optionStrings["ornateReward"]								= "装飾特性の装備の報酬"
WritCreater.optionStrings["ornateRewardTooltip"]						= "装飾特性の装備の報酬をどうするか"
WritCreater.optionStrings["intricateReward"]							= "複雑特性の装備の報酬"
WritCreater.optionStrings["intricateRewardTooltip"]						= "複雑特性の装備の報酬をどうするか"
WritCreater.optionStrings["soulGemReward"]								= "魂石(空)の報酬"
WritCreater.optionStrings["soulGemTooltip"]								= "魂石(空)の装備の報酬をどうするか"
WritCreater.optionStrings["glyphReward"]								= "グリフの報酬"
WritCreater.optionStrings["glyphRewardTooltip"]							= "グリフの報酬をどうするか"
WritCreater.optionStrings["recipeReward"]								= "レシピ"
WritCreater.optionStrings["recipeRewardTooltip"]						= "レシピの報酬をどうするか"
WritCreater.optionStrings["fragmentReward"]								= "サイジックのアンブロージアの断片"
WritCreater.optionStrings["fragmentRewardTooltip"]						= "サイジックのアンブロージアのレシピの断片の報酬をどうするか"


WritCreater.optionStrings["writRewards submenu"]						= "依頼書の報酬の取り扱い"
WritCreater.optionStrings["writRewards submenu tooltip"]				= "依頼書からの全ての報酬をどうするか"

WritCreater.optionStrings["jubilee"]									= "記念祭/ゼニタールの箱の中身を取り出す"
WritCreater.optionStrings["jubilee tooltip"]							= "記念祭/ゼニタールのギフトボックスからアイテムを自動的に取り出します"
WritCreater.optionStrings["skin"]										= "Writ CrafterのUIスキン"
WritCreater.optionStrings["skinTooltip"]								= "Writ CrafterのUI用のスキン"
WritCreater.optionStrings["skinOptions"]								= {"標準", "チーズくさい", "山羊っぽい"}
WritCreater.optionStrings["goatSkin"]									= "山羊っぽい"
WritCreater.optionStrings["cheeseSkin"]									= "チーズくさい"
WritCreater.optionStrings["defaultSkin"]								= "標準"
WritCreater.optionStrings["rewardChoices"]								= {"何もしない","預ける","ガラクタ", "破壊する", "解体する"}
WritCreater.optionStrings["scan for unopened"]							= "ログイン時にコンテナを開く"
WritCreater.optionStrings["scan for unopened tooltip"]					= "ログイン時にバッグをスキャンして、クラフト依頼の未開封の報酬コンテナを探し、開封を試みます"

WritCreater.optionStrings["smart style slot save"]						= "スタイル素材を少ない順に使用"
WritCreater.optionStrings["smart style slot save tooltip"]				= "ESO Plus会員ではないとき、スタイル素材のより小さなスタックから使用することで、使用されるスロットを最小限に抑えることを試みます"
WritCreater.optionStrings["abandon quest for item"]						= "<<1>>を納品する令状"
WritCreater.optionStrings["abandon quest for item tooltip"]				= "これをオフにすると、<<1>>を納品する令状を自動的に放棄します。<<1>>を必要とするアイテムをクラフトが必要なクエストは放棄されません"
WritCreater.optionStrings["status bar submenu"]							= "ステータスバー オプション"
WritCreater.optionStrings["status bar submenu tooltip"]					= "ステータスバー オプション"
WritCreater.optionStrings['showStatusBar']								= "クエストステータスバーの表示"
WritCreater.optionStrings['showStatusBarTooltip']						= "クエストステータスバーを表示するか"
WritCreater.optionStrings['statusBarIcons']								= "アイコンを使う"
WritCreater.optionStrings['statusBarIconsTooltip']						= "令状クエストの種別を表すアルファベットの代わりに、クラフトアイコンを表示します"
WritCreater.optionStrings['transparentStatusBar']						= "ステータスバーの透明化"
WritCreater.optionStrings['transparentStatusBarTooltip']				= "ステータスバーの背景を透明化します"
WritCreater.optionStrings['statusBarInventory']							= "インベントリ トラッカー"
WritCreater.optionStrings['statusBarInventoryTooltip']					= "インベントリの空き状況の表示をステータスバーに追加します"
WritCreater.optionStrings['incompleteColour']							= "未完了クエストの色"
WritCreater.optionStrings['completeColour']								= "完了クエストの色"
WritCreater.optionStrings['smartMultiplier']							= "スマートマルチクラフト（3日分の一括クラフト）"
WritCreater.optionStrings['smartMultiplierTooltip']						= "これをオンにすると, 3日間の令状クエストの全サイクルのアイテムをまとめてクラフトします。令状に必要なアイテムを既に持っているかをチェックし、個々のアイテムのクラフト要否はアドオンが判断します。これをオフにすると、単純にその日の令状クエストのアイテムだけをクラフトします。"


--[[
WritCreater.cheeseyLocalizations
=
{
	['reward'] = "-1 正気度",
	['rewardStylized'] = "-1 |cFFFFFF[正気度]|",
	['finalReward'] = "全部クリアして、確かめてみてください！",
	['menuName'] = "チーズくさい",
	['endeavorName'] = "チーズくさいエンデバー",
	['tasks']={
		{name="チーズへの愛を告白する",completion = "これで、あなたのチーズ好きが世界中に知れ渡りました！",
			description="チャットで「私はチーズが大好きだー！」と言う"},
		{name = "シェオおじさんを訪ねる", completion = "シェオおじさんも喜んでましたよ。そして悲しげな表情を浮かべた。チーズくさいけど、いつもキレッキレ！",
			description="シェオゴラスを見つけて話しかける。彼はとても寂しがり屋で、あなたにまた会いたがっています"},
		{name = "ひどい音楽を聴かせる", completion = "ギャー！ ひどい音で耳が痛くなったーっ！",
			description="楽器演奏のエモートを使う"},
		{name = "チーズを捨てる", completion = "チーズを捨てましたね。どうせカビていたんだろう...。",
			description="|H1:item:27057:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|hを１つ破壊する。 そう、たしかにクレイジーですが、そこがポイントです！"},
		{name = "チーズくさい本を読む", completion = "なんて香しい靴下なんだろう。いや、チーズ！？....いえ、本のことです！",
			description="本「|H0:item:121046:364:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:10000:0|h|h」を読む"},
		{name = "他の全てのチーズくさいエンデバーを完了する", completion = "チーズ！チーズ！チーズだらけだ！依頼書をやっている時も？",
		description="全部クリアすればシェオゴラスも大喜びですよ"},
	},
	['allComplete'] = "全てのチーズくさいエンデバーが完了した！",
	['chatbingo'] = "私はチーズが大好きだー！",
	["cheatyCheeseBook"] = "おかしくなっているのかもしれないが、あの本のことは覚えていないようだ...。",
}
WritCreater.cheeseBingos["私はチーズが大好きだ"] = true
WritCreater.cheeseBingos["私はチーズが大好きだー"] = true
WritCreater.cheeseBingos["私はチーズが大好きだー！"] = true
]]

WritCreater.cheeseyLocalizations
=
{
	['menuName'] = "|cFFBF00儀式|r",
	['endeavorName'] = "儀式的なエンデバー",
	['tasks']={
		{original="あなたは奇妙なパンフレットを見つけました．．．多分それを読む(/yomu)べきです。",name="幸運を呼ぶ儀式の説明を読む", completion = "幸運を呼ぶ儀式を行う方法を学びました！",
			description="本を読むエモート(/yomu)を使う"},

		{original="???", name = "無実の山羊のはらわたを調達する", completion = "モンスターめ！ 幸運を呼ぶためなら何でもありだと思っている．．．",
			description="死んだ家畜の山羊から内臓を入手する。別にあなたが殺める必要はないのだけど．．．でもそれが最も簡単な方法です"},

		{original="???", name = "儀式の場所、アラナンガに向かう", completion = "よくやったね！ とても精励な場所のようですね",
			description="アラナンガがどこにあるか分からないって？ もしかしたら賜り物のクラフト台かも．．．"},

		{original="???", name = "山羊のはらわたを破壊する", completion = "あなたは生け贄を燃やしてやった",
			description="入手した |H1:item:42870:30:1:0:0:0:0:0:0:0:0:0:0:0:16:0:0:0:1:0:0|h|h を破壊する"},

		{original="???", name = "チャットで RNGesus の神を称える", completion = "あなたは不思議と運が良くなったように感じる。いや、もしかしたら気のせいかも．．．",
			description="実際に何が書かれていたかは分からないけれど、あなたの最善の推測でどうぞ"},
				-- Or Nocturnal, or Fortuna, Tyche as easter eggs?

		-- {original="???", name = "Complete the ritual", completion = "Maybe you'll be just a little bit luckier... And Writ Crafter has a new skin!",
		-- description="Sheogorath will be very pleased if you complete them all!"},
	},
	["completePrevious"] = "先に前のステップを完了させておくとよいでしょう",
	['allComplete'] = "全ての儀式的なエンデバーが完了した！",
	['allCompleteSubheading'] = "来年たとえあなたが RNGesus神の恩寵を受けることが叶わなくとも、Writ Crafterアドオンの新しい外観スタイルが得られました！",
	["goatContextTextText"] = "山羊",
	["extraGoatyContextTextText"] = "山羊^n",
	["extraSlash"] = "/yomu",
	["bookText"] = 
[=[
この儀式はあなたに大きな幸運をもたらす|L0:0:0:45%%:8%%:ignore|lでしょう|lかもしれない。 以下の手順を正確に実行してください！

1. |L0:0:0:45%%:8%%:ignore|l羊|l 山羊から新鮮な内蔵を入手する
2. |L0:0:0:45%%:8%%:ignore|lオブリビオン|l アラナンガに向かう
3. 生け贄の内蔵を燃やす
4. [判読不能な名称] を称える

- 真心を込めて,
|L0:0:0:45%%:8%%:ignore|lシェオゴラス|l シェオゴヲス]=],
	["bookTitle"] = "幸運を呼ぶ儀式",
	["outOfRange"] = "あなたはもう儀式の場所にいません！",
	["closeEnough"] = "じゅうぶん近いから合格",
	["praiseHint "] = "(半角の)RNGesusについて何か言う必要があるんじゃない？",
}


WritCreater.cheeseyLocalizations["alreadyUnlocked"] = "Writ CrafterのUIスキン解除済"
WritCreater.cheeseyLocalizations["alreadyUnlockedTooltip"] = "あなたは 2023年4月1日に既にUIスキンを解除済です。もう一度やるのはただの楽しみのためです！"
WritCreater.cheeseyLocalizations["settingsChooseSkin"] = "あなたは設定メニューからUIスキンを変更できます"

--/esoui/art/icons/pet_041.dds
--/esoui/art/icons/pet_042.dds
--/esoui/art/icons/pet_sheepbrown.dds