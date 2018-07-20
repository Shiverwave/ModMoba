----------------------------------------------------------------------------------------------------------------------------------
-- File:          OVR_base_skill_sys.lua
-- Author:        DjOli (Adam Britto)
-- Description:   Modifies the following from base:
--                  - Ensures skill XP isn't gained when skill level is 20 or greater and pvp lethality is non-lethal.
--                  - Ensures skill XP isn't gained when in spirit form.
----------------------------------------------------------------------------------------------------------------------------------

-- Constants
local VANILLA_TARGET_OBJVAR = "CurrentTarget"

-- Stored vanilla functions.
local default_SetCurXpLevel = SetCurXpLevel

-- Override to block skill gain while dead and sparring above level 20.
function SetCurXpLevel(targMob, skillName, newXp)
  if (IsSpirit(this)) then
    return
  end

  if(this:IsPlayer() and this:HasObjVar(VANILLA_TARGET_OBJVAR) and this:GetObjVar(VANILLA_TARGET_OBJVAR):IsPlayer() and this:GetSkillLevel(skillName) >= 20) then
    if (this:GetObjVar(PALVAR_LETHALITY_MODE) == PALVAR_LETHALITY_MODE_SPARRING or this:GetObjVar(VANILLA_TARGET_OBJVAR):GetObjVar(PALVAR_LETHALITY_MODE) == PALVAR_LETHALITY_MODE_SPARRING or 
        (this:GetObjVar(PALVAR_LETHALITY_MODE) == PALVAR_LETHALITY_MODE_RETALIATING and this:GetObjVar(VANILLA_TARGET_OBJVAR):GetObjVar(PALVAR_LETHALITY_MODE) == PALVAR_LETHALITY_MODE_RETALIATING)) then
      return
    end
  end

  -- If we made it this far, continue with regular XP gain.
  default_SetCurXpLevel(targMob, skillName, newXp)
end