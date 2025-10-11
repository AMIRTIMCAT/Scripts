-- 💸 FEMBOY STEALER UI EDITION 💸

-- ⚙️ Настройки
local waitAtTarget = 1
local returnDelay = 1
local teleportOffsetY = 3

-- 🔧 Сервисы
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")
local basesFolder = Workspace:WaitForChild("Bases")

-- 📢 Уведомления
local function notify(text, color)
	pcall(function()
		local gui = Instance.new("ScreenGui")
		gui.IgnoreGuiInset = true
		gui.ResetOnSpawn = false
		gui.Name = "StealNotify"
		gui.Parent = player:WaitForChild("PlayerGui")

		local frame = Instance.new("TextLabel")
		frame.Size = UDim2.new(0, 400, 0, 40)
		frame.Position = UDim2.new(0.5, -200, 0.12, 0)
		frame.BackgroundColor3 = color
		frame.TextColor3 = Color3.new(1,1,1)
		frame.Font = Enum.Font.GothamBold
		frame.TextScaled = true
		frame.Text = text
		frame.BackgroundTransparency = 0.15
		frame.Parent = gui

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 12)
		corner.Parent = frame

		TweenService:Create(frame, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
		task.wait(1.2)
		TweenService:Create(frame, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
		task.wait(0.3)
		gui:Destroy()
	end)
end

-- ❄️ Заморозка
local function freeze()
	character:SetAttribute("savedWalkSpeed", humanoid.WalkSpeed)
	character:SetAttribute("savedJumpPower", humanoid.JumpPower)
	humanoid.WalkSpeed = 0
	humanoid.JumpPower = 0
end
local function unfreeze()
	humanoid.WalkSpeed = character:GetAttribute("savedWalkSpeed") or 16
	humanoid.JumpPower = character:GetAttribute("savedJumpPower") or 50
end

-- 🔍 Получить владельца базы
local function getOwnerName(base)
	local cfg = base:FindFirstChild("Configurationsa") or base:FindFirstChild("Configuration")
	if not cfg then return nil end
	local playerVal = cfg:FindFirstChild("Player")
	if not playerVal then return nil end

	if playerVal:IsA("ObjectValue") and playerVal.Value then
		return playerVal.Value.Name
	elseif playerVal:IsA("StringValue") then
		return tostring(playerVal.Value)
	end
	return nil
end

-- 🏠 Найти свою базу
local function findMyBase()
	for _, base in ipairs(basesFolder:GetChildren()) do
		if base:IsA("Model") then
			local owner = getOwnerName(base)
			if owner == player.Name then
				return base
			end
		end
	end
	return nil
end

-- 📍 Получить спавн своей базы
local function getSpawnPosition(base)
	if not base then return nil end
	local spawn = base:FindFirstChild("Spawn")
	if not spawn then return nil end
	if spawn:IsA("BasePart") then
		return spawn.Position
	elseif spawn:FindFirstChild("Base") then
		return spawn.Base.Position
	end
end

-- 🔍 Найти ближайший промпт
local function findNearestPrompt(originPos, maxDist)
	local nearest, min = nil, maxDist or 20
	for _, obj in ipairs(Workspace:GetDescendants()) do
		if obj:IsA("ProximityPrompt") and obj.Enabled then
			local part = obj.Parent
			if part and part:IsA("BasePart") then
				local dist = (part.Position - originPos).Magnitude
				if dist < min then
					min = dist
					nearest = obj
				end
			end
		end
	end
	return nearest
end

-- 💣 Основная логика
local function runStealRoutine()
	local myBase = findMyBase()
	local myBasePos = getSpawnPosition(myBase) or hrp.Position

	for _, base in ipairs(basesFolder:GetChildren()) do
		if base:IsA("Model") and getOwnerName(base) ~= player.Name then
			local slots = base:FindFirstChild("Slots")
			if slots then
				for _, slot in ipairs(slots:GetChildren()) do
					for _, model in ipairs(slot:GetChildren()) do
						if model:IsA("Model") and string.find(string.lower(model.Name), "femboy") then
							local part = model:FindFirstChildWhichIsA("BasePart", true)
							if part then
								freeze()
								notify("✨ Телепорт к FEMBOY...", Color3.fromRGB(0,170,255))
								hrp.CFrame = CFrame.new(part.Position + Vector3.new(0, teleportOffsetY, 0))
								task.wait(waitAtTarget)

								local prompt = findNearestPrompt(part.Position)
								if prompt then
									fireproximityprompt(prompt)
									notify("💸 Украдено у "..(getOwnerName(base) or "???").."!", Color3.fromRGB(0,200,0))
								else
									notify("⚠️ Промпт не найден!", Color3.fromRGB(255,100,100))
								end

								task.wait(returnDelay)

								if myBase and myBasePos then
									notify("🏠 Возврат на свою базу...", Color3.fromRGB(255,170,0))
									hrp.CFrame = CFrame.new(myBasePos + Vector3.new(0, teleportOffsetY, 0))
								else
									notify("⚠️ Своя база не найдена!", Color3.fromRGB(255,120,120))
								end

								unfreeze()
								return
							end
						end
					end
				end
			end
		end
	end

	notify("❌ FEMBOY не найден!", Color3.fromRGB(255,80,80))
end

-- 🖥️ Интерфейс
local gui = Instance.new("ScreenGui")
gui.Name = "FemboyStealerUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 260, 0, 90)
main.Position = UDim2.new(0.5, -130, 0.85, -45)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
main.BackgroundTransparency = 0.25
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = main

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(1, -20, 1, -20)
btn.Position = UDim2.new(0, 10, 0, 10)
btn.Text = "💸 Украсть FEMBOY"
btn.TextColor3 = Color3.new(1,1,1)
btn.Font = Enum.Font.GothamBold
btn.TextScaled = true
btn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
btn.AutoButtonColor = false
btn.Parent = main

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 12)
btnCorner.Parent = btn

-- 🔘 Кнопка запуска
btn.MouseButton1Click:Connect(function()
	btn.Text = "⏳ В процессе..."
	btn.BackgroundColor3 = Color3.fromRGB(0, 80, 180)
	btn.Active = false
	task.spawn(function()
		runStealRoutine()
		task.wait(1.5)
		btn.Text = "💸 Украсть FEMBOY"
		btn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
		btn.Active = true
	end)
end)

notify("🧠 FEMBOY STEALER UI загружен!", Color3.fromRGB(0,170,255))
