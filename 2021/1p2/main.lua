#!/usr/bin/env lua5.4

local windows = {}

local data = {}
local line
repeat
  line = io.read()
  if line then
    data[#data + 1] = tonumber(line)
  end
until line == nil

local winNum = 0
local i = 0
while data[i + 1] do
  windows[winNum + 1] = (data[i + 1] or 0) +
                        (data[i + 2] or 0) +
                        (data[i + 3] or 0)
  
  i = i + 1
  winNum = winNum + 1
end

local current = nil
local numberOfIncrease = 0
for k,v in ipairs(windows) do
  if current then
    if v > current then
      numberOfIncrease = numberOfIncrease + 1
    end
  end
  current = v
end

print(numberOfIncrease)
