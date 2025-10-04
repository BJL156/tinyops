section .data
  msg: db "This is 27 characters long.", 0x0

section .text
global _start

; returns rax with the length of a string without including the null terminator.
strlen:
  mov rax, 0 ; this will be the counter to find the length of the string.
.count_characters_loop:
  cmp byte [rdi + rax], 0x0 ; check if the index into the string is a null terminator.
  je .count_characters_done
  inc rax
  jmp .count_characters_loop
.count_characters_done:
  ret

_start:
  mov rdi, msg
  call strlen

  mov rbx, rax ; move the return value of strlen into rbx, so that rax can be set to the exit syscall.

  ; to keep things simple (no itoa function),
  ; the result of strlen will just be the exit code.
  ; to see the exit code, after running `./main`, run 'echo $?' to print the exit code.

  ; exit program
  mov rax, 60
  mov rdi, rbx ; exit code is now the result of rax.
  syscall
