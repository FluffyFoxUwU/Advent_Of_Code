#!/usr/bin/env lua5.4

local allPoints = {}
local root = {}

--Main reading loop
for line in io.lines() do
  for sym in line:gmatch(".+[,]?") do
    local from = sym:match("^[^-]+")
    local to = sym:match("[^-]+$")
    from = from:match("%a+")
    to = to:match("%a+")
    
    if not root[from] then
      root[from] = {}
    end
    
    if not root[to] then
      root[to] = {}
    end
    
    root[from][to] = true
    root[to][from] = true
  end
end

function search(tab, val)
  local num = 0
  for k,v in pairs(tab) do
    if v == val then
      num = num + 1
    end
  end
  return num
end

function length(tab, val)
  local i = 0
  for k,v in pairs(tab) do
    i = i + 1
  end
  return i
end

local stack = {"start"}
local paths = 0

function dfs(point)
  local function tmp(array)
    for pointName in pairs(array) do
      if pointName == "end" then
        paths = paths + 1
      else
        if pointName:lower() == pointName then
          if not search(stack, pointName) then
            stack[#stack + 1] = pointName
            dfs(root[pointName])
            stack[#stack] = nil
          end
        else
          stack[#stack + 1] = pointName
          dfs(root[pointName])
          stack[#stack] = nil
        end
      end
    end
  end
  
  tmp(point) 
end

dfs(root["start"])
print(paths)

