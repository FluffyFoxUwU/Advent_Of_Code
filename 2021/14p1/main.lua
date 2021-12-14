#!/usr/bin/env lua5.4

local template = io.read()
io.read()

local gsubTable = {}

--Main reading loop
for line in io.lines() do
  local pattern = line:match("^..")
  local replaceWith = line:match(".$")
  
  gsubTable[pattern] = replaceWith
end

for i=1,10 do
  local newTempl = ""
  
  for i=1,#template do
    local first = template:sub(i,i)
    local second = template:sub(i+1,i+1)
    newTempl = newTempl..first
    
    if second then
      if gsubTable[first..second] then
        newTempl = newTempl..gsubTable[first..second]
      end
    end
  end
  
  template = newTempl
end

local letters = {}
for let in template:gmatch(".") do
  if not letters[let] then
    letters[let] = 0
  end
  letters[let] = letters[let] + 1
end

local lettersArray = {}
for k,v in pairs(letters) do
  print(k,v)
  lettersArray[#lettersArray + 1] = v
end

table.sort(lettersArray)
print(lettersArray[#lettersArray] - lettersArray[1])


