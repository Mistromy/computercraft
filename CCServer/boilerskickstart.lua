-- Deployer Relay numbers:
-- 0: rightmost, 1: middle, 2: leftmost

-- Pump Relay numbers:
-- 3: leftmost, 4: middle, 5: rightmost

-- Others:
-- Speed Controller, Stressometer, Main Clutch, 

-- Starter Motor: right redstone output. true = on, false = off. 

-- Pump Speeds:
-- 1 Boiler: 96, 

local deployers_left = peripheral.wrap("redstone_relay_2")
local deployers_middle = peripheral.wrap("redstone_relay_1")
local deployers_right = peripheral.wrap("redstone_relay_0")

local pump_left = peripheral.wrap("redstone_relay_3")
local pump_middle = peripheral.wrap("redstone_relay_4")
local pump_right = peripheral.wrap("redstone_relay_5")

local speedController = peripheral.find("")
local stressometer = peripheral.wrap("Create_Stressometer_1")
local mainClutch = peripheral.wrap("redstone_relay_6")

peripheral.find("modem", rednet.open)

print("System online...")

-- Deployer Controls: true = deployers active, false = deployer retracted.
local function setDeployer(side, state)
    side.setOutput("front", not state)
end
local function setAllDeployers(state)
    setDeployer(deployers_left, state)
    setDeployer(deployers_middle, state)
    setDeployer(deployers_right, state)
end

-- Pump Controls: true = pump on, false = pump off.
local function setPump(side, state)
    side.setOutput("left", not state)
end
local function setAllPumps(state)
    setPump(pump_left, state)
    setPump(pump_middle, state)
    setPump(pump_right, state)
end

-- Main Clutch Controls: true = clutch engaged, false = clutch disengaged.
local function connectClutch(state)
    mainClutch.setOutput("top", not state)
end


local function choke()
    setAllDeployers(false)
    setAllPumps(false)
end

local function startup()
    connectClutch(false)
    setAllDeployers(false)
    setAllPumps(false)
    redstone.setOutput("right", true)
    setDeployer(deployers_right, true)
    sleep(2)
    setDeployer(deployers_right, false)
    setPump(pump_right, true)
    sleep(2)
    redstone.setOutput("right", false)
    setDeployer(deployers_right, true)
    connectClutch(true)
end

local function commandlistener()
    print("listening for on network 'boilers'... ")
    while true do
        local id, message = rednet.receive("boilers")
        if message == "start" then
            startup()
        elseif message == "choke" then
            choke()
        end
    end
end

local function measureStress()
    while true do
        local stress = stressometer.getStress()
        local stressCap = stressometer.getStressCapacity()
        data_stress = {
            stress = stress,
            stressCap = stressCap
        }
        rednet.broadcast(data_stress, "stressProtocol")
        sleep(0.5)
    end
end

parallel.waitForAny(
    commandlistener, measureStress
)

