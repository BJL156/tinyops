section .data
  msg: db "This message is being printed using an implementation of `puts`. It automatically calculates the size and therefore, it's not hardcoded.", 0xA, 0x0 ; 0x0 is a null terminator `\0`.

section .text
global _start

; prints a null terminated string to the standard output.
puts:
  mov rsi, rdi ; store string to print using the write syscall.

  mov rcx, 0 ; index tracker. Similar to `int i = 0;` in for loops.
.count_characters_loop:
  mov al, byte [rdi + rcx] ; index into `msg`.
  cmp al, 0 ; checking for the null terminator.
  je .count_characters_done
  inc rcx
  jmp .count_characters_loop

.count_characters_done:
  mov rax, 1
  mov rdi, 1
  ; no need to set `rsi` here, since it was setup at the top of `puts`.
  mov rdx, rcx
  syscall
  ret

_start:
  mov rdi, msg
  call puts

  mov rax, 60
  mov rdi, 0
  syscall
