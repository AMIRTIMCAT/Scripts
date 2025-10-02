-- Загружаем библиотеку
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()

-- Создаём окно
local Window = Library:MakeWindow({
    Title = "Catik Yield",
    SubTitle = "By Catik Yield",
    ScriptFolder = "CatikYield-library-V5"
})

-- Создаём вкладку
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "Home",
    Color = Color3.fromRGB(255, 100, 100)
})

-- Добавляем Discord Invite
MainTab:AddDiscordInvite({
    Title = "Catik Yield | Community",
    Description = "Catik Yield.",
    Banner = "rbxassetid://74299525344625",
    Logo = "rbxassetid://74299525344625",
    Invite = "https://discord.gg/Eg98P4wf2V",
    Members = 1488,
    Online = 1488
})
