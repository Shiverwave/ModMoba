function commandFunctionListMods()
    local mods = modManager:getLoadedMods()
    this:SystemMessage("[FFBF43]Server mods installed:[-]")
    for i, mod in pairs(mods) do
        this:SystemMessage("[FFBF43]\nName: " .. mod.name .. "\nAuthor: " .. mod.author .. "\nVersion: " .. mod.version .. "\nDescription: " .. mod.description .. "[-]\n\n")
    end
end

-- RegisterCommand{ Command="list-mods", AccessLevel = AccessLevel.Mortal, Func=commandFunctionListMods, Desc="Lists all mods in the module manager." }