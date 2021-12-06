#!/usr/bin/env lua5.4

--Main reading loop
local fishes = {
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,0,0,0,0,0,0,0,0
}
for num in io.read():gmatch("[0-9]+") do
  fishes[num*1] = fishes[num*1] + 1
end

for i=1,256 do
  local newFish = {
    [0] = 0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,0,0,0,0
  }
  for fish=0,8 do
    local num = fishes[fish] or 0
    
    if fish == 0 then
      newFish[6] = newFish[6] + num
      newFish[8] = newFish[8] + num
    else 
      newFish[fish - 1] = newFish[fish - 1] + num
    end
  end 
  
  fishes = newFish
end

local res = 0
for _, fish in pairs(fishes) do
  res = res + fish
end
print(res)