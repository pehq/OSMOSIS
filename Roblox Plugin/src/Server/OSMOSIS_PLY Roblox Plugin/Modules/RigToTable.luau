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

function Tablefy.Tablefy(Model:Model)
	CheckIfModelIsGood(Model) --> don't be dumb
	
	local TableResult = {
		Name = Model.Name,
		Parts = {},
		Motor6Ds = {},
		KeyframeSequence = Model:FindFirstChild("AnimSaves") and {} or nil
	}
	
	for i, v in pairs(Model:GetDescendants()) do
		if v:IsA("BasePart") then
			table.insert(TableResult.Parts, v.Name)
		elseif v:IsA("Motor6D") then
			TableResult.Motor6Ds[v.Name] = {
				Part0 = v.Part0.Name,
				Part1 = v.Part1.Name,
				C0 = {v.C0:GetComponents()},
				C1 = {v.C1:GetComponents()},
			}
		end
	end
	
	if TableResult.KeyframeSequence ~= nil then
		local KeyframeSequenceList = {}
		
		local AnimSavesContainer = Model:FindFirstChild("AnimSaves")
		local AnimSavesKeys = AnimSavesContainer:GetChildren()
		table.move(AnimSavesKeys, 1, #AnimSavesKeys, #KeyframeSequenceList + 1, KeyframeSequenceList)
		if AnimSavesContainer:IsA("ObjectValue") then
			local AnimSavesKeys = AnimSavesContainer:GetChildren()
			table.move(AnimSavesKeys, 1, #AnimSavesKeys, #KeyframeSequenceList + 1, KeyframeSequenceList)
		end
		
		for i, v:KeyframeSequence in ipairs(KeyframeSequenceList) do
			print(string.format("%i / %i", i, #KeyframeSequenceList)); task.wait();
			
			TableResult.KeyframeSequence[v.Name] = {
				Loop = v.Loop,
				Priority = v.Priority.Name,
				Keyframes = {}
			}
			for j, Keyframe in ipairs(v:GetChildren()) do
				TableResult.KeyframeSequence[v.Name].Keyframes[j] = {
					Poses = {},
					Time = Keyframe.Time,
				}
				for k, Pose:Pose in ipairs(Keyframe:GetDescendants()) do
					if Pose:IsA("Pose") == false then
						continue
					end
					TableResult.KeyframeSequence[v.Name].Keyframes[j].Poses[Pose.Name] = {
						["CFrame"] = {Pose.CFrame:GetComponents()},
						EasingDirection = Pose.EasingDirection.Name,
						EasingStyle = Pose.EasingStyle.Name,
						Weight = Pose.Weight, -- ???
						Part0 = Pose.Parent.Name,
						Part1 = Pose.Name
					}
				end
			end
		end
	end
	
	return TableResult
end

return Tablefy
