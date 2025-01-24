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
	local url = "http://127.0.0.1:5000/process_json"

	--POST request
	local success, response = pcall(function()
		return HttpService:RequestAsync({
			Url = url,
			Method = "POST",
			Headers = {
				["Content-Type"] = "application/json",
			},
			Body = json,
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
	local Model, Anim = selected[1], selected[2] 
	if Model:IsA("Model") == false or Anim:IsA("KeyframeSequence") == false then
		return warn("Not sent, check selection!")
	end
	
	local Json = HttpService:JSONEncode(RigToTable.Tablefy(Model, Anim))
	sendJSON(Json)
end

toolbarButton.Click:Connect(OnClick)