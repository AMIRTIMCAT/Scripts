local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomMenu"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- Main Menu Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 350)
mainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame)

local stroke = Instance.new("UIStroke", mainFrame)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.Transparency = 0.4

-- Shadow (fake)
local shadow = Instance.new("Frame")
shadow.Size = mainFrame.Size + UDim2.new(0, 10, 0, 10)
shadow.Position = mainFrame.Position + UDim2.new(0, 5, 0, 5)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.8
shadow.ZIndex = 0
shadow.Parent = screenGui
Instance.new("UICorner", shadow)

-- Sync shadow with frame
mainFrame:GetPropertyChangedSignal("Position"):Connect(function()
	shadow.Position = mainFrame.Position + UDim2.new(0, 5, 0, 5)
end)

-- Скрыть
local hideButton = Instance.new("TextButton")
hideButton.Text = "Скрыть"
hideButton.Size = UDim2.new(0, 100, 0, 40)
hideButton.Position = UDim2.new(0, 20, 1, -60)
hideButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
hideButton.TextColor3 = Color3.new(1, 1, 1)
hideButton.Parent = mainFrame
Instance.new("UICorner", hideButton)

-- Закрыть
local closeButton = Instance.new("TextButton")
closeButton.Text = "Закрыть"
closeButton.Size = UDim2.new(0, 100, 0, 40)
closeButton.Position = UDim2.new(1, -120, 1, -60)
closeButton.BackgroundColor3 = Color3.fromRGB(120, 50, 50)
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Parent = mainFrame
Instance.new("UICorner", closeButton)

-- Открыть Меню
local toggleButton = Instance.new("TextButton")
toggleButton.Text = "Открыть Меню"
toggleButton.Size = UDim2.new(0, 140, 0, 40)
toggleButton.Position = UDim2.new(0, 20, 1, -60)
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 120, 50)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Visible = false
toggleButton.Parent = screenGui
Instance.new("UICorner", toggleButton)

-- DropDown (ComboBox)
local dropDown = Instance.new("TextButton")
dropDown.Text = "Выбрать место ▼"
dropDown.Size = UDim2.new(0, 200, 0, 40)
dropDown.Position = UDim2.new(0.5, -100, 0, 20)
dropDown.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
dropDown.TextColor3 = Color3.new(1, 1, 1)
dropDown.Parent = mainFrame
Instance.new("UICorner", dropDown)

-- Options
local optionsFrame = Instance.new("Frame")
optionsFrame.Size = UDim2.new(0, 200, 0, 0)
optionsFrame.Position = UDim2.new(0.5, -100, 0, 60)
optionsFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
optionsFrame.Visible = false
optionsFrame.ClipsDescendants = true
optionsFrame.Parent = mainFrame
Instance.new("UICorner", optionsFrame)

local options = {"Middle Town", "Jungle"}
local selectedPlace = nil

for i, option in ipairs(options) do
	local btn = Instance.new("TextButton")
	btn.Text = option
	btn.Size = UDim2.new(1, 0, 0, 30)
	btn.Position = UDim2.new(0, 0, 0, (i - 1) * 30)
	btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Parent = optionsFrame
	Instance.new("UICorner", btn)

	btn.MouseButton1Click:Connect(function()
		selectedPlace = option
		dropDown.Text = option .. " ▼"
		optionsFrame.Visible = false
	end)
end

dropDown.MouseButton1Click:Connect(function()
	optionsFrame.Visible = not optionsFrame.Visible
	optionsFrame.Size = UDim2.new(0, 200, 0, optionsFrame.Visible and (#options * 30) or 0)
end)

-- Кнопка "Телепортироваться"
local tpButton = Instance.new("TextButton")
tpButton.Text = "Телепортироваться"
tpButton.Size = UDim2.new(0, 200, 0, 40)
tpButton.Position = UDim2.new(0.5, -100, 0, 140)
tpButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
tpButton.TextColor3 = Color3.new(1, 1, 1)
tpButton.Parent = mainFrame
Instance.new("UICorner", tpButton)

-- Логика телепорта
tpButton.MouseButton1Click:Connect(function()
	if not selectedPlace then
		warn("Место не выбрано!")
		return
	end

	local char = player.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end

	local hrp = char:FindFirstChild("HumanoidRootPart")

	if selectedPlace == "Middle Town" then
		local cf = CFrame.new(-689.302979, 8.01199341, 1583.14294, 0.965929627, 0, 0.258804798, 0, 1, 0, -0.258804798, 0, 0.965929627)
		hrp.CFrame = cf
	elseif selectedPlace == "Jungle" then
		local cf = CFrame.new(-1425.30103, 7.3999939, 125.365005, -0.499959469, 0, 0.866048813, 0, 1, 0, -0.866048813, 0, -0.499959469)
		hrp.CFrame = cf
	end
end)

-- Кнопки Скрыть / Показать / Закрыть
hideButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
	shadow.Visible = false
	toggleButton.Visible = true
end)

toggleButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = true
	shadow.Visible = true
	toggleButton.Visible = false
end)

closeButton.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)
