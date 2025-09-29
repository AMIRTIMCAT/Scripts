local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Константы для стилей (черная тема)
local STYLE = {
    MAIN_COLOR = Color3.fromRGB(15, 15, 15),
    SHADOW_COLOR = Color3.fromRGB(10, 10, 10),
    TAB_BUTTON_COLOR = Color3.fromRGB(30, 30, 30),
    TAB_ACTIVE_COLOR = Color3.fromRGB(50, 50, 50),
    TEXT_COLOR = Color3.fromRGB(200, 200, 200),
    TEXT_ACTIVE_COLOR = Color3.fromRGB(255, 255, 255),
    CORNER_RADIUS = UDim.new(0, 10)
}

-- Создаем ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CatzikHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Основной фрейм
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 450, 0, 400)
mainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
mainFrame.BackgroundColor3 = STYLE.MAIN_COLOR
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = STYLE.CORNER_RADIUS

-- Тени
local shadow = Instance.new("Frame")
shadow.Size = mainFrame.Size + UDim2.new(0, 10, 0, 10)
shadow.Position = mainFrame.Position + UDim2.new(0, 5, 0, 5)
shadow.BackgroundColor3 = STYLE.SHADOW_COLOR
shadow.BackgroundTransparency = 0.8
shadow.ZIndex = 0
shadow.Parent = screenGui
Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 12)

mainFrame:GetPropertyChangedSignal("Position"):Connect(function()
    shadow.Position = mainFrame.Position + UDim2.new(0, 5, 0, 5)
end)

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "🌌 Catzik Hub"
title.TextColor3 = Color3.fromRGB(200, 200, 200)
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.Position = UDim2.new(0, 15, 0, 7)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = mainFrame

-- Кнопки табов
local tabsFrame = Instance.new("Frame")
tabsFrame.Size = UDim2.new(1, -20, 0, 40)
tabsFrame.Position = UDim2.new(0, 10, 0, 50)
tabsFrame.BackgroundTransparency = 1
tabsFrame.Parent = mainFrame

local tabButtons = {}
local tabPages = {}
local tabNames = {"🌍 Teleport", "👤 Player", "🛠 Miscellaneous"}

-- Функция для создания вкладок
local function createTab(name, index)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 120, 1, 0)
    btn.Position = UDim2.new(0, (index - 1) * 125, 0, 0)
    btn.BackgroundColor3 = STYLE.TAB_BUTTON_COLOR
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = STYLE.TEXT_COLOR
    btn.TextSize = 18
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.Parent = tabsFrame

    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -20, 1, -110)
    page.Position = UDim2.new(0, 10, 0, 100)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = mainFrame

    tabButtons[name] = btn
    tabPages[name] = page

    -- Функция переключения вкладки
    local function switchTab()
        for tn, tb in pairs(tabButtons) do
            tb.BackgroundColor3 = STYLE.TAB_BUTTON_COLOR
            tb.TextColor3 = STYLE.TEXT_COLOR
            tabPages[tn].Visible = false
        end
        btn.BackgroundColor3 = STYLE.TAB_ACTIVE_COLOR
        btn.TextColor3 = STYLE.TEXT_ACTIVE_COLOR
        page.Visible = true
    end

    btn.MouseButton1Click:Connect(switchTab)

    return page, switchTab
end

-- Создаем вкладки
local tabSwitches = {}
for i, name in ipairs(tabNames) do
    local page, switch = createTab(name, i)
    tabSwitches[name] = switch
end

-- Активируем первую вкладку
tabSwitches["🌍 Teleport"]()

-- --- Контент вкладки Teleport ---
local teleportPage = tabPages["🌍 Teleport"]

local dropDown = Instance.new("TextButton")
dropDown.Size = UDim2.new(0, 260, 0, 40)
dropDown.Position = UDim2.new(0, 20, 0, 20)
dropDown.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
dropDown.TextColor3 = Color3.fromRGB(200, 200, 200)
dropDown.Text = "📍 Выбрать место ▼"
dropDown.Font = Enum.Font.Gotham
dropDown.TextSize = 16
Instance.new("UICorner", dropDown)
dropDown.ZIndex = 10
dropDown.Parent = teleportPage

local optionsFrame = Instance.new("Frame")
optionsFrame.Size = UDim2.new(0, 260, 0, 0)
optionsFrame.Position = UDim2.new(0, 20, 0, 60)
optionsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
optionsFrame.ClipsDescendants = true
optionsFrame.Visible = false
Instance.new("UICorner", optionsFrame)
optionsFrame.ZIndex = 11
optionsFrame.Parent = teleportPage

local tpButton = Instance.new("TextButton")
tpButton.Size = UDim2.new(0, 260, 0, 44)
tpButton.Position = UDim2.new(0, 20, 0, 120)
tpButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
tpButton.Text = "🚀 Телепортироваться"
tpButton.TextColor3 = Color3.fromRGB(200, 200, 200)
tpButton.Font = Enum.Font.GothamBold
tpButton.TextSize = 18
Instance.new("UICorner", tpButton)
tpButton.ZIndex = 10
tpButton.Parent = teleportPage

local options = {
    "🏛 Colosseum", "🏜 Desert", "⛲ Fountain", "🌴 Jungle", "🌋 Magma",
    "⚓ MarineStart", "🏴‍☠ Pirate", "⛓ Prison", "☁ Sky", "🌌 SkyArea1", "🌠 SkyArea2"
}
local selectedPlace = nil

-- Создание кнопок выпадающего меню
for i, name in ipairs(options) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.Position = UDim2.new(0, 0, 0, (i-1) * 34)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Text = name
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    Instance.new("UICorner", btn)
    btn.ZIndex = 12
    btn.Parent = optionsFrame

    btn.MouseButton1Click:Connect(function()
        selectedPlace = name:gsub("^[^\ ]+ ", "")
        dropDown.Text = name .. " ▼"
        optionsFrame.Visible = false
        optionsFrame.Size = UDim2.new(0, 260, 0, 0)
    end)
end

dropDown.MouseButton1Click:Connect(function()
    local isVisible = not optionsFrame.Visible
    optionsFrame.Visible = isVisible
    optionsFrame.Size = UDim2.new(0, 260, 0, isVisible and (#options * 34) or 0)
end)

-- --- Контент вкладки Player ---
local playerPage = tabPages["👤 Player"]

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0, 260, 0, 30)
speedLabel.Position = UDim2.new(0, 20, 0, 20)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "🏃 Скорость персонажа"
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 16
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = playerPage

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0, 260, 0, 40)
speedInput.Position = UDim2.new(0, 20, 0, 50)
speedInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
speedInput.TextColor3 = Color3.fromRGB(200, 200, 200)
speedInput.Text = "16"
speedInput.Font = Enum.Font.Gotham
speedInput.TextSize = 16
Instance.new("UICorner", speedInput)
speedInput.Parent = playerPage

local jumpLabel = Instance.new("TextLabel")
jumpLabel.Size = UDim2.new(0, 260, 0, 30)
jumpLabel.Position = UDim2.new(0, 20, 0, 100)
jumpLabel.BackgroundTransparency = 1
jumpLabel.Text = "🦘 Высота прыжка"
jumpLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
jumpLabel.Font = Enum.Font.Gotham
jumpLabel.TextSize = 16
jumpLabel.TextXAlignment = Enum.TextXAlignment.Left
jumpLabel.Parent = playerPage

local jumpInput = Instance.new("TextBox")
jumpInput.Size = UDim2.new(0, 260, 0, 40)
jumpInput.Position = UDim2.new(0, 20, 0, 130)
jumpInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
jumpInput.TextColor3 = Color3.fromRGB(200, 200, 200)
jumpInput.Text = "50"
jumpInput.Font = Enum.Font.Gotham
jumpInput.TextSize = 16
Instance.new("UICorner", jumpInput)
jumpInput.Parent = playerPage

-- Обработчики ввода для скорости и прыжка
local function updatePlayerStats()
    local char = player.Character
    if not char or not char:FindFirstChild("Humanoid") then
        warn("Персонаж не найден! 😞")
        return
    end
    local humanoid = char.Humanoid

    local speed = tonumber(speedInput.Text) or humanoid.WalkSpeed
    local jump = tonumber(jumpInput.Text) or humanoid.JumpPower

    speed = math.clamp(speed, 0, 100)
    jump = math.clamp(jump, 0, 200)

    humanoid.WalkSpeed = speed
    humanoid.JumpPower = jump

    speedInput.Text = tostring(humanoid.WalkSpeed)
    jumpInput.Text = tostring(humanoid.JumpPower)

    if humanoid.WalkSpeed ~= speed or humanoid.JumpPower ~= jump then
        warn("Изменение заблокировано (возможно, анти-чит)! ⚠")
    end
end

speedInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        updatePlayerStats()
    end
end)

jumpInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        updatePlayerStats()
    end
end)

-- --- Контент вкладки Miscellaneous ---
local miscPage = tabPages["🛠 Miscellaneous"]

local noclipButton = Instance.new("TextButton")
noclipButton.Size = UDim2.new(0, 260, 0, 40)
noclipButton.Position = UDim2.new(0, 20, 0, 20)
noclipButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
noclipButton.TextColor3 = Color3.fromRGB(200, 200, 200)
noclipButton.Text = "👻 NoClip: Выкл"
noclipButton.Font = Enum.Font.Gotham
noclipButton.TextSize = 16
Instance.new("UICorner", noclipButton)
noclipButton.Parent = miscPage

local invisButton = Instance.new("TextButton")
invisButton.Size = UDim2.new(0, 260, 0, 40)
invisButton.Position = UDim2.new(0, 20, 0, 70)
invisButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
invisButton.TextColor3 = Color3.fromRGB(200, 200, 200)
invisButton.Text = "🫥 Невидимость: Выкл"
invisButton.Font = Enum.Font.Gotham
invisButton.TextSize = 16
Instance.new("UICorner", invisButton)
invisButton.Parent = miscPage

-- Управление NoClip
local noclipConn
local function toggleNoclip(character, enable)
    if noclipConn then
        noclipConn:Disconnect()
        noclipConn = nil
    end
    if enable and character then
        local success, err = pcall(function()
            noclipConn = RunService.Stepped:Connect(function()
                if not character or not character.Parent then return end
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)
        end)
        if not success then
            warn("NoClip заблокирован (возможно, анти-чит)! 😕")
            noclipButton.Text = "👻 NoClip: Заблокировано"
            return
        end
    end
end

noclipButton.MouseButton1Click:Connect(function()
    local char = player.Character
    if char then
        local isEnabled = not noclipConn
        toggleNoclip(char, isEnabled)
        noclipButton.Text = isEnabled and "👻 NoClip: Вкл" or "👻 NoClip: Выкл"
    end
end)

-- Управление невидимостью
local isInvisible = false
invisButton.MouseButton1Click:Connect(function()
    local char = player.Character
    if char then
        isInvisible = not isInvisible
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Transparency = isInvisible and 1 or 0
            end
        end
        invisButton.Text = isInvisible and "🫥 Невидимость: Вкл" or "🫥 Невидимость: Выкл"
    end
    if not isInvisible and not char:FindFirstChildWhichIsA("BasePart").Transparency == 0 then
        warn("Невидимость может быть заблокирована анти-читом! ⚠")
    end
end)

-- Функция телепортации
local function flyTo(destinationCFrame)
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not char or not hrp then
        return
    end

    toggleNoclip(char, true)
    hrp.CFrame = hrp.CFrame + Vector3.new(0, 100, 0)

    local targetAbove = CFrame.new(destinationCFrame.Position + Vector3.new(0, 100, 0), destinationCFrame.Position)
    local distance = (hrp.Position - targetAbove.Position).Magnitude
    local speed = 300
    local duration = math.max(0.01, distance / speed)

    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetAbove})
    tween:Play()

    tween.Completed:Connect(function()
        local downTween = TweenService:Create(hrp, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {CFrame = destinationCFrame})
        downTween:Play()
        downTween.Completed:Connect(function()
            toggleNoclip(char, false)
        end)
    end)
end

-- Получение CFrame для локации
local function getCFrameForPlace(name)
    local mapFolder = workspace:FindFirstChild("Map")
    if not mapFolder then
        warn("Папка 'Map' не найдена! 😢")
        return
    end

    local model = mapFolder:FindFirstChild(name)
    if not model then
        warn("Модель '" .. name .. "' не найдена! 😞")
        return
    end

    local hrp = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChildWhichIsA("BasePart")
    if not hrp then
        warn("В модели '" .. name .. "' нет HumanoidRootPart или BasePart! 😕")
        return
    end

    return hrp.CFrame
end

tpButton.MouseButton1Click:Connect(function()
    if not selectedPlace then
        warn("Место не выбрано! ⚠")
        return
    end

    local cf = getCFrameForPlace(selectedPlace)
    if cf then
        flyTo(cf)
    else
        warn("Не найдена точка для " .. selectedPlace .. " 😔")
    end
end)

-- Кнопки управления GUI
local function createButton(parent, size, pos, bgColor, text, textColor)
    local btn = Instance.new("TextButton")
    btn.Size = size
    btn.Position = pos
    btn.BackgroundColor3 = bgColor
    btn.Text = text
    btn.TextColor3 = textColor
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    Instance.new("UICorner", btn)
    btn.ZIndex = 10
    btn.Parent = parent
    return btn
end

local hideButton = createButton(mainFrame, UDim2.new(0, 90, 0, 36), UDim2.new(0, 20, 1, -56), Color3.fromRGB(30, 30, 30), "🙈 Скрыть", Color3.fromRGB(200, 200, 200))
local closeButton = createButton(mainFrame, UDim2.new(0, 90, 0, 36), UDim2.new(1, -110, 1, -56), Color3.fromRGB(100, 30, 30), "❌ Закрыть", Color3.fromRGB(255, 255, 255))
local openButton = createButton(screenGui, UDim2.new(0, 140, 0, 40), UDim2.new(0, 20, 1, -60), Color3.fromRGB(30, 100, 30), "🔓 Открыть Меню", Color3.fromRGB(255, 255, 255))
openButton.Visible = false
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
