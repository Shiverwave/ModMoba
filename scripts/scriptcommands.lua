-- modded scriptcommands.lua

-- Uncomment this if not using the module manager.
--require 'default:scriptcommands'

--[[
This file will add more than one mod to the game but will allow for each
modification to be added separately.
the format for adding enhancements is

require 'yourFolderName.yourFileName'

This method is only used for when you are overriding an existing file to
allow multiple people to edit the same file. All your other files need to
remain in the GSCC/scripts folder with your initials in capitals as at the 
beginning. example: NS_hellportal_effect.lua

]]--


-- Mr Staples

require 'sceneCreator.createScene' -- Starts the scene editor
require 'sceneCreator.rotateObject' -- Commands to rotate objects in game.



