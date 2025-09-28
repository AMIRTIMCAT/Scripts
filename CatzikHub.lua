local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Создаем ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RedzStyleHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Основной фрейм
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 450, 0, 400)
mainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 45)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
local corner = Instance.new("UICorner", mainFrame)
corner.CornerRadius = UDim.new(0, 10)

-- Тени
local shadow = Instance.new("Frame")
shadow.Size = mainFrame.Size + UDim2.new(0, 10, 0, 10)
shadow.Position = mainFrame.Position + UDim2.new(0, 5, 0, 5)
shadow.BackgroundColor3 = Color3.new(0, 0, 0)
shadow.BackgroundTransparency = 0.8
shadow.ZIndex = 0
shadow.Parent = screenGui
local shadowCorner = Instance.new("UICorner", shadow)
shadowCorner.CornerRadius = UDim.new(0, 12)

mainFrame:GetPropertyChangedSignal("Position"):Connect(function()
    shadow.Position = mainFrame.Position + UDim2.new(0, 5, 0, 5)
end)

-- Заголовок
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Redz Hub Custom"
title.TextColor3 = Color3.fromRGB(100, 170, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.Position = UDim2.new(0, 15, 0, 7)
title.TextXAlignment = Enum.TextXAlignment.Left

-- Кнопки табов
local tabsFrame = Instance.new("Frame", mainFrame)
tabsFrame.Size = UDim2.new(1, -20, 0, 40)
tabsFrame.Position = UDim2.new(0, 10, 0, 50)
tabsFrame.BackgroundTransparency = 1

local tabButtons = {}
local tabPages = {}

local tabNames = {"Teleport", "AutoFarm", "Settings"}

local function createTab(name, index)
    local btn = Instance.new("TextButton", tabsFrame)
    btn.Size = UDim2.new(0, 120, 1, 0)
    btn.Position = UDim2.new(0, (index - 1) * 125, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30, 40, 70)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.fromRGB(150, 200, 255)
    btn.TextSize = 18
    btn.AutoButtonColor = false
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 6)

    local page = Instance.new("Frame", mainFrame)
    page.Size = UDim2.new(1, -20, 1, -110)
    page.Position = UDim2.new(0, 10, 0, 100)
    page.BackgroundTransparency = 1
    page.Visible = false

    tabButtons[name] = btn
    tabPages[name] = page

    btn.MouseButton1Click:Connect(function()
        for tn, tb in pairs(tabButtons) do
            tb.BackgroundColor3 = Color3.fromRGB(30, 40, 70)
            tb.TextColor3 = Color3.fromRGB(150, 200, 255)
            tabPages[tn].Visible = false
        end
        btn.BackgroundColor3 = Color3.fromRGB(60, 100, 220)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        page.Visible = true
    end)

    return page
end

-- Создаем вкладки
for i, name in ipairs(tabNames) do
    createTab(name, i)
end

-- Автоматически выбираем первую вкладку
tabButtons["Teleport"].MouseButton1Click:Wait()

-- --- Контент вкладки Teleport ---

local teleportPage = tabPages["Teleport"]

local dropDown = Instance.new("TextButton", teleportPage)
dropDown.Size = UDim2.new(0, 260, 0, 40)
dropDown.Position = UDim2.new(0, 20, 0, 20)
dropDown.BackgroundColor3 = Color3.fromRGB(40, 55, 90)
dropDown.TextColor3 = Color3.fromRGB(220, 220, 255)
dropDown.Text = "Выбрать место ▼"
dropDown.Font = Enum.Font.Gotham
dropDown.TextSize = 16
Instance.new("UICorner", dropDown)
dropDown.ZIndex = 10

local optionsFrame = Instance.new("Frame", teleportPage)
optionsFrame.Size = UDim2.new(0, 260, 0, 0)
optionsFrame.Position = UDim2.new(0, 20, 0, 60)
optionsFrame.BackgroundColor3 = Color3.fromRGB(25, 35, 65)
optionsFrame.ClipsDescendants = true
optionsFrame.Visible = false
Instance.new("UICorner", optionsFrame)
optionsFrame.ZIndex = 11

local tpButton = Instance.new("TextButton", teleportPage)
tpButton.Size = UDim2.new(0, 260, 0, 44)
tpButton.Position = UDim2.new(0, 20, 0, 120)
tpButton.BackgroundColor3 = Color3.fromRGB(70, 110, 210)
tpButton.Text = "Телепортироваться"
tpButton.TextColor3 = Color3.fromRGB(230, 230, 255)
tpButton.Font = Enum.Font.GothamBold
tpButton.TextSize = 18
Instance.new("UICorner", tpButton)
tpButton.ZIndex = 10

local options = {
    "Colosseum", "Desert", "Fountain", "Jungle", "Magma",
    "MarineStart", "Pirate", "Prison", "Sky", "SkyArea1", "SkyArea2"
}
local selectedPlace = nil

for i, name in ipairs(options) do
    local btn = Instance.new("TextButton", optionsFrame)
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.Position = UDim2.new(0, 0, 0, (i-1)*34)
    btn.BackgroundColor3 = Color3.fromRGB(45, 55, 90)
    btn.TextColor3 = Color3.fromRGB(220, 220, 255)
    btn.Text = name
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    Instance.new("UICorner", btn)
    btn.ZIndex = 12

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
    local speed = 300 -- studs per second
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

-- Кнопки скрытия и закрытия

local hideButton = Instance.new("TextButton", mainFrame)
hideButton.Size = UDim2.new(0, 90, 0, 36)
hideButton.Position = UDim2.new(0, 20, 1, -56)
hideButton.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
hideButton.Text = "Скрыть"
hideButton.TextColor3 = Color3.fromRGB(200, 200, 255)
Instance.new("UICorner", hideButton)
hideButton.ZIndex = 10

local closeButton = Instance.new("TextButton", mainFrame)
closeButton.Size = UDim2.new(0, 90, 0, 36)
closeButton.Position = UDim2.new(1, -110, 1, -56)
closeButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
closeButton.Text = "Закрыть"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", closeButton)
closeButton.ZIndex = 10

local openButton = Instance.new("TextButton", screenGui)
openButton.Size = UDim2.new(0, 140, 0, 40)
openButton.Position = UDim2.new(0, 20, 1, -60)
openButton.BackgroundColor3 = Color3.fromRGB(40, 150, 100)
openButton.Text = "Открыть Меню"
openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openButton.Visible = false
Instance.new("UICorner", openButton)
openButton.ZIndex = 12

hideButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    shadow.Visible = false
    openButton.Visible = true
end)

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

openButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    shadow.Visible = true
    openButton.Visible = false
end)
