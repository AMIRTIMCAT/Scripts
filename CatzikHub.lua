local player = game.Players:GetPlayers()[1]
if not player then
    warn("Player not found.")
    return
end

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local playerGui = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ExecutorTeleportMenu"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 420, 0, 360)
mainFrame.Position = UDim2.new(0.35, 0, 0.25, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
local mainCorner = Instance.new("UICorner", mainFrame)
mainCorner.CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", mainFrame)
stroke.Thickness = 1.8
stroke.Color = Color3.fromRGB(200, 200, 200)
stroke.Transparency = 0.6

local shadow = Instance.new("Frame")
shadow.Size = mainFrame.Size + UDim2.new(0, 12, 0, 12)
shadow.Position = mainFrame.Position + UDim2.new(0, 6, 0, 6)
shadow.BackgroundColor3 = Color3.new(0, 0, 0)
shadow.BackgroundTransparency = 0.82
shadow.ZIndex = 0
shadow.Parent = screenGui
Instance.new("UICorner", shadow)

mainFrame:GetPropertyChangedSignal("Position"):Connect(function()
    shadow.Position = mainFrame.Position + UDim2.new(0, 6, 0, 6)
end)

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, -20, 0, 36)
title.Position = UDim2.new(0, 10, 0, 8)
title.BackgroundTransparency = 1
title.Text = "Teleport Menu"
title.TextColor3 = Color3.fromRGB(230,230,230)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left

local dropDown = Instance.new("TextButton", mainFrame)
dropDown.Size = UDim2.new(0, 260, 0, 40)
dropDown.Position = UDim2.new(0, 20, 0, 60)
dropDown.BackgroundColor3 = Color3.fromRGB(60,60,60)
dropDown.TextColor3 = Color3.fromRGB(245,245,245)
dropDown.Text = "Выбрать место ▼"
dropDown.Font = Enum.Font.Gotham
dropDown.TextSize = 16
Instance.new("UICorner", dropDown)

local optionsFrame = Instance.new("Frame", mainFrame)
optionsFrame.Size = UDim2.new(0, 260, 0, 0)
optionsFrame.Position = UDim2.new(0, 20, 0, 106)
optionsFrame.BackgroundColor3 = Color3.fromRGB(45,45,45)
optionsFrame.ClipsDescendants = true
optionsFrame.Visible = false
Instance.new("UICorner", optionsFrame)

local tpButton = Instance.new("TextButton", mainFrame)
tpButton.Size = UDim2.new(0, 260, 0, 44)
tpButton.Position = UDim2.new(0, 20, 0, 160)
tpButton.BackgroundColor3 = Color3.fromRGB(80,120,255)
tpButton.Text = "Телепортироваться"
tpButton.TextColor3 = Color3.fromRGB(255,255,255)
tpButton.Font = Enum.Font.GothamBold
tpButton.TextSize = 18
Instance.new("UICorner", tpButton)

local hideButton = Instance.new("TextButton", mainFrame)
hideButton.Size = UDim2.new(0, 90, 0, 36)
hideButton.Position = UDim2.new(0, 20, 1, -56)
hideButton.BackgroundColor3 = Color3.fromRGB(80,80,80)
hideButton.Text = "Скрыть"
hideButton.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", hideButton)

local closeButton = Instance.new("TextButton", mainFrame)
closeButton.Size = UDim2.new(0, 90, 0, 36)
closeButton.Position = UDim2.new(1, -110, 1, -56)
closeButton.BackgroundColor3 = Color3.fromRGB(150,60,60)
closeButton.Text = "Закрыть"
closeButton.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", closeButton)

local openButton = Instance.new("TextButton", screenGui)
openButton.Size = UDim2.new(0, 140, 0, 40)
openButton.Position = UDim2.new(0, 20, 1, -60)
openButton.BackgroundColor3 = Color3.fromRGB(70,140,70)
openButton.Text = "Открыть Меню"
openButton.TextColor3 = Color3.fromRGB(255,255,255)
openButton.Visible = false
Instance.new("UICorner", openButton)

local options = {
    "Colosseum", "Desert", "Fountain", "Jungle", "Magma",
    "MarineStart", "Pirate", "Prison", "Sky", "SkyArea1", "SkyArea2"
}
local selectedPlace = nil

for i, name in ipairs(options) do
    local btn = Instance.new("TextButton", optionsFrame)
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.Position = UDim2.new(0, 0, 0, (i-1)*34)
    btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    btn.TextColor3 = Color3.fromRGB(245,245,245)
    btn.Text = name
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        selectedPlace = name
        dropDown.Text = name .. " ▼"
        optionsFrame.Visible = false
        optionsFrame.Size = UDim2.new(0, 260, 0, 0)
    end)
end

dropDown.MouseButton1Click:Connect(function()
    optionsFrame.Visible = not optionsFrame.Visible
    optionsFrame.Size = UDim2.new(0, 260, 0, optionsFrame.Visible and (#options * 34) or 0)
end)

local noclipConn
local function enableNoclip(character)
    if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    noclipConn = RunService.Stepped:Connect(function()
        if not character or not character.Parent then return end
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
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

local function flyTo(destinationCFrame)
    local char = player.Character
    if not char or not char.Parent then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    enableNoclip(char)

    hrp.CFrame = hrp.CFrame + Vector3.new(0, 100, 0)

    local targetAbove = CFrame.new(destinationCFrame.Position + Vector3.new(0, 100, 0), destinationCFrame.Position)

    local distance = (hrp.Position - targetAbove.Position).Magnitude
    local speed = 300 -- studs/sec
    local duration = math.max(0.01, distance / speed)

    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetAbove})
    tween:Play()

    tween.Completed:Connect(function()
        local downDuration = 0.2
        local downTween = TweenService:Create(hrp, TweenInfo.new(downDuration, Enum.EasingStyle.Linear), {CFrame = destinationCFrame})
        downTween:Play()
        downTween.Completed:Connect(function()
            disableNoclip()
        end)
    end)
end

local function getCFrameForPlace(name)
    local mapFolder = workspace:FindFirstChild("Map")
    if not mapFolder then
        warn("Папка 'Map' не найдена в workspace!")
        return nil
    end

    local model = mapFolder:FindFirstChild(name)
    if not model then
        warn("Модель '"..name.."' не найдена в 'Map'!")
        return nil
    end

    local hrp = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChildWhichIsA("BasePart")
    if not hrp then
        warn("В модели '"..name.."' нет HumanoidRootPart или BasePart!")
        return nil
    end

    return hrp.CFrame
end

tpButton.MouseButton1Click:Connect(function()
    if not selectedPlace then
        warn("Место не выбрано!")
        return
    end

    local cf = getCFrameForPlace(selectedPlace)
    if not cf then
        warn("Не найдена точка для " .. selectedPlace)
        return
    end

    flyTo(cf)
end)

hideButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    shadow.Visible = false
    openButton.Visible = true
end)

openButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    shadow.Visible = true
    openButton.Visible = false
end)

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    disableNoclip()
end)
