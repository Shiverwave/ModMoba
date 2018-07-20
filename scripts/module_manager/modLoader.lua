--------------------------------------------------------------------------------------------------------------------------------
-- File:          mods/palanai/scripts/mod_manager/modLoader.lua
-- Author:        DjOli (Adam Britto)
-- Type:          New
-- Date:          28/06/16
-- Description:   Provides functionality to mods to load themselves.
----------------------------------------------------------------------------------------------------------------------------------
ModLoader = {}
ModLoader.__index = ModLoader

setmetatable(ModLoader, {
    __call = function(cls, ...)
        return cls.new(...)
    end,
})

-- Constructor.
function ModLoader.new(modManager, fileUtils, dir)
    local self = setmetatable({}, ModLoader)
    self.dir = dir
    self.modManager = modManager
    self.fileUtils = fileUtils
    return self
end

function ModLoader:load(mod)
    print("Loading " .. mod.details.name)
    if (self.modManager:dependenciesLoaded(mod.dependencies)) then
        self.modManager:initializeConstants(mod.details.name, mod.constants)
        self.fileUtils:initializeGlobalMods(self:asNormal(mod.globalScripts))
        self.fileUtils:initializeOverrideMods(self:asOverride(mod.overrideScripts))
        self.fileUtils:initializePlayerMods(self:asNormal(mod.playerScripts))
        self.modManager:onModLoaded(mod.details)
    else
        print("Module loading failed.")
        print("Server shutting down.")
        os.execute("pause")
        os.exit()
    end
end

function ModLoader:asNormal(original)
    local scripts = {}
    local isOverrideScript = isOverride or false
    for i, script in pairs(original) do
        table.insert(scripts, self.dir .. "." .. script)
    end
    return scripts
end

function ModLoader:asOverride(original)
    local scripts = {}
    local isOverrideScript = isOverride or false
    for i, script in pairs(original) do
        local ovr = {vanilla = script.vanilla, override = self.dir .. "." .. script.override, excludeVanilla = script.excludeVanilla or false}
        table.insert(scripts, ovr)
    end
    return scripts
end