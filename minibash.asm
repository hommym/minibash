




    section .data
title db "Mini-Bash",0   
pathToFont db "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",0  



    section .bss
windows  resq 1
render   resq 1
font     resq 1
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
    extern SDL_CreateRenderer
    extern TTF_Init
    extern SDL_DestroyRenderer
    extern TTF_OpenFont
    extern TTF_CloseFont
    global main,render,font,windows
    




main:
push rbp
mov rbp,rsp

;initailising sdl
mov rdi,0x20 ; flag for video sub system
call SDL_InitSubSystem
cmp rax,0
jnz end

;initialising the font lib
call TTF_Init
cmp rax ,-1
jz end


windowCreation:
lea rdi,[title] 
mov rsi,100
mov rdx,100
mov rcx,500
mov r8,500
mov r9,0x20  ; flag for making the window resizeable
or r9,0x2000 ;flag for  high-DPI mode
call SDL_CreateWindow;creat windows for terminal 
cmp rax,0
jz end
;saving the pointer to the window which was just created
mov qword[windows],rax

renderCreation:
mov rdi,qword[windows]
mov rsi,-1
mov rdx,0x2 ;render flag
or rdx,0x4  ;render flags
call SDL_CreateRenderer
cmp rax,0
jz releaseResources
mov qword[render],rax

fontOpening:
lea rdi,[pathToFont]
mov rsi,18
call TTF_OpenFont
cmp rax,0
jz releaseResources
mov qword[font],rax


call eventLoop

releaseResources:
mov rdi,qword[font]
call TTF_CloseFont
mov rdi,qword[render]
call SDL_DestroyRenderer
mov rdi,qword[windows]
call SDL_DestroyWindow
call SDL_Quit

end:
pop rbp
xor rax,rax
ret