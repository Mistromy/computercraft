print("in order for the computer to know which boiler is which, after connecting all boilers up, you will have to enable each modem one by one.")
print("that is the order in which the computer will remember them, and the order of the startup sequence.")

print("Enable all boiler modems one by one.")
local function listenForBoilers()
    while true do
        local event, peripheralName = os.pullEvent("peripheral")
        if not inTable(boilers, peripheralName) then
            table.insert(boilers, peripheralName)
        end
    end
end
local function waitForConfirmation()
    while true do
        write("Type 'y' when finished: ")
        local confirm = string.lower(read())
        if confirm == "y" then
            break
        end
    end
end
parallel.waitForAny(waitForConfirmation, listenForBoilers)
