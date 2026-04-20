  [Plethora](https://plethora.madefor.cc/) [ Curse](https://minecraft.curseforge.com/projects/plethora-peripherals)[ GitHub](https://github.com/SquidDev-CC/plethora) 
## Auto feeder [Raw](https://plethora.madefor.cc/examples/auto-feeder.lua)


This script attempts to keep the player fully fed by checking their food level
and scanning for food items.


Firstly we find a manipulator or neural interface and error if it is not there.

 
```
local modules = peripheral.find("manipulator") or peripheral.find("neuralInterface")
if not modules then
	error("Must have neural interface or manipulator", 0)
end

```

We require the entity sensor to get the food levels and the introspection module
to access the player’s inventory. We use `hasModule` to ensure they are both there.

 
```
if not modules.hasModule("plethora:sensor") then
	error("The entity sensor is missing", 0)
end
if not modules.hasModule("plethora:introspection") then
	error("The introspection module is missing", 0)
end

```

We’ll want to scan the player’s inventory a lot so we cache it here.

 
```
local inv = modules.getInventory()

```

Instead of rescanning the inventory every time we cache the last slot we ate
from. As we haven’t searched for food yet, we’ll just use nil.

 
```
local cachedSlot = false

```

We run this top level loop continuously, checking every 5 seconds to see if the
player is hungry. This means we will feed the player pretty quickly after they
become hungry.

 
```
while true do

```

We fetch the metadata about the current owner which includes food levels. We run
this inner loop whilst the player is hungry to ensure they are fed quickly
without a delay (which you would get if this ran in the top loop).

 
```
	local data = modules.getMetaOwner()
	while data.food.hungry do

```

We want to find an item that we can eat. Note that this does not search for the
most “optimal” piece of food, just the first one it finds.


First we look in the `cachedSlot` if we have one from before. If it is a food we use it, otherwise we reset the
cached slot.

 
```
		local item
		if cachedSlot then
			local slotItem = inv.getItem(cachedSlot)
			if slotItem and slotItem.consume then
				item = slotItem
			else
				cachedSlot = nil
			end
		end

```

If the cached slot didn’t yield any food then scan the reset of the inventory.
We use `.list()` instead of iterating over each slot as this guarentees there will be an item
there, making the scanning slightly quicker. If we find a food item then we cache
the slot for next time and exit from the loop.

 
```
		if not item then
			for slot, meta in pairs(inv.list()) do
				local slotItem = inv.getItem(slot)
				if slotItem and slotItem.consume then
					print("Using food from slot " .. slot)
					item = slotItem
					cachedSlot = slot
					break
				end
			end
		end

```

If we found food then we eat it and re-run the loop, otherwise we stop scanning
this time and allow ourselves to sleep.

 
```
		if item then
			item.consume()
		else
			print("Cannot find food")
			break
		end

```

As the hungry flag may have changed we refetch the data and rerun the feeding
loop.

 
```
		data = modules.getMetaOwner()
	end

```

The player is now no longer hungry or we have no food so we sleep for a bit.

 
```
	sleep(5)
end

```

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


### [Method reference](https://plethora.madefor.cc/methods.html)


### Examples


[Laser drill](https://plethora.madefor.cc/examples/laser-drill.html)
[Laser sentry](https://plethora.madefor.cc/examples/laser-sentry.html)
Auto feeder
[Fly](https://plethora.madefor.cc/examples/fly.html)
[Ore scanner](https://plethora.madefor.cc/examples/ore-scanner.html)

© 2021 SquidDevView this page on [GitHub](https://github.com/SquidDev-CC/plethora/blob/gh-pages/examples/auto-feeder.md).