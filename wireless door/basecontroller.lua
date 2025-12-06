peripheral.find("modem", rednet.open)

local basalt = require("basalt")
local main = basalt.getMainFrame()
local speaker = peripheral.find("speaker")
local monitor = peripheral.find("monitor")
local monitorFrame = basalt.createFrame()
    :setTerm(monitor)

local doorState = "closed"

monitorFrame:addButton()
    :setText("Open Door")
    :setPosition(1,1)
    :onClick(function(self)
        self:setText("Opening...")
        rednet.send(7, "open")
        doorState = "open"
        sleep(1)
        self:setText("Open Door")
    end)

monitorFrame:addButton()
    :setText("Close Door")
    :setPosition(1,4)
    :onClick(function(self)
        self:setText("Closing...")
        rednet.send(7, "close")
        doorState = "closed"
        sleep(1)
        self:setText("Close Door")
    end)

    -- Dead Man's Switch to disable base after logout
    -- Dead Man's Switch to disable base after logout
    local function deadmanLoop()
        local mobileId = 8
        local controllerId = 7
        while true do
            rednet.send(mobileId, "ping")
            -- wait up to 5 seconds for a pong
            local id, message = rednet.receive(nil, 5)
            if id == mobileId and message == "pong" then
                if doorState == "open" then
                    rednet.send(controllerId, "open")
                end
            else
                -- no pong received within timeout: close the door
                rednet.send(controllerId, "close")
            end
            sleep(30)
        end
    end

    -- Run the UI and the deadman loop in parallel so the UI stays responsive.
    parallel.waitForAny(basalt.run, deadmanLoop)
