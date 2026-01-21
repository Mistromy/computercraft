turtle.refuel(1000)
local scanner = peripheral.find("universal_scanner")
local startfuel = turtle.getFuelLevel()
if not scanner then
    print("No universal scanner found.")
    return
end
print ("Fuel level before tests: " .. startfuel .. ".")
for radius = 8, 16 do
    local fuelBefore = turtle.getFuelLevel()
    scanner.scan("block", radius)
    local fuelAfter = turtle.getFuelLevel()
    local fuelCost = fuelBefore - fuelAfter
    
    print("Radius " .. radius .. ": " .. fuelCost .. " fuel")
end
local endfuel = turtle.getFuelLevel()
print ("Fuel level after tests: " .. endfuel .. ".")