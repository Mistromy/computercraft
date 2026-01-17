local basalt = require("basalt") -- Load the UI library

-- CONFIGURATION
local SERVER_URL = "http://192.168.1.XX:8042/api/map-data"
local REFRESH_RATE = 1 -- Seconds between fetches

-- STATE
local mapData = {}
local camera = {x = 0, z = 0, zoom = 1} -- Camera position and zoom level
local maxCount = 1

-- SETUP UI
local main = basalt.getMainFrame()
    :setMonitor("top") -- CHANGE THIS to your monitor side ("top", "right", etc.)
    :setBackground(colors.black)

-- We create a "Canvas" frame where we draw the pixels
local mapFrame = main:addFrame()
    :setPosition(1, 1)
    :setSize("parent.w", "parent.h")
    :setBackground(colors.black)

-- 1. DEFINE THE "NOCOM" PALETTE (Hacking the colors)
-- We overwrite standard colors to match your gradient
local monitor = peripheral.wrap("top") -- Must match setMonitor above
local palette = {
    0x300060, 0x400070, 0x500080, 0x600090, -- Purples
    0x7000A0, 0x8000B0, 0x900040, 0xA00030, -- Transition
    0xB00020, 0xC00010, 0xD00000, 0xE04000, -- Reds
    0xF08000, 0xFFC000, 0xFFFF80, 0xFFFFFF  -- Gold -> White
}
for i = 1, #palette do
    monitor.setPaletteColor(2^(i-1), palette[i])
end

-- HELPER: Logarithmic Color Mapping
local function getHeatColor(count)
    if count == 0 then return colors.black end
    local logVal = math.log(count)
    local logMax = math.log(maxCount)
    if logMax == 0 then logMax = 1 end
    
    local norm = logVal / logMax
    if norm > 1 then norm = 1 end
    
    -- Map 0.0-1.0 to 1-16 color range
    local colorIndex = math.floor(norm * 15) + 1
    return 2^(colorIndex - 1)
end

-- 2. FETCH DATA FUNCTION
local function fetchData()
    local response = http.get(SERVER_URL)
    if response then
        local data = textutils.unserializeJSON(response.readAll())
        response.close()
        
        if data and data.blocks then
            mapData = data.blocks
            -- Update Max for color scaling
            maxCount = 1
            for _, b in ipairs(mapData) do
                if b[3] > maxCount then maxCount = b[3] end
            end
        end
    end
end

-- 3. DRAWING FUNCTION
-- This runs every time the screen needs to update
mapFrame:onPaint(function(self)
    local w, h = self:getSize()
    local cx, cy = math.floor(w/2), math.floor(h/2)
    
    -- Clear background
    self:setBackground(colors.black)
    self:clear()
    
    if #mapData == 0 then
        self:setCursorPos(2, 2)
        self:setForeground(colors.white)
        self:write("Connecting...")
        return
    end

    for _, block in ipairs(mapData) do
        local bx, bz, count = block[1], block[2], block[3]
        
        -- Apply Camera Zoom & Pan
        -- (bx - camera.x) shifts the world
        -- * camera.zoom scales it
        -- + cx centers it on screen
        local screenX = math.floor((bx - camera.x) / camera.zoom) + cx
        local screenY = math.floor((bz - camera.z) / camera.zoom) + cy
        
        -- Draw pixel if visible
        if screenX >= 1 and screenX <= w and screenY >= 1 and screenY <= h then
            local color = getHeatColor(count)
            self:setCursorPos(screenX, screenY)
            self:setBackground(color)
            self:write(" ")
        end
    end
end)

-- 4. CONTROLS (Zoom & Pan)

-- Dragging Logic
local isDragging = false
local lastDrag = {x=0, y=0}

mapFrame:onDrag(function(self, event, btn, x, y)
    if not isDragging then
        isDragging = true
        lastDrag.x, lastDrag.y = x, y
    else
        local dx = x - lastDrag.x
        local dy = y - lastDrag.y
        -- Inverse the drag to move camera
        camera.x = camera.x - (dx * camera.zoom)
        camera.z = camera.z - (dy * camera.zoom)
        lastDrag.x, lastDrag.y = x, y
        -- Force redraw
        self:updateDraw() 
    end
end)

mapFrame:onRelease(function() isDragging = false end)

-- Zoom Buttons
local btnPlus = main:addButton()
    :setPosition("parent.w - 4", 2)
    :setSize(3, 3)
    :setText("+")
    :setBackground(colors.gray)
    :setForeground(colors.white)
    :onClick(function()
        if camera.zoom > 0.2 then camera.zoom = camera.zoom / 2 end
        mapFrame:updateDraw()
    end)

local btnMinus = main:addButton()
    :setPosition("parent.w - 4", 6)
    :setSize(3, 3)
    :setText("-")
    :setBackground(colors.gray)
    :setForeground(colors.white)
    :onClick(function()
        camera.zoom = camera.zoom * 2
        mapFrame:updateDraw()
    end)

-- 5. BACKGROUND THREAD (Data Fetcher)
local function dataLoop()
    while true do
        fetchData()
        mapFrame:updateDraw() -- Tell Basalt to repaint the map
        sleep(REFRESH_RATE)
    end
end

-- Run UI and Data Loop in parallel
parallel.waitForAny(basalt.run, dataLoop)