turtle.refuel(1000)
local fuel = turtle.getFuelLevel()
if fuel < 100 then
    print("Low on fuel.")
end
local origin = {x=0, y=0, z=0}
local currentPos = {x=0, y=0, z=0}

local scanner = peripheral.find("universal_scanner")
local radius = 8

local function resetRot()
    while direction > 1 do
        turtle.turnLeft()
        direction = direction - 1
    end
end
print("resetRot initialized")
local function scan()
    local scanData = scanner.scan("block", radius)
    sleep(1.5)
    for _, block in ipairs(scanData) do
        if block.x == 0 then
            if block.name == "minecraft:ancient_debris" then
                x = block.x
                y = block.y
                z = block.z
                direction = 1

                if x < 0 then
                    turtle.turnRight()
                    turtle.turnRight()
                    direction = direction + 2
                    x = -x
                end

                for i = 1, x do
                   turtle.dig()
                   turtle.forward()
                   if direction == 1 then
                        currentPos.x = currentPos.x + 1
                    elseif direction == 3 then
                        currentPos.x = currentPos.x - 1
                    end
                end

                if y > 0 then
                    for i = 1, y do
                        turtle.digUp()
                        turtle.up()
                        currentPos.y = currentPos.y + 1
                    end
                else
                    for i = 1, -y do
                        turtle.digDown()
                        turtle.down()
                        currentPos.y = currentPos.y - 1
                    end
                end

                resetRot()

                turtle.turnRight()
                direction = direction + 1

                if z < 0 then
                    turtle.turnRight()
                    turtle.turnRight()
                    direction = direction + 2
                    z = -z
                end

                for i = 1, z do
                   turtle.dig()
                   turtle.forward()
                   if direction == 2 then
                        currentPos.z = currentPos.z + 1
                    elseif direction == 4 then
                        currentPos.z = currentPos.z - 1
                    end
                end
                turtle.dig()
                resetRot()
            end
        end
    end
end
print("scan initialized")

local function distance()
    return math.abs(currentPos.x - origin.x) + math.abs(currentPos.y - origin.y) + math.abs(currentPos.z - origin.z)
end
print ("distance initialized")

local function returnhome()
    x = currentPos.x - origin.x
    y = currentPos.y - origin.y
    z = currentPos.z - origin.z

    direction = 1

    if x < 0 then
        turtle.turnRight()
        turtle.turnRight()
        direction = direction + 2
        x = -x
    end

    for i = 1, x do
       turtle.dig()
       turtle.forward()
    end

    if y > 0 then
        for i = 1, y do
            turtle.digUp()
            turtle.up()
        end
    else
        for i = 1, -y do
            turtle.digDown()
            turtle.down()
        end
    end

    resetRot()

    turtle.turnRight()
    direction = direction + 1

    if z < 0 then
        turtle.turnRight()
        turtle.turnRight()
        direction = direction + 2
        z = -z
    end

    for i = 1, z do
       turtle.dig()
       turtle.forward()
    end
    turtle.dig()
    resetRot()

end


local function returntick()
    fuel = turtle.getFuelLevel()
    if distance() > fuel * 2 + 100 then
        returnhome()
    end
end

while true do -- Spiral Movement Outwards Loop. Distance between spiral arms is radius * 2 = 16
    turtle.dig()
    turtle.forward()
    currentPos.x = currentPos.x + 1
    scan()
    returntick()
    print("Current Position: (" .. currentPos.x .. ", " .. currentPos.y .. ", " .. currentPos.z .. ")")
end
