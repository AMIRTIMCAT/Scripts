local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local bases = Workspace:WaitForChild("Bases")

local foundTargets = {}

-- 🔍 Поиск всех персонажей, чьи имена ОКАНЧИВАЮТСЯ на "Femboy"
for _, base in pairs(bases:GetChildren()) do
	if base:IsA("Model") then
		local slots = base:FindFirstChild("Slots")
		if slots then
			for _, slot in pairs(slots:GetChildren()) do
				if slot:IsA("Model") then
					for _, model in pairs(slot:GetChildren()) do
						if model:IsA("Model") then
							local name = string.lower(model.Name)
							-- проверка: имя должно заканчиваться на " femboy"
							if string.match(name, " femboy$") then
								local hrp = model:FindFirstChild("HumanoidRootPart")
								if hrp then
									table.insert(foundTargets, hrp)
									print("👀 Найден персонаж:", model.Name)
								end
							end
						end
					end
				end
			end
		end
	end
end

-- ⚡ Телепорт к первому найденному Femboy
if #foundTargets > 0 then
	local target = foundTargets[1]
	character:MoveTo(target.Position + Vector3.new(0, 5, 0))
	print("✅ Телепорт прямо к:", target.Parent.Name)
else
	warn("❌ Персонажей с окончанием 'Femboy' не найдено!")
end
