local setup = {}

local utils = require("pkg.utils")
local inTable = utils.inTable


function setup.listenForBoilers(boilers)
    while true do
        local _, peripheralName = os.pullEvent("peripheral")
        if not inTable(boilers, peripheralName) then
            table.insert(boilers, peripheralName)
            print("\nBoiler added: " .. peripheralName)
            write("type 'y' when finished: ")
        end
    end
end

function setup.waitForConfirmation()
    print("Enable all boiler modems one by one.")
    while true do
        write("Type 'y' when finished: ")
        local confirm = string.lower(read())
        if confirm == "y" then
            break
        end
    end
end

return setup