----------------------------------------------------------------------------------------------------------------------------------
-- File:          mods/palanai/scripts/ca_pvpLethality_script.lua
-- Author:        DjOli (Adam Britto)
-- Type:          New
-- Date:          12/01/16
-- Description:   Mechanics for the Toggle PVP Lethality ability.
----------------------------------------------------------------------------------------------------------------------------------


-- Performs checks to see if the ability can be activated. Toggles the PVP lethality mode or notifies the user if the mode can't be toggled.
function ActivateAbility()
  if(this:IsPlayer()) then
    this:SendMessage(PALMSG_LETHALITY_ABILITY_ACTIVATED)
  end
end

RegisterEventHandler(EventType.Message, "ca_pvp_lethality_toggle_init", ActivateAbility)
