-- This is where each item's information is stored and will be grabbed in order to display in the shop menu
shopItems = {
				{ItemName="Dagger", ItemPrice=15, ItemID="weapon_dagger",};
				{ItemName="Sword", ItemPrice=42, ItemID="weapon_longsword",};
				{ItemName="Shield", ItemPrice=80, ItemID="shield_buckler",}
			}

DefaultCommandFuncs= {
--The function that deals with displaying the team selection dynamic window.
	selectTeam = function()
	local TeamSelectionWindow = DynamicWindow("teamSelection", "Team Selection", 450, 230)
	TeamSelectionWindow:AddButton(6,20,"Team1","Garnet",200,120,"Join Team Garnet","",true)
	TeamSelectionWindow:AddButton(223,20,"Team2","Emerald",200,120,"Join Team Emerald","",true)
	TeamSelectionWindow:AddButton(6,150,"LeaveTeam","Leave Team",417,26,"Leave your Team","",true)
	this:OpenDynamicWindow(TeamSelectionWindow)
	end,
--The function that deals with displaying the shop dynamic window.
	shop = function()
	local ShopWindow = DynamicWindow("shopSelection", "Shop", 220, 500)
	local scrollWindow = ScrollWindow(5,3,182,450,40)
--The following for loop creates a box for each row in the shopItems list and assigning it a unique button output.
	for i=1,#shopItems do	
		local scrollElement = ScrollElement()
		scrollElement:AddLabel(7,22,shopItems[i].ItemName,60)
		scrollElement:AddButton(120,20,"purchase item<"..shopItems[i].ItemID..">item row:"..i,shopItems[i].ItemPrice.."G",50,25,"Purchase "..shopItems[i].ItemName.." for "..shopItems[i].ItemPrice.."G","",false)
		scrollWindow:Add(scrollElement)
	end
	
	ShopWindow:AddScrollWindow(scrollWindow)
	this:OpenDynamicWindow(ShopWindow)
	end,
}
--This functions attaches a purpose to each button in the team selection window.
RegisterEventHandler(EventType.DynamicWindowResponse,"teamSelection",
	function (user,returnId)
		if(returnId ~= nil) then
			action = returnId
			if(action == "Team1") then
				this:SystemMessage("Adding "..this:GetName().." to Team Garnet...")
				local nameColor = COLORS["Red"]
				this:SetObjVar("KarmaProtectionEnabled", false)
				this:SetObjVar("NameColorOverride",nameColor)
				this:SendMessage("UpdateName")
				this:SystemMessage("You have joined the Team Garnet")
			elseif(action == 'Team2') then
				this:SystemMessage("Adding "..this:GetName().." to Team Emerald...")
				local nameColor = COLORS["Green"]
				this:SetObjVar("KarmaProtectionEnabled", false)
				this:SetObjVar("NameColorOverride",nameColor)
				this:SendMessage("UpdateName")
				this:SystemMessage("You have joined the Team Emerald")
			elseif(action == 'LeaveTeam') then
				user:DelObjVar("NameColorOverride")
				this:SendMessage("UpdateName")
				this:SystemMessage("You have left your Team")
			end
	end
end)
--This Functions handles the logic behind the shop window User Interface
RegisterEventHandler(EventType.DynamicWindowResponse,"shopSelection",
	function (user,returnId)
	
		if (returnId == "") then --if no message is received
			return
		elseif (returnId ~= nil) then --if a message is recieved
			shopTemplateID = string.match(returnId, "<(.-)>") --extract the templateID from the received string
			itemRow = tonumber(string.match(returnId, "%d+")) --extract the itemRow from the recieved string
			DebugMessage("shopTemplateID = _"..shopTemplateID.."_")
			--DebugMessage("itemRow = _"..itemRow.."_")
			if (CountCoins(user) >= shopItems[itemRow].ItemPrice) then
				RequestConsumeResource(user,"coins", shopItems[itemRow].ItemPrice, "BuyingFromShopWindow", this)
				CreateObjInBackpack(user,shopTemplateID,"fromShop")
				this:SystemMessage("Successfully purchased "..shopItems[itemRow].ItemName.." for "..shopItems[itemRow].ItemPrice.."G. You have "..CountCoins(this).."G Remaining.\n ~Don't forget to equip it!~")
			else
				this:SystemMessage("You need "..(shopItems[itemRow].ItemPrice-CountCoins(this)).. " more to purchase "..shopItems[itemRow].ItemName..".")
				return
			end
		end
	end)
--Creating indexes for the commands in the games system.
RegisterCommand{Command="selectTeam", Category = "God Power", AccessLevel = AccessLevel.Mortal, Func=DefaultCommandFuncs.selectTeam, Usage="[No extra argument required]", Desc="Opens a window for the user to select their team" }
RegisterCommand{Command="shop", Category = "God Power", AccessLevel = AccessLevel.Mortal, Func=DefaultCommandFuncs.shop, Usage="[No extra argument required]", Desc="Opens a test window" }