local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

local bases = Workspace:WaitForChild("Bases")

-- 🧭 Сохраняем точку возврата (твоя база)
local originalPosition = hrp.Position

-- 🧾 Создание GUI уведомления
local function createNotification(text, color)
	local screenGui = Instance.new("ScreenGui")
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true
	screenGui.Name = "TeleportNotification"
	screenGui.Parent = player:WaitForChild("PlayerGui")

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 400, 0, 60)
	frame.Position = UDim2.new(0.5, -200, 0.1, 0)
	frame.BackgroundColor3 = color
	frame.BorderSizePixel = 0
	frame.BackgroundTransparency = 0.2
	frame.Parent = screenGui
	frame.AnchorPoint = Vector2.new(0, 0)

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 15)
	corner.Parent = frame

	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.Text = text
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.Font = Enum.Font.GothamBold
	textLabel.TextScaled = true
	textLabel.BackgroundTransparency = 1
	textLabel.Parent = frame

	-- Анимация появления
	frame.Position = UDim2.new(0.5, -200, 0, -80)
	TweenService:Create(frame, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, -200, 0.1, 0)
	}):Play()

	task.wait(2.5)

	-- Анимация исчезновения
	TweenService:Create(frame, TweenInfo.new(0.6), {
		Position = UDim2.new(0.5, -200, 0, -80),
		BackgroundTransparency = 1,
	}):Play()

	task.wait(0.7)
	screenGui:Destroy()
end

-- 🚀 Телепорт персонажа
local function teleportTo(position)
	humanoid:MoveTo(position)
	task.wait(0.2)
	hrp.CFrame = CFrame.new(position)
end

-- 🔍 Поиск ближайшего ProximityPrompt
local function findNearestPrompt(originPos, maxDistance)
	local closestPrompt = nil
	local closestDist = maxDistance or 15

	for _, descendant in ipairs(Workspace:GetDescendants()) do
		if descendant:IsA("ProximityPrompt") and descendant.Enabled then
			local parentPart = descendant.Parent
			if parentPart and parentPart:IsA("BasePart") then
				local dist = (parentPart.Position - originPos).Magnitude
				if dist < closestDist then
					closestDist = dist
					closestPrompt = descendant
				end
			end
		end
	end
	return closestPrompt
end

-- 🔎 Поиск модели " femboy"
for _, base in ipairs(bases:GetChildren()) do
	if base:IsA("Model") then
		local slots = base:FindFirstChild("Slots")
		if slots then
			for _, slot in ipairs(slots:GetChildren()) do
				for _, model in ipairs(slot:GetChildren()) do
					if model:IsA("Model") and string.match(string.lower(model.Name), " femboy$") then
						local modelPosition
						if model.PrimaryPart then
							modelPosition = model.PrimaryPart.Position
						else
							local firstPart = model:FindFirstChildWhichIsA("BasePart", true)
							modelPosition = firstPart and firstPart.Position or Vector3.new(0, 0, 0)
						end

						-- ✨ Уведомление: телепорт к цели
						createNotification("✨ Телепорт к цели...", Color3.fromRGB(0, 170, 255))
						teleportTo(modelPosition + Vector3.new(0, 5, 0))
						print("✅ Телепорт к:", model.Name)

						task.wait(0.8)

						-- 💸 Использование промпта
						local prompt = findNearestPrompt(modelPosition, 20)
						if prompt then
							fireproximityprompt(prompt)
							createNotification("💸 Украдено успешно!", Color3.fromRGB(0, 200, 0))
							print("⚙️ ProximityPrompt активирован:", prompt.Name)
						else
							warn("❌ Промпт не найден")
						end

						-- ⏳ Подождать и вернуться на базу
						task.wait(2)
						createNotification("🏠 Возвращаюсь на базу...", Color3.fromRGB(255, 150, 0))
						teleportTo(originalPosition + Vector3.new(0, 5, 0))
						print("🏠 Вернулся на базу!")

						return
					end
				end
			end
		end
	end
end

warn("❌ Не найдено 'femboy'")
