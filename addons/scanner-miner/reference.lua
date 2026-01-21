-- # Chunkloader Peripheral
local chunkloader = peripheral.find("chunkloader")

-- Core chunk loading control
chunkloader.setRadius(radius)           -- Set loading radius (0-2.5, 0 = disabled)
chunkloader.getRadius()                 -- Get current radius
chunkloader.getFuelRate()              -- Get fuel consumption per tick

-- Wake control
chunkloader.setWakeOnWorldLoad(boolean) -- Auto-resume on server restart
chunkloader.getWakeOnWorldLoad()        -- Check wake setting

-- Random tick control (for farms)
chunkloader.setRandomTick(boolean)      -- Enable random ticking (doubles fuel cost)
chunkloader.getRandomTick()            -- Check random tick status

-- Turtle identification
chunkloader.getTurtleIdString()         -- Get unique turtle ID for remote management

local manager = peripheral.find("chunkloader_manager")


-- # Chunkloader Manager Block
-- Remote turtle management
manager.getTurtleInfo(turtleId)                    -- Get turtle status/stats
manager.setTurtleRadius(turtleId, radius)          -- Wake & control dormant turtles
manager.setTurtleWakeOnWorldLoad(turtleId, boolean) -- Control wake settings remotely
manager.getTurtleWakeOnWorldLoad(turtleId)         -- Check wake settings
manager.listTurtles()            


-- # Scanner Peripheral
radius = 16 -- Max radius
scan("item", radius)
scan("block", radius)
scan("entity", radius)
scan("xp", radius)
scan("player", radius)

-- block scan output example
[
    {
        "y": -1,
        "x": -1,
        "name": "minecraft:grass_block",
        "z": 1,
        "tags": [
            "..."
        ],
        "displayName": "Grass Block"
    },
    {
        "y": -1,
        "x": 0,
        "name": "minecraft:grass_block",
        "z": 1,
        "tags": [
            "..."
        ],
        "displayName": "Grass Block"
    },
    {
        "y": 0,
        "x": -1,
        "name": "minecraft:grass",
        "z": 1,
        "tags": [
            "minecraft:sword_efficient",
            "minecraft:replaceable_by_trees",
            "minecraft:enchantment_power_transmitter",
            "minecraft:mineable/axe",
            "minecraft:replaceable",
            "techreborn:mineable/omni_tool"
        ],
        "displayName": "Grass"
    },
    {
        "y": -1,
        "x": -1,
        "name": "minecraft:grass_block",
        "z": 0,
        "tags": [
            "..."
        ],
        "displayName": "Grass Block"
    },
    {
        "y": -1,
        "x": 0,
        "name": "minecraft:grass_block",
        "z": 0,
        "tags": [
            "..."
        ],
        "displayName": "Grass Block"
    },
    {
        "y": 0,
        "x": 0,
        "name": "peripheralworks:universal_scanner",
        "z": 0,
        "tags": {},
        "displayName": "Universal scanner"
    },
    {
        "y": -1,
        "x": -1,
        "name": "minecraft:grass_block",
        "z": -1,
        "tags": [
            "..."
        ],
        "displayName": "Grass Block"
    },
    {
        "y": -1,
        "x": 0,
        "name": "minecraft:dirt",
        "z": -1,
        "tags": [
            "..."
        ],
        "displayName": "Dirt"
    },
    {
        "y": -1,
        "x": 1,
        "name": "minecraft:grass_block",
        "z": -1,
        "tags": [
            "..."
        ],
        "displayName": "Grass Block"
    },
    {
        "y": 0,
        "x": -1,
        "name": "minecraft:grass",
        "z": -1,
        "tags": [
            "minecraft:sword_efficient",
            "minecraft:replaceable_by_trees",
            "minecraft:enchantment_power_transmitter",
            "minecraft:mineable/axe",
            "minecraft:replaceable",
            "techreborn:mineable/omni_tool"
        ],
        "displayName": "Grass"
    },
    {
        "y": 0,
        "x": 0,
        "name": "computercraft:computer_advanced",
        "z": -1,
        "tags": [
            "techreborn:mineable/omni_tool",
            "minecraft:mineable/pickaxe",
            "techreborn:mineable/drill",
            "computercraft:computer"
        ],
        "displayName": "Advanced Computer"
    }
]