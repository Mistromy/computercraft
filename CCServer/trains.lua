local station = peripheral.wrap("top")

local function setStation(name)
    local schedule = station.getSchedule()
    schedule.entries[3].instruction.data.text = name

    station.setSchedule(schedule)
    print("Set station to " .. name)
end
while true do
    if station.isTrainPresent() then
        if redstone.getInput("back") then
            setStation("FStation")
            sleep(1.5)
        end
        if redstone.getInput("left") then 
            setStation("Nik Station")
            sleep(1.5)
        end
        if redstone.getInput("right") then 
            setStation("RaidFarm")
            sleep(1.5)
        end
    end
    sleep(0.2)
end