#!/usr/bin/env lua5.4

--Main reading loop
local zero = {0, 0, 0, 0, 0}
local one =  {0, 0, 0, 0, 0}

for line in io.lines() do
  for i=1,line:len() do
    if line:sub(i,i) == "1" then
      one[i] = (one[i] or 0) + 1
    else
      zero[i] = (zero[i] or 0) + 1
    end
  end
end

local gamma = ""
local epsilon = ""

for i=1,#zero do
  if zero[i] > one[i] then
    gamma = gamma.."0"
    epsilon = epsilon.."1"
  else
    gamma = gamma.."1"
    epsilon = epsilon.."0"
  end
end

gamma = tonumber(gamma, 2)
epsilon = tonumber(epsilon, 2)
print(gamma * epsilon)








