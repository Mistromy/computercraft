local serverUrl = "http://"
local deviceId = 8

while true do
    local x, y, z = gps.locate()

    if x and z then
        local payload = {
            id = deviceId,
            x = math.floor(x),
            z = math.floor(z),
        }
    
    local header = {["Content-Type"] = "application/json"}
    local body = textutils.serializeJSON(payload)

    http.request(serverUrl, body, header)
    end
    sleep(2)
end