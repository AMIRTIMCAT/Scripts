-- Instant Steal для Femboy игры
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- Создаем UI кнопку
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "InstantStealUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local stealButton = Instance.new("TextButton")
stealButton.Name = "InstantStealButton"
stealButton.Size = UDim2.new(0, 200, 0, 50)
stealButton.Position = UDim2.new(0, 20, 0, 20)
stealButton.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
stealButton.BorderSizePixel = 0
stealButton.Text = "🎯 INSTANT STEAL FEMBOY"
stealButton.TextColor3 = Color3.fromRGB(255, 255, 255)
stealButton.Font = Enum.Font.GothamBold
stealButton.TextSize = 14
stealButton.ZIndex = 10
stealButton.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = stealButton

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255, 20, 147)
stroke.Thickness = 2
stroke.Parent = stealButton

-- Функция поиска ближайшего Femboy
local function findNearestFemboy()
    local character = player.Character
    if not character then return nil end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return nil end
    
    local playerPos = humanoidRootPart.Position
    local nearestFemboy = nil
    local nearestDistance = 50 -- Максимальная дистанция кражи
    
    -- Ищем Femboy по типам
    local femboyTypes = {
        "Cat Femboy",
        "Bunny Femboy", 
        "Employed Femboy"
    }
    
    -- Ищем в workspace
    for _, femboyType in pairs(femboyTypes) do
        local femboy = workspace:FindFirstChild(femboyType)
        if femboy then
            local distance = (playerPos - femboy.Position).Magnitude
            if distance < nearestDistance then
                nearestDistance = distance
                nearestFemboy = femboy
            end
        end
    end
    
    -- Ищем всех детей workspace с Femboy в названии
    for _, obj in pairs(workspace:GetChildren()) do
        if string.find(obj.Name, "Femboy") then
            local distance = (playerPos - obj.Position).Magnitude
            if distance < nearestDistance then
                nearestDistance = distance
                nearestFemboy = obj
            end
        end
    end
    
    return nearestFemboy
end

-- Функция поиска свободного слота на базе
local function findFreeSlot()
    -- Ищем базы (предполагаем структуру Workspace.Bases.Base1-8.Slots.Slot1-33)
    for i = 1, 8 do
        local baseName = "Base" .. i
        local base = workspace:FindFirstChild("Bases")
        if base then
            base = base:FindFirstChild(baseName)
            if base then
                local slots = base:FindFirstChild("Slots")
                if slots then
                    -- Ищем свободный слот
                    for j = 1, 33 do
                        local slotName = "Slot" .. j
                        local slot = slots:FindFirstChild(slotName)
                        if slot then
                            -- Проверяем пустой ли слот (нет Femboy внутри)
                            local isEmpty = true
                            for _, child in pairs(slot:GetChildren()) do
                                if string.find(child.Name, "Femboy") then
                                    isEmpty = false
                                    break
                                end
                            end
                            
                            if isEmpty then
                                return slot
                            end
                        end
                    end
                end
            end
        end
    end
    
    -- Если не нашли слоты, ищем просто базу
    local base = workspace:FindFirstChild("Base") or workspace:FindFirstChild("Spawn")
    if base then
        return base
    end
    
    return nil
end

-- Главная функция Instant Steal
local stealCooldown = false

local function instantSteal()
    if stealCooldown then return end
    stealCooldown = true
    
    local character = player.Character
    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then 
        stealCooldown = false
        return 
    end
    
    -- Визуальные эффекты
    TweenService:Create(stealButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    }):Play()
    stealButton.Text = "🎯 STEALING..."
    
    -- 1. Находим ближайшего Femboy
    local targetFemboy = findNearestFemboy()
    
    if targetFemboy then
        print("🎯 Найден Femboy: " .. targetFemboy.Name)
        
        -- 2. Телепортируемся к Femboy
        humanoidRootPart.CFrame = CFrame.new(targetFemboy.Position + Vector3.new(0, 0, -3))
        
        -- 3. Симуляция кражи (возможно нужно вызвать ивент)
        -- Если есть ивент CollectMoneySound - вызываем его
        local collectEvent = game:GetService("ReplicatedStorage"):FindFirstChild("Events")
        if collectEvent then
            collectEvent = collectEvent:FindFirstChild("CollectMoneySound")
            if collectEvent then
                collectEvent:FireServer()
            end
        end
        
        -- 4. Находим свободный слот на базе
        task.wait(0.3)
        local freeSlot = findFreeSlot()
        
        if freeSlot then
            -- 5. Телепортируем Femboy на базу
            targetFemboy.CFrame = freeSlot.CFrame
            
            -- 6. Телепортируем себя на базу
            humanoidRootPart.CFrame = freeSlot.CFrame + Vector3.new(0, 0, -5)
            
            stealButton.Text = "✅ STOLEN & RETURNED"
            print("✅ Украл " .. targetFemboy.Name .. " и вернул на базу!")
        else
            -- Если слот не найден, просто телепортируемся на спавн
            humanoidRootPart.CFrame = CFrame.new(0, 10, 0)
            stealButton.Text = "✅ STOLEN"
            print("✅ Украл " .. targetFemboy.Name)
        end
        
        TweenService:Create(stealButton, TweenInfo.new(0.3), {
            BackgroundColor3 = Color3.fromRGB(50, 205, 50)
        }):Play()
        
    else
        stealButton.Text = "❌ NO FEMBOY FOUND"
        TweenService:Create(stealButton, TweenInfo.new(0.3), {
            BackgroundColor3 = Color3.fromRGB(255, 69, 0)
        }):Play()
        print("❌ Femboy не найден рядом")
    end
    
    task.wait(1)
    
    -- Возвращаем кнопку в исходное состояние
    stealButton.Text = "🎯 INSTANT STEAL FEMBOY"
    TweenService:Create(stealButton, TweenInfo.new(0.3), {
        BackgroundColor3 = Color3.fromRGB(255, 105, 180)
    }):Play()
    
    -- КД 3 секунды
    task.wait(2)
    stealCooldown = false
end

-- Обработчик кнопки
stealButton.MouseButton1Click:Connect(instantSteal)

-- Адаптация для мобильных устройств
if UserInputService.TouchEnabled then
    stealButton.Size = UDim2.new(0, 220, 0, 60)
    stealButton.TextSize = 16
end

print("🎯 Instant Steal Femboy загружен!")
print("🔍 Ищет: Cat Femboy, Bunny Femboy, Employed Femboy")
print("🏠 Возвращает на свободные слоты Base1-8.Slot1-33")
