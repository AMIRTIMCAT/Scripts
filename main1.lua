local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Создаём ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyUI"
screenGui.Parent = playerGui

-- Создаём Frame для UI
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 150, 0, 120)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
frame.BackgroundTransparency = 0.3
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Создаём ComboBox (TextButton + выпадающий список)
local selectedLocation = "Jungle"
local comboButton = Instance.new("TextButton")
comboButton.Size = UDim2.new(0, 130, 0, 30)
comboButton.Position = UDim2.new(0, 10, 0, 10)
comboButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
comboButton.TextColor3 = Color3.new(1, 1, 1)
comboButton.TextScaled = true
comboButton.Text = selectedLocation
comboButton.Parent = frame

-- Выпадающий список
local dropdown = Instance.new("Frame")
dropdown.Size = UDim2.new(0, 130, 0, 30)
dropdown.Position = UDim2.new(0, 10, 0, 40)
dropdown.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
dropdown.BackgroundTransparency = 0.2
dropdown.Visible = false
dropdown.Parent = frame

-- Кнопка для "Jungle"
local jungleOption = Instance.new("TextButton")
jungleOption.Size = UDim2.new(0, 130, 0, 30)
jungleOption.Position = UDim2.new(0, 0, 0, 0)
jungleOption.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
jungleOption.TextColor3 = Color3.new(1, 1, 1)
jungleOption.TextScaled = true
jungleOption.Text = "Jungle"
jungleOption.Parent = dropdown

-- Логика ComboBox
comboButton.MouseButton1Click:Connect(function()
    dropdown.Visible = not dropdown.Visible
end)

jungleOption.MouseButton1Click:Connect(function()
    selectedLocation = "Jungle"
    comboButton.Text = selectedLocation
    dropdown.Visible = false
end)

-- Создаём ползунок (слайдер)
local sliderFrame = Instance.new("Frame")
sliderFrame.Size = UDim2.new(0, 130, 0, 20)
sliderFrame.Position = UDim2.new(0, 10, 0, 80)
sliderFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
sliderFrame.Parent = frame

local sliderKnob = Instance.new("Frame")
sliderKnob.Size = UDim2.new(0, 20, 0, 20)
sliderKnob.Position = UDim2.new(0, 0, 0, 0)
sliderKnob.BackgroundColor3 = Color3.new(0, 0.5, 0)
sliderKnob.BorderSizePixel = 0
sliderKnob.Parent = sliderFrame

-- Логика ползунка
local isDragging = false
sliderKnob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
    end
end)

sliderKnob.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mouseX = input.Position.X
        local frameAbsPos = sliderFrame.AbsolutePosition.X
        local frameWidth = sliderFrame.AbsoluteSize.X
        local knobWidth = sliderKnob.AbsoluteSize.X
        local newX = math.clamp(mouseX - frameAbsPos, 0, frameWidth - knobWidth)
        sliderKnob.Position = UDim2.new(0, newX, 0, 0)
        
        -- Запуск полёта при движении ползунка
        if selectedLocation == "Jungle" then
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local targetCFrame = CFrame.new(
                    Vector3.new(-1440.10498, 55.6999969, -16.6650085),
                    Vector3.new(-0.866007447, 0, -0.500031412),
                    Vector3.new(0, 1, 0),
                    Vector3.new(0.500031412, 0, -0.866007447)
                )
                local humanoidRoot = character.HumanoidRootPart
                local tweenInfo = TweenInfo.new(
                    2, -- Время полёта (2 секунды)
                    Enum.EasingStyle.Linear,
                    Enum.EasingDirection.InOut
                )
                local tween = TweenService:Create(humanoidRoot, tweenInfo, {CFrame = targetCFrame})
                tween:Play()
            else
                warn("Character or HumanoidRootPart not found!")
            end
        end
    end
end)
