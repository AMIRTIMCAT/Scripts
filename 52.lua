-- ⚙️ Настройки
local waitAtTarget = 0.5 -- сколько стоять у цели перед "украсть"
local returnDelay = 0.5  -- задержка перед возвратом на свою базу
local teleportOffsetY = 3

-- 🧱 Сервисы
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")
local basesFolder = Workspace:WaitForChild("Bases")

-- 📢 Уведомление
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

-- ❄️ Заморозка игрока
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

-- 🔍 Поиск владельца базы
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

-- 🏠 Поиск своей базы
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

-- 📍 Получение позиции спавна базы
local function getSpawnPosition(base)
	if not base then return nil end
	local spawn = base:FindFirstChild("Spawn")
	if not spawn then return nil end
	return spawn.Position or (spawn:FindFirstChild("Base") and spawn.Base.Position)
end

-- 🔍 Поиск ближайшего промпта
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

-- 💥 Основная логика
local function runStealRoutine()
	local myBase = findMyBase()
	local myBasePos = getSpawnPosition(myBase) or hrp.Position

	for _, base in ipairs(basesFolder:GetChildren()) do
		if base:IsA("Model") then
			local owner = getOwnerName(base)
			if owner ~= player.Name then
				local slots = base:FindFirstChild("Slots")
				if slots then
					for _, slot in ipairs(slots:GetChildren()) do
						for _, model in ipairs(slot:GetChildren()) do
							if model:IsA("Model") and string.find(string.lower(model.Name), "femboy") then
								-- 🎯 нашёл цель
								local part = model:FindFirstChildWhichIsA("BasePart", true)
								if part then
									freeze()
									notify("✨ Телепорт к FEMBOY...", Color3.fromRGB(0,170,255))
									hrp.CFrame = CFrame.new(part.Position + Vector3.new(0, teleportOffsetY, 0))
									task.wait(waitAtTarget)

									local prompt = findNearestPrompt(part.Position)
									if prompt then
										fireproximityprompt(prompt)
										notify("💸 Украдено у "..owner.."!", Color3.fromRGB(0,200,0))
									else
										notify("⚠️ Промпт не найден!", Color3.fromRGB(255,100,100))
									end

									task.wait(returnDelay)

									-- 🏠 Возврат на СВОЮ базу (по Configurationsa.Player.Value)
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
	end

	notify("❌ FEMBOY не найден!", Color3.fromRGB(255,80,80))
end

-- 🚦 Запуск
task.spawn(function()
	task.wait(0.5)
	runStealRoutine()
end)

