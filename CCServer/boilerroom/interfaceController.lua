peripheral.find("modem", rednet.open)
local boilerProtocol = ""

local args = { ... }

local isFirstRun = false

local display = peripheral.find("Create_DisplayLink")
local vault = peripheral.wrap("create:item_vault_0")

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

if isFirstRun then
    print("=== First-Time Setup Sequence ===")
    print("Welcome to the setup manager.")

    write("Enter Boiler Protocol Name\nor press Enter to skip: ")
    input = read()
    if input == "" then
        print("Skipped.")
    else
        boilerProtocol = input
        print("Boiler Protocol Name set to: " .. boilerProtocol)
        
        local data = {
            boilerProtocol = boilerProtocol
        }
        local jsonString = textutils.serializeJSON(data)
        local file = fs.open("config.json", "w")
        file.write(jsonString)
        file.close()
    end
end
shell.run("clear")
print("Booting system...")
print("Boiler Protocol: " .. boilerProtocol)



print("shutting down in 4 seconds...")
sleep(4)
os.shutdown()