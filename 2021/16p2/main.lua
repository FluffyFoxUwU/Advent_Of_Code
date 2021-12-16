#!/usr/bin/env lua5.4

local bitstream = {}
local hexTable = {
  ["0"] = {0,0,0,0},
  ["1"] = {0,0,0,1},
  ["2"] = {0,0,1,0},
  ["3"] = {0,0,1,1},
  ["4"] = {0,1,0,0},
  ["5"] = {0,1,0,1},
  ["6"] = {0,1,1,0},
  ["7"] = {0,1,1,1},
  ["8"] = {1,0,0,0},
  ["9"] = {1,0,0,1},
  ["A"] = {1,0,1,0},
  ["B"] = {1,0,1,1},
  ["C"] = {1,1,0,0},
  ["D"] = {1,1,0,1},
  ["E"] = {1,1,1,0},
  ["F"] = {1,1,1,1} 
}

--Main reading loop
for line in io.lines() do
  for hex in line:gmatch(".") do
    for _, bit in ipairs(hexTable[hex]) do
      bitstream[#bitstream + 1] = bit
    end
  end
end

function dumpBits()
  for _, bit in ipairs(bitstream) do
    io.write(bit)
  end
  print()
end

dumpBits()

local currentReadHead = 1
function readBits(num)
  local bits = {}
  for i=1, num do
    bits[#bits + 1] = bitstream[currentReadHead]*1 --Ensure number
    currentReadHead = currentReadHead + 1
  end
  return bits
end

function readNumber(num)
  return tonumber(table.concat(readBits(num)), 2)
end

function combine(tab1, tab2)
  for k,v in ipairs(tab2) do
    tab1[#tab1 + 1] = v
  end
end

function decodeLiteral()
  local literalBits = {}
  local lastGroup = false
  repeat
    local bits = readBits(5)
    if table.remove(bits, 1) == 0 then
      lastGroup = true
    end
    combine(literalBits, bits)
  until lastGroup == true
  
  return tonumber(table.concat(literalBits), 2)
end

local totalVersion = 0
function readPacket()
  local version = readNumber(3)
  totalVersion = totalVersion + version
  
  local packetType = readNumber(3)
  if packetType == 4 then
    print("Literal packet")
    return decodeLiteral()
  else
    return readOperator(packetType)
  end
end

function readOperator(packType)
  local lengthType = readBits(1)[1]
  local packets = {}
  local result = 0
  
  if lengthType == 1 then
    local length = readNumber(11)
    print("Operator packet ", length, " packets")
    for i=1,length do
      packets[#packets + 1] = readPacket()
    end
  else
    local lengthBits = readNumber(15)
    local endHead = currentReadHead + lengthBits
    print("Operator packet ", lengthBits, " bits")
    repeat
      packets[#packets + 1] = readPacket()
    until currentReadHead == endHead
  end 
  
  if packType == 0 then
    for _, packet in ipairs(packets) do
      result = result + packet
    end
  elseif packType == 1 then
    result = packets[1]
    for k, packet in ipairs(packets) do
      if k > 1 then
        result = result * packet
      end
    end
  elseif packType == 2 then
    result = math.min(table.unpack(packets))
  elseif packType == 3 then
    result = math.max(table.unpack(packets))
  elseif packType == 5 then
    if packets[1] > packets[2] then
      result = 1
    end
  elseif packType == 6 then
    if packets[1] < packets[2] then
      result = 1
    end
  elseif packType == 7 then
    if packets[1] == packets[2] then
      result = 1
    end
  else
    error("Unknown OP")
  end
  
  return result
end

print("Result ", readPacket())
print("Total version ", totalVersion)
