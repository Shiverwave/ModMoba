----------------------------------------------------------------------------------------------------------------------------------
-- File:          main.lua
-- Author:        DjOli (Adam Britto)
-- Type:          New
-- Date:          23/9/16
-- Description:   Entry point for the buff replacer mod.
----------------------------------------------------------------------------------------------------------------------------------
function init(modLoader)
    modLoader:load({
        details = {
            name = "Buff Replacer",
            description = "Improvement to the Shards Online buff mechanic that allows buffs to be replaced, rather than removed and then added.",
            author = "DjOli",
            version = 1.0,
        },
        
        dependencies = {
        },
        
        constants = {
        
        },
        
        playerScripts = {
        },
        
        globalScripts = {
        
        },
        
        overrideScripts = {
            {vanilla = "base_player_buff_debuff", override = "OVR_base_player_buff_debuff"},
        }
    })
end
