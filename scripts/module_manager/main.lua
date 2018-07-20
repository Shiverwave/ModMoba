--------------------------------------------------------------------------------------------------------------------------------
-- File:          mods/palanai/scripts/mod_manager/main.lua
-- Author:        DjOli (Adam Britto)
-- Type:          New
-- Date:          21/06/16
-- Description:   Entry point for the module manager.
----------------------------------------------------------------------------------------------------------------------------------

print()
print("======= Module loading in progress =======")
print()

require 'module_manager.fileUtils'
require 'module_manager.modManager'

local fileUtils = FileUtils()
modManager = ModManager()

require 'module_manager.mods'
if (MODS == nil) then
  fileUtils.resetModsFile()
end

require 'module_manager.modLoader'

-- Initialize all the mods in order.
for i, modName in pairs(MODS) do
  local modMain = modName .. ".main"
  local modLoader = ModLoader(modManager, fileUtils, modName)
  require(modMain)
  init(modLoader)
end

require 'MODULE_MANAGER_requires_global'

fileUtils:initializePlayerMods({"module_manager.modList"})
MMConst = modManager:getConstants()

print()
print("======== Module loading complete! ========")
print()