-- Безопасное удаление с проверкой типа
local scriptsToDelete = {"XDAntiCheat", "Anti"}

for _, scriptName in pairs(scriptsToDelete) do
    local target = game.StarterPlayer.StarterCharacterScripts:FindFirstChild(scriptName)
    if target and target:IsA("LuaScript") then
        target:Destroy()
        print(scriptName .. " удален!")
    end
end
