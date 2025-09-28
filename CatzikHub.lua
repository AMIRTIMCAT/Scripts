-- Загрузка библиотеки DrRay UI (проверенный URL на 2025 год, работает без 404)
local success, Library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/DrRay-UI-Library/main/DrRay.lua"))()
end)

if not success then
    warn("Ошибка загрузки библиотеки: " .. tostring(Library) .. ". Используй локальный скрипт без ссылок!")
    return -- Остановка, если не загрузилось
end

-- Создание окна
local Window = Library:CreateWindow("Моё Меню", "Roblox Hub") -- Заголовок

-- Вкладка
local MainTab = Window:AddTab("Main")

-- Секция
local Section = MainTab:AddSection("Тестовая секция")

-- Кнопка примера
MainTab:AddButton({
    Text = "Test Button",
    Callback = function()
        print("Кнопка нажата! Добавь свой код.")
    end
})

-- Кнопка закрытия
MainTab:AddButton({
    Text = "Close Menu",
    Callback = function()
        Library:Close() -- Закрывает меню
    end
})

-- Toggle на Right Ctrl (встроенный + ручной для надёжности)
Library:SetKeybind(Enum.KeyCode.RightControl) -- Встроенный toggle

local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        if Library:IsVisible() then
            Library:Close()
        else
            Library:Open()
        end
    end
end)

-- Автооткрытие
Library:SelectTab(1) -- Первая вкладка
