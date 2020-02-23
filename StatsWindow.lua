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

	local BG = GetControl(control, "BG")
	local name = GetControl(control, "Name")
	local amount = GetControl(control, "Amount")
	name:SetColor(0.4627,0.73725,0.7647)
	if name then
		if type(data.item ) == "number" then
			name:SetText(getItemLinkFromItemId(data.item))
		else
			name:SetText(data.item)
		end
	end
	if amount then
		amount:SetText(data.amount or "")
	end
	if BC then
		BG:SetAnchorFill(control)
		BG:SetCenterColor(1, 0.5, 0.5, 0.2)
		BG:SetEdgeColor(0,0,0,0)
	end
	ZO_SortFilterList.SetupRow(self, control, data)
	BG:SetCenterColor(1,0,0)
	if  data.header then
		name:SetText(GetCraftingSkillName(data.craft).. " Rewards")
		name:SetColor(0,1,0)
	end
end
WritCreater.quality = {}

for i = 1, 5 do
	local qualityColor = ZO_ColorDef:New(GetInterfaceColor(INTERFACE_COLOR_TYPE_ITEM_QUALITY_COLORS, i))
    
    WritCreater.quality[i] = {[1] = i, [2] = qualityColor:Colorize(GetString(SI_ITEMQUALITY0 + i))  } 
	
end

function RewardsScroll:BuildMasterList()
	self.masterList = {}

	for craft, craftRewards in pairs(self.data) do
		local craftHeader = {["craft"] = craft ,["header"]=true}
		table.insert(self.masterList, 
				craftHeader
			)
		for reward, amount in pairs(craftRewards) do
			if reward=="num" then
				craftHeader.amount=amount.." done"
			elseif reward=="fragment" then
			else
				if type(amount)=="table" then
					for qualifier, qualifierAmount in pairs(amount) do
						if qualifierAmount>0 then
							table.insert(self.masterList, {["craft"] = craft ,["item"]=reward,["qualifier"]=qualifier, ["amount"]=qualifierAmount})
						end
					end
				else
					table.insert(self.masterList, 
						{["craft"] = craft ,["item"]=reward, ["amount"]=amount}
					)
				end
			end
		end

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