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

table.sort(elfs)
print(elfs[#elfs] + elfs[#elfs - 1] + elfs[#elfs - 2])

