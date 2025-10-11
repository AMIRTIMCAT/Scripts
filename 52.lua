-- Инструмент: Game Inspector (для отладки разработчика)
-- Запускайте только в режиме Studio или если вы владелец/разработчик
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeamsService = game:GetService("Teams")
local player = Players.LocalPlayer

-- Настройка: id группы/список разработчиков, которым разрешено использовать инструмент
local ALLOWED_USER_IDS = { -- пример: владельцы/тестеры
    -- 12345678,  -- добавьте свои UserId по необходимости
}
local ALLOWED_GROUP_ID = nil -- если нужно разрешить участникам группы, укажите groupId или nil

-- Быстрая проверка прав: владелец места или в списке разрешённых
local function isDeveloper()
    -- владелец места (CreatorId) доступен только в Studio/серверном коде обычно; проверим осторожно
    local ok, creatorId = pcall(function()
        return game.CreatorId
    end)
    if ok and creatorId and creatorId == player.UserId then
        return true
    end
    for _, id in ipairs(ALLOWED_USER_IDS) do
        if player.UserId == id then
            return true
        end
    end
    if ALLOWED_GROUP_ID then
        local ok2, isIn = pcall(function()
            return player:IsInGroup(ALLOWED_GROUP_ID)
        end)
        if ok2 and isIn then return true end
    end
    return false
end

if not isDeveloper() then
    warn("[Inspector] Доступ запрещён. Этот инструмент доступен только разработчикам/владельцам.")
    return
end

print("🔍 Game Inspector: запуск (только для отладки разработчика).")

-- Паттерны (настраиваемые)
local stealPatterns = { "brain", "femboy", "boy", "girl", "item", "flag", "coin", "crystal", "orb", "target", "objective", "collect", "steal" }
local basePatterns = { "base", "spawn", "team", "home", "goal", "safe", "area", "zone", "slot", "point", "platform", "pedestal" }
local eventPatterns = { "steal", "collect", "touch", "grab", "take", "capture", "return", "score", "point", "win", "success" }

-- Нормализующая функция
local function lowered(name)
    if typeof(name) ~= "string" then return "" end
    return string.lower(name)
end

-- Безопасное получение полного имени объекта
local function safeFullName(obj)
    local ok, res = pcall(function() return obj:GetFullName() end)
    if ok then return res else return tostring(obj.ClassName .. " (unable to get path)") end
end

-- Поиск по контейнеру с заданными паттернами, возвращает список результатов
local function scanContainer(container, patterns, resultType)
    local results = {}
    for _, obj in pairs(container:GetDescendants()) do
        local lname = lowered(obj.Name)
        for _, pat in ipairs(patterns) do
            if pat ~= "" and string.find(lname, lowered(pat)) then
                table.insert(results, {
                    type = resultType,
                    name = obj.Name,
                    path = safeFullName(obj),
                    class = obj.ClassName,
                    instance = obj
                })
                break
            end
        end
    end
    return results
end

-- Главная функция поиска
local function findObjectsByPatterns()
    local found = {}

    print("📁 Сканирование Workspace...")
    local stealFound = scanContainer(Workspace, stealPatterns, "STEAL_OBJECT")
    for _, v in ipairs(stealFound) do table.insert(found, v); print("  🔎 Цель: "..v.path.." ("..v.class..")") end

    local baseFound = scanContainer(Workspace, basePatterns, "BASE_SPAWN")
    for _, v in ipairs(baseFound) do table.insert(found, v); print("  🏠 База/Спавн: "..v.path.." ("..v.class..")") end

    print("📁 Сканирование ReplicatedStorage...")
    local eventFound = scanContainer(ReplicatedStorage, eventPatterns, "EVENT")
    for _, v in ipairs(eventFound) do table.insert(found, v); print("  ⚡ Ивент: "..v.path.." ("..v.class..")") end

    return found, stealFound, baseFound, eventFound
end

-- Ищем интерактивные элементы (Touch, Click, ProximityPrompt и т.д.)
local function findInteractionEvents()
    local interactions = {}
    local interactionTypes = { "TouchInterest", "ClickDetector", "ProximityPrompt", "BillboardGui", "ClickDetector" }
    for _, obj in pairs(Workspace:GetDescendants()) do
        for _, t in ipairs(interactionTypes) do
            if obj.ClassName == t then
                local parentName = safeFullName(obj.Parent or obj)
                table.insert(interactions, {type = t, parent = parentName, instance = obj})
                print("   "..t.." -> "..parentName)
                if t == "ProximityPrompt" then
                    local ok, actionText = pcall(function() return obj.ActionText end)
                    local ok2, objectText = pcall(function() return obj.ObjectText end)
                    print("     Action: "..tostring(actionText or "<n/a>").." | ObjectText: "..tostring(objectText or "<n/a>"))
                end
            end
        end
    end
    return interactions
end

-- HUD: простая информация на экране (Client-only)
local function createHUD(stealCount, baseCount, eventCount)
    local success, screenGui = pcall(function()
        local sg = Instance.new("ScreenGui")
        sg.Name = "GameInspectorHUD"
        sg.ResetOnSpawn = false

        local frame = Instance.new("Frame", sg)
        frame.AnchorPoint = Vector2.new(0, 1)
        frame.Position = UDim2.new(0, 10, 1, -110)
        frame.Size = UDim2.new(0, 260, 0, 90)
        frame.BackgroundTransparency = 0.35
        frame.BorderSizePixel = 0
        frame.Name = "InspectorFrame"

        local title = Instance.new("TextLabel", frame)
        title.Size = UDim2.new(1, -10, 0, 24)
        title.Position = UDim2.new(0, 5, 0, 5)
        title.BackgroundTransparency = 1
        title.TextScaled = true
        title.Text = "Game Inspector (Dev)"
        title.TextXAlignment = Enum.TextXAlignment.Left

        local info = Instance.new("TextLabel", frame)
        info.Size = UDim2.new(1, -10, 0, 60)
        info.Position = UDim2.new(0,5,0,30)
        info.BackgroundTransparency = 1
        info.Text = string.format("Targets: %d\nBases: %d\nEvents: %d", stealCount, baseCount, eventCount)
        info.TextXAlignment = Enum.TextXAlignment.Left
        info.TextYAlignment = Enum.TextYAlignment.Top
        info.TextWrapped = true

        sg.Parent = player:FindFirstChildOfClass("PlayerGui") or game:GetService("StarterGui")
        return sg
    end)
    if not success then
        warn("[Inspector] Не удалось создать HUD: "..tostring(screenGui))
    end
end

-- Мониторинг изменений для отладки (опционально)
local function startEventMonitoring()
    Workspace.ChildAdded:Connect(function(child)
        print("[Workspace] Добавлен: "..tostring(child.Name))
    end)
    Workspace.ChildRemoved:Connect(function(child)
        print("[Workspace] Удалён: "..tostring(child.Name))
    end)
end

-- Основной запуск
local allFound, stealFound, baseFound, eventFound = findObjectsByPatterns()
local interactions = findInteractionEvents()
startEventMonitoring()
createHUD(#stealFound, #baseFound, #eventFound)

print(string.rep("=", 40))
print("Итоги: всего найдено элементов: "..#allFound)
print("  Целей: "..#stealFound.." | Баз/спавнов: "..#baseFound.." | Ивентов: "..#eventFound)
print("Интерактивных элементов: "..#interactions)
print("Используйте этот инструмент только для тестирования и отладки вашей игры.")
