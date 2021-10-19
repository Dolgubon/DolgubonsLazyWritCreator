WritCreater = WritCreater or {}
local RewardsScroll = ZO_SortFilterList:Subclass()
WritCreater.rewardsScroll = RewardsScroll

function RewardsScroll:New(control)

	ZO_SortFilterList.InitializeSortFilterList(self, control)
	
	local SorterKeys =
	{
		name = {},
	}
	self.viewType = 0
 	self.masterList = {}
	
 	ZO_ScrollList_AddDataType(self.list, 1, "WritCrafterRewardTemplate", 30, function(control, data) self:SetupEntry(control, data) end)
 	ZO_ScrollList_EnableHighlight(self.list, "ZO_ThinListHighlight")
	self.currentSortKey = "Reference"
	self.currentSortOrder = ZO_SORT_ORDER_UP
 	self.sortFunction = function(listEntry1, listEntry2) 
 		if listEntry1.data.craft==listEntry2.data.craft then
 			d(listEntry1.data.amount)
 			d(listEntry2.data.amount)
 			return (listEntry1.data.amount or -1)> (listEntry2.data.amount or -1)
 		end 
 		return listEntry1.data.craft> listEntry2.data.craft 
 	end
 	--[[
	self.currentSortKey = "name"
	self.currentSortOrder = ZO_SORT_ORDER_DOWN
 	]]
	self.data = WritCreater.savedVarsAccountWide.rewards
	return self
	
end

local function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end
--[[

iridium grains ~700g
iridium plating ~8000g
zircon grains ~2000g
zircon plating ~22000g
chromium grains ~8000g
chromium plating ~80000g
dreugh wax ~8500g
tempering alloy ~4700g
rosin ~2500g
kuta ~2100g
imp stool ~45g
water hyacinth ~170g
rough provisinoing mat price ~5-10g
rough voucher price ???]]




local priceEstimates={
	["EU Megaserver"] = {
		[135153] = 2000,--zircon grains
		[135149] = 220000,--zircon platin
	},
	["NA Megaserver"] = {
		["Trait Stones"] = 5,
		["Trait Fragments"] = 20,
		["Psijic Fragment"] = 200,
		["Blue Recipes"] = 200,
		["Green Recipes"] = 30,
		["Purple Recipes"] = 2000,
		["White Mats"] = 5,
		[54173] = 5000,
		[54177] = 8000,
		[54181] = 2000,
		[45854] = 2000,	
		[135154] = 8000,
		[135150] = 80000,
		[135152] = 800,
		[135153] = 2500,--zircon grains
		[135149] = 25000,--zircon platin
		[135151] = 100,
		[135147] = 1000,
		[135148] = 8000,
		[27059] = 50,
		[26802] = 50,
		[64501] = 40,
		[77583] = 150,
		[30157] = 150,
		[30148] = 40,
		[30160] = 180,
		[77585] = 50,
		[139020] = 4000,
		[30164] = 400,
		[30161] = 400,
		[150789] = 100,
		[150731] = 500,
		[30162] = 75,
		[30151] = 50,
		[77587] = 50,
		[30156] = 50,
		[30158] = 180,
		[30155] = 50,
		[30163] = 100,
		[77591] = 150,
		[30153] = 150,
		[77590] = 150,
		[30165] = 80,
		[77589] = 200,
		[77584] = 50,
		[30149] = 50,
		[77581] = 250,
		[30152] = 200,
		[30166] = 175,
		[30154] = 40,
		[30159] = 100,
	}
}

local rewardNameMaps = 
{
	["master"] = {"Sealed Writs",5000},
	["intricate"] = {"Intricate Gear",200},
	["material"] = {"Mat Shipments",50},
	["survey"] = {"Surveys",5000},
	["soulGem"] = {"Empty Soul Gems",30},
	["glyph"] = {"Decon Glyphs",100},
	["repair"] = {"Repair Kits",200},
	["ornate"] = {"Ornate Gear",200},
	["voucher"] = {"Vouchers",500},
}
local craftWritValueModifiers = 
{
	10000,
	10000,
	5000,
	5000,
	1500,
	10000,
	500,
}

local function getPrice(itemInfo,estimateKey, craft)
	local itemLink
	if type(itemInfo ) == "number" then
		itemLink = getItemLinkFromItemId(itemInfo)
		if LibPrice then 
			local price  = LibPrice.ItemLinkToPriceGold(itemLink)
			if price then
				return price
			end
		end
		if MasterMerchant then
        local itemStats = MasterMerchant:itemStats(itemLink, false)
        if itemStats and itemStats.avgPrice then
            return itemStats.avgPrice
        end 
    end
		if TamrielTradeCentrePrice then
			local t = TamrielTradeCentrePrice:GetPriceInfo(itemLink)
			if t and t.SuggestedPrice then
				return t.SuggestedPrice
			end
		end
	end
	if itemInfo == "Trait Stones" and craft == CRAFTING_TYPE_JEWELRYCRAFTING then
		return 200
	end
	if itemInfo == "Vouchers" and craft == CRAFTING_TYPE_JEWELRYCRAFTING then
		return 10
	end
	if itemInfo == "Surveys" and craft == CRAFTING_TYPE_JEWELRYCRAFTING then
		return 13000
	end
	if type(estimateKey)=="number" then
		if itemInfo == "Sealed Writs" then
			return craftWritValueModifiers[craft]
		end
		return estimateKey
	end
	local default = (priceEstimates[GetWorldName()] and priceEstimates[GetWorldName()][itemInfo]) or priceEstimates["NA Megaserver"][itemInfo]
	if not default then
		return GetItemLinkValue(itemLink)
	end
	return default
end

local function formatNum(n) -- credit http://richard.warburton.it
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

function RewardsScroll:SetupEntry(control, data)
	control.data = data
	for craft = 1, 7 do
		local rowCraftControl = GetControl(control, "Craft"..craft)
		if rowCraftControl then
			local BG = GetControl(rowCraftControl, "BG")
			local name = GetControl(rowCraftControl, "Name")
			local amount = GetControl(rowCraftControl, "Amount")
			if name then
				name:SetColor(0.4627,0.73725,0.7647)
				if data[craft] == nil then
					name:SetText("")
				elseif type(data[craft].item ) == "number" then
					if not data[craft].item then
						d(data[craft].amount)
					end
					name:SetText(getItemLinkFromItemId(data[craft].item))
				else
					if not data[craft].item then
						d(data[craft])
					end
					name:SetText(data[craft].item)
				end
			end
			if amount then
				if data[craft] == nil or not data[craft].amount  then
					amount:SetText("")
				else
					if WritCreater.rewardsScrollManager.viewType == 0 then
						amount:SetText(formatNum(data[craft].amount))
					elseif WritCreater.rewardsScrollManager.viewType == 1 then
						local amountText = "1 in "..round(self.craftTotals[craft]/data[craft].amount, 2)
						amount:SetText(amountText)
					elseif  WritCreater.rewardsScrollManager.viewType == 2 then
						local amountText = round(data[craft].amount/self.craftTotals[craft]*100, 2).."%"
						amount:SetText(amountText)
					elseif WritCreater.rewardsScrollManager.viewType == 3 then
						local price = (getPrice(data[craft].item, data[craft].estimate, craft)or 0)*data[craft].amount
						price =math.floor(price)
						amount:SetText(formatNum(price).."g")
					end
				end
			end
			if BG then
				BG:SetAnchorFill(control)
			end	
		end
	end
	ZO_SortFilterList.SetupRow(self, control, data)
	-- local BG = GetControl(control, "BG")
	-- local name = GetControl(control, "Name")
	-- local amount = GetControl(control, "Amount")
	

	-- if BG then
	-- 	BG:SetAnchorFill(control)
	-- 	BG:SetCenterColor(1, 0.5, 0.5, 0.2)
	-- 	BG:SetEdgeColor(0,0,0,0)
	-- end
	
	-- BG:SetCenterColor(1,0,0)
	-- if  data.header then
	-- 	name:SetText(GetCraftingSkillName(data.craft).. " Rewards")
	-- 	name:SetColor(0,1,0)
	-- end
end


WritCreater.quality = {}

for i = 1, 5 do
	local qualityColor = ZO_ColorDef:New(GetInterfaceColor(INTERFACE_COLOR_TYPE_ITEM_QUALITY_COLORS, i))
    
    WritCreater.quality[i] = {[1] = i, [2] = qualityColor:Colorize(GetString(SI_ITEMQUALITY0 + i))  } 
	
end

function RewardsScroll:BuildMasterList()
	self.masterList = {}
	self.craftTotals = {}
	local totalValue = 0
	for craft, craftRewards in pairs(self.data) do
		local craftHeader = {["craft"] = craft ,["header"]=true}
		local craftMasterList = {}
		local traitMatTable =  {["craft"] = craft ,["item"]="Trait Stones", ["amount"]=0, estimateKey="traitMat"}
		local pulverizedTraitMatTable =  {["craft"] = craft ,["item"]="Trait Fragments", ["amount"]=0, estimateKey="pulverizedMat"}
		-- table.insert(self.masterList, 
		-- 		craftHeader
		-- 	)
		local i = 1
		if not (craft == CRAFTING_TYPE_ENCHANTING or craft == CRAFTING_TYPE_ALCHEMY) then
			self.masterList[i] = self.masterList[i] or {}
			self.masterList[i][craft]= traitMatTable
			if craft == CRAFTING_TYPE_PROVISIONING then
				self.masterList[i][craft].item = "White Mats"
			end
			i = i+1
			if craft == CRAFTING_TYPE_JEWELRYCRAFTING then
				self.masterList[i] = self.masterList[i] or {}
				self.masterList[i][craft]= pulverizedTraitMatTable
				
				i = i+1
			end
		end
		for reward, amount in pairs(craftRewards) do
			local numTraitStones = 0
			if reward=="num" then
				craftHeader.amount=amount.." Writs Done"
				self.craftTotals[craft] = amount
			elseif reward=="fragment" then
				local name
				if craft == CRAFTING_TYPE_PROVISIONING then
					name = "Psijic Fragment"
				else
					name = "Glass Fragment"
				end
				if amount > 0 then
					self.masterList[i] = self.masterList[i] or {}
					self.masterList[i][craft]= {["craft"] = craft ,["item"]=name, ["amount"]=amount}
					i = i+1
				end
			else
				
				if type(amount)=="table" then
					for qualifier, qualifierAmount in pairs(amount) do
						if qualifierAmount>0 then
							self.masterList[i] = self.masterList[i] or {}
							local name

							if qualifier == "blue" then
								name = "Blue Recipes"
							elseif qualifier == "purple" then
								name = "Purple Recipes"
							elseif qualifier == "green" then
								name = "Green Recipes"
							end
							self.masterList[i][craft] =  {["craft"] = craft ,["item"]=name,["qualifier"]=qualifier, ["amount"]=qualifierAmount}
							i = i+1
						end
					end
				elseif type(reward)== "number" then
					local link = getItemLinkFromItemId(reward)
					local trait = GetItemLinkItemType(link)
					if trait == ITEMTYPE_WEAPON_TRAIT or trait==ITEMTYPE_JEWELRY_TRAIT or trait == ITEMTYPE_ARMOR_TRAIT or (trait == ITEMTYPE_INGREDIENT and GetItemLinkQuality(link)==1) then
						traitMatTable.amount = traitMatTable.amount + amount
					elseif trait == ITEMTYPE_JEWELRY_RAW_TRAIT then
						pulverizedTraitMatTable.amount = pulverizedTraitMatTable.amount + amount
					else
						self.masterList[i] = self.masterList[i] or {}
						self.masterList[i][craft]= {["craft"] = craft ,["item"]=rewardNameMaps[reward] and rewardNameMaps[reward][1] or reward, 
							["estimate"]=rewardNameMaps[reward] and rewardNameMaps[reward][2] or nil,["amount"]=amount}
						i = i+1
					end
					
				else

					self.masterList[i] = self.masterList[i] or {}
					self.masterList[i][craft]= {["craft"] = craft ,["item"]=rewardNameMaps[reward] and rewardNameMaps[reward][1] or reward,
						["estimate"]=rewardNameMaps[reward] and rewardNameMaps[reward][2] or nil, ["amount"]=amount}
					i = i+1
				end
			end
			if self.masterList[i-1] and self.masterList[i-1][craft] then
				local price = (getPrice(self.masterList[i-1][craft].item, self.masterList[i-1][craft].estimate, craft)or 0)*self.masterList[i-1][craft].amount
				price =math.floor(price)
				self.masterList[i-1][craft].price = price
				totalValue = totalValue + price
			end
		end
		local header = GetControl(DolgubonsLazyWritStatsWindowBackdropCraftHeader,"Craft"..craft)
		local  headerName= GetControl(header,"Name")
		headerName:SetText(zo_strformat("<<1>>",GetCraftingSkillName(craftHeader.craft)).. " Rewards")
		headerName:SetColor(0,1,0)
		local headerAmount = GetControl(header, "Amount")
		headerAmount:SetText(craftHeader.amount)
		headerAmount:ClearAnchors()
		headerAmount:SetAnchor(TOP, headerName, BOTTOM, 80, 0)
		local questGoldControl= GetControl(DolgubonsLazyWritStatsWindowBackdrop, "QuestGold")
		local questGold
		if  IsESOPlusSubscriber() then
			questGold = WritCreater.savedVarsAccountWide.total*664
		else
			questGold = WritCreater.savedVarsAccountWide.total*604
		end
		questGoldControl:SetText("Quest Gold: "..formatNum(questGold).."g")
		local itemValue = GetControl(DolgubonsLazyWritStatsWindowBackdrop, "ItemGold")
		itemValue:SetText("Total Item Value: "..formatNum(totalValue).."g")
		local itemValue = GetControl(DolgubonsLazyWritStatsWindowBackdrop, "TotalGold")
		itemValue:SetText("Total Reward Value: "..formatNum(totalValue+questGold).."g")
	end

end


function RewardsScroll:SortScrollList()
	local scrollData = ZO_ScrollList_GetDataList(self.list)
end


function RewardsScroll:FilterScrollList()
	local scrollData = ZO_ScrollList_GetDataList(self.list)
	ZO_ClearNumericallyIndexedTable(scrollData)
	for i = 1, #self.masterList do
		local data = self.masterList[i]
		table.insert(scrollData, ZO_ScrollList_CreateDataEntry(1, data))
	end
end

function WritCreater.setupScrollLists()
	WritCreater.rewardsScrollManager = RewardsScroll:New(DolgubonsLazyWritStatsWindowRewardScroll) -- check
	
	if WritCreater:GetSettings().debugMode then
		DolgubonsLazyWritStatsWindow:SetHidden(false)
		WritCreater.rewardsScrollManager.viewType =	WritCreater:GetSettings().defaultViewType or 1
	end
	WritCreater.updateList()
end

local function updateNonScrollElements()
	local daysSinceReset = math.floor((GetTimeStamp() - WritCreater.savedVarsAccountWide.timeSinceReset)/86400*100)/100
	DolgubonsLazyWritStatsWindowBackdropWritCounter:SetText("Writs Done: ".. WritCreater.savedVarsAccountWide.total.." in the past "..daysSinceReset.." days")
	
	local itemGold= GetControl(DolgubonsLazyWritStatsWindowBackdrop, "ItemGold")
	local totalGold= GetControl(DolgubonsLazyWritStatsWindowBackdrop, "TotalGold")
	local estimateWarning = GetControl(DolgubonsLazyWritStatsWindowBackdrop, "EstimateWarning")
end

updateList = function () 
	WritCreater.rewardsScrollManager:RefreshData()
	updateNonScrollElements()
end

function WritCreater.changeStatView()
	WritCreater.rewardsScrollManager.viewType = (WritCreater.rewardsScrollManager.viewType+1)%4
	WritCreater:GetSettings().defaultViewType = WritCreater.rewardsScrollManager.viewType
	WritCreater.updateList()
end
WritCreater.updateList = updateList
