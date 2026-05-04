  [Plethora](https://plethora.madefor.cc/) [ Curse](https://minecraft.curseforge.com/projects/plethora-peripherals)[ GitHub](https://github.com/SquidDev-CC/plethora) 
## Introspection module


The introspection module allows accessing the inventory of a player, also
providing the ability to get basic information about yourself.


| Module: | plethora:introspection (view methods) |
| --- | --- |
| Usable in: | Manipulator Neural interface Pocket computers Turtle |

![Image](https://plethora.madefor.cc/images/items/module-introspection.png)


### Basic usage


Once the introspection module is equipped and wrapped as a peripheral, you will
be able to fetch the current entity/turtle’s inventory. With that object you can
use [any standard inventory method](https://plethora.madefor.cc/methods.html#targeted-methods-net.minecraftforge.items.IItemHandler).

 
```
local introspection = peripheral.wrap(--[[ whatever ]])

local inv = introspection.getInventory()
local item = inv.getItemMeta(1)
if item then
	print(item.displayName .. " at slot #1")
end

```

When using the introspection module within a manipulator, you will need to bind
it to a player. This can be done by shift + right-clicking it. The module will
now function as normal, acting on the bound player’s inventory instead.


Note that the introspection module also works on simple mobs and turtles, though
you they do not have as large an inventory as players.


### Transferring between inventories

> 


If you’re unfamiliar with Plethora’s item transfer system, I suggest [you read the introduction first](https://plethora.madefor.cc/item-transfer.html).


The introspection module also provides access to the player’s ender chest and,
if installed, the Baubles inventory. While there are methods to access them (`.getEnder()` and `.getBaubles()` respectively), you can also use the item transfer system to move things between
them.

 
```
local inv = introspection.getInventory()
local ender = introspection.getEnder()

inv.pushItems("ender_chest", 1) -- Move slot 1 into the ender chest
for slot, item in pairs(ender.list()) do
	print(string.format("#%d: %s", slot, item.name))
end

```

### Other functionality


Right-clicking with the introspection module will open the current player’s
ender chest.


### Basic concepts


[Getting started](https://plethora.madefor.cc/getting-started.html)
[Manipulating modules](https://plethora.madefor.cc/modules.html)
[The neural interface](https://plethora.madefor.cc/neural-interface.html)
[Moving items](https://plethora.madefor.cc/item-transfer.html)


### Server management


[The cost system](https://plethora.madefor.cc/cost-system.html)
[Configuring Plethora](https://plethora.madefor.cc/configuring.html)


### Blocks and Items


Introspection module
[Frickin' laser beam](https://plethora.madefor.cc/items/module-laser.html)
[Block scanner](https://plethora.madefor.cc/items/module-scanner.html)
[Entity sensor](https://plethora.madefor.cc/items/module-sensor.html)
[Kinetic augment](https://plethora.madefor.cc/items/module-kinetic.html)
[Chat recorder](https://plethora.madefor.cc/items/module-chat.html)
[Overlay glasses](https://plethora.madefor.cc/items/module-glasses.html)
[Minecart computer](https://plethora.madefor.cc/items/minecart.html)
[Redstone integrator](https://plethora.madefor.cc/items/redstone-integrator.html)
[Keyboard](https://plethora.madefor.cc/items/keyboard.html)


### [Method reference](https://plethora.madefor.cc/methods.html)


### Examples


[Laser drill](https://plethora.madefor.cc/examples/laser-drill.html)
[Laser sentry](https://plethora.madefor.cc/examples/laser-sentry.html)
[Auto feeder](https://plethora.madefor.cc/examples/auto-feeder.html)
[Fly](https://plethora.madefor.cc/examples/fly.html)
[Ore scanner](https://plethora.madefor.cc/examples/ore-scanner.html)

© 2021 SquidDevView this page on [GitHub](https://github.com/SquidDev-CC/plethora/blob/gh-pages/items/module-introspection.md).
  [Plethora](https://plethora.madefor.cc/) [ Curse](https://minecraft.curseforge.com/projects/plethora-peripherals)[ GitHub](https://github.com/SquidDev-CC/plethora) 
## Kinetic augment


The kinetic augment is the latest breakthrough in biocybernetics. It grants a
computer direct access to the nervous system of a player or mob.


| Module: | plethora:kinetic (view methods) |
| --- | --- |
| Usable in: | Minecart computer Neural interface Pocket computer Turtle |

![Image](https://plethora.madefor.cc/images/items/module-kinetic.png)


### Basic usage


While the kinetic augment has a wide range of functions, the best place to start
is the most fun: `.launch()`. This functions very similarly to a laser’s `.fire()` method: taking a yaw and pitch (horizontal and vertical angle) and a power.
When called, this will catapult the current entity in the supplied direction, the
resulting velocity depending on the provided power.

 
```
local kinetic = peripheral.wrap(--[[ whatever ]])

-- Continuously fire the player into the sky
while true do
	kinetic.launch(0, -90, 4)
	sleep(0.5)
end

```

Combined with other modules, the kinetic augment can be used in great number of
ways. One can fire yourself in the direction you’re currently looking, slow your
descent if you’re falling to fast, etc… Take a look at some of the examples to
get some ideas.


### With turtles


Kinetic augments can also be used as a turtle upgrade. When equipped, it acts as
both a tool and peripheral. `turtle.dig()` or `turtle.attack()` will use the currently selected item in the inventory to break blocks or
attack.


Beware, turtles do not use these tools with their normal finesse. Durability
will be consumed, and blocks may take multiple swings to break.


### Other functionality


If you’re a low-tech kind of person, you can always experience the joys of `.launch()` by hand. First, hold carefully grip the kinetic augment with either hand. Then
charge it up by holding right click, feeling the raw power accumulate in your
muscles. Finally release, and enjoy the feel of the wind rushing in your hair and
the rapidly approaching brick wall.


### Configuring


The kinetic augment can be configured with the `kinetic` section of the `plethora.cfg` file.


• 
`launchMax=4`: The maximum power that can be used to launch an entity.
• 
`launchCost=4`: The cost per power level to launch an entity. By default a computer will gain
10 energy points each tick ([read about the cost system](https://plethora.madefor.cc/cost-system.html) for more information).
• 
`launchYScale=0.5`: The amount the y velocity is scaled when launching an entity. The Y axis does
not experience friction in the same way other axis do, and so small changes in
veloctity have a marge larger effect.
• 
`launchElytraScale=0.4`: The amount a player’s velocity is scaled by if they are using an elytra. When
flying a player experiences much less friction, meaning small velocity increases
can send the player a long distance.
• 
`launchFallReset=true`: Whether to scale the fall distance if a player launches themselves. Minecraft
computes fall damage from how long a player has been in the air rather than what
speed they are travelling at. Consequently you can be falling very slowly but
still die. If a player launches themselves upwards Plethora will correct the fall
distance to account for the change in velocity.


Note that this may not function correctly with wolds with custom gravity, such
as Galacticraft planets.
• 
`launchFloatReset=true`: Whether to reset the “floating” time after launching. This allows players to
fly with the kinetic augment without being kicked.

> 


Note: This is not an exhaustive list of configuration options for the kinetic augment
- this only includes ones which require further explaination. Please consult
the config file for a full list.


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
Kinetic augment
[Chat recorder](https://plethora.madefor.cc/items/module-chat.html)
[Overlay glasses](https://plethora.madefor.cc/items/module-glasses.html)
[Minecart computer](https://plethora.madefor.cc/items/minecart.html)
[Redstone integrator](https://plethora.madefor.cc/items/redstone-integrator.html)
[Keyboard](https://plethora.madefor.cc/items/keyboard.html)


### [Method reference](https://plethora.madefor.cc/methods.html)


### Examples


[Laser drill](https://plethora.madefor.cc/examples/laser-drill.html)
[Laser sentry](https://plethora.madefor.cc/examples/laser-sentry.html)
[Auto feeder](https://plethora.madefor.cc/examples/auto-feeder.html)
[Fly](https://plethora.madefor.cc/examples/fly.html)
[Ore scanner](https://plethora.madefor.cc/examples/ore-scanner.html)

© 2021 SquidDevView this page on [GitHub](https://github.com/SquidDev-CC/plethora/blob/gh-pages/items/module-kinetic.md).