
-- Prints the mods file reset and kills the server.
function PrintModsFileReset()
  print("Required script 'mods.lua' file was invalid.")
  print("A templated mods.lua has been placed in the base directory of your scripts.")
  print("If the file already existed, its contents were placed under the template as comments.")
  print("Ensure 'mods.lua' is configured correctly to load community mods.")
  print("Server shutting down.")
  os.execute("pause")
  os.exit()
end

-- Merges two tables.
function mergeTables(parent, other)
  for i, var in pairs(other) do
    table.insert(parent, var)
  end
end