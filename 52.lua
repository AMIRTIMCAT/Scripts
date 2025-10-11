-- ⚙️ Настройки (можешь менять)
local waitAtTarget = 1        -- сколько сек стоять у модели до использования промпта
local returnDelay = 0.5       -- сколько сек ждать после использования промпта перед возвратом
local teleportOffsetY = 3     -- смещение по Y при телепорте
local promptSearchDistance = 18

-- 🧱 Сервисы
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")
local basesFolder = Workspace:WaitForChild("Bases")

-- 📢 Красивая функция уведомления
local function notify(text, color)
	pcall(function()
		local gui = Instance.new("ScreenGui")
		gui.ResetOnSpawn = false
		gui.IgnoreGuiInset = true
		gui.Name = "StealNotify"
		gui.Parent = player:WaitForChild("PlayerGui")

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(0, 360, 0, 40)
		label.Position = UDim2.new(0.5, -180, 0.12, 0)
		label.BackgroundColor3 = color
		label.TextColor3 = Color3.new(1,1,1)
		label.Font = Enum.Font.GothamBold
		label.TextScaled = true
		label.BackgroundTransparency = 0.15
		label.Text = text
		label.Parent = gui

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 12)
		corner.Parent = label

		TweenService:Create(label, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
		task.wait(1)
		TweenService:Create(label, TweenInfo.new(0.25), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
		task.wait(0.3)
		gui:Destroy()
	end)
end

-- ❄️ Заморозка / разморозка
local function freezeCharacter()
	character:SetAttribute("savedWalkSpeed", humanoid.WalkSpeed)
	character:SetAttribute("savedJumpPower", humanoid.JumpPower)
	humanoid.WalkSpeed = 0
	humanoid.JumpPower = 0
end
local function unfreezeCharacter()
	humanoid.WalkSpeed = character:GetAttribute("savedWalkSpeed") or 16
	humanoid.JumpPower = character:GetAttribute("savedJumpPower") or 50
end

-- 🚀 Телепорт
local function teleportTo(pos)
	if pos then
		hrp.CFrame = CFrame.new(pos)
	end
end

-- 🔍 Поиск ближайшего ProximityPrompt
local function findNearestPrompt(originPos, maxDist)
	local nearest, min = nil, maxDist or promptSearchDistance
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

-- 👤 Определить владельца базы
local function getOwnerName(base)
	local cfg = base:FindFirstChild("Configurationsa") or base:FindFirstChild("Configuration")
	if not cfg then return nil end
	local plrVal = cfg:FindFirstChild("Player")
	if not plrVal then return nil end

	if plrVal:IsA("ObjectValue") and plrVal.Value then
		return plrVal.Value.Name
	elseif plrVal:IsA("StringValue") then
		return tostring(plrVal.Value)
	end
	return nil
end

-- 🏠 Найти базу игрока
local function findMyBase()
	for _, base in ipairs(basesFolder:GetChildren()) do
		if base:IsA("Model") then
			local owner = getOwnerName(base)
			if owner and owner == player.Name then
				return base
			end
		end
	end
	return nil
end

-- 📍 Получить позицию Spawn.Base из базы
local function getSpawnPos(base)
	if not base then return nil end
	local spawn = base:FindFirstChild("Spawn")
	if not spawn then return nil end
	local basePart = spawn:FindFirstChild("Base")
	return basePart and basePart.Position or nil
end

-- 💰 Главная логика
local function runStealRoutine()
	local myBase = findMyBase()
	local returnPos = getSpawnPos(myBase) or hrp.Position

	if myBase then
		notify("🏡 Найдена твоя база!", Color3.fromRGB(0, 255, 180))
	end

	for _, base in ipairs(basesFolder:GetChildren()) do
		if base:IsA("Model") then
			local owner = getOwnerName(base)
			if owner ~= player.Name then
				local slots = base:FindFirstChild("Slots")
				if slots then
					for _, slot in ipairs(slots:GetChildren()) do
						for _, model in ipairs(slot:GetChildren()) do
							if model:IsA("Model") and string.find(string.lower(model.Name), "femboy") then
								-- нашёл цель
								local pos = model.PrimaryPart and model.PrimaryPart.Position
									or (model:FindFirstChildWhichIsA("BasePart", true) and model:FindFirstChildWhichIsA("BasePart", true).Position)
								if pos then
									freezeCharacter()
									notify("✨ Телепорт к цели...", Color3.fromRGB(0, 170, 255))
									teleportTo(pos + Vector3.new(0, teleportOffsetY, 0))
									task.wait(waitAtTarget)

									local prompt = findNearestPrompt(pos)
									if prompt then
										fireproximityprompt(prompt)
										notify("💸 Украдено!", Color3.fromRGB(0, 200, 0))
									else
										notify("⚠️ Промпт не найден!", Color3.fromRGB(255, 100, 100))
									end

									task.wait(returnDelay)
									notify("🏠 Возврат на базу...", Color3.fromRGB(255, 170, 0))
									teleportTo(returnPos + Vector3.new(0, teleportOffsetY, 0))
									task.wait(0.2)
									unfreezeCharacter()
									return
								end
							end
						end
					end
				end
			end
		end
	end

	notify("❌ Цель не найдена!", Color3.fromRGB(255, 100, 100))
end

-- 🚦 Автозапуск
task.spawn(function()
	task.wait(0.3)
	runStealRoutine()
end)
