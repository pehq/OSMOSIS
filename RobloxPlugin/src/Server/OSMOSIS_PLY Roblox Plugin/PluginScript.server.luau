--pehq
assert(plugin, "This script must be run as a plugin!")
local HttpsService = game:GetService("HttpService")
local Selection = game:GetService("Selection")

local PluginEnviroment = script.Parent
local PluginIcon = "rbxassetid://83087380766561"
local Modules = PluginEnviroment.Modules

local toolbar:PluginToolbar = plugin:CreateToolbar("OSMOSIS-PLY")
local toolbarButton:PluginToolbarButton = toolbar:CreateButton("OSMOSIS-PLY", "Use the OSMOSIS-PLY file format")

local RigToTable = require(Modules.RigToTable)

local Url = "localhost:8000"

local function OnClick()
	local selected = Selection:Get()
	if selected[1]:IsA("Model") == false then
		return
	end
	
	local Json = HttpsService:JSONEncode(RigToTable.Tablefy(selected))
	
	HttpsService:PostAsync(Url, Json, Enum.HttpContentType.ApplicationJson, true, {})
end

toolbarButton.Click:Connect(OnClick)