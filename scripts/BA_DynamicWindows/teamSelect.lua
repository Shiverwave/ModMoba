DefaultCommandFuncs= {
	selectTeam = function()
	local TeamSelectionWindow = DynamicWindow("teamSelection", "Team Selection", 450, 200)
	TeamSelectionWindow:AddButton(6,20,"Team1","Garnet",200,120,"Join Team Garnet","",true)
	TeamSelectionWindow:AddButton(223,20,"Team2","Emerald",200,120,"Join Team Emerald","",true)
	this:OpenDynamicWindow(TeamSelectionWindow)
	end,
	
	shop = function()
	local ShopWindow = DynamicWindow("shopSelection", "Shop", 200, 500)
	ShopWindow:AddButton(120,20,"purchase","Buy",50,25,"Purchase [name]","",false)
	this:OpenDynamicWindow(ShopWindow)
	end,
}

RegisterEventHandler(EventType.DynamicWindowResponse,"teamSelection",
	function (user,returnId)
		if(returnId ~= nil) then
			action = returnId
			if(action == "Team1") then
				this:SystemMessage("Adding "..this:GetName().." to Team Garnet...")
				local teamName = this:GetObjVar("Team")
				local nameColor = COLORS[Green]
				user:SetObjVar("NameColorOverride",nameColor)
				user:SendMessage("UpdateName")
				user:SystemMessage("You have joined the Team Garnet")
			elseif(action == 'Team2') then
				this:SystemMessage("Adding "..this:GetName().." to Team Emerald...")
				local teamName = this:GetObjVar("Team")
				local nameColor = COLORS[Yellow]
				user:SetObjVar("NameColorOverride",nameColor)
				user:SendMessage("UpdateName")
				user:SystemMessage("You have joined the Team Emerald")
			end
	end
end)

RegisterCommand{Command="selectTeam", Category = "God Power", AccessLevel = AccessLevel.Mortal, Func=DefaultCommandFuncs.selectTeam, Usage="[No extra argument required]", Desc="Opens a window for the user to select their team" }
RegisterCommand{Command="shop", Category = "God Power", AccessLevel = AccessLevel.Mortal, Func=DefaultCommandFuncs.shop, Usage="[No extra argument required]", Desc="Opens a test window" }