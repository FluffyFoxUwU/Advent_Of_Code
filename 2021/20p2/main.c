#if 0
clang -g -rdynamic -O2 -Wall main.c -lOpenCL
exec ./a.out
#endif

//This code will be POSIX 2016 compliant
#define _POSIX_C_SOURCE 201600L
#define CL_TARGET_OPENCL_VERSION 300

#include <CL/cl.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <assert.h>
#include <string.h>

#define MAX_SOURCE_SIZE 0x100000 
#define bool cl_bool
#define int cl_int

int width = 200;
int height = 200; 
cl_bool lookup2[512] = {};
static bool* enhance(bool* image);

cl_platform_id platform_id = NULL;
cl_device_id device_id = NULL;   
cl_uint ret_num_devices = 0;
cl_uint ret_num_platforms = 0;
cl_context context = NULL;
cl_command_queue command_queue = NULL;
cl_mem pixelsObject = NULL;
cl_kernel kernel = NULL;
cl_mem lookupObject = NULL;
cl_mem outputPixels = NULL;

int main() {
  FILE *fp = fopen("kernel.cl", "r"); 
  char *source_str;
  size_t source_size; 
  
  if (!fp) {
    fprintf(stderr, "Can't read kernel.cl\n");
    exit(1);
  }
  source_str = (char*) malloc(MAX_SOURCE_SIZE);
  source_size = fread(source_str, 1, MAX_SOURCE_SIZE, fp);
  fclose(fp);
  
  // Get platform and device information
  cl_int ret = clGetPlatformIDs(1, &platform_id, &ret_num_platforms);
  ret = clGetDeviceIDs( platform_id, CL_DEVICE_TYPE_GPU, 1, 
          &device_id, &ret_num_devices);
  assert(ret == CL_SUCCESS);
  
  // Create an OpenCL context
  puts("Creating OpenCL context");
  context = clCreateContext( NULL, 1, &device_id, NULL, NULL, &ret);
  
  // Create a command queue
  puts("Creating command queue");
  command_queue = clCreateCommandQueue(context, device_id, 0, &ret);
  
  puts("Creating OpenCL program");
  cl_program program = clCreateProgramWithSource(context, 1, 
          (const char **)&source_str, (const size_t *)&source_size, &ret);
  assert(ret == CL_SUCCESS);
  
  puts("Building OpenCL program");
  ret = clBuildProgram(program, 1, &device_id, NULL, NULL, NULL);
  assert(ret == CL_SUCCESS);
  
  puts("Creating OpenCL kernel");
  kernel = clCreateKernel(program, "kmain", &ret);
  assert(ret == CL_SUCCESS);
  
  uint8_t lookup[513] = {};
  scanf("%s", lookup); // First line guarantee be 512 bytes long
  for (int i = 0; i < 512; i++) {
    lookup2[i] = lookup[i] == '#';
  }
  
  int excludeSize = 80;
  int startX = excludeSize;
  int startY = excludeSize;
  int endX = width - excludeSize;
  int endY = height - excludeSize;
  int numIteration = 1;
  
  bool* image = malloc(width * height * sizeof(bool));
  memset(image, 0, width * height * sizeof(bool));
  
  char line[512]; // Enough for AoC lol
  int y = height / 4;
  while (scanf("%s", line) != EOF) {
    int x = width / 4;
    for (int i = 0; line[i] != 0; i++) {
      image[y * width + x] = line[i] == '#';
      x++;
    }
    y++;
  }
  
  puts("");
  puts("");
  
  for (int i = 0; i < numIteration; i++) {
    bool* tmp = enhance(image);
    free(image);
    image = tmp;
  } 
  
  int pixels = 0;
  system("clear");
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      if (image[y * width + x]) {
        printf("\x1b[47;1m\x1b[%d;%dH  ", y+1, (x*2)+1);
      } else {
        printf("\x1b[40;1m\x1b[%d;%dH  ", y+1, (x*2)+1);
      }
      if (x >= startX && y >= startY && x <= endX && y <= endY) {
        if (image[y * width + x]) {
          pixels++;
        }
      }
    }
    fflush(stdout);
  }
  printf("Result: %d\n", pixels); 
  
  ret = clFlush(command_queue);
  ret = clFinish(command_queue);
  ret = clReleaseKernel(kernel);
  ret = clReleaseProgram(program);
  ret = clReleaseMemObject(pixelsObject);
  ret = clReleaseMemObject(outputPixels);
  ret = clReleaseMemObject(lookupObject);
  ret = clReleaseCommandQueue(command_queue);
  ret = clReleaseContext(context);
  free(image);
}

// The actual muscle that does the processing
static bool* enhance(bool* image) {
  clFinish(command_queue);
  
  bool* newImage = malloc(width * height * sizeof(bool));
  memset(newImage, 0, width * height * sizeof(bool));
  cl_int ret;
  
  // Input pixels
  pixelsObject = clCreateBuffer(context, CL_MEM_READ_ONLY, 
          width * height * sizeof(bool), NULL, &ret);
  assert(ret == CL_SUCCESS);
  
  // Lookup table
  lookupObject = clCreateBuffer(context, CL_MEM_READ_ONLY, sizeof(bool) * 512, NULL, &ret);
  assert(ret == CL_SUCCESS);
  
  // Output pixels
  outputPixels = clCreateBuffer(context, CL_MEM_WRITE_ONLY, 
          width * height * sizeof(bool), NULL, &ret);
  assert(ret == CL_SUCCESS);
  
  // Copy the input pixels 
  ret = clEnqueueWriteBuffer(command_queue, pixelsObject, CL_TRUE, 0,
          width * height * sizeof(bool), image, 0, NULL, NULL);
  assert(ret == CL_SUCCESS);
  
  // Copy the lookup table 
  ret = clEnqueueWriteBuffer(command_queue, lookupObject, CL_TRUE, 0,
          512 * sizeof(bool), lookup2, 0, NULL, NULL);
  assert(ret == CL_SUCCESS);
  
  clFinish(command_queue);
  
  // Set the arguments of the kernel 
  ret = clSetKernelArg(kernel, 0, sizeof(cl_mem), (void *)&pixelsObject); assert(ret == CL_SUCCESS);
  ret = clSetKernelArg(kernel, 1, sizeof(cl_mem), (void *)&lookupObject); assert(ret == CL_SUCCESS);
  ret = clSetKernelArg(kernel, 2, sizeof(cl_mem), (void *)&outputPixels); assert(ret == CL_SUCCESS);
  ret = clSetKernelArg(kernel, 3, sizeof(cl_int), &width); assert(ret == CL_SUCCESS);
  ret = clSetKernelArg(kernel, 4, sizeof(cl_int), &height); assert(ret == CL_SUCCESS);
  
  clFinish(command_queue);
  
  size_t global_item_size = width * height; // Process the entire lists
  size_t local_item_size = 1;
  ret = clEnqueueNDRangeKernel(command_queue, kernel, 1, NULL, 
          &global_item_size, &local_item_size, 0, NULL, NULL);
  assert(ret == CL_SUCCESS);
  
  clFinish(command_queue);
  
  ret = clEnqueueReadBuffer(command_queue, outputPixels, CL_TRUE, 0, 
            width * height * sizeof(bool), newImage, 0, NULL, NULL);
  assert(ret == CL_SUCCESS);
  
  clFinish(command_queue);
  clReleaseMemObject(outputPixels);
  clReleaseMemObject(lookupObject);
  clReleaseMemObject(pixelsObject);
  return newImage;
}




