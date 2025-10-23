section .data
  number: db "67", 0x0 ; 0x0 is a null terminator ('\0' in higher level languages.)

section .text
global _start

; converts a string to an integer.
; input: `rdi` = pointer to a null terminated or new lined string.
; output: `rax` = integer.
atoi:
  mov rax, 0
  mov rcx, 0
  mov rdx, 0

  mov cl, byte [rdi]
  cmp cl, '-'
  jne .next_char_loop
  inc rdi
  mov rdx, 1

.next_char_loop:
  mov cl, byte [rdi]
  cmp cl, 0x0 ; check for null terminator.
  je .next_char_done
  cmp cl, 0xA ; check for new line.
  je .next_char_done
  cmp cl, '0' ; if digit is below the ascii integer for `0`, then it's not a digit.
  jb .next_char_done
  cmp cl, '9' ; if digit is above the ascii integer for `9`, then it's not a digit.
  ja .next_char_done

  sub cl, '0' ; converts character to integer.
  imul rax, rax, 10
  add rax, rcx

  inc rdi
  jmp .next_char_loop
.next_char_done:
  cmp rdx, 0
  je .return
  neg rax
.return:
  ret

_start:
  mov rdi, number
  call atoi

  mov rbx, rax

  ; exit codes at least in Linux can't be negative and can only be up to 255.
  ; meaning you'll get weird results.
  ; for simplicity (no `itoa` function), I've kept it to just be the exit code.

  ; to see the exit code first assemble the program and run it: `./main`
  ; then view the exit code by running as the next command `echo $?`.

  ; exit program
  mov rax, 60
  mov rdi, rbx
  syscall
