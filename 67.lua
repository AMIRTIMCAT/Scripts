-- LocalScript: Femboy Stealer UI (Максимально защищенная версия)
-- Исправлены все возможные ошибки nil value

-- Безопасная загрузка сервисов
local success, Players = pcall(function() return game:GetService("Players") end)
if not success then warn("❌ Не удалось загрузить Players service") return end

local success, TweenService = pcall(function() return game:GetService("TweenService") end)
if not success then warn("❌ Не удалось загрузить TweenService") return end

local success, Workspace = pcall(function() return game:GetService("Workspace") end)
if not success then warn("❌ Не удалось загрузить Workspace") return end

local success, RunService = pcall(function() return game:GetService("RunService") end)
if not success then warn("❌ Не удалось загрузить RunService") return end

local success, UserInputService = pcall(function() return game:GetService("UserInputService") end)
if not success then warn("❌ Не удалось загрузить UserInputService") return end

-- Максимально безопасное получение LocalPlayer
local player
local attempts = 0
local maxAttempts = 10

while not player and attempts < maxAttempts do
	attempts = attempts + 1
	local success, result = pcall(function()
		return Players.LocalPlayer
	end)
	
	if success and result then
		player = result
		break
	else
		warn("⚠️ Попытка", attempts, "/", maxAttempts, ": LocalPlayer недоступен")
		task.wait(0.5)
	end
end

if not player then
	warn("❌ Критическая ошибка: LocalPlayer недоступен после", maxAttempts, "попыток")
	return
end

print("✅ LocalPlayer получен:", player.Name)

-- Безопасное получение PlayerGui
local playerGui
local success, result = pcall(function()
	return player:WaitForChild("PlayerGui", 10)
end)

if success and result then
	playerGui = result
else
	warn("❌ PlayerGui не загружен за 10 секунд")
	return
end

-- === АВТОУСТАНОВКА (без зацикливания) ===
local INSTALLED_NAME = "FemboyStealerUI_Installed"
local ps = player:FindFirstChild("PlayerScripts")
if not ps then
	ps = player:WaitForChild("PlayerScripts", 5)
	if not ps then
		warn("❌ PlayerScripts не найден")
		return
	end
end

if script.Parent ~= ps and not ps:FindFirstChild(INSTALLED_NAME) then
	local success, err = pcall(function()
		local clone = script:Clone()
		clone.Name = INSTALLED_NAME
		clone.Parent = ps
		print("✅ FemboyStealerUI установлен в PlayerScripts как", INSTALLED_NAME)
	end)
	if not success then
		warn("❌ Ошибка установки:", err)
	end
end

-- === Предотвращение мульти-UI ===
if playerGui:FindFirstChild("FemboyStealerUI") then
	-- UI уже существует — больше не создаём новый
	print("FemboyStealerUI: GUI уже существует, повторное создание пропущено.")
	return
end

-- === UI ===
local function createGUI()
	-- если уже есть — вернём существующий
	if playerGui:FindFirstChild("FemboyStealerUI") then
		return playerGui:FindFirstChild("FemboyStealerUI")
	end

	local gui = Instance.new("ScreenGui")
	gui.Name = "FemboyStealerUI"
	gui.ResetOnSpawn = false
	gui.Parent = playerGui

	local frame = Instance.new("Frame")
	frame.Name = "MainFrame"
	frame.Size = UDim2.new(0, 260, 0, 140)
	frame.Position = UDim2.new(0.5, -130, 0.5, -70)
	frame.BackgroundColor3 = Color3.fromRGB(18,18,24)
	frame.BorderSizePixel = 0
	frame.Active = true
	frame.Draggable = false
	frame.Parent = gui

	local corner = Instance.new("UICorner", frame)
	corner.CornerRadius = UDim.new(0,12)
	local stroke = Instance.new("UIStroke", frame)
	stroke.Color = Color3.fromRGB(70,70,110)
	stroke.Thickness = 1.6

	local title = Instance.new("TextLabel", frame)
	title.Size = UDim2.new(1, -20, 0, 30)
	title.Position = UDim2.new(0,10,0,8)
	title.BackgroundTransparency = 1
	title.Text = "🌀 Украсть и вернуться"
	title.TextColor3 = Color3.fromRGB(230,230,230)
	title.Font = Enum.Font.GothamSemibold
	title.TextSize = 18
	title.TextXAlignment = Enum.TextXAlignment.Left

	local stealBtn = Instance.new("TextButton", frame)
	stealBtn.Name = "StealBtn"
	stealBtn.Size = UDim2.new(1, -40, 0, 44)
	stealBtn.Position = UDim2.new(0, 20, 0, 48)
	stealBtn.BackgroundColor3 = Color3.fromRGB(52, 56, 92)
	stealBtn.Text = "🌀 Украсть и вернуться"
	stealBtn.TextColor3 = Color3.fromRGB(240,240,240)
	stealBtn.Font = Enum.Font.GothamBold
	stealBtn.TextSize = 16
	Instance.new("UICorner", stealBtn).CornerRadius = UDim.new(0,8)

	local closeBtn = Instance.new("TextButton", frame)
	closeBtn.Name = "CloseBtn"
	closeBtn.Size = UDim2.new(1, -40, 0, 36)
	closeBtn.Position = UDim2.new(0, 20, 0, 100)
	closeBtn.BackgroundColor3 = Color3.fromRGB(130, 36, 36)
	closeBtn.Text = "🔘 Закрыть"
	closeBtn.TextColor3 = Color3.fromRGB(255,200,200)
	closeBtn.Font = Enum.Font.GothamSemibold
	closeBtn.TextSize = 14
	Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,8)

	-- notify
	local notifyLabel = Instance.new("TextLabel", gui)
	notifyLabel.Name = "FemboyNotify"
	notifyLabel.Size = UDim2.new(0,320,0,48)
	notifyLabel.Position = UDim2.new(0.5, -160, 0.15, 0)
	notifyLabel.BackgroundColor3 = Color3.fromRGB(28,28,36)
	notifyLabel.BackgroundTransparency = 1
	notifyLabel.TextColor3 = Color3.fromRGB(200,255,200)
	notifyLabel.Font = Enum.Font.GothamBold
	notifyLabel.TextSize = 16
	notifyLabel.Text = ""
	notifyLabel.Visible = false
	Instance.new("UICorner", notifyLabel).CornerRadius = UDim.new(0,10)

	-- drag support stored on frame for access later
	frame:SetAttribute("Dragging", false)

	return gui
end

-- Безопасное создание GUI с проверками
local gui, frame, stealBtn, closeBtn, notifyLabel

local success, err = pcall(function()
	gui = createGUI()
	if gui then
		frame = gui:FindFirstChild("MainFrame")
		if frame then
			stealBtn = frame:FindFirstChild("StealBtn")
			closeBtn = frame:FindFirstChild("CloseBtn")
		end
		notifyLabel = gui:FindFirstChild("FemboyNotify")
	end
end)

if not success then
	warn("❌ Ошибка создания GUI:", err)
	return
end

if not gui or not frame or not stealBtn or not closeBtn or not notifyLabel then
	warn("❌ Не все элементы GUI созданы")
	return
end

-- Максимально защищенная showNotify
local function showNotify(text, bg)
	if not notifyLabel or not notifyLabel.Parent then 
		warn("⚠️ notifyLabel недоступен")
		return 
	end
	
	local success, err = pcall(function()
		notifyLabel.Text = text or ""
		notifyLabel.BackgroundColor3 = bg or Color3.fromRGB(28,28,36)
		notifyLabel.Visible = true
		notifyLabel.BackgroundTransparency = 1
		notifyLabel.TextTransparency = 1
		
		if TweenService then
			local tween = TweenService:Create(notifyLabel, TweenInfo.new(0.22), {
				BackgroundTransparency = 0.15, 
				TextTransparency = 0
			})
			tween:Play()
			
			task.delay(1.2, function()
				if notifyLabel and notifyLabel.Parent then
					local t2 = TweenService:Create(notifyLabel, TweenInfo.new(0.18), {
						BackgroundTransparency = 1, 
						TextTransparency = 1
					})
					t2:Play()
					task.wait(0.2)
					notifyLabel.Visible = false
				end
			end)
		end
	end)
	
	if not success then
		warn("❌ Ошибка в showNotify:", err)
	end
end

-- === Drag implementation (ПК + мобилки) ===
do
	if frame and frame:FindFirstChildOfClass("TextLabel") then
		local title = frame:FindFirstChildOfClass("TextLabel")
		local dragging, dragInput, dragStart, startPos
		local function update(input)
			if not (dragStart and startPos) then return end
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end

		title.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startPos = frame.Position

				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
					end
				end)
			end
		end)

		title.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				dragInput = input
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if input == dragInput and dragging then
				update(input)
			end
		end)
	end
end

-- === Утилиты ===
local function getAnyBasePart(model)
	if not model then return nil end
	if model.PrimaryPart and model.PrimaryPart:IsA("BasePart") then return model.PrimaryPart end
	for i = 1, #model:GetDescendants() do
		local d = model:GetDescendants()[i]
		if d:IsA("BasePart") then return d end
	end
	return nil
end

local function findMyBase()
	local basesFolder = Workspace:FindFirstChild("Bases")
	if not basesFolder then return nil end
	for i = 1, #basesFolder:GetChildren() do
		local base = basesFolder:GetChildren()[i]
		if base:IsA("Model") then
			local cfg = base:FindFirstChild("Configuration") or base:FindFirstChild("Configurationsa")
			if cfg then
				local pv = cfg:FindFirstChild("Player")
				if pv then
					-- pv.Value может быть Instance (ObjectValue) или строка (StringValue)
					local ok, val = pcall(function() return pv.Value end)
					if ok and val then
						if val == player then
							return base
						elseif typeof(val) == "Instance" and val.Name == player.Name then
							return base
						elseif type(val) == "string" and val == player.Name then
							return base
						end
					end
				end
			end
		end
	end
	return nil
end

local function findEnemyFemboy(myBase)
	local basesFolder = Workspace:FindFirstChild("Bases")
	if not basesFolder then return nil end
	for i = 1, #basesFolder:GetChildren() do
		local base = basesFolder:GetChildren()[i]
		if base:IsA("Model") and base ~= myBase then
			local slots = base:FindFirstChild("Slots")
			if slots then
				for j = 1, #slots:GetChildren() do
					local slot = slots:GetChildren()[j]
					for k = 1, #slot:GetChildren() do
						local m = slot:GetChildren()[k]
						if m:IsA("Model") then
							local nameLow = tostring(m.Name):lower()
							local endsWithFemboy = #nameLow >= 6 and string.sub(nameLow, -6) == "femboy"
							local isRoommateExact = nameLow == "roommate"
							if endsWithFemboy or isRoommateExact then
								return m, base
							end
						end
					end
				end
			end
		end
	end
	return nil, nil
end

local function findPromptInModel(rootModel, originPos, maxDist)
	if not rootModel then return nil end
	local best, bestD
	maxDist = maxDist or 20
	for i = 1, #rootModel:GetDescendants() do
		local desc = rootModel:GetDescendants()[i]
		if desc:IsA("ProximityPrompt") and desc.Enabled then
			local parentPart
			local parent = desc.Parent
			if parent then
				if parent:IsA("BasePart") then
					parentPart = parent
				elseif parent:IsA("Attachment") and parent.Parent and parent.Parent:IsA("BasePart") then
					parentPart = parent.Parent
				end
			end
			if parentPart then
				local ok, d = pcall(function() return (parentPart.Position - originPos).Magnitude end)
				if ok and d then
					if d <= maxDist and (not bestD or d < bestD) then
						best = desc
						bestD = d
					end
				end
			end
		end
	end
	return best
end

local function teleportCharacterToPosition(pos)
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart")
	if hrp then
		pcall(function() hrp.Velocity = Vector3.new(0,0,0) end)
		hrp.CFrame = CFrame.new(pos)
		RunService.Heartbeat:Wait()
		pcall(function() hrp.Velocity = Vector3.new(0,0,0) end)
	end
end

local function tryActivatePrompt(prompt)
	if not prompt then return false end
	-- try global helper first
	if typeof(fireproximityprompt) == "function" then
		local ok, err = pcall(function() fireproximityprompt(prompt) end)
		if ok then return true end
	end
	-- fallback: InputHoldBegin / InputHoldEnd
	local ok, err = pcall(function()
		if prompt.InputHoldBegin then
			prompt:InputHoldBegin()
			task.wait(prompt.HoldDuration or 0.5)
			prompt:InputHoldEnd()
		elseif prompt.Trigger then
			-- some prompts have :Trigger()
			prompt:Trigger()
		end
	end)
	return ok
end

-- === Основная логика ===
local function stealAndReturn()
	if not stealBtn then 
		warn("❌ stealBtn не найден")
		return 
	end
	
	stealBtn.Active = false
	stealBtn.Text = "⏳ Выполняется..."

	-- Безопасное получение персонажа
	local char = player.Character
	if not char then
		local connection
		connection = player.CharacterAdded:Connect(function(newChar)
			char = newChar
			connection:Disconnect()
		end)
		task.wait(5) -- Ожидание максимум 5 секунд
		if connection then connection:Disconnect() end
		if not char then
			showNotify("❌ Персонаж не найден", Color3.fromRGB(200,80,80))
			goto finish
		end
	end
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		showNotify("⚠️ Гуманоид не найден", Color3.fromRGB(200,120,80))
		stealBtn.Text = "🌀 Украсть и вернуться"
		stealBtn.Active = true
		return
	end

	local myBase = findMyBase()
	if not myBase then
		showNotify("⚠️ Своя база не найдена!", Color3.fromRGB(200,80,80))
		goto finish
	end

	local targetModel, targetBase = findEnemyFemboy(myBase)
	if not targetModel then
		showNotify("❌ Не найдено femboy/roommate!", Color3.fromRGB(200,80,80))
		goto finish
	end

	local part = getAnyBasePart(targetModel)
	local targetPos
	if part then
		targetPos = part.Position + Vector3.new(0,3,0)
	elseif typeof(targetModel) == "Instance" and targetModel.GetModelCFrame then
		local ok, cf = pcall(function() return targetModel:GetModelCFrame() end)
		if ok and cf then targetPos = cf.Position + Vector3.new(0,3,0) end
	end

	if not targetPos then
		showNotify("⚠️ Не удалось определить позицию цели", Color3.fromRGB(200,80,80))
		goto finish
	end

	local savedWalk, savedJump = humanoid.WalkSpeed, humanoid.JumpHeight
	pcall(function()
		humanoid.WalkSpeed = 0
		humanoid.JumpHeight = 0
	end)

	showNotify("✨ Телепорт к цели...", Color3.fromRGB(80,120,220))
	teleportCharacterToPosition(targetPos)
	task.wait(0.15)

	local prompt = findPromptInModel(targetBase or targetModel, targetPos, 20)
	if prompt then
		local ok = tryActivatePrompt(prompt)
		if ok then
			showNotify("💸 Промпт активирован!", Color3.fromRGB(70,200,100))
		else
			showNotify("⚠️ Промпт найден, но не удалось активировать", Color3.fromRGB(220,140,80))
		end
	else
		showNotify("⚠️ Промпт не найден у цели", Color3.fromRGB(220,120,80))
	end

	task.wait(1)

	-- найти Spawn позиции в моей базе
	local spawn = myBase:FindFirstChild("Spawn")
	local spawnPos
	if spawn then
		if spawn:IsA("BasePart") then
			spawnPos = spawn.Position
		else
			local basePart = spawn:FindFirstChild("Base") or spawn:FindFirstChildWhichIsA("BasePart")
			if basePart and basePart:IsA("BasePart") then
				spawnPos = basePart.Position
			end
		end
	end

	if spawnPos then
		showNotify("🔁 Возврат на базу...", Color3.fromRGB(100,140,220))
		teleportCharacterToPosition(spawnPos + Vector3.new(0,3,0))
		task.wait(0.25)
		showNotify("🏠 Вы вернулись!", Color3.fromRGB(80,200,120))
	else
		showNotify("⚠️ Spawn не найден", Color3.fromRGB(200,120,80))
	end

	-- вернуть параметры
	pcall(function()
		humanoid.WalkSpeed = savedWalk or 16
		humanoid.JumpHeight = savedJump or 7.2
	end)

	::finish::
	stealBtn.Text = "🌀 Украсть и вернуться"
	stealBtn.Active = true
end

-- Защищенное подключение обработчиков событий
if stealBtn and stealBtn.MouseButton1Click then
	local success, err = pcall(function()
		stealBtn.MouseButton1Click:Connect(function()
			if not stealBtn.Active then return end
			task.spawn(function()
				local ok, error = pcall(stealAndReturn)
				if not ok then
					warn("❌ stealAndReturn error:", error)
					if showNotify then
						showNotify("❌ Ошибка: "..tostring(error), Color3.fromRGB(220,80,80))
					end
				end
			end)
		end)
	end)
	if not success then
		warn("❌ Ошибка подключения stealBtn:", err)
	end
else
	warn("❌ stealBtn или его MouseButton1Click недоступны")
end

if closeBtn and closeBtn.MouseButton1Click then
	local success, err = pcall(function()
		closeBtn.MouseButton1Click:Connect(function()
			if gui then
				pcall(function() gui:Destroy() end)
			end
		end)
	end)
	if not success then
		warn("❌ Ошибка подключения closeBtn:", err)
	end
else
	warn("❌ closeBtn или его MouseButton1Click недоступны")
end

-- Адаптация для мобильных устройств
if UserInputService and UserInputService.TouchEnabled and frame then
	local success, err = pcall(function()
		frame.Size = UDim2.new(0, 340, 0, 160)
		if stealBtn then stealBtn.Size = UDim2.new(1, -40, 0, 54) end
		if closeBtn then closeBtn.Size = UDim2.new(1, -40, 0, 44) end
	end)
	if not success then
		warn("❌ Ошибка адаптации для мобильных:", err)
	end
end

-- Завершение загрузки
print("✅ FemboyStealerUI загружен без ошибок!")
if showNotify then
	showNotify("🚀 Скрипт активирован!", Color3.fromRGB(90,180,255))
else
	print("⚠️ showNotify недоступна, но скрипт работает")
end-- LocalScript: Femboy Stealer UI (Auto-install, Fixed, Safe)
-- Исправленная версия с улучшениями

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
if not player then 
	warn("LocalPlayer не найден!")
	return 
end

-- === АВТОУСТАНОВКА (без зацикливания) ===
-- Установочная метка (имя скрипта в PlayerScripts)
local INSTALLED_NAME = "FemboyStealerUI_Installed"
local ps = player:WaitForChild("PlayerScripts")
if script.Parent ~= ps and not ps:FindFirstChild(INSTALLED_NAME) then
	local clone = script:Clone()
	clone.Name = INSTALLED_NAME
	clone.Parent = ps
	print("✅ FemboyStealerUI установлен в PlayerScripts как", INSTALLED_NAME)
end

-- === Предотвращение мульти-UI ===
if player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("FemboyStealerUI") then
	-- UI уже существует — больше не создаём новый
	print("FemboyStealerUI: GUI уже существует, повторное создание пропущено.")
	return
end

-- === UI ===
local function createGUI()
	-- если уже есть — вернём существующий
	if player.PlayerGui:FindFirstChild("FemboyStealerUI") then
		return player.PlayerGui:FindFirstChild("FemboyStealerUI")
	end

	local gui = Instance.new("ScreenGui")
	gui.Name = "FemboyStealerUI"
	gui.ResetOnSpawn = false
	gui.Parent = player:WaitForChild("PlayerGui")

	local frame = Instance.new("Frame")
	frame.Name = "MainFrame"
	frame.Size = UDim2.new(0, 260, 0, 140)
	frame.Position = UDim2.new(0.5, -130, 0.5, -70)
	frame.BackgroundColor3 = Color3.fromRGB(18,18,24)
	frame.BorderSizePixel = 0
	frame.Active = true
	frame.Draggable = false
	frame.Parent = gui

	local corner = Instance.new("UICorner", frame)
	corner.CornerRadius = UDim.new(0,12)
	local stroke = Instance.new("UIStroke", frame)
	stroke.Color = Color3.fromRGB(70,70,110)
	stroke.Thickness = 1.6

	local title = Instance.new("TextLabel", frame)
	title.Size = UDim2.new(1, -20, 0, 30)
	title.Position = UDim2.new(0,10,0,8)
	title.BackgroundTransparency = 1
	title.Text = "🌀 Украсть и вернуться"
	title.TextColor3 = Color3.fromRGB(230,230,230)
	title.Font = Enum.Font.GothamSemibold
	title.TextSize = 18
	title.TextXAlignment = Enum.TextXAlignment.Left

	local stealBtn = Instance.new("TextButton", frame)
	stealBtn.Name = "StealBtn"
	stealBtn.Size = UDim2.new(1, -40, 0, 44)
	stealBtn.Position = UDim2.new(0, 20, 0, 48)
	stealBtn.BackgroundColor3 = Color3.fromRGB(52, 56, 92)
	stealBtn.Text = "🌀 Украсть и вернуться"
	stealBtn.TextColor3 = Color3.fromRGB(240,240,240)
	stealBtn.Font = Enum.Font.GothamBold
	stealBtn.TextSize = 16
	Instance.new("UICorner", stealBtn).CornerRadius = UDim.new(0,8)

	local closeBtn = Instance.new("TextButton", frame)
	closeBtn.Name = "CloseBtn"
	closeBtn.Size = UDim2.new(1, -40, 0, 36)
	closeBtn.Position = UDim2.new(0, 20, 0, 100)
	closeBtn.BackgroundColor3 = Color3.fromRGB(130, 36, 36)
	closeBtn.Text = "🔘 Закрыть"
	closeBtn.TextColor3 = Color3.fromRGB(255,200,200)
	closeBtn.Font = Enum.Font.GothamSemibold
	closeBtn.TextSize = 14
	Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,8)

	-- notify
	local notifyLabel = Instance.new("TextLabel", gui)
	notifyLabel.Name = "FemboyNotify"
	notifyLabel.Size = UDim2.new(0,320,0,48)
	notifyLabel.Position = UDim2.new(0.5, -160, 0.15, 0)
	notifyLabel.BackgroundColor3 = Color3.fromRGB(28,28,36)
	notifyLabel.BackgroundTransparency = 1
	notifyLabel.TextColor3 = Color3.fromRGB(200,255,200)
	notifyLabel.Font = Enum.Font.GothamBold
	notifyLabel.TextSize = 16
	notifyLabel.Text = ""
	notifyLabel.Visible = false
	Instance.new("UICorner", notifyLabel).CornerRadius = UDim.new(0,10)

	-- drag support stored on frame for access later
	frame:SetAttribute("Dragging", false)

	return gui
end

local gui = createGUI()
local frame = gui:FindFirstChild("MainFrame")
local stealBtn = frame and frame:FindFirstChild("StealBtn")
local closeBtn = frame and frame:FindFirstChild("CloseBtn")
local notifyLabel = gui and gui:FindFirstChild("FemboyNotify")

-- safe showNotify
local function showNotify(text, bg)
	if not notifyLabel then return end
	notifyLabel.Text = text or ""
	notifyLabel.BackgroundColor3 = bg or Color3.fromRGB(28,28,36)
	notifyLabel.Visible = true
	notifyLabel.BackgroundTransparency = 1
	notifyLabel.TextTransparency = 1
	local ok, tween = pcall(function()
		return TweenService:Create(notifyLabel, TweenInfo.new(0.22), {BackgroundTransparency = 0.15, TextTransparency = 0})
	end)
	if ok and tween then tween:Play() end
	task.delay(1.2, function()
		pcall(function()
			local t2 = TweenService:Create(notifyLabel, TweenInfo.new(0.18), {BackgroundTransparency = 1, TextTransparency = 1})
			t2:Play()
		end)
		task.wait(0.2)
		notifyLabel.Visible = false
	end)
end

-- === Drag implementation (ПК + мобилки) ===
do
	if frame and frame:FindFirstChildOfClass("TextLabel") then
		local title = frame:FindFirstChildOfClass("TextLabel")
		local dragging, dragInput, dragStart, startPos
		local function update(input)
			if not (dragStart and startPos) then return end
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end

		title.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startPos = frame.Position

				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
					end
				end)
			end
		end)

		title.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				dragInput = input
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if input == dragInput and dragging then
				update(input)
			end
		end)
	end
end

-- === Утилиты ===
local function getAnyBasePart(model)
	if not model then return nil end
	if model.PrimaryPart and model.PrimaryPart:IsA("BasePart") then return model.PrimaryPart end
	for i = 1, #model:GetDescendants() do
		local d = model:GetDescendants()[i]
		if d:IsA("BasePart") then return d end
	end
	return nil
end

local function findMyBase()
	local basesFolder = Workspace:FindFirstChild("Bases")
	if not basesFolder then return nil end
	for i = 1, #basesFolder:GetChildren() do
		local base = basesFolder:GetChildren()[i]
		if base:IsA("Model") then
			local cfg = base:FindFirstChild("Configuration") or base:FindFirstChild("Configurationsa")
			if cfg then
				local pv = cfg:FindFirstChild("Player")
				if pv then
					-- pv.Value может быть Instance (ObjectValue) или строка (StringValue)
					local ok, val = pcall(function() return pv.Value end)
					if ok and val then
						if val == player then
							return base
						elseif typeof(val) == "Instance" and val.Name == player.Name then
							return base
						elseif type(val) == "string" and val == player.Name then
							return base
						end
					end
				end
			end
		end
	end
	return nil
end

local function findEnemyFemboy(myBase)
	local basesFolder = Workspace:FindFirstChild("Bases")
	if not basesFolder then return nil end
	for i = 1, #basesFolder:GetChildren() do
		local base = basesFolder:GetChildren()[i]
		if base:IsA("Model") and base ~= myBase then
			local slots = base:FindFirstChild("Slots")
			if slots then
				for j = 1, #slots:GetChildren() do
					local slot = slots:GetChildren()[j]
					for k = 1, #slot:GetChildren() do
						local m = slot:GetChildren()[k]
						if m:IsA("Model") then
							local nameLow = tostring(m.Name):lower()
							local endsWithFemboy = #nameLow >= 6 and string.sub(nameLow, -6) == "femboy"
							local isRoommateExact = nameLow == "roommate"
							if endsWithFemboy or isRoommateExact then
								return m, base
							end
						end
					end
				end
			end
		end
	end
	return nil, nil
end

local function findPromptInModel(rootModel, originPos, maxDist)
	if not rootModel then return nil end
	local best, bestD
	maxDist = maxDist or 20
	for i = 1, #rootModel:GetDescendants() do
		local desc = rootModel:GetDescendants()[i]
		if desc:IsA("ProximityPrompt") and desc.Enabled then
			local parentPart
			local parent = desc.Parent
			if parent then
				if parent:IsA("BasePart") then
					parentPart = parent
				elseif parent:IsA("Attachment") and parent.Parent and parent.Parent:IsA("BasePart") then
					parentPart = parent.Parent
				end
			end
			if parentPart then
				local ok, d = pcall(function() return (parentPart.Position - originPos).Magnitude end)
				if ok and d then
					if d <= maxDist and (not bestD or d < bestD) then
						best = desc
						bestD = d
					end
				end
			end
		end
	end
	return best
end

local function teleportCharacterToPosition(pos)
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart")
	if hrp then
		pcall(function() hrp.Velocity = Vector3.new(0,0,0) end)
		hrp.CFrame = CFrame.new(pos)
		RunService.Heartbeat:Wait()
		pcall(function() hrp.Velocity = Vector3.new(0,0,0) end)
	end
end

local function tryActivatePrompt(prompt)
	if not prompt then return false end
	-- try global helper first
	if typeof(fireproximityprompt) == "function" then
		local ok, err = pcall(function() fireproximityprompt(prompt) end)
		if ok then return true end
	end
	-- fallback: InputHoldBegin / InputHoldEnd
	local ok, err = pcall(function()
		if prompt.InputHoldBegin then
			prompt:InputHoldBegin()
			task.wait(prompt.HoldDuration or 0.5)
			prompt:InputHoldEnd()
		elseif prompt.Trigger then
			-- some prompts have :Trigger()
			prompt:Trigger()
		end
	end)
	return ok
end

-- === Основная логика ===
local function stealAndReturn()
	if not stealBtn then return end
	stealBtn.Active = false
	stealBtn.Text = "⏳ Выполняется..."

	local char = player.Character or player.CharacterAdded:Wait()
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		showNotify("⚠️ Гуманоид не найден", Color3.fromRGB(200,120,80))
		stealBtn.Text = "🌀 Украсть и вернуться"
		stealBtn.Active = true
		return
	end

	local myBase = findMyBase()
	if not myBase then
		showNotify("⚠️ Своя база не найдена!", Color3.fromRGB(200,80,80))
		goto finish
	end

	local targetModel, targetBase = findEnemyFemboy(myBase)
	if not targetModel then
		showNotify("❌ Не найдено femboy/roommate!", Color3.fromRGB(200,80,80))
		goto finish
	end

	local part = getAnyBasePart(targetModel)
	local targetPos
	if part then
		targetPos = part.Position + Vector3.new(0,3,0)
	elseif typeof(targetModel) == "Instance" and targetModel.GetModelCFrame then
		local ok, cf = pcall(function() return targetModel:GetModelCFrame() end)
		if ok and cf then targetPos = cf.Position + Vector3.new(0,3,0) end
	end

	if not targetPos then
		showNotify("⚠️ Не удалось определить позицию цели", Color3.fromRGB(200,80,80))
		goto finish
	end

	local savedWalk, savedJump = humanoid.WalkSpeed, humanoid.JumpHeight
	pcall(function()
		humanoid.WalkSpeed = 0
		humanoid.JumpHeight = 0
	end)

	showNotify("✨ Телепорт к цели...", Color3.fromRGB(80,120,220))
	teleportCharacterToPosition(targetPos)
	task.wait(0.15)

	local prompt = findPromptInModel(targetBase or targetModel, targetPos, 20)
	if prompt then
		local ok = tryActivatePrompt(prompt)
		if ok then
			showNotify("💸 Промпт активирован!", Color3.fromRGB(70,200,100))
		else
			showNotify("⚠️ Промпт найден, но не удалось активировать", Color3.fromRGB(220,140,80))
		end
	else
		showNotify("⚠️ Промпт не найден у цели", Color3.fromRGB(220,120,80))
	end

	task.wait(1)

	-- найти Spawn позиции в моей базе
	local spawn = myBase:FindFirstChild("Spawn")
	local spawnPos
	if spawn then
		if spawn:IsA("BasePart") then
			spawnPos = spawn.Position
		else
			local basePart = spawn:FindFirstChild("Base") or spawn:FindFirstChildWhichIsA("BasePart")
			if basePart and basePart:IsA("BasePart") then
				spawnPos = basePart.Position
			end
		end
	end

	if spawnPos then
		showNotify("🔁 Возврат на базу...", Color3.fromRGB(100,140,220))
		teleportCharacterToPosition(spawnPos + Vector3.new(0,3,0))
		task.wait(0.25)
		showNotify("🏠 Вы вернулись!", Color3.fromRGB(80,200,120))
	else
		showNotify("⚠️ Spawn не найден", Color3.fromRGB(200,120,80))
	end

	-- вернуть параметры
	pcall(function()
		humanoid.WalkSpeed = savedWalk or 16
		humanoid.JumpHeight = savedJump or 7.2
	end)

	::finish::
	stealBtn.Text = "🌀 Украсть и вернуться"
	stealBtn.Active = true
end

if stealBtn then
	stealBtn.MouseButton1Click:Connect(function()
		if not stealBtn.Active then return end
		task.spawn(function()
			local ok, err = pcall(stealAndReturn)
			if not ok then
				warn("stealAndReturn error:", err)
				showNotify("❌ Ошибка: "..tostring(err), Color3.fromRGB(220,80,80))
			end
		end)
	end)
end

if closeBtn then
	closeBtn.MouseButton1Click:Connect(function()
		if gui then
			pcall(function() gui:Destroy() end)
		end
	end)
end

if UserInputService.TouchEnabled and frame then
	frame.Size = UDim2.new(0, 340, 0, 160)
	if stealBtn then stealBtn.Size = UDim2.new(1, -40, 0, 54) end
	if closeBtn then closeBtn.Size = UDim2.new(1, -40, 0, 44) end
end

print("✅ FemboyStealerUI loaded and auto-installed (if needed).")
showNotify("🚀 Скрипт активирован!", Color3.fromRGB(90,180,255))
