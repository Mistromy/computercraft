  Skip to content [Create Wiki](https://wiki.createmod.net/) Search Ctrl K  MenuOn this page    
Train schedules are represented by a table in Lua. The table contains a list of
entries where each entry has a single instruction and multiple conditions. Each
instruction and condition has a `data` table that stores specific data about the instruction or condition.

 lua 
```
schedule = {
  cyclic = true, -- Does the schedule repeat itself after the end has been reached?
  entries = { -- List of entries, each entry contains a single instruction and multiple conditions.
    {
      instruction = {
        id = "create:destination", -- The different instructions are described below.
        data = { -- Data that is stored about the instruction. Different for each instruction type.
          text = "Station 1",
        },
      },
      conditions = {    -- List of lists of conditions. The outer list is the "OR" list
        {               -- and the inner lists are "AND" lists.
          {
            id = "create:delay", -- The different conditions are described below.
            data = { -- Data that is stored about the condition. Different for each condition type.
              value = 5,
              time_unit = 1,
            },
          },
          {
            id = "create:powered",
            data = {},
          },
        },
        {
          {
            id = "create:time_of_day",
            data = {
              rotation = 0,
              hour = 14,
              minute = 0,
            },
          },
        },
      },
    },
  },
}
```

If this seems a bit confusing, you may also check out some community-made [libraries](https://wiki.createmod.net/users/cc-tweaked-integration/train/libraries) for creating schedules.


## InstructionsPermalink to "Instructions"


|  |
|  |
| "create:destination" | Move to a certain train station |
| "create:rename" | Change the schedule title |
| "create:throttle" | Change the train's throttle |


### `"create:destination"`Permalink to "`"create:destination"`"


Moves the train to the chosen train station. This instruction must have at least
one condition.


Data


• text: `string` The name of the station to travel to. Can include * as a wildcard.


### `"create:rename"`Permalink to "`"create:rename"`"


Renames the schedule. This name shows up on display link targets. This
instruction cannot have conditions.


Data


• text: `string` The name to rename the schedule to.


### `"create:throttle"`Permalink to "`"create:throttle"`"


Changes the throttle of the train. This instruction cannot have conditions.


Data


• value: `number` The throttle to set the train to. Must be an integer within the range of
[5..100].


## ConditionsPermalink to "Conditions"


Conditions are stored in a list of lists of conditions. The inner lists contain
conditions that get `AND`'ed together. They must all be met for that group to be true. The outer list
contains the `AND`'ed groups of conditions that get `OR`'ed together. Only one of the groups needs to be true for the schedule to move
onto the next instruction.


|  |
|  |
| "create:delay" | Wait for a certain delay |
| "create:time_of_day" | Wait for a specific time of day |
| "create:fluid_threshold" | Wait for a certain amount of fluid to be on board |
| "create:item_threshold" | Wait for a certain amount of items to be on board |
| "create:redstone_link" | Wait for a redstone link to be powered |
| "create:player_count" | Wait for a certain amount of players to be on board |
| "create:idle" | Wait for cargo loading inactivity |
| "create:unloaded" | Wait for the current chunk to be unloaded |
| "create:powered" | Wait for the station to be powered |


### `"create:delay"`Permalink to "`"create:delay"` {#createdelay}"


Wait for a set delay. Can be measured in ticks, seconds or minutes.


Data


• value: `number` The amount of time to wait for.
• time_unit: `number` The unit of time. 0 for ticks, 1 for seconds and 2 for minutes.


### `"create:time_of_day"`Permalink to "`"create:time_of_day"` {#createtimeofday}"


Wait for a time of day, then repeat at a specified interval.


Data


• hour: `number` The hour of the day to wait for in a 24-hour format. Must be an integer within
the range of [0..23].
• minute: `number` The minute of the hour to wait for. Must be an integer within the range of
[0..59].
• rotation: `number` The interval to repeat at after the time of day has been met. Check the
rotation table below for valid values. Must be an integer within the range of [0..9].


Rotation


|  |
|  |
| 0 | Every Day |
| 1 | Every 12 Hours |
| 2 | Every 6 Hours |
| 3 | Every 4 Hours |
| 4 | Every 3 Hours |
| 5 | Every 2 Hours |
| 6 | Every Hour |
| 7 | Every 45 Minutes |
| 8 | Every 30 Minutes |
| 9 | Every 15 Minutes |


### `"create:fluid_threshold"`Permalink to "`"create:fluid_threshold"` {#createfluidthreshold}"


Wait for a certain amount of a specific fluid to be loaded onto the train.


Data


• bucket: `table` The bucket item of the fluid.
• threshold: `number` The threshold in number of buckets of fluid. Must be a positive integer.
• operator: `number` Whether the condition should wait for the train to be loaded above the
threshold, below the threshold or exactly at the threshold. 0 for greater than, 1 for
less than, 2 for equal to.
• measure: `number` The unit to measure the fluid in. This condition supports buckets as the only
unit. Set to 0.


See also


• Items How items are represented in Lua.


### `"create:item_threshold"`Permalink to "`"create:item_threshold"` {#createitemthreshold}"


Wait for a certain amount of a specific item to be loaded onto the train.


Data


• item: `table` The item.
• threshold: `number` The threshold of items. Must be a positive integer.
• operator: `number` Whether the condition should wait for the train to be loaded above the
threshold, below the threshold or exactly at the threshold. 0 for greater than, 1 for
less than, 2 for equal to.
• measure: `number` The unit to measure the items in. 0 for items. 1 for stacks of items.


See also


• Items How items are represented in Lua.


### `"create:redstone_link"`Permalink to "`"create:redstone_link"` {#createredstonelink}"


Wait for a redstone link to be powered.


Data


• frequency: `{ table... }` A list of the two items making up the redstone link frequency.
• inverted: `number` Whether the redstone link should be powered or not to meet the condition. 0 for
powered. 1 for not powered.


See also


• Items How items are represented in Lua.


### `"create:player_count"`Permalink to "`"create:player_count"` {#createplayercount}"


Wait for a certain amount of players to be seated on the train.


Data


• count: `number` The number of players to be seated on the train. Must be a positive integer.
• exact: `number` Whether the seated player count has to be exact to meet the condition. 0 for
the exact amount of players seated, 1 for a greater than or equal amount of seated
players.


### `"create:idle"`Permalink to "`"create:idle"` {#createidle}"


Wait for a period of inactivity in loading or unloading the train. Can be
measured in ticks, seconds or minutes.


Data


• value: `number` The amount of idle time to meet the condition. Must be a positive integer.
• time_unit: `number` The unit of time. 0 for ticks, 1 for seconds and 2 for minutes.


### `"create:unloaded"`Permalink to "`"create:unloaded"` {#createunloaded}"


Wait for the chunk the train is in to be unloaded.


### `"create:powered"`Permalink to "`"create:powered"` {#createpowered}"


Wait for the station to be powered with a redstone signal.


## ItemsPermalink to "Items"


In Lua, items are represented with an ID and a count.

 lua 
```
item = {
  id = "minecraft:stone",
  count = 1,
}
```

• id: `string` The ID of the item.
• count: `number` The number of items in the stack. To work with train schedules the count should
always be 1. Must be an integer.

[Edit this page on GitHub](https://github.com/Creators-of-Create/wiki/edit/main/src/users/cc-tweaked-integration/train/train-schedule.md)
Last updated: 8/8/25, 7:44 PM



## Additional Links
- [For Users](https://wiki.createmod.net/users)
- [Development Status](https://wiki.createmod.net/users/development-status)
- [Supporting Create](https://wiki.createmod.net/users/support-create)
- [View changelogs](https://wiki.createmod.net/users/changelogs/)
- [Packager](https://wiki.createmod.net/users/cc-tweaked-integration/logistics/packager)
- [Re-Packager](https://wiki.createmod.net/users/cc-tweaked-integration/logistics/repackager)
- [Stock Ticker](https://wiki.createmod.net/users/cc-tweaked-integration/logistics/stock-ticker)
- [Redstone Requester](https://wiki.createmod.net/users/cc-tweaked-integration/logistics/redstone-requester)
- [Table Cloth](https://wiki.createmod.net/users/cc-tweaked-integration/logistics/table-cloth)
- [Package Frogport](https://wiki.createmod.net/users/cc-tweaked-integration/logistics/package-frogport)
- [Postbox](https://wiki.createmod.net/users/cc-tweaked-integration/logistics/postbox)
- [Package Object](https://wiki.createmod.net/users/cc-tweaked-integration/logistics/package-object)
- [Order Data Object](https://wiki.createmod.net/users/cc-tweaked-integration/logistics/order-data-object)
- [Train Station](https://wiki.createmod.net/users/cc-tweaked-integration/train/train-station)
- [Train Signal](https://wiki.createmod.net/users/cc-tweaked-integration/train/train-signal)
- [Train Observer](https://wiki.createmod.net/users/cc-tweaked-integration/train/train-observer)
- [Train Schedule](https://wiki.createmod.net/users/cc-tweaked-integration/train/train-schedule)
- [Libraries](https://wiki.createmod.net/users/cc-tweaked-integration/train/libraries)
- [Nixie Tube](https://wiki.createmod.net/users/cc-tweaked-integration/nixie-tube)
- [Display Link](https://wiki.createmod.net/users/cc-tweaked-integration/display-link)
- [Sticker](https://wiki.createmod.net/users/cc-tweaked-integration/sticker)
- [Sequenced Gearshift](https://wiki.createmod.net/users/cc-tweaked-integration/sequenced-gearshift)
- [Rotational Speed Controller](https://wiki.createmod.net/users/cc-tweaked-integration/rotational-speed-controller)
- [Creative Motor](https://wiki.createmod.net/users/cc-tweaked-integration/creative-motor)
- [Speedometer](https://wiki.createmod.net/users/cc-tweaked-integration/speedometer)
- [Stressometer](https://wiki.createmod.net/users/cc-tweaked-integration/stressometer)
- [Previous page Train Observer](https://wiki.createmod.net/users/cc-tweaked-integration/train/train-observer)
- [Next page Libraries](https://wiki.createmod.net/users/cc-tweaked-integration/train/libraries)