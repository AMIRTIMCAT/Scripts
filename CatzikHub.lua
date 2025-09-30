local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()

local Window = Library:MakeWindow({
    Title = "Catzik Hub",
    SubTitle = "by Yoshi",
    ScriptFolder = "Catzik-Hub-V5"
})

local Tab = Window:MakeTab({
    Title = "Teleport",
    Icon = "Car"
})

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Включить/выключить noclip
local function setNoclip(state)
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = not state
        end
    end
end

-- Получить CFrame модели по имени из workspace.Map
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
    local part = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChildWhichIsA("BasePart")
    if not part then
        warn("В модели '" .. name .. "' нет HumanoidRootPart или BasePart!")
        return nil
    end
    return part.CFrame
end

-- Обновить список названий моделей из workspace.Map, у которых есть BasePart или HumanoidRootPart
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

-- Выбранное имя места для телепорта
local selectedPlace = options[1]

-- Создаём дропдаун с выбором места телепорта
local dropdown = Tab:AddDropdown({
    Name = "Select Location",
    Options = options,
    Default = selectedPlace,
    Callback = function(value)
        selectedPlace = value
        print("Выбрано место:", value)
    end
})

-- Кнопка телепорта с уведомлениями
Tab:AddButton({
    Name = "Teleport",
    Callback = function()
        if not selectedPlace then
            warn("Место не выбрано!")
            return
        end

        local targetCFrame = getCFrameForPlace(selectedPlace)
        if not targetCFrame then
            warn("Не удалось получить позицию для '" .. selectedPlace .. "'")
            return
        end

        Window:Notify({
            Title = "Телепорт",
            Content = "Начинаю телепорт к " .. selectedPlace,
            Duration = 3,
            Image = "rbxassetid://10734953451" -- Можно заменить на любую иконку
        })

        setNoclip(true)

        -- Поднимаемся на 80 по Y
        local targetPos = targetCFrame.Position + Vector3.new(0, 80, 0)
        local targetCF = CFrame.new(targetPos, targetCFrame.Position)

        local tweenService = game:GetService("TweenService")
        local distance = (humanoidRootPart.Position - targetPos).Magnitude
        local tweenInfo = TweenInfo.new(distance / 300, Enum.EasingStyle.Linear)

        local tween = tweenService:Create(humanoidRootPart, tweenInfo, {CFrame = targetCF})
        tween:Play()

        tween.Completed:Connect(function()
            setNoclip(false)
            Window:Notify({
                Title = "Телепорт",
                Content = "Вы успешно телепортировались в " .. selectedPlace,
                Duration = 3,
                Image = "rbxassetid://10734953451"
            })
            print("Телепорт завершён, noclip выключен")
        end)
    end
})
