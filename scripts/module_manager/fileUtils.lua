-- SCRIPTS_PATH is the full path to the scripts directory, including a trailing slash. It should be used as a prefix to other files, so they can be treated relative to the scripts directory.
local srcFile = debug.getinfo(1).source
local modName = string.sub(srcFile, 2, string.find(srcFile, ":") - 1)
local SCRIPTS_PATH = ".\\mods\\" .. modName .. "\\scripts\\"
local VANILLA_SCRIPTS_PATH = ".\\Build\\base\\scripts\\"
local MODS_FILE = "module_manager\\mods.lua"
local REQUIRES_PLAYER = "MODULE_MANAGER_requires_player.lua"
local REQUIRES_GLOBAL = "MODULE_MANAGER_requires_global.lua"
local OS_DIRECTORY_CHAR = "\\"
local overridesWithIncludedVanilla = {}

FileUtils = {}
FileUtils.__index = FileUtils

setmetatable(
    FileUtils,
    {
        __call = function(cls, ...)
            return cls.new(...)
        end
    }
)

function FileUtils.new()
    local self = setmetatable({}, FileUtils)

    ensureFileExists(SCRIPTS_PATH .. MODS_FILE)
    ensureFileExists(SCRIPTS_PATH .. REQUIRES_PLAYER)
    ensureFileExists(SCRIPTS_PATH .. REQUIRES_GLOBAL)

    return self
end

-- Reset's the Mods.lua file.
function FileUtils:resetModsFile()
    local path = SCRIPTS_PATH .. MODS_FILE
    local lines = {}

    -- Read in the current file and store its contents.
    local f = io.open(path, "r")
    local line = f:read()
    while line ~= nil do
        table.insert(lines, line)
        line = f:read()
    end
    f:close()

    f = io.open(path, "w")
    f:write("-- This is a compulsory file for the module_manager.", "\n")
    f:write("-- If it does not exist, the file will be created in its basic form when the server starts.", "\n")
    f:write("-- If it does exist but is not configured correctly, all existing code will be commented out and the script will be prepared in its basic form.", "\n")
    f:write("", "\n")
    f:write("-- To load a mod on start up, simply add the directory name to the 'MODS' table.", "\n")
    f:write("", "\n")
    f:write("MODS = {", "\n")
    f:write('  --"mod_name",', "\n")
    f:write("}", "\n")

    if next(lines) ~= nil then
        f:write("", "\n")
        f:write("---------------------------------------------------", "\n")
        f:write("--              Original Code Below              --", "\n")
        f:write("---------------------------------------------------", "\n")
        for i, line in pairs(lines) do
            f:write("-- " .. line, "\n")
        end
    end
    f:close()

    print("Required script 'mods.lua' file was invalid.")
    print("A templated mods.lua has been placed in the 'module_manager' directory of your scripts.")
    print("If the file already existed, its contents were placed under the template as comments.")
    print("Ensure 'mods.lua' is configured correctly to load community mods.")
    print("Server shutting down.")
    os.execute("pause")
    os.exit()
end

-- Initializes the global mods.
function FileUtils:initializeGlobalMods(requireDefinitions)
    local path = SCRIPTS_PATH .. REQUIRES_GLOBAL
    local missingRequires = getMissingRequires(requireDefinitions, path)
    addRequiresToFile(missingRequires, path)
end

-- Initializes the player mods.
function FileUtils:initializePlayerMods(requireDefinitions)
    local path = SCRIPTS_PATH .. REQUIRES_PLAYER
    local missingRequires = getMissingRequires(requireDefinitions, path)
    addRequiresToFile(missingRequires, path)
    prepareVanillaOverrideFileForRequire("player", string.sub(REQUIRES_PLAYER, 1, -5), false)
end

-- Initializes the override mods.
function FileUtils:initializeOverrideMods(requireDefinitions)
    for i, requireDefinition in pairs(requireDefinitions) do
        local vanillaScriptDot = requireDefinition.vanilla
        local vanillaScriptSlash = vanillaScriptDot:gsub("%.", OS_DIRECTORY_CHAR)
        local modScript = requireDefinition.override

        -- We might want to exclude requiring the vanilla file (as a complete override)
        local excludeVanilla = requireDefinition.excludeVanilla

        -- Check that the vanilla game actually has the original first.
        if not (doesFileExist(VANILLA_SCRIPTS_PATH .. vanillaScriptSlash .. ".lua")) then
            print(vanillaScriptSlash .. " cannot be overridden as it does not exist in the base game.")
            print("Please check your mod configurations for errors.")
            print("Server shutting down.")
            os.execute("pause")
            os.exit()
        end
        prepareVanillaOverrideFileForRequire(vanillaScriptDot, modScript, excludeVanilla)
        overrideExistingFunctions(vanillaScriptDot, modScript)
    end
end

-- Check to see if a file exists.
function doesFileExist(path)
    local f = io.open(path, "r")
    if (f ~= nil) then
        f:close()
        return true
    end
    return false
end

-- Ensures a file exists by opening it up for appending, then closing it.
function ensureFileExists(path)
    local f = io.open(path, "a")
    f:close()
end

-- Ensures the vanilla override file has the provided requires, one for the default vanilla file and another for the override.
function prepareVanillaOverrideFileForRequire(vanillaScript, requiredFile, excludeVanilla)
    local vanillaScriptSlash = vanillaScript:gsub("%.", OS_DIRECTORY_CHAR)
    local vanillaOverrideFile = SCRIPTS_PATH .. vanillaScriptSlash .. ".lua"

    -- If we're excluding the vanilla, make sure it hasn't already been added. If it has, bail!
    if (excludeVanilla and overridesWithIncludedVanilla[vanillaScript] and overridesWithIncludedVanilla[vanillaScript] > 0) then
        print("Tried to exclude vanilla file [" .. vanillaScript .. "] as part of override, but another script has already included it.")
        print("Please check your mod configurations for errors.")
        print("Server shutting down.")
        os.execute("pause")
        os.exit()
    elseif (not excludeVanilla) then
        addRequireToFile(vanillaOverrideFile, "default:" .. vanillaScript)
        overridesWithIncludedVanilla[vanillaScript] = (overridesWithIncludedVanilla[vanillaScript] or 0) + 1
    end
    addRequireToFile(vanillaOverrideFile, requiredFile)
end

-- Adds a require to a file. File 'f' should be open for appending and reading.
function addRequireToFile(filename, requiredFile)
    local expectedRequire = "require '" .. requiredFile .. "'"
    local f = io.open(filename, "a+")
    local line = f:read()
    local found = false
    while line ~= nil and not found do
        if (line == expectedRequire) then
            found = true
        else
            line = f:read()
        end
    end

    if not (found) then
        f:write("", "\n")
        f:write("-- The following require has been automatically added for the module manager.", "\n")
        f:write(expectedRequire, "\n")
    end
    f:close()
end

-- Scans the override script for functions that exist in the vanilla script which are being called from EventHandlers.
-- If any are found, an EventHandler override is created in the vanilla override script in the root scripts directory.
-- This is done to allow multiple mods to override the same functions called by event handlers without the need to
-- register their own event handlers.
function overrideExistingFunctions(vanillaScript, overrideScript)
    local vanillaScriptPath = VANILLA_SCRIPTS_PATH .. vanillaScript:gsub("%.", OS_DIRECTORY_CHAR) .. ".lua"
    local vanillaOverrideScriptPath = SCRIPTS_PATH .. vanillaScript:gsub("%.", OS_DIRECTORY_CHAR) .. ".lua"
    local overrideScriptPath = SCRIPTS_PATH .. overrideScript:gsub("%.", OS_DIRECTORY_CHAR) .. ".lua"

    local modScriptFunctions = getFunctionsForScript(overrideScriptPath)
    local vanillaEventHandlers = getEventHandlersForScript(vanillaScriptPath)

    -- Ensure functions in our override script have event handlers if necessary.
    local requiredEventHandlers = {}
    for i, modFunction in pairs(modScriptFunctions) do
        -- If the function starts with NILOVR, it should be overriding an event handler that doesn't have a name or id.
        -- The type is used instead.
        if (string.sub(modFunction, 1, 6) == "NILOVR") then
            -- If the function starts with OVR, it should be overriding an event handler without a vanilla method.
            local expectedId = string.sub(modFunction, 7, -1)
            local found = false
            for j, vanillaEventHandler in pairs(vanillaEventHandlers) do
                if (vanillaEventHandler.type == expectedId) then
                    -- Update the name of the vanilla event handler
                    if (vanillaEventHandler.name == nil) then
                        vanillaEventHandler.name = modFunction
                    end
                    if (vanillaEventHandler.name ~= modFunction) then
                        print("Conflict found when trying to override event handler with id '" .. expectedId .. "' as it is already overridden by '" .. vanillaEventHandler.name .. "'")
                    end

                    table.insert(requiredEventHandlers, vanillaEventHandler)
                    found = true
                    break
                end
            end
            if (not found) then
                print("NILOVR:Unable to find event handler with id '" .. expectedId .. "' in vanilla script " .. vanillaScript)
            end
        elseif (string.sub(modFunction, 1, 3) == "OVR") then
            -- The function doesn't start with OVR, so check to see if there is already an event handler using this function.
            local expectedId = string.sub(modFunction, 4, -1)
            local found = false
            for j, vanillaEventHandler in pairs(vanillaEventHandlers) do
                if (vanillaEventHandler.id == expectedId) then
                    -- Update the name of the vanilla event handler
                    if (vanillaEventHandler.name == nil) then
                        vanillaEventHandler.name = modFunction
                    end
                    if (vanillaEventHandler.name ~= modFunction) then
                        print("OVR:Conflict found when trying to override event handler with id '" .. expectedId .. "' as it is already overridden by '" .. vanillaEventHandler.name .. "'")
                    end

                    table.insert(requiredEventHandlers, vanillaEventHandler)
                    found = true
                    break
                end
            end
            if (not found) then
                print("Unable to find event handler with id '" .. expectedId .. "' in vanilla script " .. vanillaScript)
            end
        else
            for j, vanillaEventHandler in pairs(vanillaEventHandlers) do
                if (vanillaEventHandler.name == modFunction) then
                    table.insert(requiredEventHandlers, vanillaEventHandler)
                end
            end
        end
    end

    local eventHandlersToAdd = {}
    -- Ensure all our required event handlers are in our vanilla override script.
    local vanillaOverrideEventHandlers = getEventHandlersForScript(vanillaOverrideScriptPath)
    for i, requiredEventHandler in pairs(requiredEventHandlers) do
        local found = false
        for j, existingEventHandler in pairs(vanillaOverrideEventHandlers) do
            if (existingEventHandler.type == requiredEventHandler.type and existingEventHandler.id == requiredEventHandler.id and existingEventHandler.name == requiredEventHandler.name) then
                found = true
                break
            end
        end

        if (not found) then
            table.insert(eventHandlersToAdd, requiredEventHandler)
        end
    end

    -- Lastly, add all the missing event handlers.
    addEventHandlersToFile(eventHandlersToAdd, vanillaScript)
end

-- Gets all the functions from the provided script.
function getFunctionsForScript(scriptPath)
    local functions = {}
    local f = io.open(scriptPath, "r")
    if (f == nil) then
        print("Unable to open file for reading: " .. scriptPath)
        return
    end
    local line = f:read()
    while line ~= nil do
        local functionName = string.match(line, "%s*function%s+(%w+)%(.*%)")
        if (functionName ~= nil) then
            table.insert(functions, functionName)
        end
        line = f:read()
    end
    f:close()
    return functions
end

-- Gets all the Event Handlers for the provided script.
-- Returned as array with list of objects with event handler details <type, id, name>.
function getEventHandlersForScript(scriptPath)
    -- print(scriptPath)
    local eventHandlers = {}
    local f = io.open(scriptPath, "r")
    if (f == nil) then
        return eventHandlers
    end
    local line = f:read()
    while line ~= nil do
        -- Match for event handlers with named functions
        local eventType, eventId, functionName = string.match(line, '^%s*%w+EventHandler%(.*EventType%.(%w+),%s*"(.*)"%s*,%s*(%w+)%)')
        if (eventType ~= nil and eventId ~= nil and functionName ~= nil) then
            table.insert(eventHandlers, {type = eventType, id = eventId, name = functionName})
        -- print("1   " .. eventType .. " : " .. eventId .. " : " .. functionName)
        end

        -- Now match for event handlers without named functions
        -- Inner function on same line with real function on same line.
        eventType, eventId, functionName = string.match(line, '^%s*%w+EventHandler%(.*EventType%.(%w+),%s*"(.*)"%s*,%s*function%(.*%)%s*(.+)%(.*%)%s*end%)')
        if (eventType ~= nil and eventId ~= nil and functionName ~= nil) then
            table.insert(eventHandlers, {type = eventType, id = eventId, name = functionName})
        -- print("2   " .. eventType .. " : " .. eventId .. " : " .. functionName)
        end

        local functionOnSameLine = false
        functionName = nil
        -- Inner function on next line.
        eventType, eventId = string.match(line, '^%s*%w+EventHandler%(.*EventType%.(%w+),%s*"(.*)"%s*,%s*$')
        if (eventType == nil or eventId == nil) then
            -- Inner function on same line with real function on different line.
            functionOnSameLine = true
            eventType, eventId = string.match(line, '^%s*%w+EventHandler%(.*EventType%.(%w+),%s*"(.*)"%s*,%s*function%s*%(.*%)')
        end

        if (eventType ~= nil and eventId ~= nil) then
            -- If we have an event handler of this type, it might be wrapping a single function.
            local potentialFunctionLine = trimString(f:read())
            if not (functionOnSameLine) then
                potentialFunctionLine = trimString(f:read())
            end
            local potentialFunction = string.match(potentialFunctionLine, "(%w+)%(%w*%)")
            if (potentialFunction ~= nil and startsWith(potentialFunctionLine, potentialFunction)) then
                functionName = potentialFunction
            end
            table.insert(eventHandlers, {type = eventType, id = eventId, name = functionName})
        -- print("3   " .. eventType .. " : " .. eventId .. " : " .. tostring(functionName))
        end

        line = f:read()
    end
    f:close()
    return eventHandlers
end

-- Compare the provided file definitions to the requires inside the provided path.
-- Returns a list of missing requires.
function getMissingRequires(requireDefinitions, path)
    local missingRequires = {}
    local existingRequires = getRequiresFromFile(path)

    -- Go through all the necessary and existing requires.
    -- For each we don't have, add it to the missing list.
    for i, requireScript in pairs(requireDefinitions) do
        local found = false
        for j, existingRequire in pairs(existingRequires) do
            if (existingRequire == requireScript) then
                found = true
            end
        end
        if not (found) then
            table.insert(missingRequires, requireScript)
        end
    end
    return missingRequires
end

-- Returns a list of requires from the provided file.
function getRequiresFromFile(path)
    local lines = {}
    local f = io.open(path, "r")
    if (f == nil) then
        print("Unable to open file for reading: " .. path)
        return
    end
    local line = f:read()
    while line ~= nil do
        line = string.match(line, "'.+'")
        -- Get string in quotes.
        line = string.sub(line, 2, -2)
        -- Remove quotes.
        table.insert(lines, line)
        line = f:read()
    end
    f:close()
    return lines
end

-- Adds the requires provided to the file.
function addRequiresToFile(requiresToAdd, path)
    local f = io.open(path, "a")
    for i, requireToAdd in pairs(requiresToAdd) do
        f:write("require '" .. requireToAdd .. "'", "\n")
    end
    f:close()
end

-- Adds event handlers to the file.
function addEventHandlersToFile(eventHandlersToAdd, vanillaOverrideScriptName)
    -- Ensure there are event handlers to add.
    if next(eventHandlersToAdd) == nil then
        return
    end

    local path = SCRIPTS_PATH .. vanillaOverrideScriptName:gsub("%.", OS_DIRECTORY_CHAR) .. ".lua"
    local f = io.open(path, "a")
    f:write("", "\n")
    f:write("-- The following event handlers has been automatically added for the module manager.", "\n")
    for i, eventHandlerToAdd in pairs(eventHandlersToAdd) do
        f:write('OverrideEventHandler("default:' .. vanillaOverrideScriptName .. '", EventType.' .. eventHandlerToAdd.type .. ', "' .. eventHandlerToAdd.id .. '", ' .. eventHandlerToAdd.name .. ")", "\n")
    end
    f:write("-- Generated overrides complete.", "\n")
    f:close()
end

-- Trims a string
function trimString(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

-- Check if a string starts with another.
function startsWith(wholeString, startsWith)
    return string.sub(wholeString, 1, string.len(startsWith)) == startsWith
end
