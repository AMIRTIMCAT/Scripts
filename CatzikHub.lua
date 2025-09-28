local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local codesList = {
    ["LIGHTNINGABUSE"]=true, ["1LOSTADMIN"]=true, ["ADMINFIGHT"]=true, ["NOMOREHACK"]=true, ["BANEXPLOIT"]=true,
    ["krazydares"]=true, ["TRIPLEABUSE"]=true, ["24NOADMIN"]=true, ["REWARDFUN"]=true, ["Chandler"]=true,
    ["NEWTROLL"]=true, ["KITT_RESET"]=true, ["Sub2CaptainMaui"]=true, ["kittgaming"]=true, ["Sub2Fer999"]=true,
    ["Enyu_is_Pro"]=true, ["Magicbus"]=true, ["JCWK"]=true, ["Starcodeheo"]=true, ["Bluxxy"]=true,
    ["fudd10_v2"]=true, ["SUB2GAMERROBOT_EXP1"]=true, ["Sub2NoobMaster123"]=true, ["Sub2UncleKizaru"]=true,
    ["Sub2Daigrock"]=true, ["Axiore"]=true, ["TantaiGaming"]=true, ["StrawHatMaine"]=true, ["Sub2OfficialNoobie"]=true,
    ["Fudd10"]=true, ["Bignews"]=true, ["TheGreatAce"]=true, ["SECRET_ADMIN"]=true, ["SUB2GAMERROBOT_RESET1"]=true,
    ["SUB2OFFICIALNOOBIE"]=true, ["AXIORE"]=true, ["BIGNEWS"]=true, ["BLUXXY"]=true, ["CHANDLER"]=true,
    ["ENYU_IS_PRO"]=true, ["FUDD10"]=true, ["FUDD10_V2"]=true, ["KITTGAMING"]=true, ["MAGICBUS"]=true,
    ["STARCODEHEO"]=true, ["STRAWHATMAINE"]=true, ["SUB2CAPTAINMAUI"]=true, ["SUB2DAIGROCK"]=true,
    ["SUB2FER999"]=true, ["SUB2NOOBMASTER123"]=true, ["SUB2UNCLEKIZARU"]=true, ["TANTAIGAMING"]=true, ["THEGREATACE"]=true
}

-- Создаем ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CatzikHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Основной фрейм
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 450, 0, 400)
mainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 45)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
local corner = Instance.new("UICorner", mainFrame)
corner.CornerRadius = UDim.new(0, 10)

-- Тени
local shadow = Instance.new("Frame")
shadow.Size = mainFrame.Size + UDim2.new(0, 10, 0, 10)
shadow.Position = mainFrame.Position + UDim2.new(0, 5, 0, 5)
shadow.BackgroundColor3 = Color3.new(0, 0, 0)
shadow.BackgroundTransparency = 0.8
shadow.ZIndex = 0
shadow.Parent = screenGui
local shadowCorner = Instance.new("UICorner", shadow)
shadowCorner.CornerRadius = UDim.new(0, 12)

mainFrame:GetPropertyChangedSignal("Position"):Connect(function()
    shadow.Position = mainFrame.Position + UDim2.new(0, 5, 0, 5)
end)

-- Заголовок
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Catzik Hub"
title.TextColor3 = Color3.fromRGB(100, 170, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.Position = UDim2.new(0, 15, 0, 7)
title.TextXAlignment = Enum.TextXAlignment.Left

-- Кнопки табов
local tabsFrame = Instance.new("Frame", mainFrame)
tabsFrame.Size = UDim2.new(1, -20, 0, 40)
tabsFrame.Position = UDim2.new(0, 10, 0, 50)
tabsFrame.BackgroundTransparency = 1

local tabButtons = {}
local tabPages = {}

local tabNames = {"Teleport", "AutoFarm", "Miscellaneous"}

local function createTab(name, index)
    local btn = Instance.new("TextButton", tabsFrame)
    btn.Size = UDim2.new(0, 140, 1, 0)
    btn.Position = UDim2.new(0, (index - 1) * 145, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30, 40, 70)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.fromRGB(150, 200, 255)
    btn.TextSize = 18
    btn.AutoButtonColor = false
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 6)

    local page = Instance.new("Frame", mainFrame)
    page.Size = UDim2.new(1, -20, 1, -110)
    page.Position = UDim2.new(0, 10, 0, 100)
    page.BackgroundTransparency = 1
    page.Visible = false

    tabButtons[name] = btn
    tabPages[name] = page

    btn.MouseButton1Click:Connect(function()
        for tn, tb in pairs(tabButtons) do
            tb.BackgroundColor3 = Color3.fromRGB(30, 40, 70)
            tb.TextColor3 = Color3.fromRGB(150, 200, 255)
            tabPages[tn].Visible = false
        end
        btn.BackgroundColor3 = Color3.fromRGB(60, 100, 220)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        page.Visible = true
    end)

    return page
end

-- Создаем вкладки
for i, name in ipairs(tabNames) do
    createTab(name, i)
end

-- Автоматически выбираем первую вкладку
tabButtons["Teleport"].MouseButton1Click:Wait()

-- --- Контент вкладки Teleport ---

local teleportPage = tabPages["Teleport"]

local dropDown = Instance.new("TextButton", teleportPage)
dropDown.Size = UDim2.new(0, 260, 0, 40)
dropDown.Position = UDim2.new(0, 20, 0, 20)
dropDown.BackgroundColor3 = Color3.fromRGB(40, 55, 90)
dropDown.TextColor3 = Color3.fromRGB(220, 220, 255)
dropDown.Text = "Выбрать место ▼"
dropDown.Font = Enum.Font.Gotham
dropDown.TextSize = 16
Instance.new("UICorner", dropDown)
dropDown.ZIndex = 10

local optionsFrame = Instance.new("Frame", teleportPage)
optionsFrame.Size = UDim2.new(0, 260, 0, 0)
optionsFrame.Position = UDim2.new(0, 20, 0, 60)
optionsFrame.BackgroundColor3 = Color3.fromRGB(25, 35, 65)
optionsFrame.ClipsDescendants = true
optionsFrame.Visible = false
Instance.new("UICorner", optionsFrame)
optionsFrame.ZIndex = 11

local tpButton = Instance.new("TextButton", teleportPage)
tpButton.Size = UDim2.new(0, 260, 0, 44)
tpButton.Position = UDim2.new(0, 20, 0, 120)
tpButton.BackgroundColor3 = Color3.fromRGB(70, 110, 210)
tpButton.Text = "Телепортироваться"
tpButton.TextColor3 = Color3.fromRGB(230, 230, 255)
tpButton.Font = Enum.Font.GothamBold
tpButton.TextSize = 18
Instance.new("UICorner", tpButton)
tpButton.ZIndex = 10

local options = {
    "Colosseum", "Desert", "Fountain", "Jungle", "Magma",
    "MarineStart", "Pirate", "Prison", "Sky", "SkyArea1", "SkyArea2"
}
local selectedPlace = nil

for i, name in ipairs(options) do
    local btn = Instance.new("TextButton", optionsFrame)
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.Position = UDim2.new(0, 0, 0, (i-1)*34)
    btn.BackgroundColor3 = Color3.fromRGB(45, 55, 90)
    btn.TextColor3 = Color3.fromRGB(220, 220, 255)
    btn.Text = name
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    Instance.new("UICorner", btn)
    btn.ZIndex = 12

    btn.MouseButton1Click:Connect(function()
        selectedPlace = name
        dropDown.Text = name .. " ▼"
        optionsFrame.Visible = false
        optionsFrame.Size = UDim2.new(0, 260, 0, 0)
    end)
end

dropDown.MouseButton1Click:Connect(function()
    optionsFrame.Visible = not optionsFrame.Visible
    optionsFrame.Size = UDim2.new(0, 260, 0, optionsFrame.Visible and (#options * 34) or 0)
end)

local noclipConn
local function enableNoclip(character)
    if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    noclipConn = RunService.Stepped:Connect(function()
        if not character or not character.Parent then return end
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end

local function disableNoclip()
    if noclipConn then
        noclipConn:Disconnect()
        noclipConn = nil
    end
end

local function flyTo(destinationCFrame)
    local char = player.Character
    if not char or not char.Parent then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    enableNoclip(char)
    hrp.CFrame = hrp.CFrame + Vector3.new(0, 100, 0)

    local targetAbove = CFrame.new(destinationCFrame.Position + Vector3.new(0, 100, 0), destinationCFrame.Position)

    local distance = (hrp.Position - targetAbove.Position).Magnitude
    local speed = 300 -- studs per second
    local duration = math.max(0.01, distance / speed)

    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetAbove})

    tween:Play()
    tween.Completed:Wait()

    -- Плавное опускание на цель
    local finalTween = TweenService:Create(hrp, TweenInfo.new(1), {CFrame = destinationCFrame})
    finalTween:Play()
    finalTween.Completed:Wait()

    disableNoclip()
end

tpButton.MouseButton1Click:Connect(function()
    if not selectedPlace then
        warn("Не выбрана локация для телепортации!")
        return
    end

    local map = workspace:FindFirstChild("Map")
    if not map then
        warn("Карта не найдена в workspace!")
        return
    end

    local model = map:FindFirstChild(selectedPlace)
    if not model then
        warn("Локация "..selectedPlace.." не найдена!")
        return
    end

    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        warn("HumanoidRootPart не найден!")
        return
    end

    flyTo(model.PrimaryPart.CFrame)
end)

-- --- Контент вкладки Miscellaneous ---

local miscPage = tabPages["Miscellaneous"]

local labelCodes = Instance.new("TextLabel", miscPage)
labelCodes.Size = UDim2.new(0, 400, 0, 30)
labelCodes.Position = UDim2.new(0, 20, 0, 20)
labelCodes.BackgroundTransparency = 1
labelCodes.Text = "Введите код для redeem:"
labelCodes.TextColor3 = Color3.fromRGB(200, 220, 255)
labelCodes.Font = Enum.Font.GothamBold
labelCodes.TextSize = 18
labelCodes.TextXAlignment = Enum.TextXAlignment.Left

local codeInput = Instance.new("TextBox", miscPage)
codeInput.Size = UDim2.new(0, 260, 0, 40)
codeInput.Position = UDim2.new(0, 20, 0, 60)
codeInput.BackgroundColor3 = Color3.fromRGB(35, 45, 70)
codeInput.TextColor3 = Color3.fromRGB(220, 220, 255)
codeInput.Font = Enum.Font.Gotham
codeInput.TextSize = 18
codeInput.PlaceholderText = "Введите код здесь"
Instance.new("UICorner", codeInput)
codeInput.ClearTextOnFocus = false

local redeemButton = Instance.new("TextButton", miscPage)
redeemButton.Size = UDim2.new(0, 260, 0, 40)
redeemButton.Position = UDim2.new(0, 20, 0, 110)
redeemButton.BackgroundColor3 = Color3.fromRGB(70, 110, 210)
redeemButton.Text = "Redeem"
redeemButton.TextColor3 = Color3.fromRGB(230, 230, 255)
redeemButton.Font = Enum.Font.GothamBold
redeemButton.TextSize = 20
Instance.new("UICorner", redeemButton)

redeemButton.MouseButton1Click:Connect(function()
    local enteredCode = codeInput.Text:upper():gsub("%s+", "")
    if codesList[enteredCode] then
        print("Код успешно активирован:", enteredCode)
        -- Тут можно добавить любую логику применения кода
    else
        print("Код не найден или недействителен:", enteredCode)
    end
end)

-- --- Закрыть кнопку ---

local closeButton = Instance.new("TextButton", mainFrame)
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -40, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeButton.Text = "X"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 18
closeButton.AutoButtonColor = true
Instance.new("UICorner", closeButton)

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)
