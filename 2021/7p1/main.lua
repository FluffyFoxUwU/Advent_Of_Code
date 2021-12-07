#!/usr/bin/env lua5.4

--Main reading loop
local crabs = {}
for num in io.read():gmatch("[0-9]+") do
  crabs[#crabs + 1] = num
end

local lowest = 9e9
for _, target in ipairs(crabs) do
  local cost = 0
  for _, crab in ipairs(crabs) do
    cost = cost + math.abs(crab - target)
  end
  if cost < lowest then
    lowest = cost 
  end 
end

print(lowest)

