local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()

local Window = Library:MakeWindow({
    Title = "Catzik Hub",
    SubTitle = "by Yoshi",
    ScriptFolder = "Catzik-Hub-V5"
})

-- TELEPORT TAB
local TeleportTab = Window:MakeTab({
    Title = "Teleport",
    Icon = "Car"
})

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
    -- Ищем любую BasePart для телепорта
    local part = nil
    for _, child in ipairs(model:GetChildren()) do
        if child:IsA("BasePart") then
            part = child
            break
        end
    end
    if not part then
        warn("В модели нет BasePart!")
        return nil
    end
    return part.CFrame
end

-- Список зон для ComboBox
local teleportOptions = {}
local function updateTeleportOptions()
    local mapFolder = workspace:FindFirstChild("Map")
    if not mapFolder then return end
    teleportOptions = {}
    for _, model in ipairs(mapFolder:GetChildren()) do
        if model:IsA("Model") then
            table.insert(teleportOptions, model.Name)
        end
    end
end
updateTeleportOptions()

local selectedTeleport = nil

local teleportDropdown = TeleportTab:AddDropdown({
    Name = "Select Location",
    Options = teleportOptions,
    Default = teleportOptions[1],
    Callback = function(value)
        selectedTeleport = value
    end
})

TeleportTab:AddButton({
    Name = "Teleport",
    Callback = function()
        if not selectedTeleport then
            print("Не выбрано место для телепорта.")
            return
        end
        local cframe = getCFrameForPlace(selectedTeleport)
        if not cframe then
            print("Невозможно телепортироваться — не найден CFrame.")
            return
        end

        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then
            warn("Нет HumanoidRootPart у персонажа!")
            return
        end

        local TweenService = game:GetService("TweenService")
        local targetCFrame = cframe * CFrame.new(0, 80, 0) -- подъём на 80 по Y
        local tweenInfo = TweenInfo.new((hrp.Position - targetCFrame.Position).Magnitude / 300, Enum.EasingStyle.Linear)

        -- Включаем noclip
        local noclipConnection
        local function noclip()
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
        noclip()
        noclipConnection = game:GetService("RunService").Stepped:Connect(noclip)

        local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
        tween:Play()
        tween.Completed:Wait()

        if noclipConnection then noclipConnection:Disconnect() end

        -- Позволяем персонажу спокойно упасть
        wait(1)
        print("Телепорт завершён!")
    end
})

-- FARM TAB
local FarmTab = Window:MakeTab({
    Title = "Farm",
    Icon = "Home"
})

-- UI Scale
local uiScaleEnabled = false
local uiScaleValue = 1

local uiScaleInstance = Instance.new("UIScale")
uiScaleInstance.Parent = Window.Main
uiScaleInstance.Scale = 1
uiScaleInstance.Enabled = false

FarmTab:AddToggle({
    Name = "Enable UI Scale",
    Default = false,
    Callback = function(value)
        uiScaleEnabled = value
        uiScaleInstance.Enabled = uiScaleEnabled
        if uiScaleEnabled then
            uiScaleInstance.Scale = uiScaleValue
        end
    end
})

FarmTab:AddSlider({
    Name = "UI Scale",
    Min = 0.5,
    Max = 2,
    Default = 1,
    Increment = 0.05,
    Callback = function(value)
        uiScaleValue = value
        if uiScaleEnabled then
            uiScaleInstance.Scale = uiScaleValue
        end
    end
})

-- Автосбор сундуков
local autoChest = false
local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

FarmTab:AddToggle({
    Name = "Auto Chest [ Tween ]",
    Default = false,
    Callback = function(value)
        autoChest = value
        if autoChest then
            spawn(function()
                while autoChest do
                    local chestFolder = workspace:FindFirstChild("ChestModels")
                    if not chestFolder then
                        print("Папка ChestModels не найдена")
                        break
                    end

                    local chests = chestFolder:GetChildren()
                    for _, chest in ipairs(chests) do
                        if not autoChest then break end
                        if chest:IsA("Model") then
                            local basePart = nil
                            -- Ищем базовую деталь для телепорта
                            for _, part in ipairs(chest:GetChildren()) do
                                if part:IsA("BasePart") then
                                    basePart = part
                                    break
                                end
                            end

                            if basePart then
                                -- Включаем noclip
                                local noclipConnection
                                local function noclip()
                                    for _, part in pairs(char:GetChildren()) do
                                        if part:IsA("BasePart") then
                                            part.CanCollide = false
                                        end
                                    end
                                end
                                noclip()
                                noclipConnection = game:GetService("RunService").Stepped:Connect(noclip)

                                local targetCFrame = basePart.CFrame * CFrame.new(0, 5, 0)
                                local tweenInfo = TweenInfo.new((hrp.Position - targetCFrame.Position).Magnitude / 300, Enum.EasingStyle.Linear)
                                local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})

                                tween:Play()
                                tween.Completed:Wait()

                                if noclipConnection then noclipConnection:Disconnect() end

                                -- Ждём пока сундук соберётся (или пауза)
                                wait(2)
                            else
                                print("В сундуке нет BasePart:", chest.Name)
                            end
                        end
                    end

                    wait(10) -- пауза между обходом сундуков
                end
            end)
        end
    end
})

-- FRUIT TAB
local FruitTab = Window:MakeTab({
    Title = "Fruit",
    Icon = "Cherry"
})

local autoCollectFruit = false

local fruitNames = {
    "Rocket Fruit", "Spin Fruit", "Chop Fruit", "Spike Fruit", "Kilo Fruit", "Smoke Fruit",
    "Spring Fruit", "Sand Fruit", "Ice Fruit", "Flame Fruit", "Barrier Fruit", "Bomb Fruit",
    "Falcon Fruit", "Rubber Fruit", "Love Fruit", "Light Fruit", "Dark Fruit", "Quake Fruit",
    "Paw Fruit", "Diamond Fruit", "Buddha Fruit", "Magma Fruit", "Quake Fruit", "Buddha Fruit",
    "Door Fruit", "Rift Fruit", "Gravity Fruit", "Soul Fruit", "TRex Fruit", "Kitsune Fruit",
    "Sound Fruit", "Mammoth Fruit", "Eagle Fruit", "Creation Fruit", "Yeti Fruit",
    "West Dragon Fruit", "East Dragon Fruit", "Spirit Fruit", "Gas Fruit", "Pain Fruit",
    "Lightning Fruit", "Blizzard Fruit", "Control Fruit", "Venom Fruit", "Dragon Fruit",
    "Leopard Fruit", "Shadow Fruit"
}

FruitTab:AddToggle({
    Name = "Auto Collect Fruit",
    Default = false,
    Callback = function(value)
        autoCollectFruit = value
        if autoCollectFruit then
            spawn(function()
                local player = game.Players.LocalPlayer
                local char = player.Character or player.CharacterAdded:Wait()
                local hrp = char:WaitForChild("HumanoidRootPart")
                local TweenService = game:GetService("TweenService")
                local fruitFolder = workspace:FindFirstChild("Fruit")

                while autoCollectFruit do
                    if not fruitFolder then
                        print("Папка Fruit не найдена")
                        break
                    end

                    for _, fruitName in ipairs(fruitNames) do
                        if not autoCollectFruit then break end
                        local fruit = fruitFolder:FindFirstChild(fruitName)
                        if fruit and fruit:IsA("Model") then
                            local basePart = nil
                            for _, part in ipairs(fruit:GetChildren()) do
                                if part:IsA("BasePart") then
                                    basePart = part
                                    break
                                end
                            end
                            if basePart then
                                -- Включаем noclip
                                local noclipConnection
                                local function noclip()
                                    for _, part in pairs(char:GetChildren()) do
                                        if part:IsA("BasePart") then
                                            part.CanCollide = false
                                        end
                                    end
                                end
                                noclip()
                                noclipConnection = game:GetService("RunService").Stepped:Connect(noclip)

                                local targetCFrame = basePart.CFrame * CFrame.new(0, 5, 0)
                                local tweenInfo = TweenInfo.new((hrp.Position - targetCFrame.Position).Magnitude / 300, Enum.EasingStyle.Linear)
                                local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})

                                tween:Play()
                                tween.Completed:Wait()

                                if noclipConnection then noclipConnection:Disconnect() end

                                wait(2)
                            else
                                print("Нет BasePart у фрукта:", fruitName)
                            end
                        end
                    end
                    wait(10)
                end
            end)
        end
    end
})

return Window
