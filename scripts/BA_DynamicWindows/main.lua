-- Constants
-- Add your mod constants here. Use unique names by prefixing the name of the mod.
-- This function is required by the module manager.
function init(modLoader)
    modLoader:load({
        details = {
            name = "BA_DynamicWindows",
            description = "Various Windows",
            author = "Braith Anderson",
            version = 2.0,
        },

        dependencies = {
          -- {name = "Other Module"},
        },

        constants = {
          -- CONSTANT = "constant"
        },

        playerScripts = {
            "script"
        },

        globalScripts = {
            "script"
        },

        overrideScripts = {
			{vanilla = "globals.helpers.combat", override = "BA_combat"},
            {vanilla = "scriptcommands", override = "BA_scriptcommands"}
        }
    })
end
