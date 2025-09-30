local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local Window = Library:MakeWindow({
    Title = "Catzik Hub",
    SubTitle = "by Yoshi",
    ScriptFolder = "Catzik-Hub-V5"
})

-- Noclip управление
local noclipEnabled = false
local function setNoclip(state)
    noclipEnabled = state
end
RunService.Stepped:Connect(function()
    if noclipEnabled and character then
        for _, part in ipairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    else
        if character then
            for _, part in ipairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end)

-- Вкладка Teleport
local TeleportTab = Window:MakeTab({
    Title = "Teleport",
    Icon = "Car"
})

-- Обновляем список моделей из workspace.Map
local function getMapModels()
    local mapFolder = workspace:FindFirstChild("Map")
    local models = {}
    if mapFolder then
        for _, model in ipairs(mapFolder:GetChildren()) do
            if model:IsA("Model") then
                table.insert(models, model.Name)
            end
        end
    end
    return models
end

local selectedModelName = nil

local comboBox = TeleportTab:AddDropdown({
    Name = "Select Map Model",
    Options = getMapModels(),
    Default = nil,
    MultiSelect = false,
    Callback = function(value)
        selectedModelName = value
    end
})

TeleportTab:AddButton({
    Name = "Teleport",
    Callback = function()
        if not selectedModelName then
            print("Выберите модель для телепорта!")
            return
        end

        local mapFolder = workspace:FindFirstChild("Map")
        if not mapFolder then
            print("Папка 'Map' не найдена!")
            return
        end

        local model = mapFolder:FindFirstChild(selectedModelName)
        if not model then
            print("Модель не найдена: "..selectedModelName)
            return
        end

        -- Ищем BasePart для позиции (HumanoidRootPart или первый BasePart)
        local basePart = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChildWhichIsA("BasePart")
        if not basePart then
            print("В модели нет подходящей части (HumanoidRootPart/BasePart)")
            return
        end

        local targetCFrame = basePart.CFrame

        -- Tween полёт с noclip
        local hrp = humanoidRootPart
        local distance = (hrp.Position - targetCFrame.Position).Magnitude
        local speed = 300
        local tweenInfo = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
        
        setNoclip(true)
        local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
        tween:Play()
        tween.Completed:Wait()
        setNoclip(false)
        
        print("Телепорт выполнен к "..selectedModelName)
    end
})

-- Вкладка Farm
local FarmTab = Window:MakeTab({
    Title = "Farm",
    Icon = "Home"
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
                    if not autoChestEnabled then break end -- стоп если выключили
                    if chest:IsA("Model") then
                        print("Летим к сундуку: "..chest.Name)
                        local basePart = chest:FindFirstChild("HumanoidRootPart") or chest:FindFirstChildWhichIsA("BasePart")
                        if not basePart then
                            print("В сундуке нет подходящей части: "..chest.Name)
                            continue
                        end
                        -- Летим над сундуком на 10 юнитов выше
                        local aboveCFrame = basePart.CFrame + Vector3.new(0, 10, 0)
                        local hrp = humanoidRootPart
                        local distance = (hrp.Position - aboveCFrame.Position).Magnitude
                        local speed = 300
                        local tweenInfo = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)

                        setNoclip(true)
                        local tween = TweenService:Create(hrp, tweenInfo, {CFrame = aboveCFrame})
                        tween:Play()
                        tween.Completed:Wait()
                        setNoclip(false)

                        print("Подлетели над сундуком: "..chest.Name)

                        -- Ждем пока сундук исчезнет (соберется)
                        while chest.Parent and autoChestEnabled do
                            wait(0.5)
                        end

                        if not autoChestEnabled then
                            print("Auto Chest выключен, прекращаем фарм")
                            break
                        end

                        print("Сундук собран: "..chest.Name)
                        wait(0.5) -- небольшая пауза перед следующим сундуком
                    end
                end

                if autoChestEnabled then
                    print("Все сундуки обработаны")
                end
            end)
        end
    end
})
