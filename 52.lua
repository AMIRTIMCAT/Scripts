-- Удаляем несколько скриптов
local scriptsToDelete = {"XDAntiCheat", "Anti"}

for _, scriptName in pairs(scriptsToDelete) do
    if game.StarterPlayer.StarterCharacterScripts:FindFirstChild(scriptName) then
        game.StarterPlayer.StarterCharacterScripts[scriptName]:Destroy()
        print(scriptName .. " удален!")
    end
end
