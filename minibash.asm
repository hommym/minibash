




    section .data
title db "Mini-Bash",0   
  



    section .bss
windows  resq 1
keyStore    resb 1   ; section for storing keys(alpa-numeric) entered from the keyboard






    section .text
    extern printf
    extern SDL_InitSubSystem
    extern SDL_Quit   ;function for quiting sdl
    extern SDL_CreateWindow   ;returns the window object
    extern SDL_DestroyWindow
    extern SDL_Delay
    extern SDL_Event
    extern SDL_PollEvent
    extern eventLoop
    global main
    




main:
push rbp
mov rbp,rsp

;initailising sdl
mov rdi,0x20 ; flag for video sub system
call SDL_InitSubSystem

;creat windows for terminal 
lea rdi,[title]
mov rsi,100
mov rdx,100
mov rcx,500
mov r8,500
mov r9,0x20  ; flag for making the window resizeable
call SDL_CreateWindow
cmp rax,0
jz end

saveCreatedWindows:
mov qword[windows],rax
call eventLoop

mov rdi,qword[windows]
call SDL_DestroyWindow

end:
call SDL_Quit
pop rbp
xor rax,rax
ret