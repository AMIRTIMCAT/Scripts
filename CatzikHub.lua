local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local Window = Library:MakeWindow({
    Title = "Catzik Hub",
    SubTitle = "by Yoshi",
    ScriptFolder = "Catzik-Hub-V5"
})

-- Функция noclip
local noclipEnabled = false
local function setNoclip(state)
    noclipEnabled = state
end

game:GetService("RunService").Stepped:Connect(function()
    if noclipEnabled then
        for _, part in ipairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    else
        for _, part in ipairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end)

-- Функция для телепорта с Tween и noclip
local function tweenToPosition(targetCFrame, speed)
    local hrp = humanoidRootPart
    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    local tweenInfo = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
    setNoclip(true)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
    tween.Completed:Wait()
    setNoclip(false)
end

-- ========== TELEPORT TAB ==========
local TeleportTab = Window:MakeTab({
    Title = "Teleport",
    Icon = "Car"
})

-- Обновление списка мест из workspace.Map
local function getMapModels()
    local mapFolder = workspace:FindFirstChild("Map")
    if not mapFolder then return {} end
    local models = {}
    for _, model in ipairs(mapFolder:GetChildren()) do
        if model:IsA("Model") then
            table.insert(models, model.Name)
        end
    end
    return models
end

local selectedPlace = nil
local comboBoxOptions = getMapModels()

local comboBox = TeleportTab:AddDropdown({
    Name = "Select Place",
    Options = comboBoxOptions,
    Default = comboBoxOptions[1],
    Callback = function(value)
        selectedPlace = value
    end
})

TeleportTab:AddButton({
    Name = "Teleport",
    Callback = function()
        if not selectedPlace then
            print("Выберите место для телепорта!")
            return
        end
        local mapFolder = workspace:FindFirstChild("Map")
        if not mapFolder then
            print("Папка Map не найдена!")
            return
        end
        local model = mapFolder:FindFirstChild(selectedPlace)
        if not model then
            print("Модель "..selectedPlace.." не найдена!")
            return
        end
        local basePart = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChildWhichIsA("BasePart")
        if not basePart then
            print("В модели нет части для телепортации!")
            return
        end
        -- Летим на 80 единиц выше модели
        local targetCFrame = basePart.CFrame + Vector3.new(0, 80, 0)
        tweenToPosition(targetCFrame, 300)
    end
})

-- ========== FARM TAB ==========
local FarmTab = Window:MakeTab({
    Title = "Farm",
    Icon = "Home"
})

-- UI Scale slider сверху
FarmTab:AddSlider({
    Name = "UI Scale",
    Min = 0.5,
    Max = 2.0,
    Default = 1,
    Increment = 0.05,
    Callback = function(value)
        -- Создаём или меняем UIScale у окна
        local uiScale = Window.Main:FindFirstChildOfClass("UIScale")
        if not uiScale then
            uiScale = Instance.new("UIScale")
            uiScale.Parent = Window.Main
        end
        uiScale.Scale = value
    end
})

local autoChestEnabled = false

FarmTab:AddToggle({
    Name = "Auto Chest [ Tween ]",
    Default = false,
    Callback = function(value)
        autoChestEnabled = value
        if autoChestEnabled then
            spawn(function()
                local chestFolder = workspace:FindFirstChild("ChestModels")
                if not chestFolder then
                    print("Папка ChestModels не найдена")
                    return
                end

                for _, chest in ipairs(chestFolder:GetChildren()) do
                    if not autoChestEnabled then break end
                    if chest:IsA("Model") then
                        print("Летим к сундуку: "..chest.Name)
                        local basePart = chest:FindFirstChild("HumanoidRootPart") or chest:FindFirstChildWhichIsA("BasePart")
                        if not basePart then
                            print("В сундуке нет подходящей части: "..chest.Name)
                            continue
                        end
                        local aboveCFrame = basePart.CFrame + Vector3.new(0, 10, 0)
                        tweenToPosition(aboveCFrame, 300)
                        print("Подлетели над сундуком: "..chest.Name)

                        -- Ждём пока сундук будет удалён (собран)
                        while chest.Parent and autoChestEnabled do
                            wait(0.5)
                        end

                        if not autoChestEnabled then
                            print("Auto Chest выключен, прекращаем фарм")
                            break
                        end

                        print("Сундук собран: "..chest.Name)
                        wait(0.5)
                    end
                end

                if autoChestEnabled then
                    print("Все сундуки обработаны")
                end
            end)
        end
    end
})

-- ========== FRUIT TAB ==========
local FruitTab = Window:MakeTab({
    Title = "Fruit",
    Icon = "Cherry"
})

local fruitsList = {
    "Rocket Fruit", "Spin Fruit", "Chop Fruit", "Spike Fruit", "Kilo Fruit",
    "Smoke Fruit", "Spring Fruit", "Sand Fruit", "Ice Fruit", "Flame Fruit",
    "Barrier Fruit", "Bomb Fruit", "Falcon Fruit", "Rubber Fruit", "Love Fruit",
    "Light Fruit", "Dark Fruit", "Quake Fruit", "Paw Fruit", "Diamond Fruit",
    "Buddha Fruit", "Magma Fruit", "Door Fruit", "Rift Fruit", "Gravity Fruit",
    "Soul Fruit", "TRex Fruit", "Kitsune Fruit", "Sound Fruit", "Mammoth Fruit",
    "Eagle Fruit", "Creation Fruit", "Yeti Fruit", "West Dragon Fruit", "East Dragon Fruit",
    "Spirit Fruit", "Gas Fruit", "Pain Fruit", "Lightning Fruit", "Blizzard Fruit",
    "Control Fruit", "Venom Fruit", "Dragon Fruit", "Leopard Fruit", "Shadow Fruit"
}

local autoFruitEnabled = false

FruitTab:AddToggle({
    Name = "Auto Collect Fruit",
    Default = false,
    Callback = function(value)
        autoFruitEnabled = value
        if autoFruitEnabled then
            spawn(function()
                local fruitFolder = workspace:FindFirstChild("Fruit")
                if not fruitFolder then
                    print("Папка Fruit не найдена")
                    return
                end

                while autoFruitEnabled do
                    for _, fruit in ipairs(fruitFolder:GetChildren()) do
                        if not autoFruitEnabled then break end
                        if fruit:IsA("Model") and table.find(fruitsList, fruit.Name) then
                            local basePart = fruit:FindFirstChild("HumanoidRootPart") or fruit:FindFirstChildWhichIsA("BasePart")
                            if not basePart then
                                print("В фрукте нет части для телепортации: "..fruit.Name)
                                continue
                            end
                            local aboveCFrame = basePart.CFrame + Vector3.new(0, 10, 0)
                            print("Летим к фрукту: "..fruit.Name)
                            tweenToPosition(aboveCFrame, 300)
                            wait(0.5)
                        end
                    end
                    wait(2)
                end
            end)
        end
    end
})
