# Welcome to the Legends of Aria Module Manager Repository.

The Legends of Aria Module Manager was created to add support for modular modifications to a Legends of Aria mod. 

The system provides a framework for loading modules within sub-directories of a Legends of Aria mod. It functions best if all modifications for the mod are making use of the module manager.

## Installation

1. Clone this repository into the *scripts* directory within the required Legends of Aria mod.
> If using a git repository for your mod, it is useful to clone the Module Manager as a submodule. See [Git - Submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules) for more information.
2. Ensure you have overridden the globals/main.lua file
3. In your globals/main.lua file file, after `require 'default:globals.main'` file, add `require 'module_manager.main'`

## Creating a mod.

The Legends of Aria Module Manager makes use of some minor configuration files and a set of standards when creating mods. If the standards are followed and configuration files are set up correctly, your mod will be compatible with the Module Manager. Below is a brief description of how to create a mod.

1. Create a directory inside the *scripts* directory of your mod. Provide a unique name to avoid possible conflicts with other mods in the community.
2. Create *main.lua* within the newly created directory.
3. Add the following code to the file:

```
-- Constants
-- Add your mod constants here. Use unique names by prefixing the name of the mod.
-- This function is required by the module manager.
function init(modLoader)
    modLoader:load({
        details = {
            name = "Module Name",
            description = "Module Description",
            author = "Module Author",
            version = 1.0,
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
            {vanilla = "vanilla_script", override = "override_script"},
            {vanilla = "other_vanilla_script", override = "other_override_script", excludeVanilla = true},
        }
    })
end

```


4. Open the *scripts/module_manager/mods.lua* file, and add an entry in the *MODS* array for your new mod. The mod name should match the name of the directory created in step 1.

The code block above indicates how to make use of the Module Manager. The *init(modLoader)* function will be called when the server starts, and anything specified via one of the modLoader functions will be loaded. 

Mods are broken down into 3 possible script types.
- Global: Mods that are global to the server.
- Player: Mods that affect the player (are attached to the player via the vanilla player module.
- Override: Mods that override existing functionality.
*Note: For scripts overriding the main.lua and player.lua files, an Override mod should be created, rather than a Global or Player mod respectively.*

Global and Player mods are all straight forward to create. These mods can require whatever incl_ scripts that they need.

When creating an override mod, it is important to follow the outlined standards to ensure compatibility with other mods.
- Don't require the base game file. This will be handled by the module manager.
-- To exclude the base game file (for override scripts only), add the property 'excludeVanilla = true' to the definition for that script.
- When overriding functions...
-- Back up the vanilla function.
-- Call the vanilla function before or after your modification if viable/possible.
-- Document all changes to vanilla functions to ensure users of your mod are aware of what functions are overridden.
- Don't override any event handlers. 
-- To override a function called by a vanilla event handler, simply override the function.
-- To override an event handler with an inline function, use the convention 'OVReventHandlerKey' with eventHandlerKey being the key to the event handler.
-- To override an event handler without a key, use the convention 'NILOVReventType', with eventType being the type of event (e.g. NILOVRLoadedFromBackup)

Ensure all created scripts are registered in the init(modLoader) function in the main.lua script. 

Run the server and observe output for potential errors. If everything is correct, no errors will be displayed and various files will be generated which will route calls to your modded scripts.

## Installing a mod.

Mods are installed by dumping a mod directory inside the *scripts* directory of your server mod and adding an entry in the *scripts/module_manager/mods.lua* file.

## Mod Dependencies.

Mods can be set up to depend on other mods being loaded. These can be specified in the Dependencies table in main.lua of each mod. Versioning support for this is coming soon.

## Constants.

Mods can have scoped constants added which can then be referenced by the mod, or other mods if required. Simply add the constants to the main.lua file of each mod.
These constants can be referenced in code: `MMConst["Module Name"].CONSTANT`
Remember to try and prefix the content of the constant text to keep it unique. This will be improved in the future so specifying values for constants will not be required.

## Examples.

There are a number of examples in the examples folder which provide some insight into how a mod should be put together and how the module manager works. 

> While the examples should provide guidance, due to drastic changes to the Legends of Aria codebase, the example code may not actually work. Palanai will be releasing official versions of these systems during the latter half of 2018.

## Errors and improvements.

Email adam@teartek.com or clone the repository, apply the fix/improvement and raise a pull request.

## Credits.
Created by Adam Britto (DjOli). 

Special thanks to Yorlik.

## Updates

3rd May 2018 - Updated the main files for examples as they were out of date.