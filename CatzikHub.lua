local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/main/redz-V5-remake/main.luau"))()

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Создание окна
local Window = Library:MakeWindow({
    Title = "Catzik Hub",
    SubTitle = "by Yoshi",
    ScriptFolder = "redz-library-V5"
})

-- Вкладки
local TeleportTab = Window:Tab("Teleport")
local PlayerTab = Window:Tab("Player")
local MiscTab = Window:Tab("Miscellaneous")

-- Переменные
local noclipConn = nil
local selectedPlace = nil
local options = {}

-- Функция: обновить параметры игрока
local function updatePlayerStats(speed, jump)
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if speed then hum.WalkSpeed = math.clamp(speed, 0, 100) end
    if jump then hum.JumpPower = math.clamp(jump, 0, 200) end
end

-- Функция: включение/выключение noclip
local function toggleNoclip(character, enable)
    if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    if enable and character then
        local success = pcall(function()
            noclipConn = RunService.Stepped:Connect(function()
                if not character or not character.Parent then return end
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)
        end)
        if not success then warn("Noclip ошибка!") end
    end
end

-- Функция: получить CFrame точки по имени
local function getCFrameForPlace(name)
    local map = workspace:FindFirstChild("Map")
    if not map then return end
    local model = map:FindFirstChild(name)
    if not model then return end
    local hrp = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChildWhichIsA("BasePart")
    return hrp and hrp.CFrame
end

-- Функция: плавный полет к цели
local function flyTo(destinationCFrame)
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp or not destinationCFrame then return end

    toggleNoclip(char, true)
    hrp.CFrame = hrp.CFrame + Vector3.new(0, 100, 0)

    local targetAbove = CFrame.new(destinationCFrame.Position + Vector3.new(0, 100, 0), destinationCFrame.Position)
    local dist = (hrp.Position - targetAbove.Position).Magnitude
    local duration = math.max(0.01, dist / 300)

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

-- Функция: обновить список зон
local function updateOptions()
    local map = workspace:FindFirstChild("Map")
    options = {}
    if map then
        for _, model in ipairs(map:GetChildren()) do
            if model:IsA("Model") then
                table.insert(options, model.Name)
            end
        end
    end
end

updateOptions()

-- === UI ===

-- Player Tab
do
    local section = PlayerTab:Section("Movement")
    section:Slider("WalkSpeed", 16, {min = 16, max = 100, precise = true}, function(value)
        updatePlayerStats(value, nil)
    end)
    section:Slider("JumpPower", 50, {min = 50, max = 200, precise = true}, function(value)
        updatePlayerStats(nil, value)
    end)
    section:Toggle("Noclip", false, function(state)
        toggleNoclip(player.Character, state)
    end)
end

-- Teleport Tab
do
    local section = TeleportTab:Section("Map Teleport")
    local dropdown = section:Dropdown("Select Place", options, function(selected)
        selectedPlace = selected
    end)
    section:Button("Fly to Selected", function()
        if not selectedPlace then
            warn("Место не выбрано")
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
end

-- Misc Tab
do
    local section = MiscTab:Section("Other Features")

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

-- Init UI
Window:Init()
