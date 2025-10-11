local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local player = players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Ждем загрузки персонажа
if not character:FindFirstChild("HumanoidRootPart") then
    character:WaitForChild("HumanoidRootPart")
end

-- Включаем NoClip и настраиваем полет
local function enableFlight()
    local hrp = character.HumanoidRootPart
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    -- Отключаем гравитацию и коллизии
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
            part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end
    end
    
    -- Отключаем гравитацию у HRP
    hrp:SetNetworkOwner(nil)
    
    if humanoid then
        humanoid.PlatformStand = true -- Отключаем физику персонажа
    end
    
    print("🚀 Режим полета включен - тело летит вместе с камерой")
end

-- Включаем полет
enableFlight()

-- Постоянно обновляем NoClip
local noclipConnection
noclipConnection = RunService.Stepped:Connect(function()
    if character and character:FindFirstChild("HumanoidRootPart") then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
                part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            end
        end
    else
        noclipConnection:Disconnect()
    end
end)

-- Функция плавного полета тела к цели
local function smoothBodyFlyToPosition(targetPosition)
    local hrp = character.HumanoidRootPart
    local startPosition = hrp.Position
    local distance = (targetPosition - startPosition).Magnitude
    local duration = math.max(4, distance / 8) -- Еще более плавно
    
    local startTime = tick()
    
    while tick() - startTime < duration do
        local elapsed = tick() - startTime
        local progress = elapsed / duration
        
        -- Плавное движение с easing (для более натурального полета)
        local easedProgress = 1 - (1 - progress) * (1 - progress) -- Квадратичное easing
        local currentPosition = startPosition:Lerp(targetPosition, easedProgress)
        
        -- Двигаем ВСЕ тело, а не только HRP
        hrp.Position = currentPosition
        
        -- Небольшая пауза для плавности
        RunService.Heartbeat:Wait()
    end
    
    -- Финальная позиция
    hrp.Position = targetPosition
    print("✅ Полет тела завершен")
end

local bases = Workspace:WaitForChild("Bases")

for _, base in ipairs(bases:GetChildren()) do
    if base:IsA("Model") then
        local slots = base:FindFirstChild("Slots")
        if slots then
            for _, slot in ipairs(slots:GetChildren()) do
                for _, model in ipairs(slot:GetChildren()) do
                    if model:IsA("Model") and string.match(string.lower(model.Name), " femboy$") then
                        -- Находим позицию модели
                        local modelPosition
                        if model.PrimaryPart then
                            modelPosition = model.PrimaryPart.Position
                        else
                            local minX, maxX, minY, maxY, minZ, maxZ = math.huge, -math.huge, math.huge, -math.huge, math.huge, -math.huge
                            for _, part in ipairs(model:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    local pos = part.Position
                                    minX, maxX = math.min(minX, pos.X), math.max(maxX, pos.X)
                                    minY, maxY = math.min(minY, pos.Y), math.max(maxY, pos.Y)
                                    minZ, maxZ = math.min(minZ, pos.Z), math.max(maxZ, pos.Z)
                                end
                            end
                            modelPosition = Vector3.new((minX + maxX) / 2, (minY + maxY) / 2, (minZ + maxZ) / 2)
                        end
                        
                        local targetPos = modelPosition + Vector3.new(0, 3, 0)
                        print("🚀 Начинаем полет тела к:", model.Name)
                        smoothBodyFlyToPosition(targetPos)
                        print("✅ Полет к модели завершен:", model.Name)
                        return
                    end
                end
            end
        end
    end
end

warn("❌ Не найдено моделей, оканчивающихся на 'Femboy'")
