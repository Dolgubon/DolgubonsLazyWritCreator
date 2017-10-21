local MAJOR, MINOR = "LibMOTD", 1.003
local LibMOTD, oldminor = LibStub:NewLibrary(MAJOR, MINOR)
if not LibMOTD then return end -- the same or newer version of this lib is already loaded into memory

function LibMOTD:setMessage(savedVariablesAccount, message, numMaxChars)
  if not numMaxChars then numMaxChars = 1 end
  local savedVariables = ZO_SavedVars:NewAccountWide(savedVariablesAccount, 2, 'LibMOTD', {messages = {}})
  
  local doAddMessage = true
  if savedVariables.messages[#savedVariables.messages] then
    if savedVariables.messages[#savedVariables.messages].message == message then
      doAddMessage = false    
    end
  end
  
  if (doAddMessage) then
    table.insert(savedVariables.messages, {message=message,chars={},numMaxChars = numMaxChars})
  end 
  
  EVENT_MANAGER:RegisterForEvent("LibMOTD"..math.random(999999), EVENT_PLAYER_ACTIVATED, function() 
    if savedVariables.messages[#savedVariables.messages].chars[GetCurrentCharacterId()] then return end
    
    if savedVariables.messages[#savedVariables.messages].numMaxChars then
      if savedVariables.messages[#savedVariables.messages].numMaxChars > 0 then
        local countChars = 0
        for k,v in pairs(savedVariables.messages[#savedVariables.messages].chars) do
          countChars = countChars + 1
        end
        
        if countChars >= savedVariables.messages[#savedVariables.messages].numMaxChars then
          return end
      end
    end
    
    _G.d(savedVariables.messages[#savedVariables.messages].message)
    savedVariables.messages[#savedVariables.messages].chars[GetCurrentCharacterId()] = true
  end)
end