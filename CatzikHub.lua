-- Подключаем библиотеку
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()
if not Library then
    warn("Не удалось загрузить библиотеку")
    return
end

-- Создаем окно
local Window = Library:MakeWindow({
    Title = "Catzik Hub",
    SubTitle = "by Yoshi",
    ScriptFolder = "redz-library-V5"
})

-- Вкладки
local TeleportTab = Window:Tab("Teleport")
local PlayerTab = Window:Tab("Player")
local MiscTab = Window:Tab("Misc")

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer

-- Глобальные переменные
local noclipConn = nil
local selectedPlace = nil
local options = {}

-- === Функции ===

-- Ноклип: отключает коллизию для всех частей персонажа
local function toggleNoclip(character, enable)
    if noclipConn then
        noclipConn:Disconnect()
        noclipConn = nil
    end
    if enable and character then
        local ok, err = pcall(function()
            noclipConn = RunService.Stepped:Connect(function()
                if not character or not character.Parent then return end
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)
        end)
        if not ok then
            warn("Ошибка включения noclip:", err)
        end
    end
end

-- Плавный “полет” к месту
local function flyTo(destinationCFrame)
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not char or not hrp or not destinationCFrame then
        warn("flyTo: неверные параметры")
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
        downTween.Completed:Connect(function()
            toggleNoclip(char, false)
        end)
    end)
end

-- Получить CFrame места из workspace.Map
local function getCFrameForPlace(name)
    local mapFolder = workspace:FindFirstChild("Map")
    if not mapFolder then
        warn("getCFrameForPlace: папка Map не найдена")
        return nil
    end
    local model = mapFolder:FindFirstChild(name)
    if not model then
        warn("getCFrameForPlace: модель " .. name .. " не найдена")
        return nil
    end
    local hrp = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChildWhichIsA("BasePart")
    if not hrp then
        warn("getCFrameForPlace: нет HumanoidRootPart")
        return nil
    end
    return hrp.CFrame
end

-- Обновить список мест для телепорта
local function updateOptions()
    local mapFolder = workspace:FindFirstChild("Map")
    if not mapFolder then
        options = {}
        return
    end
    options = {}
    for _, model in ipairs(mapFolder:GetChildren()) do
        if model:IsA("Model") then
            table.insert(options, model.Name)
        end
    end
end

-- Обновить характеристики игрока
local function updatePlayerStats(speed, jump)
    local char = player.Character
    if not char or not char:FindFirstChild("Humanoid") then
        warn("updatePlayerStats: humanoid не найден")
        return
    end
    local humanoid = char.Humanoid
    if speed then
        humanoid.WalkSpeed = math.clamp(speed, 0, 100)
    end
    if jump then
        humanoid.JumpPower = math.clamp(jump, 0, 200)
    end
end

-- === UI: подключаем функции к интерфейсу ===

-- Player вкладка
do
    local section = PlayerTab:Section("Player Controls")
    section:Toggle("Noclip", false, function(state)
        toggleNoclip(player.Character, state)
    end)
    section:Slider("WalkSpeed", 16, { min = 16, max = 100, precise = true }, function(val)
        updatePlayerStats(val, nil)
    end)
    section:Slider("JumpPower", 50, { min = 50, max = 200, precise = true }, function(val)
        updatePlayerStats(nil, val)
    end)
end

-- Teleport вкладка
do
    local section = TeleportTab:Section("Teleport")
    local dropdown = section:Dropdown("Select Place", options, function(choice)
        selectedPlace = choice
    end)
    section:Button("Fly to Selected", function()
        if not selectedPlace then
            warn("Вы не выбрали место")
            return
        end
        local cf = getCFrameForPlace(selectedPlace)
        if cf then
            flyTo(cf)
        end
    end)

    -- Автообновление dropdown каждые 10 секунд
    spawn(function()
        while true do
            task.wait(10)
            updateOptions()
            dropdown:Refresh(options)
        end
    end)
end

-- Misc вкладка
do
    local section = MiscTab:Section("Misc Features")
    section:Toggle("Invisibility", false, function(state)
        local char = player.Character
        if not char then return end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Transparency = state and 1 or 0
            end
        end
    end)
    section:Button("Redeem All Codes", function()
        local codes = {
            "update3", "yay1klikes", "release", "wupdate2",
            "woo3500", "2.5klikesyay", "wow1.5klikes"
        }
        local VirtualInputManager = game:GetService("VirtualInputManager")
        for _, code in ipairs(codes) do
            task.wait(0.3)
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait(0.3)
            for i = 1, #code do
                local c = code:sub(i,i)
                local key = Enum.KeyCode[c:upper()] or Enum.KeyCode.Unknown
                VirtualInputManager:SendKeyEvent(true, key, false, game)
                task.wait(0.03)
            end
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
        end
    end)
end

-- Инициализируем UI
Window:Init()

