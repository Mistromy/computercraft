local setup = {}

function setup.standardSetup()
    print("=== First-Time Setup Sequence ===")
    print("Welcome to the setup manager.")
    
    write("Enter Boiler Protocol Name\nor press Enter to skip: ")
    local input = read()
    local boilerProtocol = ""
    if input == "" then
        print("Skipped.")
    else
        boilerProtocol = input
        print("Boiler Protocol Name set to: " .. boilerProtocol)

    end
    return boilerProtocol
end

function setup.writeConfig(configData)
    local jsonString = textutils.serializeJSON(configData)
    local file = fs.open("config.json", "w")
    file.write(jsonString)
    file.close()
end

return setup