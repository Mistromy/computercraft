-- Deployer Relay numbers:
-- 0: rightmost, 1: middle, 2: leftmost

-- Pump Relay numbers:
-- 3: leftmost, 4: middle, 5: rightmost

-- Others:
-- Speed Controller, Stressometer, Main Clutch, 

-- Starter Motor: right redstone output. true = on, false = off. 

-- Pump Speeds:
-- 1 Boiler: 96, 
-- 2 boilers: 160
-- 3 boilers: 256

local speeds = {
    [1] = 96,
    [2] = 160,
    [3] = 256
}

local START_ORDER = { "right", "middle", "left" }
local STATE_FILE = "boiler_state"

local pumpSpeedController = peripheral.wrap("Create_RotationSpeedController_1")

local deployers_left = peripheral.wrap("redstone_relay_2")
local deployers_middle = peripheral.wrap("redstone_relay_1")
local deployers_right = peripheral.wrap("redstone_relay_0")

local pump_left = peripheral.wrap("redstone_relay_3")
local pump_middle = peripheral.wrap("redstone_relay_4")
local pump_right = peripheral.wrap("redstone_relay_5")

local stressometer = peripheral.wrap("Create_Stressometer_1")
local mainClutch = peripheral.wrap("redstone_relay_6")

local boilerActive_left   = false
local boilerActive_middle = false
local boilerActive_right  = false

local numBoilersActive = 0
local desiredLevel = 0
local kickstartInProgress = false

local boiler = {
    left = {
        deployers = peripheral.wrap("redstone_relay_2"),
        pumps = peripheral.wrap("redstone_relay_3"),
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

if rednet.isOpen() == true then 
    print("System online...") else print ("Network Error. Rednet Offline.") print("have you checked if a wireless/ender modem is present?")
end

-- Deployer Controls: true = deployers active, false = deployer retracted.
local function setDeployer(side, state)
    -- side.setOutput("front", not state)
    boiler[side].deployers.setOutput("front", not state)
end

local function setAllDeployers(state)
    setDeployer("left", state)
    setDeployer("middle", state)
    setDeployer("right", state)
end

-- Pump Controls: true = pump on, false = pump off.
local function setPump(side, state)
    -- side.setOutput("left", not state)
    boiler[side].pumps.setOutput("left", not state)
    print(side, "set to", state)
end
local function setAllPumps(state)
    for k, v in pairs(boiler) do
        setPump(k, state)
    end
end

local function getActiveCount()
    local count = 0
    for _, side in ipairs(START_ORDER) do
        if boiler[side].active then
            count = count + 1
        end
    end
    return count
end

local function saveState()
    local payload = {
        desiredLevel = desiredLevel
    }
    local h = fs.open(STATE_FILE, "w")
    if h then
        h.write(textutils.serialize(payload))
        h.close()
    end
end

local function loadState()
    if not fs.exists(STATE_FILE) then
        return nil
    end

    local h = fs.open(STATE_FILE, "r")
    if not h then
        return nil
    end

    local text = h.readAll()
    h.close()
    local parsed = textutils.unserialize(text)
    if type(parsed) == "table" and type(parsed.desiredLevel) == "number" then
        return math.max(0, math.min(3, math.floor(parsed.desiredLevel)))
    end
    return nil
end

local function setPumpSpeed(level)
    local target = speeds[level] or 0
    if not pumpSpeedController then
        return
    end

    if pumpSpeedController.setTargetSpeed then
        pcall(function() pumpSpeedController.setTargetSpeed(target) end)
    elseif pumpSpeedController.setSpeed then
        pcall(function() pumpSpeedController.setSpeed(target) end)
    end
end

local function toggleBoiler(side, state)
    if not boiler[side] then
        return false
    end
    setPump(side, state)
    setDeployer(side, state)
    boiler[side].active = state
    return true
end

-- Main Clutch Controls: true = clutch engaged, false = clutch disengaged.
local function connectClutch(state)
    mainClutch.setOutput("top", not state)
end

local function getStatus()
    for side, v in pairs(boiler) do
        v.active = not v.pumps.getOutput("left")
        print(side, v.active)
    end
    numBoilersActive = getActiveCount()
end

local function choke()
    desiredLevel = 0
    setAllDeployers(false)
    setAllPumps(false)
    connectClutch(true)
    boiler.left.active = false
    boiler.middle.active = false
    boiler.right.active = false
    numBoilersActive = 0
    setPumpSpeed(0)
    saveState()
end

local function applyLevel(level)
    local clamped = math.max(0, math.min(3, math.floor(level or 0)))

    if clamped == 0 then
        choke()
        return
    end

    desiredLevel = clamped
    for i, side in ipairs(START_ORDER) do
        local shouldBeActive = i <= clamped
        toggleBoiler(side, shouldBeActive)
    end

    numBoilersActive = getActiveCount()
    setPumpSpeed(numBoilersActive)
    saveState()
end

local function kickstart()
    if kickstartInProgress then
        return
    end

    kickstartInProgress = true
    print("kickstarting")

    connectClutch(false)
    setAllDeployers(false)
    setAllPumps(false)
    boiler.left.active = false
    boiler.middle.active = false
    boiler.right.active = false

    setDeployer("right", true)
    redstone.setOutput("right", true)
    sleep(2)
    setPump("right", true)
    setDeployer("right", true)
    boiler.right.active = true
    sleep(4)
    redstone.setOutput("right", false)
    connectClutch(true)

    numBoilersActive = getActiveCount()
    setPumpSpeed(numBoilersActive)
    kickstartInProgress = false
end

local function ensureLevel(level)
    local clamped = math.max(0, math.min(3, math.floor(level or 0)))
    desiredLevel = clamped

    if clamped == 0 then
        choke()
        return
    end

    if not boiler.right.active then
        kickstart()
    end

    applyLevel(clamped)
end

local function parseLegacyTarget(target, value)
    if type(target) ~= "string" or type(value) ~= "boolean" then
        return nil
    end

    if value then
        if target == "right" then return 1 end
        if target == "middle" then return 2 end
        if target == "left" then return 3 end
        return nil
    end

    if target == "left" then return 2 end
    if target == "middle" then return 1 end
    if target == "right" then return 0 end
    return nil
end

local function commandlistener()
    print("listening for on network 'boilers'... ")
    while true do
        local id, message = rednet.receive("boilerProtocol")
        if type(message) ~= "table" or type(message.action) ~= "string" then
            print("ignored malformed packet from", id)
        elseif message.action == "kickstart" then
            kickstart()
            applyLevel(desiredLevel)
        elseif message.action == "choke" then
            choke()
        elseif message.action == "set_level" then
            ensureLevel(message.level)
        elseif message.action == "toggle" then
            local mappedLevel = parseLegacyTarget(message.target, message.value)
            if mappedLevel ~= nil then
                ensureLevel(mappedLevel)
            else
                print("ignored invalid toggle packet from", id)
            end
        elseif message.action == "query" then
            -- no-op; telemetry loop is already periodic broadcast
        else
            print("unknown action", message.action)
        end
    end
end

local function loop()
    while true do
        local stress = 0
        local stressCap = 0
        if stressometer then
            stress = stressometer.getStress() or 0
            stressCap = stressometer.getStressCapacity() or 0
        end

        numBoilersActive = getActiveCount()
        local packet = {
            version = 1,
            desired_level = desiredLevel,
            actual_level = numBoilersActive,
            controller_state = {
                kickstart = kickstartInProgress
            },
            stress = stress,
            stressCap = stressCap,
            data_stress = {
                stress = stress,
                stressCap = stressCap
            }, 
            active_boilers = {
                left = boiler.left.active,
                middle = boiler.middle.active,
                right = boiler.right.active
            }
        }
        rednet.broadcast(packet, "statusProtocol")
        sleep(0.5)
    end
end

getStatus()
local savedLevel = loadState()
if savedLevel ~= nil then
    ensureLevel(savedLevel)
else
    desiredLevel = numBoilersActive
    saveState()
end

parallel.waitForAny(
    commandlistener, loop
)

