----------------------------------------------------------------------------------------------------------------------------------
-- File:          init.lua
-- Author:        DjOli (Adam Britto)
-- Type:          New
-- Date:          23/9/16
-- Description:   Initializez the lethality system.
----------------------------------------------------------------------------------------------------------------------------------

local OUT_OF_COMBAT_TIME_REQ_SECS = 60
local OUT_OF_COMBAT_RESET_EVENT = "ResetRecentlyInCombat"

-- Fires when a player has connected
function OnPlayerConnected()
  InitializeObjVar(this, PALVAR_LETHALITY_MODE, PALVAR_LETHALITY_MODE_RETALIATING)
  UpdateLethalityIcon()
end

-- Updates the buff icon for the current lethality state
function UpdateLethalityIcon()
  local lethality = this:GetObjVar(PALVAR_LETHALITY_MODE)
  local title
  local icon
  local description

  if (lethality == PALVAR_LETHALITY_MODE_RETALIATING) then
    title = "Retaliating Stance"
    icon = "Martial Arts 03"
    description = "You will retaliate with how your opponent attacks you in PVP."
  elseif (lethality == PALVAR_LETHALITY_MODE_SPARRING) then
    title = "Sparring Stance"
    icon = "Martial Arts 02"
    description = "Your PVP attacks will knock foes unconscious but not kill them."
  else
    title = "Deadly Stance"
    icon = "Martial Arts 01"
    description = "Your PVP attacks will kill foes."
  end
  this:AddBuffIcon("PalanaiPVPLethality", title, icon, description, false)
end

-- Performs checks to see if the ability can be activated. Toggles the PVP lethality mode or notifies the user if the mode can't be toggled.
function ActivateAbility()
  if(this:IsPlayer()) then
    local inCombat = this:GetSharedObjectProperty("CombatMode")
    if (inCombat) then
      this:SystemMessage("[F7CC0A] You can't change your PVP stance during combat.")
    elseif (this:HasTimer(OUT_OF_COMBAT_RESET_EVENT)) then
      local timeUntilReset = this:GetTimerDelay(OUT_OF_COMBAT_RESET_EVENT)
      this:SystemMessage("[F7CC0A] You can't change your PVP stance for [-][08FFFF]" .. timeUntilReset:ToString("%s") .. "[-][F7CC0A] more seconds.")
    else
      ToggleMode()
    end
  end
end

-- Toggles to the next PVP lethality mode, broadcasting the new mode.
function ToggleMode()
  local currentMode = this:GetObjVar(PALVAR_LETHALITY_MODE)
  if (currentMode == PALVAR_LETHALITY_MODE_RETALIATING) then
    currentMode = PALVAR_LETHALITY_MODE_DEADLY
  elseif (currentMode == PALVAR_LETHALITY_MODE_DEADLY) then
    currentMode = PALVAR_LETHALITY_MODE_SPARRING
  else
    currentMode = PALVAR_LETHALITY_MODE_RETALIATING
  end
  this:NpcSpeech(ChangeModeStringValue(currentMode, true) .. " Stance","combat")
  this:SetObjVar(PALVAR_LETHALITY_MODE,currentMode)
  UpdateLethalityIcon()
end

-- Handles when combat state has changed.
function HandleCombatStateChanged(combatState)
  if (combatState == false) then
    if (this:HasTimer(OUT_OF_COMBAT_RESET_EVENT)) then
      this:RemoveTimer(OUT_OF_COMBAT_RESET_EVENT)
    end
    this:ScheduleTimerDelay(TimeSpan.FromSeconds(OUT_OF_COMBAT_TIME_REQ_SECS), OUT_OF_COMBAT_RESET_EVENT)
  end
end

-- Handles when guard protection state has changed.
function HandleUpdateIsInGuardProtection(inGuardProtection)
  if (this:IsPlayer()) then
    if (inGuardProtection == true) then
      this:SystemMessage(GetInGuardProtectionMessageText())
    else
      this:SystemMessage(GetOutOfGuardProtectionMessageText())
      if (this:GetObjVar(PALVAR_LETHALITY_MODE) == PALVAR_LETHALITY_MODE_SPARRING) then
        ToggleMode()
      end
    end
  end
end

-- Converts the current mode to the relevant output string. Use the includeColour flag to prefix the return value with the modes corresponding colour.
function ChangeModeStringValue(mode, includeColour)
  local newValue = ""
  if (mode == PALVAR_LETHALITY_MODE_RETALIATING) then
    if (includeColour == true) then
      newValue = "[0181f6]"
    end
    newValue = newValue .. "Retaliating"
  elseif (mode == PALVAR_LETHALITY_MODE_DEADLY) then
    if (includeColour == true) then
      newValue = "[b79901]"
    end
    newValue = newValue .. "Deadly"
  else
    if (includeColour == true) then
      newValue = "[6dd901]"
    end
    newValue = newValue .. "Sparring"
  end
  return newValue
end

-- Get the message text for entering guard protection based on your current PVP lethality mode.
function GetInGuardProtectionMessageText()
  local currentMode = this:GetObjVar(PALVAR_LETHALITY_MODE)
  local message = "[" .. ChangeModeStringValue(currentMode, true) .. " Stance[FFFFFF]] "
  if (currentMode == PALVAR_LETHALITY_MODE_RETALIATING) then
    message = message .. "Guards will intervene if your fighting gets out of hand."
  elseif (currentMode == PALVAR_LETHALITY_MODE_DEADLY) then
    message = message .. "Guards won't tolerate your aggression toward others."
  else
    message = message .. "Guards will generally stay out of friendly fights."
  end
  return message
end

-- Get the message text for leaving guard protection based on your current PVP lethality mode.
function GetOutOfGuardProtectionMessageText()
  local currentMode = this:GetObjVar(PALVAR_LETHALITY_MODE)
  local message = "[" .. ChangeModeStringValue(currentMode, true) .. " Stance[FFFFFF]] "
  if (currentMode == PALVAR_LETHALITY_MODE_RETALIATING) then
    message = message .. "You won't be taken advantage of in a fight."
  elseif (currentMode == PALVAR_LETHALITY_MODE_DEADLY) then
    message = message .. "Your aggression will turn the tide of battle."
  else
    message = message .. "Sparring will get you nowhere out here. You're better off [36ffff]Retaliating[FFFFFF]."
  end
  return message
end

-- Register event handlers
RegisterEventHandler(EventType.Message, PALMSG_LETHALITY_ABILITY_ACTIVATED, ActivateAbility)
RegisterEventHandler(EventType.Message, PALMSG_LETHALITY_COMBAT_STATE_CHANGED, HandleCombatStateChanged)
RegisterEventHandler(EventType.Message, PALMSG_LETHALITY_UDATE_IN_GUARD_PROTECTION, HandleUpdateIsInGuardProtection)
RegisterEventHandler(EventType.Timer, PALMSG_ON_CONNECT, OnPlayerConnected)