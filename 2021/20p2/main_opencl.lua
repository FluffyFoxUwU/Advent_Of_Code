#!/bin/lua5.3
local CL = require("mooncl")

local lookupTable = {}
for chr in io.read():gmatch(".") do
  lookupTable[#lookupTable + 1] = (chr == "#") and 1 or 0
end
io.read()

local infiniteImage = {}

print("Initializing dataset")

local maxW = 600
local maxH = 600
for x=0,maxW-1 do
  for y=0,maxH-1 do
    infiniteImage[y * maxW + x + 1] = 0
  end
end

--Main reading loop
local y = math.floor(maxH/4)
for line in io.lines() do
  local x = math.floor(maxW/4)
  for pix in line:gmatch(".") do
    infiniteImage[y * maxW + x + 1] = (pix == "#") and 1 or 0
    x = x + 1
  end
  y = y + 1
end

function print2(...)
  os.execute("notify-send '"..table.concat({...}, "\t").."'")
end

print("Done")
print("OpenCL initialization")

local platform = CL.get_platform_ids()[1]
local device = CL.get_device_ids(platform, CL.DEVICE_TYPE_GPU)[1]
local context = CL.create_context(platform, {device})
local queue = CL.create_command_queue(context, device)
local program = CL.create_program_with_sourcefile(context, "kernel.cl") 
CL.build_program(program, {device})
local kernel = CL.create_kernel(program, "kmain")

local resultBuffer = CL.create_buffer(context, CL.MEM_WRITE_ONLY, CL.sizeof('int') * maxW * maxH)
local lookupBuffer = CL.create_buffer(context, CL.MEM_READ_ONLY, CL.sizeof('int') * 512)
local inputBuffer = CL.create_buffer(context, CL.MEM_READ_ONLY, CL.sizeof('int') * maxW * maxH)
local intermediateNativeBuffer = CL.malloc(CL.sizeof("int") * maxW * maxH)
local lookupNativeBuffer = CL.malloc(CL.sizeof("int") * 512)

-- Write lookup
lookupNativeBuffer:write(0, "int", lookupTable)
CL.enqueue_write_buffer(queue, lookupBuffer, true, 0, CL.sizeof("int") * 512, lookupNativeBuffer:ptr()) 
CL.set_kernel_arg(kernel, 0, inputBuffer)
CL.set_kernel_arg(kernel, 1, lookupBuffer)
CL.set_kernel_arg(kernel, 2, resultBuffer)
CL.set_kernel_arg(kernel, 3, 'int', maxW)
CL.set_kernel_arg(kernel, 4, 'int', maxH)

local size = {maxW * maxH}
function enhance(image)
  -- Write input
  intermediateNativeBuffer:write(0, "int", image)
  CL.enqueue_write_buffer(queue, inputBuffer, true, 0, intermediateNativeBuffer:size(), intermediateNativeBuffer:ptr()) 
  CL.enqueue_ndrange_kernel(queue, kernel, 1, nil, size)
  CL.enqueue_read_buffer(queue, resultBuffer, true, 0, intermediateNativeBuffer:size(), intermediateNativeBuffer:ptr()) 
  return intermediateNativeBuffer:read(0, nil, "int")
end

print("Done!")

function render(image)
  os.execute("clear")
  for y=0,maxH-1 do
    for x=0,maxW-1 do
      if image[y * maxW + x + 1] == 1 then
        io.write(string.format("\27[47;1m\27[%d;%dH  ", y+1, (x*2)+1))
      else
        io.write(string.format("\27[40;1m\27[%d;%dH  ", y+1, (x*2)+1))
      end
    end
    io.write("\27[m")
    io.flush()
  end
end

for i=1,50 do
  print("Step: "..i)
  infiniteImage = enhance(infiniteImage)
  --render(infiniteImage)
end

print("Calculating final result")

local pixels = 0
local excludeDistance = 80
local startX = excludeDistance 
local startY = excludeDistance 
local endX = maxW - excludeDistance 
local endY = maxH - excludeDistance 

for k,pix in ipairs(infiniteImage) do
  k = k - 1
  local x, y = math.floor(k % maxW), math.floor(k / maxW)
  x=x*1
  y=y*1
  
  if x >= startX and y >= startY and y <= endY and x <= endX then
    if pix == 1 then
      pixels = pixels + 1
    end 
  end
end

print("Result: "..pixels)























