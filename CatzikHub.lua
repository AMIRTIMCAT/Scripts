local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Загрузка redz-V5-remake (main.luau)
local Library
local success, err = pcall(function()
    Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/main/redz-V5-remake/main.luau"))()
end)
if not success then
    warn("Ошибка загрузки redz-V5-remake/main.luau: " .. (err or "файл недоступен") .. ". Скрипт не работает без библиотеки.")
    return
end
print("redz-V5-remake загружена успешно!")

-- Константы стилей
local STYLE = {
    MAIN_COLOR = Color3.fromRGB(15, 15, 15),
    TEXT_COLOR = Color3.fromRGB(200, 200, 200),
    BUTTON_COLOR = Color3.fromRGB(25, 25, 25)
}

-- Размеры под устройство
local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
local frameSize = isMobile and UDim2.new(0, 300, 0, 250) or UDim2.new(0, 450, 0, 400)

-- Создание окна через библиотеку
local window = Library.new("Catzik Hub", {
    Size = frameSize,
    Theme = {BackgroundColor = STYLE.MAIN_COLOR, TextColor = STYLE.TEXT_COLOR}
})
window.Position = UDim2.new(0.5, -frameSize.X.Offset / 2, 0.5, -frameSize.Y.Offset / 2)
window.Draggable = true

-- Вкладки
local teleportTab = window:tab("Teleport")
local playerTab = window:tab("Player")
local miscTab = window:tab("Miscellaneous")

-- Функции
local noclipConn
local function toggleNoclip(character, enable)
    if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    if enable and character then
        local success, err = pcall(function()
            noclipConn = RunService.Stepped:Connect(function()
                if not character or not character.Parent then return end
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end)
        end)
        if not success then warn("NoClip заблокирован!") end
    end
end

local function flyTo(destinationCFrame)
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not char or not hrp or not destinationCFrame then warn("Ошибка телепортации!") return end
    toggleNoclip(char, true)
    hrp.CFrame = hrp.CFrame + Vector3.new(0, 100, 0)
    local targetAbove = CFrame.new(destinationCFrame.Position + Vector3.new(0, 100, 0), destinationCFrame.Position)
    local distance = (hrp.Position - targetAbove.Position).Magnitude
    local duration = math.max(0.01, distance / 300)
    local tween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetAbove})
    tween:Play()
    tween.Completed:Connect(function()
        local downTween = TweenService:Create(hrp, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {CFrame = destinationCFrame})
        downTween:Play()
        downTween.Completed:Connect(function() toggleNoclip(char, false) end)
    end)
end

local function getCFrameForPlace(name)
    local mapFolder = workspace:FindFirstChild("Map")
    if not mapFolder then warn("Папка 'Map' не найдена!") return end
    local model = mapFolder:FindFirstChild(name)
    if not model then warn("Модель '" .. name .. "' не найдена!") return end
    local hrp = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChildWhichIsA("BasePart")
    if not hrp then warn("Нет HumanoidRootPart!") return end
    return hrp.CFrame
end

local function updatePlayerStats(speed, jump)
    local char = player.Character
    if not char or not char:FindFirstChild("Humanoid") then warn("Персонаж не найден!") return end
    local humanoid = char.Humanoid
    if speed then humanoid.WalkSpeed = math.clamp(speed, 0, 100) end
    if jump then humanoid.JumpPower = math.clamp(jump, 0, 200) end
    if humanoid.WalkSpeed ~= (speed or humanoid.WalkSpeed) or humanoid.JumpPower ~= (jump or humanoid.JumpPower) then
        warn("Изменение заблокировано!")
    end
end

local selectedPlace = nil
local options = {}
local function updateOptions()
    local mapFolder = workspace:FindFirstChild("Map")
    if not mapFolder then return end
    options = {}
    for _, model in ipairs(mapFolder:GetChildren()) do
        if model:IsA("Model") then table.insert(options, model.Name) end
    end
end
updateOptions()

local codes = {
    "LIGHTNINGABUSE", "1LOSTADMIN", "ADMINFIGHT", "NOMOREHACK", "BANEXPLOIT",
    "krazydares", "TRIPLEABUSE", "24NOADMIN", "REWARDFUN", "Chandler",
    "NEWTROLL", "KITT_RESET", "Sub2CaptainMaui", "kittgaming", "Sub2Fer999",
    "Enyu_is_Pro", "Magicbus", "JCWK", "Starcodeheo", "Bluxxy",
    "fudd10_v2", "SUB2GAMERROBOT_EXP1", "Sub2NoobMaster123", "Sub2UncleKizaru",
    "Sub2Daigrock", "Axiore", "TantaiGaming", "StrawHatMaine", "Sub2OfficialNoobie",
    "Fudd10", "Bignews", "TheGreatAce", "SECRET_ADMIN", "SUB2GAMERROBOT_RESET1",
    "SUB2OFFICIALNOOBIE", "AXIORE", "BIGNEWS", "BLUXXY", "CHANDLER", "ENYU_IS_PRO",
    "FUDD10", "FUDD10_V2", "KITTGAMING", "MAGICBUS", "STARCODEHEO", "STRAWHATMAINE",
    "SUB2CAPTAINMAUI", "SUB2DAIGROCK", "SUB2FER999", "SUB2NOOBMASTER123", "SUB2UNCLEKIZARU",
    "TANTAIGAMING", "THEGREATACE"
}

local function redeemAllCodes()
    local successCount = 0
    local virtualInputManager = game:GetService("VirtualInputManager")
    for _, code in ipairs(codes) do
        pcall(function()
            virtualInputManager:SendKeyEvent(true, "T", false, game)
            wait(0.1)
            virtualInputManager:SendText(code)
            wait(0.1)
            virtualInputManager:SendKeyEvent(true, "Enter", false, game)
            wait(0.2)
            successCount = successCount + 1
        end)
    end
    warn("Активировано " .. successCount .. " кодов!")
end

-- Настройка UI через библиотеку
teleportTab:dropdown("Select Place", options, function(value)
    selectedPlace = value
end)
teleportTab:button("Teleport", function()
    if selectedPlace then
        local cf = getCFrameForPlace(selectedPlace)
        if cf then flyTo(cf) end
    end
end)

playerTab:slider("Speed", 16, 100, 16, function(value)
    updatePlayerStats(value, nil)
end)
playerTab:slider("Jump", 50, 200, 50, function(value)
    updatePlayerStats(nil, value)
end)

miscTab:toggle("NoClip", false, function(state)
    toggleNoclip(player.Character, state)
end)
miscTab:toggle("Invisibility", false, function(state)
    local char = player.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Transparency = state and 1 or 0
            end
        end
    end
end)
miscTab:button("Redeem All Codes", redeemAllCodes)
