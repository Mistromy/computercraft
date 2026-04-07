local telem = require 'telem'
local env = require 'secrets'
local mon = peripheral.find("monitor")
mon.setTextScale(0.5)
local monw, monh = mon.getSize()
local win = window.create(mon, 1, 1, monw, monh)

local backplane = telem.backplane()

local hello_in = telem.input.helloWorld(123)

local hello_out = telem.output.helloWorld()

local authGrafana = {
    endpoint = env.endpoint,
    apiKey = env.test_token
}

local currentStress = 0
local stressCap = 0
if peripheral.find("modem", rednet.open) then
    print("Rednet modem found and opened.")
else
    print("No rednet modem found. Please connect one to receive stress data.")
end


local backplane = telem.backplane()
    :addInput("custom_short", telem.input.custom(function()
        return {
            custom_short_1 = currentStress,
            custom_short_2 = stressCap
        }
    end))
    :addOutput("stress", telem.output.plotter.line(win, "custom_short", colors.black, colors.yellow))
    -- :addOutput("influxdb", telem.output.grafana(authGrafana.endpoint, authGrafana.apiKey))


local function getStress()
    while true do
        local id, stress_data = rednet.receive("stressProtocol")
        currentStress = stress_data.stress or 0
        stressCap = stress_data.stressCap or 0
    end
end

parallel.waitForAny(
    backplane:cycleEvery(0.5), getStress
)