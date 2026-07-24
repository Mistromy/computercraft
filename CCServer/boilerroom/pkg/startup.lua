local startup = {}

function startup.init(...)
    local args = { ... }
    local isFirstRun = false
    for i, arg in ipairs(args) do
        if arg == "-n" or arg == "--new" then
            isFirstRun = true
            break
        end
    end    
    return isFirstRun
end

function startup.loadConfig()
    if not fs.exists("config.json") then
        return {}
    end

    local file = fs.open("config.json", "r")
    local jsonString = file.readAll()
    file.close()

    return textutils.unserializeJSON(jsonString) or {}
end

return startup