-- Constants
-- Add your mod constants here. Use unique names by prefixing the name of the mod.
-- This function is required by the module manager.
function init(modLoader)
    modLoader:load({
        details = {
            name = "DOTS_WeaponsSpells",
            description = "New Weapons and Spells for the MOBA",
            author = "Dylan Baynes & Bryce Benham",
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
			{vanilla = "globals.static_data.equipmentstats", override = "DOTS_equipmentstats"},
			{vanilla = "globals.server_settings.player_interactions", override = "DOTSplayer"},
			--{vanilla = "globals.static_data.weapon_abilities.weapons", override = "DOTS_weapons"},
			--{vanilla = "globals.static_data.spells", override = "DOTS_spells"},
        }
    })
end
