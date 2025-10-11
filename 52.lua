local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local bases = Workspace:WaitForChild("Bases")

local foundTargets = {}

for _, base in pairs(bases:GetChildren()) do
    local slots = base:FindFirstChild("Slots")
    if slots then
        for _, slot in pairs(slots:GetChildren()) do
            for _, model in pairs(slot:GetChildren()) do
                local hrp = model:FindFirstChild("HumanoidRootPart")
                if hrp then
                    table.insert(foundTargets, hrp)
                    print("👀 Найден:", model.Name, " | Позиция:", hrp.Position)
                end
            end
        end
    end
end

if #foundTargets > 0 then
    -- ⚡ Телепорт к самому первому найденному “челику”
    local target = foundTargets[1]
    character:MoveTo(target.Position + Vector3.new(0, 5, 0))
    print("✅ Телепорт прямо к:", target.Parent.Name)
else
    warn("❌ Не найдено ни одного HumanoidRootPart")
end
