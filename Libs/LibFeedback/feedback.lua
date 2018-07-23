-- Modified by Dolgubon based off code from Master Merchant with permission
-- Master Merchant was written by Dan Stone (aka @khaibit) / Chris Lasswell (aka @Philgo68)

--[[

Use:

local LibFeedback = LibStub:GetLibrary('LibFeedback')
LibFeedback:initializeFeedbackWindow(ExampleAddonNameSpace, -- namespace of the addon
"Example Addon", -- The title string for the feedback window and the mails it sends
"@AddonAuthor", -- The destination for feedback (0 gold attachment) and donation mails
{TOPLEFT , owningWindow , TOPLEFT , 10, 10}, -- The position of the mail button icon. 
					     -- The button is returned so you can modify the button if needed
{0,5000,50000, "https://www.genericexampleurl.com/somemoregenericiness"} -- The button info.
					-- If 0: Will not attach any gold, and will say 'Send Note'
					-- If non zero: Will auto attach that amount of gold
					-- If URL: Will show a dialog box and ask the user if they want to go to the URL.
					-- Can theoretically do any number of options, it *should* handle them
"If you found a bug, have a request or a suggestion, or simply wish to donate, send a mail." 
					-- The above will be displayed as a message below the title.
)

]]



local libLoaded
local LIB_NAME, VERSION = "LibFeedback", 1.0
local LibFeedback, oldminor = LibStub:NewLibrary(LIB_NAME, VERSION)
if not LibFeedback then return end

local function SendNote(self)
	local p = self.parent
	if type(self.amount)=="string" then
		RequestOpenUnsafeURL(self.amount)
	else
		p.parentControl:SetHidden(true)
		SCENE_MANAGER:Show('mailSend')
		zo_callLater(function()
		ZO_MailSendToField:SetText(p.mailDestination)
		ZO_MailSendSubjectField:SetText(p.parentAddonName)
		QueueMoneyAttachment(self.amount)
		ZO_MailSendBodyField:TakeFocus() end, 200)
	end
end

local function createFeedbackButton(name, owningWindow)
	local button = WINDOW_MANAGER:CreateControlFromVirtual(name, owningWindow, "ZO_DefaultButton")
	local b = button
	b:SetDimensions(150, 28)
	b:SetHandler("OnClicked",function()SendNote(b) end)
	b:SetAnchor(BOTTOMLEFT,owningWindow, BOTTOMLEFT,5,5)
	return button
end

local function createShowFeedbackWindow(owningWindow)
	local showButton = WINDOW_MANAGER:CreateControl(owningWindow:GetName().."ShowFeedbackWindowButton", owningWindow, CT_BUTTON)
	local b = showButton
	b:SetDimensions(34, 34)
	b:SetNormalTexture("ESOUI/art/chatwindow/chat_mail_up.dds")
	b:SetMouseOverTexture("ESOUI/art/chatwindow/chat_mail_over.dds")
	b:SetHandler("OnClicked", function(self) self.feedbackWindow:ToggleHidden() end )
	return showButton
end

local function createFeedbackWindow(owningWindow, messageText)
	local feedbackWindow = WINDOW_MANAGER:CreateTopLevelWindow(owningWindow:GetName().."FeedbackWindow")
	local c = feedbackWindow
	c:SetDimensions(545, 150)
	c:SetMouseEnabled(true)
	c:SetClampedToScreen(true)
	c:SetMovable(true)

	WINDOW_MANAGER:CreateControlFromVirtual(c:GetName().."BG", c, "ZO_DefaultBackdrop"):SetAnchorFill(c)
	local l = WINDOW_MANAGER:CreateControl(c:GetName().."Label", c, CT_LABEL)
	l:SetFont("ZoFontGame")
	l:SetAnchor(TOP, c,TOP0, 0, 5)
	l:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
	l:SetColor(0.83, 0.76, 0.16)
	local b = WINDOW_MANAGER:CreateControl(c:GetName().."Close", c, CT_BUTTON)
	b:SetAnchor(CENTER, c,TOPRIGHT, -20, 20)
	b:SetDimensions(48, 48)
	b:SetNormalTexture("/esoui/art/hud/radialicon_cancel_up.dds")
	b:SetMouseOverTexture("/esoui/art/hud/radialicon_cancel_over.dds")
	b:SetHandler("OnClicked", function(self) self:GetParent():SetHidden(true) end )
	local n = WINDOW_MANAGER:CreateControl(c:GetName().."Note", c, CT_LABEL)
	n:SetText(messageText)
	n:SetDimensions(525, 200)
	n:SetAnchor(TOPLEFT, c, TOPLEFT, 10, 50)
	n:SetColor(1, 1, 1)
	n:SetFont("ZoFontGame")
	n:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
	return feedbackWindow
end

function LibFeedback:initializeFeedbackWindow(parentAddonNameSpace, parentAddonName, parentControl, mailDestination,  mailButtonPosition, buttonInfo,  messageText)

	local feedbackWindow = createFeedbackWindow(parentControl, messageText)

	parentAddonNameSpace.feedbackWindow = feedbackWindow
	feedbackWindow.parentControl = parentControl
	feedbackWindow.mailDestination = mailDestination
	feedbackWindow.parentAddonName = parentAddonName

	feedbackWindow:SetAnchor(TOPLEFT,parentControl, TOPLEFT, 0,0)
	feedbackWindow:SetHidden(true)

	feedbackWindow:SetDimensions(math.max(#buttonInfo*150, 600) , 150)
	feedbackWindow:GetNamedChild("Label"):SetText(parentAddonName)

	local buttons = {}
	for i = 1, #buttonInfo do

		buttons[#buttons+1] =  createFeedbackButton(feedbackWindow:GetName().."Button"..#buttons, feedbackWindow)
		buttons[i]:SetAnchor(BOTTOM,feedbackWindow, BOTTOMLEFT, (i-1)*150+70,-10)
		buttons[i].amount = buttonInfo[i]
		buttons[i].SendNote = SendNote
		buttons[i].parent = feedbackWindow

		if buttonInfo[i] == 0 then
			buttons[i]:SetText("Send Note")
		elseif type(buttonInfo[i] )=="string" then
			buttons[i]:SetText("Send $$")
		else
			buttons[i]:SetText("Send "..tostring(buttonInfo[i]).." gold")
		end
	end
	local showButton = createShowFeedbackWindow(parentControl)

	showButton.feedbackWindow = feedbackWindow
	showButton:SetAnchor(unpack(mailButtonPosition))
	showButton:SetDimensions(40,40)

	return showButton, feedbackWindow
end
