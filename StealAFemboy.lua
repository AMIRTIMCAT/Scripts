-- Универсальный скрипт для PC и Mobile
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Создаем главный UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CompactUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Главное окно (немного увеличим для ползунка)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainWindow"
mainFrame.Size = UDim2.new(0, 300, 0, 280)
mainFrame.Position = UDim2.new(0, 50, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Закругленные углы
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = mainFrame

-- Тень
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(80, 80, 120)
UIStroke.Thickness = 2
UIStroke.Parent = mainFrame

-- Заголовок для перетаскивания
local titleBar = Instance.new("TextButton")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
titleBar.BorderSizePixel = 0
titleBar.Text = "🔧 Компактный UI"
titleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
titleBar.TextSize = 14
titleBar.Font = Enum.Font.GothamSemibold
titleBar.Parent = mainFrame

-- Закругление только сверху
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

-- Контент
local contentFrame = Instance.new("Frame")
contentFrame.Name = "Content"
contentFrame.Size = UDim2.new(1, -20, 1, -40)
contentFrame.Position = UDim2.new(0, 10, 0, 35)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Функция NoClip
local noclipEnabled = false
local noclipConnection

local function noclip()
    if noclipEnabled and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end

-- Toggle Switch для NoClip
local toggleFrame = Instance.new("Frame")
toggleFrame.Name = "ToggleFrame"
toggleFrame.Size = UDim2.new(1, 0, 0, 40)
toggleFrame.Position = UDim2.new(0, 0, 0, 0)
toggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
toggleFrame.BorderSizePixel = 0
toggleFrame.Parent = contentFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleFrame

-- Текст тоггла
local toggleLabel = Instance.new("TextLabel")
toggleLabel.Name = "ToggleLabel"
toggleLabel.Size = UDim2.new(0, 150, 1, 0)
toggleLabel.Position = UDim2.new(0, 10, 0, 0)
toggleLabel.BackgroundTransparency = 1
toggleLabel.Text = "NoClip Режим"
toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
toggleLabel.Font = Enum.Font.GothamSemibold
toggleLabel.TextSize = 14
toggleLabel.Parent = toggleFrame

-- Переключатель
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 50, 0, 25)
toggleButton.Position = UDim2.new(1, -60, 0.5, -12)
toggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
toggleButton.BorderSizePixel = 0
toggleButton.Text = ""
toggleButton.Parent = toggleFrame

local toggleButtonCorner = Instance.new("UICorner")
toggleButtonCorner.CornerRadius = UDim.new(1, 0)
toggleButtonCorner.Parent = toggleButton

-- Кружок внутри тоггла
local toggleCircle = Instance.new("Frame")
toggleCircle.Name = "ToggleCircle"
toggleCircle.Size = UDim2.new(0, 19, 0, 19)
toggleCircle.Position = UDim2.new(0, 3, 0, 3)
toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggleCircle.BorderSizePixel = 0
toggleCircle.Parent = toggleButton

local toggleCircleCorner = Instance.new("UICorner")
toggleCircleCorner.CornerRadius = UDim.new(1, 0)
toggleCircleCorner.Parent = toggleCircle

-- Ползунок WalkSpeed
local speedSliderFrame = Instance.new("Frame")
speedSliderFrame.Name = "SpeedSliderFrame"
speedSliderFrame.Size = UDim2.new(1, 0, 0, 60)
speedSliderFrame.Position = UDim2.new(0, 0, 0, 50)
speedSliderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
speedSliderFrame.BorderSizePixel = 0
speedSliderFrame.Parent = contentFrame

local speedSliderCorner = Instance.new("UICorner")
speedSliderCorner.CornerRadius = UDim.new(0, 8)
speedSliderCorner.Parent = speedSliderFrame

-- Заголовок ползунка
local speedLabel = Instance.new("TextLabel")
speedLabel.Name = "SpeedLabel"
speedLabel.Size = UDim2.new(1, -20, 0, 20)
speedLabel.Position = UDim2.new(0, 10, 0, 5)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Скорость: 16"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Font = Enum.Font.GothamSemibold
speedLabel.TextSize = 14
speedLabel.Parent = speedSliderFrame

-- Фон ползунка
local sliderTrack = Instance.new("Frame")
sliderTrack.Name = "SliderTrack"
sliderTrack.Size = UDim2.new(1, -20, 0, 6)
sliderTrack.Position = UDim2.new(0, 10, 0, 30)
sliderTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
sliderTrack.BorderSizePixel = 0
sliderTrack.Parent = speedSliderFrame

local sliderTrackCorner = Instance.new("UICorner")
sliderTrackCorner.CornerRadius = UDim.new(1, 0)
sliderTrackCorner.Parent = sliderTrack

-- Заполненная часть ползунка
local sliderFill = Instance.new("Frame")
sliderFill.Name = "SliderFill"
sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
sliderFill.Position = UDim2.new(0, 0, 0, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(65, 105, 225)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderTrack

local sliderFillCorner = Instance.new("UICorner")
sliderFillCorner.CornerRadius = UDim.new(1, 0)
sliderFillCorner.Parent = sliderFill

-- Бегунок ползунка
local sliderThumb = Instance.new("TextButton")
sliderThumb.Name = "SliderThumb"
sliderThumb.Size = UDim2.new(0, 20, 0, 20)
sliderThumb.Position = UDim2.new(0.5, -10, 0.5, -10)
sliderThumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderThumb.BorderSizePixel = 0
sliderThumb.Text = ""
sliderThumb.ZIndex = 2
sliderThumb.Parent = sliderTrack

local sliderThumbCorner = Instance.new("UICorner")
sliderThumbCorner.CornerRadius = UDim.new(1, 0)
sliderThumbCorner.Parent = sliderThumb

-- Тень бегунка
local thumbStroke = Instance.new("UIStroke")
thumbStroke.Color = Color3.fromRGB(100, 100, 150)
thumbStroke.Thickness = 2
thumbStroke.Parent = sliderThumb

-- Кнопка Fly
local flyButton = Instance.new("TextButton")
flyButton.Name = "FlyButton"
flyButton.Size = UDim2.new(1, 0, 0, 35)
flyButton.Position = UDim2.new(0, 0, 0, 120)
flyButton.BackgroundColor3 = Color3.fromRGB(106, 90, 205)
flyButton.BorderSizePixel = 0
flyButton.Text = "🕊️ Fly Mode"
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.Font = Enum.Font.GothamSemibold
flyButton.TextSize = 14
flyButton.Parent = contentFrame

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 8)
flyCorner.Parent = flyButton

-- Кнопка Reset
local resetButton = Instance.new("TextButton")
resetButton.Name = "ResetButton"
resetButton.Size = UDim2.new(1, 0, 0, 30)
resetButton.Position = UDim2.new(0, 0, 0, 165)
resetButton.BackgroundColor3 = Color3.fromRGB(255, 69, 0)
resetButton.BorderSizePixel = 0
resetButton.Text = "🔄 Сбросить скорость"
resetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
resetButton.Font = Enum.Font.GothamSemibold
resetButton.TextSize = 12
resetButton.Parent = contentFrame

local resetCorner = Instance.new("UICorner")
resetCorner.CornerRadius = UDim.new(0, 8)
resetCorner.Parent = resetButton

-- Статус бар
local statusBar = Instance.new("Frame")
statusBar.Name = "StatusBar"
statusBar.Size = UDim2.new(1, 0, 0, 3)
statusBar.Position = UDim2.new(0, 0, 1, -3)
statusBar.BackgroundColor3 = Color3.fromRGB(65, 105, 225)
statusBar.BorderSizePixel = 0
statusBar.Parent = mainFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 12)
statusCorner.Parent = statusBar

-- ФУНКЦИОНАЛ

-- Перетаскивание окна
local dragging = false
local dragStart, startPos

local function updateInput(input)
    if dragging then
        local delta
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            delta = input.Position - dragStart
        end
        if delta then
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        mainFrame.ZIndex = 10
        titleBar.ZIndex = 11
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                mainFrame.ZIndex = 1
                titleBar.ZIndex = 2
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateInput(input)
    end
end)

-- Функция Toggle Switch
local function toggleNoClip()
    noclipEnabled = not noclipEnabled
    
    if noclipEnabled then
        local tweenIn = TweenService:Create(toggleCircle, TweenInfo.new(0.2), {
            Position = UDim2.new(0, 28, 0, 3)
        })
        local colorTween = TweenService:Create(toggleButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(50, 205, 50)
        })
        tweenIn:Play()
        colorTween:Play()
        
        statusBar.BackgroundColor3 = Color3.fromRGB(50, 205, 50)
        toggleLabel.Text = "NoClip: ВКЛ"
        
        if noclipConnection then
            noclipConnection:Disconnect()
        end
        noclipConnection = RunService.Stepped:Connect(noclip)
        
    else
        local tweenOut = TweenService:Create(toggleCircle, TweenInfo.new(0.2), {
            Position = UDim2.new(0, 3, 0, 3)
        })
        local colorTween = TweenService:Create(toggleButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(80, 80, 100)
        })
        tweenOut:Play()
        colorTween:Play()
        
        statusBar.BackgroundColor3 = Color3.fromRGB(65, 105, 225)
        toggleLabel.Text = "NoClip: ВЫКЛ"
        
        if player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        
        if noclipConnection then
            noclipConnection:Disconnect()
        end
    end
end

toggleButton.MouseButton1Click:Connect(toggleNoClip)

-- Функции для ползунка WalkSpeed
local walkSpeed = 16
local sliderDragging = false

local function updateWalkSpeed(value)
    walkSpeed = math.clamp(value, 16, 100)
    
    -- Обновляем позицию бегунка и заполнение
    local fillWidth = (walkSpeed - 16) / (100 - 16)
    sliderFill.Size = UDim2.new(fillWidth, 0, 1, 0)
    sliderThumb.Position = UDim2.new(fillWidth, -10, 0.5, -10)
    
    -- Обновляем текст
    speedLabel.Text = "Скорость: " .. math.floor(walkSpeed)
    
    -- Применяем скорость к персонажу
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = walkSpeed
    end
end

-- Перетаскивание ползунка
sliderThumb.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = true
        sliderThumb.ZIndex = 3
        
        -- Увеличиваем бегунок при захвате
        TweenService:Create(sliderThumb, TweenInfo.new(0.1), {
            Size = UDim2.new(0, 24, 0, 24)
        }):Play()
    end
end)

sliderThumb.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = false
        sliderThumb.ZIndex = 2
        
        -- Возвращаем размер бегунка
        TweenService:Create(sliderThumb, TweenInfo.new(0.1), {
            Size = UDim2.new(0, 20, 0, 20)
        }):Play()
    end
end)

-- Клик по треку ползунка (для мгновенного перехода)
sliderTrack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local mousePos = input.Position.X
        local trackAbsPos = sliderTrack.AbsolutePosition.X
        local trackWidth = sliderTrack.AbsoluteSize.X
        
        local relativePos = (mousePos - trackAbsPos) / trackWidth
        local newSpeed = 16 + math.floor(relativePos * (100 - 16))
        
        updateWalkSpeed(newSpeed)
    end
end)

-- Обновление позиции при движении
UserInputService.InputChanged:Connect(function(input)
    if sliderDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local mousePos = input.Position.X
        local trackAbsPos = sliderTrack.AbsolutePosition.X
        local trackWidth = sliderTrack.AbsoluteSize.X
        
        local relativePos = math.clamp((mousePos - trackAbsPos) / trackWidth, 0, 1)
        local newSpeed = 16 + math.floor(relativePos * (100 - 16))
        
        updateWalkSpeed(newSpeed)
    end
end)

-- Fly Mode
local flyEnabled = false

flyButton.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    
    if flyEnabled then
        flyButton.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
        flyButton.Text = "🕊️ Fly: ВКЛ"
        print("Fly mode активирован")
    else
        flyButton.BackgroundColor3 = Color3.fromRGB(106, 90, 205)
        flyButton.Text = "🕊️ Fly Mode"
        print("Fly mode деактивирован")
    end
end)

-- Кнопка сброса скорости
resetButton.MouseButton1Click:Connect(function()
    updateWalkSpeed(16) -- Сбрасываем к стандартной скорости
    
    -- Анимация сброса
    TweenService:Create(resetButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(50, 205, 50)
    }):Play()
    
    task.wait(0.3)
    
    TweenService:Create(resetButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(255, 69, 0)
    }):Play()
end)

-- Анимации при наведении
local function setupButtonHover(button)
    button.MouseEnter:Connect(function()
        if not UserInputService.TouchEnabled then
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundTransparency = 0.2
            }):Play()
        end
    end)
    
    button.MouseLeave:Connect(function()
        if not UserInputService.TouchEnabled then
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundTransparency = 0
            }):Play()
        end
    end)
end

-- Применяем эффекты ко всем кнопкам
for _, button in pairs({flyButton, resetButton, toggleButton, sliderThumb}) do
    setupButtonHover(button)
end

-- Адаптация для мобильных устройств
if UserInputService.TouchEnabled then
    flyButton.Size = UDim2.new(1, 0, 0, 45)
    resetButton.Size = UDim2.new(1, 0, 0, 40)
    resetButton.Position = UDim2.new(0, 0, 0, 175)
    
    toggleButton.Size = UDim2.new(0, 60, 0, 30)
    toggleCircle.Size = UDim2.new(0, 24, 0, 24)
    toggleButton.Position = UDim2.new(1, -70, 0.5, -15)
    
    sliderThumb.Size = UDim2.new(0, 25, 0, 25)
    
    print("📱 Mobile режим активирован")
else
    print("🖥️ PC режим активирован")
end

-- Плавное появление
mainFrame.BackgroundTransparency = 1
titleBar.BackgroundTransparency = 1
titleBar.TextTransparency = 1

local fadeIn = TweenService:Create(mainFrame, TweenInfo.new(0.5), {
    BackgroundTransparency = 0
})
local titleFadeIn = TweenService:Create(titleBar, TweenInfo.new(0.5), {
    BackgroundTransparency = 0,
    TextTransparency = 0
})

fadeIn:Play()
titleFadeIn:Play()

-- Инициализация скорости
updateWalkSpeed(16)

print("✅ Компактный UI загружен!")
print("🎯 Функции: NoClip, WalkSpeed слайдер, Fly Mode")
print("📱 Поддержка: PC и Mobile")
print("🎚️  WalkSpeed диапазон: 16-100")
