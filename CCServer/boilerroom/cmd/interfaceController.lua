peripheral.find("modem", rednet.open)

local args = { ... }

local startup = require("pkg.startup")
local setup = require("pkg.setup")
local graph = require("pkg.graph")

local config = startup.loadConfig()
boilerProtocol = config.boilerProtocol or ""

local isFirstRun = startup.init(...)

if isFirstRun or not fs.exists("config.json") then
    boilerProtocol = setup.standardSetup()
    local configdata = {
        boilerProtocol = boilerProtocol
    }
    setup.writeConfig(configdata)
end

shell.run("clear")
print("Booting system...")
print("Boiler Protocol: " .. boilerProtocol)

local function leverPosLoop()
    while true do
        leverpos = redstone.getAnalogInput("top")
        rednet.broadcast({type = "leverpos", pos = leverpos}, boilerProtocol)
        sleep(0.5)
    end
end


parallel.waitForAny(leverPosLoop, function() if peripheral.find("monitor") then graph.run(boilerProtocol) end end)