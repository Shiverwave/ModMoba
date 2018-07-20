----------------------------------------------------------------------------------------------------------------------------------
-- File:          messaging.lua
-- Author:        DjOli (Adam Britto)
-- Description:   Messaging utilities.
----------------------------------------------------------------------------------------------------------------------------------

function GMBroadcast(message,isEvent)
  local loggedOnUsers = FindObjects(SearchUser(),GameObj(0))

  if( isEvent == nil ) then
    isEvent = false
  end

  for index,object in pairs(loggedOnUsers) do
    if (object:IsGod() or object:IsDemiGod()) then
      if( isEvent ) then
        object:SystemMessage(message,"event")
      else
        object:SystemMessage(message)
      end
    end
  end
end

-- Sends a message to all users currently logged on.
function ServerMessage(source, message)
  local loggedOnUsers = FindObjects(SearchUser(),GameObj(0))
  for index,object in pairs(loggedOnUsers) do
    object:SendMessage(message, source)
  end
end