local krok = script.Parent
local prompt = krok:WaitForChild("ProximityPrompt")
local ServerStorage = game:GetService("ServerStorage") 

-- ==========================================
-- 1. ตั้งค่าตัวแปร (Config)
-- ==========================================
local ingredients = {
	Var1 = "Pepper",
	Var2 = "Garlic",
	Var3 = "MeshPart",
	Var4 = "Noodles",  -- ย้ายไปใส่ขั้นตอนสุดท้าย
	Var5 = "Tomato",
	Var6 = "Soy Sauce",
	Var7 = "Lime",
	Var8 = "Vegetable"
}

-- ตัวแปรเก็บสถานะขั้นตอน (1-4) *เพิ่มกลับเป็น 4 ขั้นตอน
local currentStep = 1

-- ตารางเช็คของ Step 1
local step1Progress = { [ingredients.Var1] = false, [ingredients.Var2] = false }

-- ตารางเช็คของ Step 3 (เอา Noodles ออกไปไว้ Step 4)
local step3Progress = { 
	[ingredients.Var5] = false, 
	[ingredients.Var6] = false, 
	[ingredients.Var7] = false 
}
local step3OptionalAdded = false 

-- ตั้งค่าเริ่มต้น
prompt.ActionText = "Add Pepper & Garlic"
prompt.HoldDuration = 0

-- ==========================================
-- ฟังก์ชันหลัก (Main Logic)
-- ==========================================
prompt.Triggered:Connect(function(player)
	local heldTool = player.Character:FindFirstChildWhichIsA("Tool")

	-- ######################################
	-- STEP 1: ใส่ Pepper & Garlic -> กดค้าง 3 วิ
	-- ######################################
	if currentStep == 1 then
		if prompt.HoldDuration == 0 then
			if heldTool and step1Progress[heldTool.Name] ~= nil then
				if step1Progress[heldTool.Name] == false then
					heldTool:Destroy()
					step1Progress[heldTool.Name] = true
					print("Added Step 1 Item: " .. heldTool.Name)
				end
			end

			local allAdded = true
			for _, v in pairs(step1Progress) do if not v then allAdded = false break end end

			if allAdded then
				prompt.ActionText = "Pound (Tum)"
				prompt.HoldDuration = 3
			end

		elseif prompt.HoldDuration == 3 then
			krok.Name = "Crushed Pepper"
			currentStep = 2
			prompt.HoldDuration = 3 -- เวลาสำหรับ Step 2
			prompt.ActionText = "Add " .. ingredients.Var3
			print("--- Entered Step 2 ---")
		end

		-- ######################################
		-- STEP 2: ใส่ MeshPart -> กดค้าง 3 วิ
		-- ######################################
	elseif currentStep == 2 then
		if heldTool and heldTool.Name == ingredients.Var3 then
			heldTool:Destroy()
			krok.Name = "Crushed Dried Garlic + Lime + Tomato"
			currentStep = 3
			prompt.HoldDuration = 0
			prompt.ActionText = "Add Ingredients (Mix)"
			print("--- Entered Step 3 ---")
		end

		-- ######################################
		-- STEP 3: ปรุงน้ำ (Tomato, Soy Sauce, Lime) -> กดค้าง 3 วิ -> ไปรอใส่เส้น
		-- ######################################
	elseif currentStep == 3 then
		-- 3.1 ใส่เครื่องปรุง (ยกเว้นเส้น)
		if prompt.HoldDuration == 0 then
			if heldTool then
				if step3Progress[heldTool.Name] ~= nil and step3Progress[heldTool.Name] == false then
					heldTool:Destroy()
					step3Progress[heldTool.Name] = true
					print("Added Main: " .. heldTool.Name)
				elseif heldTool.Name == ingredients.Var8 and not step3OptionalAdded then
					heldTool:Destroy()
					step3OptionalAdded = true
					print("Added Optional: " .. heldTool.Name)
				end
			end

			local allRequired = true
			for _, v in pairs(step3Progress) do if not v then allRequired = false break end end

			if allRequired then
				prompt.ActionText = "Mix Sauce"
				prompt.HoldDuration = 3 
			end

			-- 3.2 คนน้ำเสร็จ -> ไป Step 4
		elseif prompt.HoldDuration == 3 then
			krok.Name = "Som Tum Base" -- เปลี่ยนชื่อเป็นน้ำส้มตำ (รอเส้น)
			currentStep = 4
			prompt.HoldDuration = 0 -- กลับมาเป็นกดคลิกเพื่อใส่เส้น
			prompt.ActionText = "Add Final: " .. ingredients.Var4 -- บอกให้ใส่ Noodles
			print("--- Entered Step 4 (Waiting for Noodles) ---")
		end

		-- ######################################
		-- STEP 4: ใส่ Noodles -> จบงานทันที
		-- ######################################
	elseif currentStep == 4 then
		if heldTool and heldTool.Name == ingredients.Var4 then -- เช็คว่าเป็น Noodles หรือไม่
			heldTool:Destroy()
			krok.Name = "Tam Sua"

			-- [รับรางวัล]
			local targetDish = ServerStorage:FindFirstChild("Tam Sua")

			if targetDish then
				local finishedDish = targetDish:Clone()
				finishedDish.Parent = player.Backpack
				print("--- MISSION COMPLETE: Received Tam Sua ---")
			else
				warn("Error: ไม่เจอ Tool ชื่อ 'Tam Sua' ใน ServerStorage!")
			end

			-- รีเซ็ตระบบ
			wait(3)
			krok.Name = "Krok"
			currentStep = 1
			prompt.HoldDuration = 0
			prompt.ActionText = "Add Pepper & Garlic"

			for k in pairs(step1Progress) do step1Progress[k] = false end
			for k in pairs(step3Progress) do step3Progress[k] = false end
			step3OptionalAdded = false
		else
			-- แจ้งเตือนถ้าใส่ผิดอันในขั้นตอนสุดท้าย
			game.StarterGui:SetCore("SendNotification", {Title = "ผิดพลาด"; Text = "ขั้นตอนสุดท้ายต้องใส่ " .. ingredients.Var4;})
		end
	end
end)
