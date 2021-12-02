#!/usr/bin/env lua5.4

local x, y = 0, 0
local aim = 0

for line in io.lines() do
  local op = line:match("^[a-z]+")
  local changes = line:match("[0-9]+$")
  
  if op == "forward" then
    x = x + changes
    y = y + aim * changes
  elseif op == "up" then
    aim = aim - changes
  elseif op == "down" then
    aim = aim + changes
  end
end

print(x * y)


