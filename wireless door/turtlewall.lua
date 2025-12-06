local height = 0
local width = 10

turtle.select(1)
local itemCount = turtle.getItemCount(1)
referenceDetail = getItemDetail()
for i = 2, 16 do
    turlte.select(i)
    if compareItemDetail(referenceDetail, getItemDetail()) then
        itemCount = itemCount + turtle.getItemCount(i)
    end



for i = 1, height do
    turtle.select(1)
    itemCount = turtle.getItemCount(1)
    print(itemCount)
    end
end