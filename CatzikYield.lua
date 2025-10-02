--========================================
-- Catik Yield GUI (English, global)
--========================================

-- Load UI library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()

-- Global storage table (keeps settings accessible globally)
_G.CatikYield = _G.CatikYield or {}
local G = _G.CatikYield

-- Default global settings (will be preserved across script reload if _G exists)
G.Defaults = G.Defaults or { WalkSpeed = 16, JumpPower = 50, FlySpeed = 100 }
G.State = G.State or { WalkSpeed = G.Defaults.WalkSpeed, JumpPower = G.Defaults.JumpPower, FlyEnabled = false, FlySpeed = G.Defaults.FlySpeed, Noclip = false }

-- Create main window
local Window = Library:MakeWindow({
    Title = "Catik Yield",
    SubTitle = "By Catik Yield",
    ScriptFolder = "CatikYield-library-V5"
})

-- ================= Main Tab (Discord invite) =================
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "Home", -- use library's built-in icon name or asset id
    Color = Color3.fromRGB(255, 100, 100)
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

-- ================= Player Tab =================
local PlayerTab = Window:MakeTab({
    Name = "Player",
    Icon = "User",
    Color = Color3.fromRGB(100, 149, 255)
})

-- Services and locals
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Helpers
local function getCharacterParts()
    local char = LocalPlayer.Character
    if not char then return nil end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    return char, humanoid, root
end

-- Ensure defaults reflect current character if available
local function refreshDefaults()
    local _, humanoid = getCharacterParts()
    if humanoid then
        G.Defaults.WalkSpeed = humanoid.WalkSpeed or G.Defaults.WalkSpeed
        G.Defaults.JumpPower = humanoid.JumpPower or G.Defaults.JumpPower
        -- store current state if not set
        G.State.WalkSpeed = G.State.WalkSpeed or G.Defaults.WalkSpeed
        G.State.JumpPower = G.State.JumpPower or G.Defaults.JumpPower
    end
end

refreshDefaults()

-- Apply state to newly spawned character
LocalPlayer.CharacterAdded:Connect(function(char)
    -- small wait for humanoid
    wait(0.1)
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = G.State.WalkSpeed or G.Defaults.WalkSpeed
        humanoid.JumpPower = G.State.JumpPower or G.Defaults.JumpPower
    end
    -- If noclip was enabled, reapply
    if G.State.Noclip then
        -- will be handled by noclip loop (if running)
    end
end)

-- ---------------- WalkSpeed ----------------
PlayerTab:AddSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 300,
    Default = G.State.WalkSpeed or G.Defaults.WalkSpeed,
    Callback = function(value)
        G.State.WalkSpeed = value
        local _, humanoid = getCharacterParts()
        if humanoid then
            humanoid.WalkSpeed = value
        end
    end
})

PlayerTab:AddButton({
    Name = "Reset WalkSpeed",
    Callback = function()
        G.State.WalkSpeed = G.Defaults.WalkSpeed
        local _, humanoid = getCharacterParts()
        if humanoid then
            humanoid.WalkSpeed = G.Defaults.WalkSpeed
        end
    end
})

-- ---------------- JumpPower ----------------
PlayerTab:AddSlider({
    Name = "JumpPower",
    Min = 50,
    Max = 300,
    Default = G.State.JumpPower or G.Defaults.JumpPower,
    Callback = function(value)
        G.State.JumpPower = value
        local _, humanoid = getCharacterParts()
        if humanoid then
            humanoid.JumpPower = value
        end
    end
})

PlayerTab:AddButton({
    Name = "Reset JumpPower",
    Callback = function()
        G.State.JumpPower = G.Defaults.JumpPower
        local _, humanoid = getCharacterParts()
        if humanoid then
            humanoid.JumpPower = G.Defaults.JumpPower
        end
    end
})

-- ---------------- Noclip ----------------
G.NoclipConnection = G.NoclipConnection or nil
G.State.Noclip = G.State.Noclip or false

local function enableNoclip()
    if G.NoclipConnection then G.NoclipConnection:Disconnect() end
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

-- ---------------- Fly ----------------
-- States and variables
G.State.FlyEnabled = G.State.FlyEnabled or false
G.State.FlySpeed = G.State.FlySpeed or G.Defaults.FlySpeed

local flyBV, flyBG, flyHeartbeat, ascend, descend, moveVector
ascend = false
descend = false
moveVector = Vector3.new(0,0,0)

-- Input handlers for ascend/descend and movement vector
UserInputService.InputBegan:Connect(function(inp, processed)
    if processed then return end
    if inp.KeyCode == Enum.KeyCode.Space then ascend = true end
    if inp.KeyCode == Enum.KeyCode.LeftShift then descend = true end
end)
UserInputService.InputEnded:Connect(function(inp)
    if inp.KeyCode == Enum.KeyCode.Space then ascend = false end
    if inp.KeyCode == Enum.KeyCode.LeftShift then descend = false end
end)

-- Keep track of camera-based movement vector
RunService.RenderStepped:Connect(function()
    if not G.State.FlyEnabled then return end
    local cam = workspace.CurrentCamera
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not cam or not root then
        moveVector = Vector3.new(0,0,0)
        return
    end

    local forward = cam.CFrame.LookVector
    local right = cam.CFrame.RightVector
    local dir = Vector3.new(0,0,0)

    if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + forward end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - forward end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - right end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + right end

    if dir.Magnitude > 0 then
        moveVector = dir.Unit
    else
        moveVector = Vector3.new(0,0,0)
    end
end)

local function enableFly()
    local char, humanoid, root = getCharacterParts()
    if not (char and humanoid and root) then return end

    humanoid.PlatformStand = true

    flyBV = Instance.new("BodyVelocity")
    flyBV.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    flyBV.Velocity = Vector3.new(0,0,0)
    flyBV.P = 1e4
    flyBV.Parent = root

    flyBG = Instance.new("BodyGyro")
    flyBG.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    flyBG.CFrame = root.CFrame
    flyBG.P = 1e4
    flyBG.Parent = root

    if flyHeartbeat then flyHeartbeat:Disconnect() end
    flyHeartbeat = RunService.Heartbeat:Connect(function(dt)
        if not G.State.FlyEnabled then return end
        local vel = Vector3.new(0,0,0)
        vel = vel + (moveVector * G.State.FlySpeed)
        if ascend then
            vel = vel + Vector3.new(0, G.State.FlySpeed, 0)
        elseif descend then
            vel = vel + Vector3.new(0, -G.State.FlySpeed, 0)
        end
        if flyBV and flyBV.Parent then flyBV.Velocity = vel end
        if flyBG and flyBG.Parent then flyBG.CFrame = workspace.CurrentCamera.CFrame end
    end)
end

local function disableFly()
    if flyHeartbeat then flyHeartbeat:Disconnect(); flyHeartbeat = nil end
    if flyBV then flyBV:Destroy(); flyBV = nil end
    if flyBG then flyBG:Destroy(); flyBG = nil end
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

-- ---------------- Reset All ----------------
PlayerTab:AddButton({
    Name = "Reset All (to defaults)",
    Callback = function()
        -- Reset state values
        G.State.WalkSpeed = G.Defaults.WalkSpeed
        G.State.JumpPower = G.Defaults.JumpPower
        G.State.FlySpeed = G.Defaults.FlySpeed
        G.State.FlyEnabled = false
        G.State.Noclip = false

        -- Apply to character
        local _, humanoid = getCharacterParts()
        if humanoid then
            humanoid.WalkSpeed = G.Defaults.WalkSpeed
            humanoid.JumpPower = G.Defaults.JumpPower
            humanoid.PlatformStand = false
        end

        -- Turn off fly and noclip
        disableFly()
        disableNoclip()
    end
})

-- Final safety notes printed to console (not intrusive)
print("[CatikYield] GUI loaded. Main tab: 'Main'. Player tab created with WalkSpeed, JumpPower, Fly, Noclip.")
print("[CatikYield] Controls: WASD for movement in fly, Space to ascend, LeftShift to descend.")

-- End of file
