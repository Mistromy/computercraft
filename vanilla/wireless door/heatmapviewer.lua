-- CONFIGURATION
-- Replace with your Python Server IP
local SERVER_URL = "http:// /api/map-data"
local MONITOR_SIDE = "top" -- or "right", "left", "back"
local REFRESH_RATE = 2 -- Seconds between updates

-- Import required libraries
local monitor = peripheral.wrap(MONITOR_SIDE)
monitor.setTextScale(0.5) -- 0.5 gives you 4x more pixels (High Res)

-- DEFINING THE "NOCOM" PALETTE
-- We override the standard CC colors to match your Python gradient
-- 1 (Purple) -> ... -> 16 (White)
local palette = {
    0x300060, -- 1: Deep Purple
    0x400070, -- 2
    0x500080, -- 3
    0x600090, -- 4
    0x7000A0, -- 5
    0x8000B0, -- 6
    0x900040, -- 7: Transition to Red
    0xA00030, -- 8
    0xB00020, -- 9
    0xC00010, -- 10
    0xD00000, -- 11: Bright Red
    0xE04000, -- 12: Orange
    0xF08000, -- 13
    0xFFC000, -- 14: Gold
    0xFFFF80, -- 15: Pale Yellow
    0xFFFFFF  -- 16: Pure White
}

-- Apply palette to monitor
for i = 1, #palette do
    -- Math.log(2) based mapping to CC colors 2^0 to 2^15
    monitor.setPaletteColor(2^(i-1), palette[i])
end

-- Helper: Map counts to our 1-16 color range (Logarithmic)
local function getHeatColor(count, maxCount)
    if count == 0 then return colors.black end
    
    -- Logarithmic scaling (same as your JS code)
    local logVal = math.log(count)
    local logMax = math.log(maxCount)
    if logMax == 0 then logMax = 1 end
    
    local norm = logVal / logMax
    if norm > 1 then norm = 1 end
    
    -- Map 0.0-1.0 to 1-16 range
    local colorIndex = math.floor(norm * 15) + 1
    return 2^(colorIndex - 1)
end

local function draw()
    -- 1. Fetch Data
    local response = http.get(SERVER_URL)
    if not response then
        print("Failed to connect to server.")
        return
    end
    
    local data = textutils.unserializeJSON(response.readAll())
    response.close()
    
    if not data or not data.blocks then return end
    
    local blocks = data.blocks
    local current = data.current -- [x, z]
    
    -- 2. Find Max for scaling
    local maxCount = 1
    for _, b in ipairs(blocks) do
        if b[3] > maxCount then maxCount = b[3] end
    end
    
    -- 3. Calculate Offset (Center on Player)
    local w, h = monitor.getSize()
    local centerX = math.floor(w / 2)
    local centerY = math.floor(h / 2)
    
    -- Default to 0,0 if no player, else player pos
    local camX = 0
    local camZ = 0
    if current then
        camX = current[1]
        camZ = current[2]
    end
    
    -- 4. Draw
    monitor.setBackgroundColor(colors.black)
    monitor.clear()
    
    for _, block in ipairs(blocks) do
        local bx, bz, count = block[1], block[2], block[3]
        
        -- Convert World Coords -> Monitor Coords
        local screenX = (bx - camX) + centerX
        local screenY = (bz - camZ) + centerY
        
        -- Only draw if visible
        if screenX >= 1 and screenX <= w and screenY >= 1 and screenY <= h then
            local color = getHeatColor(count, maxCount)
            monitor.setCursorPos(screenX, screenY)
            monitor.setBackgroundColor(color)
            monitor.write(" ") -- Draw a pixel
        end
    end
    
    -- Draw Player (Green Pixel)
    if current then
        monitor.setCursorPos(centerX, centerY)
        monitor.setBackgroundColor(colors.lime)
        monitor.write(" ")
    end
end

-- Main Loop
print("Heatmap Monitor Running...")
while true do
    draw()
    sleep(REFRESH_RATE)
end