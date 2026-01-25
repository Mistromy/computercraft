

local hub = peripheral.find("netherite_peripheraleum_hub")
hub.equip(1)
hub.equip(2)
hub.equip(3)
local sensor = peripheral.find("ultimate_sensor")
local chunkloader = peripheral.find("chunkloader")
local scanner = peripheral.find("universal_scanner")
local radius = 16
local targetBlock = "minecraft:ancient_debris"
turtle.refuel(1000)
local fuel = turtle.getFuelLevel()
local localcoords = {x = 0, y = 0, z = 0}
local origin = gps.locate()
local globalcoords = origin
local hasChest = false
local rotation = sensor.inspect("orientation")

local missing = {}
if not scanner then table.insert(missing, "universal_scanner") end
if not sensor then table.insert(missing, "ultimate_sensor") end
if not chunkloader then table.insert(missing, "chunkloader") end
if #missing > 0 then
  print("Missing peripherals! " .. table.concat(missing, ", "))
  print("Please place a Universal scanner, Ultimate sensor, and Chunkloader in the 3 first slots.")
  return
end

print("Connecting to server")
local wsURL = "ws://micro.mista.tech:8080/ws/commander"
local ws = http.websocket(wsURL)
if not ws then 
    print("Failed to connect to server at " .. wsURL)
    return
end
print("Successfully Connected to: " .. wsURL)

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

local function scan()
    local globalcoords, success = gps.locate()
    if not success then
        print("Error: No GPS signal!")
        return
    end
    local scanResults = scanner.scan("block", radius)
    local targetBlocks = {}
    for _, blockData in ipairs(scanResults) do
        if blockData.name == targetBlock then
            table.insert(targetBlocks, blockData)
        end
    end
end



local spiralsidemultiplier = 1
while true do -- Spiral Movement Outwards Loop. Distance between spiral arms is radius * 2 = 16
    for _ = 1, 2 do
        for _ = 1, spiralsidemultiplier do
            for _ = 1, radius * 2 do
                turtle.forward()
            end
            scan()
        end
        turtle.turnLeft()
    end  
spiralsidemultiplier = spiralsidemultiplier + 1
end