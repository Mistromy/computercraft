local function setup()
    print("=== First-Time Setup Sequence ===")
    print("Welcome to the setup manager.")
    
    write("Enter Boiler Protocol Name\nor press Enter to skip: ")
    local input = read()
    if input == "" then
        print("Skipped.")
    else
        boilerProtocol = input
        print("Boiler Protocol Name set to: " .. boilerProtocol)

    end

    local configData = {
        boilerProtocol = boilerProtocol,
        boilers = boilers
    }
    local jsonString = textutils.serializeJSON(configData)
    local file = fs.open("config.json", "w")
    file.write(jsonString)
    file.close()

    print("[✓] Configuration saved to config.json!")
    sleep(0.5)
end