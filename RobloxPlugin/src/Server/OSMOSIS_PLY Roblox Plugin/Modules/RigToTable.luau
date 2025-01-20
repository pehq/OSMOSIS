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
		Parts = {},
		Motor6Ds = {},
	}
	
	for i, v in pairs(Model:GetDescendants()) do
		if v:IsA("BasePart") then
			table.insert(TableResult.Parts, v)
		elseif v:IsA("Motor6D") then
			TableResult.Motor6Ds[v.Name] = {
				Part0 = v.Part0.Name,
				Part1 = v.Part1.Name,
				C0 = v.C0,
				C1 = v.C1,
			}
		end
	end
	
	return TableResult
end

return Tablefy
