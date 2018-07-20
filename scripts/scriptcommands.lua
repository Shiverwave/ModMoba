require 'default:scriptcommands'

createTemplates = 
{
	"leather_suit",
	"padded_suit",
	"plate_suit",
	"bag_of_weapons",
	"all_spells",
	"test_all_blueprints",
	"resource_bag_raw",
	"resource_bag_refined",
	"gate_stone",
	"reagant_bag"
}

templateListPage = 1
function ShowMortalCreateTemplates()
	local newWindow = DynamicWindow("MortalCreateTemplateList","Test Server Create",410,400)
	local x = 20
	local y = 10
	local rowIndex = 1
	local itemsPerPage = 18
	local startIndex = ((templateListPage-1) * itemsPerPage) + 1
	local commandIndex = 1

	local createSorted = {}
	for i,createTemplate in ipairs(createTemplates) do	
		entryName = StripColorFromString(GetTemplateObjectName(createTemplate))
		if(entryName == nil or entryName == "") then
			entryName = createTemplate
		end	
		table.insert(createSorted,{EntryName=entryName,CreateTemplate=createTemplate})
	end
	table.sort(createSorted,function(a,b) return a.EntryName < b.EntryName end)

	for i,create in ipairs(createSorted) do		
		if( commandIndex >= startIndex  and commandIndex < startIndex + itemsPerPage) then
			tooltip = ""
			
			newWindow:AddButton(x, y, "create:"..create.CreateTemplate,create.EntryName, 350, 0, "", "", false)
			if( rowIndex == 1 ) then
				x = 20
				y = y + 30
				rowIndex = 1
			else
				x = x + 200
				rowIndex = 1
			end			
		end
		commandIndex = commandIndex + 1
	end
	
	if( templateListPage > 1 ) then
		newWindow:AddButton(180, 580, "UserListPrev:", "Previous", 100, 0, "", "", false)
	end
	if( templateListPage <= (commandIndex-1) / itemsPerPage) then
		newWindow:AddButton(300, 580, "UserListNext:", "Next", 100, 0, "", "", false)
	end
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

TestServerCommandFuncs = 
{
	Create = function(templateName)
		if(IsDemiGod(this)) then
			DefaultCommandFuncs.Create(templateName)
		else
			ShowMortalCreate()
		end
	end,
}

RegisterCommand{ Command="jump", AccessLevel = AccessLevel.Mortal, Func=DefaultCommandFuncs.Jump, Desc="Get a cursor for a location to jump to" }
RegisterCommand{ Command="template", AccessLevel = AccessLevel.Mortal, Func=DefaultCommandFuncs.Template, Usage="<warrior|rogue|mage|hybrid> <beginner|veteran|expert>", Desc="Sets your skills and stats to match the specified template and level" }
RegisterCommand{ Command="setskill", AccessLevel = AccessLevel.Mortal, Func=DefaultCommandFuncs.SetSkill, Usage="<skill_name> <value> [<target_id>]", "Set the skill level of a mobile specified by target_id (defaults to self)" }
RegisterCommand{ Command="create", AccessLevel = AccessLevel.Mortal, Func=TestServerCommandFuncs.Create, Desc="Opens Test Server create window." }
RegisterCommand{ Command="setstat", AccessLevel = AccessLevel.Mortal, Func=DefaultCommandFuncs.SetStat, Usage="<hp|mana|sta|str|agi|int> <value> [<target_id>]", Desc="Set the stat value for a given mob. No id specfied defaults to self" }
RegisterCommand{ Command="createcoins", AccessLevel = AccessLevel.Mortal, Func=DefaultCommandFuncs.CreateCoins, Usage="<amount>", Desc="Create a bag of coins in your backpack" }
RegisterCommand{ Command="showxp", AccessLevel = AccessLevel.Mortal, Func=DefaultCommandFuncs.ShowXP, Desc="XP gains are shown overhead." }
RegisterCommand{ Command="gotolocation", AccessLevel = AccessLevel.Mortal, Func=DefaultCommandFuncs.Goto, Usage="[<x>] [<y>] [<z>]", Desc="[$2477]", Aliases={"goto"}}