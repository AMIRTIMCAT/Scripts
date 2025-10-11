-- Создаем главное окно приложения
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ModernApp"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Главный контейнер
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainWindow"
mainFrame.Size = UDim2.new(0, 450, 0, 500)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -250)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Закругленные углы
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 16)
UICorner.Parent = mainFrame

-- Тень окна
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(80, 80, 120)
UIStroke.Thickness = 2
UIStroke.Parent = mainFrame

-- Градиентный заголовок
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 16)
titleCorner.Parent = titleBar

-- Градиент для заголовка
local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(106, 90, 205)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(65, 105, 225))
})
titleGradient.Rotation = 45
titleGradient.Parent = titleBar

-- Иконка приложения
local icon = Instance.new("ImageLabel")
icon.Name = "Icon"
icon.Size = UDim2.new(0, 32, 0, 32)
icon.Position = UDim2.new(0, 15, 0.5, -16)
icon.BackgroundTransparency = 1
icon.Image = "rbxassetid://10734948220" -- Можно заменить на любую иконку
icon.Parent = titleBar

-- Заголовок
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, -100, 1, 0)
titleLabel.Position = UDim2.new(0, 60, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "MODERN APP"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.TextTransparency = 0.1
titleLabel.Parent = titleBar

-- Субтитл
local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Name = "Subtitle"
subtitleLabel.Size = UDim2.new(1, -100, 0, 20)
subtitleLabel.Position = UDim2.new(0, 60, 0, 25)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = "Premium Interface"
subtitleLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
subtitleLabel.Font = Enum.Font.Gotham
subtitleLabel.TextSize = 11
subtitleLabel.TextTransparency = 0.3
subtitleLabel.Parent = titleBar

-- Кнопка закрытия (стильная)
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0.5, -15)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
closeButton.BorderSizePixel = 0
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 20
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeButton

-- Контентная область
local contentFrame = Instance.new("Frame")
contentFrame.Name = "Content"
contentFrame.Size = UDim2.new(1, -30, 1, -70)
contentFrame.Position = UDim2.new(0, 15, 0, 60)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Карточка профиля
local profileCard = Instance.new("Frame")
profileCard.Name = "ProfileCard"
profileCard.Size = UDim2.new(1, 0, 0, 80)
profileCard.Position = UDim2.new(0, 0, 0, 10)
profileCard.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
profileCard.BorderSizePixel = 0
profileCard.Parent = contentFrame

local profileCorner = Instance.new("UICorner")
profileCorner.CornerRadius = UDim.new(0, 12)
profileCorner.Parent = profileCard

local profileStroke = Instance.new("UIStroke")
profileStroke.Color = Color3.fromRGB(80, 80, 100)
profileStroke.Thickness = 1
profileStroke.Parent = profileCard

-- Аватар профиля
local avatar = Instance.new("ImageLabel")
avatar.Name = "Avatar"
avatar.Size = UDim2.new(0, 50, 0, 50)
avatar.Position = UDim2.new(0, 15, 0.5, -25)
avatar.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
avatar.BorderSizePixel = 0
avatar.Image = "rbxassetid://10734948220"
avatar.Parent = profileCard

local avatarCorner = Instance.new("UICorner")
avatarCorner.CornerRadius = UDim.new(1, 0)
avatarCorner.Parent = avatar

-- Информация профиля
local playerName = Instance.new("TextLabel")
playerName.Name = "PlayerName"
playerName.Size = UDim2.new(0, 200, 0, 25)
playerName.Position = UDim2.new(0, 80, 0, 15)
playerName.BackgroundTransparency = 1
playerName.Text = game.Players.LocalPlayer.Name
playerName.TextColor3 = Color3.fromRGB(255, 255, 255)
playerName.TextXAlignment = Enum.TextXAlignment.Left
playerName.Font = Enum.Font.GothamSemibold
playerName.TextSize = 16
playerName.Parent = profileCard

local playerStatus = Instance.new("TextLabel")
playerStatus.Name = "Status"
playerStatus.Size = UDim2.new(0, 200, 0, 20)
playerStatus.Position = UDim2.new(0, 80, 0, 40)
playerStatus.BackgroundTransparency = 1
playerStatus.Text = "Online • Premium User"
playerStatus.TextColor3 = Color3.fromRGB(150, 200, 255)
playerStatus.TextXAlignment = Enum.TextXAlignment.Left
playerStatus.Font = Enum.Font.Gotham
playerStatus.TextSize = 12
playerStatus.Parent = profileCard

-- Статус бадж
local statusBadge = Instance.new("Frame")
statusBadge.Name = "StatusBadge"
statusBadge.Size = UDim2.new(0, 8, 0, 8)
statusBadge.Position = UDim2.new(1, -25, 0.5, -4)
statusBadge.BackgroundColor3 = Color3.fromRGB(50, 205, 50)
statusBadge.BorderSizePixel = 0
statusBadge.Parent = profileCard

local badgeCorner = Instance.new("UICorner")
badgeCorner.CornerRadius = UDim.new(1, 0)
badgeCorner.Parent = statusBadge

-- Секция действий
local actionsLabel = Instance.new("TextLabel")
actionsLabel.Name = "ActionsLabel"
actionsLabel.Size = UDim2.new(1, 0, 0, 20)
actionsLabel.Position = UDim2.new(0, 0, 0, 105)
actionsLabel.BackgroundTransparency = 1
actionsLabel.Text = "БЫСТРЫЕ ДЕЙСТВИЯ"
actionsLabel.TextColor3 = Color3.fromRGB(150, 150, 180)
actionsLabel.TextXAlignment = Enum.TextXAlignment.Left
actionsLabel.Font = Enum.Font.GothamBold
actionsLabel.TextSize = 12
actionsLabel.TextTransparency = 0.4
actionsLabel.Parent = contentFrame

-- Сетка кнопок
local buttonGrid = Instance.new("Frame")
buttonGrid.Name = "ButtonGrid"
buttonGrid.Size = UDim2.new(1, 0, 0, 150)
buttonGrid.Position = UDim2.new(0, 0, 0, 130)
buttonGrid.BackgroundTransparency = 1
buttonGrid.Parent = contentFrame

-- Создаем красивые кнопки
local buttons = {
    {Name = "Запустить", Color = Color3.fromRGB(65, 105, 225), Icon = "▶"},
    {Name = "Настройки", Color = Color3.fromRGB(106, 90, 205), Icon = "⚙"},
    {Name = "Статистика", Color = Color3.fromRGB(50, 205, 50), Icon = "📊"},
    {Name = "Помощь", Color = Color3.fromRGB(255, 140, 0), Icon = "❓"}
}

for i, btnData in pairs(buttons) do
    local col = (i-1) % 2
    local row = math.floor((i-1) / 2)
    
    local button = Instance.new("TextButton")
    button.Name = btnData.Name
    button.Size = UDim2.new(0.5, -5, 0, 65)
    button.Position = UDim2.new(col * 0.5, col * 5, 0, row * 70)
    button.BackgroundColor3 = btnData.Color
    button.BorderSizePixel = 0
    button.Text = ""
    button.Parent = buttonGrid
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 10)
    buttonCorner.Parent = button
    
    local buttonGradient = Instance.new("UIGradient")
    buttonGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, btnData.Color),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(
            math.floor(btnData.Color.R * 200),
            math.floor(btnData.Color.G * 200),
            math.floor(btnData.Color.B * 200)
        ))
    })
    buttonGradient.Rotation = 45
    buttonGradient.Parent = button
    
    -- Иконка кнопки
    local buttonIcon = Instance.new("TextLabel")
    buttonIcon.Name = "Icon"
    buttonIcon.Size = UDim2.new(0, 30, 0, 30)
    buttonIcon.Position = UDim2.new(0, 15, 0, 10)
    buttonIcon.BackgroundTransparency = 1
    buttonIcon.Text = btnData.Icon
    buttonIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
    buttonIcon.Font = Enum.Font.GothamBold
    buttonIcon.TextSize = 16
    buttonIcon.Parent = button
    
    -- Текст кнопки
    local buttonText = Instance.new("TextLabel")
    buttonText.Name = "Text"
    buttonText.Size = UDim2.new(1, -50, 0, 20)
    buttonText.Position = UDim2.new(0, 50, 0, 20)
    buttonText.BackgroundTransparency = 1
    buttonText.Text = btnData.Name
    buttonText.TextColor3 = Color3.fromRGB(255, 255, 255)
    buttonText.TextXAlignment = Enum.TextXAlignment.Left
    buttonText.Font = Enum.Font.GothamSemibold
    buttonText.TextSize = 14
    buttonText.Parent = button
end

-- Панель прогресса
local progressSection = Instance.new("Frame")
progressSection.Name = "Progress"
progressSection.Size = UDim2.new(1, 0, 0, 80)
progressSection.Position = UDim2.new(0, 0, 0, 300)
progressSection.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
progressSection.BorderSizePixel = 0
progressSection.Parent = contentFrame

local progressCorner = Instance.new("UICorner")
progressCorner.CornerRadius = UDim.new(0, 12)
progressCorner.Parent = progressSection

local progressLabel = Instance.new("TextLabel")
progressLabel.Name = "ProgressLabel"
progressLabel.Size = UDim2.new(1, -20, 0, 20)
progressLabel.Position = UDim2.new(0, 10, 0, 10)
progressLabel.BackgroundTransparency = 1
progressLabel.Text = "ЗАВЕРШЕНИЕ ПРИЛОЖЕНИЯ"
progressLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
progressLabel.TextXAlignment = Enum.TextXAlignment.Left
progressLabel.Font = Enum.Font.Gotham
progressLabel.TextSize = 12
progressLabel.Parent = progressSection

-- Прогресс бар
local progressBar = Instance.new("Frame")
progressBar.Name = "ProgressBar"
progressBar.Size = UDim2.new(1, -20, 0, 8)
progressBar.Position = UDim2.new(0, 10, 0, 35)
progressBar.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
progressBar.BorderSizePixel = 0
progressBar.Parent = progressSection

local progressBarCorner = Instance.new("UICorner")
progressBarCorner.CornerRadius = UDim.new(1, 0)
progressBarCorner.Parent = progressBar

-- Заполнение прогресса
local progressFill = Instance.new("Frame")
progressFill.Name = "ProgressFill"
progressFill.Size = UDim2.new(0.75, 0, 1, 0)
progressFill.Position = UDim2.new(0, 0, 0, 0)
progressFill.BackgroundColor3 = Color3.fromRGB(106, 90, 205)
progressFill.BorderSizePixel = 0
progressFill.Parent = progressBar

local progressFillCorner = Instance.new("UICorner")
progressFillCorner.CornerRadius = UDim.new(1, 0)
progressFillCorner.Parent = progressFill

-- Текст прогресса
local progressText = Instance.new("TextLabel")
progressText.Name = "ProgressText"
progressText.Size = UDim2.new(1, -20, 0, 20)
progressText.Position = UDim2.new(0, 10, 0, 50)
progressText.BackgroundTransparency = 1
progressText.Text = "75% завершено"
progressText.TextColor3 = Color3.fromRGB(150, 200, 255)
progressText.TextXAlignment = Enum.TextXAlignment.Right
progressText.Font = Enum.Font.Gotham
progressText.TextSize = 11
progressText.Parent = progressSection

-- АНИМАЦИИ И ФУНКЦИОНАЛ

-- Плавное появление
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

local tweenService = game:GetService("TweenService")
local openTween = tweenService:Create(mainFrame, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 450, 0, 500),
    Position = UDim2.new(0.5, -225, 0.5, -250)
})
openTween:Play()

-- Перетаскивание окна
local dragging = false
local dragInput, dragStart, startPos

local function updateInput(input)
    if dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
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

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

-- Анимации кнопок
local function setupButtonEffects(button)
    local originalSize = button.Size
    local hoverTween = tweenService:Create(button, TweenInfo.new(0.2), {
        Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset - 2, originalSize.Y.Scale, originalSize.Y.Offset - 2)
    })
    
    local leaveTween = tweenService:Create(button, TweenInfo.new(0.2), {
        Size = originalSize
    })
    
    button.MouseEnter:Connect(function()
        hoverTween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        leaveTween:Play()
    end)
end

-- Применяем эффекты ко всем кнопкам
for _, button in pairs(buttonGrid:GetChildren()) do
    if button:IsA("TextButton") then
        setupButtonEffects(button)
        
        button.MouseButton1Click:Connect(function()
            local clickTween = tweenService:Create(button, TweenInfo.new(0.1), {
                BackgroundTransparency = 0.5
            })
            local resetTween = tweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundTransparency = 0
            })
            
            clickTween:Play()
            clickTween.Completed:Connect(function()
                resetTween:Play()
            end)
            
            print("Нажата кнопка: " .. button.Name)
        end)
    end
end

-- Анимация закрытия
closeButton.MouseButton1Click:Connect(function()
    local closeTween = tweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    closeTween:Play()
    
    closeTween.Completed:Connect(function()
        screenGui:Destroy()
    end)
end)

-- Эффект пульсации для статус баджа
while task.wait(1) and statusBadge do
    local pulseTween = tweenService:Create(statusBadge, TweenInfo.new(0.5), {
        Size = UDim2.new(0, 10, 0, 10),
        Position = UDim2.new(1, -27, 0.5, -5)
    })
    local resetTween = tweenService:Create(statusBadge, TweenInfo.new(0.5), {
        Size = UDim2.new(0, 8, 0, 8),
        Position = UDim2.new(1, -25, 0.5, -4)
    })
    
    pulseTween:Play()
    pulseTween.Completed:Connect(function()
        resetTween:Play()
    end)
end

print("🚀 Стильное современное приложение загружено!")
