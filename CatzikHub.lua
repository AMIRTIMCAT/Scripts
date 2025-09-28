local player = game.Players:GetPlayers()[1]
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- GUIs
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "ExecutorMenu"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

-- Main Frame
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame)

local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.Thickness = 2
stroke.Transparency = 0.5

-- Shadow
local shadow = Instance.new("Frame", screenGui)
shadow.Size = mainFrame.Size + UDim2.new(0, 10, 0, 10)
shadow.Position = mainFrame.Position + UDim2.new(0, 5, 0, 5)
shadow.BackgroundColor3 = Color3.new(0, 0, 0)
shadow.BackgroundTransparency = 0.8
shadow.ZIndex = 0
Instance.new("UICorner", shadow)

mainFrame:GetPropertyChangedSignal("Position"):Connect(function()
	shadow.Position = mainFrame.Position + UDim2.new(0, 5, 0, 5)
end)

-- ComboBox
local dropdown = Instance.new("TextButton", mainFrame)
dropdown.Size = UDim2.new(0, 200, 0, 40)
dropdown.Position = UDim2.new(0.5, -100, 0, 20)
dropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
dropdown.TextColor3 = Color3.new(1,1,1)
dropdown.Text = "Выбрать место ▼"
Instance.new("UICorner", dropdown)

local optionsFrame = Instance.new("Frame", mainFrame)
optionsFrame.Size = UDim2.new(0, 200, 0, 0)
optionsFrame.Position = UDim2.new(0.5, -100, 0, 60)
optionsFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
optionsFrame.ClipsDescendants = true
optionsFrame.Visible = false
Instance.new("UICorner", optionsFrame)

local selectedPlace = nil
local options = {"Middle Town", "Jungle"}

for i, name in ipairs(options) do
	local btn = Instance.new("TextButton", optionsFrame)
	btn.Text = name
	btn.Size = UDim2.new(1, 0, 0, 30)
	btn.Position = UDim2.new(0, 0, 0, (i-1)*30)
	btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	btn.TextColor3 = Color3.new(1, 1, 1)
	Instance.new("UICorner", btn)

	btn.MouseButton1Click:Connect(function()
		selectedPlace = name
		dropdown.Text = name .. " ▼"
		optionsFrame.Visible = false
	end)
end

dropdown.MouseButton1Click:Connect(function()
	optionsFrame.Visible = not optionsFrame.Visible
	optionsFrame.Size = UDim2.new(0, 200, 0, optionsFrame.Visible and #options * 30 or 0)
end)

-- Noclip
local noclipConn
local function enableNoclip(char)
	noclipConn = RunService.Stepped:Connect(function()
		for _, v in ipairs(char:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end)
end

local function disableNoclip()
	if noclipConn then
		noclipConn:Disconnect()
		noclipConn = nil
	end
end

-- Полёт
local function flyTo(destinationCFrame)
	local char = player.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	enableNoclip(char)

	-- Подъём на 100 y
	hrp.CFrame = hrp.CFrame + Vector3.new(0, 100, 0)

	local goalPos = destinationCFrame.Position + Vector3.new(0, 100, 0)
	local dist = (hrp.Position - goalPos).Magnitude
	local speed = 2000
	local time = dist / speed

	local tween = TweenService:Create(hrp, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = destinationCFrame})
	tween:Play()

	tween.Completed:Connect(function()
		disableNoclip()
	end)
end

-- Кнопка ТП
local tpBtn = Instance.new("TextButton", mainFrame)
tpBtn.Size = UDim2.new(0, 200, 0, 40)
tpBtn.Position = UDim2.new(0.5, -100, 0, 140)
tpBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
tpBtn.TextColor3 = Color3.new(1, 1, 1)
tpBtn.Text = "Телепортироваться"
Instance.new("UICorner", tpBtn)

tpBtn.MouseButton1Click:Connect(function()
	if not selectedPlace then return end

	local cf
	if selectedPlace == "Middle Town" then
		cf = CFrame.new(-689.302979, 8.01199341, 1583.14294, 0.965929627, 0, 0.258804798, 0, 1, 0, -0.258804798, 0, 0.965929627)
	elseif selectedPlace == "Jungle" then
		cf = CFrame.new(-1425.30103, 7.3999939, 125.365005, -0.499959469, 0, 0.866048813, 0, 1, 0, -0.866048813, 0, -0.499959469)
	end

	if cf then
		flyTo(cf)
	end
end)
