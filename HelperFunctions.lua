-----------------------------------------------------------------------------------
-- Addon Name: Dolgubon's Lazy Writ Crafter
-- Creator: Dolgubon (Joseph Heinzle)
-- Addon Ideal: Simplifies Crafting Writs as much as possible
-- Addon Creation Date: March 14, 2016
--
-- File Name: HelperFunctions.lua
-- File Description: This file contains various helper functions
-- Load Order Requirements: Early, just in case
-- 
-----------------------------------------------------------------------------------

-- This adds a new function to the global table, due to its wide utility. -- NOTE: In Summerset, this will be an API function provided by the game

function getItemLinkFromItemId(itemId) 
	return string.format("|H1:item:%d:%d:50:0:0:0:0:0:0:0:0:0:0:0:0:%d:%d:0:0:%d:0|h|h", itemId, 0, ITEMSTYLE_NONE, 0, 10000) 
end 