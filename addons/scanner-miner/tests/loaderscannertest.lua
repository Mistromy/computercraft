local chunkloader = peripheral.find("chunkloader")
local scanner = peripheral.find("universal_scanner")
local radius = 16
turtle.refuel(1000)
print("starting test...")
chunkloader.setRadius(0.1)

-- Function to send a message to a Discord Webhook
-- @param webhookUrl (string): The full URL of your Discord Webhook
-- @param message (string): The text message to send
-- @param username (string, optional): A custom name for the bot
local function sendToDiscord(webhookUrl, message, username)
    if not http then
        printError("Error: HTTP API is not enabled in ComputerCraft config.")
        return false
    end

    local payload = {
        content = message,
        username = username or "ComputerCraft Bot" -- Default name if none provided
    }

    local jsonBody = textutils.serializeJSON(payload)

    local headers = {
        ["Content-Type"] = "application/json"
    }

    local request, errorMessage = http.post(webhookUrl, jsonBody, headers)

    if request then
        request.close()
        return true
    else
        printError("Failed to send to Discord: " .. (errorMessage or "Unknown error"))
        return false, errorMessage
    end
end

local myWebhook = "https://discord.com/api/webhooks/1463567049727934659/9atfK6cKWpJY5ZR7hGKYRH-IzuvwehfUMWOeikFGLR9BBf7KPVe2kFUCI7FQiSSkCPrK"
local success = sendToDiscord(myWebhook, "Initialized", "loadertest")
sendToDiscord(myWebhook, "Chunkloader fuel rate: " .. chunkloader.getFuelRate() .. " per tick.", "loadertest")
sleep(15)

chunkloader.setRadius(0.5)
print("Chunkloader radius set to " .. chunkloader.getRadius() .. ".")
chunkloader.getFuelRate()
print("Chunkloader fuel rate: " .. chunkloader.getFuelRate() .. " per tick.")

sleep(15)

local results = scanner.scan("block", radius)
for _, block in ipairs(results) do
    if block.name == "minecraft:red_concrete" or 
       block.name == "minecraft:lime_concrete" or 
       block.name == "minecraft:light_blue_concrete" or 
       block.name == "minecraft:yellow_concrete" then
        print("Found: " .. block.name)
    end
end


for _, block in ipairs(results) do
    if block.name == "minecraft:red_concrete" or 
       block.name == "minecraft:lime_concrete" or 
       block.name == "minecraft:light_blue_concrete" or 
       block.name == "minecraft:yellow_concrete" then
        local message = "Found: " .. block.name
        print(message)
        sendToDiscord(myWebhook, message, "loadertest")
    end
end

chunkloader.setRadius(0.1)