local newWindow = DynamicWindow(
	"teamSelection", --(string) Window ID used to uniquely identify the window. It is returned in the DynamicWindowResponse event.
	"Team Selection", --(string) Title of the window for the client UI
	450, --(number) Width of the window
	200, --(number) Height of the window
	600, --(number) Starting X position of the window (chosen by client if not specified)
	600, --(number) Starting Y position of the window (chosen by client if not specified)
)
RegisterCommand{Command="SelectTeam", Category = "God Power", AccessLevel = AccessLevel.Mortal, Func=DefaultCommandFuncs.teamSelect, Usage="nothing yet", Desc="Opens a window for the user to select their team" }