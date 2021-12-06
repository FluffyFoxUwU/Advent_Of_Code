#!/usr/bin/env lua5.4

--Main reading loop
local fishes = {}
for num in io.read():gmatch("[0-9]+") do
  fishes[#fishes + 1] = num
end

for i=1,80 do
  local newFishes = {}
  
  for _, fish in ipairs(fishes) do
    if fish == 0 then
      newFishes[#newFishes + 1] = 8
      fish = 7
    end
    
    fish = fish - 1
    newFishes[#newFishes + 1] = fish
  end
  
  fishes = newFishes
end

print(#fishes)
