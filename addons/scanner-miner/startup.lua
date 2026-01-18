local scanner = peripheral.find("universal_scanner")
local chunkloader = peripheral.find("chunkloader")
local radius = 8
local targetBlock = "minecraft:ancient_debris"
turtle.refuel(1000)
local fuel = turtle.getFuelLevel()
local localcoords = {x = 0, y = 0, z = 0}
local hasChest = false
local targetBlocks = {}
if not scanner then
    print("No universal scanner found. Please attach a universal scanner peripheral.")
    return
end
-- if not chunkloader then
--     print("No chunkloader found. Please attach a chunkloader peripheral.")
--     return
-- end

if fuel < 1000 then
    print("Not enough fuel. turtle needs at least 1000 fuel.")
    print("Current fuel level: " .. fuel .. ".")
    return
end

local chest = peripheral.find("minecraft:chest")
if chest then
    chest = peripheral.wrap("back")
    if chest then
        hasChest = true
    else
        print("Please put the chest behind the turtle.")
    end
else
    print("No chest found. Place a chest behind the turtle.")
end


print("Starting miner...")
print("Fuel level: " .. fuel .. ".")
print("Scan Radius: " .. radius .. ".")
print("Target: " .. targetBlock .. ".")
print("Has Chest: " .. tostring(hasChest) .. ".")

-- local targetBlocksNumber = 0

-- local function scanForBlocks()
--     local scanResult = scanner.scan("block", radius)
--     for _, block in ipairs(scanResult) do
--         if block.name == targetBlock then
--             table.insert(targetBlocks, block)
--             targetBlocksNumber = targetBlocksNumber + 1
--         end
-- end

-- local function getManhattanDistance(coords)
--     return math.abs(coords.x) + math.abs(coords.y) + math.abs(coords.z)
-- end

-- local function sortByDistance(a, b)
    
-- end

-- local function moveToTarget(target)
--     for _, target.x do

-- end

local spiralsidemultiplier = 1
while true do -- Spiral Movement Outwards Loop. Distance between spiral arms is radius * 2 = 16
    -- scan()
    for _ = 1, 2 do
        for _ = 1, spiralsidemultiplier do
            for _ = 1, radius * 2 do
                turtle.forward()
            end
        end
        turtle.turnLeft()
    end  
spiralsidemultiplier = spiralsidemultiplier + 1
end 

