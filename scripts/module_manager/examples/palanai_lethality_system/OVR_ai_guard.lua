----------------------------------------------------------------------------------------------------------------------------------
-- File:          OVR_ai_guard.lua
-- Author:        DjOli (Adam Britto)
-- Description:   Notifies GM when a guard is handling a help request between players.
----------------------------------------------------------------------------------------------------------------------------------

local default_HandleRequestHelp = HandleRequestHelp

-- Mod which adds notification of GMs when a guard is fining a player for PVP. Event handler is overridden to call this method first.
function HandleRequestHelp(attacker,crimeIndex,victim)
  if (attacker:IsPlayer() and victim:IsPlayer()) then
    GMBroadcast("[-][08FFFF]" .. attacker:GetName() .. "[-][F7CC0A] is picking a fight with [-][08FFFF]" .. victim:GetName() .. "[-][F7CC0A].")
  end

  -- Be sure to call the original method.
  default_HandleRequestHelp(attacker, crimeIndex, victim)
end