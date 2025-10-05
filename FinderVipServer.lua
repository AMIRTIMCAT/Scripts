local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local localPlayer = Players.LocalPlayer

local currentPlaceId = game.PlaceId

local function findPrivateServer()
    local success, result = pcall(function()
        local url = "https://games.roblox.com/v1/games/" .. currentPlaceId .. "/servers/Private?limit=100"
        local response = game:HttpGetAsync(url)
        local data = HttpService:JSONDecode(response)
        
        if data and data.data and #data.data > 0 then
            for _, server in ipairs(data.data) do
                if server.id and server.playing and server.maxPlayers > server.playing then
                    return server.id
                end
            end
        end
        return nil
    end)
    
    if success then
        return result
    else
        warn("Error searching for server: " .. result)
        return nil
    end
end

local privateServerId = findPrivateServer()

if privateServerId then
    local teleportSuccess, teleportError = pcall(function()
        TeleportService:TeleportToPrivateServer(currentPlaceId, privateServerId)
    end)
    
    if not teleportSuccess then
        warn("Teleportation error: " .. teleportError)
    end
else
    warn("No private servers found.")
end
