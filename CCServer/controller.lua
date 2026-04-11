peripheral.find("modem", rednet.open)
local relay = peripheral.find("redstone_relay")
local network = "boilerProtocol"

boilers = {
    left = false,
    middle = false,
    right = false
}

local function lamps()
    while true do
        local id, message = rednet.receive("statusProtocol")
        if message.active_boilers then
            relay.setOutput("left", message.active_boilers.left)
            boilers.left = message.active_boilers.left
            relay.setOutput("front", message..active_boilers.middle)
            boilers.middle = message.active_boilers.middle
            relay.setOutput("right", message.active_boilers.right)
            boilers.right = message.active_boilers.left
        end
        sleep(0.5)
    end
end

local function buttons()
    os.pullEvent("redstone")
    if relay.getInput("top") then
        if boilers.left == true or if boilers.middle == true or if boilers.right == true then
            local packet = {
                action = "kickstart"
            }
            rednet.broadcast(packet, network)
        else
            local packet = {
                action = "choke"
            }
            rednet.broadcast(packet, network)
        end
    elseif redstone.getInput("left") then
        local packet = {
            action = "toggle",
            target = "left",
            value = not boilers.left
        }
        rednet.broadcast(packet, network)
end


while true do
    os.pullEvent("redstone")
    if relay.getInput("top") then
        local packet = {
            action = "kickstart"
        }
        rednet.broadcast(packet, network)
    elseif redstone.getInput("right") the
        while redstone.getInput("right") do sleep(0.2) end
    end
end

while true do
    os.pullEvent("redstone")
    if relay.getInput("top") then
        if not boiler1active
            rednet.broadcast("kickstart", network)
            boiler1active = true
            relay.setOutput("left", true)
        else
            rednet.broadcast("choke", network)
            boiler1active = false
            relay.setOutput("left", true)
        while redstone.getInput("left") do sleep(0.2) end
    elseif redstone.getInput("right") then
        
        while redstone.getInput("right") do sleep(0.2) end
    end
    if redstone1 = active
    relay.
end

parallel.waitForAny(
    lamps, buttons
)