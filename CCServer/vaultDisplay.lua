local vault = peripheral.find("create:item_vault")
local monitor = peripheral.find("monitor")

if not vault then error("No Create item vault found") end
if not monitor then error("No monitor found") end

monitor.setTextScale(0.5)

local vaultCapacity = 72 * 20 * 64

local function trimText(text, limit)
    if #text <= limit then
        return text
    end

    return text:sub(1, math.max(1, limit - 3)) .. "..."
end

local function formatStacks(count)
    local stacks = math.floor(count / 64)
    local items = count % 64
    return string.format("%d s %d i", stacks, items)
end

local function padRight(text, width)
    if #text >= width then
        return text
    end

    return text .. string.rep(" ", width - #text)
end

while true do
    local rawData = vault.items()
    local itemRows = {}
    local totalItems = 0

    for _, item in pairs(rawData) do
        if item and item.name then
            local row = itemRows[item.name]

            if not row then
                row = {
                    name = item.name,
                    displayName = item.displayName or item.name,
                    count = 0
                }
                itemRows[item.name] = row
            end

            row.count = row.count + item.count
            totalItems = totalItems + item.count
        end
    end

    local sortedItems = {}

    for _, row in pairs(itemRows) do
        sortedItems[#sortedItems + 1] = row
    end

    table.sort(sortedItems, function(left, right)
        if left.count == right.count then
            return left.displayName < right.displayName
        end

        return left.count > right.count
    end)

    monitor.clear()
    monitor.setCursorPos(1, 1)

    local width, height = monitor.getSize()
    local rowsToShow = math.max(0, height - 1)

    for index = 1, math.min(#sortedItems, rowsToShow) do
        local row = sortedItems[index]
        local exactCount = tostring(row.count)
        local countText = formatStacks(row.count)
        local leftText = row.displayName .. " " .. exactCount
        local line = leftText

        if #leftText + #countText < width then
            line = padRight(leftText, width - #countText) .. countText
        else
            line = trimText(leftText, math.max(1, width - #countText)) .. countText
        end

        monitor.write(trimText(line, width))

        if index < math.min(#sortedItems, rowsToShow) then
            monitor.setCursorPos(1, index + 1)
        end
    end

    if height > 0 then
        local freeItems = math.max(0, vaultCapacity - totalItems)
        local footer = string.format("Free %s", formatStacks(freeItems))
        monitor.setCursorPos(1, height)
        monitor.write(trimText(footer, width))
    end

    sleep(5) -- Refresh every 5 seconds
end
