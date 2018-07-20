----------------------------------------------------------------------------------------------------------------------------------
-- File:          scheduled_event_handler_global.lua
-- Author:        DjOli (Adam Britto)
-- Description:   Adds support for scheduled events which fire even after character log out.
----------------------------------------------------------------------------------------------------------------------------------

require 'incl_gametime'

-- Schedules a delayed event which will be fired after the specified delay. 
-- Returns the name of the scheduled event.
function ScheduleDelayedEvent(target, delaySeconds, messageToFire)
  local delayedEvents = target:GetObjVar(PALVAR_DELAYED_EVENTS)
  local timeToFire = ServerTimeSecs() + delaySeconds

  -- Ensure we are adding an event at a unique time to fire. A few seconds won't make much difference.
  while (delayedEvents[timeToFire] ~= nil) do
    timeToFire = timeToFire + 1
  end

  -- Add the event to the delayed events table
  delayedEvents[timeToFire] = messageToFire
  target:SetObjVar(PALVAR_DELAYED_EVENTS, delayedEvents)
  -- Request the event be fired. This method will schedule the event to fire and be removed from the delayed events table.
  return RegisterTimedEvent(target, messageToFire, timeToFire)
end

-- Fires a scheduled event and removes it from the list of scheduled events.
function FireScheduledEvent(target, message, timeToFire)
  local delayedEvents = target:GetObjVar(PALVAR_DELAYED_EVENTS)
  target:SendMessage(message)
  delayedEvents[timeToFire] = nil
  target:SetObjVar(PALVAR_DELAYED_EVENTS, delayedEvents)
end

-- Registers a timed event to be fired on the target.
function RegisterTimedEvent(target, messageToFire, timeToFire)
  local timeSecondsNow = ServerTimeSecs()
  local timeRemaining = timeToFire - timeSecondsNow
  local timerEventName = PALMSG_DELAYED_TIMER_EVENT_PREFIX .. messageToFire
  RegisterEventHandler(EventType.Timer, timerEventName, FireScheduledEvent)
  if (timeRemaining > 0) then
    target:ScheduleTimerDelay(TimeSpan.FromSeconds(timeRemaining), timerEventName, target, messageToFire, timeToFire)
  else
    target:ScheduleTimerDelay(TimeSpan.FromMilliseconds(100), timerEventName, target, messageToFire, timeToFire)
  end
  return timerEventName
end