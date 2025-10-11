-- Roblox LocalScript: Windows-style UI + безопасная проверка наличия XDAntiCheat.lua
-- ВАЖНО: Скрипт НЕ удаляет файлы и не помогает обходить античит.
-- Этот скрипт только проверяет существование файла по пути
-- Workspace.StarterPlayer.StarterCharacterScripts.XDAntiCheat.lua (если такой есть)
-- и отображает красивое уведомление: найдено / не найдено.
-- Как использовать:
-- 1) Вставь этот LocalScript в StarterPlayerScripts или StarterGui.
-- 2) Запусти игру. UI появится, выполнит проверку и покажет результат.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Функция безопасной проверки (без удаления)
local function checkAntiCheatPath()
    local success, found = pcall(function()
        local ws = game:GetService("Workspace")
        if not ws then return nil end
        local sp = ws:FindFirstChild("StarterPlayer")
        if not sp then return nil end
        local scs = sp:FindFirstChild("StarterCharacterScripts")
        if not scs then return nil end
        local xd = scs:FindFirstChild("XDAntiCheat.lua") or scs:FindFirstChild("XDAntiCheat")
        -- Иногда объект может быть ModuleScript/Script без .lua в названии; проверяем оба варианта
        return xd
    end)
    if not success then
        return nil, "error"
    end
    if found then
        return found, "found"
    else
        return nil, "not_found"
    end
end

-- Создаём ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WinStyleMiniUI"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 100
screenGui.Parent = playerGui

-- Основное окно (фон)
local frame = Instance.new("Frame")
frame.Name = "Window"
frame.Size = UDim2.new(0, 380, 0, 120)
frame.Position = UDim2.new(0.5, -190, 0.4, -60)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(245, 246, 250) -- светлый Windows фон
frame.BorderSizePixel = 0
frame.ZIndex = 2
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

-- Тень
local shadow = Instance.new("Frame")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 8, 1, 8)
shadow.Position = UDim2.new(0, -4, 0, -4)
shadow.BackgroundTransparency = 0.9
shadow.ZIndex = 1
shadow.Parent = frame

local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 36)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(230, 232, 235)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 16, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Панель — Система"
title.TextColor3 = Color3.fromRGB(24, 24, 27)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Name = "Close"
closeBtn.Size = UDim2.new(0, 36, 0, 24)
closeBtn.Position = UDim2.new(1, -48, 0, 6)
closeBtn.BackgroundTransparency = 0
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.BorderSizePixel = 0
closeBtn.AutoButtonColor = true
closeBtn.Parent = titleBar

-- Content area
local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -24, 1, -48)
content.Position = UDim2.new(0, 12, 0, 44)
content.BackgroundTransparency = 1
content.Parent = frame

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "Status"
statusLabel.Size = UDim2.new(1, 0, 0, 48)
statusLabel.Position = UDim2.new(0, 0, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Проверка..."
statusLabel.TextWrapped = true
statusLabel.TextColor3 = Color3.fromRGB(30,30,30)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 15
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.TextYAlignment = Enum.TextYAlignment.Center
statusLabel.Parent = content

local hint = Instance.new("TextLabel")
hint.Name = "Hint"
hint.Size = UDim2.new(1, 0, 0, 20)
hint.Position = UDim2.new(0, 0, 0, 52)
hint.BackgroundTransparency = 1
hint.Text = "Это безопасная проверка — ничего не удаляется."
hint.TextColor3 = Color3.fromRGB(110,110,115)
hint.Font = Enum.Font.Gotham
hint.TextSize = 12
hint.TextXAlignment = Enum.TextXAlignment.Left
hint.Parent = content

-- Иконка статуса (круг)
local statusIcon = Instance.new("Frame")
statusIcon.Name = "Icon"
statusIcon.Size = UDim2.new(0, 40, 0, 40)
statusIcon.Position = UDim2.new(1, -46, 0, 4)
statusIcon.AnchorPoint = Vector2.new(0, 0)
statusIcon.BackgroundColor3 = Color3.fromRGB(200,200,200)
statusIcon.BorderSizePixel = 0
statusIcon.Parent = frame
local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 8)
iconCorner.Parent = statusIcon

-- Анимация появления
frame.Position = UDim2.new(0.5, -190, 0.2, -60)
frame.BackgroundTransparency = 1
spawn(function()
    for i = 1, 10 do
        frame.BackgroundTransparency = frame.BackgroundTransparency - 0.1
        RunService.RenderStepped:Wait()
    end
end)

-- Функция для отображения результата
local function showResult(state, obj)
    if state == "found" then
        statusLabel.Text = "✅ Anti-Cheat найден: " .. (obj.Name or "(без имени)")
        statusIcon.BackgroundColor3 = Color3.fromRGB(94, 165, 255) -- синий
    elseif state == "not_found" then
        statusLabel.Text = "ℹ️ Anti-Cheat не найден в указанном пути."
        statusIcon.BackgroundColor3 = Color3.fromRGB(200,200,200)
    else
        statusLabel.Text = "⚠️ Произошла ошибка при проверке."
        statusIcon.BackgroundColor3 = Color3.fromRGB(220,140,140)
    end
end

-- Делаем окно перетаскиваемым за titleBar
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
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

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Закрытие
closeBtn.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

-- Горячая клавиша для скрытия (RightControl)
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        screenGui.Enabled = not screenGui.Enabled
    end
end)

-- Запускаем проверку и показываем результат
spawn(function()
    local obj, state = checkAntiCheatPath()
    if state == "found" then
        showResult("found", obj)
    elseif state == "not_found" then
        showResult("not_found")
    else
        showResult("error")
    end

    -- Оставляем сообщение на экране 4 секунды, затем плавно скрываем текст (не удаляем окно полностью)
    wait(4)
    -- Плавное скрытие текста
    for i = 1, 10 do
        statusLabel.TextTransparency = statusLabel.TextTransparency + 0.1
        hint.TextTransparency = hint.TextTransparency + 0.1
        RunService.RenderStepped:Wait()
    end
end)

-- Конец скрипта
