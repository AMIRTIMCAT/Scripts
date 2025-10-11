-- 🌀 Femboy Stealer GUI by ChatGPT (Dark Mode Version)
-- Авто-ТП, авто-промпт, возврат и UI

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- 🧩 Функция уведомлений
local function createNotification(text)
	local screenGui = player:FindFirstChild("PlayerGui"):FindFirstChild("FemboyNotifyGui")
	if not screenGui then
		screenGui = Instance.new("ScreenGui")
		screenGui.Name = "FemboyNotifyGui"
		screenGui.Parent = player:WaitForChild("PlayerGui")
	end

	local msg = Instance.new("TextLabel")
	msg.Size = UDim2.new(0.4, 0, 0.07, 0)
	msg.Position = UDim2.new(0.3, 0, 0.85, 0)
	msg.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	msg.BorderSizePixel = 0
	msg.Text = text
	msg.TextColor3 = Color3.fromRGB(0, 255, 150)
	msg.TextScaled = true
	msg.Font = Enum.Font.GothamBold
	msg.BackgroundTransparency = 0.15
	msg.Parent = screenGui
	msg.TextTransparency = 1
	msg.BackgroundTransparency = 1

	-- Анимация появления
	TweenService:Create(msg, TweenInfo.new(0.3), {
		TextTransparency = 0,
		BackgroundTransparency = 0.15
	}):Play()

	task.wait(2)

	-- Исчезновение
	TweenService:Create(msg, TweenInfo.new(0.3), {
		TextTransparency = 1,
		BackgroundTransparency = 1
	}):Play()
	task.wait(0.3)
	msg:Destroy()
end

-- 🔍 Функция поиска своей базы
local function getMyBase()
	local bases = Workspace:WaitForChild("Bases")
	for _, base in ipairs(bases:GetChildren()) do
		local conf = base:FindFirstChild("Configuration") or base:FindFirstChild("Configurationsa")
		if conf and conf:FindFirstChild("Player") then
			local val = conf.Player.Value
			if val == player or (val and val.Name == player.Name) then
				return base
			end
		end
	end
	return nil
end

-- 🔍 Функция поиска чужой базы с Femboy
local function findEnemyFemboy()
	local bases = Workspace:WaitForChild("Bases")
	for _, base in ipairs(bases:GetChildren()) do
		local conf = base:FindFirstChild("Configuration") or base:FindFirstChild("Configurationsa")
		if conf and conf:FindFirstChild("Player") then
			local val = conf.Player.Value
			if val ~= player and (not val or val.Name ~= player.Name) then
				local slots = base:FindFirstChild("Slots")
				if slots then
					for _, slot in ipairs(slots:GetChildren()) do
						for _, model in ipairs(slot:GetChildren()) do
							if model:IsA("Model") and string.match(string.lower(model.Name), "femboy$") then
								return model
							end
						end
					end
				end
			end
		end
	end
	return nil
end

-- 🎯 Телепорт игрока
local function teleportTo(pos)
	if not character:FindFirstChild("HumanoidRootPart") then
		character:WaitForChild("HumanoidRootPart")
	end
	character:MoveTo(pos)
end

-- 💫 Активация ProximityPrompt
local function activatePrompt()
	for _, prompt in ipairs(Workspace:GetDescendants()) do
		if prompt:IsA("ProximityPrompt") and (prompt.Enabled or prompt.MaxActivationDistance > 0) then
			fireproximityprompt(prompt)
			task.wait(0.1)
		end
	end
end

-- 🕹️ Главная функция
local function stealAndReturn()
	local myBase = getMyBase()
	if not myBase then
		createNotification("⚠️ Не найдена твоя база!")
		return
	end

	local enemyModel = findEnemyFemboy()
	if not enemyModel then
		createNotification("❌ Не найдено ни одного Femboy у врагов!")
		return
	end

	local pos = enemyModel.PrimaryPart and enemyModel.PrimaryPart.Position or enemyModel:GetModelCFrame().p
	createNotification("🌀 Телепорт к цели...")
	teleportTo(pos + Vector3.new(0, 3, 0))

	task.wait(1)
	activatePrompt()
	createNotification("✅ Украдено успешно!")

	task.wait(1)
	local spawnPart = myBase:FindFirstChild("Spawn") or myBase:FindFirstChildWhichIsA("BasePart")
	if spawnPart then
		createNotification("🔁 Возврат на базу...")
		teleportTo(spawnPart.Position + Vector3.new(0, 3, 0))
		task.wait(0.5)
		createNotification("🏠 Вы вернулись на базу!")
	else
		createNotification("⚠️ Не найден Spawn на базе!")
	end
end

-- 💻 UI
local gui = Instance.new("ScreenGui")
gui.Name = "FemboyStealerUI"
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 130)
frame.Position = UDim2.new(0.5, -110, 0.5, -65)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Parent = gui

local uicorner = Instance.new("UICorner")
uicorner.CornerRadius = UDim.new(0, 12)
uicorner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0, 255, 150)
stroke.Thickness = 1.6
stroke.Parent = frame

local stealBtn = Instance.new("TextButton")
stealBtn.Size = UDim2.new(1, -20, 0, 45)
stealBtn.Position = UDim2.new(0, 10, 0, 15)
stealBtn.Text = "🌀 Украсть и вернуться"
stealBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
stealBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
stealBtn.Font = Enum.Font.GothamBold
stealBtn.TextScaled = true
stealBtn.Parent = frame

local uicorner2 = Instance.new("UICorner")
uicorner2.CornerRadius = UDim.new(0, 8)
uicorner2.Parent = stealBtn

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(1, -20, 0, 35)
closeBtn.Position = UDim2.new(0, 10, 0, 75)
closeBtn.Text = "🔘 Закрыть"
closeBtn.BackgroundColor3 = Color3.fromRGB(50, 10, 10)
closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextScaled = true
closeBtn.Parent = frame

local uicorner3 = Instance.new("UICorner")
uicorner3.CornerRadius = UDim.new(0, 8)
uicorner3.Parent = closeBtn

-- ⚡ Обработчики
stealBtn.MouseButton1Click:Connect(stealAndReturn)
closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)
