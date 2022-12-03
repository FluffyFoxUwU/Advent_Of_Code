#!/usr/bin/env lua5.4

--Main reading loop

local prio = "abcdefghijklmnopqrstuvwxyz"
prio=prio..prio:upper()

local list = {}
for line in io.lines() do
  local lines = {line,io.read(),io.read()}
  for c in prio:gmatch(".") do
    if lines[1]:match(c) and lines[2]:match(c) and lines[3]:match(c) then
      list[c] = (list[c] or 0 )+ 1
      break
    end
  end
end

local sum = 0
for t, count in  pairs(list) do
  sum = sum + prio:find(t) * count
end
print(sum)

