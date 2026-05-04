![[Hologram Projector.png]]
## Syntax:
```lua
local hologram = peripheral.find("hologram_projector")
hologram.text({text = "Hello world", color = "red"})
```

[source code](https://github.com/SirEdvin/UnlimitedPeripheralWorks/blob/1.20/projects/core/src/main/kotlin/site/siredvin/peripheralworks/computercraft/peripherals/HologramProjectorPeripheral.kt)
## 1. Primary Spawn Functions

These functions create the hologram and return a **UUID string**, which you must save to move or update it later.

### `text(content, options)`

- **content**: A table representing a Minecraft JSON text component.
    
    - _Simple:_ `{text = "Hello World", color = "red"}`
        
- **options**: (Optional) A table of visual settings (see the "Options" section below).
    

### `item(content, options)`

- **content**: A table representing an item stack.
    
    - _Example:_ `{id = "minecraft:diamond", Count = 1}`
	    Remember to capitalize Count
        
- **options**: (Optional) Visual settings.
    

### `block(content, options)`

- **content**: A table representing a block state.
    
    - _Example:_ `{Name = "minecraft:grass_block"}`
        
- **options**: (Optional) Visual settings.


## 2. The `options` Table (The "How it Looks")

The code defines several sets of options you can mix and match inside the second table argument.

### Global Options (Works for all)

| **Key**                  | **Type** | **Description**                                                      |
| ------------------------ | -------- | -------------------------------------------------------------------- |
| `brightness`             | Int      | Light level of the hologram.                                         |
| `glow_color_override`    | Int      | The hex color of the outline glow.                                   |
| `interpolation_duration` | Int      | How many ticks it takes to transition (smooth movement).             |
| `view_range`             | Float    | How far away players can see it.                                     |
| `billboard`              | String   | "none", "vertical", "horizontal", or "center" (follows player eyes). |
| `transformation`         | Table    | See the **Transformation Sub-table** below.                          |
### Text-Specific Options

|**Key**|**Type**|**Description**|
|---|---|---|
|`line_width`|Int|Where the text wraps.|
|`background`|Int|Hex color of the text background.|
|`text_opacity`|Number|0 to 255.|
|`shadow`|Bool|Does the text have a drop shadow?|
|`see_through`|Bool|Can you see it through walls?|
|`alignment`|String|"left", "right", or "center".|

### Item-Specific Options

- `item_display`: String (e.g., "head", "ground", "fixed"). This changes the "rotation" style of the item model.
    

---

## 3. The `transformation` Sub-table

Inside your `options` table, you can add a `transformation` key to scale or rotate the hologram.

Lua

```
local options = {
    transformation = {
        translation = {0, 1.5, 0}, -- X, Y, Z offset
        scale = {2, 2, 2},         -- Double the size
        left_rotation = {0, 0, 0, 1}, -- Quaternion (x, y, z, w)
        right_rotation = {0, 0, 0, 1}
    }
}
```

---

## 4. Management Functions

Once you have the `uuid` from a spawn function:

- **`move(uuid, vector)`**: Moves the entity. The vector can be `{x, y, z}`.
    
- **`rotate(uuid, xRot, yRot)`**: Changes the pitch and yaw.
    
- **`update(uuid, content, options)`**: Changes the text/item/block and the settings without spawning a new one.
    
- **`destroy(uuid)`**: Removes the hologram.
    
- **`list(mode)`**: Use `"owned"` to see what you've built or `"around"` to find nearby holograms.
    
- **`ride(riderUUID, horseUUID)`**: High-level trick—you can make one hologram "sit" on another for complex animations.
    

---

## 5. Practical Example

Here is a script to create a giant spinning diamond above the projector:

Lua

```
local hp = peripheral.find("hologram_projector")

-- 1. Create a big diamond
local diamondID = hp.item(
    {id = "minecraft:diamond", Count = 1}, 
    {
        transformation = {
            scale = {3, 3, 3}
        },
        item_display = "fixed"
    }
)

print("Spawned hologram: " .. diamondID)

-- 2. Move it up slowly (Example of an update)
hp.move(diamondID, {0, 2, 0})

-- 3. To remove it later:
-- hp.destroy(diamondID)
```

### Pro-Tip for the `text` function:

Because it uses `GSON.toJson(text)`, you can pass it very complex tables to get colored text or bolding:

Lua

```
hp.text({
    {text = "WARNING: ", color = "red", bold = true},
    {text = "Reactor Overheat", color = "white"}
}, {background = 0x000000})
```