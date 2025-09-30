local TabFarm = Window:MakeTab({
    Title = "Farm",
    Icon = "Home"
})

local autoChest = false
local chests = {"Chest1", "Chest2", "Chest3"}

local function getChestCFrame(name)
    local mapFolder = workspace:FindFirstChild("Map")
    if not mapFolder then return nil end
    local chestModel = mapFolder:FindFirstChild(name)
    if not chestModel then return nil end
    local part = chestModel:FindFirstChild("HumanoidRootPart") or chestModel:FindFirstChildWhichIsA("BasePart")
    if not part then return nil end
    return part.CFrame
end

-- Функция, которая циклично телепортирует к сундукам
spawn(function()
    while true do
        if autoChest then
            for _, chestName in ipairs(chests) do
                if not autoChest then break end
                local cframe = getChestCFrame(chestName)
                if cframe then
                    Window:Notify({
                        Title = "Auto Chest",
                        Content = "Лечу к " .. chestName,
                        Duration = 2
                    })
                    tweenToPosition(cframe):Wait()
                end
                wait(0.3)
            end
        else
            wait(0.5)
        end
    end
end)

TabFarm:AddToggle({
    Name = "Auto Chest [ Tween ]",
    Default = false,
    Callback = function(value)
        autoChest = value
        print("Auto Chest", value and "включён" or "выключен")
    end
})
