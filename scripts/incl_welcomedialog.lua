require 'default:incl_welcomedialog'

function ShowWelcomeDialog()
	local welcomeWindow = DynamicWindow("Welcome","Welcome to TestServer",600,200)
	welcomeWindow:AddLabel(20,20,"This server has special commands intended to ease with testing of specific systems.",0,0,18)
	welcomeWindow:AddButton(20,60,"Misc","Special Commands",540,0,"","",false)
	welcomeWindow:AddButton(20,100,"Housing","Housing",540,0,"","",false)

	this:OpenDynamicWindow(welcomeWindow,this)
end

function ShowHousingDialog()
	local housingWindow = DynamicWindow("HousingHelp","TestServer Housing",570,550)
	housingWindow:AddLabel(20,20,"Instructions:",0,0,18)
	housingWindow:AddLabel(20,70,"* Use the /create window to obtain a lockbox containing every available housing blueprint\n* Once you place your house, access the house control and decoration windows by using (double-clicking) the house sign\n* You can also access the decorate window with the /deco command if you are on your house plot\n* To create decorations for this test, click the create button on the decorate window\n* Most decorations appear in your inventory in packed form. To unpack them, double click them and click on the location you want to place it.\n* You can fine tune the placement of decorations and pack them back up using the decorate window accessed from the house sign.\n* To see these instructions again use /help\n\nPROTIP: Laying in your bed will bind you to your house.\nPROTIP: Put a trash can in your house so you can easily destroy unneeded items.\nPROTIP: We have enabled the /jump command for mortals to help with the known pathing issues.",500,0,18)
	housingWindow:AddButton(440,440,"","Okay")

	this:OpenDynamicWindow(housingWindow,this)
end

function ShowMiscDialog()
	local miscWindow = DynamicWindow("MiscHelp","TestServer Special Commands",570,300)
	miscWindow:AddLabel(20,20,"Instructions:",0,0,18)
	miscWindow:AddLabel(20,70,"* Use the /create window to get access to weapons/armor/spells\n* Use /template to set your stats/skills to a predefined template (/help template for more info)\n* Use /goto for a list of locations on the server to travel to\n* You can use /setskill to set individual skills. (see /help setskill for more info)\n",500,0,18)
	miscWindow:AddButton(440,200,"","Okay")

	this:OpenDynamicWindow(miscWindow,this)
end

RegisterEventHandler(EventType.DynamicWindowResponse,"Welcome", 
	function (user,buttonId)
		if(buttonId == "Housing") then
			ShowHousingDialog()
		elseif(buttonId == "Misc") then
			ShowMiscDialog()
		end
	end)

RegisterEventHandler(EventType.ClientUserCommand,"help", 
	function (args)
		if(args == nil) then
			ShowWelcomeDialog()
		end
	end)

RegisterEventHandler(EventType.LoadedFromBackup,"", 
	function (user,buttonId)
		ShowWelcomeDialog()
	end)