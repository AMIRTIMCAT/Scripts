```lua
-- Load Fluent Library
local HttpService = game:GetService("HttpService")
local Fluent = loadstring(HttpService:GetAsync("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Example.lua"))()

-- Catzik Hub Window Creation
local Window = Fluent:CreateWindow({
    Title = "Catzik Hub | Blox Fruits",
    SubTitle = "by Colin (Hacked Edition)",
    TabWidth = 160,
    Image = "rbxassetid://0",
    AcceptKey = Enum.KeyCode.RightControl
})

-- [Rest of the script remains the same as previous version]
```

-- Main Tabs
local FarmTab = Window:AddTab({Title = "Auto Farm", Image = "rbxassetid://0"})
local TeleportTab = Window:AddTab({Title = "Teleports", Image = "rbxassetid://0"})
local MiscTab = Window:AddTab({Title = "Misc", Image = "rbxassetid://0"})

-- Settings
local Settings = {
    JoinTeam = "Pirates",
    AutoFarm = true,
    AutoStats = true,
    FruitFinder = true,
    RaidFarm = true,
    Teleports = true,
    EventFarm = {Sea = true, Volcano = true, Kitsune = true}
}

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Team Join
local function JoinTeam(team)
    ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", team)
end
if Settings.JoinTeam then JoinTeam(Settings.JoinTeam) end

-- Farm Toggles
FarmTab:AddToggle("Auto Farm Level", Settings.AutoFarm, function(Value)
    Settings.AutoFarm = Value
end)
FarmTab:AddToggle("Auto Farm Boss", Settings.AutoFarm, function(Value)
    Settings.AutoFarm = Value
end)
FarmTab:AddToggle("Auto Raid Farm", Settings.RaidFarm, function(Value)
    Settings.RaidFarm = Value
end)

-- Misc Toggles
MiscTab:AddToggle("Fruit Finder", Settings.FruitFinder, function(Value)
    Settings.FruitFinder = Value
end)

-- Teleport Buttons
TeleportTab:AddButton("Teleport to Spawn", function()
    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
end)
TeleportTab:AddButton("Teleport to Boss Area", function()
    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(200, 50, 200)
end)

-- Core Functions
local function AutoFarmLevel()
    if Settings.AutoFarm then
        local quest = Workspace.NPCs:FindFirstChild("QuestGiver")
        if quest then
            LocalPlayer.Character.HumanoidRootPart.CFrame = quest.HumanoidRootPart.CFrame
            ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest")
            for _, mob in pairs(Workspace.Enemies:GetChildren()) do
                if mob:IsA("Model") and mob:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame
                    game:GetService("VirtualUser"):Click()
                end
            end
        end
    end
end

local function AutoFarmBoss()
    if Settings.AutoFarm then
        for _, boss in pairs(Workspace.Enemies:GetChildren()) do
            if boss.Name:match("Boss") and boss:FindFirstChild("Humanoid") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = boss.HumanoidRootPart.CFrame
                game:GetService("VirtualUser"):Click()
            end
        end
    end
end

local function AutoFarmRaid()
    if Settings.RaidFarm then
        ReplicatedStorage.Remotes.CommF_:InvokeServer("Raid", "Start")
        wait(2)
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Workspace.Raid.Position)
    end
end

local function FruitFinder()
    if Settings.FruitFinder then
        for _, fruit in pairs(Workspace:GetChildren()) do
            if fruit.Name:match("Fruit") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = fruit.CFrame
                game:GetService("VirtualUser"):CaptureController()
                wait(0.5)
            end
        end
    end
end

local function AutoStats()
    if Settings.AutoStats then
        local stats = {"Melee", "Defense", "Sword", "Fruit"}
        for _, stat in pairs(stats) do
            ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", stat, 1)
        end
    end
end

local function EventFarm(event)
    if Settings.EventFarm[event] then
        LocalPlayer.Character.HumanoidRootPart.CFrame = Workspace[event].Position
        ReplicatedStorage.Remotes.CommF_:InvokeServer("Event", "Start")
    end
end

-- Main Loop
while wait(0.1) do
    AutoFarmLevel()
    AutoFarmBoss()
    AutoFarmRaid()
    FruitFinder()
    AutoStats()
    if Settings.EventFarm.Sea then EventFarm("Sea") end
    if Settings.EventFarm.Volcano then EventFarm("Volcano") end
    if Settings.EventFarm.Kitsune then EventFarm("Kitsune") end
end
