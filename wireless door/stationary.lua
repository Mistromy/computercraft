peripheral.find("modem", rednet.open)
print("wating....")

while true do
    local id, message = rednet.receive()
    print("Received message from " .. id .. ": " .. message)

    if message == "open" then
        print("Door is opening...")
        rs.setOutput("front", true)        
    elseif message == "close" then
        print("Door is closing...")
        rs.setOutput("front", false)        
    end
end