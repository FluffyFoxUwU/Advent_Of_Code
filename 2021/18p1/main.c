#if 0
gcc -fsanitize=address -static-libasan  -O2 -Wall main.c 
exec ./a.out
#endif

//This code will be POSIX 2016 compliant
#define _POSIX_C_SOURCE 201600L

int main() {
  
}

 