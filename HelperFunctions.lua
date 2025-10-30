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


local craftingHouses = 
{
    ["XB1live-eu"] = 
            {{displayName = "@Blackswan20022" , houseId = 116, greeting = "Welcome to the Highlanders Might Guild Hall",
        subHeading = "Stations are located directly by entrance.", chatMessage = "Like their guild house and want to join? Check them out here: |H1:guild:303060|hHighlanders Might|h|h",},
        {displayName = "@Darhysh" , houseId = 18, greeting = "Welcome to Wizard’s Emporium",
        subHeading = "Stations are located at entrance.", chatMessage = "Like their guild house and want to join? Check them out here: |H1:guild:289124|hWizard's Emporium|h",},},
    ["XB1live"] = {
        {displayName = "@J3zdaz", houseId = 46, greeting = "J3’s Craft Hub",
        subHeading = "Stations at front, to the right.", chatMessage = "Like their guild house and want to join? Check them out here: |H1:guild:1218717|hRebels Reign|h"},
        {displayName = "@Razberry9876" , houseId = 18, greeting = "Welcome to the Master Writ Pit!",
        subHeading = "Stations in front entry area.",},
        {displayName = "@MisfitOfSith" , houseId = 94, greeting = "Welcome to the Tarnished Architect's Guild House! Prepare yourself to be Bio Shocked!",
        subHeading = "Follow the portal", chatMessage = "Like their guild house and want to join? Check them out here: |H1:guild:1111961|hTarnished Architects|h"},},
    ["PS4live"] = 
        {{displayName = "@bat_girl77" , houseId =  55, greeting = "Welcome to bat’s Craft House!",
        subHeading = "Stations are located by front entrance.", chatMessage = "Like their guild house and want to join? Check them out here: |H1:guild:908761|hDecor and Design|h|h",},
        {displayName = "@b3ast03101978" , houseId = 21,  greeting = "B3astly Builds Headquarters",
        subHeading = "Stations are located in outside area.",},},
    ["PS4live-eu"] = 
         {{displayName = "@NocturnaStrix" , houseId = 102, greeting = "Welcome, traveler. The veil grows thin tonight.",
        subHeading = "Stations are located on the left side of the stairs at entrance.",},
        {displayName = "@Festegios" , houseId =  90, greeting = "Welcome to Renegade Jesters Guild House",
        subHeading = "Stations are located on the left.",}, 
        {displayName = "@Ettena_" , houseId =  99 , greeting = "Welcome to The Hex Pistols Craft Hub",
        subHeading = "Stations are to the left around the corner.", chatMessage = "Like their guild house and want to join? Check them out here: |H1:guild:382160|hThe Hex Pistols|h|h",},},
    ["NA Megaserver"] = 
    {
        {displayName = "@xGAMxHQ", houseId = 71, greeting = "Welcome to Moon's Edge's guild house!", subheading = "Stations straight ahead", 
            chatMessage = "Like their guild house and want to join? Check them out here: |H1:guild:391101|hMoon's Edge|h"},
        {displayName = "@Amrayia", houseId = 71, greeting = "Welcome to Auction House Central's guild house!", subheading = "Stations straight ahead", 
            chatMessage = "Like their house? Join AHC in Alinor - where friendly traders thrive. Check it out here: |H1:guild:370167|hAuction House Central|h"},
        {displayName = "@Kelinmiriel", houseId = 40, greeting = "Welcome to Kelinmiriel's house!", subheading = "Stations to your left", chatMessage = ""},
        {displayName = "@AuctionsBMW", houseId = 62, greeting = "Welcome to Black Market Wares' guild house!", subheading = "Stations to your left", 
            chatMessage ="Like their guild house and want to join? Check them out here: |H1:guild:1427|hBlack Market Wares|h"},
    },
    ["EU Megaserver"] = 
    {
        {displayName = "@JN_Slevin", houseId = 56, greeting = "Welcome to JNSlevin's house!", subheading = "Stations to the left", 
            chatMessage = "Welcome to the Independent Trading Team [ITT]'s guild house! if you find yourself in need of a "..
        "trading guild please join discord.gg/itt or contact @JN_Slevin, @LouAnja or @RichestGuyinESO. From Mournhold to Alinor we have a space for every every type of trader you might be!"},
        {displayName = "@Ek1", houseId = 66, greeting = "Welcome to Ek1's house!", subheading = "Stations right here!", chatMessage = ""},
    }
}
if GetTimeStamp() < 1754784957 then
    craftingHouses["XB1live"][3] = nil
end

---Join AHC in Alinor - where traders thrive in a friendly community. Check it out here: |H1:guild:370167|hAuction House Central|h
-- Like their guild house? Join AHC in Alinor here: |H1:guild:370167|hAuction House Central|h
-- Like their house? Join AHC in Alinor - where friendly traders thrive. Check it out here: |H1:guild:370167|hAuction House Central|h
--GetCurrentHouseOwner()
-- GetCurrentZoneHouseId()
local houseToUse
local function displayGreeting(greeting, subHeading)
    local messageParams = CENTER_SCREEN_ANNOUNCE:CreateMessageParams(CSA_CATEGORY_LARGE_TEXT)
    messageParams:SetText(greeting, subHeading)
    CENTER_SCREEN_ANNOUNCE:AddMessageWithParams(messageParams)
end

local function welcomePlayerToHouse()
    if houseToUse and GetCurrentHouseOwner() == houseToUse.displayName and GetCurrentZoneHouseId()==houseToUse.houseId then
        displayGreeting(houseToUse.greeting, houseToUse.subheading)
        if houseToUse.chatMessage and houseToUse.chatMessage~="" then
            d(houseToUse.chatMessage)
        end
        houseToUse = nil
        EVENT_MANAGER:UnregisterForEvent(WritCreater.name.."_houseWelcome", EVENT_PLAYER_ACTIVATED )
    end
end

function WritCreater.portToCraftingHouse()
    if GetWorldName()=="PTS" then 
        return
    end
    if not craftingHouses[GetWorldName()] then return end -- no houses available :(
    houseToUse = craftingHouses[GetWorldName()][math.random(1, #craftingHouses[GetWorldName()] ) ]
    JumpToSpecificHouse(houseToUse.displayName, houseToUse.houseId)
    EVENT_MANAGER:RegisterForEvent(WritCreater.name.."_houseWelcome", EVENT_PLAYER_ACTIVATED , welcomePlayerToHouse)
end
