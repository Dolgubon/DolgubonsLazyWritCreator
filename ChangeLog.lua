--  bullet point: |t12:12:EsoUI/Art/Miscellaneous/bullet.dds|t
local changelog = {
	{4030,
[[Changelog window
|t12:12:EsoUI/Art/Miscellaneous/bullet.dds|t You're looking at it! It will be used to communicate new features and bugfixes
Improved Craft Multiplier
|t12:12:EsoUI/Art/Miscellaneous/bullet.dds|t Will now craft for a full cycle of writs when you interact with a station (equipable gear only for now)
|t12:12:EsoUI/Art/Miscellaneous/bullet.dds|t Checks the current contents of your bag, and crafts up to x amount of each item. e.g., if you have a multiplier of 3, and currently have 1 sword, it will craft two swords
|t12:12:EsoUI/Art/Miscellaneous/bullet.dds|t If you want the old behaviour, you can turn the smart multiplier off in the settings menu
Slight load optimization - stat window functionality will only be loaded if you open the window
]],
console=[[
QR codes for settings links (Console only)
|t12:12:EsoUI/Art/Miscellaneous/bullet.dds|t Will pop up a QR code for you to scan, for example if you want to go to the forum thread for posting bugs
|t12:12:EsoUI/Art/Miscellaneous/bullet.dds|t LibQRCode added as a dependency to facilitate this behaviour
]]

},
-- {
-- 	4051,
-- 	console=[[
-- PSA: Ealier today, LibHarvenAddonSettings(LHAS), LibQRCode, and Tamriel Savings Co were subject to false copyright strikes and removed from the game.
-- Any addon which used LHAS to create a settings menu will be unusable unless updated by the authors to not require it.
-- Please do not badger authors to do so. Some may be unable to do these updates.

-- Because of the removal, until LHAS has been restored to the game, you will be |L0:0:0:90%%:10%%:|lunable to change the settings for Lazy Writ Crafter|l.
-- The settings you have previously set will be used, but you can use /resetwritcraftersettings to reset the settings.
-- ]]
-- }
{4052,console=
[[Added LibRadialMenu support. Using the radial menu, you can now craft sealed writs, port to a crafting house, or more!
Improved the identification of unique sealed writs. You'll now be able to queue multiple identical sealed writs at the same time
Queueing sealed writs will now also not re-queue previously crafted sealed writs.
 |t12:12:EsoUI/Art/Miscellaneous/bullet.dds|t If you need to re-craft a previously crafted writ, (Why'd you decon it? You needed that!) you can re-queue it from the inventory.
Writ Rewards set to be junked, will now be automatically sold when interacting with an NPC merchant.
]]},
{
	4053, console=
[[LibRadialMenu is now optional
Added a marker icon to the inventory for already crafted master writs
Added a marker icon to the inventory for items marked as junk
Added a setting option to use mimic stones for master writs, which is never use by default. The options are:
 |t12:12:EsoUI/Art/Miscellaneous/bullet.dds|t Never use
 |t12:12:EsoUI/Art/Miscellaneous/bullet.dds|t Always use
 |t12:12:EsoUI/Art/Miscellaneous/bullet.dds|t Use only if you don't have the style stone
 |t12:12:EsoUI/Art/Miscellaneous/bullet.dds|t Use if the style stone's cost is more than 1k or 3k gold
]]
},

}-- ,pc =[[Added a port to crafting house button to the settings menu]]

local welcomeMessage = WritCreater.strings['welcomeMessage']

local function displayText(text)
	WritCreater.initializeResetWarnerScene()
	DolgubonsLazyWritChangelogBackdropOutput:SetText(text)
	SCENE_MANAGER:Show("dlwcannouncer")
end

function WritCreater.displayChangelog()
	WritCreater.savedVarsAccountWide.initialInstall = false
	if WritCreater.savedVarsAccountWide.initialInstall then
		WritCreater.savedVarsAccountWide.initialInstall = false
		displayText(welcomeMessage)
		for i = 1, #changelog do
			WritCreater.savedVarsAccountWide.viewedChangelogs[changelog[i][1]] = true
		end
		return
	end
	
	for i = 1, #changelog do
		if not WritCreater.savedVarsAccountWide.viewedChangelogs[changelog[i][1]] then
			WritCreater.savedVarsAccountWide.viewedChangelogs[changelog[i][1]] = true
			local text = changelog[i][2] or ""
			if IsConsoleUI() and changelog[i].console then
				text = text..changelog[i].console
				if not LibHarvensAddonSettings then
					-- WritCreater.savedVarsAccountWide.viewedChangelogs[changelog[i][1]] = false
				end
			elseif not IsConsoleUI() and changelog[i].pc then
				text = text..changelog[i].pc
			end
			if text ~= "" then
				displayText(text)
			end
			return
		end
	end
	-- WritCreater.expectedVersion
end

if GetDisplayName() == "@Dolgubon" then
	SLASH_COMMANDS['/resetchangelog'] = function() WritCreater.savedVarsAccountWide.viewedChangelogs = {} WritCreater.displayChangelog() end
	SLASH_COMMANDS['/resetwelcome'] = function() WritCreater.savedVarsAccountWide.initialInstall = true  WritCreater.displayChangelog() end
	-- SLASH_COMMANDS['/resetchangelog2'] = function() WritCreater.savedVarsAccountWide.viewedChangelogs = {} WritCreater.savedVarsAccountWide.initialInstall = true end
	SLASH_COMMANDS['/displaychangelog'] = function() WritCreater.displayChangelog() end
end

function WritCreater.initializeResetWarnerScene()
	if WritCreater.announcementScreen then return end
	local announcementScreen = ZO_Scene:New("dlwcannouncer", SCENE_MANAGER)
	WritCreater.announcementScreen = announcementScreen
	WritCreater.announcementScreen:AddFragment(ZO_SimpleSceneFragment:New(DolgubonsLazyWritChangelog))
end