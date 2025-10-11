-- Детектор для Instant Steal - найдет все нужные объекты
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

print("🔍 ЗАПУСК ДЕТЕКТОРА INSTANT STEAL...")
print("=" .. string.rep("=", 50))

-- Функция поиска объектов по паттернам
local function findObjectsByPatterns()
    local foundObjects = {}
    
    -- Паттерны для объектов которые можно украсть
    local stealPatterns = {
        "brain", "femboy", "boy", "girl", "item", "flag", "coin", 
        "crystal", "orb", "target", "objective", "collect", "steal"
    }
    
    -- Паттерны для баз и спавнов
    local basePatterns = {
        "base", "spawn", "team", "home", "goal", "safe", "area", "zone",
        "slot", "point", "platform", "pedestal"
    }
    
    -- Паттерны для ивентов
    local eventPatterns = {
        "steal", "collect", "touch", "grab", "take", "capture",
        "return", "score", "point", "win", "success"
    }
    
    -- Поиск в Workspace
    print("📁 ПОИСК В WORKSPACE:")
    for _, obj in pairs(Workspace:GetDescendants()) do
        local lowerName = string.lower(obj.Name)
        
        -- Проверка объектов для кражи
        for _, pattern in pairs(stealPatterns) do
            if string.find(lowerName, pattern) then
                table.insert(foundObjects, {
                    type = "STEAL_OBJECT",
                    name = obj.Name,
                    path = obj:GetFullName(),
                    object = obj
                })
                print("🎯 Объект для кражи: " .. obj:GetFullName() .. " (" .. obj.ClassName .. ")")
                break
            end
        end
        
        -- Проверка баз и спавнов
        for _, pattern in pairs(basePatterns) do
            if string.find(lowerName, pattern) then
                table.insert(foundObjects, {
                    type = "BASE_SPAWN",
                    name = obj.Name,
                    path = obj:GetFullName(),
                    object = obj
                })
                print("🏠 База/Спавн: " .. obj:GetFullName() .. " (" .. obj.ClassName .. ")")
                break
            end
        end
    end
    
    -- Поиск в ReplicatedStorage
    print("\n📁 ПОИСК В REPLICATEDSTORAGE:")
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        local lowerName = string.lower(obj.Name)
        
        -- Проверка ивентов
        for _, pattern in pairs(eventPatterns) do
            if string.find(lowerName, pattern) then
                table.insert(foundObjects, {
                    type = "EVENT",
                    name = obj.Name,
                    path = obj:GetFullName(),
                    object = obj
                })
                print("⚡ Ивент: " .. obj:GetFullName() .. " (" .. obj.ClassName .. ")")
                break
            end
        end
    end
    
    return foundObjects
end

-- Функция анализа структуры игры
local function analyzeGameStructure()
    print("\n🔧 АНАЛИЗ СТРУКТУРЫ ИГРЫ:")
    
    -- Проверка команд
    if #game:GetService("Teams"):GetTeams() > 0 then
        print("🎯 Игра с командами:")
        for _, team in pairs(game:GetService("Teams"):GetTeams()) do
            print("   - " .. team.Name .. " (" .. team.TeamColor.Name .. ")")
        end
    else
        print("🎯 Игра без команд (FFA)")
    end
    
    -- Проверка основных папок
    local importantFolders = {"Bases", "Base", "Spawns", "Spawn", "Items", "Objectives", "Targets"}
    for _, folderName in pairs(importantFolders) do
        local folder = Workspace:FindFirstChild(folderName)
        if folder then
            print("📁 Найдена папка: " .. folderName)
            print("   Содержит " .. #folder:GetChildren() .. " объектов")
        end
    end
    
    -- Проверка игрока
    if player.Team then
        print("👤 Твоя команда: " .. player.Team.Name)
    end
end

-- Функция поиска Touch/Click событий
local function findInteractionEvents()
    print("\n🖱️ ПОИСК ИНТЕРАКТИВНЫХ ОБЪЕКТОВ:")
    
    local interactionTypes = {
        "TouchInterest", "ClickDetector", "ProximityPrompt", "BillboardGui"
    }
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        for _, interactionType in pairs(interactionTypes) do
            if obj.ClassName == interactionType then
                print("   " .. interactionType .. " -> " .. obj.Parent:GetFullName())
                
                -- Дополнительная информация для ProximityPrompt
                if interactionType == "ProximityPrompt" then
                    print("     Action: " .. tostring(obj.ActionText))
                    print("     Object: " .. tostring(obj.ObjectText))
                end
            end
        end
    end
end

-- Функция мониторинга событий в реальном времени
local function startEventMonitoring()
    print("\n📡 МОНИТОРИНГ СОБЫТИЙ В РЕАЛЬНОМ ВРЕМЕНИ:")
    print("   (Совершай действия в игре и смотри что происходит)")
    
    -- Мониторинг изменений в Workspace
    Workspace.ChildAdded:Connect(function(child)
        print("   [+] Добавлен объект: " .. child.Name)
    end)
    
    Workspace.ChildRemoved:Connect(function(child)
        print("   [-] Удален объект: " .. child.Name)
    end)
end

-- Функция проверки механик кражи
local function testStealMechanics()
    print("\n🎯 ТЕСТИРОВАНИЕ МЕХАНИК КРАЖИ:")
    print("   1. Подойди к объекту который нужно украсть")
    print("   2. Посмотри в консоль (F9) что происходит")
    print("   3. Попробуй украсть обычным способом")
    print("   4. Вернись на базу")
    print("   5. Запомни какие объекты/ивенты участвуют")
end

-- Запуск детектора
local foundObjects = findObjectsByPatterns()
analyzeGameStructure()
findInteractionEvents()
startEventMonitoring()
testStealMechanics()

-- Вывод итоговой информации
print("\n" .. "=" .. string.rep("=", 50))
print("📊 ИТОГИ ПОИСКА:")
print("   Найдено объектов для кражи: " .. #foundObjects)

local stealObjects = {}
local baseObjects = {}
local events = {}

for _, obj in pairs(foundObjects) do
    if obj.type == "STEAL_OBJECT" then
        table.insert(stealObjects, obj.path)
    elseif obj.type == "BASE_SPAWN" then
        table.insert(baseObjects, obj.path)
    elseif obj.type == "EVENT" then
        table.insert(events, obj.path)
    end
end

print("🎯 Возможные цели для кражи:")
for _, obj in pairs(stealObjects) do
    print("   - " .. obj)
end

print("🏠 Возможные базы/спавны:")
for _, obj in pairs(baseObjects) do
    print("   - " .. obj)
end

print("⚡ Найденные ивенты:")
for _, obj in pairs(events) do
    print("   - " .. obj)
end

print("\n💡 ЧТО ДЕЛАТЬ ДАЛЬШЕ:")
print("   1. Скопируй эту информацию")
print("   2. Попробуй украсть объект в игре")
print("   3. Посмотри в Output (F9) какие ивенты вызываются")
print("   4. Сообщи мне что нашел и я сделаю Instant Steal!")

print("\n🔧 Детектор завершил работу!")
