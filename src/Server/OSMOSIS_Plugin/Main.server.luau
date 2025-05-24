local PluginEnviroment = script.Parent --> The Coregui


local toolbar = plugin:CreateToolbar("OSMOSIS")
local OsmosisButton = toolbar:CreateButton("Run Osmosis", "Launch OSMOSIS", "http://www.roblox.com/asset/?id=111932722305543", "Free and Open-Sourced! <3 ^W^")
OsmosisButton.ClickableWhenViewportHidden = false --no

local widgetInfo = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Float, -- Widget will be initialized in floating panel
	false, -- Widget will be initially enabled
	false, -- Don't override the previous enabled state
	200, -- Default width of the floating window
	300, -- Default height of the floating window
	150, -- Minimum width of the floating window (optional)
	150 -- Minimum height of the floating window (optional)
)

local MainWidget = plugin:CreateDockWidgetPluginGui("PehqOsmosisAnimator", widgetInfo)
MainWidget.Title = "Woaw"

OsmosisButton.Click:Connect(function()
    MainWidget.Enabled = not MainWidget.Enabled
end)