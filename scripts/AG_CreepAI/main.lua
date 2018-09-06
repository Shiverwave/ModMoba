-- Constants
-- Add your mod constants here. Use unique names by prefixing the name of the mod.
-- This function is required by the module manager.
function init(modLoader)
    modLoader:load({
        details = {
            name = "AG_CreepAI",
            description = "AI for creeps and guards in the MOBA",
            author = "Adam Godwin & Bryce Benham",
            version = 0.1,
        },
        
        dependencies = {
          -- {name = "Other Module"},
        },
        
        constants = {
          -- CONSTANT = "constant"
        },
        
        playerScripts = {

        },
        
        globalScripts = {
			
        },
        
        overrideScripts = {
			--{vanilla = "globals.static_data.equipmentstats", override = "DOTS_equipmentstats"},
			--{vanilla = "globals.static_data.weapon_abilities.weapons", override = "DOTS_weapons"},
			--{vanilla = "globals.static_data.spells", override = "DOTS_spells"},
        }
    })
end
