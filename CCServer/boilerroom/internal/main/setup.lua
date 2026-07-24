local setup = {}

local utils = require("pkg.utils")
local inTable = utils.inTable


function setup.listenForBoilers(boilers)
    print("Enable all boiler modems one by one.")
    while true do
        local _, peripheralName = os.pullEvent("peripheral")
        if not inTable(boilers, peripheralName) then
            table.insert(boilers, peripheralName)
            print("Boiler added: " .. peripheralName)
        end
    end
end

function setup.waitForConfirmation()
    while true do
        write("Type 'y' when finished: ")
        local confirm = string.lower(read())
        if confirm == "y" then
            break
        end
    end
end

return setup