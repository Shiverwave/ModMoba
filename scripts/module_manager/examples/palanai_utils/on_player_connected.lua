----------------------------------------------------------------------------------------------------------------------------------
-- File:          scheduled_event_handler_global.lua
-- Author:        DjOli (Adam Britto)
-- Description:   Notifies listeners on player connected.
----------------------------------------------------------------------------------------------------------------------------------

-- Notifies anything listening to the PALMSG_ON_CONNECT to update systems on reconnect.
function NotifyOnPlayerConnected()
  -- Schedule a timer to notify systems to update for on player connection.
  this:ScheduleTimerDelay(TimeSpan.FromSeconds(1), PALMSG_ON_CONNECT)
  -- To register for this event, just use the following line. The final argument will be the method name being called.
  -- RegisterEventHandler(EventType.Timer,PALMSG_ON_CONNECT, OnPlayerConnected)
end

-- We call this so when the player script is processed it will be fired.
NotifyOnPlayerConnected()