-- Загружаем библиотеку
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()

-- Создаём окно
local Window = Library:MakeWindow({
    Title = "Catik Yield",
    SubTitle = "By Catik Yield",
    ScriptFolder = "CatikYield-library-V5"
})

-- Вкладка: Main
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "Home", -- Иконка по имени (если библиотека поддерживает это)
    Color = Color3.fromRGB(255, 100, 100)
})

-- Добавляем Discord Invite в MainTab
MainTab:AddDiscordInvite({
    Title = "Catik Yield | Community",
    Description = "Catik Yield.",
    Banner = "rbxassetid://74299525344625",
    Logo = "rbxassetid://74299525344625",
    Invite = "https://discord.gg/Eg98P4wf2V",
    Members = 1488,
    Online = 1488
})

-- ✅ Вкладка: Player
local PlayerTab = Window:MakeTab({
    Name = "Player",
    Icon = "User", -- Можно заменить на подходящую иконку или ID
    Color = Color3.fromRGB(100, 149, 255) -- Голубой оттенок
})

-- Пример: кнопка в PlayerTab
PlayerTab:AddButton({
    Name = "Установить скорость 100",
    Callback = function()
        local player = game.Players.LocalPlayer
        if player and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 100
        end
    end
})

-- Пример: слайдер для изменения скорости
PlayerTab:AddSlider({
    Name = "Скорость игрока",
    Min = 16,
    Max = 200,
    Default = 16,
    Callback = function(value)
        local player = game.Players.LocalPlayer
        if player and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = value
        end
    end
})
