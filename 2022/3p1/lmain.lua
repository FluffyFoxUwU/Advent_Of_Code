#!/usr/bin/env lua5.4

--Main reading loop

local list = {}
for line in io.lines() do
  local halfBottom = line:sub(1,line:len()/2)
  local halfTop = line:sub(line:len()/2+1)
  
  for c in halfBottom:gmatch(".") do
    if halfTop:find(c) then
      list[c] = (list[c] or 0)+1
      break
    end
  end
end

local prio = "abcdefghijklmnopqrstuvwxyz"
prio=prio..prio:upper()

local sum = 0
for t, count in  pairs(list) do
  sum = sum + prio:find(t) * count
end
print(sum)

