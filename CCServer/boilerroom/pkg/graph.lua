local graph = {}

function graph.run(boilerProtocol)
    local telem = require 'telem'
    local mon = peripheral.find("monitor")
    mon.setTextScale(0.5)
    local monw, monh = mon.getSize()
    local win = window.create(mon, 1, 1, monw, monh)

    local backplane = telem.backplane()

    local hello_in = telem.input.helloWorld(123)

    local hello_out = telem.output.helloWorld()

    local currentStress = 0
    local stressCap = 0
    peripheral.find("modem", rednet.open)

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
            local _, msg = rednet.receive(boilerProtocol)
            if msg.type == "stress_telem" then
                currentStress = msg.stress or  0
                stressCap = msg.stressCap or 0
            end
        end
    end

    parallel.waitForAny(
        backplane:cycleEvery(0.25), getStress
    )
end
return graph