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

local function setNoclip(state)
  for _, part in pairs(character:GetChildren()) do
    if part:IsA("BasePart") then
      part.CanCollide = not state
    end
  end
end

local mapFolder = workspace:FindFirstChild("Map")
if not mapFolder then
  warn("Папка 'Map' не найдена в workspace!")
  return
end

local modelNames = {}
local modelsMap = {}

for _, model in pairs(mapFolder:GetChildren()) do
  if model:IsA("Model") and model.PrimaryPart then
    table.insert(modelNames, model.Name)
    modelsMap[model.Name] = model
  end
end

local selectedModelName = modelNames[1]

local dropdown = Tab:AddDropdown({
  Name = "Select Location",
  Options = modelNames,
  Default = selectedModelName,
  Callback = function(value)
    selectedModelName = value
    print("Выбрана модель:", value)
  end
})

Tab:AddButton({
  Name = "Teleport",
  Callback = function()
    if not selectedModelName then
      warn("Модель не выбрана!")
      return
    end

    local targetModel = modelsMap[selectedModelName]
    if not targetModel or not targetModel.PrimaryPart then
      warn("Модель не найдена или не имеет PrimaryPart")
      return
    end

    setNoclip(true)

    local targetPos = targetModel.PrimaryPart.Position + Vector3.new(0, 80, 0)
    local tweenService = game:GetService("TweenService")
    local distance = (humanoidRootPart.Position - targetPos).Magnitude
    local tweenInfo = TweenInfo.new(distance / 300, Enum.EasingStyle.Linear)

    local tween = tweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(targetPos)})
    tween:Play()

    tween.Completed:Connect(function()
      setNoclip(false)
      print("Телепорт завершён, noclip выключен")
    end)
  end
})
