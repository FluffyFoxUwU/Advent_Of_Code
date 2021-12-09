#!/usr/bin/env lua5.4

--Main reading loop
local world = {}
local y = 1
for line in io.lines() do
  local x = 1
  for num in line:gmatch(".") do
    world[x.." "..y] = tonumber(num)
    x = x + 1
  end
  y = y + 1
end

local lowPoints = {}
for coord, height in pairs(world) do
  local x = coord:match("^[0-9]+") * 1
  local y = coord:match("[0-9]+$") * 1
  local found = 0
  
  --Top
  if world[x.." "..(y + 1)] ~= nil then
    if world[x.." "..(y + 1)] > height then
      found = found + 1 
    end
  else
    found = found + 1
  end
  
  --Bottom
  if world[x.." "..(y - 1)] ~= nil then
    if world[x.." "..(y - 1)] > height then
      found = found + 1 
    end
  else
    found = found + 1
  end
  
  --Right
  if world[(x + 1).." "..y] ~= nil then
    if world[(x + 1).." "..y] > height then
      found = found + 1 
    end
  else
    found = found + 1
  end
  
  --Left
  if world[(x - 1).." "..y] ~= nil then
    if world[(x - 1).." "..y] > height then
      found = found + 1 
    end
  else
    found = found + 1
  end
  
  if found == 4 then
    lowPoints[#lowPoints + 1] = {coord, height}
  end
end

local result = 0
for _, point in ipairs(lowPoints) do
  result = result + point[2] + 1
end

print(result)
