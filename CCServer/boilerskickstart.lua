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

local boilerActive_left   = false
local boilerActive_middle = false
local boilerActive_right  = false

local numBoilersActive = 0

local boiler = {
    left = {
        deployers = peripheral.wrap("redstone_relay_2"),
        pumps = peripheral.wrap("redstone_relay_1"),
        active = false
    },
    middle = {
        deployers = peripheral.wrap("redstone_relay_1"),
        pumps = peripheral.wrap("redstone_relay_4"),
        active = false
    },
    right = {
        deployers = peripheral.wrap("redstone_relay_0"),
        pumps = peripheral.wrap("redstone_relay_5"),
        active = false
    }
}

peripheral.find("modem", rednet.open)

if rednet.isOpen == true then 
    print("System online...") else print ("Network Error. Rednet Offline.") print("have you checked if a wireless/ender modem is present?")
end

-- Deployer Controls: true = deployers active, false = deployer retracted.
local function setDeployer(side, state)
    -- side.setOutput("front", not state)
    boiler[side].deployers.setOutput("front", not state)
end

local function setAllDeployers(state)
    setDeployer(left, state)
    setDeployer(middle, state)
    setDeployer(right, state)
end

-- Pump Controls: true = pump on, false = pump off.
local function setPump(side, state)
    -- side.setOutput("left", not state)
    boiler[side].pumps.setOutput("left", not state)
end
local function setAllPumps(state)
    -- setPump(left, state)
    -- setPump(middle, state)
    -- setPump(right, state)
    for k, v in pairs(boiler) do
        setPump(k, state)
end

local function toggleBoiler(side, state)
    setPump(side, state)
    setDeployer(side, state)
    boiler[side].active = state

-- Main Clutch Controls: true = clutch engaged, false = clutch disengaged.
local function connectClutch(state)
    mainClutch.setOutput("top", not state)
end

local function getStatus()
    for side, v in pairs(boiler) do
        v.active = not v.pumps.getOutput("front")
    end
end

local function choke()
    setAllDeployers(false)
    setAllPumps(false)
end

local function kickstart()
    connectClutch(false)
    setAllDeployers(false)
    setAllPumps(false)
    toggleBoiler("left", true)
    redstone.setOutput("right", true)
    sleep(3.5)
    redstone.setOutput("right", false)
    connectClutch(true)
end

local function commandlistener()
    print("listening for on network 'boilers'... ")
    while true do
        local id, message = rednet.receive("boilerProtocol")
        if message.action == "kickstart" then
            kickstart()
        elseif message.action == "choke" then
            choke()
        elseif messageaction == "toggle" then
            toggleBoiler(message.target, message.value)
        end
    end
end

local function loop()
    while true do
        local stress = stressometer.getStress()
        local stressCap = stressometer.getStressCapacity()
        local packet = {
            data_stress = {
                stress = stress,
                stressCap = stressCap
            }, 
            active_boilers = {
                left = boilerActive_left,
                middle = boilerActive_middle,
                right = boilerActive_right
            }
        }
        rednet.broadcast(packet, "statusProtocol")
        sleep(0.5)
    end
end

parallel.waitForAny(
    commandlistener, loop, getStatus
)

