#!/usr/bin/env lua5.4

function sort(input)
  local buffer = {}
  for i=1,#input do
     buffer[i] = input:sub(i,i)
  end
  table.sort(buffer)
  return table.concat(buffer)
end

function get_all_combinations(arr1, arr2)
   local n, e, all_comb  = #arr1, {}, {}
   for j = 1, n do
      e[j] = arr2[j]
   end
   local function generate(m)
      if m <= 1 then
         local comb = {}
         all_comb[#all_comb + 1] = comb
         for j = 1, n do
            --print(arr1[j], e[j])
            --comb[j] = {arr1[j], e[j]}  -- it should be {arr1[j], e[j]} to fulfill your requirements
            comb[arr1[j]] = e[j]
         end
      else
         for j = 1, m do
            generate(m - 1)
            local k = j < m and m % 2 == 1 and 1 or j
            e[k], e[m] = e[m], e[k]
         end
      end
   end
   generate(n)
   return all_comb
end

local combinations = get_all_combinations(
  {"a", "b", "c", "d", "e", "f", "g"}, 
  {"a", "b", "c", "d", "e", "f", "g"})

--[[
 0:      1:      2:      3:      4:
 aaaa    ....    aaaa    aaaa    ....
b    c  .    c  .    c  .    c  b    c
b    c  .    c  .    c  .    c  b    c
 ....    ....    dddd    dddd    dddd
e    f  .    f  e    .  .    f  .    f
e    f  .    f  e    .  .    f  .    f
 gggg    ....    gggg    gggg    ....

  5:      6:      7:      8:      9:
 aaaa    aaaa    aaaa    aaaa    aaaa
b    .  b    .  .    c  b    c  b    c
b    .  b    .  .    c  b    c  b    c
 dddd    dddd    ....    dddd    dddd
.    f  e    f  .    f  e    f  .    f
.    f  e    f  .    f  e    f  .    f
 gggg    gggg    ....    gggg    gggg

]]
local numbers = {}

for key, value in pairs({
  abcefg = 0, 
  cf = 1,
  acdeg = 2,
  acdfg = 3,
  bcdf = 4,
  abdfg = 5,
  abdefg = 6,
  acf = 7,
  abcdefg = 8,
  abcdfg = 9
}) do
  numbers[sort(key)] = value
end

--Main reading loop
local result = 0
local lineNum = 0 

for line in io.lines() do
  lineNum = lineNum + 1
  local iterator = line:gmatch("[a-z|]+")
  local code_mapping = {}
  local current = sort(iterator())
  local set = {}
  
  while current ~= "|" do 
    set[#set + 1] = current 
    current = sort(iterator())
  end
  
  -- Brute force to get number
  -- 2 3 5 6 9 0
  for _, mapping in ipairs(combinations) do
    code_mapping = {}
    
    --Apply mapping for each number
    local correct = true
    for _, raw_code in ipairs(set) do
      local code = sort(raw_code:gsub(".", mapping))
      if numbers[code] == nil then
        correct = false
      else
        code_mapping[raw_code] = numbers[code]
      end
    end
    
    if correct then
      break
    end
  end
  
  print(lineNum)
  
  local i = 3
  for code in iterator do
    result = result + code_mapping[sort(code)] * 10^i
    i = i - 1
  end
end
print(result)


