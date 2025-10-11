-- Roblox LocalScript: Маленький переносимый UI с кнопкой закрытия
-- Как использовать:
-- 1) Создайте LocalScript и вставьте этот код в StarterPlayerScripts или StarterGui.
-- 2) Скрипт автоматически создаст ScreenGui в PlayerGui и покажет окно.
-- 3) Окно можно перетаскивать за заголовок, и закрыть кнопку X (скрывает GUI).

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Создаём ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MiniUI"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 50
screenGui.Parent = playerGui

-- Основное окно
local frame = Instance.new("Frame")
frame.Name = "Window"
frame.Size = UDim2.new(0, 320, 0, 160)
frame.Position = UDim2.new(0.35, 0, 0.35, 0)
frame.AnchorPoint = Vector2.new(0, 0)
frame.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Тень (легкая) - для эстетики
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = frame

local shadow = Instance.new("Frame")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 6, 1, 6)
shadow.Position = UDim2.new(0, -3, 0, -3)
shadow.BackgroundTransparency = 0.9
shadow.Parent = frame
shadow.ZIndex = 0

-- Панель заголовка (за неё можно тянуть)
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 32)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Маленькое окно"
title.TextColor3 = Color3.fromRGB(240, 240, 240)
title.Font = Enum.Font.SourceSansSemibold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Кнопка закрытия
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "Close"
closeBtn.Size = UDim2.new(0, 44, 0, 24)
closeBtn.Position = UDim2.new(1, -54, 0, 4)
closeBtn.AnchorPoint = Vector2.new(0, 0)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 18
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BackgroundColor3 = Color3.fromRGB(175, 50, 60)
closeBtn.BorderSizePixel = 0
closeBtn.AutoButtonColor = true
closeBtn.Parent = titleBar

-- Содержимое окна (пример)
local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -16, 1, -44)
content.Position = UDim2.new(0, 8, 0, 36)
content.BackgroundTransparency = 1
content.Parent = frame

local exampleLabel = Instance.new("TextLabel")
exampleLabel.Size = UDim2.new(1, 0, 0, 24)
exampleLabel.Position = UDim2.new(0, 0, 0, 0)
exampleLabel.BackgroundTransparency = 1
exampleLabel.Text = "Пример: маленький UI, перетаскиваемый за заголовок"
exampleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
exampleLabel.Font = Enum.Font.SourceSans
exampleLabel.TextSize = 14
exampleLabel.TextWrapped = true
exampleLabel.TextXAlignment = Enum.TextXAlignment.Left
exampleLabel.Parent = content

-- Поведение кнопки закрытия
closeBtn.MouseButton1Click:Connect(function()
    screenGui.Enabled = false -- скрываем UI
end)

-- Сделаем окно перетаскиваемым за titleBar (работает для мыши на ПК)
local dragging = false
local dragInput
local dragStart
local startPos

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

-- Поддержка сенсорных экранов (при желании можно убрать)
-- Для сенсора используем Touch
local touchDragging = false
local touchStart

titleBar.TouchStarted:Connect(function(touch, gpe)
    touchDragging = true
    touchStart = touch.Position
    startPos = frame.Position
end)

UserInputService.TouchMoved:Connect(function(touch, gpe)
    if touchDragging then
        local delta = touch.Position - touchStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

titleBar.TouchEnded:Connect(function(touch, gpe)
    touchDragging = false
end)

-- Дополнительно: горячая клавиша для открытия (пример: RightControl)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        screenGui.Enabled = not screenGui.Enabled
    end
end)

-- Конец скрипта
