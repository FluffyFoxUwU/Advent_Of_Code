#!/usr/bin/env lua5.4

local guide = {}

local scoreMapping = {
  ['X'] = 1, --rock
  ['Y'] = 2, --paper
  ['Z'] = 3, --scisors
  ['A'] = 1, --rock
  ['B'] = 2, --paper
  ['C'] = 3 --scisors
}

local state = {
  ["AX"] = 0,
  ["BY"] = 0,
  ["CZ"] = 0,
  
  ["BX"] = -6,
  ["CX"] = 6,
  
  ["AY"] = 6,
  ["CY"] = -6,
  
  ["BZ"] = 6,
  ["AZ"] = -6,
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
local scoreEnemy = 0
for line in io.lines() do
  local enemy, me = string.match(line, "^(.) (.)$")
  me = loseMove[enemy][indexFromMove[me]]
  
  local nextState = state[enemy..me]
  
  scoreMe = scoreMe + scoreMapping[me]
  scoreEnemy = scoreEnemy + scoreMapping[enemy]
  
  if nextState > 0 then
    scoreMe = scoreMe + nextState
  elseif nextState < 0 then
    scoreEnemy = scoreEnemy + -nextState
  else
    scoreEnemy = scoreEnemy + 3
    scoreMe = scoreMe + 3
  end
end
print(scoreMe)



