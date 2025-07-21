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
	return string.format("|H1:item:%d:%d:50:0:0:0:0:0:0:0:0:0:0:0:0:%d:%d:0:0:%d:0|h|h", itemId, 0, 0, 0, 10000) 
end 
WritCreater = WritCreater or {}
-- Currently only used on console, but who knows
function WritCreater.showQRCode(url)
    if not DolgubonsLazyWritQRCode or not LibQRCode then
        RequestOpenUnsafeURL(url)
    end
    if url == nil then return end
    if not WritCreater.qrCodeScene then
        local qrCodeScene = ZO_Scene:New("dlwcqrCode", SCENE_MANAGER)
        WritCreater.qrCodeScene = qrCodeScene
        WritCreater.qrCodeScene:AddFragment(ZO_SimpleSceneFragment:New(DolgubonsLazyWritQRCode))
    end
    LibQRCode.DrawQRCode(DolgubonsLazyWritQRCodeBackdropOutput, url)
    SCENE_MANAGER:Show("dlwcqrCode")
end
