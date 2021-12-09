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

local basins = {}
local traversed = {}

function travel(coord)
  local x = coord:match("^[0-9]+") * 1
  local y = coord:match("[0-9]+$") * 1
  local height = world[coord]
  local result = 1
  if not height then
    return 0
  end
  
  if traversed[coord] then
    return 0
  else
    traversed[coord] = true
  end
  
  if height == 9 then
    return 0
  end
  
  --Top
  if world[x.." "..(y + 1)] ~= nil then
    if world[x.." "..(y + 1)] ~= 9 then
      result = result + travel(x.." "..(y + 1))
    end
  end
  
  --Bottom
  if world[x.." "..(y - 1)] ~= nil then
    if world[x.." "..(y - 1)] ~= 9 then
      result = result + travel(x.." "..(y - 1))
    end
  end
  
  --Right
  if world[(x + 1).." "..y] ~= nil then
    if world[(x + 1).." "..y] ~= 9 then
      result = result + travel((x + 1).." "..y)
    end
  end
  
  --Left
  if world[(x - 1).." "..y] ~= nil then
    if world[(x - 1).." "..y] ~= 9 then
      result = result + travel((x - 1).." "..y)
    end
  end
  
  return result
end

for _, v in ipairs(lowPoints) do
  local basinSize = travel(v[1])
  if basinSize > 1 then
    basins[#basins + 1] = basinSize
  end
end

table.sort(basins)
print(basins[#basins], basins[#basins - 1], basins[#basins - 2])
print(basins[#basins] * basins[#basins - 1] * basins[#basins - 2])
