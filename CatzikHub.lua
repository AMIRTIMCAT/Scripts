-- Подключение библиотеки
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/main/redz-V5-remake/main.luau"))()

-- Создание окна
local Window = Library:MakeWindow({
    Title = "Catzik Hub",
    SubTitle = "by Yoshi",
    ScriptFolder = "redz-library-V5"
})

-- Создание вкладки (ВНИМАНИЕ: метод называется Page, но он точно должен быть в Window)
local MainTab = Window:Page("Main")

-- Создание секции
local Section = MainTab:Section("Main Section")

-- Пример слайдера
Section:Slider("WalkSpeed", 16, {min = 16, max = 100}, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)

-- Пример переключателя
Section:Toggle("Noclip", false, function(state)
    print("Noclip toggled:", state)
end)

-- Обязательно запуск UI
Window:Init()
