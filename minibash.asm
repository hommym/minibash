




    section .data
title db "Mini-Bash",0   
pathToFont db "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",0  
ptPath    db "/dev/ptmx",0


    section .bss
windows     resq 1
render      resq 1
font        resq 1
masterFd    resd 1  
slaveFd     resd 1






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
    extern loadCwd
    extern posix_openpt
    extern unlockpt
    extern grantpt
    extern ptsname
    extern open
    extern O_RDWR
    extern O_NOCTTY
    global main,render,font,windows,masterFd,slaveFd
    




main:
push rbp
mov rbp,rsp

;loading the cwd
call loadCwd

;initailising sdl
mov rdi,0x20 ; flag for video sub system
call SDL_InitSubSystem
cmp rax,0
jnz end

;initialising the font lib
call TTF_Init
cmp rax ,-1
jz end


;creating master fd and prep other needed details
mov rdi,0x0102 
call posix_openpt
mov dword[masterFd],eax
xor rdi,rdi
mov edi,eax
call grantpt
xor rdi,rdi
mov edi,dword[masterFd]
call unlockpt

; creating slaveFd
xor rdi,rdi
mov edi,dword[masterFd]
call ptsname
mov rdi,rax
mov rsi,0x0102
call open
mov dword[slaveFd],eax


windowCreation:
lea rdi,[title] 
mov rsi,100
mov rdx,100
mov rcx,1000
mov r8,700
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