turtle.refuel(100)

local scanner = peripheral.find("universal_scanner")
local radius = 8

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

                local function resetRot()
                    while direction > 1 do
                        turtle.turnLeft()
                        direction = direction - 1
                    end
                end

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
        end
    end
end


while true do -- Spiral Movement Outwards Loop. Distance between spiral arms is radius * 2 = 16
    turtle.dig()
    turtle.forward()
    scan()
end
