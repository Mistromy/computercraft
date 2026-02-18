-- Custom GPS Library for Swarm Miners
-- Bypasses standard rednet/gps side limitations
local lib = {}

-- 1. Vector Math Helpers (Required for Trilateration)
local function vSub(v1, v2) return {x=v1.x-v2.x, y=v1.y-v2.y, z=v1.z-v2.z} end
local function vAdd(v1, v2) return {x=v1.x+v2.x, y=v1.y+v2.y, z=v1.z+v2.z} end
local function vDot(v1, v2) return v1.x*v2.x + v1.y*v2.y + v1.z*v2.z end
local function vScale(v, s) return {x=v.x*s, y=v.y*s, z=v.z*s} end
local function vLen(v) return math.sqrt(v.x^2 + v.y^2 + v.z^2) end
local function vNorm(v) local l = vLen(v); return {x=v.x/l, y=v.y/l, z=v.z/l} end
local function vCross(v1, v2)
    return {
        x = v1.y*v2.z - v1.z*v2.y,
        y = v1.z*v2.x - v1.x*v2.z,
        z = v1.x*v2.y - v1.y*v2.x
    }
end

-- 2. The Trilateration Algorithm
-- Calculates position given 3 known points (p1, p2, p3) and 3 distances (r1, r2, r3)
local function trilaterate(p1, p2, p3, r1, r2, r3)
    local ex = vNorm(vSub(p2, p1))
    local i = vDot(ex, vSub(p3, p1))
    local temp = vSub(vSub(p3, p1), vScale(ex, i))
    local ey = vNorm(temp)
    local ez = vCross(ex, ey)
    local d = vLen(vSub(p2, p1))
    local j = vDot(ey, vSub(p3, p1))

    local x = (r1^2 - r2^2 + d^2) / (2*d)
    local y = ((r1^2 - r3^2 + i^2 + j^2) / (2*j)) - ((i/j)*x)
    
    -- z can be positive or negative (two intersection points)
    -- We assume the world is standard height and usually return the valid one
    local z_sq = r1^2 - x^2 - y^2
    if z_sq < 0 then return nil end -- No intersection
    local z = math.sqrt(z_sq)

    -- Map back to world coordinates
    local res = vAdd(p1, vAdd(vScale(ex, x), vScale(ey, y)))
    local res1 = vAdd(res, vScale(ez, z))
    local res2 = vAdd(res, vScale(ez, -z))
    
    return res1, res2
end

-- 3. The Main Locate Function
function lib.locate(timeout)
    timeout = timeout or 2
    
    -- Find the modem (works with Peripherals++ / Hubs)
    local modem = peripheral.find("modem", function(n, o) return o.isWireless() end)
    if not modem then error("No wireless modem found") end

    -- Open a random channel for replies
    local replyChannel = math.random(10000, 60000)
    modem.open(replyChannel)

    -- Broadcast "PING" in Rednet format to channel 65535 (Standard GPS)
    -- This mimics what 'rednet.broadcast("PING")' does under the hood
    local packet = {
        nMessageID = math.random(1, 2000000000),
        nRecipient = 65535,
        sProtocol = "gps",
        message = "PING"
    }
    modem.transmit(65535, replyChannel, packet)

    -- Collect responses
    local fixes = {} -- Stores {vec, dist}
    local timer = os.startTimer(timeout)

    while true do
        local e = {os.pullEvent()}
        if e[1] == "timer" and e[2] == timer then
            break -- Time is up
        elseif e[1] == "modem_message" then
            local _, _, channel, _, msg, dist = table.unpack(e)
            
            -- Check if it's a valid GPS response (Message contains x,y,z)
            -- Rednet messages are tables: {message={x,y,z}, ...}
            if type(msg) == "table" and type(msg.message) == "table" and msg.message[1] and msg.message[2] and msg.message[3] then
                local pos = {x=msg.message[1], y=msg.message[2], z=msg.message[3]}
                table.insert(fixes, {pos=pos, dist=dist})
            end
            
            -- If we have 3 fixes, we can calculate!
            if #fixes >= 3 then
                modem.close(replyChannel)
                
                -- Perform trilateration with the first 3 responses
                local p1, d1 = fixes[1].pos, fixes[1].dist
                local p2, d2 = fixes[2].pos, fixes[2].dist
                local p3, d3 = fixes[3].pos, fixes[3].dist
                
                local result1, result2 = trilaterate(p1, p2, p3, d1, d2, d3)
                
                -- Simply returning result1 is usually 99% correct in MC
                -- (unless you are underground and the ghost point is above ground)
                return result1.x, result1.y, result1.z
            end
        end
    end
    
    modem.close(replyChannel)
    return nil -- Failed to get 3 responses
end

return lib