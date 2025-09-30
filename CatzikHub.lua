local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()

local Window = Library:MakeWindow({
    Title = "Catzik Hub",
    SubTitle = "by Yoshi",
    ScriptFolder = "Catzik-Hub-V5"
})

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Noclip
local function setNoclip(state)
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not state
        end
    end
end

-- Tween перемещение
local function tweenToPosition(targetCFrame)
    local hrp = humanoidRootPart
    if not hrp then return end

    local tweenService = game:GetService("TweenService")
    local targetPosition = targetCFrame.Position

    -- Позиция чуть перед сундуком (сдвиг по Z вперед относительно сундука)
    local approachOffset = Vector3.new(0, 5, -3)  -- 5 вверх, 3 назад по Z, чтобы не застрять в сундуке

    local destination = CFrame.new(targetPosition + approachOffset)

    local distance = (hrp.Position - destination.Position).Magnitude
    local speed = 300
    local tweenInfo = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)

    local tween = tweenService:Create(hrp, tweenInfo, {CFrame = destination})

    setNoclip(true)
    tween:Play()
    tween.Completed:Wait()
    setNoclip(false)
end


-- Teleport Tab
local TabTeleport = Window:MakeTab({
    Title = "Teleport",
    Icon = "Car"
})

local teleportOptions = {}
local function updateTeleportOptions()
    teleportOptions = {}
    local mapFolder = workspace:FindFirstChild("Map")
    if not mapFolder then
        print("[Teleport] Map folder not found")
        return
    end
    for _, model in ipairs(mapFolder:GetChildren()) do
        if model:IsA("Model") then
            local hasPart = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChildWhichIsA("BasePart")
            if hasPart then
                table.insert(teleportOptions, model.Name)
            end
        end
    end
end
updateTeleportOptions()

local selectedPlace = teleportOptions[1]

TabTeleport:AddDropdown({
    Name = "Select Location",
    Options = teleportOptions,
    Default = selectedPlace,
    Callback = function(value)
        selectedPlace = value
    end
})

TabTeleport:AddButton({
    Name = "Teleport",
    Callback = function()
        local mapFolder = workspace:FindFirstChild("Map")
        if not mapFolder then
            print("[Teleport Error] Map not found")
            return
        end
        local model = mapFolder:FindFirstChild(selectedPlace)
        if not model then
            print("[Teleport Error] Model not found:", selectedPlace)
            return
        end
        local part = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChildWhichIsA("BasePart")
        if not part then
            print("[Teleport Error] No valid part found in model")
            return
        end

        tweenToPosition(part.CFrame)
    end
})

-- Farm Tab
local TabFarm = Window:MakeTab({
    Title = "Farm",
    Icon = "Home"
})

local autoChest = false
local lastLogTime = 0

-- Получить все CFrame сундуков из workspace.ChestModels
local function getAllChestCFrames()
    local cframes = {}
    local chestFolder = workspace:FindFirstChild("ChestModels")
    if not chestFolder then
        return cframes
    end

    for _, chest in ipairs(chestFolder:GetChildren()) do
        if chest:IsA("Model") then
            local part = chest:FindFirstChild("HumanoidRootPart") or chest:FindFirstChildWhichIsA("BasePart")
            if part then
                table.insert(cframes, part.CFrame)
            end
        end
    end

    return cframes
end

-- Цикл авто-честа
task.spawn(function()
    while true do
        if autoChest then
            local chests = getAllChestCFrames()

            if tick() - lastLogTime >= 10 then
                if #chests == 0 then
                    print("[AutoChest] ❌ No chests found.")
                else
                    print("[AutoChest] ✅ Found", #chests, "chests.")
                end
                lastLogTime = tick()
            end

            for _, cframe in ipairs(chests) do
                if not autoChest then break end
                tweenToPosition(cframe)
                task.wait(0.3)
            end
        end
        task.wait(0.5)
    end
end)

TabFarm:AddToggle({
    Name = "Auto Chest [ Tween ]",
    Default = false,
    Callback = function(state)
        autoChest = state
        print("[AutoChest] Toggled:", state)
    end
})
