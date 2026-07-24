local args = { ... }
local isFirstRun = false

local display = peripheral.find("Create_DisplayLink")
local vault = peripheral.wrap("create:item_vault_0")
local boilerProtocol = ""
local boilers = {}
peripheral.find("modem", rednet.open)

if fs.exists("config.json") then
    local file = fs.open("config.json", "r")
    local jsonString = file.readAll()
    file.close()
    local data = textutils.unserializeJSON(jsonString)
    boilerProtocol = data.boilerProtocol or ""
    boilers = data.boilers or {}
end


for i, arg in ipairs(args) do
    if arg == "-n" or arg == "--new" then
        isFirstRun = true
        break
    end
end

--- Get total count for a single item ID
-- @param container table: The peripheral handle (e.g., vault)
-- @param itemName string: The item registry name (e.g., "minecraft:diamond")
-- @return number: The total count of that item
local function getItemCount(container, itemName)
    local rawData = container.items()
    local total = 0

    for _, item in pairs(rawData) do
        if item and item.name == itemName then
            total = total + item.count
        end
    end

    return total
end

local function inTable(tbl, item)
    for _, val in ipairs(tbl) do
        if val == item then return true end
    end
    return false
end

if isFirstRun then
    print("=== First-Time Setup Sequence ===")
    print("Welcome to the setup manager.")
    print("in order for the computer to know which boiler is which, after connecting all boilers up, you will have to enable each modem one by one.")
    print("that is the order in which the computer will remember them, and the order of the startup sequence.")

    write("Enter Boiler Protocol Name\nor press Enter to skip: ")
    local input = read()
    if input == "" then
        print("Skipped.")
    else
        boilerProtocol = input
        print("Boiler Protocol Name set to: " .. boilerProtocol)

    end

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


    local configData = {
        boilerProtocol = boilerProtocol,
        boilers = boilers
    }
    local jsonString = textutils.serializeJSON(configData)
    local file = fs.open("config.json", "w")
    file.write(jsonString)
    file.close()

    print("[✓] Configuration saved to config.json!")
    sleep(1.5)
end



local stressometer = peripheral.wrap("Create_Stressometer_2")

local function displayLoop()
    while true do
        local cobble = getItemCount(vault, "minecraft:cobblestone")
        local stress = stressometer.getStressCapacity() - stressometer.getStress()
        if cobble ~= oldcobble or leverpos ~= oldleverpos then
            display.clear()
            display.setCursorPos(1, 1)
            display.write("cob:  " .. string.format("%d", cobble))
            display.setCursorPos(1, 2)
            display.write("fuel: " .. string.format("%d", cobble / 160))
            display.setCursorPos(1, 3)
            display.write("lvl:  " .. string.format("%d", leverpos))
            display.setCursorPos(1, 4)
            display.write("strs: " .. string.format("%d", stress))
            display.update()
            oldcobble = cobble
            oldleverpos = leverpos
        end
        sleep(2.5)
    end
end


local function rednetLoop()
    while true do
        _, leverpos = rednet.receive(boilerProtocol)
    end
end


shell.run("clear")
print("Booting system...")
print("Protocol: " .. boilerProtocol)
print("Boilers: " .. table.concat(boilers, ", "))

leverpos = 0
parallel.waitForAny(displayLoop, rednetLoop)