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
{4032,
[[Bug Fixes
- Fixed lua errors which fired when using the deconstruction assistants
- Fixed a bug where the smart multiplier wouldn't properly detect level 1 crafted items
]]
},
{
	4036,
[[Added Psijic Recipe Fragments to supported writ reward handling
Added the ability to craft set items for the 'A Crafty Business' Golden Pursuit. 
|t12:12:EsoUI/Art/Miscellaneous/bullet.dds|t When you interact with a grand master crafting station, you will see a prompt to craft the items. 
|t12:12:EsoUI/Art/Miscellaneous/bullet.dds|t Will only craft the ones you still need, and will only show if you haven't finished the capstone reward
|t12:12:EsoUI/Art/Miscellaneous/bullet.dds|t Note that it's very basic, so will only craft robes/axes/bow/ring
]]
},
{
	4038,
[[Added gold to writ reward handling. You can set it to deposit all gold you get from writs into your bank. Only the actual quest gold will be deposited
Fixed a bug where reward handling for the new unknown surveys was using the setting for the unknown master writs
]],pc="Added a 'port to craft house' button to the settings menu (a few versions ago)"
},
{4039,
[[Smart multiplier now supports enchanting
Fixed a bug where unknown surveys and unknown master writs were combined in the loot statistics window
Changed the background texture to use the old background texture
]]
},
{4041,
[[Added support for gold mats to the rewards handling
]]}

}-- ,pc =[[Added a port to crafting house button to the settings menu]]

local welcomeMessage = "Thanks for installing Dolgubon's Lazy Writ Crafter! Please check out the settings to customize the behaviour of the addon"

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
			local text = changelog[i][2]
			if IsConsoleUI() and changelog[i].console then
				text = text..changelog[i].console
			elseif not IsConsoleUI() and changelog[i].pc then
				text = text..changelog[i].pc
			end
			displayText(text)
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