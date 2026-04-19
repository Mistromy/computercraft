local CONFIG = {
	channelProtocol = "xray_scan_v1",
	receiveTimeout = 10,
	boxColor = 0x40FF40AA,
}

local modules = peripheral.find("neuralInterface")
if not modules then
	error("Must have a neural interface", 0)
end

local function openWirelessModem()
	for _, name in ipairs(peripheral.getNames()) do
		if peripheral.getType(name) == "modem" then
			local modem = peripheral.wrap(name)
			if modem and modem.isWireless and modem.isWireless() then
				if not rednet.isOpen(name) then
					rednet.open(name)
				end
				return name
			end
		end
	end
	return nil
end

local modemName = openWirelessModem()
if not modemName then
	error("No wireless modem found for rednet.", 0)
end

print("xray head receiver ready")
print("modem: " .. modemName)
print("waiting for one packet: " .. CONFIG.channelProtocol)

local senderId, message = rednet.receive(CONFIG.channelProtocol, CONFIG.receiveTimeout)
if not senderId then
	error("Timed out waiting for xray packet", 0)
end

if type(message) ~= "table" or type(message.blocks) ~= "table" then
	error("Invalid packet format", 0)
end

local first = message.blocks[1]
if not first then
	error("Packet had no blocks to draw", 0)
end

local canvas3d = modules.canvas3d()
local root3d = canvas3d.create({ 0, 0, 0 })

-- One draw call MVP: place one 1x1x1 box at scanner-reported relative coords.
root3d.addBox(first.x, first.y, first.z, 1, 1, 1, CONFIG.boxColor)

print(string.format("drawn 1 block from sender %d at (%d, %d, %d)", senderId, first.x, first.y, first.z))
print("done")
