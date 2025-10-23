section .data
  pre_sleep_msg: db "Sleeping...", 0xA
  pre_sleep_len equ $ - pre_sleep_msg

  post_sleep_msg: db "Finished sleeping.", 0xA
  post_sleep_len equ $ - post_sleep_msg

section .text
global _start

; void sleep(uint64_t seconds)
sleep:
  sub rsp, 16

  ; set up struct needed for syscall `nanosleep`
  ; struct {
  ;   uint64_t seconds;
  ;   uint64_t nanoseconds;
  ; }
  mov [rsp], rdi ; seconds = rdi;
  mov qword [rsp + 8], 0 ; nanoseconds = 0;

  ; call nanosleep
  mov rax, 35
  mov rdi, rsp
  mov rsi, 0
  syscall

  add rsp, 16

  ret

_start:
  mov rax, 1
  mov rdi, 1
  mov rsi, pre_sleep_msg
  mov rdx, pre_sleep_len
  syscall

  ; sleep
  mov rdi, 2
  call sleep

  mov rax, 1
  mov rdi, 1
  mov rsi, post_sleep_msg
  mov rdx, post_sleep_len
  syscall

  mov rax, 60
  mov rdi, 0
  syscall
