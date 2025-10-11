-- Настройки (можешь менять)
local waitAtTarget = 1        -- сколько сек стоять у модели до использования промпта
local returnDelay = 0.5       -- сколько сек ждать после использования промпта перед возвратом
local teleportOffsetY = 3     -- смещение по Y при телепорте
local promptSearchDistance = 18

-- Сервисы
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")
local basesFolder = Workspace:WaitForChild("Bases")

-- Уведомления
local function notify(text, color)
	local ok, err = pcall(function()
		local gui = Instance.new("ScreenGui")
		gui.ResetOnSpawn = false
		gui.IgnoreGuiInset = true
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

		task.delay(0.9, function()
			TweenService:Create(label, TweenInfo.new(0.25), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
			task.wait(0.3)
			pcall(function() gui:Destroy() end)
		end)
	end)
	if not ok then
		warn("notify error:", err)
	end
end

-- Заморозка / разморозка (с сохранением старых значений)
local function freezeCharacter()
	character:SetAttribute("savedWalkSpeed", humanoid.WalkSpeed)
	character:SetAttribute("savedJumpPower", humanoid.JumpPower)
	humanoid.WalkSpeed = 0
	humanoid.JumpPower = 0
end

local function unfreezeCharacter()
	local ws = character:GetAttribute("savedWalkSpeed") or 16
	local jp = character:GetAttribute("savedJumpPower") or 50
	humanoid.WalkSpeed = ws
	humanoid.JumpPower = jp
	character:SetAttribute("savedWalkSpeed", nil)
	character:SetAttribute("savedJumpPower", nil)
end

-- Телепорт
local function teleportTo(position)
	pcall(function()
		humanoid:MoveTo(position)
		hrp.CFrame = CFrame.new(position)
	end)
end

-- Поиск ближайшего ProximityPrompt
local function findNearestPrompt(originPos, maxDistance)
	local closestPrompt, minDist = nil, maxDistance or promptSearchDistance
	for _, obj in ipairs(Workspace:GetDescendants()) do
		if obj:IsA("ProximityPrompt") and obj.Enabled then
			local parent = obj.Parent
			if parent and parent:IsA("BasePart") then
				local dist = (parent.Position - originPos).Magnitude
				if dist < minDist then
					minDist = dist
					closestPrompt = obj
				end
			end
		end
	end
	return closestPrompt
end

-- Получить имя владельца базы из Configurationsa.Player
local function getOwnerNameFromConfig(baseModel)
	local cfg = baseModel:FindFirstChild("Configurationsa")
	if not cfg then return nil end

	-- Ищем объект Player внутри Configurationsa
	local playerEntry = cfg:FindFirstChild("Player") or cfg:FindFirstChildWhichIsA("Value")
	if not playerEntry then
		for _, v in ipairs(cfg:GetDescendants()) do
			if v:IsA("Value") and tostring(v.Name):lower():find("player") then
				playerEntry = v
				break
			end
		end
	end

	if not playerEntry then return nil end

	-- Поддерживаем разные типы Value
	if playerEntry:IsA("StringValue") or playerEntry:IsA("IntValue") or playerEntry:IsA("NumberValue") then
		return tostring(playerEntry.Value)
	elseif playerEntry:IsA("ObjectValue") and playerEntry.Value then
		-- ObjectValue может хранить игрока/персонаж
		local v = playerEntry.Value
		-- если это игрок (редко), вернём имя
		if v.IsA and v:IsA("Player") then
			return v.Name
		elseif v.Name then
			return tostring(v.Name)
		end
	elseif playerEntry.Value then
		return tostring(playerEntry.Value)
	end

	return nil
end

-- Найти базу игрока по совпадению ника в Configurationsa.Player
local function findPlayerBase()
	for _, baseModel in ipairs(basesFolder:GetChildren()) do
		if baseModel:IsA("Model") then
			local ownerName = getOwnerNameFromConfig(baseModel)
			if ownerName and ownerName == player.Name then
				return baseModel
			end
		end
	end
	return nil
end

-- Получить позицию Spawn.Base внутри базы
local function getSpawnPositionFromBase(baseModel)
	if not baseModel then return nil end
	local spawn = baseModel:FindFirstChild("Spawn")
	if spawn then
		local basePart = spawn:FindFirstChild("Base")
		if basePart and basePart:IsA("BasePart") then
			return basePart.Position
		end
	end
	return nil
end

-- Основная логика: ищем femboy в чужих базах (пропуская свою)
local function runStealRoutine()
	local playerBase = findPlayerBase()
	local returnPos = getSpawnPositionFromBase(playerBase) or hrp.Position

	-- Проходим по всем базам, но пропускаем свою
	for _, base in ipairs(basesFolder:GetChildren()) do
		if not base:IsA("Model") then
			-- пропускаем если не модель
		else
			-- пропустить свою базу (если найдена)
			if playerBase and base == playerBase then
				-- пропускаем
			else
				-- работаем с чужой базой
				local slots = base:FindFirstChild("Slots")
				if slots then
					for _, slot in ipairs(slots:GetChildren()) do
						for _, model in ipairs(slot:GetChildren()) do
							if model:IsA("Model") and string.match(string.lower(model.Name), " femboy$") then
								-- нашли цель в чужой базе
								local pos
								if model.PrimaryPart then
									pos = model.PrimaryPart.Position
								else
									local part = model:FindFirstChildWhichIsA("BasePart", true)
									pos = part and part.Position or Vector3.new(0,0,0)
								end

								-- блокируем движение и телепортируемся
								freezeCharacter()
								notify("✨ Телепорт к цели...", Color3.fromRGB(0,170,255))
								teleportTo(pos + Vector3.new(0, teleportOffsetY, 0))

								-- ждем немного чтобы промпт прогрузился
								task.wait(0.3)

								-- стоим у цели указанное время, чтобы успеть сработать
								task.wait(waitAtTarget - 0.3 >= 0 and (waitAtTarget - 0.3) or 0)

								-- пробуем найти и использовать промпт
								local prompt = findNearestPrompt(pos, promptSearchDistance)
								if prompt then
									pcall(function() fireproximityprompt(prompt) end)
									notify("💸 Украдено!", Color3.fromRGB(0,200,0))
								else
									notify("⚠️ Промпт не найден", Color3.fromRGB(220,80,80))
								end

								-- ждем перед возвратом
								task.wait(returnDelay)

								-- возвращаемся на свою базу (или на последний hrp.pos)
								notify("🏠 Возврат на базу...", Color3.fromRGB(255,170,0))
								teleportTo(returnPos + Vector3.new(0, teleportOffsetY, 0))

								task.wait(0.15)
								unfreezeCharacter()
								return
							end
						end
					end
				end
			end
		end
	end

	warn("❌ Не найдено 'femboy' в чужих базах")
end

-- Запуск (с маленькой задержкой чтобы всё прогрузилось)
spawn(function()
	task.wait(0.2)
	runStealRoutine()
end)
