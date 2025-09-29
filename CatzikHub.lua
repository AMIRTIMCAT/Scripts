local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer

-- Безопасная загрузка библиотеки redz-V5-remake
local function loadLibrary()
    local url = "https://raw.githubusercontent.com/tlredz/Library/main/redz-V5-remake/main.luau"
    local httpResponse = nil
    local success, err = pcall(function()
        httpResponse = game:HttpGetAsync(url)
    end)
    if not success or not httpResponse or httpResponse == "" then
        warn("Ошибка: не удалось загрузить библиотеку redz-V5-remake")
        return nil
    end

    local func, loadError = loadstring(httpResponse)
    if not func then
        warn("Ошибка компиляции библиотеки:", loadError)
        return nil
    end

    local lib = nil
    local ok, res = pcall(function()
        return func()
    end)
    if not ok or not res then
        warn("Ошибка инициализации библиотеки:", res)
        return nil
    end
    return res
end

local Library = loadLibrary()
if not Library then
    return -- прерываем скрипт если библиотека не загрузилась
end

-- Создаем окно
local window = Library.new({
    name = "CatzikHub",
    loading_title = "CatzikHub is loading...",
    game = game,
})

-- Вкладки
local teleportTab = window:Tab("Teleport")
local playerTab = window:Tab("Player")
local miscTab = window:Tab("Miscellaneous")

-- Глобальные переменные
local noclipConn
local selectedPlace = nil
local options = {}

-- Функции

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
        if not success then warn("NoClip заблокирован!") end
    end
end

local function flyTo(destinationCFrame)
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not char or not hrp or not destinationCFrame then
        warn("Ошибка телепортации!")
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

local function getCFrameForPlace(name)
    local mapFolder = workspace:FindFirstChild("Map")
    if not mapFolder then
        warn("Папка 'Map' не найдена!")
        return nil
    end
    local model = mapFolder:FindFirstChild(name)
    if not model then
        warn("Модель '" .. name .. "' не найдена!")
        return nil
    end
    local hrp = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChildWhichIsA("BasePart")
    if not hrp then
        warn("Нет HumanoidRootPart в модели!")
        return nil
    end
    return hrp.CFrame
end

local function updateOptions()
    local mapFolder = workspace:FindFirstChild("Map")
    if not mapFolder then return end
    options = {}
    for _, model in ipairs(mapFolder:GetChildren()) do
        if model:IsA("Model") then
            table.insert(options, model.Name)
        end
    end
end
updateOptions()

local function updatePlayerStats(speed, jump)
    local char = player.Character
    if not char or not char:FindFirstChild("Humanoid") then
        warn("Персонаж не найден!")
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

-- UI

local playerSection = playerTab:Section("Player Movement")

playerSection:Slider("WalkSpeed", 16, {min = 16, max = 100, precise = true}, function(value)
    updatePlayerStats(value, nil)
end)

playerSection:Slider("JumpPower", 50, {min = 50, max = 200, precise = true}, function(value)
    updatePlayerStats(nil, value)
end)

playerSection:Toggle("Noclip", false, function(enabled)
    toggleNoclip(player.Character, enabled)
end)

local tpSection = teleportTab:Section("Teleport Zones")

local dropdown = tpSection:Dropdown("Select Place", options, function(selected)
    selectedPlace = selected
end)

tpSection:Button("Fly to Selected", function()
    if not selectedPlace then
        warn("Выберите место для телепорта")
        return
    end
    local cf = getCFrameForPlace(selectedPlace)
    if cf then
        flyTo(cf)
    end
end)

spawn(function()
    while true do
        task.wait(10)
        updateOptions()
        dropdown:Refresh(options)
    end
end)

local miscSection = miscTab:Section("Miscellaneous Features")

miscSection:Toggle("Invisibility", false, function(state)
    local char = player.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Transparency = state and 1 or 0
        end
    end
end)

miscSection:Button("Redeem All Codes", function()
    local codes = {
        "update3", "yay1klikes", "release", "wupdate2",
        "woo3500", "2.5klikesyay", "wow1.5klikes"
    }
    local VirtualInputManager = game:GetService("VirtualInputManager")

    for _, code in pairs(codes) do
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

-- Запускаем UI
window:Init()
