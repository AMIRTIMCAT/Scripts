-- LocalScript для StarterPlayerScripts
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Создаём ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportUI"
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
local selectedLocation = "Jungle" -- Текущая выбранная локация
local comboButton = Instance.new("TextButton")
comboButton.Size = UDim2.new(0, 130, 0, 30)
comboButton.Position = UDim2.new(0, 10, 0, 10)
comboButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
comboButton.TextColor3 = Color3.new(1, 1, 1)
comboButton.TextScaled = true
comboButton.Text = selectedLocation
comboButton.Parent = frame

-- Выпадающий список (Frame, скрытый по умолчанию)
local dropdown = Instance.new("Frame")
dropdown.Size = UDim2.new(0, 130, 0, 30)
dropdown.Position = UDim2.new(0, 10, 0, 40)
dropdown.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
dropdown.BackgroundTransparency = 0.2
dropdown.Visible = false
dropdown.Parent = frame

-- Кнопка в выпадающем списке для "Jungle"
local jungleOption = Instance.new("TextButton")
jungleOption.Size = UDim2.new(0, 130, 0, 30)
jungleOption.Position = UDim2.new(0, 0, 0, 0)
jungleOption.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
jungleOption.TextColor3 = Color3.new(1, 1, 1)
jungleOption.TextScaled = true
jungleOption.Text = "Jungle"
jungleOption.Parent = dropdown

-- Логика для ComboBox
comboButton.MouseButton1Click:Connect(function()
    dropdown.Visible = not dropdown.Visible -- Показать/скрыть выпадающий список
end)

jungleOption.MouseButton1Click:Connect(function()
    selectedLocation = "Jungle"
    comboButton.Text = selectedLocation
    dropdown.Visible = false
end)

-- Кнопка-ползунок для телепортации
local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(0, 130, 0, 30)
teleportButton.Position = UDim2.new(0, 10, 0, 80)
teleportButton.BackgroundColor3 = Color3.new(0, 0.5, 0)
teleportButton.TextColor3 = Color3.new(1, 1, 1)
teleportButton.TextScaled = true
teleportButton.Text = "Teleport"
teleportButton.Parent = frame

-- Логика телепортации
teleportButton.MouseButton1Click:Connect(function()
    if selectedLocation == "Jungle" then
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local targetCFrame = CFrame.new(
                Vector3.new(-1440.10498, 55.6999969, -16.6650085),
                Vector3.new(-0.866007447, 0, -0.500031412),
                Vector3.new(0, 1, 0),
                Vector3.new(0.500031412, 0, -0.866007447)
            )
            character.HumanoidRootPart.CFrame = targetCFrame
            print("Teleported to Jungle!")
        else
            warn("Character or HumanoidRootPart not found!")
        end
    end
end)
