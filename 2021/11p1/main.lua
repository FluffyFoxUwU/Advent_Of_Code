#!/usr/bin/env lua5.4

local world = {}

--Main reading loop
local y = 0
for line in io.lines() do
  local x = 0
  for octo in line:gmatch("[0-9]") do
    world[x.." "..y] = {has_flash = false, energy = octo*1}
    x = x + 1
  end
  y = y + 1
end

local flashes = 0

function tick(state, coord)
  local x = coord:match("^[0-9]+")
  local y = coord:match("[0-9]+$")
  
  state.energy = state.energy + 1
  if state.energy > 9 and state.has_flash == false then
    state.has_flash = true
    
    function tryTick(coord)
      if world[coord] then
        tick(world[coord], coord)
        --world[coord].energy = world[coord].energy + 1
      end
    end
    
    tryTick((x-1).." "..(y-1))
    tryTick((x-1).." "..(y+0))
    tryTick((x-1).." "..(y+1))
    
    tryTick((x+0).." "..(y-1))
    tryTick((x+0).." "..(y+1))
    
    tryTick((x+1).." "..(y-1))
    tryTick((x+1).." "..(y+0))
    tryTick((x+1).." "..(y+1))
    
    flashes = flashes + 1
  end
end

for i=1,100 do
  local newWorld = {}
  for coord, state in pairs(world) do
    tick(state, coord)
  end
  
  for coord, state in pairs(world) do
    if state.has_flash then
      world[coord].energy = 0
      state.has_flash = false
    end
  end
  --world = newWorld
end

print(flashes)
