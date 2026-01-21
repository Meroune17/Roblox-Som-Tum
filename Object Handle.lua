local ServerStorage = game:GetService("ServerStorage")
local pickupPart = script.Parent
local itemName = " name item " -- ชื่อ Tool ใน ServerStorage

-- สร้าง ProximityPrompt
local prompt = Instance.new("ProximityPrompt")
prompt.Parent = pickupPart
prompt.ActionText = " name "
prompt.HoldDuration = 0.5
prompt.MaxActivationDistance = 10

prompt.Triggered:Connect(function(player)
	local item = ServerStorage:FindFirstChild(itemName)
	if item then
		local clone = item:Clone()
		clone.Parent = player:WaitForChild("Backpack")
	end
end)
