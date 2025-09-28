-- LocalScript для условной загрузки main1.lua
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- Целевой Place ID
local TARGET_PLACE_ID = 2753915549

-- URL для raw содержимого main1.lua (прямой доступ к файлу на GitHub)
local SCRIPT_URL = "https://raw.githubusercontent.com/AMIRTIMCAT/Scripts/main/main1.lua"

-- Проверка Place ID и загрузка скрипта
if game.PlaceId == TARGET_PLACE_ID then
    -- Включаем HTTP-запросы, если они отключены (требует прав в Studio или эксплойт)
    if not game:GetService("HttpService").HttpEnabled then
        game:GetService("HttpService").HttpEnabled = true
    end
    
    -- Загружаем содержимое скрипта
    local success, result = pcall(function()
        return HttpService:GetAsync(SCRIPT_URL)
    end)
    
    if success and result then
        -- Выполняем загруженный скрипт
        local load_success, err = pcall(function()
            loadstring(result)()
        end)
        
        if load_success then
            print("main1.lua успешно загружен и выполнен для Place ID " .. TARGET_PLACE_ID)
        else
            warn("Ошибка выполнения main1.lua: " .. tostring(err))
        end
    else
        warn("Ошибка загрузки main1.lua: " .. tostring(result))
    end
else
    print("Place ID не совпадает (" .. game.PlaceId .. " != " .. TARGET_PLACE_ID .. "). Скрипт не запущен.")
end
