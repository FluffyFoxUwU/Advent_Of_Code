#!/usr/bin/env lua5.4

local points = {}

local pointTable = {
  [")"] = 1,
  ["]"] = 2,
  ["}"] = 3,
  [">"] = 4
}

--Main reading loop
for line in io.lines() do
  local stack = {}
  line = line.."\n"
  
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
        --Fill incompletes
        local final = 0
        for i=#stack,1,-1 do
          final = final * 5
          final = final + pointTable[stack[i]]
        end
        points[#points + 1] = final
        break
      end
      
      if stack[#stack] == chr then
        stack[#stack] = nil
      else
        break
      end
    end
  end
end

table.sort(points)
print(points[math.ceil(#points / 2)])


