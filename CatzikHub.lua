```lua
-- Rayfield Interface Suite Load
local Rayfield = loadstring(game:GetService("HttpService"):GetAsync("https://sirius.menu/rayfield"))()

-- Catzik Hub Window Creation
local Window = Rayfield:CreateWindow({
   Name = "Catzik Hub | Blox Fruits",
   LoadingTitle = "Catzik Hub Interface",
   LoadingSubtitle = "by Colin (Hacked Edition)",
   ConfigurationSaving = {Enabled = true, FolderName = "CatzikHub", FileName = "CatzikConfig"},
   Discord = {Enabled = false, Invite = "noinvitelink", RememberJoins = true},
   KeySystem = false
})

-- Main Tabs
local FarmTab = Window:CreateTab("Auto Farm", 4483362458)
local TeleportTab = Window:CreateTab("Teleports", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)

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
FarmTab:CreateToggle({
   Name = "Auto Farm Level", CurrentValue = true, Flag = "AutoFarmLevel",
   Callback = function(Value) Settings.AutoFarm = Value end,
})
FarmTab:CreateToggle({
   Name = "Auto Farm Boss", CurrentValue = true, Flag = "AutoFarmBoss",
   Callback = function(Value) Settings.AutoFarm = Value end,
})
FarmTab:CreateToggle({
   Name = "Auto Raid Farm", CurrentValue = true, Flag = "AutoRaidFarm",
   Callback = function(Value) Settings.RaidFarm = Value end,
})

-- Misc Toggles
MiscTab:CreateToggle({
   Name = "Fruit Finder", CurrentValue = true, Flag = "FruitFinder",
   Callback = function(Value) Settings.FruitFinder = Value end,
})

-- Teleport Buttons
local TeleportSection = TeleportTab:CreateSection("Quick Teleports")
TeleportTab:CreateButton({Name = "Spawn", Callback = function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0) end})
TeleportTab:CreateButton({Name = "Boss Area", Callback = function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(200, 50, 200) end})

-- Core Functions
local function AutoFarmLevel()
    if Settings.AutoFarm and Rayfield.Library.Flags.AutoFarmLevel then
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
    if Settings.AutoFarm and Rayfield.Library.Flags.AutoFarmBoss then
        for _, boss in pairs(Workspace.Enemies:GetChildren()) do
            if boss.Name:match("Boss") and boss:FindFirstChild("Humanoid") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = boss.HumanoidRootPart.CFrame
                game:GetService("VirtualUser"):Click()
            end
        end
    end
end

local function AutoFarmRaid()
    if Settings.RaidFarm and Rayfield.Library.Flags.AutoRaidFarm then
        ReplicatedStorage.Remotes.CommF_:InvokeServer("Raid", "Start")
        wait(2)
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Workspace.Raid.Position)
    end
end

local function FruitFinder()
    if Settings.FruitFinder and Rayfield.Library.Flags.FruitFinder then
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
