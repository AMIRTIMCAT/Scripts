--========================================
-- Catik Yield GUI (English, global) Improved, no _G
--========================================

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()

local Window = Library:MakeWindow({
    Title = "Catik Yield",
    SubTitle = "By Catik Yield",
    ScriptFolder = "CatikYield-library-V5"
})

local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "Home",
})

MainTab:AddDiscordInvite({
    Title = "Catik Yield | Community",
    Description = "Catik Yield.",
    Banner = "rbxassetid://103624317740952",
    Logo = "rbxassetid://103624317740952",
    Invite = "https://discord.gg/Eg98P4wf2V",
    Members = 1488,
    Online = 1488
})

local PlayerTab = Window:MakeTab({
    Name = "Player",
    Icon = "User",
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local function getCharacterParts()
    local char = LocalPlayer.Character
    if not char then return nil end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    return char, humanoid, root
end

local function applyWalkJump()
    local _, humanoid = getCharacterParts()
    if humanoid then
        humanoid.WalkSpeed = State.WalkSpeed
        humanoid.JumpPower = State.JumpPower
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    wait(0.1)
    applyWalkJump()
    if State.Noclip then
        enableNoclip()
    else
        disableNoclip()
    end
    if State.FlyEnabled then
        enableFly()
    else
        disableFly()
    end
end)

-- WalkSpeed
PlayerTab:AddSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 300,
    Default = State.WalkSpeed,
    Callback = function(value)
        State.WalkSpeed = value
        applyWalkJump()
    end
})

-- JumpPower
PlayerTab:AddSlider({
    Name = "JumpPower",
    Min = 50,
    Max = 300,
    Default = State.JumpPower,
    Callback = function(value)
        State.JumpPower = value
        applyWalkJump()
    end
})

-- Noclip (пример, без глобальных переменных)
local noclipConnection = nil

local function enableNoclip()
    if noclipConnection then return end
    noclipConnection = RunService.Stepped:Connect(function()
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = false
                end
            end
        end
    end)
end

local function disableNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    local char = LocalPlayer.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
    end
end

PlayerTab:AddToggle({
    Name = "Noclip",
    Default = State.Noclip,
    Callback = function(state)
        State.Noclip = state
        if state then
            enableNoclip()
        else
            disableNoclip()
        end
    end
})
