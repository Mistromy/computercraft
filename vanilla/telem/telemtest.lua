local telem = require 'telem'
local env = require 'secrets'
local mon = peripheral.find("monitor")
mon.setTextScale(0.5)
local monw, monh = mon.getSize()
local win = window.create(mon, 1, 1, monw, monh)

local backplane = telem.backplane()

local hello_in = telem.input.helloWorld(123)

local hello_out = telem.output.helloWorld()

local chest = peripheral.find("minecraft:chest")

local authGrafana = {
    endpoint = env.endpoint,
    apiKey = env.test_token
}

local backplane = telem.backplane()
    :addInput("chest", telem.input.itemStorage("right"))
    :addOutput("graph1", telem.output.plotter.line(win, "storage:minecraft:redstone", colors.black, colors.yellow))
    :addOutput("influxdb", telem.output.grafana(authGrafana.endpoint, authGrafana.apiKey))

parallel.waitForAny(
    backplane:cycleEvery(0.25)
)