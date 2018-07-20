createTemplates = 
{
	"all_tools",
	"resource_bag_metalsmith_raw",
	"resource_bag_metalsmith_refined",
	"resource_bag_fabrication_raw",
	"resource_bag_fabrication_refined",
	"resource_bag_carpentry_refined",
	"resource_bag_carpentry_raw",
	"resource_bag_inscription",
	"resource_bag_cooking",
	"spellbook_full",
	"reagent_bag",
	"healing_bag",	
	"all_blueprints"
}

templateListPage = 1
function ShowMortalCreateTemplates()
	local newWindow = DynamicWindow("MortalCreateTemplateList","Test Server Create",410,400)

	local createSorted = {}
	for i,createTemplate in ipairs(createTemplates) do	
		entryName = StripColorFromString(GetTemplateObjectName(createTemplate))
		if(entryName == nil or entryName == "") then
			entryName = createTemplate
		end	
		table.insert(createSorted,{EntryName=entryName,CreateTemplate=createTemplate})
	end
	table.sort(createSorted,function(a,b) return a.EntryName < b.EntryName end)

	local createList = ScrollWindow(8,8,360,340,30)
	for i,create in ipairs(createSorted) do		
		tooltip = ""
		local createElement = ScrollElement()
		createElement:AddButton(0, 0, "create:"..create.CreateTemplate,create.EntryName, 350, 0, "", "", false)

		createList:Add(createElement)	
	end
	newWindow:AddScrollWindow(createList)
	
	this:OpenDynamicWindow(newWindow)
end

function DoCreate(templateId)
	local weight = GetTemplateObjectProperty(templateId,"Weight")

	if(weight == -1) then
		CreatePackedObject(this,templateId)		
	else
		CreateObjInBackpackOrAtLocation(this, templateId)		
	end

	entryName = StripColorFromString(GetTemplateObjectName(templateId))
	if(entryName == nil or entryName == "") then
		entryName = templateId
	end	
	this:SystemMessage(entryName.. " created in your backpack.")
end

RegisterEventHandler(EventType.DynamicWindowResponse,"MortalCreateTemplateList",
	function (user,returnId)
		if(returnId ~= nil) then
			action, template = string.match(returnId, "(%a+):([%a_%d]*)")
			if(action == "create") then				
				if( template ~= nil ) then
					DoCreate(template)
				end
			elseif(action == "UserListNext") then
				templateListPage = templateListPage + 1
				ShowMortalCreateTemplates()
			elseif( action == "UserListPrev") then
				templateListPage = templateListPage - 1
				ShowMortalCreateTemplates()			
			end
		end	
	end)

function ShowMortalCreate()
	templateListPage = 1
	ShowMortalCreateTemplates()
end

function ShowTestServerDialog()
	local welcomeWindow = DynamicWindow("Welcome","Welcome to TestServer",600,200)
	welcomeWindow:AddLabel(20,20,"This server gives you the power to alter your character and create cetain items to make it easier to test specific systems. Please do not abuse these powers.",540,0,18)
	welcomeWindow:AddButton(20,70,"EditChar","Edit Character",540,0,"","",false)
	welcomeWindow:AddButton(20,110,"Create","Create Items",540,0,"","",false)

	this:OpenDynamicWindow(welcomeWindow,this)
end
RegisterEventHandler(EventType.DynamicWindowResponse,"Welcome", 
	function (user,buttonId)
		if(buttonId == "EditChar") then
			OpenCharEditWindow(this)
		elseif(buttonId == "Create") then
			ShowMortalCreate()
		end
	end)

function OnTestPlayerLoad()	
	local testWindow = DynamicWindow("TestUI","",50,50,-370,50,"Transparent","TopRight")
	testWindow:AddButton(0,0,"Control","TestServer Menu",0,20,"","",false,"SimpleButton")
	this:OpenDynamicWindow(testWindow)
end

RegisterEventHandler(EventType.DynamicWindowResponse,"TestUI",
	function (user,buttonId)
		if(buttonId == "Control") then
			ShowTestServerDialog()
		end
	end)