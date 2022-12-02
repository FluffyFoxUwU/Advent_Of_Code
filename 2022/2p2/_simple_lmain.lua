#!/usr/bin/env lua5.4

local scoreMapping = {
  ['X'] = 1, --rock
  ['Y'] = 2, --paper
  ['Z'] = 3
}

local state = {
  ["AX"] = 0,
  ["BY"] = 0,
  ["CZ"] = 0,
  
  ["CX"] = 6,
  ["AY"] = 6,
  ["BZ"] = 6
}

local loseMove = {
  ["A"] = {"Z", "X", "Y"},
  ["B"] = {"X", "Y", "Z"},
  ["C"] = {"Y", "Z", "X"}
}

local indexFromMove = {
  ["X"] = 1,
  ["Y"] = 2,
  ["Z"] = 3
}

--Main reading loop
local scoreMe = 0
for line in io.lines() do
  scoreMe = scoreMe + state[line:sub(1)..line:sub(-1)]
end
print(scoreMe)



