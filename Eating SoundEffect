local tool = script.Parent
local isEating = false 

-- ==========================================
-- ตั้งค่า (Config)
-- ==========================================
local eatTime = 1.0  
local healAmount = 20 

-- ID ท่ากิน (ใส่ไว้ทั้ง 2 แบบ กันพลาด)
local animId_R15 = "rbxassetid://507768375" -- ท่าสำหรับ R15 (ตัวมีศอก/เข่า)
local animId_R6 = "rbxassetid://180435571"  -- ท่าสำหรับ R6 (ตัวเหลี่ยมคลาสสิก)

tool.Activated:Connect(function()
	if isEating then return end
	isEating = true

	local character = tool.Parent
	local humanoid = character:FindFirstChild("Humanoid")
	local handle = tool:FindFirstChild("Handle")

	if humanoid and handle then
		-- 1. เล่นเสียง (ถ้ามี)
		local sound = handle:FindFirstChild("EatSound")
		if sound then sound:Play() end

		-- 2. เช็คประเภทตัวละคร แล้วเลือกท่าที่ถูก
		local anim = Instance.new("Animation")

		if humanoid.RigType == Enum.HumanoidRigType.R15 then
			anim.AnimationId = animId_R15 -- ถ้าเป็น R15
			print("Detected R15: Playing R15 Animation")
		else
			anim.AnimationId = animId_R6  -- ถ้าเป็น R6
			print("Detected R6: Playing R6 Animation")
		end

		-- 3. โหลดและเล่นท่า (ใช้ Animator เพื่อความชัวร์)
		local animator = humanoid:FindFirstChild("Animator") or humanoid
		local track = animator:LoadAnimation(anim)

		track.Priority = Enum.AnimationPriority.Action -- บังคับให้ท่านี้สำคัญสุด
		track:Play()
		track:AdjustSpeed(2.5) -- เร่งความเร็ว (ยัดเข้าปาก!)

		-- 4. รอเวลาเคี้ยว
		task.wait(eatTime)

		-- 5. เพิ่มเลือดและลบของ
		if humanoid.Health < humanoid.MaxHealth then
			humanoid.Health = math.min(humanoid.Health + healAmount, humanoid.MaxHealth)
		end

		track:Stop()
		if sound then sound:Stop() end
		tool:Destroy()
	end
end)
