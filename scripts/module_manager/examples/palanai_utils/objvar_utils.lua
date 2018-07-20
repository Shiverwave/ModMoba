----------------------------------------------------------------------------------------------------------------------------------
-- File:          objvar_utils.lua
-- Author:        DjOli (Adam Britto)
-- Description:   Utilities for objvar manipulation.
----------------------------------------------------------------------------------------------------------------------------------

-- Initializes an object variable if it doesn't already exist on the target.
function InitializeObjVar(target, objvar, initialState)
  if (not target:HasObjVar(objvar)) then
    target:SetObjVar(objvar, initialState)
  end
end