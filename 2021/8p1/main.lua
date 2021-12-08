#!/usr/bin/env lua5.4

--Main reading loop
local instances = 0
for line in io.lines() do
  local iterator = line:gmatch("[a-z|]+")
  while iterator() ~= "|" do end
  
  for code in iterator do
    -- 1
    if #code == 2 then 
      instances = instances + 1
    -- 4
    elseif #code == 4 then
      instances = instances + 1
    -- 7
    elseif #code == 3 then
      instances = instances + 1
    -- 8
    elseif #code == 7 then
      instances = instances + 1
    end
  end
end
print(instances)


