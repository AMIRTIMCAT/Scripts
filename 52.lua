-- LocalScript: Femboy Stealer UI (Fixed + Drag + Mobile Support)
-- ПОЛОЖИ В StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
if not player then return end

-- UI
local gui = Instance.new("ScreenGui")
gui.Name = "FemboyStealerUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 140)
frame.Position = UDim2.new(0.5, -130, 0.5, -70)
frame.BackgroundColor3 = Color3.fromRGB(18,18,24)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = false -- отключено, используем свой drag
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
stealBtn.Size = UDim2.new(1, -40, 0, 44)
stealBtn.Position = UDim2.new(0, 20, 0, 48)
stealBtn.BackgroundColor3 = Color3.fromRGB(52, 56, 92)
stealBtn.Text = "🌀 Украсть и вернуться"
stealBtn.TextColor3 = Color3.fromRGB(240,240,240)
stealBtn.Font = Enum.Font.GothamBold
stealBtn.TextSize = 16
local stealCorner = Instance.new("UICorner", stealBtn)
stealCorner.CornerRadius = UDim.new(0,8)

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(1, -40, 0, 36)
closeBtn.Position = UDim2.new(0, 20, 0, 100)
closeBtn.BackgroundColor3 = Color3.fromRGB(130, 36, 36)
closeBtn.Text = "🔘 Закрыть"
closeBtn.TextColor3 = Color3.fromRGB(255,200,200)
closeBtn.Font = Enum.Font.GothamSemibold
closeBtn.TextSize = 14
local closeCorner = Instance.new("UICorner", closeBtn)
closeCorner.CornerRadius = UDim.new(0,8)

-- notify
local notifyLabel = Instance.new("TextLabel", gui)
notifyLabel.Size = UDim2.new(0,320,0,48)
notifyLabel.Position = UDim2.new(0.5, -160, 0.15, 0)
notifyLabel.BackgroundColor3 = Color3.fromRGB(28,28,36)
notifyLabel.BackgroundTransparency = 1
notifyLabel.TextColor3 = Color3.fromRGB(200,255,200)
notifyLabel.Font = Enum.Font.GothamBold
notifyLabel.TextSize = 16
notifyLabel.Text = ""
notifyLabel.Visible = false
local notifyCorner = Instance.new("UICorner", notifyLabel)
notifyCorner.CornerRadius = UDim.new(0,10)

local function showNotify(text, bg)
	notifyLabel.Text = text
	notifyLabel.BackgroundColor3 = bg or Color3.fromRGB(28,28,36)
	notifyLabel.Visible = true
	notifyLabel.BackgroundTransparency = 1
	notifyLabel.TextTransparency = 1
	TweenService:Create(notifyLabel, TweenInfo.new(0.22), {BackgroundTransparency = 0.15, TextTransparency = 0}):Play()
	task.delay(1.2, function()
		TweenService:Create(notifyLabel, TweenInfo.new(0.18), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
		task.wait(0.2)
		notifyLabel.Visible = false
	end)
end

-- Drag (поддержка ПК и мобилы)
do
	local dragging, dragInput, dragStart, startPos

	local function update(input)
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

-- Utility: безопасно получить child which is BasePart
local function getAnyBasePart(model)
	if not model then return nil end
	if model.PrimaryPart and model.PrimaryPart:IsA("BasePart") then return model.PrimaryPart end
	for _,d in ipairs(model:GetDescendants()) do
		if d:IsA("BasePart") then return d end
	end
	return nil
end

-- Получаем мою базу
local function findMyBase()
	local basesFolder = Workspace:FindFirstChild("Bases")
	if not basesFolder then return nil end
	for _, base in ipairs(basesFolder:GetChildren()) do
		if base:IsA("Model") then
			local cfg = base:FindFirstChild("Configuration") or base:FindFirstChild("Configurationsa")
			if cfg then
				local pv = cfg:FindFirstChild("Player")
				if pv then
					local val = pv.Value
					if val == player then
						return base
					elseif type(val) == "Instance" and val.Name == player.Name then
						return base
					elseif pv:IsA("StringValue") and pv.Value == player.Name then
						return base
					end
				end
			end
		end
	end
	return nil
end

-- найти модель, где имя заканчивается на "femboy" или имя точно "roommate"
local function findEnemyFemboy(myBase)
	local basesFolder = Workspace:FindFirstChild("Bases")
	if not basesFolder then return nil end

	for _, base in ipairs(basesFolder:GetChildren()) do
		if base:IsA("Model") and base ~= myBase then
			local slots = base:FindFirstChild("Slots")
			if slots then
				for _, slot in ipairs(slots:GetChildren()) do
					for _, m in ipairs(slot:GetChildren()) do
						if m:IsA("Model") then
							local nameLow = tostring(m.Name):lower()
							local endsWithFemboy = string.sub(nameLow, -6) == "femboy"
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

-- Найти ближайший ProximityPrompt
local function findPromptInModel(rootModel, originPos, maxDist)
	if not rootModel then return nil end
	local best, bestD
	maxDist = maxDist or 20
	for _,desc in ipairs(rootModel:GetDescendants()) do
		if desc:IsA("ProximityPrompt") and desc.Enabled then
			local parent = desc.Parent
			if parent and parent:IsA("BasePart") then
				local d = (parent.Position - originPos).Magnitude
				if d <= maxDist and (not bestD or d < bestD) then
					best = desc
					bestD = d
				end
			end
		end
	end
	return best
end

-- телепорт HRP
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

-- главный процесс
local function stealAndReturn()
	stealBtn.Active = false
	stealBtn.Text = "⏳ Выполняется..."

	local char = player.Character or player.CharacterAdded:Wait()
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	local hrp = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart")

	local myBase = findMyBase()
	if not myBase then
		showNotify("⚠️ Своя база не найдена!", Color3.fromRGB(200,80,80))
		goto endRoutine
	end

	local targetModel, targetBase = findEnemyFemboy(myBase)
	if not targetModel then
		showNotify("❌ Не найдено femboy/roommate!", Color3.fromRGB(200,80,80))
		goto endRoutine
	end

	local part = getAnyBasePart(targetModel)
	local targetPos
	if part then targetPos = part.Position + Vector3.new(0, 3, 0)
	elseif targetModel.GetModelCFrame then
		local ok, cf = pcall(function() return targetModel:GetModelCFrame() end)
		if ok and cf then targetPos = cf.p + Vector3.new(0,3,0) end
	end
	if not targetPos then
		showNotify("⚠️ Не удалось определить позицию цели", Color3.fromRGB(200,80,80))
		goto endRoutine
	end

	local savedWalk = {}
	if humanoid then
		savedWalk = {WalkSpeed = humanoid.WalkSpeed, JumpPower = humanoid.JumpPower}
		humanoid.WalkSpeed = 0
		humanoid.JumpPower = 0
	end

	showNotify("✨ Телепорт к цели...", Color3.fromRGB(80,120,220))
	teleportCharacterToPosition(targetPos)
	task.wait(0.15)

	local prompt = findPromptInModel(targetBase or targetModel, targetPos, 20)
	if prompt then
		pcall(function() fireproximityprompt(prompt) end)
		showNotify("💸 Промпт активирован!", Color3.fromRGB(70,200,100))
	else
		showNotify("⚠️ Промпт не найден у цели", Color3.fromRGB(220,120,80))
	end

	task.wait(1)

	local spawn = myBase:FindFirstChild("Spawn")
	local spawnPos
	if spawn then
		if spawn:IsA("BasePart") then spawnPos = spawn.Position
		else
			local basePart = spawn:FindFirstChild("Base")
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

	if humanoid and savedWalk then
		humanoid.WalkSpeed = savedWalk.WalkSpeed or 16
		humanoid.JumpPower = savedWalk.JumpPower or humanoid.JumpPower
	end

	::endRoutine::
	stealBtn.Text = "🌀 Украсть и вернуться"
	stealBtn.Active = true
end

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

closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- Mobile tweak
if UserInputService.TouchEnabled then
	frame.Size = UDim2.new(0, 340, 0, 160)
	stealBtn.Size = UDim2.new(1, -40, 0, 54)
	closeBtn.Size = UDim2.new(1, -40, 0, 44)
end

print("✅ FemboyStealerUI loaded with drag + mobile support.")
