DefaultCommandFuncs= {
	selectTeam = function(dontUse)
	this:SystemMessage("Command beginning to run")
		if (dontUse ~= nil) then
			local TeamSelectionWindow = DynamicWindow(
			"teamSelection", --(string) Window ID used to uniquely identify the window. It is returned in the DynamicWindowResponse event.
			"Team Selection", --(string) Title of the window for the client UI
			450, --(number) Width of the window
			200, --(number) Height of the window
			600, --(number) Starting X position of the window (chosen by client if not specified)
			600 --(number) Starting Y position of the window (chosen by client if not specified)
			)
			TeamSelectionWindow:AddImage(40,12,"TitleBackground",250,0,"Sliced")
			TeamSelectionWindow:AddButton(30,16,"CatLeft:","",0,0,"","",false,"LeftArrow")
			TeamSelectionWindow:AddButton(280,16,"CatRight:","",0,0,"","",false,"RightArrow")
			TeamSelectionWindow:AddButton(310, 8, "SelectCat:", "Back", 100, 0, "", "", false, "")
		else
			Usage("selectTeam")
			return
 		end
		this:SystemMessage("Command Successfully Run")
	end,
}
RegisterCommand{Command="selectTeam", Category = "God Power" , AccessLevel = AccessLevel.Mortal, Func=DefaultCommandFuncs.teamSelect, Usage="nothing yet", Desc="Opens a window for the user to select their team" }