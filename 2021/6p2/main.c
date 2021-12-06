#if 0
gcc -O2 -Wall main.c 
exec ./a.out
#endif

//This code will be POSIX 2016 compliant
#define _POSIX_C_SOURCE 201600L

#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>

int main() {
  puts("WARN: This will took gigabytes of memory to complete real puzzle input!\n");
  exit(1);
  
  uint8_t* world = calloc(1, sizeof(uint8_t));
  size_t len = 0;
  
  int fish;
  while (scanf("%d", &fish) > 0) {
    len++;
    world = realloc(world, sizeof(uint8_t) * len);
    world[len - 1] = (uint8_t) fish;
  };
  
  //Simulation
  for (int i = 0; i < 256; i++) {
    size_t lenO = len;
    for (int j = 0; j < lenO; j++) {
      fish = world[j];
      
      if (fish == 0) {
        len++;
        world = realloc(world, sizeof(uint8_t) * len);
        world[len - 1] = (uint8_t) 8;
        fish = 7;
      }
      
      world[j] = fish - 1;
    }
    printf("%d\n", i);
  }
  
  printf("%zu\n", len);
  
  free(world);
}







