---------------------------------------------------------------------------------------------------------------------------------
-- File:          mods/palanai/scripts/palanai_lethality_system/main.lua
-- Author:        DjOli (Adam Britto)
-- Type:          New
-- Date:          21/06/16
-- Description:   Entry point for the lethality system global scripts.
----------------------------------------------------------------------------------------------------------------------------------
function init(modLoader)
    modLoader:load({
        details = {
            name = "Palanai Leathality System",
            description = "Adds a number of stances for pvp lethality",
            author = "DjOli",
            version = 1.0,
        },
        
        dependencies = {
        },
        
        constants = {
            PALVAR_LETHALITY_MODE = "Palanai_LethalityMode",
            PALVAR_LETHALITY_MODE_DEADLY = "Palanai_LethalityModeDeadly",
            PALVAR_LETHALITY_MODE_SPARRING = "Palanai_LethalityModeSparring",
            PALVAR_LETHALITY_MODE_RETALIATING = "Palanai_LethalityModeRetaliating",
            PALMSG_LETHALITY_ABILITY_ACTIVATED = "Palanai_LethalityAbilityActivated",
            PALMSG_LETHALITY_COMBAT_STATE_CHANGED = "Palanai_LethalityCombatStateChanged",
            PALMSG_LETHALITY_STATE_CHANGED = "Palanai_LethalityStateChanged",
            PALMSG_LETHALITY_UDATE_IN_GUARD_PROTECTION = "Palanai_UpdateIsInGuardProtection",
        
        },
        
        playerScripts = {
            "lethality_system",
        },
        
        globalScripts = {
        },
        
        overrideScripts = {
            {vanilla = "ai_guard", override = "OVR_ai_guard"},
            {vanilla = "base_mobile", override = "OVR_base_mobile"},
            {vanilla = "base_skill_sys", override = "OVR_base_skill_sys"},
            {vanilla = "globals.static_data.combat_abilities", override = "OVR_combat_abilities"},
            {vanilla = "incl_stat_gain", override = "OVR_incl_stat_gain"},
            {vanilla = "guard_protect", override = "OVR_guard_protect"},
        }
    })
end
