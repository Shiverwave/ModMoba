----------------------------------------------------------------------------------------------------------------------------------
-- File:          OVR_incl_stat_gain.lua
-- Author:        DjOli (Adam Britto)
-- Description:   Ensures combat stats aren't gained from PVP combat when fighting non-lethally.
----------------------------------------------------------------------------------------------------------------------------------

local default_CanGainStat = CanGainStat

function CanGainStat(targMob, statName)
  if (this:IsPlayer() and this:HasObjVar("CurrentTarget") and this:GetObjVar("CurrentTarget"):IsPlayer() and this:GetBaseStatValue(statName) >= 20) then
    if (this:GetObjVar(PALVAR_LETHALITY_MODE) == PALVAR_LETHALITY_MODE_SPARRING or this:GetObjVar("CurrentTarget"):GetObjVar(PALVAR_LETHALITY_MODE) == PALVAR_LETHALITY_MODE_SPARRING or 
        (this:GetObjVar(PALVAR_LETHALITY_MODE) == PALVAR_LETHALITY_MODE_RETALIATING and this:GetObjVar("CurrentTarget"):GetObjVar(PALVAR_LETHALITY_MODE) == PALVAR_LETHALITY_MODE_RETALIATING)) then
      return false
    end
  end

  -- If we made it this far, continue with the regular stat gain check.
  return default_CanGainStat(targMob, statName)
end