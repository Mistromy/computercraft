peripheral.find("modem", rednet.open)

local basalt = require("basalt")
local main = basalt.getMainFrame()
local serverUrl = "http:// /api/batch" 
local deviceId = 8

shell.run("gpsapp.lua")

main:addButton()
    :setText("Open Door")
    :setPosition(1,1)
    :onClick(function(self)
        self:setText("Opening...")
        rednet.send(7, "open")
        rednet.send(1, "open")
        sleep(1)
        self:setText("Open Door")
    end)

main:addButton()
    :setText("Close Door")
    :setPosition(1,4)
    :onClick(function(self)
        self:setText("Closing...")
        rednet.send(7, "close")
        rednet.send(1, "close")
        sleep(1)
        self:setText("Close Door")
    end)

local function tracker()
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
end

local function listener()
    while true do
        -- wait up to 5 seconds for any message so this loop doesn't block forever
        local id, message = rednet.receive(nil, 5)
        if id and message == "ping" then
            -- reply to the sender so the controller gets the pong
            rednet.send(id, "pong")
        end
    end
end

-- Run UI and listener in parallel so the UI stays responsive
parallel.waitForAny(basalt.run, listener, tracker())
