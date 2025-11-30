peripheral.find("modem", rednet.open)

local basalt = require("basalt")
local main = basalt.getMainFrame()

main:addButton()
    :setText("Open Door")
    :setPosition(1,1)
    :onClick(function(self)
        self:setText("Opening...")
        rednet.send(7, "open")
        sleep(1)
        self:setText("Open Door")
    end)

main:addButton()
    :setText("Close Door")
    :setPosition(1,4)
    :onClick(function(self)
        self:setText("Closing...")
        rednet.send(1, "close")
        sleep(1)
        self:setText("Close Door")
    end)


