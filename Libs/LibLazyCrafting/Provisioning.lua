-----------------------------------------------------------------------------------
-- Library Name: LibLazyCrafting
-- Creator: Dolgubon (Joseph Heinzle)
-- File Creator: ziggr
-- Library Ideal: Allow addons to craft anything, anywhere
-- Library Creation Date: December, 2016
-- Publication Date: Febuary 5, 2017
--
-- File Name: Provisioning.lua
-- File Description: Contains the functions for Provisioning
-- Load Order Requirements: After LibLazyCrafting.lua
--
-----------------------------------------------------------------------------------


--Don't fail silently?

local LibLazyCrafting = LibStub("LibLazyCrafting")
local sortCraftQueue = LibLazyCrafting.sortCraftQueue

local widgetType = 'provisioning'
local widgetVersion = 1.6
if not LibLazyCrafting:RegisterWidget(widgetType, widgetVersion) then return false end

local function dbug(...)
    if not DolgubonGlobalDebugOutput then return end
    DolgubonGlobalDebugOutput(...)
end

local craftingQueue = LibLazyCrafting.craftingQueue

local function getItemLinkFromItemId(itemId) local name = GetItemLinkName(ZO_LinkHandler_CreateLink("Test Trash", nil, ITEM_LINK_TYPE,itemId, 1, 26, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 10000, 0))
    return ZO_LinkHandler_CreateLink(zo_strformat("<<t:1>>",name), nil, ITEM_LINK_TYPE,itemId, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
end

local function toRecipeLink(recipeId)
    return string.format("|H1:item:%s:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", tostring(recipeId))
end

local function LLC_CraftProvisioningItemByRecipeId(self, recipeId, timesToMake, autocraft, reference)
    dbug('FUNCTION:LLCCraftProvisioning')
    if reference == nil then reference = "" end
    if not self then d("Please call with colon notation") end
    if autocraft==nil then autocraft = self.autocraft end
    if not recipeId then return end

    -- ZOS API prefers recipeListIndex + recipeIndex, not recipeId or recipeLink.
    -- Translate now, fail silently if we cannot.
    local recipeLink = toRecipeLink(recipeId)
    local recipeListIndex, recipeIndex = GetItemLinkGrantedRecipeIndices(recipeLink)
    if not (recipeListIndex and recipeIndex) then d("Recipe not found") return end

    table.insert(craftingQueue[self.addonName][CRAFTING_TYPE_PROVISIONING],
    {
        ["recipeId"] = recipeId,
        ["recipeListIndex"] = recipeListIndex,
        ["recipeIndex"] = recipeIndex,
        ["timestamp"] = GetTimeStamp(),
        ["autocraft"] = autocraft,
        ["Requester"] = self.addonName,
        ["reference"] = reference,
        ["station"] = CRAFTING_TYPE_PROVISIONING,
        ["timesToMake"] = timesToMake or 1
    }
    )

    --sortCraftQueue()
    if GetCraftingInteractionType()==CRAFTING_TYPE_PROVISIONING then
        LibLazyCrafting.craftInteract(event, CRAFTING_TYPE_PROVISIONING)
    end
end

local function LLC_ProvisioningCraftInteraction(event, station)
    
    dbug("FUNCTION:LLCProvisioningCraft")
    local earliest, addon , position = LibLazyCrafting.findEarliestRequest(CRAFTING_TYPE_PROVISIONING)
    if not earliest then LibLazyCrafting.SendCraftEvent( LLC_NO_FURTHER_CRAFT_POSSIBLE,  station) return end
    if IsPerformingCraftProcess()  then return end

    dbug("CALL:ZOProvisioningCraft")
    local recipeArgs = { earliest.recipeListIndex, earliest.recipeIndex }
    LibLazyCrafting.isCurrentlyCrafting = {true, "provisioning", earliest["Requester"]}
    CraftProvisionerItem(unpack(recipeArgs))

    currentCraftAttempt = LibLazyCrafting.tableShallowCopy(earliest)
    currentCraftAttempt.callback = LibLazyCrafting.craftResultFunctions[addon]
    currentCraftAttempt.slot = nil
    currentCraftAttempt.link = GetRecipeResultItemLink(unpack(recipeArgs))
    currentCraftAttempt.position = position
    currentCraftAttempt.timestamp = GetTimeStamp()
    currentCraftAttempt.addon = addon
    currentCraftAttempt.prevSlots = LibLazyCrafting.backpackInventory()
end

local function LLC_ProvisioningCraftingComplete(event, station, lastCheck)
    LibLazyCrafting.stackableCraftingComplete(event, station, lastCheck, CRAFTING_TYPE_PROVISIONING, currentCraftAttempt)
end

local function LLC_ProvisioningIsItemCraftable(station, request)
    if station ~= CRAFTING_TYPE_PROVISIONING then return false end

    local materialList  = {}
    local recipeLink    = getItemLinkFromItemId(request.recipeId)
    local ingrCt        = GetItemLinkRecipeNumIngredients(recipeLink)
    for ingrIndex = 1,ingrCt do
        local _, _, ingrReqCt = GetItemLinkRecipeIngredientInfo(recipeLink, ingrIndex)
        local ingrLink = GetItemLinkRecipeIngredientItemLink(recipeLink, ingrIndex, LINK_STYLE_DEFAULT)
        if       ingrReqCt
            and (0 < ingrReqCt)
            and  ingrLink
            and (ingrLink ~= "") then
            local mat = { itemLink   = ingrLink
                        , requiredCt = ingrReqCt * request.timesToMake
                        }
            table.insert(materialList, mat)
        end
    end
    return LibLazyCrafting.HaveMaterials(materialList)
end

LibLazyCrafting.craftInteractionTables[CRAFTING_TYPE_PROVISIONING] =
{
    ["station"] = CRAFTING_TYPE_PROVISIONING,
    ["check"] = function(self, station) return station == self.station end,
    ['function'] = LLC_ProvisioningCraftInteraction,
    ["complete"] = LLC_ProvisioningCraftingComplete,
    ["endInteraction"] = function(station) --[[endInteraction()]] end,
    ["isItemCraftable"] = LLC_ProvisioningIsItemCraftable

}

LibLazyCrafting.functionTable.CraftProvisioningItemByRecipeId = LLC_CraftProvisioningItemByRecipeId
