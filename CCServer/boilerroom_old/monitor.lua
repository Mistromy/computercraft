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
peripheral.find("modem", rednet.open)

local tube = peripheral.find("Create_NixieTube")

local backplane = telem.backplane()
    :addInput("custom_short", telem.input.custom(function()
        return {
            custom_short_1 = currentStress,
            custom_short_2 = stressCap,
            custom_short_3 = 0
        }
    end))
    :addOutput("stress", telem.output.plotter.multiLine(win, {
        {name = "custom_short_1", color = colors.green },
        {name = "custom_short_2", color = colors.red },
        {name = "custom_short_3", color = colors.black }
    }, colors.black, colors.yellow))
    -- :addOutput("influxdb", telem.output.grafana(authGrafana.endpoint, authGrafana.apiKey))


local function getStress()
    while true do
        local id, stress_data = rednet.receive("statusProtocol")
        if type(stress_data) == "table" then
            currentStress = stress_data.stress or (stress_data.data_stress and stress_data.data_stress.stress) or 0
            stressCap = stress_data.stressCap or (stress_data.data_stress and stress_data.data_stress.stressCap) or 0
        end
    end
end

local function displayValue(value)
    local fullString = string.format("%06d", value)
    print(fullString)

    tube.setText(fullString)
end

local function runNixies()
    while true do
        displayValue(currentStress)
        sleep(0.5)
    end
end

parallel.waitForAny(
    backplane:cycleEvery(0.5), getStress, runNixies
)

-- Nikie Tubes: left:2, middle:1, right:0

