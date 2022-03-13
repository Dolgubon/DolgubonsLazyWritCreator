local hirelingMailSubjects = WritCreater.hirelingMailSubjects

local hirelingMails = 
{}

local currentWorkingMail
local function lootMails()
	if #hirelingMails == 0 then
		-- CloseMailbox()
		d("Writ Crafter: Mail Looting complete")
		return
	else
		local mailId = hirelingMails[1]
		-- d(mailId)
		currentWorkingMail = mailId
		requestResult = RequestReadMail(mailId)
		if requestResult and requestResult <= REQUEST_READ_MAIL_RESULT_SUCCESS_SERVER_REQUESTED then
		end
		zo_callLater(function()

				if currentWorkingMail == mailId and not IsReadMailInfoReady(mailId) then
					RequestReadMail(mailId)
				end 
			end, 100)
	end
end

local function  findLootableMails()
	if not WritCreater:GetSettings().mail.loot then
		return
	end
	hirelingMails = {}
	local nextMail = GetNextMailId(nil)
	if not nextMail then
	 	-- CloseMailbox()
	 	-- d("No mails found")
	 	EVENT_MANAGER:UnregisterForEvent(WritCreater.name.."mailbox", EVENT_MAIL_READABLE)
	 	return
	end
	
	while nextMail do
		local  _,_,subject, _,_,system,customer, _, numAtt, money = GetMailItemInfo (nextMail)
		if not customer and money == 0 and system and hirelingMailSubjects[subject] then
			if WritCreater:GetSettings().mail.delete or numAtt > 0 then
			-- if #hirelingMails < 3 then
				-- hirelingMails[nextMail] = true
				table.insert(hirelingMails,  nextMail)
			end
			-- end
			-- DeleteMail(mailId, true)
		end
		nextMail = GetNextMailId(nextMail)
	end

	if #hirelingMails > 0 then
		d("Writ Crafter: "..#hirelingMails.. " hireling mails found")
		zo_callLater(lootMails, 10)
	else
		EVENT_MANAGER:UnregisterForEvent(WritCreater.name.."mailbox", EVENT_MAIL_READABLE)
		-- d("No hireling mails found")
	end
end
local lootReadMail
local function deleteLootedMail(mailId)
	local  _,_,subject, _,_,system,customer, _, numAtt, money = GetMailItemInfo(mailId)
	if numAtt > 0 and FindFirstEmptySlotInBag() then
		-- d("Tried deleting but still attachments")
		lootReadMail(1, mailId)
		return
	end
	if WritCreater:GetSettings().mail.delete then
		DeleteMail(mailId, true)
	end
	if hirelingMails[1] == mailId then
		table.remove(hirelingMails, 1)
		zo_callLater(lootMails, 250)
	end
	-- table.remove(hirelingMails, mailId)
	shouldBeRemoved = mailId
	-- zo_callLater(lootMails, 40)
end


function lootReadMail(event, mailId)
	if not IsReadMailInfoReady(mailId) then
		-- d("Stop")
		zo_callLater(function() lootMails() end , 10 )
		return
	end
	local  _,_,subject, _,_,system,customer, _, numAtt, money = GetMailItemInfo(mailId)
	if not customer and money == 0 and system and hirelingMailSubjects[subject] then
		if numAtt > 0 and FindFirstEmptySlotInBag() then
			-- d("Writ Crafter: Looting "..subject)
			ZO_MailInboxShared_TakeAll(mailId)
			zo_callLater(function() deleteLootedMail(mailId) end, 250)
			return
		elseif FindFirstEmptySlotInBag() == nil and numAtt > 0 then
			return
		else
			-- d("Mail empty. Delete it")
			deleteLootedMail(mailId)
			return
		end
	end
end


function WritCreater.lootHireling(event)
	-- d("BEGIN the bugs!")
	EVENT_MANAGER:RegisterForEvent(WritCreater.name.."mailbox",EVENT_MAIL_REMOVED, function(event, mailId)if hirelingMails[1] == mailId then
		table.remove(hirelingMails, 1)
		if #hirelingMails == 0 then
			-- d("COMPLETETIONS")
		else
			lootMails()
		end
	end
	end)
	EVENT_MANAGER:RegisterForEvent(WritCreater.name.."mailbox",EVENT_MAIL_TAKE_ATTACHED_ITEM_SUCCESS, function(event, mailId) 
		local toremove
		for k, v in pairs(hirelingMails) do 
			if v == mailId then 
				local _,_,sub = GetMailItemInfo(mailId)
				-- d("Writ Crafter: "..sub.." looted")
				if not WritCreater:GetSettings().mail.delete then
					toremove = k
				end
			end 
		end 
		if toremove then
			table.remove(hirelingMails, k)
		end
	end )
	-- EVENT_MANAGER:RegisterForEvent(WritCreater.name.."mailbox", EVENT_MAIL_OPEN_MAILBOX, 
	-- 	function ()
	-- 	EVENT_MANAGER:UnregisterForEvent(WritCreater.name.."mailbox", EVENT_MAIL_OPEN_MAILBOX)
	-- 		zo_callLater(function ()
	-- 			findLootableMails()
	-- 		end, 10)
	-- 	end)
	if WritCreater:GetSettings().mail.loot then
		findLootableMails()
		EVENT_MANAGER:RegisterForEvent(WritCreater.name.."mailbox", EVENT_MAIL_READABLE, lootReadMail)
	end
end
EVENT_MANAGER:RegisterForEvent(WritCreater.name.."mailbox",EVENT_MAIL_OPEN_MAILBOX , function() WritCreater.lootHireling() end)

function WritCreater.triggerMailLooting()
	CloseMailbox()
	RequestOpenMailbox()
end

SLASH_COMMANDS['/testmail'] = WritCreater.triggerMailLooting
--EVENT_MAIL_INBOX_UPDATE

