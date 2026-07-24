local args = { ... }

local isFirstRun = false

local display = peripheral.find("Create_DisplayLink")
local vault = peripheral.wrap("create:item_vault_0")
local boilerProtocol = ""

if fs.exists("config.json") then
    local file = fs.open("config.json", "r")
    local jsonString = file.readAll()
    file.close()
    local data = textutils.unserializeJSON(jsonString)
    boilerProtocol = data.boilerProtocol or ""
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

if isFirstRun then
    print("=== First-Time Setup Sequence ===")
    print("Welcome to the setup manager.")
    print("in order for the computer to know which boiler is which, after connecting all boilers up, you will have to enable each modem one by one.")
    print("that is the order in which the computer will remember them, and the order of the startup sequence.")

    write("Enter Boiler Protocol Name\nor press Enter to skip: ")
    boilerProtocol = read()
    if boilerProtocol == "" then
        return
    else    
    print("Boiler Protocol Name set to: " .. boilerProtocol)
    
    local data = {
        boilerProtocol = boilerProtocol
    }
    local jsonString = textutils.serializeJSON(data)
    local file = fs.open("config.json", "w")
    file.write(jsonString)
    file.close()
    end

else
    print("Booting system...")
    print("Protocol: " .. boilerProtocol)
    while true do
        local cobble = getItemCount(vault, "minecraft:cobblestone")
        display.clear()
        display.setCursorPos(1, 1)
        display.write("Cob: " .. string.format("%d", cobble))
        display.setCursorPos(1, 2)
        display.write("fuel: " .. string.format("%d", cobble / 160))
        display.update()
        sleep(2.5)
    end
end