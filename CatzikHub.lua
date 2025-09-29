local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Загрузка redz-V5-remake (main.luau)
local Library
local success, err = pcall(function()
    Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/main/redz-V5-remake/main.luau"))()
end)
if not success then
    warn("Не удалось загрузить redz-V5-remake/main.luau: " .. (err or "файл пустой/недоступен") .. ". Fallback на ручной UI. 😕")
    Library = nil
else
    print("redz-V5-remake загружена! 🚀")
end

-- Загрузка Icons (если нужно для кастомных эмодзи)
local Icons
if Library then
    local iconSuccess, iconErr = pcall(function()
        Icons = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/main/redz-V5-remake/Utils/Icons.lua"))()
    end)
    if not iconSuccess then
        warn("Icons.lua не загружен: " .. (iconErr or "ошибка") .. ". Использую стандартные эмодзи.")
    end
end

-- Константы стилей (для fallback или кастомизации библиотеки)
local STYLE = {
    MAIN_COLOR = Color3.fromRGB(15, 15, 15),
    SHADOW_COLOR = Color3.fromRGB(10, 10, 10),
    TAB_BUTTON_COLOR = Color3.fromRGB(30, 30, 30),
    TAB_ACTIVE_COLOR = Color3.fromRGB(50, 50, 50),
    TEXT_COLOR = Color3.fromRGB(200, 200, 200),
    TEXT_ACTIVE_COLOR = Color3.fromRGB(255, 255, 255),
    CORNER_RADIUS = UDim.new(0, 10)
}

-- Размеры под устройство
local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
local frameSize = isMobile and UDim2.new(0, 300, 0, 250) or UDim2.new(0, 450, 0, 400)
local scaleFactor = isMobile and 0.6667 or 1

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CatzikHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- UI через библиотеку или fallback
local mainFrame, tabPages = nil, {}
if Library and Library.new then
    -- Создание через redz-V5-remake
    local window = Library.new("🌌 Catzik Hub", frameSize, STYLE.MAIN_COLOR)
    mainFrame = window.Frame
    mainFrame.Position = UDim2.new(0.5, -frameSize.X.Offset / 2, 0.5, -frameSize.Y.Offset / 2)
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    -- Вкладки через библиотеку
    local teleportTab = window:tab("🌍 Teleport")
    local playerTab = window:tab("👤 Player")
    local miscTab = window:tab("🛠 Miscellaneous")
    tabPages = {["🌍 Teleport"] = teleportTab, ["👤 Player"] = playerTab, ["🛠 Miscellaneous"] = miscTab}
    
    -- Пример кнопок в вкладках (адаптируй под реальный API)
    teleportTab:button("🚀 Телепортироваться", function() end)  -- Placeholder
    playerTab:button("Обновить", function() end)  -- Placeholder
    miscTab:button("🎫 Redeem All Codes", redeemAllCodes)
    
    print("UI создан через redz-V5-remake! 🌟")
else
    -- Fallback: Ручной UI
    mainFrame = Instance.new("Frame")
    mainFrame.Size = frameSize
    mainFrame.Position = UDim2.new(0.5, -frameSize.X.Offset / 2, 0.5, -frameSize.Y.Offset / 2)
    mainFrame.BackgroundColor3 = STYLE.MAIN_COLOR
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    Instance.new("UICorner", mainFrame).CornerRadius = STYLE.CORNER_RADIUS
    
    -- Ручные вкладки
    local tabsFrame = Instance.new("Frame")
    tabsFrame.Size = UDim2.new(1, -20 * scaleFactor, 0, 40 * scaleFactor)
    tabsFrame.Position = UDim2.new(0, 10 * scaleFactor, 0, 50 * scaleFactor)
    tabsFrame.BackgroundTransparency = 1
    tabsFrame.Parent = mainFrame
    
    local tabButtons = {}
    local tabNames = {"🌍 Teleport", "👤 Player", "🛠 Miscellaneous"}
    
    local function createTab(name, index)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 120 * scaleFactor, 1, 0)
        btn.Position = UDim2.new(0, (index - 1) * 125 * scaleFactor, 0, 0)
        btn.BackgroundColor3 = STYLE.TAB_BUTTON_COLOR
        btn.Text = name
        btn.Font = Enum.Font.GothamBold
        btn.TextColor3 = STYLE.TEXT_COLOR
        btn.TextSize = 18 * scaleFactor
        btn.AutoButtonColor = false
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6 * scaleFactor)
        btn.Parent = tabsFrame
        
        local page = Instance.new("Frame")
        page.Size = UDim2.new(1, -20 * scaleFactor, 1, -110 * scaleFactor)
        page.Position = UDim2.new(0, 10 * scaleFactor, 0, 100 * scaleFactor)
        page.BackgroundTransparency = 1
        page.Visible = false
        page.Parent = mainFrame
        
        tabButtons[name] = btn
        tabPages[name] = page
        
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
        return page
    end
    
    for i, name in ipairs(tabNames) do
        createTab(name, i)
    end
    tabPages["🌍 Teleport"].Visible = true
end

-- Тени
local shadow = Instance.new("Frame")
shadow.Size = mainFrame.Size + UDim2.new(0, 10 * scaleFactor, 0, 10 * scaleFactor)
shadow.Position = mainFrame.Position + UDim2.new(0, 5 * scaleFactor, 0, 5 * scaleFactor)
shadow.BackgroundColor3 = STYLE.SHADOW_COLOR
shadow.BackgroundTransparency = 0.8
shadow.ZIndex = 0
shadow.Parent = screenGui
Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 12 * scaleFactor)

if not Library then
    mainFrame:GetPropertyChangedSignal("Position"):Connect(function()
        shadow.Position = mainFrame.Position + UDim2.new(0, 5 * scaleFactor, 0, 5 * scaleFactor)
    end)
end

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40 * scaleFactor)
title.BackgroundTransparency = 1
title.Text = "🌌 Catzik Hub"
title.TextColor3 = Color3.fromRGB(200, 200, 200)
title.Font = Enum.Font.GothamBold
title.TextSize = 24 * scaleFactor
title.Position = UDim2.new(0, 15 * scaleFactor, 0, 7 * scaleFactor)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = mainFrame

-- Функции
local noclipConn
local function toggleNoclip(character, enable)
    if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    if enable and character then
        local success, err = pcall(function()
            noclipConn = RunService.Stepped:Connect(function()
                if not character or not character.Parent then return end
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end)
        end)
        if not success then
            warn("NoClip заблокирован (возможно, анти-чит)! 😕")
            return
        end
    end
end

local function flyTo(destinationCFrame)
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not char or not hrp or not destinationCFrame then
        warn("Ошибка телепортации: недействительные данные! 😞")
        return
    end
    toggleNoclip(char, true)
    hrp.CFrame = hrp.CFrame + Vector3.new(0, 100, 0)
    local targetAbove = CFrame.new(destinationCFrame.Position + Vector3.new(0, 100, 0), destinationCFrame.Position)
    local distance = (hrp.Position - targetAbove.Position).Magnitude
    local duration = math.max(0.01, distance / 300)
    local tween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetAbove})
    tween:Play()
    tween.Completed:Connect(function()
        local downTween = TweenService:Create(hrp, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {CFrame = destinationCFrame})
        downTween:Play()
        downTween.Completed:Connect(function() toggleNoclip(char, false) end)
    end)
end

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

-- Teleport вкладка
local teleportPage = tabPages["🌍 Teleport"] or Instance.new("Frame")
teleportPage.Parent = mainFrame
local dropDown = Instance.new("TextButton")
dropDown.Size = UDim2.new(0, 260 * scaleFactor, 0, 40 * scaleFactor)
dropDown.Position = UDim2.new(0, 20 * scaleFactor, 0, 20 * scaleFactor)
dropDown.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
dropDown.Text = "📍 Выбрать место ▼"
dropDown.TextColor3 = Color3.fromRGB(200, 200, 200)
dropDown.Font = Enum.Font.Gotham
dropDown.TextSize = 16 * scaleFactor
Instance.new("UICorner", dropDown)
dropDown.Parent = teleportPage

local optionsFrame = Instance.new("Frame")
optionsFrame.Size = UDim2.new(0, 260 * scaleFactor, 0, 0)
optionsFrame.Position = UDim2.new(0, 20 * scaleFactor, 0, 60 * scaleFactor)
optionsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
optionsFrame.ClipsDescendants = true
optionsFrame.Visible = false
Instance.new("UICorner", optionsFrame)
optionsFrame.Parent = teleportPage

local tpButton = Instance.new("TextButton")
tpButton.Size = UDim2.new(0, 260 * scaleFactor, 0, 44 * scaleFactor)
tpButton.Position = UDim2.new(0, 20 * scaleFactor, 0, 120 * scaleFactor)
tpButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
tpButton.Text = "🚀 Телепортироваться"
tpButton.TextColor3 = Color3.fromRGB(200, 200, 200)
tpButton.Font = Enum.Font.GothamBold
tpButton.TextSize = 18 * scaleFactor
Instance.new("UICorner", tpButton)
tpButton.Parent = teleportPage

local options = {}
local selectedPlace = nil

local function updateOptions()
    local mapFolder = workspace:FindFirstChild("Map")
    if not mapFolder then return end
    optionsFrame:ClearAllChildren()
    options = {}
    local index = 1
    for _, model in ipairs(mapFolder:GetChildren()) do
        if model:IsA("Model") then
            local emoji = "🌐"
            table.insert(options, emoji .. " " .. model.Name)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 34 * scaleFactor)
            btn.Position = UDim2.new(0, 0, 0, (index - 1) * 34 * scaleFactor)
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            btn.Text = emoji .. " " .. model.Name
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 16 * scaleFactor
            Instance.new("UICorner", btn)
            btn.Parent = optionsFrame
            btn.MouseButton1Click:Connect(function()
                selectedPlace = model.Name
                dropDown.Text = emoji .. " " .. model.Name .. " ▼"
                optionsFrame.Visible = false
                optionsFrame.Size = UDim2.new(0, 260 * scaleFactor, 0, 0)
            end)
            index = index + 1
        end
    end
    optionsFrame.Size = UDim2.new(0, 260 * scaleFactor, 0, #options * 34 * scaleFactor)
end

updateOptions()

dropDown.MouseButton1Click:Connect(function()
    local isVisible = not optionsFrame.Visible
    optionsFrame.Visible = isVisible
    optionsFrame.Size = UDim2.new(0, 260 * scaleFactor, 0, isVisible and (#options * 34 * scaleFactor) or 0)
end)

tpButton.MouseButton1Click:Connect(function()
    if not selectedPlace then
        warn("Место не выбрано! ⚠")
        return
    end
    local cf = getCFrameForPlace(selectedPlace)
    if cf then flyTo(cf) else warn("Не найдена точка для " .. selectedPlace .. " 😔") end
end)

-- Player вкладка
local playerPage = tabPages["👤 Player"] or Instance.new("Frame")
playerPage.Parent = mainFrame
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0, 260 * scaleFactor, 0, 30 * scaleFactor)
speedLabel.Position = UDim2.new(0, 20 * scaleFactor, 0, 20 * scaleFactor)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "🏃 Скорость персонажа"
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 16 * scaleFactor
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = playerPage

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0, 260 * scaleFactor, 0, 40 * scaleFactor)
speedInput.Position = UDim2.new(0, 20 * scaleFactor, 0, 50 * scaleFactor)
speedInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
speedInput.TextColor3 = Color3.fromRGB(200, 200, 200)
speedInput.Text = "16"
speedInput.Font = Enum.Font.Gotham
speedInput.TextSize = 16 * scaleFactor
Instance.new("UICorner", speedInput)
speedInput.Parent = playerPage

local jumpLabel = Instance.new("TextLabel")
jumpLabel.Size = UDim2.new(0, 260 * scaleFactor, 0, 30 * scaleFactor)
jumpLabel.Position = UDim2.new(0, 20 * scaleFactor, 0, 100 * scaleFactor)
jumpLabel.BackgroundTransparency = 1
jumpLabel.Text = "🦘 Высота прыжка"
jumpLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
jumpLabel.Font = Enum.Font.Gotham
jumpLabel.TextSize = 16 * scaleFactor
jumpLabel.TextXAlignment = Enum.TextXAlignment.Left
jumpLabel.Parent = playerPage

local jumpInput = Instance.new("TextBox")
jumpInput.Size = UDim2.new(0, 260 * scaleFactor, 0, 40 * scaleFactor)
jumpInput.Position = UDim2.new(0, 20 * scaleFactor, 0, 130 * scaleFactor)
jumpInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
jumpInput.TextColor3 = Color3.fromRGB(200, 200, 200)
jumpInput.Text = "50"
jumpInput.Font = Enum.Font.Gotham
jumpInput.TextSize = 16 * scaleFactor
Instance.new("UICorner", jumpInput)
jumpInput.Parent = playerPage

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
    if enterPressed then updatePlayerStats() end
end)

jumpInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then updatePlayerStats() end
end)

-- Miscellaneous вкладка
local miscPage = tabPages["🛠 Miscellaneous"] or Instance.new("Frame")
miscPage.Parent = mainFrame
local noclipButton = Instance.new("TextButton")
noclipButton.Size = UDim2.new(0, 260 * scaleFactor, 0, 40 * scaleFactor)
noclipButton.Position = UDim2.new(0, 20 * scaleFactor, 0, 20 * scaleFactor)
noclipButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
noclipButton.TextColor3 = Color3.fromRGB(200, 200, 200)
noclipButton.Text = "👻 NoClip: Выкл"
noclipButton.Font = Enum.Font.Gotham
noclipButton.TextSize = 16 * scaleFactor
Instance.new("UICorner", noclipButton)
noclipButton.Parent = miscPage

local invisButton = Instance.new("TextButton")
invisButton.Size = UDim2.new(0, 260 * scaleFactor, 0, 40 * scaleFactor)
invisButton.Position = UDim2.new(0, 20 * scaleFactor, 0, 70 * scaleFactor)
invisButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
invisButton.TextColor3 = Color3.fromRGB(200, 200, 200)
invisButton.Text = "🫥 Невидимость: Выкл"
invisButton.Font = Enum.Font.Gotham
invisButton.TextSize = 16 * scaleFactor
Instance.new("UICorner", invisButton)
invisButton.Parent = miscPage

local redeemButton = Instance.new("TextButton")
redeemButton.Size = UDim2.new(0, 260 * scaleFactor, 0, 40 * scaleFactor)
redeemButton.Position = UDim2.new(0, 20 * scaleFactor, 0, 120 * scaleFactor)
redeemButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
redeemButton.TextColor3 = Color3.fromRGB(200, 200, 200)
redeemButton.Text = "🎫 Redeem All Codes"
redeemButton.Font = Enum.Font.Gotham
redeemButton.TextSize = 16 * scaleFactor
Instance.new("UICorner", redeemButton)
redeemButton.Parent = miscPage

local codes = {
    "LIGHTNINGABUSE", "1LOSTADMIN", "ADMINFIGHT", "NOMOREHACK", "BANEXPLOIT",
    "krazydares", "TRIPLEABUSE", "24NOADMIN", "REWARDFUN", "Chandler",
    "NEWTROLL", "KITT_RESET", "Sub2CaptainMaui", "kittgaming", "Sub2Fer999",
    "Enyu_is_Pro", "Magicbus", "JCWK", "Starcodeheo", "Bluxxy",
    "fudd10_v2", "SUB2GAMERROBOT_EXP1", "Sub2NoobMaster123", "Sub2UncleKizaru",
    "Sub2Daigrock", "Axiore", "TantaiGaming", "StrawHatMaine", "Sub2OfficialNoobie",
    "Fudd10", "Bignews", "TheGreatAce", "SECRET_ADMIN", "SUB2GAMERROBOT_RESET1",
    "SUB2OFFICIALNOOBIE", "AXIORE", "BIGNEWS", "BLUXXY", "CHANDLER", "ENYU_IS_PRO",
    "FUDD10", "FUDD10_V2", "KITTGAMING", "MAGICBUS", "STARCODEHEO", "STRAWHATMAINE",
    "SUB2CAPTAINMAUI", "SUB2DAIGROCK", "SUB2FER999", "SUB2NOOBMASTER123", "SUB2UNCLEKIZARU",
    "TANTAIGAMING", "THEGREATACE"
}

local function redeemAllCodes()
    local successCount = 0
    local virtualInputManager = game:GetService("VirtualInputManager")
    for _, code in ipairs(codes) do
        pcall(function()
            virtualInputManager:SendKeyEvent(true, "T", false, game)
            wait(0.1)
            virtualInputManager:SendText(code)
            wait(0.1)
            virtualInputManager:SendKeyEvent(true, "Enter", false, game)
            wait(0.2)
            successCount = successCount + 1
        end)
    end
    warn("Активировано " .. successCount .. " кодов! 🎉")
end

noclipButton.MouseButton1Click:Connect(function()
    local char = player.Character
    if char then
        local isEnabled = not noclipConn
        toggleNoclip(char, isEnabled)
        noclipButton.Text = isEnabled and "👻 NoClip: Вкл" or "👻 NoClip: Выкл"
    end
end)

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

redeemButton.MouseButton1Click:Connect(redeemAllCodes)

-- Кнопки управления
local function createButton(parent, size, pos, bgColor, text, textColor, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, size.X.Offset * scaleFactor, 0, size.Y.Offset * scaleFactor)
    btn.Position = UDim2.new(0, pos.X.Offset * scaleFactor, 1, pos.Y.Offset * scaleFactor)
    btn.BackgroundColor3 = bgColor
    btn.Text = text
    btn.TextColor3 = textColor
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18 * scaleFactor
    Instance.new("UICorner", btn)
    btn.ZIndex = 10
    btn.Parent = parent
    if callback then btn.MouseButton1Click:Connect(callback) end
    return btn
end

local hideButton = createButton(mainFrame, UDim2.new(0, 90, 0, 36), UDim2.new(0, 20, -56), Color3.fromRGB(30, 30, 30), "🙈 Скрыть", Color3.fromRGB(200, 200, 200), function()
    mainFrame.Visible = false
    shadow.Visible = false
    openButton.Visible = true
end)

local closeButton = createButton(mainFrame, UDim2.new(0, 90, 0, 36), UDim2.new(1, -110, -56), Color3.fromRGB(100, 30, 30), "❌ Закрыть", Color3.fromRGB(255, 255, 255), function()
    screenGui:Destroy()
end)

local openButton = createButton(screenGui, UDim2.new(0, 140, 0, 40), UDim2.new(0, 20, -60), Color3.fromRGB(30, 100, 30), "🔓 Открыть Меню", Color3.fromRGB(255, 255, 255), function()
    mainFrame.Visible = true
    shadow.Visible = true
    openButton.Visible = false
end)
openButton.Visible = false
openButton.ZIndex = 12
