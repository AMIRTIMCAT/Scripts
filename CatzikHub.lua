local success, err = pcall(function()
    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/exunys/Eclipse-UI/main/EclipseUI.lua"))() -- Замени на актуальный URL
    if not Library then error("Библиотека не загрузилась") end

    local Window = Library:CreateWindow({
        Title = "Моё Eclipse 5 Меню",
        Center = true,
        AutoShow = true,
        Size = UDim2.fromOffset(500, 400),
        MinimizeKey = Enum.KeyCode.RightControl,
    })

    local MainTab = Window:AddTab({ Title = "Main" })
    MainTab:AddButton({
        Title = "Test Button",
        Callback = function()
            print("Кнопка нажата!")
        end
    })

    MainTab:AddButton({
        Title = "Close Menu",
        Callback = function()
            Library:Close()
        end
    })
end)

if not success then
    warn("Ошибка загрузки: " .. tostring(err) .. ". Проверь URL или используй локальный скрипт.")
end

-- Toggle на Right Ctrl (ручной)
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        if typeof(Window) == "table" and Window.Visible then
            Window:Close()
        elseif typeof(Window) == "table" then
            Window:Open()
        end
    end
end)
