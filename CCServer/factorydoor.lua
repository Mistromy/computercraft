peripheral.find("modem", rednet.open)

local mobileID = 16

local doorState = "closed"

while true do
    local id, message = rednet.receive()
    if message == "open" then
        redstone.setOutput("bottom", true)
    elseif message == "close" then
        redstone.setOutput("bottom", false)
    end
    
end