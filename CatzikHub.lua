-- Загрузка библиотеки Eclipse 5 (замени URL на актуальный, если нужно)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/UI"))()  -- Это пример; для Eclipse 5 используй: "https://pastebin.com/raw/XXXXX" или GitHub raw

-- Создание окна
local Window = Library:CreateWindow({
    Title = "Моё Eclipse 5 Меню",
    Center = true,
    AutoShow = true,  -- Открыто по умолчанию
    TabPadding = 8,
    MenuFadeTime = 0.2,
    Size = UDim2.fromOffset(500, 400),
    MinSize = 400,
    MaxSize = 600,
    Acrylic = true,  -- Эффект акрила (полупрозрачность)
    ThemedBackground = true,  -- Темная/светлая тема
    MinimizeKey = Enum.KeyCode.RightControl,  -- Right Ctrl для toggle (скрыть/показать)
    -- Закругления и тень встроены в Eclipse 5 (CornerRadius и Shadow по умолчанию)
})

-- Создание вкладки
local MainTab = Window:AddTab({
    Title = "Main",
    Icon = "rbxassetid://4483345998",  -- Иконка (опционально)
})

-- Добавление секции с кнопкой (пример контента)
local Section = MainTab:AddSection({
    Title = "Тестовая секция"
})

MainTab:AddButton({
    Title = "Test Button",
    Description = "Нажми для теста",
    Callback = function()
        print("Кнопка нажата!")  -- Замени на свой код
        -- Например, toggle другого GUI или что-то
    end
})

-- Кнопка для закрытия/скрытия (опционально, но для явного закрытия)
MainTab:AddButton({
    Title = "Close Menu",
    Description = "Закрыть меню",
    Callback = function()
        Library:Close()  -- Закрывает меню (Right Ctrl вернёт)
    end
})

-- Автоматический toggle на Right Ctrl (если MinimizeKey не сработает, используй это)
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        if Window.Visible then
            Window:Close()  -- Скрыть
        else
            Window:Open()  -- Показать
        end
    end
end)
