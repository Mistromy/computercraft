local serverUrl = "http:// /api/batch" 
local deviceId = 8
 
print("Tracker Started")
 
while true do
    local batch = {}
    local successCount = 0
    
    for i = 1, 20 do
        local x, y, z = gps.locate()
        
        if x and z then
            table.insert(batch, {
                id = deviceId,
                x = math.floor(x),
                z = math.floor(z)
            })
            -- successCount = successCount + 1
        end
        
        sleep(0.05)
    end
    
    -- print("GPS Lock: " .. successCount .. " / 20 ticks")
 
    if #batch > 0 then
        local body = textutils.serializeJSON(batch)
        local headers = {["Content-Type"] = "application/json"}
        
        local response, err = http.post(serverUrl, body, headers)
        if response then
            response.close()
        end
    end
end
 