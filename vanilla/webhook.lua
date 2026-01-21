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
        username = username or "ComputerCraft Bot"
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

local myWebhook = "https://discord.com/api/webhooks/123456789/abcdefg..."

print("Attempting to send message...")
local success = sendToDiscord(myWebhook, "Hello from Minecraft!", "Mining Turtle 01")

if success then
    print("Message sent successfully!")
end