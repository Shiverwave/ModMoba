----------------------------------------------------------------------------------------------------------------------------------
-- File:          mods/palanai/scripts/palanai_lethality_system/OVR_base_mobile.lua
-- Author:        DjOli (Adam Britto)
-- Type:          Override
-- Date:          21/06/16
-- Description:   Adds non-lethal death, blocks default death if non-lethal occurs.
----------------------------------------------------------------------------------------------------------------------------------

-- Store vanilla methods.
local vanilla_HandleApplyDamage = HandleApplyDamage

-- Constants.
local NON_LETHAL_DEATH_RESET_TIMER = "NonLethalDeathReset"
local NON_LETHAL_DIALOG_TIMER_EVENT = "NonLethalDeathDialogShow"

-- Override to perform PVP checking when player is about to die.
function HandleApplyDamage(damager, procDam, isCrit)
  if (this:IsPlayer() and WillCauseNonLethalDeath(damager, procDam)) then
    DebugMessage("Causing non-lethal death")
    PerformNonLethalDeath(damager)
    return
  end
  vanilla_HandleApplyDamage(damager, procDam, isCrit)
end

-- Check to see if this is a non-lethal death. 
-- Returns true if it is, otherwise false for a normal death.
function WillCauseNonLethalDeath(damager, procDam)
  if (IsDead(this) or this:HasObjVar("Invulnerable") or damager:IsImmortal()) then
    return false
  end

  local curHealth = this:GetCurHealth()
  local newHealth = curHealth - procDam

  if (newHealth > 0) then
    return false
  end

  local damagerLethality = nil
  if (this:IsPlayer() and damager:IsPlayer()) then
    damagerLethality = damager:GetObjVar(PALVAR_LETHALITY_MODE)

    if (damagerLethality == PALVAR_LETHALITY_MODE_RETALIATING) then
      damagerLethality = this:GetObjVar(PALVAR_LETHALITY_MODE)
    end

    if (damagerLethality == PALVAR_LETHALITY_MODE_RETALIATING) then
      damagerLethality = PALVAR_LETHALITY_MODE_SPARRING
    end
  end

  if (damagerLethality and damagerLethality == PALVAR_LETHALITY_MODE_SPARRING) then
    return true
  end

  return false
end

-- Handles death during non-lethal PVP.
function PerformNonLethalDeath(damager)
  damager:SystemMessage("[0AB4F7] You have knocked out [-][F70A79]" .. this:GetName(), "event")
  this:SendMessage("HasDiedMessage", damager)

  HandleRemoveAllFreezesTimer()
  this:PlayObjectSound("Death", true)
  this:SetSharedObjectProperty("IsDead", true)
  this:PlayAnimation("die")
  this:StopMoving()
  this:SetMobileFrozen(true,true)
  mMoveSpeedEffects = {}
  this:DelObjVar("MoveSpeedEffects")
  ClearMoveSpeedEffects()
  ClearInvisibilityEffects()

  local currentHealthRegen = this:GetStatRegenRate("Health")
  local currentStaminaRegen = this:GetStatRegenRate("Stamina")
  local currentManaRegen = this:GetStatRegenRate("Mana")

  this:SetStatRegenRate("Health", 0)
  this:SetStatRegenRate("Stamina", 0)
  this:SetStatRegenRate("Mana", 0)
  
  this:ScheduleTimerDelay(TimeSpan.FromSeconds(60), NON_LETHAL_DEATH_RESET_TIMER, currentHealthRegen, currentStaminaRegen, currentManaRegen)
  this:ScheduleTimerDelay(TimeSpan.FromSeconds(1), NON_LETHAL_DIALOG_TIMER_EVENT, damager)
end

-- Handles reset of non-lethal death.
function PerformNonLethalDeathReset(healthRegenRage, staminaRegenRage, manaRegenRate)
  this:SetMobileFrozen(false, false)
  this:SetSharedObjectProperty("IsDead", false)
  this:SetStatRegenRate("Health", healthRegenRage)
  this:SetStatRegenRate("Stamina", staminaRegenRage)
  this:SetStatRegenRate("Mana", manaRegenRate)
end

-- Shows the non lethal death dialog.
function ShowNonLethalDeathDialog(damager)
  local remainingTime = this:GetTimerDelay(NON_LETHAL_DEATH_RESET_TIMER)
  if(remainingTime == nil) then
    remainingTime = 0
  else
    remainingTime = tonumber(remainingTime:ToString("%s"))
  end
  local id = "nonLethalDeathDialog"
  if (remainingTime > 0) then
    local title = "Defeat"
    local text1 = damager:GetName() .. " has knocked you unconscious in battle."
    local text2 = "You will regain consciousness in " .. tostring(remainingTime) .. " seconds."

    local newWindow = DynamicWindow(id, title,700,135,200,200,"NoFrame","Top")
    newWindow:AddLabel(350, 10, text1, 600,60,30,"center")
    newWindow:AddLabel(350, 50, text2, 600,60,30,"center")
    this:OpenDynamicWindow(newWindow)
    this:ScheduleTimerDelay(TimeSpan.FromSeconds(1), NON_LETHAL_DIALOG_TIMER_EVENT, damager)
  else
    this:CloseDynamicWindow(id)
  end
end

-- Register for messages.
RegisterEventHandler(EventType.Timer, NON_LETHAL_DEATH_RESET_TIMER, PerformNonLethalDeathReset)
RegisterEventHandler(EventType.Timer, NON_LETHAL_DIALOG_TIMER_EVENT, ShowNonLethalDeathDialog)
--OverrideEventHandler("default:base_mobile", EventType.Message, "DamageInflicted", HandleApplyDamage)  



    