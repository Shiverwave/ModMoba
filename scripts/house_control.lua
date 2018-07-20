require 'test_decorations'
require 'default:house_control'

oldShowDecorateTab = ShowDecorateTab
function ShowDecorateTab(controlWindow)
	oldShowDecorateTab(controlWindow)

	controlWindow:AddButton(2,270,"DecoCreate","Create Decorations",327,0,"(TEST) Create decorations","",false)	
end

oldHandleDecorateWindowResponse = HandleDecorateWindowResponse
function HandleDecorateWindowResponse(user,returnId)
	if not(oldHandleDecorateWindowResponse(user,returnId)) then
		if(returnId == "DecoCreate") then
			templateListPage = 1
			ShowPlacableDecoTemplates(user)
		end
	end

	return false
end