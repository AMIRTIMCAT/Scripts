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

-- Получаем игрока и его персонажа
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- Функция для включения и выключения noclip
local function setNoclip(state)
  if state then
    -- Отключаем столкновения
    for _, part in pairs(character:GetChildren()) do
      if part:IsA("BasePart") then
        part.CanCollide = false
      end
    end
  else
    -- Включаем столкновения
    for _, part in pairs(character:GetChildren()) do
      if part:IsA("BasePart") then
        part.CanCollide = true
      end
    end
  end
end

-- Получаем список моделей из workspace.Map
local mapFolder = workspace:FindFirstChild("Map")
local locations = {}

if mapFolder then
  for _, model in pairs(mapFolder:GetChildren()) do
    if model:IsA("Model") and model:FindFirstChild("PrimaryPart") then
      table.insert(locations, model.Name)
    end
  end
else
  warn("Map folder not found in workspace")
end

local selectedLocation = nil

-- Создаём Dropdown с локациями
local dropdown = Tab:AddDropdown({
  Name = "Select Location",
  Options = locations,
  Default = locations[1] or "",
  Callback = function(value)
    selectedLocation = value
    print("Selected location:", value)
  end
})

-- Кнопка Teleport
Tab:AddButton({
  Name = "Teleport",
  Callback = function()
    if not selectedLocation then
      warn("No location selected")
      return
    end

    local targetModel = mapFolder:FindFirstChild(selectedLocation)
    if not targetModel or not targetModel.PrimaryPart then
      warn("Target model or PrimaryPart not found")
      return
    end

    -- Включаем noclip
    setNoclip(true)

    -- Целевая позиция (с поправкой по Y +80)
    local targetPos = targetModel.PrimaryPart.Position + Vector3.new(0, 80, 0)

    -- Tween для полёта к точке
    local tweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(
      (humanoidRootPart.Position - targetPos).Magnitude / 300, -- скорость 300
      Enum.EasingStyle.Linear
    )
    local tween = tweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(targetPos)})

    tween:Play()

    tween.Completed:Connect(function()
      -- Отключаем noclip, даём упасть естественно
      setNoclip(false)
      -- Можно дополнительно убедиться, что игрок в воздухе и не в состоянии парить
      print("Teleport complete, noclip off")
    end)
  end
})
