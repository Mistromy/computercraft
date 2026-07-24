peripheral.find("modem", rednet.open)
local relay = peripheral.find("redstone_relay")
local network = "boilerProtocol"
local leverSide = "back"

boilers = {
    left = false,
    middle = false,
    right = false
}

local lastLeverValue = -1
local lastRequestedLevel = -1

local function clamp(value, minValue, maxValue)
    if value < minValue then
        return minValue
    end
    if value > maxValue then
        return maxValue
    end
    return value
end

local function levelFromLever(analogValue)
    local value = clamp(math.floor(analogValue or 0), 0, 15)
    if value == 0 then
        return 0
    elseif value <= 5 then
        return 1
    elseif value <= 10 then
        return 2
    end
    return 3
end

local function sendLevel(level)
    local packet = {
        action = "set_level",
        level = level
    }
    rednet.broadcast(packet, network)
    print("requested level", level)
end

local function lamps()
    while true do
        local id, message = rednet.receive("statusProtocol")
        if type(message) == "table" and message.active_boilers then
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

local function lever()
    lastLeverValue = redstone.getAnalogInput(leverSide)
    lastRequestedLevel = levelFromLever(lastLeverValue)
    sendLevel(lastRequestedLevel)

    while true do
        os.pullEvent("redstone")
        local currentValue = redstone.getAnalogInput(leverSide)
        if currentValue ~= lastLeverValue then
            lastLeverValue = currentValue
            local level = levelFromLever(currentValue)
            if level ~= lastRequestedLevel then
                lastRequestedLevel = level
                sendLevel(level)
            end
        end
        sleep(0.4)
    end
end

parallel.waitForAny(
    lamps, lever
)