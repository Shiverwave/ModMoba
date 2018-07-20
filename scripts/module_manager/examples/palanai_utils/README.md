The palanai_utils mod contains utilities used by various other Palanai mods. Its functionality can be used in other mods.

### messaging_utils.lua
Adds various global messaging utilities.

### objvar_utils.lua
Provides a means of initializing an object variable. Useful to use for initializing mods as it can be used on a start up/load and not affect the object variable after the initialization.

### on_player_connected.lua
Player function which sends the message constant PALMSG_ON_CONNECT (see main.lua) after 1 second, allowing mods to listen in on the message as a means of initializing player functionality.

### scheduled_event_handler_global.lua and scheduled_event_handler_player.lua
Provides functionality to schedule events to occur on players, even after logout or restart.