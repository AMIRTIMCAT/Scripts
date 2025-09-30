local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/main/redz-V5-remake/main.luau"))()
if not Library then
    warn("Не удалось загрузить библиотеку redz-V5-remake")
    return
end

local window = Library.new({
    name = "TestUI",
    loading_title = "Loading TestUI...",
    game = game,
})

-- Создаем одну вкладку
local mainTab = window:Tab("Main")

-- Создаем секцию внутри вкладки
local mainSection = mainTab:Section("Main Section")

-- Добавляем кнопку для теста
mainSection:Button("Click Me", function()
    print("Button clicked!")
end)

-- Инициализируем UI
window:Init()
