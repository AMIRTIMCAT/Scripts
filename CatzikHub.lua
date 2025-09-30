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
    if not hrp then print("HumanoidRootPart not found!") return end

    local tweenService = game:GetService("TweenService")
    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    local tweenInfo = TweenInfo.new(distance / 300, Enum.EasingStyle.Linear)

    local raised = targetCFrame + Vector3.new(0, 80, 0)
    local tween = tweenService:Create(hrp, tweenInfo, {CFrame = raised})

    print("[Tween] Start to position:", raised.Position)
    setNoclip(true)
    tween:Play()
    tween.Completed:Wait()
    setNoclip(false)
    print("[Tween] Completed")
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
        print("[Error] Map folder not found in workspace")
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
            print("[Teleport Error] Map folder not found")
            return
        end
        local model = mapFolder:FindFirstChild(selectedPlace)
        if not model then
            print("[Teleport Error] Selected model not found:", selectedPlace)
            return
        end
        local part = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChildWhichIsA("BasePart")
        if not part then
            print("[Teleport Error] No usable part in model:", selectedPlace)
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

-- Получить все CFrame сундуков из всех Map.Модель.Chests
local function getAllChestCFrames()
    local cframes = {}
    local mapFolder = workspace:FindFirstChild("Map")
    if not mapFolder then
        print("[AutoChest] Map folder not found!")
        return cframes
    end

    for _, areaModel in ipairs(mapFolder:GetChildren()) do
        if areaModel:IsA("Model") then
            local chestsFolder = areaModel:FindFirstChild("Chests")
            if not chestsFolder then
                print("[AutoChest] No 'Chests' folder in:", areaModel.Name)
                continue
            end
            for _, chest in ipairs(chestsFolder:GetChildren()) do
                if chest:IsA("Model") then
                    local part = chest:FindFirstChild("HumanoidRootPart") or chest:FindFirstChildWhichIsA("BasePart")
                    if part then
                        print("[AutoChest] Found chest:", chest.Name, "in", areaModel.Name)
                        table.insert(cframes, part.CFrame)
                    else
                        print("[AutoChest] Chest has no usable part:", chest.Name)
                    end
                else
                    print("[AutoChest] Non-model inside Chests folder:", chest.Name)
                end
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
            if #chests == 0 then
                print("[AutoChest] No chests found!")
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
