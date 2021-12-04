#!/usr/bin/env lua5.4

local numbers = {}
local boards = {}

for num in io.read():gmatch("[0-9]+[,]?") do
  numbers[#numbers + 1] = num:gsub(",", "")*1
end
io.read()

--Main reading loop
local currentBoard = {}
for line in io.lines() do
  if line == "" then
    boards[#boards + 1] = currentBoard
    currentBoard = {}
  else
    local currentRow = {}
    for num in line:gmatch("[0-9]+[ ]?") do
      currentRow[tonumber((num:gsub(" ", "")))] = false
    end
    currentBoard[#currentBoard + 1] = currentRow
  end
end
boards[#boards + 1] = currentBoard

for _, num__ in ipairs(numbers) do
  for boardNum, board in ipairs(boards) do
    for _, row in ipairs(board) do
      for bnum in pairs(row) do
        if num__*1 == bnum*1 then
          row[bnum*1] = true
        end
      end
      
      local res = true
      for _, v in pairs(row) do
        if v ~= true then
          res = false
        end
      end
      
      if res == true then
        local tmp = 0
        for _, v in ipairs(board) do
          for k, v in pairs(v) do
            if not v then
              tmp = tmp + k
            end
          end
        end
        print(tmp * num__)
        return
      end
    end
  end
end

