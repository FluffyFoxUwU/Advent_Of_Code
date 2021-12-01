#if 0
gcc -fsanitize=address -static-libasan  -O2 -Wall main.c 
exec ./a.out
#endif

//This code will be POSIX 2016 compliant
#define _POSIX_C_SOURCE 201600L

#include <stdio.h>
#include <stdlib.h>

int main() {
  int current = -1;
  int numberOfIncreases = 0;
  int number = 0;
  
  while (scanf("%d", &number) > 0) {
    if (current != -1 && number > current) {
      numberOfIncreases++;
    }
    current = number;
  };
  
  printf("%d\n", numberOfIncreases);
}







