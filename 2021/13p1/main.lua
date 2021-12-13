#!/usr/bin/env lua5.4

local paper = {}

local width = 0
local height = 0

--Main reading loop
for line in io.lines() do
  if line == "" then
    break
  end
  
  local iterator = line:gmatch("%d+")
  local x = iterator() * 1 
  local y = iterator() * 1 
  
  if x + 1 > width then
    width = x + 1
  end
  
  if y + 1 > height then
    height = y + 1
  end
  
  paper[x.." "..y] = true
end 

print("Height: ", height)
print("Width: ", width)

for line in io.lines() do
  local instruction = line:match("[^ ]+$")
  local axis = instruction:match("^.")
  local pivot = instruction:match("%d+$") * 1 
  
  print("Folding "..axis.." at "..pivot)
  
  if axis == "x" then
    for y=0,height do
      for x=pivot+1, width do
        local point = paper[x.." "..y]
        local distance = x - pivot
        local newX = pivot - distance
        if newX >= 0 then
          if not paper[newX.." "..y] then
            paper[newX.." "..y] = point
          end
        end
      end
    end
    width = math.floor(width / 2)
  elseif axis == "y" then
    for y=pivot+1,height do
      for x=0, width do
        local point = paper[x.." "..y]
        local distance = y - pivot
        local newY = pivot - distance 
        if newY >= 0 then
          ---print(x, newY, distance, y, point)
          if not paper[x.." "..newY] then
            paper[x.." "..newY] = point
          end
        end
      end
    end
    height = math.floor(height / 2)
  else
    error(axis)
  end
  
  local num = 0
  for y=0,height do
    for x=0, width do
      if paper[x.." "..y] then
        io.write("\27["..(y+1)..";"..(x+1).."H".."#")
        num = num + 1
      else
        io.write("\27["..(y+1)..";"..(x+1).."H".." ")
      end
    end
  end
  print(num) 
  break
end


