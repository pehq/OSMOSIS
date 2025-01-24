--Pehq
local Tablefy = {}

local function CheckIfModelIsGood(Model:Model)
	local PartCount = 0
	local Motor6DCount = 0
	
	local Motor6Ds = {}
	
	for i, v in pairs(Model:GetDescendants()) do
		if v:IsA("BasePart") then
			if v.Parent ~= Model then
				return error(v.Name .." is not parented to the model. All parts should be parented to the model.")
			end
			
			PartCount += 1
		elseif v:IsA("Motor6D") then
			if v.Part0 == nil or v.Part1 == nil then
				return error(v.Name .." is missing a part.")
			end
			if table.find(Motor6Ds, v.Name) ~= nil then
				return error(v.Name .." is duplicated.")
			end
			Motor6DCount += 1
		end		
	end
end

function Tablefy.Tablefy(Model:Model, KeyframeSequence:KeyframeSequence)
	CheckIfModelIsGood(Model) --> don't be dumb
	
	local Progress, MaxProgress = 0, #Model:GetChildren() + #Model:GetDescendants() + (KeyframeSequence ~= nil and #KeyframeSequence:GetDescendants() or 0) + 1
	
	local DominantPart = nil
	for i, v:BasePart in ipairs(Model:GetChildren()) do
		task.wait(); Progress += 1; print(Progress.. "/".. MaxProgress);

		if v:IsA("BasePart") == false then
			continue
		end
		if v.Name == "HumanoidRootPart" then
			DominantPart = v
			break
		end
		if DominantPart == nil then
			DominantPart = v
		elseif v.RootPriority > DominantPart.RootPriority then
			DominantPart = v
		end
	end
	Progress = #Model:GetChildren()
	
	local TableResult = {
		["Header"] = {
			["Motor6Ds"] = {},
			["RigName"] = Model.Name,
			["Parts"] = {},
			["RootPart"] = DominantPart,
			["FPS"] = 60
		},
		["KeyframeSequence"] = KeyframeSequence and {} or nil
	}
	
	for i, v in pairs(Model:GetDescendants()) do
		task.wait(); Progress += 1; print(Progress.. "/".. MaxProgress);
		
		if v:IsA("BasePart") then
			TableResult.Header.Parts[v.Name] = {
				["CFrame"] = {v.CFrame:GetComponents()},
				["Size"] = {v.Size.X, v.Size.Y, v.Size.Z},
			}
		elseif v:IsA("Motor6D") then
			TableResult.Header.Motor6Ds[v.Name] = {
				Part0 = v.Part0.Name,
				Part1 = v.Part1.Name,
				C0 = {v.C0:GetComponents()},
				C1 = {v.C1:GetComponents()},
			}
		end
	end
	
	if TableResult.KeyframeSequence == nil then
		return TableResult
	end

	for j, Keyframe in ipairs(KeyframeSequence:GetChildren()) do
		task.wait(); Progress += 1; print(Progress.. "/".. MaxProgress);
		
		TableResult.KeyframeSequence[Keyframe.Time] = {}
		for k, Pose:Pose in ipairs(Keyframe:GetDescendants()) do
			task.wait(); Progress += 1; print(Progress.. "/".. MaxProgress);

			if Pose:IsA("Pose") == false then
				continue
			end
			TableResult.KeyframeSequence[Keyframe.Time][Pose.Name] = {
				["CFrame"] = {Pose.CFrame:GetComponents()},
				["Part0"] = Pose.Name ~= Model.PrimaryPart and Pose.Parent.Name or nil,
				["Part1"] = Pose.Name ~= Model.PrimaryPart and Pose.Name or nil,
				["EasingDirection"] = Pose.EasingDirection.Name,
				["EasingStyle"] = Pose.EasingStyle.Name,
			}
		end
	end
	
	return TableResult
end

return Tablefy