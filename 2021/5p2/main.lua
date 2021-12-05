#!/usr/bin/env lua5.4

local world = {}

--Main reading loop
for line in io.lines() do
  local x1, y1
  local x2, y2
  
  for num in line:gmatch("[0-9]+") do
    if x1 then
      if y1 then
        if x2 then
          if y2 then
            --null
          else
            y2 = num
          end
        else
          x2 = num
        end
      else
        y1 = num
      end
    else
      x1 = num
    end
  end
  x1 = x1*1
  y1 = y1*1
  x2 = x2*1
  y2 = y2*1
  
  if x1 == x2 then
    local delta = (y1 < y2) and 1 or -1
    local y=y1
    while true do
      world[x1.." "..y] = (world[x1.." "..y] or 0) + 1
      
      if y == y2 then
        break
      end
      y = y + delta
    end
  elseif y1 == y2 then
    local delta = (x1 < x2) and 1 or -1
    local x = x1
    while true do
      world[x.." "..y1] = (world[x.." "..y1] or 0) + 1
      
      if x == x2 then
        break
      end
      
      x = x + delta
    end
  else
    local deltaX = (x1 < x2) and 1 or -1
    local deltaY = (y1 < y2) and 1 or -1
    local x = x1
    local y = y1
    while true do
      world[x.." "..y] = (world[x.." "..y] or 0) + 1
      
      if x == x2 or y == y2 then
        break
      end
      
      x = x + deltaX
      y = y + deltaY
    end
  end
end

local count = 0
for _, p in pairs(world) do
  if p > 1 then
    count = count + 1
  end
end

print(count)

