----------------------------------------------------------------------------------------------------------------------------------
-- File:          OVR_data_combat_abilities.lua
-- Author:        DjOli (Adam Britto)
-- Description:   Adds PvpStance ability.
----------------------------------------------------------------------------------------------------------------------------------

AbilityData.AllAbilities.PvpStance = {
  DisplayName = "PVP Stance Toggle",
  TooltipString = "Type: Instant\nToggles between the PVP stances.\n\n[00FF00]Sparring Stance\n[FFFFFF]Your PVP attacks will knock foes unconscious but not kill them.\n\n[FF0000]Deadly Stance\n[FFFFFF]Your PVP attacks will kill foes.\n\n[36ffff]Retaliating Stance\n[FFFFFF]You will retaliate with your opponents mode, or Sparring if they are also retaliating.",
  AbilityTriggertype = {
          Instant = true,
          Triggered = false
      },
  IsPeacefulAbility = true,
  AlwaysUsable = true,
  AbilityEnabled = true,
  CompletionDelay = 0,
  StaminaCost = 0,
  CooldownTimer = 0,
  isTargetRequired = false,
  combatAbilityScriptOnUser = "ca_pvp_lethality_toggle",
  Icon="Martial Arts 01",
  AssociatedSkill = "MeleeSkill", 
}