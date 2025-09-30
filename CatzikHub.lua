local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()

local Window = Library:MakeWindow({
    Title = "Catzik Hub",
    SubTitle = "by Yoshi",
    ScriptFolder = "Catzik-Hub-V5"
})

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 🧱 Noclip
local function setNoclip(state)
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = not state
        end
    end
end

-- 📍 Получение позиции модели
local function getCFrameForPlace(name)
    local mapFolder = workspace:FindFirstChild("Map")
    if not mapFolder then return nil end
    local model = mapFolder:FindFirstChild(name)
    if not model then return nil end
    local part = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChildWhichIsA("BasePart")
    if not part then return nil end
    return part.CFrame
end

-- 🚀 Tween-перемещение
local function tweenToPosition(targetCFrame)
    local character = game.Players.LocalPlayer.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local tweenService = game:GetService("TweenService")
    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    local tweenInfo = TweenInfo.new(distance / 300, Enum.EasingStyle.Linear)

    local raised = targetCFrame + Vector3.new(0, 80, 0)
    local tween = tweenService:Create(hrp, tweenInfo, {CFrame = raised})

    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end

    tween:Play()
    tween.Completed:Wait()

    -- ❌ отключение noclip
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
end

-- 📦 Teleport Tab
local TabTeleport = Window:MakeTab({
    Title = "Teleport",
    Icon = "Car"
})

-- 📄 Получение всех зон
local options = {}
local function updateOptions()
    options = {}
    local mapFolder = workspace:FindFirstChild("Map")
    if not mapFolder then return end
    for _, model in ipairs(mapFolder:GetChildren()) do
        if model:IsA("Model") then
            local hasPart = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChildWhichIsA("BasePart")
            if hasPart then
                table.insert(options, model.Name)
            end
        end
    end
end
updateOptions()

local selectedPlace = options[1]

-- 🔽 Dropdown
TabTeleport:AddDropdown({
    Name = "Select Location",
    Options = options,
    Default = selectedPlace,
    Callback = function(value)
        selectedPlace = value
    end
})

-- 🔘 Teleport Button
TabTeleport:AddButton({
    Name = "Teleport",
    Callback = function()
        if not selectedPlace then return end
        local targetCFrame = getCFrameForPlace(selectedPlace)
        if not targetCFrame then return end

        Window:Notify({
            Title = "Телепорт",
            Content = "Начинаю телепорт к " .. selectedPlace,
            Duration = 3
        })

        tweenToPosition(targetCFrame)

        Window:Notify({
            Title = "Телепорт",
            Content = "Успешно телепортирован в " .. selectedPlace,
            Duration = 3
        })
    end
})

-- 🌾 Farm Tab
local TabFarm = Window:MakeTab({
    Title = "Farm",
    Icon = "Home"
})

local autoChest = false
local chests = {"Chest1", "Chest2", "Chest3"}

-- 📍 Получить CFrame сундуков
local function getChestCFrame(name)
    local mapFolder = workspace:FindFirstChild("Map")
    if not mapFolder then return nil end
    local chestModel = mapFolder:FindFirstChild(name)
    if not chestModel then return nil end
    local part = chestModel:FindFirstChild("HumanoidRootPart") or chestModel:FindFirstChildWhichIsA("BasePart")
    if not part then return nil end
    return part.CFrame
end

-- 🔁 Фарм
task.spawn(function()
    while true do
        if autoChest then
            for _, name in ipairs(chests) do
                if not autoChest then break end
                local cf = getChestCFrame(name)
                if cf then
                    Window:Notify({
                        Title = "Auto Chest",
                        Content = "Лечу к " .. name,
                        Duration = 2
                    })
                    tweenToPosition(cf)
                end
                task.wait(0.3)
            end
        end
        task.wait(0.5)
    end
end)

-- ✅ Переключатель
TabFarm:AddToggle({
    Name = "Auto Chest [ Tween ]",
    Default = false,
    Callback = function(state)
        autoChest = state
        Window:Notify({
            Title = "Auto Chest",
            Content = state and "Включён" or "Выключен",
            Duration = 2
        })
    end
})
