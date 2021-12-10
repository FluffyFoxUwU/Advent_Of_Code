#!/usr/bin/env lua5.4

local points = 0

local pointTable = {
  [")"] = 3,
  ["]"] = 57,
  ["}"] = 1197,
  [">"] = 25137
}

--Main reading loop
for line in io.lines() do
  local stack = {}
  
  for chr in line:gmatch(".") do
    if chr == "{" then
      stack[#stack + 1] = "}"
    elseif chr == "[" then
      stack[#stack + 1] = "]"
    elseif chr == "(" then
      stack[#stack + 1] = ")"
    elseif chr == "<" then
      stack[#stack + 1] = ">"
    else
      if chr == "\n" then
        break
      end
      
      if stack[#stack] == chr then
        stack[#stack] = nil
      else
        points = points + pointTable[chr]
        break
      end
    end
  end
end

print(points)


