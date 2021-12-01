#!/usr/bin/env lua5.4

local current = nil
local increaseAmount = 0

local line
repeat
  line = io.read()
  if line then
    if current and tonumber(line) > current then
      increaseAmount = increaseAmount + 1
    end
    current = tonumber(line)
  end
until line == nil

print(increaseAmount)


