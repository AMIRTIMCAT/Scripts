local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Ждем загрузки персонажа
if not character:FindFirstChild("HumanoidRootPart") then
    character:WaitForChild("HumanoidRootPart")
end

-- Включаем NoClip
local function enableNoClip()
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
    print("🔓 NoClip включен - можно проходить через стены")
end

-- Отключаем коллизии навсегда
enableNoClip()

-- Постоянно обновляем NoClip
local noclipConnection
noclipConnection = RunService.Stepped:Connect(function()
    if character and character:FindFirstChild("HumanoidRootPart") then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    else
        noclipConnection:Disconnect()
    end
end)

-- Функция плавной телепортации (имитация полета)
local function smoothFlyToPosition(targetPosition)
    local hrp = character.HumanoidRootPart
    local startPosition = hrp.Position
    local distance = (targetPosition - startPosition).Magnitude
    local duration = math.max(3, distance / 10) -- Плавное перемещение минимум 3 секунды
    
    local startTime = tick()
    
    while tick() - startTime < duration do
        local elapsed = tick() - startTime
        local progress = elapsed / duration
        local currentPosition = startPosition:Lerp(targetPosition, progress)
        
        -- Плавное перемещение с небольшими шагами
        hrp.Position = currentPosition
        RunService.Heartbeat:Wait()
    end
    
    -- Финальная точная позиция
    hrp.Position = targetPosition
    print("✅ Плавная телепортация завершена")
end

local bases = Workspace:WaitForChild("Bases")

for _, base in ipairs(bases:GetChildren()) do
    if base:IsA("Model") then
        local slots = base:FindFirstChild("Slots")
        if slots then
            for _, slot in ipairs(slots:GetChildren()) do
                for _, model in ipairs(slot:GetChildren()) do
                    if model:IsA("Model") and string.match(string.lower(model.Name), " femboy$") then
                        -- Телепортируем к позиции самой модели
                        local modelPosition
                        if model.PrimaryPart then
                            modelPosition = model.PrimaryPart.Position
                        else
                            -- Если нет PrimaryPart, вычисляем приблизительный центр модели
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
                        print("🚀 Начинаем плавную телепортацию к:", model.Name)
                        smoothFlyToPosition(targetPos)
                        print("✅ ТП к модели завершена:", model.Name)
                        return
                    end
                end
            end
        end
    end
end

warn("❌ Не найдено моделей, оканчивающихся на 'Femboy'")
