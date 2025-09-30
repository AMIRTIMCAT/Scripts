local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()

local Window = Library:MakeWindow({
    Title = "Catzik Hub",
    SubTitle = "by Yoshi",
    ScriptFolder = "Catzik-Hub-V5"
})

-- TELEPORT TAB
local TeleportTab = Window:MakeTab({
    Title = "Teleport",
    Icon = "History"
})

local function getCFrameForPlace(name)
    local mapFolder = workspace:FindFirstChild("Map")
    if not mapFolder then
        warn("Папка 'Map' не найдена!")
        return nil
    end
    local model = mapFolder:FindFirstChild(name)
    if not model then
        warn("Модель '" .. name .. "' не найдена!")
        return nil
    end
    local part = nil
    for _, child in ipairs(model:GetChildren()) do
        if child:IsA("BasePart") then
            part = child
            break
        end
    end
    if not part then
        warn("В модели нет BasePart!")
        return nil
    end
    return part.CFrame
end

local teleportOptions = {}
local function updateTeleportOptions()
    local mapFolder = workspace:FindFirstChild("Map")
    if not mapFolder then return end
    teleportOptions = {}
    for _, model in ipairs(mapFolder:GetChildren()) do
        if model:IsA("Model") then
            table.insert(teleportOptions, model.Name)
        end
    end
end
updateTeleportOptions()

local selectedTeleport = nil

TeleportTab:AddDropdown({
    Name = "Select Location",
    Options = teleportOptions,
    Default = teleportOptions[1],
    Callback = function(value)
        selectedTeleport = value
    end
})

TeleportTab:AddButton({
    Name = "Teleport",
    Callback = function()
        if not selectedTeleport then
            print("Не выбрано место для телепорта.")
            return
        end
        local cframe = getCFrameForPlace(selectedTeleport)
        if not cframe then
            print("Невозможно телепортироваться — не найден CFrame.")
            return
        end

        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then
            warn("Нет HumanoidRootPart у персонажа!")
            return
        end

        local TweenService = game:GetService("TweenService")
        local targetCFrame = cframe * CFrame.new(0, 80, 0)
        local tweenInfo = TweenInfo.new((hrp.Position - targetCFrame.Position).Magnitude / 300, Enum.EasingStyle.Linear)

        local noclipConnection
        local function noclip()
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
        noclip()
        noclipConnection = game:GetService("RunService").Stepped:Connect(noclip)

        local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
        tween:Play()
        tween.Completed:Wait()

        if noclipConnection then noclipConnection:Disconnect() end
        wait(1)
        print("Телепорт завершён!")
    end
})

-- FARM TAB
local FarmTab = Window:MakeTab({
    Title = "Farm",
    Icon = "Home"
})

local autoChest = false
local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

FarmTab:AddToggle({
    Name = "Auto Chest Tween [BETA]",
    Default = false,
    Callback = function(value)
        autoChest = value
        if autoChest then
            spawn(function()
                while autoChest do
                    local chestFolder = workspace:FindFirstChild("ChestModels")
                    if not chestFolder then
                        print("Папка ChestModels не найдена")
                        break
                    end

                    local chests = chestFolder:GetChildren()
                    for _, chest in ipairs(chests) do
                        if not autoChest then break end
                        if chest:IsA("Model") then
                            local basePart = nil
                            for _, part in ipairs(chest:GetChildren()) do
                                if part:IsA("BasePart") then
                                    basePart = part
                                    break
                                end
                            end

                            if basePart then
                                local noclipConnection
                                local function noclip()
                                    for _, part in pairs(char:GetChildren()) do
                                        if part:IsA("BasePart") then
                                            part.CanCollide = false
                                        end
                                    end
                                end
                                noclip()
                                noclipConnection = game:GetService("RunService").Stepped:Connect(noclip)

                                local targetCFrame = basePart.CFrame * CFrame.new(0, 5, 0)
                                local tweenInfo = TweenInfo.new((hrp.Position - targetCFrame.Position).Magnitude / 300, Enum.EasingStyle.Linear)
                                local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})

                                tween:Play()
                                tween.Completed:Wait()

                                if noclipConnection then noclipConnection:Disconnect() end
                                wait(2)
                            else
                                print("В сундуке нет BasePart:", chest.Name)
                            end
                        end
                    end

                    wait(10)
                end
            end)
        end
    end
})

-- FRUIT TAB
local FruitTab = Window:MakeTab({
    Title = "Fruit",
    Icon = "Cherry"
})

local autoCollectFruit = false

local fruitNames = {
    "Rocket Fruit", "Spin Fruit", "Chop Fruit", "Spike Fruit", "Kilo Fruit", "Smoke Fruit",
    "Spring Fruit", "Sand Fruit", "Ice Fruit", "Flame Fruit", "Barrier Fruit", "Bomb Fruit",
    "Falcon Fruit", "Rubber Fruit", "Love Fruit", "Light Fruit", "Dark Fruit", "Quake Fruit",
    "Paw Fruit", "Diamond Fruit", "Buddha Fruit", "Magma Fruit", "Quake Fruit", "Buddha Fruit",
    "Door Fruit", "Rift Fruit", "Gravity Fruit", "Soul Fruit", "TRex Fruit", "Kitsune Fruit",
    "Sound Fruit", "Mammoth Fruit", "Eagle Fruit", "Creation Fruit", "Yeti Fruit",
    "West Dragon Fruit", "East Dragon Fruit", "Spirit Fruit", "Gas Fruit", "Pain Fruit",
    "Lightning Fruit", "Blizzard Fruit", "Control Fruit", "Venom Fruit", "Dragon Fruit",
    "Leopard Fruit", "Shadow Fruit"
}

FruitTab:AddToggle({
    Name = "Auto Collect Fruit",
    Default = false,
    Callback = function(value)
        autoCollectFruit = value
        if autoCollectFruit then
            spawn(function()
                local player = game.Players.LocalPlayer
                local char = player.Character or player.CharacterAdded:Wait()
                local hrp = char:WaitForChild("HumanoidRootPart")
                local TweenService = game:GetService("TweenService")
                local fruitFolder = workspace:FindFirstChild("Fruit")

                while autoCollectFruit do
                    if not fruitFolder then
                        print("Папка Fruit не найдена")
                        break
                    end

                    for _, fruitName in ipairs(fruitNames) do
                        if not autoCollectFruit then break end
                        local fruit = fruitFolder:FindFirstChild(fruitName)
                        if fruit and fruit:IsA("Model") then
                            local basePart = nil
                            for _, part in ipairs(fruit:GetChildren()) do
                                if part:IsA("BasePart") then
                                    basePart = part
                                    break
                                end
                            end
                            if basePart then
                                local noclipConnection
                                local function noclip()
                                    for _, part in pairs(char:GetChildren()) do
                                        if part:IsA("BasePart") then
                                            part.CanCollide = false
                                        end
                                    end
                                end
                                noclip()
                                noclipConnection = game:GetService("RunService").Stepped:Connect(noclip)

                                local targetCFrame = basePart.CFrame * CFrame.new(0, 5, 0)
                                local tweenInfo = TweenInfo.new((hrp.Position - targetCFrame.Position).Magnitude / 300, Enum.EasingStyle.Linear)
                                local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})

                                tween:Play()
                                tween.Completed:Wait()

                                if noclipConnection then noclipConnection:Disconnect() end
                                wait(2)
                            else
                                print("Нет BasePart у фрукта:", fruitName)
                            end
                        end
                    end
                    wait(10)
                end
            end)
        end
    end
})

-- VISUAL TAB
local VisualTab = Window:MakeTab({
    Title = "Visual",
    Icon = "Eye"
})

local espEnabled = false
local espObjects = {}

local function createESP(player)
    if player == game.Players.LocalPlayer then return end
    if espObjects[player] then return end

    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP_Billboard"
        billboard.Size = UDim2.new(0, 200, 0, 60)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Adornee = char:FindFirstChild("HumanoidRootPart")

        -- Имя игрока
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 0.33, 0)
        nameLabel.Position = UDim2.new(0, 0, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextScaled = true
        nameLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
        nameLabel.Font = Enum.Font.SourceSansBold
        nameLabel.Text = player.Name
        nameLabel.Parent = billboard

        -- HP
        local hpLabel = Instance.new("TextLabel")
        hpLabel.Size = UDim2.new(1, 0, 0.33, 0)
        hpLabel.Position = UDim2.new(0, 0, 0.33, 0)
        hpLabel.BackgroundTransparency = 1
        hpLabel.TextScaled = true
        hpLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        hpLabel.Font = Enum.Font.SourceSans
        hpLabel.Text = "HP: ???"
        hpLabel.Name = "HPLabel"
        hpLabel.Parent = billboard

        -- Distance
        local distLabel = Instance.new("TextLabel")
        distLabel.Size = UDim2.new(1, 0, 0.33, 0)
        distLabel.Position = UDim2.new(0, 0, 0.66, 0)
        distLabel.BackgroundTransparency = 1
        distLabel.TextScaled = true
        distLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        distLabel.Font = Enum.Font.SourceSans
        distLabel.Text = "Distance: ???"
        distLabel.Name = "DistLabel"
        distLabel.Parent = billboard

        billboard.Parent = game.CoreGui
        espObjects[player] = billboard
    end
end

local function removeESP(player)
    if espObjects[player] then
        espObjects[player]:Destroy()
        espObjects[player] = nil
    end
end

local function updateESP()
    while espEnabled do
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                if not espObjects[player] then
                    createESP(player)
                end

                local char = player.Character
                local rootPart = char:FindFirstChild("HumanoidRootPart")
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                local billboard = espObjects[player]

                if billboard and rootPart then
                    local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude

                    local hpLabel = billboard:FindFirstChild("HPLabel")
                    if hpLabel and humanoid then
                        hpLabel.Text = "HP: " .. math.floor(humanoid.Health)
                    end

                    local distLabel = billboard:FindFirstChild("DistLabel")
                    if distLabel then
                        distLabel.Text = "Distance: " .. math.floor(distance) .. "m"
                    end

                    billboard.Adornee = rootPart
                end
            else
                removeESP(player)
            end
        end
        task.wait(0.5)
    end
end

VisualTab:AddToggle({
    Name = "ESP Players (Name, HP, Distance)",
    Default = false,
    Callback = function(value)
        espEnabled = value
        if espEnabled then
            updateESP()
        else
            for _, esp in pairs(espObjects) do
                if esp then esp:Destroy() end
            end
            espObjects = {}
        end
    end
})

-- HOME TAB (для UI Scale)
local HomeTab = Window:MakeTab({
    Title = "Home",
    Icon = "Home"
})

local uiScaleEnabled = false
local uiScaleValue = 1.0

Library:SetUIScale(uiScaleValue)

HomeTab:AddToggle({
    Name = "Enable UI Scale",
    Default = false,
    Callback = function(value)
        uiScaleEnabled = value
        if uiScaleEnabled then
            Library:SetUIScale(uiScaleValue)
        else
            Library:SetUIScale(1.0)
        end
    end
})

HomeTab:AddSlider({
    Name = "UI Scale",
    Min = 0.6,
    Max = 1.6,
    Default = 1.0,
    Increment = 0.05,
    Callback = function(value)
        uiScaleValue = value
        if uiScaleEnabled then
            Library:SetUIScale(uiScaleValue)
        end
    end
})

print(string.format("UI Max Scale is: %s and the minimum is: %s", Library:GetMaxScale(), Library:GetMinScale()))

return Window
