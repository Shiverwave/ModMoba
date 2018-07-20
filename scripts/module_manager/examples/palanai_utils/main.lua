----------------------------------------------------------------------------------------------------------------------------------
-- File:          main.lua
-- Author:        DjOli (Adam Britto)
-- Description:   Main for the palanai tools project.
----------------------------------------------------------------------------------------------------------------------------------

function init(modLoader)
    modLoader:load({
        details = {
            name = "Palanai Utils",
            description = "A number of utility functions from the Palanai server",
            author = "DjOli",
            version = 1.0,
        },
        
        dependencies = {
        },
        
        constants = {
            PALVAR_DELAYED_EVENTS = "Palanai_DelayedEvents",
            PALMSG_DELAYED_TIMER_EVENT_PREFIX = "Palanai_DelayedTimerEvent_",
            PALMSG_ON_CONNECT = "Palanai_OnPlayerConnect"
        
        },
        
        playerScripts = {
            "scheduled_event_handler_player",
            "on_player_connected",
        },
        
        globalScripts = {
            "scheduled_event_handler_global",
            "objvar_utils",
            "messaging_utils",
        
        },
        
        overrideScripts = {
        }
    })
end
