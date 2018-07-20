----------------------------------------------------------------------------------------------------------------------------------
-- File:          OVR_combat.lua
-- Author:        DjOli (Adam Britto)
-- Description:   Fires a message when combat state has changed.
----------------------------------------------------------------------------------------------------------------------------------

local default_SetInCombat = SetInCombat

-- Mod which fires a message
function SetInCombat(inCombat)
  -- Only apply this mod if we're a player and our combat state is changing.
  if( this:IsPlayer() and mInCombatState ~= inCombat ) then
    this:SendMessage(PALMSG_LETHALITY_COMBAT_STATE_CHANGED, inCombat)
  end

  -- Call the base method.
  default_SetInCombat(inCombat)
end