#!/usr/bin/env lua5.4

--Main reading loop
local lines = {}

for line in io.lines() do
  lines[#lines + 1] = line
end

--Search oxygen
local oxygen = lines
for i=1, #lines[1] do
  local zero = {0, 0, 0, 0, 0}
  local one =  {0, 0, 0, 0, 0}
  
  for _, line in ipairs(oxygen) do
    for j=1,line:len() do
      if line:sub(j,j) == "1" then
        one[j] = (one[j] or 0) + 1
      else
        zero[j] = (zero[j] or 0) + 1
      end
    end
  end
  
  local newOxygen = {}
  for _, line in ipairs(oxygen) do
    local target = (zero[i] > one[i]) and "0" or "1" 
    if line:sub(i,i) == target then
      newOxygen[#newOxygen + 1] = line
    end
  end
  oxygen = newOxygen
  
  if #newOxygen == 1 then
    oxygen = newOxygen[1]
    break
  end
end

local resOxy = oxygen

--Search oxygen
local oxygen = lines
for i=1, #lines[1] do
  local zero = {0, 0, 0, 0, 0}
  local one =  {0, 0, 0, 0, 0}
  
  for _, line in ipairs(oxygen) do
    for j=1,line:len() do
      if line:sub(j,j) == "1" then
        one[j] = (one[j] or 0) + 1
      else
        zero[j] = (zero[j] or 0) + 1
      end
    end
  end
  
  local newOxygen = {}
  for _, line in ipairs(oxygen) do
    local target = (zero[i] > one[i]) and "1" or "0" 
    if line:sub(i,i) == target then
      newOxygen[#newOxygen + 1] = line
    end
  end
  oxygen = newOxygen
  
  if #newOxygen == 1 then
    oxygen = newOxygen[1]
    break
  end
end

print(tonumber(resOxy, 2) * tonumber(oxygen, 2))
