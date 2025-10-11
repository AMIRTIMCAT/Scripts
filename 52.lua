local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local bases = Workspace:WaitForChild("Bases")

local foundModels = {}

-- 🔍 Поиск всех моделей с HumanoidRootPart
for _, base in pairs(bases:GetChildren()) do
    local slots = base:FindFirstChild("Slots")
    if slots then
        for _, slot in pairs(slots:GetChildren()) do
            for _, model in pairs(slot:GetChildren()) do
                if model:FindFirstChild("HumanoidRootPart") then
                    table.insert(foundModels, model)
                    print("👀 Найден персонаж:", model.Name)
                end
            end
        end
    end
end

-- ⚡ Если есть найденные модели — тпшимся к первому
if #foundModels > 0 then
    local target = foundModels[1] -- можешь поменять индекс, например [2], [3] и т.д.
    character:MoveTo(target.HumanoidRootPart.Position + Vector3.new(0, 5, 0))
    print("✅ Телепорт к:", target.Name)
else
    warn("❌ Не найдено ни одного персонажа с HumanoidRootPart")
end
