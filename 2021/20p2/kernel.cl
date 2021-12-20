#pragma OPENCL EXTENSION cl_intel_printf : enable

int getPixel(__global const bool* pixels, int x, int y, const int width, const int height) {
  if (x >= width || y >= height ||
      x < 0 || y < 0) 
    return 0;
  
  return pixels[y * width + x] ? 1 : 0;
}

__kernel void kmain(__global const bool* pixels, __global const bool* lookup, 
                    __global bool* outputPixels, const int width, 
                    const int height) {
  // Get the index of the current element to be processed
  int workunit = get_global_id(0);
  int y = workunit / width;
  int x = workunit % width;
  
  int index = getPixel(pixels, x-1, y-1, width, height) + (getPixel(pixels, x, y-1, width, height) << 1) + (getPixel(pixels, x+1, y-1, width, height) << 2) |
              (getPixel(pixels, x-1, y, width, height) << 3) + (getPixel(pixels, x, y, width, height) << 4) + (getPixel(pixels, x+1, y, width, height) << 5) |
              (getPixel(pixels, x-1, y+1, width, height) << 6) + (getPixel(pixels, x, y+1, width, height) << 7) + (getPixel(pixels, x+1, y+1, width, height) << 8);
  
  //printf("[Thread-%d] X: %d  Y: %d become %s (Index: %d) (Previous: %d))\n", get_local_id(0), x, y, lookup[index] ? "true" : "false", index, outputPixels[workunit]);
  
  outputPixels[workunit] = lookup[index];
  /*local x, y = coord:match("^(%d+) (%d+)$")
    local bits = {
      getPixel(image, x-1, y-1), getPixel(image, x, y-1), getPixel(image, x+1, y-1),
      getPixel(image, x-1, y),   getPixel(image, x, y),   getPixel(image, x+1, y),
      getPixel(image, x-1, y+1), getPixel(image, x, y+1), getPixel(image, x+1, y+1)
    }
    
    local index = tonumber(table.concat(bits), 2)
    newImage[x.." "..y] = tonumber(algoString:sub(index+1,index+1))*/
}