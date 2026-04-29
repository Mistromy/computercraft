while true do
    local _, inspect = turtle.inspect()
    if inspect.name == "ae2:quartz_cluster" then
        turtle.dig()
    end
    sleep(2)
end