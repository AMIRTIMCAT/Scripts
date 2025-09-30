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
local locations = {}

-- Мапа имени к объекту (чтобы по имени потом быстро искать)
local locationObjects = {}

if mapFolder then
  for _, obj in pairs(mapFolder:GetChildren()) do
    if obj:IsA("Model") and obj.PrimaryPart then
      table.insert(locations, obj.Name)
      locationObjects[obj.Name] = obj
    elseif obj:IsA("BasePart") then
      table.insert(locations, obj.Name)
      locationObjects[obj.Name] = obj
    end
  end
else
  warn("Map folder not found in workspace")
end

local selectedLocation = nil

local dropdown = Tab:AddDropdown({
  Name = "Select Location",
  Options = locations,
  Default = locations[1] or "",
  Callback = function(value)
    selectedLocation = value
    print("Selected location:", value)
  end
})

Tab:AddButton({
  Name = "Teleport",
  Callback = function()
    if not selectedLocation then
      warn("No location selected")
      return
    end

    local targetObject = locationObjects[selectedLocation]
    if not targetObject then
      warn("Target object not found")
      return
    end

    local targetPos
    if targetObject:IsA("Model") then
      targetPos = targetObject.PrimaryPart and targetObject.PrimaryPart.Position
      if not targetPos then
        warn("Model has no PrimaryPart")
        return
      end
    elseif targetObject:IsA("BasePart") then
      targetPos = targetObject.Position
    else
      warn("Unsupported target object type")
      return
    end

    setNoclip(true)

    local tweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(
      (humanoidRootPart.Position - targetPos).Magnitude / 300,
      Enum.EasingStyle.Linear
    )
    local tween = tweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(targetPos + Vector3.new(0, 80, 0))})

    tween:Play()

    tween.Completed:Connect(function()
      setNoclip(false)
      print("Teleport complete, noclip off")
    end)
  end
})
