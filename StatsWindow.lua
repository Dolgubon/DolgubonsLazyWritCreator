local RewardsScroll = ZO_SortFilterList:Subclass()
WritCreater.rewardsScroll = RewardsScroll

function RewardsScroll:New(control)

	ZO_SortFilterList.InitializeSortFilterList(self, control)
	
	local SorterKeys =
	{
		name = {},
	}
	
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
				if data[craft] == nil then
					amount:SetText("")
				else
					amount:SetText(data[craft].amount or "")
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

local rewardNameMaps = 
{
	["master"] = "Sealed Writs",
	["intricate"] = "Intricate Gear",
	["material"] = "Low level mats",
	["survey"] = "Surveys",
	["soulGem"] = "Soul Gems",
	["glyph"] = "Decon Glyphs",
	["repair"] = "Repair Kits",
	["ornate"] = "Ornate Gear"
}
WritCreater.quality = {}

for i = 1, 5 do
	local qualityColor = ZO_ColorDef:New(GetInterfaceColor(INTERFACE_COLOR_TYPE_ITEM_QUALITY_COLORS, i))
    
    WritCreater.quality[i] = {[1] = i, [2] = qualityColor:Colorize(GetString(SI_ITEMQUALITY0 + i))  } 
	
end

function RewardsScroll:BuildMasterList()
	self.masterList = {}

	for craft, craftRewards in pairs(self.data) do
		local craftHeader = {["craft"] = craft ,["header"]=true}
		local craftMasterList = {}
		-- table.insert(self.masterList, 
		-- 		craftHeader
		-- 	)
		local i = 1
		for reward, amount in pairs(craftRewards) do

			if reward=="num" then
				craftHeader.amount=amount.." Writs Done"
			elseif reward=="fragment" then
				local name
				if craft == CRAFTING_TYPE_PROVISIONING then
					name = "Psijic Fragment"
				else
					name = "Glass Fragment"
				end
				self.masterList[i] = self.masterList[i] or {}
				self.masterList[i][craft]= {["craft"] = craft ,["item"]=name, ["amount"]=amount}
				i = i+1
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
				else
					self.masterList[i] = self.masterList[i] or {}
					self.masterList[i][craft]= {["craft"] = craft ,["item"]=rewardNameMaps[reward] or reward, ["amount"]=amount}
					i = i+1
				end
			end
		end
		local header = GetControl(DolgubonsLazyWritStatsWindowBackdropCraftHeader,"Craft"..craft)
		local  headerName= GetControl(header,"Name")
		headerName:SetText(GetCraftingSkillName(craftHeader.craft).. " Rewards")
		headerName:SetColor(0,1,0)
		local headerAmount = GetControl(header, "Amount")
		headerAmount:SetText(craftHeader.amount)
		headerAmount:ClearAnchors()
		headerAmount:SetAnchor(TOP, headerName, BOTTOM, 80, 0)
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
	WritCreater.updateList()
end

updateList = function () 
	WritCreater.rewardsScrollManager:RefreshData()
	DolgubonsLazyWritStatsWindowBackdropWritCounter:SetText("Writs Done: ".. WritCreater.savedVarsAccountWide.total)
end
WritCreater.updateList = updateList