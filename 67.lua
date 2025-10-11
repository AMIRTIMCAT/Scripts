-- LocalScript: Femboy Stealer UI (Упрощенная версия)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
if not player then return end

-- === UI ===
local playerGui = player:WaitForChild("PlayerGui")

-- Удаляем старый UI если есть
local oldGui = playerGui:FindFirstChild("FemboyStealerUI")
if oldGui then oldGui:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "FemboyStealerUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 140)
frame.Position = UDim2.new(0.5, -130, 0.5, -70)
frame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = false
frame.Parent = gui

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(70, 70, 110)
stroke.Thickness = 1.6

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -20, 0, 30)
title.Position = UDim2.new(0, 10, 0, 8)
title.BackgroundTransparency = 1
title.Text = "🌀 Украсть и вернуться"
title.TextColor3 = Color3.fromRGB(230, 230, 230)
title.Font = Enum.Font.GothamSemibold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left

local stealBtn = Instance.new("TextButton", frame)
stealBtn.Size = UDim2.new(1, -40, 0, 44)
stealBtn.Position = UDim2.new(0, 20, 0, 48)
stealBtn.BackgroundColor3 = Color3.fromRGB(52, 56, 92)
stealBtn.Text = "🌀 Украсть и вернуться"
stealBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
stealBtn.Font = Enum.Font.GothamBold
stealBtn.TextSize = 16
stealBtn.AutoButtonColor = true
Instance.new("UICorner", stealBtn).CornerRadius = UDim.new(0, 8)

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(1, -40, 0, 36)
closeBtn.Position = UDim2.new(0, 20, 0, 100)
closeBtn.BackgroundColor3 = Color3.fromRGB(130, 36, 36)
closeBtn.Text = "🔘 Закрыть"
closeBtn.TextColor3 = Color3.fromRGB(255, 200, 200)
closeBtn.Font = Enum.Font.GothamSemibold
closeBtn.TextSize = 14
closeBtn.AutoButtonColor = true
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

-- === Уведомления ===
local notifyLabel = Instance.new("TextLabel", gui)
notifyLabel.Size = UDim2.new(0, 320, 0, 48)
notifyLabel.Position = UDim2.new(0.5, -160, 0.15, 0)
notifyLabel.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
notifyLabel.BackgroundTransparency = 1
notifyLabel.TextColor3 = Color3.fromRGB(200, 255, 200)
notifyLabel.Font = Enum.Font.GothamBold
notifyLabel.TextSize = 16
notifyLabel.Text = ""
notifyLabel.Visible = false
notifyLabel.TextWrapped = true
Instance.new("UICorner", notifyLabel).CornerRadius = UDim.new(0, 10)

local function showNotify(text, bg)
    notifyLabel.Text = text
    notifyLabel.BackgroundColor3 = bg or Color3.fromRGB(28, 28, 36)
    notifyLabel.Visible = true
    notifyLabel.BackgroundTransparency = 1
    notifyLabel.TextTransparency = 1
    
    local fadeIn = TweenService:Create(notifyLabel, TweenInfo.new(0.22), {
        BackgroundTransparency = 0.15,
        TextTransparency = 0
    })
    fadeIn:Play()
    
    task.delay(1.8, function()
        local fadeOut = TweenService:Create(notifyLabel, TweenInfo.new(0.18), {
            BackgroundTransparency = 1,
            TextTransparency = 1
        })
        fadeOut:Play()
        fadeOut.Completed:Connect(function()
            notifyLabel.Visible = false
        end)
    end)
end

-- === Drag система ===
do
    local dragging = false
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end

    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
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
        if input.UserInputType == Enum.UserInputType.MouseMovement or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- === Вспомогательные функции ===
local function getAnyBasePart(model)
    if not model then return nil end
    
    if model.PrimaryPart and model.PrimaryPart:IsA("BasePart") then 
        return model.PrimaryPart 
    end
    
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("BasePart") then 
            return d 
        end
    end
    
    return nil
end

local function findMyBase()
    local basesFolder = Workspace:FindFirstChild("Bases")
    if not basesFolder then return nil end
    
    for _, base in ipairs(basesFolder:GetChildren()) do
        if base:IsA("Model") then
            local cfg = base:FindFirstChild("Configuration") or base:FindFirstChild("Configurationsa")
            if cfg then
                local pv = cfg:FindFirstChild("Player")
                if pv and (pv.Value == player or pv.Value == player.Name) then
                    return base
                end
            end
        end
    end
    
    return nil
end

local function findEnemyFemboy(myBase)
    local basesFolder = Workspace:FindFirstChild("Bases")
    if not basesFolder then return nil, nil end
    
    for _, base in ipairs(basesFolder:GetChildren()) do
        if base:IsA("Model") and base ~= myBase then
            local slots = base:FindFirstChild("Slots")
            if slots then
                for _, slot in ipairs(slots:GetChildren()) do
                    for _, m in ipairs(slot:GetChildren()) do
                        if m:IsA("Model") then
                            local n = m.Name:lower()
                            if n:find("femboy") or n == "roommate" then
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

local function teleportCharacterToPosition(pos)
    local char = player.Character
    if not char then return false end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    pcall(function() 
        hrp.Velocity = Vector3.zero 
        hrp.AssemblyLinearVelocity = Vector3.zero
    end)
    
    hrp.CFrame = CFrame.new(pos)
    RunService.Heartbeat:Wait()
    
    pcall(function() 
        hrp.Velocity = Vector3.zero 
        hrp.AssemblyLinearVelocity = Vector3.zero
    end)
    
    return true
end

local function findPromptInModel(rootModel, originPos, maxDist)
    local best, bestD
    maxDist = maxDist or 20
    
    for _, desc in ipairs(rootModel:GetDescendants()) do
        if desc:IsA("ProximityPrompt") and desc.Enabled then
            local part = desc.Parent
            if part and part:IsA("BasePart") then
                local d = (part.Position - originPos).Magnitude
                if d <= maxDist and (not bestD or d < bestD) then
                    best = desc
                    bestD = d
                end
            end
        end
    end
    
    return best
end

-- === Основная логика ===
local isRunning = false

local function stealAndReturn()
    if isRunning then
        showNotify("⚠️ Уже выполняется!", Color3.fromRGB(220, 120, 80))
        return
    end
    
    isRunning = true
    stealBtn.Active = false
    stealBtn.Text = "⏳ Выполняется..."

    local char = player.Character
    if not char then
        showNotify("❌ Персонаж не найден!", Color3.fromRGB(200, 80, 80))
    end
    
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    
    if not hum or not hrp then
        showNotify("❌ Humanoid/HRP не найден!", Color3.fromRGB(200, 80, 80))
    end

    local myBase = findMyBase()
    if not myBase then
        showNotify("⚠️ Своя база не найдена!", Color3.fromRGB(200, 80, 80))
    end

    local targetModel, targetBase = findEnemyFemboy(myBase)
    if not targetModel then
        showNotify("❌ Femboy/Roommate не найден!", Color3.fromRGB(200, 80, 80))
    end

    local part = getAnyBasePart(targetModel)
    if not part then
        showNotify("⚠️ Не удалось найти часть цели", Color3.fromRGB(200, 80, 80))
    end
    
    local pos = part.Position + Vector3.new(0, 3, 0)

    -- Сохраняем параметры
    local savedWalkSpeed = hum.WalkSpeed
    local savedJumpPower = hum.JumpPower
    hum.WalkSpeed = 0
    hum.JumpPower = 0

    showNotify("✨ Телепорт к цели...", Color3.fromRGB(80, 120, 220))
    
    if not teleportCharacterToPosition(pos) then
        showNotify("❌ Ошибка телепортации!", Color3.fromRGB(200, 80, 80))
        hum.WalkSpeed = savedWalkSpeed
        hum.JumpPower = savedJumpPower
        goto done
    end
    
    task.wait(0.3)

    -- Ищем и активируем промпт
    local prompt = findPromptInModel(targetBase or targetModel, pos, 25)
    if prompt then
        local success, err = pcall(function()
            -- Безопасная проверка fireproximityprompt
            local hasFirePrompt = false
            pcall(function()
                hasFirePrompt = typeof(fireproximityprompt) == "function"
            end)
            
            if hasFirePrompt then
                fireproximityprompt(prompt, 1)
            else
                -- Альтернативный метод
                prompt:InputHoldBegin()
                task.wait(prompt.HoldDuration or 0.5)
                prompt:InputHoldEnd()
            end
        end)
        
        if success then
            showNotify("💸 Промпт активирован!", Color3.fromRGB(70, 200, 100))
        else
            showNotify("⚠️ Ошибка: " .. tostring(err), Color3.fromRGB(220, 120, 80))
        end
    else
        showNotify("⚠️ Промпт не найден", Color3.fromRGB(220, 120, 80))
    end

    task.wait(1)

    -- Возврат на базу
    local spawn = myBase:FindFirstChild("Spawn")
    if spawn then
        local spawnPos
        if spawn:IsA("BasePart") then
            spawnPos = spawn.Position
        else
            local base = spawn:FindFirstChild("Base")
            if base and base:IsA("BasePart") then
                spawnPos = base.Position
            end
        end
        
        if spawnPos then
            showNotify("🔁 Возврат на базу...", Color3.fromRGB(100, 140, 220))
            teleportCharacterToPosition(spawnPos + Vector3.new(0, 3, 0))
            task.wait(0.3)
            showNotify("🏠 Вы вернулись!", Color3.fromRGB(80, 200, 120))
        end
    end

    -- Восстанавливаем параметры
    if hum then
        hum.WalkSpeed = savedWalkSpeed
        hum.JumpPower = savedJumpPower
    end

    ::done::
    stealBtn.Text = "🌀 Украсть и вернуться"
    stealBtn.Active = true
    isRunning = false
end

-- === Обработчики событий ===
stealBtn.MouseButton1Click:Connect(function()
    if stealBtn.Active and not isRunning then
        task.spawn(function()
            local ok, err = pcall(stealAndReturn)
            if not ok then
                showNotify("❌ Ошибка: " .. tostring(err), Color3.fromRGB(220, 80, 80))
                stealBtn.Text = "🌀 Украсть и вернуться"
                stealBtn.Active = true
                isRunning = false
            end
        end)
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- === Адаптация для мобильных ===
if UserInputService.TouchEnabled then
    frame.Size = UDim2.new(0, 340, 0, 160)
    frame.Position = UDim2.new(0.5, -170, 0.5, -80)
    stealBtn.Size = UDim2.new(1, -40, 0, 54)
    stealBtn.Position = UDim2.new(0, 20, 0, 48)
    closeBtn.Size = UDim2.new(1, -40, 0, 44)
    closeBtn.Position = UDim2.new(0, 20, 0, 110)
end

print("✅ FemboyStealerUI loaded!")
showNotify("🚀 Скрипт активирован!", Color3.fromRGB(90, 180, 255))
