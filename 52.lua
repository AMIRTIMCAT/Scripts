local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local bases = Workspace:WaitForChild("Bases")

for _, base in ipairs(bases:GetChildren()) do
	if base:IsA("Model") then
		local slots = base:FindFirstChild("Slots")
		if slots then
			for _, slot in ipairs(slots:GetChildren()) do
				for _, model in ipairs(slot:GetChildren()) do
					if model:IsA("Model") and string.match(string.lower(model.Name), " femboy$") then
						local hrp = model:FindFirstChild("HumanoidRootPart")
						if hrp then
							character:MoveTo(hrp.Position + Vector3.new(0, 0, 0))
							print("✅ ТП к:", model.Name)
							return
						end
					end
				end
			end
		end
	end
end

warn("❌ Не найдено персонажей, оканчивающихся на 'Femboy'")
