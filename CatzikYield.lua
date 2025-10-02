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

-- Состояния для всех функций
local State = {
    WalkSpeed = 16,
    JumpPower = 50,
    Noclip = false,
    FlyEnabled = false,
    SpinEnabled = false,
    SpinSpeed = 20,
    XrayEnabled = false,
    WallTpEnabled = false,
    AutoClickEnabled = false,
    HeadSizeTarget = "",
    HeadSizeValue = 1,
    HitboxTarget = "",
    HitboxSize = 1,
    HitboxTransparency = 0.4,
    StareTarget = ""
}

-- Вспомогательные функции из Infinite Yield
local function getRoot(char)
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
end

local function r15(plr)
    if plr.Character then
        local hum = plr.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            return hum.RigType == Enum.HumanoidRigType.R15
        end
    end
    return false
end

local function getPlayer(name, speaker)
    local players = {}
    for _, plr in pairs(Players:GetPlayers()) do
        if string.lower(plr.Name):sub(1, #name) == string.lower(name) then
            table.insert(players, plr.Name)
        end
    end
    return players
end

local function isNumber(str)
    return tonumber(str) ~= nil
end

local function getCharacterParts()
    local char = LocalPlayer.Character
    if not char then return nil end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local root = getRoot(char)
    return char, humanoid, root
end

local function applyWalkJump()
    local _, humanoid = getCharacterParts()
    if humanoid then
        humanoid.WalkSpeed = State.WalkSpeed
        humanoid.JumpPower = State.JumpPower
    end
end

-- Обработчик добавления персонажа
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
    if State.SpinEnabled then
        enableSpin()
    else
        disableSpin()
    end
    if State.XrayEnabled then
        enableXray()
    else
        disableXray()
    end
    if State.WallTpEnabled then
        enableWallTp()
    else
        disableWallTp()
    end
    if State.AutoClickEnabled then
        enableAutoClick()
    else
        disableAutoClick()
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

-- Noclip
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

-- Fly (оставлено без изменений, предполагается, что функция уже реализована)
-- Замените этот блок, если у вас есть конкретная реализация fly
local flyConnection = nil
local function enableFly()
    if flyConnection then return end
    -- Реализация полета (пример, замените на вашу)
    flyConnection = RunService.RenderStepped:Connect(function()
        local char, humanoid, root = getCharacterParts()
        if char and humanoid and root then
            humanoid.PlatformStand = true
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bodyVelocity.Velocity = Vector3.new(0, 50, 0) -- Пример
            bodyVelocity.Parent = root
        end
    end)
end

local function disableFly()
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    local char, humanoid = getCharacterParts()
    if char and humanoid then
        humanoid.PlatformStand = false
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BodyVelocity") then
                v:Destroy()
            end
        end
    end
end

PlayerTab:AddToggle({
    Name = "Fly",
    Default = State.FlyEnabled,
    Callback = function(state)
        State.FlyEnabled = state
        if state then
            enableFly()
        else
            disableFly()
        end
    end
})

-- Spin
local spinConnection = nil
local function enableSpin()
    if spinConnection then return end
    local char, _, root = getCharacterParts()
    if root then
        spinConnection = RunService.RenderStepped:Connect(function()
            local spin = Instance.new("BodyAngularVelocity")
            spin.Name = "Spinning"
            spin.Parent = root
            spin.MaxTorque = Vector3.new(0, math.huge, 0)
            spin.AngularVelocity = Vector3.new(0, State.SpinSpeed, 0)
        end)
    end
end

local function disableSpin()
    if spinConnection then
        spinConnection:Disconnect()
        spinConnection = nil
    end
    local char, _, root = getCharacterParts()
    if root then
        for _, v in pairs(root:GetChildren()) do
            if v.Name == "Spinning" then
                v:Destroy()
            end
        end
    end
end

PlayerTab:AddToggle({
    Name = "Spin",
    Default = State.SpinEnabled,
    Callback = function(state)
        State.SpinEnabled = state
        if state then
            enableSpin()
        else
            disableSpin()
        end
    end
})

PlayerTab:AddSlider({
    Name = "Spin Speed",
    Min = 10,
    Max = 100,
    Default = State.SpinSpeed,
    Callback = function(value)
        State.SpinSpeed = value
        if State.SpinEnabled then
            disableSpin()
            enableSpin()
        end
    end
})

-- Xray
local xrayConnection = nil
local function enableXray()
    if xrayConnection then return end
    xrayConnection = RunService.RenderStepped:Connect(function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v.Parent:FindFirstChildWhichIsA("Humanoid") and not v.Parent.Parent:FindFirstChildWhichIsA("Humanoid") then
                v.LocalTransparencyModifier = 0.5
            end
        end
    end)
end

local function disableXray()
    if xrayConnection then
        xrayConnection:Disconnect()
        xrayConnection = nil
    end
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v.Parent:FindFirstChildWhichIsA("Humanoid") and not v.Parent.Parent:FindFirstChildWhichIsA("Humanoid") then
            v.LocalTransparencyModifier = 0
        end
    end
end

MainTab:AddToggle({
    Name = "Xray",
    Default = State.XrayEnabled,
    Callback = function(state)
        State.XrayEnabled = state
        if state then
            enableXray()
        else
            disableXray()
        end
    end
})

-- WallTp
local walltpConnection = nil
local function enableWallTp()
    if walltpConnection then return end
    local char, humanoid = getCharacterParts()
    local torso = r15(LocalPlayer) and char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    if torso then
        walltpConnection = torso.Touched:Connect(function(hit)
            local root = getRoot(char)
            if hit:IsA("BasePart") and root and humanoid and hit.Position.Y > root.Position.Y - humanoid.HipHeight then
                local hitP = getRoot(hit.Parent)
                if hitP then
                    root.CFrame = hit.CFrame * CFrame.new(root.CFrame.lookVector.X, hitP.Size.Z/2 + humanoid.HipHeight, root.CFrame.lookVector.Z)
                else
                    root.CFrame = hit.CFrame * CFrame.new(root.CFrame.lookVector.X, hit.Size.Y/2 + humanoid.HipHeight, root.CFrame.lookVector.Z)
                end
            end
        end)
    end
end

local function disableWallTp()
    if walltpConnection then
        walltpConnection:Disconnect()
        walltpConnection = nil
    end
end

PlayerTab:AddToggle({
    Name = "Wall Teleport",
    Default = State.WallTpEnabled,
    Callback = function(state)
        State.WallTpEnabled = state
        if state then
            enableWallTp()
        else
            disableWallTp()
        end
    end
})

-- AutoClick
local autoclickConnection = nil
local cancelAutoClick = nil
local function enableAutoClick()
    if autoclickConnection then return end
    if not (mouse1press and mouse1release) then
        Library:Notify("Auto Clicker", "Your exploit doesn't support this feature (missing mouse1press/mouse1release)")
        State.AutoClickEnabled = false
        return
    end
    autoclickConnection = RunService.RenderStepped:Connect(function()
        cancelAutoClick = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
            if not gameProcessedEvent and ((input.KeyCode == Enum.KeyCode.Backspace and UserInputService:IsKeyDown(Enum.KeyCode.Equals)) or (input.KeyCode == Enum.KeyCode.Equals and UserInputService:IsKeyDown(Enum.KeyCode.Backspace))) then
                State.AutoClickEnabled = false
                disableAutoClick()
            end
        end)
        Library:Notify("Auto Clicker", "Press [backspace] and [=] to stop")
        repeat
            mouse1press()
            wait(0.1)
            mouse1release()
            wait(0.1)
        until not State.AutoClickEnabled
    end)
end

local function disableAutoClick()
    if autoclickConnection then
        autoclickConnection:Disconnect()
        autoclickConnection = nil
    end
    if cancelAutoClick then
        cancelAutoClick:Disconnect()
        cancelAutoClick = nil
    end
end

PlayerTab:AddToggle({
    Name = "Auto Click",
    Default = State.AutoClickEnabled,
    Callback = function(state)
        State.AutoClickEnabled = state
        if state then
            enableAutoClick()
        else
            disableAutoClick()
        end
    end
})

-- HeadSize
PlayerTab:AddTextbox({
    Name = "HeadSize Target",
    Default = "",
    PlaceholderText = "Enter player name",
    Callback = function(value)
        State.HeadSizeTarget = value
    end
})

PlayerTab:AddSlider({
    Name = "HeadSize Value",
    Min = 1,
    Max = 10,
    Default = State.HeadSizeValue,
    Callback = function(value)
        State.HeadSizeValue = value
    end
})

PlayerTab:AddButton({
    Name = "Apply HeadSize",
    Callback = function()
        local players = getPlayer(State.HeadSizeTarget, LocalPlayer)
        for _, v in pairs(players) do
            if Players[v] ~= LocalPlayer and Players[v].Character:FindFirstChild("Head") then
                local head = Players[v].Character:FindFirstChild("Head")
                if head:IsA("BasePart") then
                    head.Size = Vector3.new(State.HeadSizeValue, State.HeadSizeValue, State.HeadSizeValue)
                end
            end
        end
    end
})

-- Hitbox
PlayerTab:AddTextbox({
    Name = "Hitbox Target",
    Default = "",
    PlaceholderText = "Enter player name",
    Callback = function(value)
        State.HitboxTarget = value
    end
})

PlayerTab:AddSlider({
    Name = "Hitbox Size",
    Min = 1,
    Max = 10,
    Default = State.HitboxSize,
    Callback = function(value)
        State.HitboxSize = value
    end
})

PlayerTab:AddSlider({
    Name = "Hitbox Transparency",
    Min = 0,
    Max = 1,
    Default = State.HitboxTransparency,
    Callback = function(value)
        State.HitboxTransparency = value
    end
})

PlayerTab:AddButton({
    Name = "Apply Hitbox",
    Callback = function()
        local players = getPlayer(State.HitboxTarget, LocalPlayer)
        for _, v in pairs(players) do
            if Players[v] ~= LocalPlayer and Players[v].Character:FindFirstChild("HumanoidRootPart") then
                local root = Players[v].Character:FindFirstChild("HumanoidRootPart")
                if root:IsA("BasePart") then
                    root.Size = Vector3.new(State.HitboxSize, State.HitboxSize, State.HitboxSize)
                    root.Transparency = State.HitboxTransparency
                end
            end
        end
    end
})

-- StareAt
PlayerTab:AddTextbox({
    Name = "StareAt Target",
    Default = "",
    PlaceholderText = "Enter player name",
    Callback = function(value)
        State.StareTarget = value
    end
})

local stareConnection = nil
local function enableStare()
    if stareConnection then return end
    local players = getPlayer(State.StareTarget, LocalPlayer)
    for _, v in pairs(players) do
        stareConnection = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character and Players[v] and Players[v].Character and Players[v].Character:FindFirstChild("HumanoidRootPart") then
                local chrPos = LocalPlayer.Character.PrimaryPart.Position
                local tPos = Players[v].Character:FindFirstChild("HumanoidRootPart").Position
                local modTPos = Vector3.new(tPos.X, chrPos.Y, tPos.Z)
                local newCF = CFrame.new(chrPos, modTPos)
                LocalPlayer.Character:SetPrimaryPartCFrame(newCF)
            else
                disableStare()
            end
        end)
    end
end

local function disableStare()
    if stareConnection then
        stareConnection:Disconnect()
        stareConnection = nil
    end
end

PlayerTab:AddToggle({
    Name = "StareAt",
    Default = false,
    Callback = function(state)
        if state then
            enableStare()
        else
            disableStare()
        end
    end
})

-- RemoveTerrain
MainTab:AddButton({
    Name = "Remove Terrain",
    Callback = function()
        workspace:FindFirstChildOfClass("Terrain"):Clear()
        Library:Notify("Remove Terrain", "Terrain cleared!")
    end
})

-- ClearNilInstances
MainTab:AddButton({
    Name = "Clear Nil Instances",
    Callback = function()
        if getnilinstances then
            for _, v in pairs(getnilinstances()) do
                v:Destroy()
            end
            Library:Notify("Clear Nil Instances", "Nil instances cleared!")
        else
            Library:Notify("Incompatible Exploit", "Your exploit does not support this command (missing getnilinstances)")
        end
    end
})

-- DestroyHeight
MainTab:AddTextbox({
    Name = "Destroy Height",
    Default = "-500",
    PlaceholderText = "Enter destroy height",
    Callback = function(value)
        if isNumber(value) then
            workspace.FallenPartsDestroyHeight = tonumber(value)
            Library:Notify("Destroy Height", "Set to " .. value)
        else
            Library:Notify("Invalid Input", "Please enter a valid number")
        end
    end
})

-- AntiVoid
local antivoidConnection = nil
local function enableAntiVoid()
    if antivoidConnection then return end
    local orgDestroyHeight = workspace.FallenPartsDestroyHeight
    antivoidConnection = RunService.Stepped:Connect(function()
        local root = getRoot(LocalPlayer.Character)
        if root and root.Position.Y <= orgDestroyHeight + 25 then
            root.Velocity = root.Velocity + Vector3.new(0, 250, 0)
        end
    end)
end

local function disableAntiVoid()
    if antivoidConnection then
        antivoidConnection:Disconnect()
        antivoidConnection = nil
    end
end

MainTab:AddToggle({
    Name = "Anti Void",
    Default = false,
    Callback = function(state)
        if state then
            enableAntiVoid()
            Library:Notify("Anti Void", "Enabled")
        else
            disableAntiVoid()
            Library:Notify("Anti Void", "Disabled")
        end
    end
})

-- FakeOut
MainTab:AddButton({
    Name = "Fake Out",
    Callback = function()
        local root = getRoot(LocalPlayer.Character)
        local oldpos = root.CFrame
        local orgDestroyHeight = workspace.FallenPartsDestroyHeight
        local antivoidWasEnabled = antivoidConnection ~= nil
        if antivoidWasEnabled then
            disableAntiVoid()
        end
        workspace.FallenPartsDestroyHeight = 0/1/0
        root.CFrame = CFrame.new(Vector3.new(0, orgDestroyHeight - 25, 0))
        wait(1)
        root.CFrame = oldpos
        workspace.FallenPartsDestroyHeight = orgDestroyHeight
        if antivoidWasEnabled then
            enableAntiVoid()
        end
        Library:Notify("Fake Out", "Executed!")
    end
})

-- Trip
PlayerTab:AddButton({
    Name = "Trip",
    Callback = function()
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
        local root = getRoot(LocalPlayer.Character)
        if humanoid and root then
            humanoid:ChangeState(Enum.HumanoidStateType.FallingDown)
            root.Velocity = root.CFrame.LookVector * 30
            Library:Notify("Trip", "Tripped!")
        end
    end
})

-- RemoveAds
MainTab:AddButton({
    Name = "Remove Ads",
    Callback = function()
        task.spawn(function()
            while true do
                pcall(function()
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA("PackageLink") then
                            if v.Parent:FindFirstChild("ADpart") or v.Parent:FindFirstChild("AdGuiAdornee") then
                                v.Parent:Destroy()
                            end
                        end
                    end
                end)
                wait()
            end
        end)
        Library:Notify("Remove Ads", "Ad removal started!")
    end
})

-- Scare
PlayerTab:AddTextbox({
    Name = "Scare Target",
    Default = "",
    PlaceholderText = "Enter player name",
    Callback = function(value)
        State.StareTarget = value
    end
})

PlayerTab:AddButton({
    Name = "Scare",
    Callback = function()
        local players = getPlayer(State.StareTarget, LocalPlayer)
        for _, v in pairs(players) do
            local root = getRoot(LocalPlayer.Character)
            local target = Players[v]
            local targetRoot = target and target.Character and getRoot(target.Character)
            if root and targetRoot and target ~= LocalPlayer then
                local oldpos = root.CFrame
                root.CFrame = targetRoot.CFrame + targetRoot.CFrame.lookVector * 2
                root.CFrame = CFrame.new(root.Position, targetRoot.Position)
                wait(0.5)
                root.CFrame = oldpos
                Library:Notify("Scare", "Scared " .. v .. "!")
            end
        end
    end
})

-- AlignmentKeys
local alignmentKeysConnection = nil
local alignmentKeysEmotes = nil
local function enableAlignmentKeys()
    if alignmentKeysConnection then return end
    alignmentKeysEmotes = game:GetService("StarterGui"):GetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu)
    game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, false)
    alignmentKeysConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.Comma then
            workspace.CurrentCamera:PanUnits(-1)
        elseif input.KeyCode == Enum.KeyCode.Period then
            workspace.CurrentCamera:PanUnits(1)
        end
    end)
end

local function disableAlignmentKeys()
    if alignmentKeysConnection then
        alignmentKeysConnection:Disconnect()
        alignmentKeysConnection = nil
    end
    if type(alignmentKeysEmotes) == "boolean" then
        game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, alignmentKeysEmotes)
    end
end

PlayerTab:AddToggle({
    Name = "Alignment Keys",
    Default = false,
    Callback = function(state)
        if state then
            enableAlignmentKeys()
            Library:Notify("Alignment Keys", "Enabled")
        else
            disableAlignmentKeys()
            Library:Notify("Alignment Keys", "Disabled")
        end
    end
})

-- CtrlLock
PlayerTab:AddToggle({
    Name = "Ctrl Lock",
    Default = false,
    Callback = function(state)
        local mouseLockController = LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("CameraModule"):WaitForChild("MouseLockController")
        local boundKeys = mouseLockController:FindFirstChild("BoundKeys")
        if not boundKeys then
            boundKeys = Instance.new("StringValue")
            boundKeys.Name = "BoundKeys"
            boundKeys.Parent = mouseLockController
        end
        boundKeys.Value = state and "LeftControl" or "LeftShift"
        Library:Notify("Ctrl Lock", state and "Enabled" or "Disabled")
    end
})

-- ListenTo
PlayerTab:AddTextbox({
    Name = "ListenTo Target",
    Default = "",
    PlaceholderText = "Enter player name",
    Callback = function(value)
        State.StareTarget = value
    end
})

local listentoConnection = nil
local function enableListenTo()
    if listentoConnection then return end
    local player = Players:FindFirstChild(getPlayer(State.StareTarget, LocalPlayer)[1])
    local root = player and player.Character and getRoot(player.Character)
    if root then
        game:GetService("SoundService"):SetListener(Enum.ListenerType.ObjectPosition, root)
        listentoConnection = player.CharacterAdded:Connect(function()
            repeat wait() until Players[player.Name].Character and getRoot(Players[player.Name].Character)
            game:GetService("SoundService"):SetListener(Enum.ListenerType.ObjectPosition, getRoot(Players[player.Name].Character))
        end)
        Library:Notify("Listen To", "Listening to " .. player.Name)
    end
end

local function disableListenTo()
    if listentoConnection then
        listentoConnection:Disconnect()
        listentoConnection = nil
    end
    game:GetService("SoundService"):SetListener(Enum.ListenerType.Camera)
    Library:Notify("Listen To", "Disabled")
end

PlayerTab:AddToggle({
    Name = "Listen To",
    Default = false,
    Callback = function(state)
        if state then
            enableListenTo()
        else
            disableListenTo()
        end
    end
})

-- Jerk
PlayerTab:AddButton({
    Name = "Jerk",
    Callback = function()
        local humanoid = LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
        local backpack = LocalPlayer:FindFirstChildWhichIsA("Backpack")
        if not humanoid or not backpack then return end
        local tool = Instance.new("Tool")
        tool.Name = "Jerk Off"
        tool.ToolTip = "in the stripped club. straight up \"jorking it\" . and by \"it\" , haha, well. let's justr say. My peanits."
        tool.RequiresHandle = false
        tool.Parent = backpack
        local jorkin = false
        local track = nil
        local function stopTomfoolery()
            jorkin = false
            if track then
                track:Stop()
                track = nil
            end
        end
        tool.Equipped:Connect(function() jorkin = true end)
        tool.Unequipped:Connect(stopTomfoolery)
        humanoid.Died:Connect(stopTomfoolery)
        task.spawn(function()
            while true do
                if not jorkin then wait() continue end
                local isR15 = r15(LocalPlayer)
                if not track then
                    local anim = Instance.new("Animation")
                    anim.AnimationId = not isR15 and "rbxassetid://72042024" or "rbxassetid://698251653"
                    track = humanoid:LoadAnimation(anim)
                end
                track:Play()
                track:AdjustSpeed(isR15 and 0.7 or 0.65)
                track.TimePosition = 0.6
                wait(0.1)
                while track and track.TimePosition < (not isR15 and 0.65 or 0.7) do wait(0.1) end
                if track then
                    track:Stop()
                    track = nil
                end
            end
        end)
        Library:Notify("Jerk", "Jerk tool added!")
    end
})

-- GuiScale
MainTab:AddSlider({
    Name = "Gui Scale",
    Min = 0.4,
    Max = 2,
    Default = 1,
    Callback = function(value)
        -- Предполагается, что библиотека redz-V5-remake поддерживает изменение масштаба
        Library:Notify("Gui Scale", "Set to " .. value .. " (may require manual UI adjustment)")
    end
})

-- UnsuspendVC
MainTab:AddButton({
    Name = "Unsuspend Voice Chat",
    Callback = function()
        local VoiceChatService = game:GetService("VoiceChatService")
        VoiceChatService:joinVoice()
        local onVoiceModerated
        if not onVoiceModerated then
            onVoiceModerated = game:GetService("VoiceChatInternal").LocalPlayerModerated:Connect(function()
                wait(1)
                VoiceChatService:joinVoice()
            end)
        end
        Library:Notify("Unsuspend Voice Chat", "Voice chat unsuspended!")
    end
})

-- FreezeUnanchored
local freezeUaConnection = nil
local frozenParts = {}
local function enableFreezeUa()
    if freezeUaConnection then return end
    local badnames = {
        "Head", "UpperTorso", "LowerTorso", "RightUpperArm", "LeftUpperArm", "RightLowerArm", "LeftLowerArm",
        "RightHand", "LeftHand", "RightUpperLeg", "LeftUpperLeg", "RightLowerLeg", "LeftLowerLeg",
        "RightFoot", "LeftFoot", "Torso", "Right Arm", "Left Arm", "Right Leg", "Left Leg", "HumanoidRootPart"
    }
    local function freezeNoob(v)
        if v:IsA("BasePart") or v:IsA("UnionOperation") and not v.Anchored then
            local isBad = false
            for _, name in pairs(badnames) do
                if v.Name == name then
                    isBad = true
                    break
                end
            end
            if LocalPlayer.Character and v:IsDescendantOf(LocalPlayer.Character) then
                isBad = true
            end
            if not isBad then
                for _, c in pairs(v:GetChildren()) do
                    if c:IsA("BodyPosition") or c:IsA("BodyGyro") then
                        c:Destroy()
                    end
                end
                local bodypos = Instance.new("BodyPosition")
                bodypos.Parent = v
                bodypos.Position = v.Position
                bodypos.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                local bodygyro = Instance.new("BodyGyro")
                bodygyro.Parent = v
                bodygyro.CFrame = v.CFrame
                bodygyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                if not table.find(frozenParts, v) then
                    table.insert(frozenParts, v)
                end
            end
        end
    end
    for _, v in pairs(workspace:GetDescendants()) do
        freezeNoob(v)
    end
    freezeUaConnection = workspace.DescendantAdded:Connect(freezeNoob)
end

local function disableFreezeUa()
    if freezeUaConnection then
        freezeUaConnection:Disconnect()
        freezeUaConnection = nil
    end
    for _, v in pairs(frozenParts) do
        for _, c in pairs(v:GetChildren()) do
            if c:IsA("BodyPosition") or c:IsA("BodyGyro") then
                c:Destroy()
            end
        end
    end
    frozenParts = {}
end

MainTab:AddToggle({
    Name = "Freeze Unanchored",
    Default = false,
    Callback = function(state)
        if state then
            enableFreezeUa()
            Library:Notify("Freeze Unanchored", "Enabled")
        else
            disableFreezeUa()
            Library:Notify("Freeze Unanchored", "Disabled")
        end
    end
})

-- TpUnanchored
MainTab:AddTextbox({
    Name = "Tp Unanchored Target",
    Default = "",
    PlaceholderText = "Enter player name",
    Callback = function(value)
        State.StareTarget = value
    end
})

MainTab:AddButton({
    Name = "Teleport Unanchored",
    Callback = function()
        local players = getPlayer(State.StareTarget, LocalPlayer)
        for _, v in pairs(players) do
            local forces = {}
            for _, part in pairs(workspace:GetDescendants()) do
                if (part:IsA("BasePart") or part:IsA("UnionOperation") or part:IsA("Model")) and not part.Anchored and not part:IsDescendantOf(LocalPlayer.Character) and not table.find({"Torso", "Head", "Right Arm", "Left Arm", "Right Leg", "Left Leg", "HumanoidRootPart"}, part.Name) then
                    for _, c in pairs(part:GetChildren()) do
                        if c:IsA("BodyPosition") or c:IsA("BodyGyro") then
                            c:Destroy()
                        end
                    end
                    local forceInstance = Instance.new("BodyPosition")
                    forceInstance.Parent = part
                    forceInstance.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    table.insert(forces, forceInstance)
                    if not table.find(frozenParts, part) then
                        table.insert(frozenParts, part)
                    end
                end
            end
            for _, c in pairs(forces) do
                c.Position = Players[v].Character.Head.Position
            end
            Library:Notify("Teleport Unanchored", "Teleported unanchored parts to " .. v)
        end
    end
})

-- AutoKeyPress
local keycodeMap = {
    ["0"] = 0x30, ["1"] = 0x31, ["2"] = 0x32, ["3"] = 0x33, ["4"] = 0x34,
    ["5"] = 0x35, ["6"] = 0x36, ["7"] = 0x37, ["8"] = 0x38, ["9"] = 0x39,
    ["a"] = 0x41, ["b"] = 0x42, ["c"] = 0x43, ["d"] = 0x44, ["e"] = 0x45,
    ["f"] = 0x46, ["g"] = 0x47, ["h"] = 0x48, ["i"] = 0x49, ["j"] = 0x4A,
    ["k"] = 0x4B, ["l"] = 0x4C, ["m"] = 0x4D, ["n"] = 0x4E, ["o"] = 0x4F,
    ["p"] = 0x50, ["q"] = 0x51, ["r"] = 0x52, ["s"] = 0x53, ["t"] = 0x54,
    ["u"] = 0x55, ["v"] = 0x56, ["w"] = 0x57, ["x"] = 0x58, ["y"] = 0x59,
    ["z"] = 0x5A, ["enter"] = 0x0D, ["shift"] = 0x10, ["ctrl"] = 0x11,
    ["alt"] = 0x12, ["pause"] = 0x13, ["capslock"] = 0x14, ["spacebar"] = 0x20,
    ["space"] = 0x20, ["pageup"] = 0x21, ["pagedown"] = 0x22, ["end"] = 0x23,
    ["home"] = 0x24, ["left"] = 0x25, ["up"] = 0x26, ["right"] = 0x27,
    ["down"] = 0x28, ["insert"] = 0x2D, ["delete"] = 0x2E, ["f1"] = 0x70,
    ["f2"] = 0x71, ["f3"] = 0x72, ["f4"] = 0x73, ["f5"] = 0x74, ["f6"] = 0x75,
    ["f7"] = 0x76, ["f8"] = 0x77, ["f9"] = 0x78, ["f10"] = 0x79, ["f11"] = 0x7A,
    ["f12"] = 0x7B
}

PlayerTab:AddTextbox({
    Name = "Auto Key Press",
    Default = "",
    PlaceholderText = "Enter key (e.g., space)",
    Callback = function(value)
        State.AutoKeyPress = value
    end
})

PlayerTab:AddToggle({
    Name = "Auto Key Press",
    Default = false,
    Callback = function(state)
        if state then
            if not (keypress and keyrelease) then
                Library:Notify("Auto Key Press", "Your exploit doesn't support this feature (missing keypress/keyrelease)")
                return
            end
            local code = keycodeMap[string.lower(State.AutoKeyPress)]
            if not code then
                Library:Notify("Auto Key Press", "Invalid key")
                return
            end
            task.spawn(function()
                local cancelAutoKeyPress
                cancelAutoKeyPress = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
                    if not gameProcessedEvent and ((input.KeyCode == Enum.KeyCode.Backspace and UserInputService:IsKeyDown(Enum.KeyCode.Equals)) or (input.KeyCode == Enum.KeyCode.Equals and UserInputService:IsKeyDown(Enum.KeyCode.Backspace))) then
                        State.AutoKeyPressEnabled = false
                        if cancelAutoKeyPress then cancelAutoKeyPress:Disconnect() end
                    end
                end)
                Library:Notify("Auto Key Press", "Press [backspace] and [=] to stop")
                while State.AutoKeyPressEnabled do
                    keypress(code)
                    wait(0.1)
                    keyrelease(code)
                    wait(0.1)
                end
            end)
            State.AutoKeyPressEnabled = true
        else
            State.AutoKeyPressEnabled = false
            Library:Notify("Auto Key Press", "Disabled")
        end
    end
})

-- Rolewatch
MainTab:AddTextbox({
    Name = "Rolewatch Group ID",
    Default = "",
    PlaceholderText = "Enter group ID",
    Callback = function(value)
        State.RolewatchGroup = value
    end
})

MainTab:AddTextbox({
    Name = "Rolewatch Role",
    Default = "",
    PlaceholderText = "Enter role name",
    Callback = function(value)
        State.RolewatchRole = value
    end
})

local rolewatchConnection = nil
MainTab:AddToggle({
    Name = "Rolewatch",
    Default = false,
    Callback = function(state)
        if state then
            local groupId = tonumber(State.RolewatchGroup)
            if groupId and State.RolewatchRole then
                rolewatchConnection = Players.PlayerAdded:Connect(function(player)
                    if player:IsInGroup(groupId) and string.lower(player:GetRoleInGroup(groupId)) == string.lower(State.RolewatchRole) then
                        Library:Notify("Rolewatch", "Player \"" .. player.Name .. "\" has joined with the Role \"" .. State.RolewatchRole .. "\"")
                    end
                end)
                Library:Notify("Rolewatch", "Watching Group ID \"" .. groupId .. "\" for Role \"" .. State.RolewatchRole .. "\"")
            else
                Library:Notify("Rolewatch", "Invalid Group ID or Role")
            end
        else
            if rolewatchConnection then
                rolewatchConnection:Disconnect()
                rolewatchConnection = nil
            end
            Library:Notify("Rolewatch", "Disabled")
        end
    end
})

-- Staffwatch
local staffwatchConnection = nil
local staffRoles = {"mod", "admin", "staff", "dev", "founder", "owner", "supervis", "manager", "management", "executive", "president", "chairman", "chairwoman", "chairperson", "director"}
local function getStaffRole(player)
    local playerRole = player:GetRoleInGroup(game.CreatorId)
    local result = {Role = playerRole, Staff = false}
    if player:IsInGroup(1200769) then
        result.Role = "Roblox Employee"
        result.Staff = true
    end
    for _, role in pairs(staffRoles) do
        if string.find(string.lower(playerRole), role) then
            result.Staff = true
        end
    end
    return result
end

MainTab:AddToggle({
    Name = "Staffwatch",
    Default = false,
    Callback = function(state)
        if state then
            if game.CreatorType == Enum.CreatorType.Group then
                local found = {}
                staffwatchConnection = Players.PlayerAdded:Connect(function(player)
                    local result = getStaffRole(player)
                    if result.Staff then
                        Library:Notify("Staffwatch", player.Name .. " is a " .. result.Role)
                    end
                end)
                for _, player in pairs(Players:GetPlayers()) do
                    local result = getStaffRole(player)
                    if result.Staff then
                        table.insert(found, player.Name .. " is a " .. result.Role)
                    end
                end
                if #found > 0 then
                    Library:Notify("Staffwatch", table.concat(found, ",\n"))
                else
                    Library:Notify("Staffwatch", "Enabled")
                end
            else
                Library:Notify("Staffwatch", "Game is not owned by a Group")
            end
        else
            if staffwatchConnection then
                staffwatchConnection:Disconnect()
                staffwatchConnection = nil
            end
            Library:Notify("Staffwatch", "Disabled")
        end
    end
})

-- HoverName
local hoverNameConnection = nil
local nameBox = nil
local nbSelection = nil
local function enableHoverName()
    if hoverNameConnection then return end
    nameBox = Instance.new("TextLabel")
    nameBox.Name = "HoverNameLabel"
    nameBox.Parent = game:GetService("CoreGui")
    nameBox.BackgroundTransparency = 1
    nameBox.Size = UDim2.new(0, 200, 0, 30)
    nameBox.Font = Enum.Font.Code
    nameBox.TextSize = 16
    nameBox.Text = ""
    nameBox.TextColor3 = Color3.new(1, 1, 1)
    nameBox.TextStrokeTransparency = 0
    nameBox.TextXAlignment = Enum.TextXAlignment.Left
    nameBox.ZIndex = 10
    nbSelection = Instance.new("SelectionBox")
    nbSelection.Name = "HoverNameSelection"
    nbSelection.LineThickness = 0.03
    nbSelection.Color3 = Color3.new(1, 1, 1)
    local mouse = LocalPlayer:GetMouse()
    hoverNameConnection = mouse.Move:Connect(function()
        local target = mouse.Target
        local t
        if target then
            local humanoid = target.Parent:FindFirstChildOfClass("Humanoid") or target.Parent.Parent:FindFirstChildOfClass("Humanoid")
            if humanoid then
                t = humanoid.Parent
            end
        end
        if t then
            local x = mouse.X
            local xP = x > 200 and x - 205 or x + 25
            nameBox.TextXAlignment = x > 200 and Enum.TextXAlignment.Right or Enum.TextXAlignment.Left
            nameBox.Position = UDim2.new(0, xP, 0, mouse.Y)
            nameBox.Text = t.Name
            nameBox.Visible = true
            nbSelection.Parent = t
            nbSelection.Adornee = t
        else
            nameBox.Visible = false
            nbSelection.Parent = nil
            nbSelection.Adornee = nil
        end
    end)
end

local function disableHoverName()
    if hoverNameConnection then
        hoverNameConnection:Disconnect()
        hoverNameConnection = nil
    end
    if nameBox then
        nameBox:Destroy()
    end
    if nbSelection then
        nbSelection:Destroy()
    end
end

PlayerTab:AddToggle({
    Name = "Hover Name",
    Default = false,
    Callback = function(state)
        if state then
            enableHoverName()
            Library:Notify("Hover Name", "Enabled")
        else
            disableHoverName()
            Library:Notify("Hover Name", "Disabled")
        end
    end
})
