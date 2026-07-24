local utils = require("pkg.utils")
local inTable = utils.inTable
local getItemCount = utils.getItemCount

local startup = require("pkg.startup")
local setup = require("pkg.setup")

local mainsetup = require("internal.main.setup")
local waitForConfirmation = mainsetup.waitForConfirmation
local listenForBoilers = mainsetup.listenForBoilers

local display = peripheral.find("Create_DisplayLink")
local vault = peripheral.wrap("create:item_vault_0")
local boilerProtocol = ""
local boilers = {}
peripheral.find("modem", rednet.open)


local config = startup.loadConfig()
boilerProtocol = config.boilerProtocol or ""
boilers = config.boilers or {}

local isFirstRun = startup.init(...)

if isFirstRun or not fs.exists("config.json") then
    boilerProtocol = setup.standardSetup()
    boilers = {}
  
    parallel.waitForAny(
        waitForConfirmation,
        function() mainsetup.listenForBoilers(boilers)  end
    )
    local configdata = {
        boilerProtocol = boilerProtocol,
        boilers = boilers
    }

    setup.writeConfig(configdata)
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