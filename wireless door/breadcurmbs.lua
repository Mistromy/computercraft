-- REPLACE WITH YOUR PC IP:
local serverUrl = "http:// /api/batch" 
local deviceId = 8

print("Initializing High-Speed Tracker...")

while true do
    local batch = {}
    
    -- 1. COLLECTION PHASE (Run for 20 ticks / ~1 second)
    for i = 1, 20 do
        -- gps.locate() with no arguments is instant
        local x, y, z = gps.locate()
        
        if x and z then
            table.insert(batch, {
                id = deviceId,
                x = math.floor(x),
                z = math.floor(z)
            })
        end
        
        -- Wait 1 tick (0.05 seconds)
        sleep(0.05)
    end
    
    -- 2. TRANSMISSION PHASE
    if #batch > 0 then
        print("Sending batch of " .. #batch .. " points...")
        
        local body = textutils.serializeJSON(batch)
        local headers = {["Content-Type"] = "application/json"}
        
        -- Send to the new /api/batch endpoint
        local response, err = http.post(serverUrl, body, headers)
        
        if response then
            response.close()
        else
            print("Server Error: " .. tostring(err))
        end
    end
end