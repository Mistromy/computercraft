local hologram = peripheral.find("hologram_projector")
diamond = hologram.item({id = "minecraft:diamond", Count = 1}, {item_display = "ground", interpolation_duration = 20})
hologram.update(diamond, {id = "minecraft:diamond", Count = 1}, {
    interpolation_duration = 60,
    start_interpolation = 0,
    transformation = {
        left_rotation = {0, 1, 0, 0}
    }
})