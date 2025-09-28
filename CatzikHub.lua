local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Создаём ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomMenu"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

-- Создаём основной Frame (окно меню)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100) -- Центр экрана
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Тёмный фон
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Добавляем закругление углов
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12) -- Радиус закругления (12 пикселей)
UICorner.Parent = MainFrame

-- Добавляем UIStroke для обводки
local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(100, 100, 100)
UIStroke.Transparency = 0.5
UIStroke.Parent = MainFrame

-- Создаём ImageLabel для эффекта тени
local Shadow = Instance.new("ImageLabel")
Shadow.Size = UDim2.new(1, 20, 1, 20) -- Чуть больше Frame для "выступа"
Shadow.Position = UDim2.new(0, -10, 0, -10)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://1316045217" -- Стандартное размытие Roblox
Shadow.ImageTransparency = 0.7 -- Полупрозрачность
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
Shadow.Parent = MainFrame
Shadow.ZIndex = -1 -- За основным фреймом

-- Добавляем текстовую метку (пример контента)
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Position = UDim2.new(0, 0, 0, 10)
Title.BackgroundTransparency = 1
Title.Text = "Моё Меню"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 24
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Кнопка (пример)
local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0, 100, 0, 40)
Button.Position = UDim2.new(0.5, -50, 0.5, 0)
Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Button.Text = "Тест"
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.TextSize = 18
Button.Font = Enum.Font.Gotham
Button.Parent = MainFrame

-- Закругление для кнопки
local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 8)
ButtonCorner.Parent = Button

-- Функция для кнопки
Button.MouseButton1Click:Connect(function()
    print("Кнопка нажата!")
    -- Добавь свой код сюда
end)

-- Кнопка закрытия
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -40, 0, 10)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18
CloseButton.Font = Enum.Font.Gotham
CloseButton.Parent = MainFrame

-- Закругление для кнопки закрытия
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

-- Закрытие меню
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = false
end)

-- Toggle на Right Ctrl
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        ScreenGui.Enabled = not ScreenGui.Enabled -- Toggle видимости
    end
end)
