turtle.refuel(1000)
local fuel = turtle.getFuelLevel()
if fuel < 100 then
    print("Low on fuel.")
end
local origin = {x=0, y=0, z=0}
local currentPos = {x=0, y=0, z=0}
local direction = 1 -- 1: forward/positive X, 2: right, 3: back, 4: left

local targetLocation = nil
local targetDistance = math.huge
local scanner = peripheral.find("universal_scanner")
local radius = 8
print("Scanning at radius " .. radius)

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
    if block.name == "minecraft:ancient_debris" then
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


local function gototarget(target)
    local x, y, z = target.x, target.y, target.z
    if z > 0 then
        rotateTo(2)
        for i = 1, z do
            turtle.dig()
            turtle.forward()
            currentPos.z = currentPos.z + 1
        end
    end
end



while true do
    local target, dist = findNearest()

end