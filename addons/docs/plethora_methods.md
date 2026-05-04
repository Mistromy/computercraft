  [Plethora](https://plethora.madefor.cc/) [ Curse](https://minecraft.curseforge.com/projects/plethora-peripherals)[ GitHub](https://github.com/SquidDev-CC/plethora) 
## Method reference


## Module methods


• minecraft:clock
• minecraft:daylight_detector
• minecraft:noteblock
• plethora:chat
• plethora:chat_creative
• plethora:glasses
• plethora:introspection
• plethora:introspection, plethora:sensor
• plethora:kinetic
• plethora:laser
• plethora:scanner
• plethora:sensor


## Targeted methods


• java.lang.Object
• net.minecraft.tileentity.TileEntityBrewingStand
• net.minecraft.tileentity.TileEntityFurnace
• net.minecraft.tileentity.TileEntitySign
• net.minecraftforge.common.capabilities.ICapabilityProvider
• net.minecraftforge.fluids.capability.IFluidHandler
• net.minecraftforge.items.IItemHandler
• org.squiddev.plethora.api.method.IMethodCollection
• org.squiddev.plethora.api.module.IModuleContainer
• org.squiddev.plethora.api.reference.ItemSlot
• org.squiddev.plethora.gameplay.modules.glasses.BaseObject
• org.squiddev.plethora.gameplay.modules.glasses.objects.Colourable
• org.squiddev.plethora.gameplay.modules.glasses.objects.ItemObject
• org.squiddev.plethora.gameplay.modules.glasses.objects.ObjectGroup
• org.squiddev.plethora.gameplay.modules.glasses.objects.ObjectGroup$Frame2D
• org.squiddev.plethora.gameplay.modules.glasses.objects.ObjectGroup$Group2D
• org.squiddev.plethora.gameplay.modules.glasses.objects.ObjectGroup$Group3D
• org.squiddev.plethora.gameplay.modules.glasses.objects.ObjectGroup$Origin3D
• org.squiddev.plethora.gameplay.modules.glasses.objects.Scalable
• org.squiddev.plethora.gameplay.modules.glasses.objects.TextObject
• org.squiddev.plethora.gameplay.modules.glasses.objects.object2d.MultiPoint2D
• org.squiddev.plethora.gameplay.modules.glasses.objects.object2d.MultiPointResizable2D
• org.squiddev.plethora.gameplay.modules.glasses.objects.object2d.Positionable2D
• org.squiddev.plethora.gameplay.modules.glasses.objects.object2d.Rectangle
• org.squiddev.plethora.gameplay.modules.glasses.objects.object3d.Box
• org.squiddev.plethora.gameplay.modules.glasses.objects.object3d.DepthTestable
• org.squiddev.plethora.gameplay.modules.glasses.objects.object3d.MultiPoint3D
• org.squiddev.plethora.gameplay.modules.glasses.objects.object3d.ObjectRoot3D
• org.squiddev.plethora.gameplay.modules.glasses.objects.object3d.Positionable3D
• org.squiddev.plethora.gameplay.modules.glasses.objects.object3d.Rotatable3D


## Metadata providers


• dan200.computercraft.shared.computer.blocks.TileComputerBase
• dan200.computercraft.shared.turtle.blocks.ITurtleTile
• net.minecraft.block.Block
• net.minecraft.block.material.Material
• net.minecraft.block.state.IBlockState
• net.minecraft.entity.Entity
• net.minecraft.entity.EntityLivingBase
• net.minecraft.entity.item.EntityItem
• net.minecraft.entity.passive.EntitySheep
• net.minecraft.entity.player.EntityPlayer
• net.minecraft.item.ItemStack
• net.minecraft.tileentity.MobSpawnerBaseLogic
• net.minecraft.tileentity.TileEntitySign
• net.minecraftforge.energy.IEnergyStorage
• net.minecraftforge.fluids.FluidStack
• net.minecraftforge.fluids.IFluidTank
• net.minecraftforge.fluids.capability.IFluidHandler
• net.minecraftforge.fluids.capability.IFluidTankProperties
• org.squiddev.plethora.api.reference.BlockReference
• org.squiddev.plethora.integration.MetaWrapper
• org.squiddev.plethora.integration.vanilla.NullableItemStack


## Module methods


### minecraft:clock


| Function | Synopsis |
| --- | --- |
| getCelestialAngle | The angle the sun or moon lies at in degrees. |
| getDay | The current day of this world |
| getMoonPhase | The current phase of the moon |
| getTime | The game time in ticks |


#### getCelestialAngle():number


The angle the sun or moon lies at in degrees.


0 is directly overhead.


| Class | org.squiddev.plethora.integration.vanilla.method.MethodsClock#getCelestialAngle(IModuleContainer) |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Modules | minecraft:clock |


#### getDay():integer


The current day of this world


| Class | org.squiddev.plethora.integration.vanilla.method.MethodsClock#getDay(IModuleContainer) |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Modules | minecraft:clock |


#### getMoonPhase():int


The current phase of the moon


| Class | org.squiddev.plethora.integration.vanilla.method.MethodsClock#getMoonPhase(IModuleContainer) |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Modules | minecraft:clock |


#### getTime():int


The game time in ticks


| Class | org.squiddev.plethora.integration.vanilla.method.MethodsClock#getTime(IModuleContainer) |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Modules | minecraft:clock |


### minecraft:daylight_detector


| Function | Synopsis |
| --- | --- |
| getBlockLight | The light level from surrounding blocks. |
| getSkyLight | The light level from the sun. |
| getWeather | The weather in the current world. |
| hasSky | Whether this world has a sky. |


#### getBlockLight():int


The light level from surrounding blocks.


| Class | org.squiddev.plethora.integration.vanilla.method.MethodsDaylightSensor#getBlockLight(IModuleContainer) |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Modules | minecraft:daylight_detector |


#### getSkyLight():int


The light level from the sun.


| Class | org.squiddev.plethora.integration.vanilla.method.MethodsDaylightSensor#getSkyLight(IModuleContainer) |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Modules | minecraft:daylight_detector |


#### getWeather():string


The weather in the current world.


| Class | org.squiddev.plethora.integration.vanilla.method.MethodsDaylightSensor#getWeather(IModuleContainer) |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Modules | minecraft:daylight_detector |


#### hasSky():boolean


Whether this world has a sky.


| Class | org.squiddev.plethora.integration.vanilla.method.MethodsDaylightSensor#hasSky(IModuleContainer) |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Modules | minecraft:daylight_detector |


### minecraft:noteblock


| Function | Synopsis |
| --- | --- |
| playNote | Plays a note block note |
| playSound | Play a sound |


#### playNote(instrument:string|number, pitch:number[, volume:number])


Plays a note block note


| Class | org.squiddev.plethora.integration.vanilla.method.MethodsNoteblock#playNote(IModuleContainer) |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Modules | minecraft:noteblock |


#### playSound(sound:string[, pitch:number][, volume:number])


Play a sound


| Class | org.squiddev.plethora.integration.vanilla.method.MethodsNoteblock#playSound(IModuleContainer) |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Modules | minecraft:noteblock |


### plethora:chat


| Function | Synopsis |
| --- | --- |
| capture | Capture all chat messages matching a Lua pattern, preventing them from being said. |
| clearCaptures | Remove all listeners added by capture(). |
| say | Send a message to everyone |
| tell | Send a message to yourself |
| uncapture | Remove a capture added by capture(pattern). |


#### capture(pattern:string)


Capture all chat messages matching a Lua pattern, preventing them from being
said.


| Class | org.squiddev.plethora.gameplay.modules.methods.MethodsChat#capture(IModuleContainer) |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Modules | plethora:chat |


#### clearCaptures()


Remove all listeners added by capture().


| Class | org.squiddev.plethora.gameplay.modules.methods.MethodsChat#clearCaptures(IModuleContainer) |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Modules | plethora:chat |


#### say(message:string)


Send a message to everyone


| Class | org.squiddev.plethora.gameplay.modules.methods.MethodsChat#say(IModuleContainer) |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Modules | plethora:chat |


#### tell(message:string)


Send a message to yourself


| Class | org.squiddev.plethora.gameplay.modules.methods.MethodsChat#tell(IModuleContainer) |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Sub-target | org.squiddev.plethora.integration.EntityIdentifier |
| Modules | plethora:chat |


#### uncapture(pattern:string):boolean


Remove a capture added by capture(pattern).


| Class | org.squiddev.plethora.gameplay.modules.methods.MethodsChat#uncapture(IModuleContainer) |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Modules | plethora:chat |


### plethora:chat_creative


| Function | Synopsis |
| --- | --- |
| capture | Capture all chat messages matching a Lua pattern, preventing them from being said. |
| clearCaptures | Remove all listeners added by capture(). |
| say | Send a message to everyone |
| uncapture | Remove a capture added by capture(pattern). |


#### capture(pattern:string)


Capture all chat messages matching a Lua pattern, preventing them from being
said.


| Class | org.squiddev.plethora.gameplay.modules.methods.MethodsChatCreative#capture(IModuleContainer) |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Modules | plethora:chat_creative |


#### clearCaptures()


Remove all listeners added by capture().


| Class | org.squiddev.plethora.gameplay.modules.methods.MethodsChatCreative#clearCaptures(IModuleContainer) |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Modules | plethora:chat_creative |


#### say(message:string)


Send a message to everyone


| Class | org.squiddev.plethora.gameplay.modules.methods.MethodsChatCreative#say(IModuleContainer) |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Modules | plethora:chat_creative |


#### uncapture(pattern:string):boolean


Remove a capture added by capture(pattern).


| Class | org.squiddev.plethora.gameplay.modules.methods.MethodsChatCreative#uncapture(IModuleContainer) |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Modules | plethora:chat_creative |


### plethora:glasses


| Function | Synopsis |
| --- | --- |
| canvas | Get the 2D canvas for these glasses. |
| canvas3d | Get the 3D canvas for these glasses. |


#### canvas():table


Get the 2D canvas for these glasses.


| Class | org.squiddev.plethora.gameplay.modules.glasses.methods.MethodsCanvas#canvas(IModuleContainer) |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Sub-target | org.squiddev.plethora.gameplay.modules.glasses.CanvasServer |
| Modules | plethora:glasses |


#### canvas3d():table


Get the 3D canvas for these glasses.


| Class | org.squiddev.plethora.gameplay.modules.glasses.methods.MethodsCanvas#canvas3d(IModuleContainer) |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Sub-target | org.squiddev.plethora.gameplay.modules.glasses.CanvasServer |
| Modules | plethora:glasses |


### plethora:introspection


| Function | Synopsis |
| --- | --- |
| getEnder | Get this player's ender chest |
| getEquipment | Get this entity's held item and armor |
| getID | Get this entity's UUID. |
| getInventory | Get this turtle's inventory |
| getInventory | Get this player's inventory |
| getName | Get this entity's name. |


#### getEnder():table


Get this player's ender chest


| Class | org.squiddev.plethora.integration.vanilla.method.MethodsIntrospectionEntity#getEnder(IModuleContainer) |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Sub-target | org.squiddev.plethora.integration.EntityIdentifier$Player |
| Modules | plethora:introspection |


#### getEquipment():table


Get this entity's held item and armor


| Class | org.squiddev.plethora.integration.vanilla.method.MethodsIntrospectionEntity#getEquipment(IModuleContainer) |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Sub-target | org.squiddev.plethora.integration.EntityIdentifier |
| Modules | plethora:introspection |


#### getID():string


Get this entity's UUID.


| Class | org.squiddev.plethora.gameplay.modules.methods.MethodsIntrospection#getID(IModuleContainer) |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Sub-target | org.squiddev.plethora.integration.EntityIdentifier |
| Modules | plethora:introspection |


#### getInventory():table


Get this turtle's inventory


| Class | org.squiddev.plethora.integration.computercraft.MethodsIntrospectionTurtle#getInventory(IModuleContainer) |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Sub-target | dan200.computercraft.api.turtle.ITurtleAccess |
| Modules | plethora:introspection |


#### getInventory():table


Get this player's inventory


| Class | org.squiddev.plethora.integration.vanilla.method.MethodsIntrospectionEntity#getInventory(IModuleContainer) |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Sub-target | org.squiddev.plethora.integration.EntityIdentifier$Player |
| Modules | plethora:introspection |


#### getName():string


Get this entity's name.


| Class | org.squiddev.plethora.gameplay.modules.methods.MethodsIntrospection#getName(IModuleContainer) |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Sub-target | org.squiddev.plethora.integration.EntityIdentifier |
| Modules | plethora:introspection |


### plethora:introspection, plethora:sensor


| Function | Synopsis |
| --- | --- |
| getMetaOwner | Get this entity's UUID. |


#### getMetaOwner():table


Get this entity's UUID.


| Class | org.squiddev.plethora.gameplay.modules.methods.MethodsIntrospection#getMetaOwner(IModuleContainer) |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Sub-target | org.squiddev.plethora.integration.EntityIdentifier |
| Modules | plethora:introspection plethora:sensor |


### plethora:kinetic


| Function | Synopsis |
| --- | --- |
| disableAI | Disable the AI of this entity. |
| explode | Explode this creeper. |
| isWalking | Whether the entity is currently walking somewhere. |
| launch | Launch the entity in a set direction |
| look | Look in a set direction |
| propel | Propel this minecart in along the track. |
| shoot | Fire an arrow in the direction the skeleton is looking |
| shoot | Fire a fireball in the specified direction. |
| shoot | Throw a potion in the direction the witch is looking |
| swing | Left click with this item. |
| swing | Left click with this item. |
| teleport | Teleport to a position relative to the current one |
| use | Right click with this item. |
| use | Right click with this item using a particular hand ("left" or "right"). |
| walk | Walk to a coordinate |


#### disableAI()


Disable the AI of this entity.


Be warned: this permanently scars them - they'll never be the same again!


| Class | org.squiddev.plethora.integration.vanilla.method.MethodsKinetic#disableAI(IModuleContainer) |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Sub-target | net.minecraft.entity.EntityLiving |
| Modules | plethora:kinetic |


#### explode()


Explode this creeper.


| Class | org.squiddev.plethora.integration.vanilla.method.MethodsKineticEntity#explode(IModuleContainer) |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Sub-target | net.minecraft.entity.monster.EntityCreeper |
| Modules | plethora:kinetic |


#### isWalking():boolean


Whether the entity is currently walking somewhere.


| Class | org.squiddev.plethora.integration.vanilla.method.MethodsKinetic#isWalking(IModuleContainer) |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Sub-target | net.minecraft.entity.EntityLiving |
| Modules | plethora:kinetic |


#### launch(yaw:number, pitch:number, power:number)


Launch the entity in a set direction


| Class | org.squiddev.plethora.integration.vanilla.method.MethodsKinetic#launch |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Sub-target | net.minecraft.entity.Entity |
| Modules | plethora:kinetic |


#### look(yaw:number, pitch:number)


Look in a set direction


| Class | org.squiddev.plethora.integration.vanilla.method.MethodsKineticEntity#look(IModuleContainer) |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Sub-target | net.minecraft.entity.EntityLivingBase |
| Modules | plethora:kinetic |


#### propel(velocity:number)


Propel this minecart in along the track.


| Class | org.squiddev.plethora.integration.vanilla.method.MethodsKineticEntity#propel |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Sub-target | net.minecraft.entity.item.EntityMinecart |
| Modules | plethora:kinetic |


#### shoot(potency:number)


Fire an arrow in the direction the skeleton is looking


| Class | org.squiddev.plethora.integration.vanilla.method.MethodsKineticEntity#shootSkeleton |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Sub-target | net.minecraft.entity.monster.AbstractSkeleton |
| Modules | plethora:kinetic |


#### shoot(yaw:number, pitch:number)


Fire a fireball in the specified direction.


| Class | org.squiddev.plethora.integration.vanilla.method.MethodsKineticEntity#shootBlaze |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Sub-target | net.minecraft.entity.monster.EntityBlaze |
| Modules | plethora:kinetic |


#### shoot(potency:number)


Throw a potion in the direction the witch is looking


| Class | org.squiddev.plethora.integration.vanilla.method.MethodsKineticEntity#shootWitch |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Sub-target | net.minecraft.entity.monster.EntityWitch |
| Modules | plethora:kinetic |


#### swing():boolean, string|nil


Left click with this item.


Returns the action taken.


| Class | org.squiddev.plethora.integration.vanilla.method.MethodsKineticActions#swing(IModuleContainer) |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Sub-target | net.minecraft.entity.EntityLivingBase |
| Modules | plethora:kinetic |


#### swing():boolean, string|nil


Left click with this item.


Returns the action taken.


| Class | org.squiddev.plethora.integration.computercraft.MethodsKineticTurtle#swing(IModuleContainer) |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Sub-target | dan200.computercraft.api.turtle.ITurtleAccess |
| Modules | plethora:kinetic |


#### teleport(x:number, y:number, z:number)


Teleport to a position relative to the current one


| Class | org.squiddev.plethora.integration.vanilla.method.MethodsKineticEntity#teleport |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Sub-target | net.minecraft.entity.monster.EntityEnderman |
| Modules | plethora:kinetic |


#### use([duration:integer]):boolean, string|nil


Right click with this item.


The duration is in ticks, or 1/20th of a second.


| Class | org.squiddev.plethora.integration.computercraft.MethodsKineticTurtle#use(IModuleContainer) |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Sub-target | dan200.computercraft.api.turtle.ITurtleAccess |
| Modules | plethora:kinetic |


#### use([duration:integer], [hand:string]):boolean, string|nil


Right click with this item using a particular hand ("left" or "right").


The duration is in ticks, or 1/20th of a second.


| Class | org.squiddev.plethora.integration.vanilla.method.MethodsKineticActions#use(IModuleContainer) |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Sub-target | net.minecraft.entity.EntityLivingBase |
| Modules | plethora:kinetic |


#### walk(x:number, y:number, z:number):boolean, string|nil


Walk to a coordinate


| Class | org.squiddev.plethora.integration.vanilla.method.MethodsKinetic#walk |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Sub-target | net.minecraft.entity.EntityLiving |
| Modules | plethora:kinetic |


### plethora:laser


| Function | Synopsis |
| --- | --- |
| fire | Fire a laser in a set direction |


#### fire(yaw:number, pitch:number, potency:number)


Fire a laser in a set direction


| Class | org.squiddev.plethora.gameplay.modules.methods.MethodsLaser#fire |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Sub-target | org.squiddev.plethora.api.IWorldLocation |
| Modules | plethora:laser |


### plethora:scanner


| Function | Synopsis |
| --- | --- |
| getBlockMeta | Get metadata about a nearby block |
| scan | Scan all blocks in the vicinity |


#### getBlockMeta(x:int, y:int, z:int):table


Get metadata about a nearby block


| Class | org.squiddev.plethora.gameplay.modules.methods.MethodsScanner#getBlockMeta(IModuleContainer) |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Modules | plethora:scanner |


#### scan():table


Scan all blocks in the vicinity


| Class | org.squiddev.plethora.gameplay.modules.methods.MethodsScanner#scan(IModuleContainer) |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Modules | plethora:scanner |


### plethora:sensor


| Function | Synopsis |
| --- | --- |
| getMetaByID | Find a nearby entity by UUID |
| getMetaByName | Find a nearby entity by name |
| sense | Scan for entities in the vicinity |


#### getMetaByID(id:string):table|nil


Find a nearby entity by UUID


| Class | org.squiddev.plethora.gameplay.modules.methods.MethodsSensor#getMetaByID(IModuleContainer) |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Modules | plethora:sensor |


#### getMetaByName(name:string):table|nil


Find a nearby entity by name


| Class | org.squiddev.plethora.gameplay.modules.methods.MethodsSensor#getMetaByName(IModuleContainer) |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Modules | plethora:sensor |


#### sense():table


Scan for entities in the vicinity


| Class | org.squiddev.plethora.gameplay.modules.methods.MethodsSensor#sense(IModuleContainer) |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |
| Modules | plethora:sensor |


## Targeted methods


### java.lang.Object


| Function | Synopsis |
| --- | --- |
| getMetadata | Get metadata about this object |


#### getMetadata():table


Get metadata about this object


| Class | org.squiddev.plethora.integration.MethodMeta |
| --- | --- |
| Target | java.lang.Object |


### net.minecraft.tileentity.TileEntityBrewingStand


| Function | Synopsis |
| --- | --- |
| getBrewTime | Number of ticks the current potion has brewed for |


#### getBrewTime():int


Number of ticks the current potion has brewed for


| Class | org.squiddev.plethora.integration.vanilla.method.MethodsVanillaTileEntities#getBrewTime(TileEntityBrewingStand) |
| --- | --- |
| Target | net.minecraft.tileentity.TileEntityBrewingStand |


### net.minecraft.tileentity.TileEntityFurnace


| Function | Synopsis |
| --- | --- |
| getBurnTime | Number of ticks of burning the current fuel provides |
| getCookTime | Number of ticks the current item has cooked for |
| getRemainingBurnTime | Number of ticks of fuel left |


#### getBurnTime():int


Number of ticks of burning the current fuel provides


| Class | org.squiddev.plethora.integration.vanilla.method.MethodsVanillaTileEntities#getBurnTime(TileEntityFurnace) |
| --- | --- |
| Target | net.minecraft.tileentity.TileEntityFurnace |


#### getCookTime():int


Number of ticks the current item has cooked for


| Class | org.squiddev.plethora.integration.vanilla.method.MethodsVanillaTileEntities#getCookTime(TileEntityFurnace) |
| --- | --- |
| Target | net.minecraft.tileentity.TileEntityFurnace |


#### getRemainingBurnTime():int


Number of ticks of fuel left


| Class | org.squiddev.plethora.integration.vanilla.method.MethodsVanillaTileEntities#getRemainingBurnTime(TileEntityFurnace) |
| --- | --- |
| Target | net.minecraft.tileentity.TileEntityFurnace |


### net.minecraft.tileentity.TileEntitySign


| Function | Synopsis |
| --- | --- |
| getSignText | Each line of text on this sign |
| setSignText | Set the lines of text on this sign |


#### getSignText():table


Each line of text on this sign


| Class | org.squiddev.plethora.integration.vanilla.method.MethodsVanillaTileEntities#getSignText(TileEntitySign) |
| --- | --- |
| Target | net.minecraft.tileentity.TileEntitySign |


#### setSignText(lines...:string)


Set the lines of text on this sign


| Class | org.squiddev.plethora.integration.vanilla.method.MethodsVanillaTileEntities#setSignText(TileEntitySign) |
| --- | --- |
| Target | net.minecraft.tileentity.TileEntitySign |


### net.minecraftforge.common.capabilities.ICapabilityProvider


| Function | Synopsis |
| --- | --- |
| getTanks | Get a list of all tanks on this side |


#### getTanks([side:string]):table


Get a list of all tanks on this side


| Class | org.squiddev.plethora.integration.vanilla.method.MethodFluidHandler |
| --- | --- |
| Target | net.minecraftforge.common.capabilities.ICapabilityProvider |


### net.minecraftforge.fluids.capability.IFluidHandler


| Function | Synopsis |
| --- | --- |
| pullFluid | Pull fluid to this tank from another tank. |
| pushFluid | Push fluid from this tank to another tank. |


#### pullFluid(fromName:string[, limit:int[, fluid:string]]):int


Pull fluid to this tank from another tank.


Returns the amount transferred.


| Class | org.squiddev.plethora.integration.vanilla.method.MethodsFluidTransfer#pullFluid(IFluidHandler) |
| --- | --- |
| Target | net.minecraftforge.fluids.capability.IFluidHandler |


#### pushFluid(toName:string[, limit:int], fluid:string):int


Push fluid from this tank to another tank.


Returns the amount transferred.


| Class | org.squiddev.plethora.integration.vanilla.method.MethodsFluidTransfer#pushFluid(IFluidHandler) |
| --- | --- |
| Target | net.minecraftforge.fluids.capability.IFluidHandler |


### net.minecraftforge.items.IItemHandler


| Function | Synopsis |
| --- | --- |
| drop | Drop an item on the ground. |
| getItem | The item in the specified slot. |
| getItemMeta | The metadata of the item in the specified slot. |
| list | List all items in this inventory |
| pullItems | Pull items to this inventory from another inventory. |
| pushItems | Push items from this inventory to another inventory. |
| size | The size of the inventory |
| suck | Suck an item from the ground |


#### drop(slot:int[, limit:int[, direction:string]]):int


Drop an item on the ground.


Returns the number of items dropped


| Class | org.squiddev.plethora.integration.vanilla.method.MethodsInventoryWorld#drop(IItemHandler) |
| --- | --- |
| Target | net.minecraftforge.items.IItemHandler |


#### getItem(slot:int):table|nil


The item in the specified slot.


The slot number starts from 1.


| Class | org.squiddev.plethora.integration.vanilla.method.MethodsInventory#getItem(IItemHandler) |
| --- | --- |
| Target | net.minecraftforge.items.IItemHandler |


#### getItemMeta(slot:int):table|nil


The metadata of the item in the specified slot.


The slot number starts from 1.


| Class | org.squiddev.plethora.integration.vanilla.method.MethodsInventory#getItemMeta(IItemHandler) |
| --- | --- |
| Target | net.minecraftforge.items.IItemHandler |


#### list():table


List all items in this inventory


| Class | org.squiddev.plethora.integration.vanilla.method.MethodsInventory#list(IItemHandler) |
| --- | --- |
| Target | net.minecraftforge.items.IItemHandler |


#### pullItems(fromName:string, fromSlot:int[, limit:int[, toSlot:int]]):int


Pull items to this inventory from another inventory.


Returns the amount transferred.


| Class | org.squiddev.plethora.integration.vanilla.method.MethodsInventoryTransfer#pullItems(IItemHandler) |
| --- | --- |
| Target | net.minecraftforge.items.IItemHandler |


#### pushItems(toName:string, fromSlot:int[, limit:int[, toSlot:int]]):int


Push items from this inventory to another inventory.


Returns the amount transferred.


| Class | org.squiddev.plethora.integration.vanilla.method.MethodsInventoryTransfer#pushItems(IItemHandler) |
| --- | --- |
| Target | net.minecraftforge.items.IItemHandler |


#### size():int


The size of the inventory


| Class | org.squiddev.plethora.integration.vanilla.method.MethodsInventory#size(IItemHandler) |
| --- | --- |
| Target | net.minecraftforge.items.IItemHandler |


#### suck([slot:int[, limit:int]]):int


Suck an item from the ground


| Class | org.squiddev.plethora.integration.vanilla.method.MethodsInventoryWorld#suck(IItemHandler) |
| --- | --- |
| Target | net.minecraftforge.items.IItemHandler |


### org.squiddev.plethora.api.method.IMethodCollection


| Function | Synopsis |
| --- | --- |
| getDocs | Get the documentation for all functions or the function specified. |
| getTransferLocations | Get a list of all available objects which can be transferred to or from |


#### getDocs([name: string]):string|table


Get the documentation for all functions or the function specified.


Errors if the function cannot be found.


| Class | org.squiddev.plethora.integration.MethodsCore#getDocs(IMethodCollection) |
| --- | --- |
| Target | org.squiddev.plethora.api.method.IMethodCollection |


#### getTransferLocations([location:string]):table


Get a list of all available objects which can be transferred to or from


| Class | org.squiddev.plethora.integration.MethodTransferLocations |
| --- | --- |
| Target | org.squiddev.plethora.api.method.IMethodCollection |


### org.squiddev.plethora.api.module.IModuleContainer


| Function | Synopsis |
| --- | --- |
| filterModules | Gets the methods which require these modules |
| hasModule | Checks whether a module is available |
| listModules | Lists all modules available |


#### filterModules(names:string...):table|nil


Gets the methods which require these modules


| Class | org.squiddev.plethora.integration.MethodsCore#filterModules(IModuleContainer) |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |


#### hasModule(module:string):boolean


Checks whether a module is available


| Class | org.squiddev.plethora.integration.MethodsCore#hasModule(IModuleContainer) |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |


#### listModules():table


Lists all modules available


| Class | org.squiddev.plethora.integration.MethodsCore#listModules(IModuleContainer) |
| --- | --- |
| Target | org.squiddev.plethora.api.module.IModuleContainer |


### org.squiddev.plethora.api.reference.ItemSlot


| Function | Synopsis |
| --- | --- |
| consume | Consume one item from this stack |
| drop | Drop an item on the ground. |
| setActive | Set whether these elytra are active or not. |


#### consume()


Consume one item from this stack


| Class | org.squiddev.plethora.integration.vanilla.method.MethodItemConsume |
| --- | --- |
| Target | org.squiddev.plethora.api.reference.ItemSlot |


#### drop([limit:int[, direction:string]]):int


Drop an item on the ground.


Returns the number of items dropped


| Class | org.squiddev.plethora.integration.vanilla.method.MethodsInventoryWorld#drop(ItemSlot) |
| --- | --- |
| Target | org.squiddev.plethora.api.reference.ItemSlot |


#### setActive([active:boolean])


Set whether these elytra are active or not.


| Class | org.squiddev.plethora.integration.vanilla.method.MethodItemElytraActivate |
| --- | --- |
| Target | org.squiddev.plethora.api.reference.ItemSlot |


### org.squiddev.plethora.gameplay.modules.glasses.BaseObject


| Function | Synopsis |
| --- | --- |
| remove | Remove this object from the canvas. |


#### remove()


Remove this object from the canvas.


| Class | org.squiddev.plethora.gameplay.modules.glasses.methods.MethodsCanvas#remove(BaseObject) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.BaseObject |


### org.squiddev.plethora.gameplay.modules.glasses.objects.Colourable


| Function | Synopsis |
| --- | --- |
| getAlpha | Get the alpha for this object. |
| getColor | Get the colour for this object. |
| getColour | Get the colour for this object. |
| setAlpha | Set the alpha for this object. |
| setColor | Set the colour for this object. |
| setColour | Set the colour for this object. |


#### getAlpha():int


Get the alpha for this object.


| Class | org.squiddev.plethora.gameplay.modules.glasses.objects.Colourable#getAlpha(Colourable) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.Colourable |


#### getColor():int


Get the colour for this object.


| Class | org.squiddev.plethora.gameplay.modules.glasses.objects.Colourable#getColour(Colourable) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.Colourable |


#### getColour():int


Get the colour for this object.


| Class | org.squiddev.plethora.gameplay.modules.glasses.objects.Colourable#getColour(Colourable) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.Colourable |


#### setAlpha(alpha:int)


Set the alpha for this object.


| Class | org.squiddev.plethora.gameplay.modules.glasses.objects.Colourable#setAlpha(Colourable) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.Colourable |


#### setColor(colour|r:int, [g:int, b:int], [alpha:int]):number


Set the colour for this object.


| Class | org.squiddev.plethora.gameplay.modules.glasses.objects.Colourable#setColour(Colourable) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.Colourable |


#### setColour(colour|r:int, [g:int, b:int], [alpha:int]):number


Set the colour for this object.


| Class | org.squiddev.plethora.gameplay.modules.glasses.objects.Colourable#setColour(Colourable) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.Colourable |


### org.squiddev.plethora.gameplay.modules.glasses.objects.ItemObject


| Function | Synopsis |
| --- | --- |
| getItem | Get the item and damage value for this object. |
| setItem | Set the item and damage value for this object. |


#### getItem(): string, number


Get the item and damage value for this object.


| Class | org.squiddev.plethora.gameplay.modules.glasses.objects.ItemObject#getItem(ItemObject) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.ItemObject |


#### setItem(item:string[, damage:int])


Set the item and damage value for this object.


| Class | org.squiddev.plethora.gameplay.modules.glasses.objects.ItemObject#setItem(ItemObject) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.ItemObject |


### org.squiddev.plethora.gameplay.modules.glasses.objects.ObjectGroup


| Function | Synopsis |
| --- | --- |
| clear | Remove all objects. |


#### clear()


Remove all objects.


| Class | org.squiddev.plethora.gameplay.modules.glasses.methods.MethodsCanvas#clear(ObjectGroup) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.ObjectGroup |


### org.squiddev.plethora.gameplay.modules.glasses.objects.ObjectGroup$Frame2D


| Function | Synopsis |
| --- | --- |
| getSize | Get the size of this canvas. |


#### getSize():number, number


Get the size of this canvas.


| Class | org.squiddev.plethora.gameplay.modules.glasses.methods.MethodsCanvas2D#getSize(Frame2D) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.ObjectGroup$Frame2D |


### org.squiddev.plethora.gameplay.modules.glasses.objects.ObjectGroup$Group2D


| Function | Synopsis |
| --- | --- |
| addDot | Create a new dot. |
| addGroup | Create a new object group. |
| addItem | Create a item icon. |
| addLine | Create a new line. |
| addLines | Create a new line loop, composed of many points. |
| addPolygon | Create a new polygon, composed of many points. |
| addRectangle | Create a new rectangle. |
| addText | Create a new text object. |
| addTriangle | Create a new triangle, composed of three points. |


#### addDot(position:table, [, color:number][, size:number]):table


Create a new dot.


| Class | org.squiddev.plethora.gameplay.modules.glasses.methods.MethodsCanvas2D#addDot(Group2D) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.ObjectGroup$Group2D |


#### addGroup(position:table):table


Create a new object group.


| Class | org.squiddev.plethora.gameplay.modules.glasses.methods.MethodsCanvas2D#addGroup(Group2D) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.ObjectGroup$Group2D |


#### addItem(position:table, item:string[, damage:int[, scale:number]]):table


Create a item icon.


| Class | org.squiddev.plethora.gameplay.modules.glasses.methods.MethodsCanvas2D#addItem(Group2D) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.ObjectGroup$Group2D |


#### addLine(start:table, end:table[, colour:int[, thickness:number]]):table


Create a new line.


| Class | org.squiddev.plethora.gameplay.modules.glasses.methods.MethodsCanvas2D#addLine(Group2D) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.ObjectGroup$Group2D |


#### addLines(points...:table, [, color:number[, thickness:number]]):table


Create a new line loop, composed of many points.


| Class | org.squiddev.plethora.gameplay.modules.glasses.methods.MethodsCanvas2D#addLines(Group2D) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.ObjectGroup$Group2D |


#### addPolygon(points...:table, [, color:number]):table


Create a new polygon, composed of many points.


| Class | org.squiddev.plethora.gameplay.modules.glasses.methods.MethodsCanvas2D#addPolygon(Group2D) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.ObjectGroup$Group2D |


#### addRectangle(x:number, y:number, width:number, height:number[, colour:int]):table


Create a new rectangle.


| Class | org.squiddev.plethora.gameplay.modules.glasses.methods.MethodsCanvas2D#addRectangle(Group2D) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.ObjectGroup$Group2D |


#### addText(position:table, contents:string[, colour:int[, size:number]]):table


Create a new text object.


| Class | org.squiddev.plethora.gameplay.modules.glasses.methods.MethodsCanvas2D#addText(Group2D) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.ObjectGroup$Group2D |


#### addTriangle(p1:table, p2:table, p3:table[, colour:int]):table


Create a new triangle, composed of three points.


| Class | org.squiddev.plethora.gameplay.modules.glasses.methods.MethodsCanvas2D#addTriangle(Group2D) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.ObjectGroup$Group2D |


### org.squiddev.plethora.gameplay.modules.glasses.objects.ObjectGroup$Group3D


| Function | Synopsis |
| --- | --- |
| addBox | Create a new box. |
| addFrame | Create a new frame to put 2d objects in. |
| addItem | Create a item model. |
| addLine | Create a new line. |


#### addBox(x:number, y:number, z:number[, width:number, height:number, depth:number][, color:number]):table


Create a new box.


| Class | org.squiddev.plethora.gameplay.modules.glasses.methods.MethodsCanvas3D#addBox(Group3D) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.ObjectGroup$Group3D |


#### addFrame(position:table):table


Create a new frame to put 2d objects in.


| Class | org.squiddev.plethora.gameplay.modules.glasses.methods.MethodsCanvas3D#addFrame(Group3D) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.ObjectGroup$Group3D |


#### addItem(position:table, item:string[, damage:int[, scale:number]]):table


Create a item model.


| Class | org.squiddev.plethora.gameplay.modules.glasses.methods.MethodsCanvas3D#addItem(Group3D) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.ObjectGroup$Group3D |


#### addLine(start:table, end:table[, thickness:number[, colour:int]]):table


Create a new line.


| Class | org.squiddev.plethora.gameplay.modules.glasses.methods.MethodsCanvas3D#addLine(Group3D) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.ObjectGroup$Group3D |


### org.squiddev.plethora.gameplay.modules.glasses.objects.ObjectGroup$Origin3D


| Function | Synopsis |
| --- | --- |
| create | Create a new 3D canvas centred relative to the current position. |


#### create([offset:table]):table


Create a new 3D canvas centred relative to the current position.


| Class | org.squiddev.plethora.gameplay.modules.glasses.methods.MethodsCanvas3D#create(Origin3D) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.ObjectGroup$Origin3D |


### org.squiddev.plethora.gameplay.modules.glasses.objects.Scalable


| Function | Synopsis |
| --- | --- |
| getScale | Get the scale for this object. |
| setScale | Set the scale for this object. |


#### getScale():number


Get the scale for this object.


| Class | org.squiddev.plethora.gameplay.modules.glasses.objects.Scalable#getScale(Scalable) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.Scalable |


#### setScale(scale:number)


Set the scale for this object.


| Class | org.squiddev.plethora.gameplay.modules.glasses.objects.Scalable#setScale(Scalable) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.Scalable |


### org.squiddev.plethora.gameplay.modules.glasses.objects.TextObject


| Function | Synopsis |
| --- | --- |
| getLineHeight | Get the line height for this object. |
| getText | Get the text for this object. |
| hasShadow | Get the shadow for this object. |
| setLineHeight | Set the line height for this object. |
| setShadow | Set the shadow for this object. |
| setText | Set the text for this object. |


#### getLineHeight():int


Get the line height for this object.


| Class | org.squiddev.plethora.gameplay.modules.glasses.objects.TextObject#getLineHeight(TextObject) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.TextObject |


#### getText():string


Get the text for this object.


| Class | org.squiddev.plethora.gameplay.modules.glasses.objects.TextObject#getText(TextObject) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.TextObject |


#### hasShadow():boolean


Get the shadow for this object.


| Class | org.squiddev.plethora.gameplay.modules.glasses.objects.TextObject#hasShadow(TextObject) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.TextObject |


#### setLineHeight(lineHeight:int)


Set the line height for this object.


| Class | org.squiddev.plethora.gameplay.modules.glasses.objects.TextObject#setLineHeight(TextObject) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.TextObject |


#### setShadow(shadow:boolean)


Set the shadow for this object.


| Class | org.squiddev.plethora.gameplay.modules.glasses.objects.TextObject#setShadow(TextObject) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.TextObject |


#### setText(contents:string)


Set the text for this object.


| Class | org.squiddev.plethora.gameplay.modules.glasses.objects.TextObject#setText(TextObject) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.TextObject |


### org.squiddev.plethora.gameplay.modules.glasses.objects.object2d.MultiPoint2D


| Function | Synopsis |
| --- | --- |
| getPoint | Get the specified vertex of this object. |
| setPoint | Set the specified vertex of this object. |


#### getPoint(idx:int):number, number


Get the specified vertex of this object.


| Class | org.squiddev.plethora.gameplay.modules.glasses.objects.object2d.MultiPoint2D#getPoint(MultiPoint2D) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.object2d.MultiPoint2D |


#### setPoint(idx:int, x:number, y:number)


Set the specified vertex of this object.


| Class | org.squiddev.plethora.gameplay.modules.glasses.objects.object2d.MultiPoint2D#setPoint(MultiPoint2D) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.object2d.MultiPoint2D |


### org.squiddev.plethora.gameplay.modules.glasses.objects.object2d.MultiPointResizable2D


| Function | Synopsis |
| --- | --- |
| getPointCount | Get the number of verticies on this object. |
| insertPoint | Add a specified vertex to this object. |
| removePoint | Remove the specified vertex of this object. |


#### getPointCount():int


Get the number of verticies on this object.


| Class | org.squiddev.plethora.gameplay.modules.glasses.objects.object2d.MultiPointResizable2D#getPointCount(MultiPointResizable2D) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.object2d.MultiPointResizable2D |


#### insertPoint([idx:int, ]x:number, y:number)


Add a specified vertex to this object.


| Class | org.squiddev.plethora.gameplay.modules.glasses.objects.object2d.MultiPointResizable2D#insertPoint(MultiPointResizable2D) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.object2d.MultiPointResizable2D |


#### removePoint(idx:int)


Remove the specified vertex of this object.


| Class | org.squiddev.plethora.gameplay.modules.glasses.objects.object2d.MultiPointResizable2D#removePoint(MultiPointResizable2D) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.object2d.MultiPointResizable2D |


### org.squiddev.plethora.gameplay.modules.glasses.objects.object2d.Positionable2D


| Function | Synopsis |
| --- | --- |
| getPosition | Get the position for this object. |
| setPosition | Set the position for this object. |


#### getPosition():number, number


Get the position for this object.


| Class | org.squiddev.plethora.gameplay.modules.glasses.objects.object2d.Positionable2D#getPosition(Positionable2D) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.object2d.Positionable2D |


#### setPosition(x:number, y:number)


Set the position for this object.


| Class | org.squiddev.plethora.gameplay.modules.glasses.objects.object2d.Positionable2D#setPosition(Positionable2D) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.object2d.Positionable2D |


### org.squiddev.plethora.gameplay.modules.glasses.objects.object2d.Rectangle


| Function | Synopsis |
| --- | --- |
| getSize | Get the size of this rectangle. |
| setSize | Set the size of this rectangle. |


#### getSize():number, number


Get the size of this rectangle.


| Class | org.squiddev.plethora.gameplay.modules.glasses.objects.object2d.Rectangle#getSize(Rectangle) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.object2d.Rectangle |


#### setSize(width:number, height:number)


Set the size of this rectangle.


| Class | org.squiddev.plethora.gameplay.modules.glasses.objects.object2d.Rectangle#setSize(Rectangle) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.object2d.Rectangle |


### org.squiddev.plethora.gameplay.modules.glasses.objects.object3d.Box


| Function | Synopsis |
| --- | --- |
| getSize | Get the size of this box. |
| setSize | Set the size of this box. |


#### getSize():number, number, number


Get the size of this box.


| Class | org.squiddev.plethora.gameplay.modules.glasses.objects.object3d.Box#getSize(Box) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.object3d.Box |


#### setSize(width:number, height:number, depth:number)


Set the size of this box.


| Class | org.squiddev.plethora.gameplay.modules.glasses.objects.object3d.Box#setSize(Box) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.object3d.Box |


### org.squiddev.plethora.gameplay.modules.glasses.objects.object3d.DepthTestable


| Function | Synopsis |
| --- | --- |
| isDepthTested | Determine whether depth testing is enabled for this object. |
| setDepthTested | Set whether depth testing is enabled for this object. |


#### isDepthTested():boolean


Determine whether depth testing is enabled for this object.


| Class | org.squiddev.plethora.gameplay.modules.glasses.objects.object3d.DepthTestable#isDepthTested(DepthTestable) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.object3d.DepthTestable |


#### setDepthTested(depthTest:boolean)


Set whether depth testing is enabled for this object.


| Class | org.squiddev.plethora.gameplay.modules.glasses.objects.object3d.DepthTestable#setDepthTested(DepthTestable) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.object3d.DepthTestable |


### org.squiddev.plethora.gameplay.modules.glasses.objects.object3d.MultiPoint3D


| Function | Synopsis |
| --- | --- |
| getPoint | Get the specified vertex of this object. |
| setPoint | Set the specified vertex of this object. |


#### getPoint(idx:int):number, number, number


Get the specified vertex of this object.


| Class | org.squiddev.plethora.gameplay.modules.glasses.objects.object3d.MultiPoint3D#getPoint(MultiPoint3D) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.object3d.MultiPoint3D |


#### setPoint(idx:int, x:number, y:number, z:number)


Set the specified vertex of this object.


| Class | org.squiddev.plethora.gameplay.modules.glasses.objects.object3d.MultiPoint3D#setPoint(MultiPoint3D) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.object3d.MultiPoint3D |


### org.squiddev.plethora.gameplay.modules.glasses.objects.object3d.ObjectRoot3D


| Function | Synopsis |
| --- | --- |
| recenter | Recenter this canvas relative to the current position. |


#### recenter([offset:table])


Recenter this canvas relative to the current position.


| Class | org.squiddev.plethora.gameplay.modules.glasses.objects.object3d.ObjectRoot3D#recenter(ObjectRoot3D) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.object3d.ObjectRoot3D |


### org.squiddev.plethora.gameplay.modules.glasses.objects.object3d.Positionable3D


| Function | Synopsis |
| --- | --- |
| getPosition | Get the position for this object. |
| setPosition | Set the position for this object. |


#### getPosition():number, number, number


Get the position for this object.


| Class | org.squiddev.plethora.gameplay.modules.glasses.objects.object3d.Positionable3D#getPosition(Positionable3D) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.object3d.Positionable3D |


#### setPosition(x:number, y:number, z:number)


Set the position for this object.


| Class | org.squiddev.plethora.gameplay.modules.glasses.objects.object3d.Positionable3D#setPosition(Positionable3D) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.object3d.Positionable3D |


### org.squiddev.plethora.gameplay.modules.glasses.objects.object3d.Rotatable3D


| Function | Synopsis |
| --- | --- |
| getRotation | Get the rotation for this object, or nil if it faces the player. |
| setRotation | Set the rotation for this object, passing nothing if it should face the player. |


#### getRotation():nil|number, number, number


Get the rotation for this object, or nil if it faces the player.


| Class | org.squiddev.plethora.gameplay.modules.glasses.objects.object3d.Rotatable3D#getRotation(Rotatable3D) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.object3d.Rotatable3D |


#### setRotation([x:number, y:number, z:number])


Set the rotation for this object, passing nothing if it should face the player.


| Class | org.squiddev.plethora.gameplay.modules.glasses.objects.object3d.Rotatable3D#setRotation(Rotatable3D) |
| --- | --- |
| Target | org.squiddev.plethora.gameplay.modules.glasses.objects.object3d.Rotatable3D |


## Metadata providers


### dan200.computercraft.shared.computer.blocks.TileComputerBase


#### org.squiddev.plethora.integration.computercraft.MetaTileComputer


### dan200.computercraft.shared.turtle.blocks.ITurtleTile


#### org.squiddev.plethora.integration.computercraft.MetaTileTurtle

  {
  turtle =  {
    color = 23,
    colour = 23,
    fuel = 100,
    left = nil,
    right = nil
   }
 }
### net.minecraft.block.Block


#### org.squiddev.plethora.integration.vanilla.meta.MetaBlock


Provide the registry name, display name and translation key of a block.

  {
  displayName = "Dirt",
  name = "minecraft:dirt",
  translationKey = "tile.dirt"
 }
### net.minecraft.block.material.Material


#### org.squiddev.plethora.integration.vanilla.meta.MetaMaterial

  {
  blocksLight = true,
  blocksMovement = true,
  burns = false,
  liquid = false,
  opaque = true,
  replaceable = false,
  requiresTool = true,
  solid = true
 }
### net.minecraft.block.state.IBlockState


#### org.squiddev.plethora.integration.vanilla.meta.MetaBlockState


Provides some very basic information about a block and its associated state.

  {
  harvestLevel = 0,
  harvestTool = "pickaxe",
  material =   { «nested metadata»  },
  metadata = 0,
  state =  {
    variant = "stone"
   }
 }
### net.minecraft.entity.Entity


#### org.squiddev.plethora.integration.vanilla.meta.MetaEntity


Provides some basic information about an entity, such as their their UUID and
name.

  {
  displayName = "Experience Orb",
  id = "8a28378f-9b8f-4d5c-80e1-7544a01d7847",
  motionX = 0.5,
  motionY = 0,
  motionZ = 0,
  name = "XPOrb",
  pitch = 73,
  withinBlock =  {
    x = 0,
    y = 0.2125,
    z = 0
   },
  x = 11.5,
  y = -0.2875,
  yaw = 30,
  z = -0.5
 }
### net.minecraft.entity.EntityLivingBase


Also includes metadata from Entity


#### org.squiddev.plethora.integration.vanilla.meta.MetaEntityLiving

  {
  armor =  {
    boots = nil,
    chestplate = «reference to net.minecraft.item.ItemStack»,
    helmet = nil,
    leggings = nil
   },
  health = 20,
  heldItem = «reference to net.minecraft.item.ItemStack»,
  isAirborne = false,
  isAlive = true,
  isBurning = false,
  isChild = false,
  isDead = false,
  isElytraFlying = false,
  isInWater = false,
  isOnLadder = false,
  isRiding = false,
  isSleeping = false,
  isSneaking = false,
  isSprinting = false,
  isWet = false,
  maxHealth = 20,
  offhandItem = nil,
  potionEffects = {}
 }
### net.minecraft.entity.item.EntityItem


Also includes metadata from Entity


#### org.squiddev.plethora.integration.vanilla.meta.MetaEntities.ENTITY_ITEM


Provides the stack of a dropped item

  {
  item =   { «nested metadata»  }
 }
### net.minecraft.entity.passive.EntitySheep


Also includes metadata from Entity, EntityLivingBase


#### org.squiddev.plethora.integration.vanilla.meta.MetaEntities.ENTITY_SHEEP


Provides the wool colour of the sheep.

  {
  woolColor = "green",
  woolColour = "green"
 }
### net.minecraft.entity.player.EntityPlayer


Also includes metadata from Entity, EntityLivingBase


#### org.squiddev.plethora.integration.vanilla.meta.MetaEntityPlayer

  {
  allowFlying = false,
  flySpeed = 0.05,
  food =  {
    hunger = 20,
    hungry = false,
    saturation = 5
   },
  isFlying = false,
  walkSpeed = 0.1
 }
### net.minecraft.item.ItemStack


#### org.squiddev.plethora.integration.computercraft.MetaItemPrintout

  {
  printout =  {
    lines = {},
    pages = 0,
    title = "My page",
    type = "Single"
   }
 }
#### org.squiddev.plethora.integration.vanilla.meta.MetaItemBasic

  {
  count = 5,
  damage = 0,
  displayName = "Stick",
  maxCount = 64,
  maxDamage = 0,
  name = "minecraft:stick",
  nbtHash = nil,
  rawName = "item.stick"
 }
#### org.squiddev.plethora.integration.vanilla.meta.MetaItems.ITEM_FOOD


Provides the hunger and saturation this foodstuff restores.

  {
  heal = 5,
  saturation = 0.6
 }
#### org.squiddev.plethora.integration.vanilla.meta.MetaItems.ITEM_POTION


Provides the potion type and effects of this item.

  {
  effects =  {
     {
      amplifier = 0,
      color = 8171462,
      duration = 180,
      instant
= false,
      name = "effect.moveSpeed"
     }
   },
  potion = "minecraft:swiftness",
  potionType = "normal"
 }
#### org.squiddev.plethora.integration.vanilla.meta.MetaItems.ITEM_SPAWN_EGG


Provides information about items captured within spawn eggs.

  {
  storedEntity =   { «nested metadata»  }
 }
#### org.squiddev.plethora.integration.vanilla.meta.MetaItems.ITEM_TOOL_CLASS


Provides the tool classes an item may have.

  {
  toolClass =  {
    pickaxe = 3
   }
 }
#### org.squiddev.plethora.integration.vanilla.meta.VanillaMeta.ENCHANTED_ITEM


Provides the enchantments on an item

  {
  enchantments =  {
     {
      fullName = "Unbreaking V",
      level = 5,
      name = "enchantment.durability"
     }
   }
 }
#### org.squiddev.plethora.integration.computercraft.MetaItemComputer

  {
  computer =  {
    family = "Normal",
    id = 3,
    label = "My computer"
   }
 }
#### org.squiddev.plethora.integration.vanilla.meta.MetaItemOreDict

  {
  ores =  {
    blockGlass = true,
    blockGlassColorless = true
   }
 }
#### org.squiddev.plethora.integration.computercraft.MetaItemMedia

  {
  media =  {
    label = "My disk",
    recordTitle = nil
   }
 }
#### org.squiddev.plethora.integration.plethora.MetaItemModule


#### org.squiddev.plethora.integration.computercraft.MetaItemTurtle

  {
  turtle =  {
    color = 65280,
    colour = 65280,
    fuel = 3000,
    left =  {
      adjective = "upgrade.computercraft:advanced_modem.adjective",
      id = "computercraft:advanced_modem",
      type = "Peripheral"
     },
    right = nil
   }
 }
#### org.squiddev.plethora.integration.vanilla.meta.MetaItemMaterial

  {
  material = "DIAMOND"
 }
#### org.squiddev.plethora.integration.vanilla.meta.MetaItemArmor


Provides type and colour of amour.

  {
  armorType = "chest",
  color = 16711680,
  colour = 16711680
 }
#### org.squiddev.plethora.integration.computercraft.MetaItemPocketComputer

  {
  pocket =  {
    back =  {
      adjective = "upgrade.computercraft:speaker.adjective",
      id = "computercraft:speaker"
     },
    color = 16711680,
    colour = 16711680
   }
 }
#### org.squiddev.plethora.integration.vanilla.meta.MetaItemBanner

  {
  banner =  {
     {
      color = "purple",
      colour = "purple",
      id = "cre",
      name = "creeper"
     }
   }
 }
### net.minecraft.tileentity.MobSpawnerBaseLogic


#### org.squiddev.plethora.integration.vanilla.meta.VanillaMeta.SPAWNER_LOGIC


Provides the entities that this spawner will spawn.

  {
  spawnedEntities =  {
      { «nested metadata»  }
   }
 }
### net.minecraft.tileentity.TileEntitySign


#### org.squiddev.plethora.integration.vanilla.meta.VanillaMeta.TILE_SIGN


Provides the text upon the sign.

  {
  lines =  {
    "This is",
    "my rather fancy",
    "sign.",
    ""
   }
 }
### net.minecraftforge.energy.IEnergyStorage


#### org.squiddev.plethora.integration.vanilla.meta.VanillaMeta.ENERGY


Provides the currently stored energy and capacity of a Forge Energy cell

  {
  energy =  {
    capacity = 50000,
    stored = 1000
   }
 }
### net.minecraftforge.fluids.FluidStack


#### org.squiddev.plethora.integration.vanilla.meta.MetaFluidStack


Provides information about a fluid, as well as how much is currently stored.

  {
  amount = 525,
  displayName = "Water",
  id = "minecraft:water",
  name = "water",
  rawName = "fluid.tile.water"
 }
### net.minecraftforge.fluids.IFluidTank


#### org.squiddev.plethora.integration.vanilla.meta.MetaFluidTank

  {
  capacity = 1000
 }
### net.minecraftforge.fluids.capability.IFluidHandler


#### org.squiddev.plethora.integration.vanilla.meta.MetaFluidHandler

  {
  tanks =  {
      { «nested metadata»  }
   }
 }
### net.minecraftforge.fluids.capability.IFluidTankProperties


#### org.squiddev.plethora.integration.vanilla.meta.MetaFluidTankProperties

  {
  capacity = 1000
 }
### org.squiddev.plethora.api.reference.BlockReference


#### org.squiddev.plethora.integration.vanilla.meta.MetaDaylightSensor


Provides metadata about block light levels, when the daylight sensor module is
attached.


#### org.squiddev.plethora.integration.vanilla.meta.MetaBlockReference


Provides information about blocks which exist in the world.

  {
  color = 9923917,
  colour = 9923917,
  hardness = 0.5
 }
### org.squiddev.plethora.integration.MetaWrapper


#### org.squiddev.plethora.integration.MetaWrapper$MetaProvider


Simply wraps an object and exposes metadata for that.


You can happily ignore this.


### org.squiddev.plethora.integration.vanilla.NullableItemStack


#### org.squiddev.plethora.integration.vanilla.NullableItemStack$MetaNullableItemStack


Simply wraps an item stack with additional information.


Refer to the documentation on those instead for more information.


### Basic concepts


[Getting started](https://plethora.madefor.cc/getting-started.html)
[Manipulating modules](https://plethora.madefor.cc/modules.html)
[The neural interface](https://plethora.madefor.cc/neural-interface.html)
[Moving items](https://plethora.madefor.cc/item-transfer.html)


### Server management


[The cost system](https://plethora.madefor.cc/cost-system.html)
[Configuring Plethora](https://plethora.madefor.cc/configuring.html)


### Blocks and Items


[Introspection module](https://plethora.madefor.cc/items/module-introspection.html)
[Frickin' laser beam](https://plethora.madefor.cc/items/module-laser.html)
[Block scanner](https://plethora.madefor.cc/items/module-scanner.html)
[Entity sensor](https://plethora.madefor.cc/items/module-sensor.html)
[Kinetic augment](https://plethora.madefor.cc/items/module-kinetic.html)
[Chat recorder](https://plethora.madefor.cc/items/module-chat.html)
[Overlay glasses](https://plethora.madefor.cc/items/module-glasses.html)
[Minecart computer](https://plethora.madefor.cc/items/minecart.html)
[Redstone integrator](https://plethora.madefor.cc/items/redstone-integrator.html)
[Keyboard](https://plethora.madefor.cc/items/keyboard.html)


### Method reference


### Examples


[Laser drill](https://plethora.madefor.cc/examples/laser-drill.html)
[Laser sentry](https://plethora.madefor.cc/examples/laser-sentry.html)
[Auto feeder](https://plethora.madefor.cc/examples/auto-feeder.html)
[Fly](https://plethora.madefor.cc/examples/fly.html)
[Ore scanner](https://plethora.madefor.cc/examples/ore-scanner.html)

© 2021 SquidDevView this page on [GitHub](https://github.com/SquidDev-CC/plethora/blob/gh-pages/methods.html).