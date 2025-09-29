local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Попытка загрузки библиотеки redz-V5-remake
local Library
local success, err = pcall(function()
    Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/main/redz-V5-remake/init.lua"))()
end)
if not success then
    warn("Не удалось загрузить redz-V5-remake: " .. (err or "неизвестная ошибка") .. ". Использую базовый UI. 😕")
    Library = nil  -- Fallback на ручной UI
else
    print("redz-V5-remake успешно загружена! Использую её UI. 🚀")
end

-- Константы для стилей (черная тема, если библиотека поддерживает)
local STYLE = {
    MAIN_COLOR = Color3.fromRGB(15, 15, 15),
    SHADOW_COLOR = Color3.fromRGB(10, 10, 10),
    TAB_BUTTON_COLOR = Color3.fromRGB(30, 30, 30),
    TAB_ACTIVE_COLOR = Color3.fromRGB(50, 50, 50),
    TEXT_COLOR = Color3.fromRGB(200, 200, 200),
    TEXT_ACTIVE_COLOR = Color3.fromRGB(255, 255, 255),
    CORNER_RADIUS = UDim.new(0, 10)
}

-- Определение размеров в зависимости от устройства
local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
local frameSize = isMobile and UDim2.new(0, 300, 0, 250) or UDim2.new(0, 450, 0, 400)
local scaleFactor = isMobile and 0.6667 or 1

-- Создаем ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CatzikHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- UI через библиотеку или fallback
local mainFrame, tabsFrame, tabPages = nil, nil, {}
if Library and Library.CreateLib then
    -- Пример использования redz-V5-remake (адаптируй под реальные методы библиотеки)
    local lib = Library.CreateLib("🌌 Catzik Hub", "DarkTheme")  -- Предполагаемая функция создания окна
    mainFrame = lib.MainFrame  -- Получаем основной фрейм из библиотеки
    mainFrame.Size = frameSize
    mainFrame.Position = UDim2.new(0.5, -frameSize.X.Offset / 2, 0.5, -frameSize.Y.Offset / 2)
    mainFrame.BackgroundColor3 = STYLE.MAIN_COLOR
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    -- Создание вкладок через библиотеку
    local teleportTab = lib:NewTab("🌍 Teleport")
    local playerTab = lib:NewTab("👤 Player")
    local miscTab = lib:NewTab("🛠 Miscellaneous")
    
    tabPages = {["🌍 Teleport"] = teleportTab, ["👤 Player"] = playerTab, ["🛠 Miscellaneous"] = miscTab}
    tabsFrame = lib.TabFrame  -- Предполагаемый фрейм вкладок
else
    -- Fallback: Ручное создание (как раньше)
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
    tabsFrame = Instance.new("Frame")
    tabsFrame.Size = UDim2.new(1, -20 * scaleFactor, 0, 40 * scaleFactor)
    tabsFrame.Position = UDim2.new(0, 10 * scaleFactor, 0, 50 * scaleFactor)
    tabsFrame.BackgroundTransparency = 1
    tabsFrame.Parent = mainFrame
    
    local tabNames = {"🌍 Teleport", "👤 Player", "🛠 Miscellaneous"}
    local tabButtons = {}
    
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
    tabPages["🌍 Teleport"].Visible = true  -- Активация первой вкладки
end

-- Тени (адаптировано)
local shadow = Instance.new("Frame")
shadow.Size = mainFrame.Size + UDim2.new(0, 10 * scaleFactor, 0, 10 * scaleFactor)
shadow.Position = mainFrame.Position + UDim2.new(0, 5 * scaleFactor, 0, 5 * scaleFactor)
shadow.BackgroundColor3 = STYLE.SHADOW_COLOR
shadow.BackgroundTransparency = 0.8
shadow.ZIndex = 0
shadow.Parent = screenGui
Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 12 * scaleFactor)

if not Library or not Library.CreateLib then
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

-- [Остальной код: функции toggleNoclip, flyTo, getCFrameForPlace, updateOptions, redeemAllCodes и т.д. — вставь из предыдущей версии]
-- Для примера, добавлю redeemAllCodes с использованием библиотеки, если возможно
local codes = { -- Твой список кодов
    "LIGHTNINGABUSE", "1LOSTADMIN", -- ... (полный список)
}

local function redeemAllCodes()
    if Library and Library.FireRemote then
        -- Используем библиотеку для FireServer
        for _, code in ipairs(codes) do
            Library:FireRemote("RedeemCode", code)  -- Адаптируй под реальный метод
            wait(0.5)
        end
    else
        -- Fallback: Стандартный VirtualInputManager
        local virtualInputManager = game:GetService("VirtualInputManager")
        for _, code in ipairs(codes) do
            pcall(function()
                virtualInputManager:SendKeyEvent(true, "T", false, game)
                wait(0.1)
                virtualInputManager:SendText(code)
                wait(0.1)
                virtualInputManager:SendKeyEvent(true, "Enter", false, game)
                wait(0.2)
            end)
        end
    end
    print("Коды активированы через " .. (Library and "библиотеку" or "fallback") .. "! 🎉")
end

-- Кнопки управления (адаптировано)
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
    if callback then
        btn.MouseButton1Click:Connect(callback)
    end
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

-- Добавь кнопки в вкладки (Teleport, Player, Miscellaneous) аналогично предыдущей версии, используя tabPages[name] как parent
-- Например, для Miscellaneous:
local miscPage = tabPages["🛠 Miscellaneous"] or Instance.new("Frame")  -- Fallback
local redeemButton = createButton(miscPage, UDim2.new(0, 260, 0, 40), UDim2.new(0, 20, 120), Color3.fromRGB(25, 25, 25), "🎫 Redeem All Codes", Color3.fromRGB(200, 200, 200), redeemAllCodes)

-- [Вставь полный код вкладок, NoClip, Player stats и т.д. из предыдущей версии для полноты]
