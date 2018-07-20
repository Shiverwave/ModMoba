----------------------------------------------------------------------------------------------------------------------------------
-- File:          scheduled_event_handler_player.lua
-- Author:        DjOli (Adam Britto)
-- Description:   Adds support for scheduled events which fire even after character log out.
----------------------------------------------------------------------------------------------------------------------------------

-- Checks any scheduled events. If they need firing, they will be fired immediately, otherwise they will be scheduled again.
function CheckScheduledEvents()
  if (this:HasObjVar(PALVAR_DELAYED_EVENTS)) then
    local delayedEvents = this:GetObjVar(PALVAR_DELAYED_EVENTS)
    local timeSecondsNow = ServerTimeSecs()
    for timeToFire, messageToFire in pairs(delayedEvents) do
      if (timeSecondsNow > timeToFire) then
        FireScheduledEvent(this, messageToFire, timeToFire)
      else
        RegisterTimedEvent(this, messageToFire, timeToFire)
      end
    end
  else
    local emptyTable = {}
    this:SetObjVar(PALVAR_DELAYED_EVENTS, emptyTable)
  end
end

-- We call this so when the player script is processed it will be fired.
CheckScheduledEvents()