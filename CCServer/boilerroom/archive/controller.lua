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
            relay.setOutput("front", not message.active_boilers.middle)
            boilers.middle = message.active_boilers.middle
            relay.setOutput("right", message.active_boilers.right)
            boilers.right = message.active_boilers.right
        end
        sleep(0.5)
    end
end

local function buttons()
    while true do
        os.pullEvent("redstone")
        if relay.getInput("top") then
            if boilers.left == false or boilers.middle == false or boilers.right == false then
                local packet = {
                    action = "kickstart"
                }
                print("kickstart")
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
            print("left")
            rednet.broadcast(packet, network)
        elseif redstone.getInput("back") then
            local packet = {
                action = "toggle",
                target = "middle",
                value = not boilers.middle
            }
            print("middle")
            rednet.broadcast(packet, network)
        elseif redstone.getInput("right") then
            local packet = {
                action = "toggle",
                target = "right",
                value = not boilers.right
            }
            print("right")
            rednet.broadcast(packet, network)
        end
        sleep(0.4)
    end
end

parallel.waitForAny(
    lamps, buttons
)