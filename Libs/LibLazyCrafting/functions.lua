function GetItemIDFromLink(itemLink) return tonumber(string.match(itemLink,"|H%d:item:(%d+)")) end

function GetItemNameFromItemId(itemId) end

function GetCurrentSetInteractionIndex() end

function canCraftItemHere(station, setIndex) end

function findItem(itemID) end

local function CraftEnchantingItemId(self, potencyItemID, essenceItemID, aspectItemID)
end

local craftingQueue