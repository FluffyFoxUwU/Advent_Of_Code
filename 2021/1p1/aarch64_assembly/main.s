# ARM64 assembly
# as dare
/*
Simple ABI to keep everything tidy
x0 return arg 1
x1 arg 2
x2 arg 3
x3 arg 4
x4 arg 5 
*/

.macro PUSH reg
  str \reg, [sp, #-16]!
.endm

.macro POP reg
  ldr \reg, [sp], #16 
.endm

.macro CALL label
  PUSH lr
  bl \label
  POP lr
.endm

.text
.global _start
.extern printf

.data
_start.number: .word 0
_start.scanf_fmt: .string "%d"
.text
_start:
  /*
  x1 is "current"
  x2 is "numberOfIncreases"
  */
  
  //Variables
  mov x1, -1  // current
  mov x2, 0   // numberOfIncrease
  
  //Actual execution
  _start.loop:
    // scanf("%d", &number) also break loop if scanf return -1 //
    PUSH x1
    PUSH x2
    
    ldr x0, =_start.scanf_fmt
    ldr x1, =_start.number
    CALL scanf
    cmp w0, -1
    beq _start.quit_loop
    
    ldr x2, =_start.number
    mov x0, 0
    ldr w0, [x2]
    
    POP x2
    POP x1
    /////////////////
    
    //Main logic
    cmp x0, x1
    bgt _start.loop.if_true
    b _start.loop.if_false
    _start.loop.if_true:
      add x2, x2, 1
    _start.loop.if_false:
    
    // current = number
    mov x1, x0
  b _start.loop
  _start.quit_loop:
  POP x2
  POP x1
  
  //Printing result
  sub x0, x2, 1
  CALL print_integer
  
  //Quiting
  mov x0, 0
  CALL exit

// x0 exit code
exit:
  mov x8, 0x5D  // exit syscall number
	svc #0        // perform syscall
  ret           // Unreachable but its neat to peoples

//x0 character read result
read:
  PUSH x1
  PUSH x2
  PUSH x8
  
  ldr x1, =read.buffer  // Load the buffer address
  
  mov x0, 1                 // File descriptor
  mov x2, 1                 // Size to write
  mov x8, 0x3F              // write(2) syscall number
  svc #0
  
  ldrb w0, [x1]
  
  POP x8
  POP x2
  POP x1
  ret

//x0 character to write
write:
  PUSH x0
  PUSH x1
  PUSH x2
  PUSH x8
  
  ldr x1, =teletype.buffer  // Load the buffer address
  strb w0, [x1]              // Store one byte
  
  mov x0, 1                 // File descriptor
  mov x2, 1                 // Size to write
  mov x8, 0x40              // write(2) syscall number
  svc #0
  
  POP x8
  POP x2
  POP x1
  POP x0
  ret

//x0 integer to write
print_integer:
  PUSH x1
  PUSH x0
  
  mov x1, x0
  ldr x0, =print_integer.fmt
  CALL printf
  
  POP x0
  POP x1
  ret

.data
  teletype.buffer: .byte 0x00
  read.buffer: .byte 0x00
  print_integer.fmt: .string "%lld\n"





