#!/usr/bin/env lua5.4

local polyString = io.read()
io.read()

local patternTable = {}

for line in io.lines() do
  local pattern = line:match("^..")
  local replaceWith = line:match(".$")
  
  patternTable[pattern] = replaceWith
end

--Somehow replace this code with efficient version------
local letters = {}
local numberOfPairs = {}

local it = polyString:gmatch(".")
it()

for first in polyString:gmatch(".") do
  local second = it() 
  if not second then
    break
  end
  
  if not letters[first] then
    letters[first] = 0
  end
  letters[first] = letters[first] + 1
  
  if not numberOfPairs[first..second] then
    numberOfPairs[first..second] = 0
  end
  numberOfPairs[first..second] = numberOfPairs[first..second] + 1 
end

--Last char always alone
if not letters[polyString:sub(#polyString, #polyString)] then
  letters[polyString:sub(#polyString, #polyString)] = 0
end
letters[polyString:sub(#polyString, #polyString)] = letters[polyString:sub(#polyString, #polyString)] + 1

for i=1,40 do
  local copyOfNumberOfPairs = {}
  for k,v in pairs(numberOfPairs) do
    copyOfNumberOfPairs[k] = v
  end
  
  for pattern, count in pairs(copyOfNumberOfPairs) do
    local toInsert = patternTable[pattern]
    --The current possibly pattern no longer valid
    numberOfPairs[pattern] = numberOfPairs[pattern] - count
    
    --Add letter
    if not letters[toInsert] then --All these if constructs is for make sure the entry is zero not nil
      letters[toInsert] = 0
    end
    letters[toInsert] = letters[toInsert] + count
    
    --The pattern split to  c1..inserted and inserted..c2
    --After insertion at middle
    if not numberOfPairs[pattern:sub(1,1)..toInsert] then
      numberOfPairs[pattern:sub(1,1)..toInsert] = 0
    end
    numberOfPairs[pattern:sub(1,1)..toInsert] = numberOfPairs[pattern:sub(1,1)..toInsert] + count
    
    if not numberOfPairs[toInsert..pattern:sub(2,2)] then
      numberOfPairs[toInsert..pattern:sub(2,2)] = 0
    end
    numberOfPairs[toInsert..pattern:sub(2,2)] = numberOfPairs[toInsert..pattern:sub(2,2)] + count 
    
  end
end

--------------------------------------------------------

local lettersArray = {}
for k,v in pairs(letters) do
  print(k,v)
  lettersArray[#lettersArray + 1] = v
end

table.sort(lettersArray)
print(lettersArray[#lettersArray] - lettersArray[1])


