--pehq
assert(plugin, "This script must be run as a plugin!")
local HttpService = game:GetService("HttpService")
local Selection = game:GetService("Selection")

local PluginEnviroment = script.Parent
local Modules = PluginEnviroment.Modules

local toolbar:PluginToolbar = plugin:CreateToolbar("OSMOSIS-PLY")
local toolbarButton:PluginToolbarButton = toolbar:CreateButton("OSMOSIS-PLY", "Use the OSMOSIS-PLY file format", "http://www.roblox.com/asset/?id=111932722305543")

local RigToTable = require(Modules.RigToTable)

local function sendJSON(json)
	local url = "http://127.0.0.1:5000/process_json" -- Replace with your server's URL

	-- Send the POST request
	local success, response = pcall(function()
		return HttpService:RequestAsync({
			Url = url,
			Method = "POST",
			Headers = {
				["Content-Type"] = "application/json", -- Specify JSON content type
			},
			Body = json, -- Send the JSON string
		})
	end)

	if success and response.Success then
		print("Response from server:", response.Body)
	else
		warn("Failed to send JSON:", response and response.StatusCode or "Unknown error")
	end
end


local function OnClick()
	local selected = Selection:Get()
	local Model = selected[1] 
	if Model:IsA("Model") == false then
		return
	end
	
	local Json = HttpService:JSONEncode(RigToTable.Tablefy(Model))
	sendJSON(Json)
end

toolbarButton.Click:Connect(OnClick)