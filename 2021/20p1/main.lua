#!/usr/bin/env lua5.4

local algoString = io.read():gsub(".", {["#"]=1, ["."]=0})
io.read()

local infiniteImage = {}

local maxW = 300
local maxH = 300
for x=0,maxW do
  for y=0,maxH do
    infiniteImage[x.." "..y] = 0
  end
end

--Main reading loop
local y = math.floor(maxH/4)
for line in io.lines() do
  local x = math.floor(maxW/4)
  for pix in line:gmatch(".") do
    infiniteImage[x.." "..y] = (pix == "#") and 1 or 0
    x = x + 1
  end
  y = y + 1
end


function getPixel(image, x, y)
  return image[x.." "..y] or 0
end

function enhance(image)
  local newImage = {}
  for k,v in pairs(image) do newImage[k] = v end
  
  for coord, pix in pairs(image) do
    local x, y = coord:match("^(%d+) (%d+)$")
    local bits = {
      getPixel(image, x-1, y-1), getPixel(image, x, y-1), getPixel(image, x+1, y-1),
      getPixel(image, x-1, y),   getPixel(image, x, y),   getPixel(image, x+1, y),
      getPixel(image, x-1, y+1), getPixel(image, x, y+1), getPixel(image, x+1, y+1)
    }
    
    local index = tonumber(table.concat(bits), 2)
    newImage[x.." "..y] = tonumber(algoString:sub(index+1,index+1))
  end
  
  return newImage
end

function render(image)
  os.execute("clear")
  for y=0,maxH do
    for x=0,maxW do
      if image[x.." "..y] == 1 then
        io.write(string.format("\27[47;1m\27[%d;%dH  ", y+1, (x*2)+1))
      else
        io.write(string.format("\27[40;1m\27[%d;%dH  ", y+1, (x*2)+1))
      end
    end
    io.write("\27[m")
    io.flush()
  end
end

for i=1,2 do
  infiniteImage = enhance(infiniteImage)
  --render(infiniteImage)
  os.execute("notify-send 'Step: "..i.."'")
end

--12432
--23797

local pixels = 0
local excludeDistance = 20
local startX = excludeDistance - 1
local startY = excludeDistance - 1
local endX = maxW - excludeDistance - 1
local endY = maxH - excludeDistance - 1

for coord, pix in pairs(infiniteImage) do
  local x, y = coord:match("^(%d+) (%d+)$")
  x=x*1
  y=y*1
  
  if x >= startX and y >= startY and y <= endY and x <= endX then
    if pix == 1 then
      pixels = pixels + 1
    end 
  end
end

os.execute("notify-send 'Result: "..pixels.."'")
