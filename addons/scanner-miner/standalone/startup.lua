turtle.refuel(1000)
local fuel = turtle.getFuelLevel()
local initialFuel = fuel
if fuel < 1000 then
    print("Low on fuel. " .. fuel .. " remaining.")
    return
end
print ("Fuel level: " .. fuel)
local origin = {x=0, y=0, z=0}
local currentPos = {x=0, y=0, z=0}
local direction = 1 -- 1: forward/positive X, 2: right, 3: back, 4: left

local desiredBlock = "minecraft:ancient_debris"
print("Mining for: " .. desiredBlock)

local targetLocation = nil
local targetDistance = math.huge
local scanner = peripheral.find("universal_scanner")
if not scanner then
    print("No scanner found. Please attach a universal scanner.")
    return
end
local radius = 8
print("Scanning at radius " .. radius)

if not peripheral.find("ender_modem") or not peripheral.find("wireless_modem") then
    print("No Modem found. Might cause issues in the future.")
end

local function resetRot()
    while direction > 1 do
        turtle.turnLeft()
        direction = direction - 1
    end
end

-- Direction Cheatsheet: forward: 1. right: 2. back: 3. left: 4.

local function ManhattanDistance(pos1, pos2)
    if not pos2 then pos2 = {x=0, y=0, z=0} end
    return math.abs(pos1.x - pos2.x) + math.abs(pos1.y - pos2.y) + math.abs(pos1.z - pos2.z)
end

local function filterBlocks(block)
    if block.name == desiredBlock then
        local location = {x=block.x, y=block.y, z=block.z}
        local distance = ManhattanDistance(location)
        if distance < targetDistance then
            targetLocation = location
            targetDistance = distance
        end
    end
end

local function findNearest()
    targetDistance = math.huge
    targetLocation = nil
    local scanData = scanner.scan("block", radius)
    sleep(1.5) -- Give Scanner time to process
    for _, block in ipairs(scanData) do
        if direction == 1 or direction == 3 then
            if block.x == 0 then
                filterBlocks(block)
            end
        else
            if block.z == 0 then
                filterBlocks(block)
            end
        end
    end
    if targetLocation then
        print("Nearest Debris: " .. targetLocation.x .. ", " .. targetLocation.y .. ", " .. targetLocation.z .. " (Dist: " .. targetDistance .. ")")
        return targetLocation, targetDistance
    else
        print("No debris found.")
        return nil, nil
    end
end

local function localToGlobal(pos)
    local globalX, globalY, globalZ = pos.x, pos.y, pos.z
    if direction == 1 then
        globalX = currentPos.x + pos.x
        globalZ = currentPos.z + pos.z
    elseif direction == 2 then
        globalX = currentPos.x - pos.z
        globalZ = currentPos.z + pos.x
    elseif direction == 3 then
        globalX = currentPos.x - pos.x
        globalZ = currentPos.z - pos.z
    elseif direction == 4 then
        globalX = currentPos.x + pos.z
        globalZ = currentPos.z - pos.x
    end
    return {x=globalX, y=currentPos.y + pos.y, z=globalZ}
end

local function rotateTo(target)
    if target - direction == 2 or direction - target == 2 then
        turtle.turnRight()
        turtle.turnRight()
        direction = target
    elseif direction - target == 1 or direction - target == -3 then
        turtle.turnLeft()
        direction = target
    elseif direction - target == -1 or direction - target == 3 then
        turtle.turnRight()
        direction = target
    end
end

local function safeForward()
    while turtle.detect() do
        turtle.dig()
    end
    turtle.forward()
    if direction == 1 then
        currentPos.x = currentPos.x + 1
    elseif direction == 2 then
        currentPos.z = currentPos.z + 1
    elseif direction == 3 then
        currentPos.x = currentPos.x - 1
    elseif direction == 4 then
        currentPos.z = currentPos.z - 1
    end
end

local function safeUp()
    while turtle.detectUp() do
        turtle.digUp()
    end
    turtle.up()
    currentPos.y = currentPos.y + 1
end

local function gototarget(target)
    local x, y, z = target.x, target.y, target.z
    if z > 0 then
        rotateTo(2)
        for i = 1, z do
            safeForward()
        end
    elseif z < 0 then
        rotateTo(4)
        for i = 1, -z do
            safeForward()
        end
    end
    if y > 0 then
        for i = 1, y do
            turtle.digUp()
            safeUp()
        end
    elseif y < 0 then
        for i = 1, -y do
            turtle.digDown()
            turtle.down()
            currentPos.y = currentPos.y - 1
        end
    end
end

local function goBack()
    rotateTo(3)
     for i = 1, currentPos.x do
        safeForward()
    end
    rotateTo(4)
    for i = 1, currentPos.z do
        safeForward()
    end
    rotateTo(2)
    for i = 1, currentPos.y do
        turtle.digDown()
        turtle.down()
    end
end

while true do
    local target, dist = findNearest()
    while target do
        gototarget(target)
        turtle.dig()
        target, dist = findNearest()
        safeForward()
    end
    rotateTo(1)
    turtle.dig()
    safeForward()
    fuel = turtle.getFuelLevel()
    if fuel < initialFuel * 0.4 then
        goBack()
        return
    end
end
