x = 3
y = 2
z = 8
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
    turtle.forward()
end

if y > 0 then
    for i = 1, y do
        turtle.up()
    end
else
    for i = 1, -y do
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
    turtle.forward()
end

resetRot()