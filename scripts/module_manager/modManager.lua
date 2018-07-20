ModManager = {}
ModManager.__index = ModManager

setmetatable(ModManager, {
    __call = function(cls, ...)
        return cls.new(...)
    end,
})

-- Constructor.
function ModManager.new()
    local self = setmetatable({}, ModManager)
    self.loadedMods = {}
    self.constants = {}
    return self
end

function ModManager:onModLoaded(modDetails)
    table.insert(self.loadedMods, modDetails)
end

function ModManager:getLoadedMods()
    return self.loadedMods
end

function ModManager:initializeConstants(modName, constants)
    local constantKey = constants.key or modName
    local modConstants = self.constants[constantKey] or {}
    if (constants.list ~= nil) then
        for key, constant in pairs(constants.list) do
            modConstants[key] = constant
        end
    end
    self.constants[constantKey] = modConstants

    local constantAccessor = constants.accessor
    if (constantAccessor ~= nil) then
        _G[constantAccessor] = modConstants
    end
end

function ModManager:getConstants()
    return self.constants
end

function ModManager:dependenciesLoaded(dependencies)
    local errors = {}
    for i, dependency in pairs(dependencies) do
        local found = false
        for i, loadedMod in pairs(self.loadedMods) do
            if (loadedMod.name == dependency.name) then
                if (dependency.version ~= nil) then
                    if (loadedMod.version == dependency.version) then
                        found = true
                    else
                        table.insert(errors, "Requires '" .. dependency.name .. "@" .. dependency.version "' but found " .. loadedMod.name .. "@" .. loadedMod.version .. ".")
                    end
                else
                    found = true
                end
            end
        end
        if (not found) then
            table.insert(errors, "Dependency '" .. dependency.name .. "' not found.")
        end
    end
    
    for i, error in pairs(errors) do
        print("Error: " .. error)
    end
    
    return (next(errors) == nil)-- True on no errors
end
