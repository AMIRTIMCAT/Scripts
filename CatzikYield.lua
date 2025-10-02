--========================================
-- Catik Yield GUI (English, global) Improved
--========================================

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()

_G.CatikYield = _G.CatikYield or {}
local G = _G.CatikYield

G.Defaults = G.Defaults or { WalkSpeed = 16, JumpPower = 50, FlySpeed = 100 }
G.State = G.State or { WalkSpeed = G.Defaults.WalkSpeed, JumpPower = G.Defaults.JumpPower, FlyEnabled = false, FlySpeed = G.Defaults.FlySpeed, Noclip = false }

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
    Banner = "rbxassetid://74299525344625",
    Logo = "rbxassetid://74299525344625",
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
        humanoid.WalkSpeed = G.State.WalkSpeed
        humanoid.JumpPower = G.State.JumpPower
    end
end

-- При появлении персонажа применяем значения из состояния
LocalPlayer.CharacterAdded:Connect(function()
    wait(0.1)
    applyWalkJump()
    if G.State.Noclip then
        enableNoclip()
    else
        disableNoclip()
    end
    if G.State.FlyEnabled then
        enableFly()
    else
        disableFly()
    end
end)

-- ============ WalkSpeed ============
PlayerTab:AddSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 300,
    Default = G.State.WalkSpeed,
    Callback = function(value)
        G.State.WalkSpeed = value
        applyWalkJump()
    end
})

-- ============ JumpPower ============
PlayerTab:AddSlider({
    Name = "JumpPower",
    Min = 50,
    Max = 300,
    Default = G.State.JumpPower,
    Callback = function(value)
        G.State.JumpPower = value
        applyWalkJump()
    end
})

-- ============ Noclip ============
G.NoclipConnection = nil

local function enableNoclip()
    if G.NoclipConnection then return end
    G.NoclipConnection = RunService.Stepped:Connect(function()
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
    if G.NoclipConnection then
        G.NoclipConnection:Disconnect()
        G.NoclipConnection = nil
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
    Default = G.State.Noclip,
    Callback = function(state)
        G.State.Noclip = state
        if state then
            enableNoclip()
        else
            disableNoclip()
        end
    end
})

-- ============ Fly ============
G.State.FlyEnabled = G.State.FlyEnabled or false
G.State.FlySpeed = G.State.FlySpeed or G.Defaults.FlySpeed

local flyBV, flyBG, flyHeartbeat
local ascend, descend = false, false
local moveVector = Vector3.new()

UserInputService.InputBegan:Connect(function(inp, processed)
    if processed then return end
    if inp.KeyCode == Enum.KeyCode.Space then ascend = true end
    if inp.KeyCode == Enum.KeyCode.LeftShift then descend = true end
end)
UserInputService.InputEnded:Connect(function(inp)
    if inp.KeyCode == Enum.KeyCode.Space then ascend = false end
    if inp.KeyCode == Enum.KeyCode.LeftShift then descend = false end
end)

RunService.RenderStepped:Connect(function()
    if not G.State.FlyEnabled then
        moveVector = Vector3.new()
        return
    end
    local cam = workspace.CurrentCamera
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not cam or not root then
        moveVector = Vector3.new()
        return
    end

    local forward = cam.CFrame.LookVector
    local right = cam.CFrame.RightVector
    local dir = Vector3.new()

    if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += forward end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= forward end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= right end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += right end

    moveVector = dir.Magnitude > 0 and dir.Unit or Vector3.new()
end)

local function enableFly()
    local char, humanoid, root = getCharacterParts()
    if not (char and humanoid and root) then return end

    humanoid.PlatformStand = true

    if flyBV then flyBV:Destroy() end
    flyBV = Instance.new("BodyVelocity")
    flyBV.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    flyBV.Velocity = Vector3.new()
    flyBV.P = 1e4
    flyBV.Parent = root

    if flyBG then flyBG:Destroy() end
    flyBG = Instance.new("BodyGyro")
    flyBG.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    flyBG.CFrame = root.CFrame
    flyBG.P = 1e4
    flyBG.Parent = root

    if flyHeartbeat then flyHeartbeat:Disconnect() end
    flyHeartbeat = RunService.Heartbeat:Connect(function()
        if not G.State.FlyEnabled then return end
        local vel = moveVector * G.State.FlySpeed
        if ascend then vel += Vector3.new(0, G.State.FlySpeed, 0) end
        if descend then vel -= Vector3.new(0, G.State.FlySpeed, 0) end

        if flyBV and flyBV.Parent then flyBV.Velocity = vel end
        if flyBG and flyBG.Parent then flyBG.CFrame = workspace.CurrentCamera.CFrame end
    end)
end

local function disableFly()
    if flyHeartbeat then
        flyHeartbeat:Disconnect()
        flyHeartbeat = nil
    end
    if flyBV then
        flyBV:Destroy()
        flyBV = nil
    end
    if flyBG then
        flyBG:Destroy()
        flyBG = nil
    end
    local _, humanoid = getCharacterParts()
    if humanoid then humanoid.PlatformStand = false end
end

PlayerTab:AddToggle({
    Name = "Fly",
    Default = G.State.FlyEnabled,
    Callback = function(state)
        G.State.FlyEnabled = state
        if state then
            enableFly()
        else
            disableFly()
        end
    end
})

PlayerTab:AddSlider({
    Name = "Fly Speed",
    Min = 20,
    Max = 500,
    Default = G.State.FlySpeed,
    Callback = function(val)
        G.State.FlySpeed = val
    end
})

print("[CatikYield] GUI loaded with improved Noclip and without reset buttons.")
print("[CatikYield] Controls: WASD for fly movement, Space to ascend, LeftShift to descend.")
