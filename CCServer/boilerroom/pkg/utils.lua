local utils = {}

function utils.inTable(tbl, item)
    for _, val in ipairs(tbl) do
        if val == item then return true end
    end
    return false
end

--- Get total count for a single item ID
-- @param container table: The peripheral handle (e.g., vault)
-- @param itemName string: The item registry name (e.g., "minecraft:diamond")
-- @return number: The total count of that item
function utils.getItemCount(container, itemName)
    local rawData = container.items()
    local total = 0

    for _, item in pairs(rawData) do
        if item and item.name == itemName then
            total = total + item.count
        end
    end

    return total
end

return utils