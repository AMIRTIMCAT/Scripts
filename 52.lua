local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")
local bases = Workspace:WaitForChild("Bases")

local originalPosition = hrp.Position -- 🧭 Точка возврата

-- 📢 Быстрое уведомление
local function notify(text, color)
	local gui = Instance.new("ScreenGui")
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.Parent = player:WaitForChild("PlayerGui")

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0, 400, 0, 45)
	label.Position = UDim2.new(0.5, -200, 0.12, 0)
	label.BackgroundColor3 = color
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Font = Enum.Font.GothamBold
	label.TextScaled = true
	label.BackgroundTransparency = 0.1
	label.Text = text
	label.Parent = gui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = label

	TweenService:Create(label, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundTransparency = 0
	}):Play()

	task.delay(0.6, function()
		TweenService:Create(label, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
		task.wait(0.3)
		gui:Destroy()
	end)
end

-- 🚀 Телепорт
local function teleportTo(position)
	humanoid:MoveTo(position)
	hrp.CFrame = CFrame.new(position)
end

-- 🔍 Поиск ближайшего ProximityPrompt
local function findNearestPrompt(originPos, maxDistance)
	local prompt, distMin = nil, maxDistance or 15
	for _, obj in ipairs(Workspace:GetDescendants()) do
		if obj:IsA("ProximityPrompt") and obj.Enabled then
			local parent = obj.Parent
			if parent:IsA("BasePart") then
				local dist = (parent.Position - originPos).Magnitude
				if dist < distMin then
					distMin, prompt = dist, obj
				end
			end
		end
	end
	return prompt
end

-- ⚡ Основное действие
for _, base in ipairs(bases:GetChildren()) do
	if base:IsA("Model") then
		local slots = base:FindFirstChild("Slots")
		if slots then
			for _, slot in ipairs(slots:GetChildren()) do
				for _, model in ipairs(slot:GetChildren()) do
					if model:IsA("Model") and string.match(string.lower(model.Name), " femboy$") then
						local pos
						if model.PrimaryPart then
							pos = model.PrimaryPart.Position
						else
							local part = model:FindFirstChildWhichIsA("BasePart", true)
							pos = part and part.Position or Vector3.new(0, 0, 0)
						end

						-- ✨ Телепорт + уведомление
						notify("✨ Телепорт к цели...", Color3.fromRGB(0, 170, 255))
						teleportTo(pos + Vector3.new(0, 4, 0))

						task.wait(0.15)
						local prompt = findNearestPrompt(pos, 18)
						if prompt then
							fireproximityprompt(prompt)
							notify("💸 Украдено!", Color3.fromRGB(0, 200, 0))
						end

						task.wait(0.2)
						notify("🏠 Возврат на базу!", Color3.fromRGB(255, 170, 0))
						teleportTo(originalPosition + Vector3.new(0, 4, 0))

						return
					end
				end
			end
		end
	end
end

warn("❌ Не найдено 'femboy'")
