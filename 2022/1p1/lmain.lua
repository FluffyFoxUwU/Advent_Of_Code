#!/usr/bin/env lua5.4

local elfs = {}

--Main reading loop
local it = io.lines()
for line in it do
  local cals = tonumber(line)
  
  for line in it do
    if tonumber(line) ~= nil then
      cals = cals + tonumber(line)
    else
      break
    end
  end
  
  elfs[#elfs + 1] = cals
end

local largest = nil
local currentLargestCals = 0
for i, cal in ipairs(elfs) do
  if cal > currentLargestCals then
    largest = i
    currentLargestCals = cal
  end
end

print(elfs[largest])




