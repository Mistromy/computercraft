turtle.refuel(1000)
local fuel = turtle.getFuelLevel()
if fuel < 100 then
    print("Low on fuel.")
end
local origin = {x=0, y=0, z=0}
local currentPos = {x=0, y=0, z=0}

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

local function findNearest()
    local scanData = scanner.scan("block", radius)
    sleep(1.5) -- Give Scanner time to process
    for _, block in ipairs(scanData) do
        if block.x == 0 then
            if block.name == "minecraft:ancient_debris" then
                location = {x=block.x, y=block.y, z=block.z}
                distance = ManhattanDistance(location)
                if distance < targetDistance then
                    targetLocation = location
                    targetDistance = distance
                end
            end
        end
    end
    print("Found Ancient Debris at " .. targetLocation.x .. ", " .. targetLocation.y .. ", " .. targetLocation.z .. " (Distance: " .. targetDistance .. ")")
return targetLocation, targetDistance
end