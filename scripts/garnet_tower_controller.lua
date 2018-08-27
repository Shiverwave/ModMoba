RegisterEventHandler(EventType.ModuleAttached,"garnet_tower_controller",
	function ( ... )
		CreatePrefab("GarnetTower",this:GetLoc(), this:GetRotation())
	end)