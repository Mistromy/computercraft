peripheral.find("modem", rednet.open)
local boilerProtocol = ""

local args = { ... }

local isFirstRun = false

local display = peripheral.find("Create_DisplayLink")
local vault = peripheral.wrap("create:item_vault_0")

for i, arg in ipairs(args) do
    if arg == "-n" or arg == "--new" then
        isFirstRun = true
        break
    end
end

if isFirstRun then
    print("=== First-Time Setup Sequence ===")
    print("Welcome to the setup manager.")
    print("")

    write("Enter Boiler Protocol Name: ")
    boilerProtocol = read()
    print("Boiler Protocol Name set to: " .. boilerProtocol)
else
    print("Booting system...")
    print("shutting down in 4 seconds...")
    sleep(4)
    os.shutdown()
end