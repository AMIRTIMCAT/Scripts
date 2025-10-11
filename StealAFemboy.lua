-- Создаем главное окно
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TestApp"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Главный фрейм (окно)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainWindow"
mainFrame.Size = UDim2.new(0, 400, 0, 300)  -- Размер окна
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)  -- Центр экрана
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Закругленные углы
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = mainFrame

-- Заголовок окна
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

-- Текст заголовка
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, -60, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Тестовое приложение"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Font = Enum.Font.GothamSemibold
titleLabel.TextSize = 14
titleLabel.Parent = titleBar

-- Кнопка закрытия
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeButton.BorderSizePixel = 0
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 14
closeButton.Parent = titleBar

-- Закругление для кнопки закрытия
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeButton

-- Контентная область
local contentFrame = Instance.new("Frame")
contentFrame.Name = "Content"
contentFrame.Size = UDim2.new(1, -20, 1, -50)
contentFrame.Position = UDim2.new(0, 10, 0, 40)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Кнопка действия 1
local actionButton1 = Instance.new("TextButton")
actionButton1.Name = "Btn1"
actionButton1.Size = UDim2.new(1, 0, 0, 40)
actionButton1.Position = UDim2.new(0, 0, 0, 10)
actionButton1.BackgroundColor3 = Color3.fromRGB(65, 105, 225)  -- Синий
actionButton1.BorderSizePixel = 0
actionButton1.Text = "Тестовая кнопка 1"
actionButton1.TextColor3 = Color3.fromRGB(255, 255, 255)
actionButton1.Font = Enum.Font.GothamSemibold
actionButton1.TextSize = 14
actionButton1.Parent = contentFrame

-- Кнопка действия 2
local actionButton2 = Instance.new("TextButton")
actionButton2.Name = "Btn2"
actionButton2.Size = UDim2.new(1, 0, 0, 40)
actionButton2.Position = UDim2.new(0, 0, 0, 60)
actionButton2.BackgroundColor3 = Color3.fromRGB(50, 205, 50)  -- Зеленый
actionButton2.BorderSizePixel = 0
actionButton2.Text = "Тестовая кнопка 2"
actionButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
actionButton2.Font = Enum.Font.GothamSemibold
actionButton2.TextSize = 14
actionButton2.Parent = contentFrame

-- Текстовое поле
local textBox = Instance.new("TextBox")
textBox.Name = "InputField"
textBox.Size = UDim2.new(1, 0, 0, 35)
textBox.Position = UDim2.new(0, 0, 0, 120)
textBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
textBox.BorderSizePixel = 0
textBox.PlaceholderText = "Введите текст здесь..."
textBox.Text = ""
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.Font = Enum.Font.Gotham
textBox.TextSize = 12
textBox.Parent = contentFrame

-- Метка для вывода
local outputLabel = Instance.new("TextLabel")
outputLabel.Name = "Output"
outputLabel.Size = UDim2.new(1, 0, 0, 50)
outputLabel.Position = UDim2.new(0, 0, 0, 170)
outputLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
outputLabel.BorderSizePixel = 0
outputLabel.Text = "Результат:"
outputLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
outputLabel.Font = Enum.Font.Gotham
outputLabel.TextSize = 12
outputLabel.TextWrapped = true
outputLabel.Parent = contentFrame

-- Закругления для элементов
local elementCorner = Instance.new("UICorner")
elementCorner.CornerRadius = UDim.new(0, 6)

for _, element in pairs({actionButton1, actionButton2, textBox, outputLabel}) do
	elementCorner:Clone().Parent = element
end

-- ФУНКЦИОНАЛ ПРИЛОЖЕНИЯ

-- Перетаскивание окна
local dragging = false
local dragInput, dragStart, startPos

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
	if dragging and input == dragInput then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Закрытие приложения
closeButton.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

-- Действия кнопок
actionButton1.MouseButton1Click:Connect(function()
	outputLabel.Text = "Нажата кнопка 1!\nВремя: " .. os.date("%X")
end)

actionButton2.MouseButton1Click:Connect(function()
	local inputText = textBox.Text
	if inputText ~= "" then
		outputLabel.Text = "Вы ввели: '" .. inputText .. "'"
	else
		outputLabel.Text = "Сначала введите текст в поле выше!"
	end
end)

-- Анимации при наведении
local function setupButtonHover(button)
	button.MouseEnter:Connect(function()
		game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
	end)
	
	button.MouseLeave:Connect(function()
		game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
	end)
end

setupButtonHover(actionButton1)
setupButtonHover(actionButton2)
setupButtonHover(closeButton)

print("Тестовое приложение загружено!")
