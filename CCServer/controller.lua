peripheral.find("modem", rednet.open)

while true do
    os.pullEvent("redstone")
    if redstone.getInput("left") then
        rednet.broadcast("start", "boilers")
        while redstone.getInput("left") do sleep(0.2) end
    elseif redstone.getInput("right") then
        rednet.broadcast("choke", "boilers")
        while redstone.getInput("right") do sleep(0.2) end
    end

end