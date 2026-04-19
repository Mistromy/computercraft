local CONFIG = {
	channelProtocol = "xray_scan_v1",
	updateInterval = 1.25,
	boxColor = 0x40FF40AA,
	offset = { x = -0.6, y = -1.5, z = -0.65 },
	yawQuarterTurns = 0,
	renderThroughWalls = true,
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

local function tryMethod(obj, methodName, ...)
	if type(obj) ~= "table" then
		return false
	end

	local fn = obj[methodName]
	if type(fn) ~= "function" then
		return false
	end

	if pcall(fn, obj, ...) then
		return true
	end

	return pcall(fn, ...)
end

local canvas3d = modules.canvas3d()

local function clearAllStartup()
	tryMethod(canvas3d, "clear")
	local ok, root = pcall(canvas3d.create, { 0, 0, 0 })
	if ok and root then
		tryMethod(root, "clear")
		tryMethod(root, "remove")
	end
end

local function normalizeYaw(yaw)
	local y = yaw % 360
	if y < 0 then
		y = y + 360
	end
	return y
end

local function facingFromYaw(yaw)
	local y = normalizeYaw(yaw)
	if y >= 315 or y < 45 then
		return "south"
	elseif y < 135 then
		return "west"
	elseif y < 225 then
		return "north"
	end
	return "east"
end

local function rotateFromEastBaseline(x, z, facing)
	if facing == "east" then
		return x, z
	elseif facing == "south" then
		return -z, x
	elseif facing == "west" then
		return -x, -z
	elseif facing == "north" then
		return z, -x
	end
	return x, z
end

local function rotateQuarterTurns(x, z, turns)
	local t = turns % 4
	if t < 0 then
		t = t + 4
	end
	for _ = 1, t do
		x, z = -z, x
	end
	return x, z
end

local function getOwnerMeta()
	local ok, meta = pcall(modules.getMetaOwner)
	if not ok or type(meta) ~= "table" then
		return nil
	end
	return meta
end

local function getSubBlockComp(meta)
	if not meta then
		return 0, 0, 0
	end
	local px = tonumber(meta.x) or 0
	local py = tonumber(meta.y) or 0
	local pz = tonumber(meta.z) or 0
	local dx = (math.floor(px) + 0.5) - px
	local dy = math.floor(py) - py
	local dz = (math.floor(pz) + 0.5) - pz
	return dx, dy, dz
end

local function setDepthDisabled(obj)
	if not CONFIG.renderThroughWalls then
		return
	end
	tryMethod(obj, "setDepthTested", false)
	tryMethod(obj, "setDepthTest", false)
	tryMethod(obj, "setDepth", false)
	tryMethod(obj, "setDepthWrite", false)
end

local currentRoot = nil

local function clearCurrentRender()
	if currentRoot then
		tryMethod(currentRoot, "clear")
		tryMethod(currentRoot, "remove")
		currentRoot = nil
	end
end

local function drawPacket(message)
	if type(message) ~= "table" or type(message.blocks) ~= "table" then
		return
	end

	clearCurrentRender()

	local ownerMeta = getOwnerMeta()
	local ownerYaw = ownerMeta and tonumber(ownerMeta.yaw) or 0
	local ownerFacing = facingFromYaw(ownerYaw)
	local snapX, snapY, snapZ = getSubBlockComp(ownerMeta)

	local root = canvas3d.create({ 0, 0, 0 })
	setDepthDisabled(root)

	for _, block in ipairs(message.blocks) do
		local bx = block.x
		local by = block.y
		local bz = block.z

		bx, bz = rotateFromEastBaseline(bx, bz, ownerFacing)
		bx, bz = rotateQuarterTurns(bx, bz, CONFIG.yawQuarterTurns)

		local drawX = bx + CONFIG.offset.x + snapX
		local drawY = by + CONFIG.offset.y + snapY
		local drawZ = bz + CONFIG.offset.z + snapZ

		local box = root.addBox(drawX, drawY, drawZ, 1, 1, 1, CONFIG.boxColor)
		setDepthDisabled(box)
	end

	currentRoot = root
end

clearAllStartup()

print("xray head renderer online")
print("modem: " .. modemName)
print("protocol: " .. CONFIG.channelProtocol)

while true do
	local _, message = rednet.receive(CONFIG.channelProtocol, CONFIG.updateInterval)
	if message then
		drawPacket(message)
	end
end
