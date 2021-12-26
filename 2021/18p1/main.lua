#!/usr/bin/env lua5.4
local JSON = require("json")

--Main reading loop

function nearestLeft(root, relativeTo)
  local latestNumber, pair, index = nil
  local function recurse(parent, current, index2)
    if type(current) == "number" then
      latestNumber = current
      pair = parent 
      index = index2
      return 
    end
    
    if current == relativeTo then
      return true
    end
    
    if recurse(current, current[1], 1) then return true end
    if recurse(current, current[2], 2) then return true end
  end 
  
  recurse(root.parent, root, nil)
  if latestNumber then
    return pair, latestNumber, index
  else
    return nil
  end
end

function nearestRight(root, relativeTo)
  local latestNumber, pair, index = nil
  local function recurse(parent, current, index2)
    if type(current) == "number" then
      latestNumber = current
      pair = parent 
      index = index2
      return 
    end
    
    if current == relativeTo then
      return true
    end
    
    if recurse(current, current[2], 2) then return true end
    if recurse(current, current[1], 1) then return true end
  end 
  
  recurse(root.parent, root, nil)
  if latestNumber then
    return pair, latestNumber, index
  else
    return nil
  end
end

function explode(root, pair)
  assert(type(pair[1]) == "number")
  assert(type(pair[2]) == "number")
  
  local replacePattern = JSON.encode(pair):gsub('%%', '%%%%')
                                         :gsub('^%^', '%%^')
                                         :gsub('%$$', '%%$')
                                         :gsub('%(', '%%(')
                                         :gsub('%)', '%%)')
                                         :gsub('%.', '%%.')
                                         :gsub('%[', '%%[')
                                         :gsub('%]', '%%]')
                                         :gsub('%*', '%%*')
                                         :gsub('%+', '%%+')
                                         :gsub('%-', '%%-')
                                         :gsub('%?', '%%?') 
  local replacement = "\27[32m"..JSON.encode(pair).."\27[m" 
  print(JSON.encode(root):gsub(replacePattern, replacement))
  
  local firstLeftPair, leftNum, leftPairIndex = nearestLeft(root, pair)
  local firstRightPair, rightNum, rightPairIndex = nearestRight(root, pair)
  
  if firstLeftPair then
    firstLeftPair[leftPairIndex] = leftNum + pair[1]
  end
  
  if firstRightPair then
    firstRightPair[rightPairIndex] = rightNum + pair[2]
  end
end

function fixTable(table, parent)
  if type(table) ~= "table" then
    return
  end
  
  table.parent = parent
  fixTable(table[1], table)
  fixTable(table[2], table)
end

function tryExplode(root)
  local depth = 1
  local function recurse(pair)
    if type(pair) ~= "table" then
      return
    end
    
    if depth >= 4 then
      if type(pair[1]) == "table" then
        explode(root, pair[1])
        pair[1] = 0
        return true
      end
      
      if type(pair[2]) == "table" then
        explode(root, pair[2])
        pair[2] = 0
        return true
      end
    end
    
    depth = depth + 1
    if recurse(pair[1]) then return true end
    if recurse(pair[2]) then return true end
    depth = depth - 1
  end
  
  recurse(root)
end

function split(root, pair, index, depth)
  if pair[index] >= 10 then
    local replacePattern = JSON.encode(pair[index]):gsub('%%', '%%%%')
                                                   :gsub('^%^', '%%^')
                                                   :gsub('%$$', '%%$')
                                                   :gsub('%(', '%%(')
                                                   :gsub('%)', '%%)')
                                                   :gsub('%.', '%%.')
                                                   :gsub('%[', '%%[')
                                                   :gsub('%]', '%%]')
                                                   :gsub('%*', '%%*')
                                                   :gsub('%+', '%%+')
                                                   :gsub('%-', '%%-')
                                                   :gsub('%?', '%%?')
    local replacement = "\27[33m"..JSON.encode(pair[index]).."\27[m" 
    print(JSON.encode(root):gsub(replacePattern, replacement))
    
    pair[index] = {
      math.floor(pair[index] / 2),
      math.ceil(pair[index] / 2)
    }
    
    if depth >= 4 then
      explode(root, pair[index])
      pair[index] = 0
    end
    
    return true
  end
  return false
end

function trySplit(root)
  local depth = 1
  local function recurse(pair)
    if type(pair) ~= "table" then
      return
    end
    
    if type(pair[1]) == "number" then
      if split(root, pair, 1, depth) then
        return true
      end
    else
      depth = depth + 1
      if recurse(pair[1]) then return true end
      depth = depth - 1
    end
    
    if type(pair[2]) == "number" then
      if split(root, pair, 2, depth) then
        return true
      end
    else
      depth = depth + 1
      if recurse(pair[2]) then return true end
      depth = depth - 1
    end
  end
  
  recurse(root)
end

function reduce(result)
  local prev
  print("Explosion phase")
  
  repeat
    prev = JSON.encode(result)
    tryExplode(result)
  until prev == JSON.encode(result)
  
  repeat
    print("Split phase")
    prev = JSON.encode(result)
    trySplit(result)
  until prev == JSON.encode(result)
  
  print("Splitting phase")
  
  --repeat
  --  prev = JSON.encode(result)
  --until prev == JSON.encode(result) 
end

function add(op1, op2)
  local result = {op1, op2} 
  reduce(result)
  return JSON.encode(result)
end

local total = 0
local accumulator = io.read() 

for line in io.lines() do
  --print("ACC1", accumulator)
  accumulator = add(JSON.decode(accumulator), JSON.decode(line))
  --print("ACC2", line)
  print("RES", accumulator)
  --print("EXP", io.read())
  print()
end  
print("TOTAL", accumulator)

function magnitude(op1, op2)
  if type(op1) == "table" then
    op1 = magnitude(op1[1], op1[2])
  end
  
  if type(op2) == "table" then
    op2 = magnitude(op2[1], op2[2])
  end
  
  return 3*op1 + 2*op2
end

accumulator = JSON.decode(accumulator)
print(magnitude(accumulator[1], accumulator[2]))
