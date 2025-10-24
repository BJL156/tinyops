BOARD_WIDTH  equ 20
BOARD_HEIGHT equ 10

section .data
  ball: db 'o'
  bg:   db '-'
  nl:   db 0xA

  ball_x: dq 1
  ball_y: dq 2
  dir_x:  dq 1
  dir_y:  dq 1

  seconds:     dq 0
  nanoseconds: dq 125000000

  clear_ansi:  db 0x1B, '[', '2', 'J'
  return_ansi: db 0x1B, '[', 'H'

section .text
global _start

; void putchar(char *c)
putchar:
  mov rsi, rdi
  mov rax, 1
  mov rdi, 1
  mov rdx, 1
  syscall
  ret

; void return_cursor()
return_cursor:
  mov rsi, return_ansi
  mov rax, 1
  mov rdi, 1
  mov rdx, 3
  syscall
  ret

; void clear_terminal()
clear_terminal:
  mov rsi, clear_ansi
  mov rax, 1
  mov rdi, 1
  mov rdx, 4
  syscall
  call return_cursor
  ret

; void sleep
sleep:
  mov rax, 35
  lea rdi, [seconds]
  lea rsi, [nanoseconds]
  syscall
  ret

; void print_board()
print_board:
  mov r12, 0
.board_loop_outer:
  mov r13, 0
.board_loop_inner:
  mov rax, r12
  cmp rax, [ball_y]
  jne .put_bg
  mov rax, r13
  cmp rax, [ball_x]
  jne .put_bg
.put_ball:
  mov rdi, ball
  call putchar
  jmp .board_loop_inner_inc
.put_bg:
  mov rdi, bg
  call putchar
.board_loop_inner_inc:
  inc r13
  cmp r13, BOARD_WIDTH
  jne .board_loop_inner

  mov rdi, nl
  call putchar

  inc r12
  cmp r12, BOARD_HEIGHT
  jne .board_loop_outer

  ret

_start:
  call clear_terminal
.logic_loop:
  cmp qword [ball_y], BOARD_HEIGHT - 1
  je .bounce_y
  cmp qword [ball_y], 0
  je .bounce_y
  mov rax, [ball_y]
  add rax, [dir_y]
  mov qword [ball_y], rax
  jmp .handle_x

.bounce_y:
  neg qword [dir_y]
  mov rax, [ball_y]
  add rax, [dir_y]
  mov qword [ball_y], rax

.handle_x:
  cmp qword [ball_x], BOARD_WIDTH - 1
  je .bounce_x
  cmp qword [ball_x], 0
  je .bounce_x
  mov rax, [ball_x]
  add rax, [dir_x]
  mov qword [ball_x], rax
  jmp .render

.bounce_x:
  neg qword [dir_x]
  mov rax, [ball_x]
  add rax, [dir_x]
  mov qword [ball_x], rax

.render:
  call return_cursor
  call print_board
  call sleep
  jmp .logic_loop

  mov rax, 60
  mov rdi, 0
  syscall
