require 'default:player'

-- DAB NOTE: Don't do anything in login world
if(GetWorldName()=="Login") then
	return
end

require 'base_test_player'


RegisterEventHandler(EventType.Timer,"delayed_init",
	function ()		
		OnTestPlayerLoad()
	end)

RegisterEventHandler(EventType.UserLogout,"", 
	function (logoutType)
		if (logoutType == "Disconnect") then
		    -- let people log out instantly
		    CallFunctionDelayed(TimeSpan.FromSeconds(1),function() this:CompleteLogout() end)
		end
	end)

this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"delayed_init")