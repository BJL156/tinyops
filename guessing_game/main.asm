section .text
    guess_msg_str: db "Guess a number: "
    guess_msg_len equ $ - guess_msg_str
    
    win_msg_str: db "You win.", 0xA
    win_msg_len equ $ - win_msg_str
    
    high_msg_str: db "Too high.", 0xA
    high_msg_len equ $ - high_msg_str
    
    low_msg_str: db "Too low.", 0xA
    low_msg_len equ $ - low_msg_str

    secret_number equ 67

section .bss
    input: resb 4
    input_end:

section .text
global _start

_start:
.game_loop:
    mov rax, 1
    mov rdi, 1
    mov rsi, guess_msg_str
    mov rdx, guess_msg_len
    syscall
    
    mov rax, 0
    mov rdi, 0
    mov rsi, input
    mov rdx, input_end - input
    syscall
    mov rbx, rax

    mov r8, 0
    mov rcx, 0
.loop:
    cmp rcx, rbx
    jge .done

    movzx r9, byte [input + rcx]
    cmp r9, 0xA
    je .done
    sub r9, '0'

    imul r8, r8, 0xA
    add r8, r9

    inc rcx
    jmp .loop
.done:
    cmp r8, secret_number
    je .win
    jl .low
    jg .high
.low:
    mov rax, 1
    mov rdi, 1
    mov rsi, low_msg_str
    mov rdx, low_msg_len
    syscall
    jmp .game_loop
.high:
    mov rax, 1
    mov rdi, 1
    mov rsi, high_msg_str
    mov rdx, high_msg_len
    syscall
    jmp .game_loop
.win:
    mov rax, 1
    mov rdi, 1
    mov rsi, win_msg_str
    mov rdx, win_msg_len
    syscall
    
    mov rax, 60
    mov rdi, 0
    syscall
