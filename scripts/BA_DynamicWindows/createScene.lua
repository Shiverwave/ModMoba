
--[[
Shards Server version: 0.6.3f
Author: Cowgoesmoo - NS
Date Modified: 08/05/2018

This file contains all the functions to implement the scene editor into the god commands
Many of the functions are edited from scriptcommands_UI_create.lua
Function list:
/createScene
/loadScene
/deleteScene

DefaultCommandFuncs -- adds the functions for the commands to the God commands list
RegisterCommand -- registers the commands for the command line.

Massive Credit to Yorlik of Arcanima for xml code help.
Huge thanks to the Teriavon team for maintaining the code between updates.
--]]

--Uncomment the next line to enable support for not using the Module Manager
-- require "scriptcommands"

----------------------------------------
--Variables
----------------------------------------

-- Creates a list of template categories to aid in template navigation/location
-- Excludes categories that have mobiles and spawn controllers.
-- Add any additional categories that you need to the list.
local sceneTemplateCategories = {"All","resources", "outlands", "nodraws", "mobiles", "magic_items", "tv_books", "celador", "catacombs", "tv_mobiles","items", "equipment", "environment", "tv_resources", "tv_items", "tv_equipment", "tv_environment", "spawners", "tv_gizmo"}


--Your mod name goes here
local myMod = "GSCC"


-- These variables are already declared in scriptcommands_UI_create.lua
-- templateListCategory = ""
-- templateListCategoryIndex = 1
-- templateListFilter = ""
-- These variables are used in the standard /create window that has been copied
-- here as the template. The functionality it initiates has been disabled
-- and commented out but left in should it ever be required again. 
createAmountStr = "1"
createAmount = 1
createType = "Object"

--SC_templateId = nil

----------------------------------------
--Functions
----------------------------------------

----------------------------------------
--Scene editor UI functions
-- Create the initial display listing categories of template that can be added to a scene
function showSceneSelectCategory()
	local sceneEditorWindow = DynamicWindow("sceneTemplateList","Create objects for scene: "..this:GetObjVar("editingScene"),450,700)

	sceneEditorWindow:AddImage(110,12,"TitleBackground",250,0,"Sliced")
	sceneEditorWindow:AddButton(80,16,"CatLeft:","",0,0,"","",false,"LeftArrow")
	sceneEditorWindow:AddLabel(210,15,"Select Category",400,0,18,"center")
	sceneEditorWindow:AddButton(330,16,"CatRight:","",0,0,"","",false,"RightArrow")

	local scrollWindow = ScrollWindow(20,60,380,450,40)

	for i=1,#sceneTemplateCategories do	
		local scrollElement = ScrollElement()	
		scrollElement:AddButton(0,0, "category:"..sceneTemplateCategories[i],sceneTemplateCategories[i], 350, 0, "", "", false, "")
		scrollWindow:Add(scrollElement)
	end
	
	sceneEditorWindow:AddScrollWindow(scrollWindow)

	sceneEditorWindow:AddButton(20, 520, "commitScene:", "Save Scene", 390, 0, "", "", false, "")

	
--	sceneEditorWindow:AddLabel(20,572,"Amount: ",0,0,20)
--	sceneEditorWindow:AddTextField(100, 570, 100, "CreateAmount", createAmountStr)
--	sceneEditorWindow:AddButton(220, 565, "Type:", createType, 150, 25, "", "", false, "")

	sceneEditorWindow:AddLabel(20,610,"Filter: ",0,0,20)
	DebugMessage("template List Filter= "..templateListFilter)
	sceneEditorWindow:AddTextField(100, 610, 200, 20, "Filter", templateListFilter)
	sceneEditorWindow:AddButton(320, 605, "ApplyFilter:", "Apply", 100, 0, "", "", false, "")

	this:OpenDynamicWindow(sceneEditorWindow)
end

function showScenePlacableTemplates()
	if(templateListCategory == "") then
		templateListCategoryIndex = 0
		showSceneSelectCategory()
		return
	end

	local newWindow = DynamicWindow("sceneTemplateList","Create objects for scene: "..this:GetObjVar("editingScene"),450,700)
	local templatesListTable = nil

	newWindow:AddImage(40,12,"TitleBackground",250,0,"Sliced")
	newWindow:AddButton(30,16,"CatLeft:","",0,0,"","",false,"LeftArrow")
	newWindow:AddLabel(160,15,templateListCategory,340,0,18,"center")
	newWindow:AddButton(280,16,"CatRight:","",0,0,"","",false,"RightArrow")
	newWindow:AddButton(310, 8, "SelectCat:", "Back", 100, 0, "", "", false, "")

	if(templateListCategory == "All") then
		templatesListTable = GetAllTemplateNames()
	else
		templatesListTable = GetAllTemplateNames(templateListCategory)
	end

	if(templateListFilter ~= nil and templateListFilter ~= "") then
		local fullList = templatesListTable
		templatesListTable = {}
		for i,v in pairs(fullList) do
			if(v:match(templateListFilter)) then
				table.insert(templatesListTable,v)
			end
		end
	end

	table.sort(templatesListTable)

	local scrollWindow = ScrollWindow(20,60,380,450,40)

	for i=1,#templatesListTable do	
		local scrollElement = ScrollElement()	
		scrollElement:AddButton(0,0, "create:"..templatesListTable[i],templatesListTable[i], 350, 0, "", "", false, "")
		scrollWindow:Add(scrollElement)
	end
	
	newWindow:AddScrollWindow(scrollWindow)

	newWindow:AddButton(20, 520, "commitScene:", "Save Scene", 390, 0, "", "", false, "")
	
--	newWindow:AddLabel(20,572,"Amount: ",0,0,20)
--	newWindow:AddTextField(100, 570, 100, "CreateAmount", createAmountStr)
--	newWindow:AddButton(220, 565, "Type:", createType, 150, 25, "", "", false, "")

	newWindow:AddLabel(20,610,"Filter: ",0,0,20)
	newWindow:AddTextField(100, 610, 200, 20, "Filter", templateListFilter)
	newWindow:AddButton(320, 605, "ApplyFilter:", "Apply", 100, 0, "", "", false, "")

	this:OpenDynamicWindow(newWindow)
end



RegisterEventHandler(EventType.ClientTargetLocResponse, "createSceneTemplateAt",
	function(success,targetLoc)
		if not(IsDemiGod(this)) then return end

		local createFunc = CreateObj
		createFunc(templateId,targetLoc,"sceneObject")
		PlayEffectAtLoc("TeleportFromEffect",targetLoc)
	end
)


--[[
when the object is created it adds the name of the scene currently being edited
as well as sets appropriate variables (NoInteract, weight -1) so that the object is not able
to be moved or be interacted with by players

success = bool - was the item created successflly?
objref = object - the id of the created object
--]]

RegisterEventHandler(EventType.CreatedObject,"sceneObject",
	function(success, objref)
		if success == 1 then
					local sceneName = this:GetObjVar("editingScene")
			objref:SetObjVar("sceneName", sceneName)
			objref:SetSharedObjectProperty("NoInteract", true)
			objref:SetSharedObjectProperty("Weight",-1)		
			objref:SetObjVar("handlesPickup",true)
		end
	end)


--[[
commitScene

Gets the info for all scene objects created with the currently active scene name
and saves them to the seedobjects file.
sceneName = string - the scene being saved
--]]

function commitScene(sceneName)
	-- Set file name for scene to be saved to.

	sceneFile = "mods\\".. tostring(myMod).. "\\mapdata\\"..GetWorldName().."\\Scenes\\" .. tostring(sceneName) .. ".xml"
	
	-- Set file name for seeds to be saved to. -- Added by Merrenwen
	seedIFile = "mods\\".. tostring(myMod).. "\\mapdata\\"..GetWorldName().."\\Scenes\\" .. tostring(sceneName) .. "SEED.xml"
	
--	DebugMessage ("Scenefile is ".. SceneFile)

	----------------------------------------
	--[[ Backup Old Scene File ( uncomment this to enable file backups)
	----------------------------------------

	-- TimeStamp for Backup File
	TimeStamp =	string.format("%04d", DateTime.UtcNow.Year		)
				.."-".. string.format("%02d", DateTime.UtcNow.Month		)
				.."-".. string.format("%02d", DateTime.UtcNow.Day 		)
				.."_".. string.format("%02d", DateTime.UtcNow.Hour 		)
				.."-".. string.format("%02d", DateTime.UtcNow.Minute	)
				.."-".. string.format("%02d", DateTime.UtcNow.Second	)

	-- Define Backup File in directory mymod\backup\mapName\ eg.GSCC\backup\celador\
	backupFile="mods\\".. tostring(myMod).. "\\mapdata\\"..GetWorldName().."\\Scenes\\" .. tostring(sceneName) .. TimeStamp ..".xml"

--	DebugMessage ("TimeStamp is "..TimeStamp)
--	DebugMessage ("BackupFile is "..BackupFile)
	
	-- read
	local file = io.open(SceneFile ,"r")
	local MyString = file:read("*a")
	file:close()

	--write
	local backupfile = assert(io.open(backupFile ,"w"))
	backupfile:write(MyString)
	backupfile:close()
	--]]

	----------------------------------------
	-- Find scene objects to save to file
	-- creates a table col 0 = table index, col 1 = object id
	----------------------------------------
	local sceneObjects = FindObjects(SearchObjVar("sceneName", sceneName,10000))

--	DebugMessage(DumpTable(sceneObjects))

	----------------------------------------
	-- Create internal XML table to be used
	-- Set initial values
	----------------------------------------

	local workingXML = xml.new("sceneObjects:" .. sceneName)
    workingXML["xmlns:xsi"] = "http://www.w3.org/2001/XMLSchema-instance"
    workingXML["xmlns:xsd"] = "http://www.w3.org/2001/XMLSchema"
	
	----------------------------------------
	-- Create internal XML table to be used for seeds
	-- Set initial values
	-- Added by Merrenwen
	----------------------------------------
	
	local workingXMLS = xml.new("WorldTemplateObjects")
	workingXMLS["xmlns:xsd"] = "http://www.w3.org/2001/XMLSchema"
    workingXMLS["xmlns:xsi"] = "http://www.w3.org/2001/XMLSchema-instance"
	
	--add group name
	grpName = {
	  ["Exclude"]="False",
      ["Name"]=sceneName
      
	  }
	  
	--make the XML string
	NewXmlStrS=xml.str(
		grpName, 		--string
		1, 				-- indentation
		"Group" 		-- enclosing xml tag
		)

	-- Convert the New XML String into an xml object that can be appended
	NewTag = xml.eval(NewXmlStrS)
	-- append our New Seed XML Object to the Master Seed Objects XML Object
	xml.append(workingXMLS,NewTag)
	
	--set initial counter value for item ID in seed file
	local seedCount = 1
	
	
	--xml find by the group name, then append to that name
	
	
	----------------------------------------
	-- Save each item in the sceneObjects list individually to the file
	-- First we need to gather all the information required so that we can recreate each
	-- object in its current state in the game world.
	----------------------------------------

	for i,object in ipairs(sceneObjects) do

		PlayEffectAtLoc("TeleportToEffect",object:GetLoc() ) -- Candy

		local objectTemplate = object:GetCreationTemplateId()
		local objectHue = object:GetHue()
		local objectName = object:GetName()
		local objectScaleVector = " "
		local objectRotation = object:GetRotation().X .. "," .. object:GetRotation().Y .. "," .. object:GetRotation().Z
		local objectLocation = object:GetLoc().X .. "," .. object:GetLoc().Y .. "," .. object:GetLoc().Z
		local objectScripts = object:GetObjVar("customScripts")
		-- custom - weight etc will be added by default when objects are created on server start
		
		----------------------------------------
		-- Object Scaling
		-- Format for Rotation and Location information for addition to the ObjectCreationParams
		-- Added by Merrenwen
		----------------------------------------

		local osv = object:GetScale()
		objectScaleVector = string.format("%4.4f %4.4f %4.4f",osv.X,osv.Y,osv.Z)

		--------------------------------------------
		-- Gather all object var information and save it
		-- Cycle through ObjVars on the object save all of them to the objVars variable
		-- don't do this if the objvar is a table
		----------------------------------------

		local objVars= ""
		
		for objVarName,value in pairs(object:GetAllObjVars()) do
			if type(value)=="string" then
--				DebugMessage("String ObjVar")
				objVars=objVars .. tostring(objVarName) .. "=" .. tostring(value) .. "=string" .. ";"
			elseif type(value)=="number" then
--				DebugMessage("Number ObjVar")
				objVars=objVars .. tostring(objVarName) .. "=" .. tostring(value) .. "=number" .. ";"
			elseif type(value)=="boolean" then
--				DebugMessage("Number ObjVar")
				objVars=objVars .. tostring(objVarName) .. "=" .. tostring(value) .. "=boolean" .. ";"
			else
				DebugMessage("Can't save objVar info. Wrong format: ".. tostring(objVarName).. ":" ..tostring(value)..":"..tostring(type(value)))
			end
		end
--			DebugMessage(objVars)

		--------------------------------------------
		-- For seed file, put together the values for the ObjectCreationParams
		-- Added by Merrenwen
		-- ***Later we should just modify the scene editor to use this same format**
		----------------------------------------
		local objectRotationS = object:GetRotation().X .. " " .. object:GetRotation().Y .. " " .. object:GetRotation().Z
		local objectLocationS = object:GetLoc().X .. " " .. object:GetLoc().Y .. " " .. object:GetLoc().Z
		
		local objParams= objectTemplate .. " " .. objectLocationS .. " " .. objectRotationS .. " " .. objectScaleVector
		
		----------------------------------------
		-- Construct XMLString Structure
		----------------------------------------

		myXML=
			{
			Name={objectName},
			Template={objectTemplate},
			Hue={objectHue},
			ObjectScaleVector={objectScaleVector},
			ObjectLocation={objectLocation},
			ObjectRotation={objectRotation},
			ObjVars={objVars},
			CustomScripts={objectScripts}
		}
--		DebugMessage(DumpTable(myXML))

		-- Finally make the XML string
		NewXmlStr=xml.str(
			myXML, 			--string
			2, 				-- indentation
			"DynamicObject" -- enclosing xml tag)
			)

		-- Convert the New XML String into an xml object that can be appended
		NewTag = xml.eval(NewXmlStr)
		-- append our New Seed XML Object to the Master Seed Objects XML Object
		xml.append(workingXML,NewTag)
		
		----------------------------------------
		-- Construct XMLString Structure for temp seed file --Added by Merrenwen
		----------------------------------------		

		--create item string
		myXMLS=
			{
			Name={objectName},
			ID={seedCount},
			ObjectCreationParams={objParams}
		}

		-- Finally make the XML string
		NewXmlStrS=xml.str(
			myXMLS, 			--string
			2, 				-- indentation
			"DynamicObject" -- enclosing xml tag)
			)

		-- Convert the New XML String into an xml object that can be appended
		NewTagS = xml.eval(NewXmlStrS)
		
		--table.insert(xml.find(xmlObj,"Group","Name",grpName), deepcopy(SeedObjectXml))
		-- append our New Seed XML Object to the Master Seed Objects XML Object
		xml.append(workingXMLS,NewTagS)	
		
		--increment seed ID counter
		seedCount = seedCount + 1
		
		-- rinse-repeat
	end

	-- Write scene object file
	-- First get rid of HTML ' cos
	local finalXML = workingXML:str():gsub("&quot;", "\"")
	local file = io.open(sceneFile, "w+")
	file:write("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n")
	file:write(finalXML)
	file:close()
	
	this:SystemMessage("Saving Scene Objects to scene file: Done!")
	
	-- Write seed object file
	-- First get rid of HTML ' cos
	local finalXMLS = workingXMLS:str():gsub("&quot;", "\"")
	local fileS = io.open(seedIFile, "w+")
	fileS:write("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n")
	fileS:write(finalXMLS)
	fileS:close()
	
	this:SystemMessage("Saving Scene Objects to seed file: Done!")
end

	
	
RegisterEventHandler(EventType.DynamicWindowResponse,"sceneTemplateList",
	function (user,returnId,fieldData)
		if(returnId ~= nil) then
			createAmountStr = fieldData.CreateAmount
			templateListFilter = fieldData.Filter

			action, template = string.match(returnId, "(%a+):([%a_%d]*)")
			if(action == "create") then
				createAmount = tonumber(createAmountStr) or 1
				templateId = GetTemplateMatch(template)
				if( templateId ~= nil ) then
					this:RequestClientTargetLocPreview(this,"createSceneTemplateAt",templateId,Loc(0,0,0))
				end
			elseif(action == "category") then
--				local templateCategories = GetCategories()
				templateListCategory = template
				templateListCategoryIndex = IndexOf(sceneTemplateCategories,template)
				showScenePlacableTemplates()
			elseif(action == "CatLeft") then
--				local templateCategories = GetCategories()
				templateListCategoryIndex = ((templateListCategoryIndex - 2) % #sceneTemplateCategories) + 1
				templateListCategory = sceneTemplateCategories[templateListCategoryIndex]
				showScenePlacableTemplates()
			elseif( action == "CatRight") then
				local templateCategories = GetCategories()
				templateListCategoryIndex = (templateListCategoryIndex % #sceneTemplateCategories) + 1
				templateListCategory = sceneTemplateCategories[templateListCategoryIndex]
				showScenePlacableTemplates()
				elseif( action == "SelectCat" ) then
				templateListCategoryIndex = 0
				templateListCategory = ""
				showSceneSelectCategory()
			elseif( action == "CreateFilter") then
				user:SendClientMessage("EnterChat",".xo "..this.Id.." createfilter ")
			elseif( action == "ApplyFilter" ) then
				showScenePlacableTemplates()
--[[			elseif( action == "Type") then
				if(createType == "Object") then createType = "Temporary"
				elseif(createType == "Temporary") then createType = "Packed"
				elseif(createType == "Packed") then createType = "Object" end
--]]			showScenePlacableTemplates()			

				elseif( action == "commitScene") then
				local sceneName = this:GetObjVar("editingScene")
				
				commitScene(sceneName)
				
				this:SystemMessage("Scene: ".. tostring(sceneName).. " saved!")
				this:SystemMessage("Scene: ".. tostring(sceneName).. " saved!",	"event")
				showSceneSelectCategory()			
			end
		end	
	end)

	
RegisterEventHandler(EventType.ClientObjectCommand,"createfilter",
	function(user,filterStr)
		templateListFilter = filterStr
		showScenePlacableTemplates()
	end)

----------------------------------------
--Load and delete scene functions

--Custom function to split a string into a table of each of its components.
--inputString = string - the string to be split
--seperator the charcter (or charater string to split on) these are not included in the output.
function splitString(inputString, seperator)
    if separator == nil then
		separator = "%s"
	end
		
	local stringTable={} ; i=1
	for str in string.gmatch(inputString, "([^"..seperator.."]+)") do
		stringTable[i] = str
		i = i + 1
	end
	return stringTable
end


function deleteSceneObjects(sceneName)
	local sceneObjects = FindObjects(SearchObjVar("sceneName", sceneName,10000))

	for i,object in ipairs(sceneObjects) do
		object:Destroy()
	end
end


function loadSceneFile(sceneFileName)
	local scene = sceneFileName

	sceneFile = "mods\\".. tostring(myMod).. "\\mapdata\\"..GetWorldName().."\\Scenes\\" .. tostring(scene) .. ".xml"
--			DebugMessage ("Scenefile is " .. sceneFile)

	----------------------------------------
	-- Convert the xml file into a lua table
	----------------------------------------

	local sceneObjectList = xml.load(sceneFile)
--			DebugMessage(DumpTable(sceneObjectList))

	----------------------------------------
	-- Extract all the object info from the file. Use template, location, and scale to create item
	-- send the rest with create function to ve handled by the item created event message
	----------------------------------------
	
	for i = 1, #sceneObjectList do
--				DebugMessage("Scanning object :", i)

		local objectInfo ={}
		object = sceneObjectList[i]

		for i = 1, #object do
--					DebugMessage("Scanning attribute :", i)
			attribute = object[i]

--					DebugMessage(attribute[0])
--					DebugMessage(attribute[1])

			objectInfo[attribute[0]] = attribute[1]
		end	

		-- covert stored location into usful information
		local loc = splitString(objectInfo.ObjectLocation, ",")
		
--				DebugMessage(loc[1], loc[2], loc[3])
		local tempLocation = Loc(tonumber(loc[1]), tonumber(loc[2]), tonumber(loc[3]))
		objectInfo.ObjectLocation = tempLocation
		
		-- covert stored scale Vector into usful information
		if (objectInfo.ObjectScaleVector ~= nil) then
			local scale = splitString(objectInfo.ObjectScaleVector, " ")
		
			local tempScale = Loc(tonumber(scale[1]), tonumber(scale[2]), tonumber(scale[3]))
			objectInfo.ScaleVector = tempScale

--					DebugMessage(DumpTable(objectInfo))
--					DebugMessage(objectInfo.Template)
--					DebugMessage(tempLocation)

--					CreateObj(objectInfo.Template, objectInfo.ObjectLocation, "sceneObjectSpawned", objectInfo)
			CreateObjExtended(objectInfo.Template, nil, objectInfo.ObjectLocation, Loc(0,0,0), objectInfo.ScaleVector, "sceneObjectSpawned", objectInfo)
		end
	end
end

-- Attaches all scripts and objVars to created scene objects.	
RegisterEventHandler(EventType.CreatedObject,"sceneObjectSpawned",
	function(success, objref, objectInfo)
	
		if not(IsDemiGod(this)) then return end
	
		----------------------------------------
		-- Set standard values to stop players interacting with objects
		----------------------------------------
		
		--Teiravon--do we need this one? commenting out
		--objref:SetSharedObjectProperty("NoInteract", true)
		objref:SetSharedObjectProperty("Weight",-1)		
		objref:SetObjVar("handlesPickup",true)
		objref:SetObjVar("NoReset",true)

		----------------------------------------
		-- Set values retrieved from XML file passed in objectInfo
		-- First retrieve custom scripts and attach them
		-- second get objVats and set them
		----------------------------------------

		-- covert stored rotation into usful information
		local rot = splitString(objectInfo.ObjectRotation, ",")
		local tempRotation = Loc(tonumber(rot[1]), tonumber(rot[2]), tonumber(rot[3]))
		objectInfo.ObjectRotation = tempRotation

		objref:SetHue(objectInfo.Hue)
		objref:SetRotation(objectInfo.ObjectRotation)
		objref:SetName(objectInfo.Name)

		-- Attach Scripts
		if objectInfo.CustomScripts ~= nil and objectInfo.CustomScripts ~= "" then
			local scriptsToAttach = splitString(objectInfo.CustomScripts, ",")
			for i, script in pairs(scriptsToAttach) do
				objref:AddModule(script)
			end
		end
		
		-- Attach object variables
		local objVarsToAttach = splitString(objectInfo.ObjVars, ";")
		for i = 1, #objVarsToAttach do
			objVarPair = splitString(objVarsToAttach[i], "=")

--			DebugMessage(objVarPair[1], objVarPair[2])
			if objVarPair[3] == "string" then
				objref:SetObjVar(objVarPair[1], objVarPair[2])
			elseif 	objVarPair[3] == "number" then
				objref:SetObjVar(objVarPair[1], tonumber(objVarPair[2]))
			else
				if objVarPair[2] == "true" then
					objref:SetObjVar(objVarPair[1], true)
				else
					objref:SetObjVar(objVarPair[1], false )
				end
			end
		end
		DebugMessage("Object created!!")
	end)
	
-- Adds the command functions to the script table
DefaultCommandFuncs= {
	createScene = function(sceneName)		
		if (sceneName ~= nil) then
			this:SetObjVar("editingScene", sceneName)
		elseif (this:GetObjVar("editingScene") ~= nil) then
			sceneName = this:GetObjVar("editingScene")
		else
			Usage("createScene")
			return
 		end

		this:SystemMessage("You are creating objects in scene: ".. tostring(sceneName))
		this:SystemMessage("You are creating objects in scene: ".. tostring(sceneName), "event")

		showScenePlacableTemplates()
	end,
	deleteScene = function(sceneName)
		if (sceneName ~= nil) then
			deleteSceneObjects(sceneName)
		else
			Usage("deleteScene")
			return
 		end

		this:SystemMessage("All objects in scene " .. tostring(sceneName) .. " have been deleted")
	end,
	loadScene = function(sceneName)
		if (sceneName ~= nil) then
			loadSceneFile(sceneName)
		else
			Usage("loadScene")
			return
 		end
	end,
}






--Allow the command to be used in game by typing it in the text area
RegisterCommand{Command="createScene", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.createScene, Usage="[<sceneName>] is required in command or continue editing last active scene.", Desc="Loads the scene editor for creating static objects that survive a server reset." }
RegisterCommand{Command="deleteScene", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.deleteScene, Usage="[<sceneName>] is required in command", Desc="Destroys all objects in the sceneName provided. Does not delete the scene file." }
RegisterCommand{Command="loadScene", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.loadScene, Usage="[<sceneName>] is required in command and must match file name in scenes folder", Desc="Loads the named scene from the sceneName.xml file in the scenes directory." }

