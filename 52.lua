-- ⚡ Тёмный мини-UI для "Украсть и вернуться"
-- Работает на PC и Mobile

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- 🧱 UI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "StealUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 280, 0, 150)
frame.Position = UDim2.new(0.5, -140, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
frame.BorderSizePixel = 0

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(90, 90, 150)
stroke.Thickness = 2

local title = Instance.new("TextLabel", frame)
title.Text = "🌀 Украсть и вернуться"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamSemibold
title.TextSize = 18

local stealBtn = Instance.new("TextButton", frame)
stealBtn.Size = UDim2.new(1, -40, 0, 40)
stealBtn.Position = UDim2.new(0, 20, 0, 45)
stealBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
stealBtn.Text = "🌀 Украсть и вернуться"
stealBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
stealBtn.Font = Enum.Font.GothamBold
stealBtn.TextSize = 16

local stealCorner = Instance.new("UICorner", stealBtn)
stealCorner.CornerRadius = UDim.new(0, 8)

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(1, -40, 0, 35)
closeBtn.Position = UDim2.new(0, 20, 0, 95)
closeBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
closeBtn.Text = "🔘 Закрыть"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamSemibold
closeBtn.TextSize = 14

local closeCorner = Instance.new("UICorner", closeBtn)
closeCorner.CornerRadius = UDim.new(0, 8)

-- 🌟 Уведомление
local notify = Instance.new("TextLabel", gui)
notify.Size = UDim2.new(0, 300, 0, 50)
notify.Position = UDim2.new(0.5, -150, 0.1, 0)
notify.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
notify.TextColor3 = Color3.fromRGB(255, 255, 255)
notify.Font = Enum.Font.GothamSemibold
notify.TextSize = 16
notify.Visible = false

local notifyCorner = Instance.new("UICorner", notify)
notifyCorner.CornerRadius = UDim.new(0, 10)

local function showNotify(text, color)
	notify.Text = text
	notify.BackgroundColor3 = color or Color3.fromRGB(35, 35, 55)
	notify.Visible = true
	TweenService:Create(notify, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
	task.wait(1.3)
	TweenService:Create(notify, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
	task.wait(0.3)
	notify.Visible = false
end

-- ⚙️ Основная функция
local function stealAndReturn()
	character = player.Character or player.CharacterAdded:Wait()
	local hrp = character:WaitForChild("HumanoidRootPart")

	-- Найти свою базу
	local myBase
	local bases = Workspace:WaitForChild("Bases")
	for _, base in ipairs(bases:GetChildren()) do
		local conf = base:FindFirstChild("Configuration") or base:FindFirstChild("Configurationsa")
		if conf and conf:FindFirstChild("Player") and conf.Player.Value == player.Name then
			myBase = base
			break
		end
	end

	if not myBase then
		showNotify("⚠️ Твоя база не найдена!", Color3.fromRGB(200, 60, 60))
		return
	end

	-- Найти свою базу
	local myBase
	lcoal bases = Workspace.WaitForChild("Bases")

	for _, base in ipairs(bases:GetChildren()) do
	local conf = base:FindFirstChild("Configuration") or base:FindFirstChild("Configurationsa")
	if conf and conf:FindFirstChild("Player") then
		local playerValue = conf.Player
		if playerValue.Value == player or (playerValue.Value and playerValue.Value.Name == player.Name) then
			myBase = base
			break
		end
	end
end

	if not targetBase then
		showNotify("❌ Нет чужих баз!", Color3.fromRGB(180, 60, 60))
		return
	end

	-- Телепорт к чужой базе
	local targetSpawn = targetBase:FindFirstChild("Spawn")
	if targetSpawn then
		hrp.CFrame = targetSpawn.CFrame + Vector3.new(0, 3, 0)
		showNotify("🌀 Телепорт к цели...", Color3.fromRGB(65, 105, 225))
	end

	-- Использовать ближайший ProximityPrompt
	task.wait(0.5)
	for _, obj in ipairs(Workspace:GetDescendants()) do
		if obj:IsA("ProximityPrompt") and (obj.Parent:IsDescendantOf(targetBase)) then
			fireproximityprompt(obj)
			showNotify("💰 Украдено!", Color3.fromRGB(50, 205, 50))
			break
		end
	end

	-- Вернуться на свою базу
	task.wait(1)
	local mySpawn = myBase:FindFirstChild("Spawn")
	if mySpawn then
		hrp.CFrame = mySpawn.CFrame + Vector3.new(0, 3, 0)
		showNotify("🏠 Возвращение на базу...", Color3.fromRGB(100, 149, 237))
		task.wait(0.5)
		showNotify("✅ Успешно вернулся!", Color3.fromRGB(60, 200, 80))
	end
end

-- 🔘 Кнопки
stealBtn.MouseButton1Click:Connect(stealAndReturn)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- 📱 Поддержка мобильных
if game:GetService("UserInputService").TouchEnabled then
	frame.Size = UDim2.new(0, 320, 0, 180)
	stealBtn.Size = UDim2.new(1, -40, 0, 50)
	closeBtn.Size = UDim2.new(1, -40, 0, 45)
	title.TextSize = 20
end

print("✅ Скрипт 'Украсть и вернуться' загружен!")
