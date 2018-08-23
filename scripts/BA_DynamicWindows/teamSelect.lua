DefaultCommandFuncs= {
	selectTeam = function()
	this:SystemMessage("Command beginning to run")
	local TeamSelectionWindow = DynamicWindow("teamSelection", "Team Selection", 450, 200)
	TeamSelectionWindow:AddButton(6,20,"Team1","Garnet",200,120,"Join Team Garnet","",true)
	TeamSelectionWindow:AddButton(223,20,"Team2","Emerald",200,120,"Join Team Emerald","",true)
	this:OpenDynamicWindow(TeamSelectionWindow)
	end,
	
	shop = function()
	this:SystemMessage("Command beginning to run")
	local ShopWindow = DynamicWindow("shopSelection", "Shop", 200, 500)
	ShopWindow:AddButton(120,20,"purchase","Buy",50,25,"Purchase [name]","",false)
	this:SystemMessage("Command Successfully Run")
	this:OpenDynamicWindow(ShopWindow)
	end,
}

RegisterEventHandler(EventType.DynamicWindowResponse,"teamSelection",
	function (user,returnId)
		if(returnId ~= nil) then
			action = returnId
			if(action == "Team1") then
				this:SystemMessage("Adding "..this:GetName().." to Team Garnet...")
				local MobaTeam = 1
			--set this:player to team garnet - dont think this exists in the game right now. ie; temp_twotowers_teammaker.lua is not functional.
			elseif(action == 'Team2') then
				this:SystemMessage("Adding "..this:GetName().." to Team Emerald...")
				local MobaTeam = 2
			--set this:player to team emerald
		end
	end
	this:SystemMessage("Command Successfully Run")
end)

RegisterCommand{Command="selectTeam", Category = "God Power", AccessLevel = AccessLevel.Mortal, Func=DefaultCommandFuncs.selectTeam, Usage="[No extra argument required]", Desc="Opens a window for the user to select their team" }
RegisterCommand{Command="shop", Category = "God Power", AccessLevel = AccessLevel.Mortal, Func=DefaultCommandFuncs.shop, Usage="[No extra argument required]", Desc="Opens a test window" }