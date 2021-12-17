#!/usr/bin/env lua5.4

local line = io.read()
local iterator = line:gmatch("[-]?%d+")
local x1, x2 = iterator()*1, iterator()*1
local y1, y2 = iterator()*1, iterator()*1

-- Offset coords to be above 0 
local startX, startY = 0, math.abs(y1)
y2 = y2 + math.abs(y1)
y1 = 0
y1, y2 = y2, y1

function isOvershoot(x, y)
  return x > x2 or y < y2
end

function isHitTarget(x, y)
  return x >= x1 and x <= x2 and
         y >= y2 and y <= y1
end

local numberOfInitials = 0
local initialsExists = {}

local highestY = 0
for newVelX=1,400 do
  for newVelY=-300,1000 do
    local x = startX
    local y = startY
    local velX = newVelX
    local velY = newVelY
    local localHighestY = 0
    
    repeat
      x = x + velX
      y = y + velY
      
      velX = velX - 1
      velY = velY - 1
      if velX < 0 then
        velX = 0
      end
      
      if y > localHighestY then
        localHighestY = y
      end
      
      if isHitTarget(x, y) then
        if not initialsExists[newVelX.." "..newVelY] then
          initialsExists[newVelX.." "..newVelY] = true
          numberOfInitials = numberOfInitials + 1
        end
        break
      end
    until isOvershoot(x, y)
  end
end

print(numberOfInitials)


