  [Plethora](https://plethora.madefor.cc/) [ Curse](https://minecraft.curseforge.com/projects/plethora-peripherals)[ GitHub](https://github.com/SquidDev-CC/plethora) 
## The cost system


Plethora’s cost system is a way of limiting the rate at which methods can be
called, ensuring that certain features are not abused. By default, a fixed buffer
of “energy” is allocated for every owning object (be it tile entity or entity).
This energy regenerates by a fixed amount over time. Each method call will
consume a configurable amount of energy from this buffer, waiting for the buffer to
replenish if there is no energy left.


Whilst each method can consume a fixed level of energy, some methods will
consume additional energy based on its arguments. One such example would be lasers,
which consume more energy the higher their potency.


It is possible to configure the rate at which the internal buffer regenerates,
and the maximum size of the buffer through the `Cost System` section of the `plethora-core.cfg` configuration file (or in the Minecraft GUI). You can also set the base cost
for every method in the same file. For more information about configuring
Plethora, read [this document](https://plethora.madefor.cc/configuring.html#cost-system).


### Negative energy


There may be a time where you want to have a method consume significant amounts
of energy, but not increase the size of the energy buffer. If so, you may wish
to enable the `allowNegative` option. This allows the energy buffer to enter the negative region, though
methods will fail if there is negative energy. This option, when combined with a
buffer limit of 0, allows a more traditional rate limiting system as you must wait
after every method call rather than being able to batch them.


### Hard failure


Previous versions of Plethora would error if there was insufficient energy,
instead of waiting for the buffer to fill up again. This functionality can be
re-enabled by setting the `awaitRegen` to false. While it does make it harder to write programs which run under
different configurations, it does make it easier to discover potential performance
issues.


### Basic concepts


[Getting started](https://plethora.madefor.cc/getting-started.html)
[Manipulating modules](https://plethora.madefor.cc/modules.html)
[The neural interface](https://plethora.madefor.cc/neural-interface.html)
[Moving items](https://plethora.madefor.cc/item-transfer.html)


### Server management


The cost system
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


### [Method reference](https://plethora.madefor.cc/methods.html)


### Examples


[Laser drill](https://plethora.madefor.cc/examples/laser-drill.html)
[Laser sentry](https://plethora.madefor.cc/examples/laser-sentry.html)
[Auto feeder](https://plethora.madefor.cc/examples/auto-feeder.html)
[Fly](https://plethora.madefor.cc/examples/fly.html)
[Ore scanner](https://plethora.madefor.cc/examples/ore-scanner.html)

© 2021 SquidDevView this page on [GitHub](https://github.com/SquidDev-CC/plethora/blob/gh-pages/cost-system.md).