






    section .data
bytTracker          dw 0     
envp                dq 0 
startChar           db "my-bash@",0x20 
locCmd              db "/usr/bin",0
cmdNotFoundErr      db "Command Not Found😞",0xa   ;13 bytes




    section .bss
usrContent             resq 131072   ;reserving 1mb space for content of usr directory
cmdOutput              resq 131072    ;1mb space for output    
allUserInput           resb 1024
opt                    resb 100
cmdLength              resb 1  
addresOfExevArgs       resq 3
cmd                    resb 30
currentCmdC            resb 30
fullPath               resb 30  
pipFd                  resd 2        ;pipfd[0]= read pipfd[1]=write
usrFd                  resw 1
singleInput            resb 1




    section .text
    global _start



_start:
lea rax ,[cmdOutput]
call clearData               
mov word[bytTracker],0
mov rax,1
mov rdi,1
lea rsi,[startChar]
mov rdx,9
syscall; print @ on the screen 

getUserInput:
mov rax,0
mov rdi,0
lea rsi,[singleInput]
mov rdx,1
syscall

saveInput:
movzx rax,word[bytTracker]
mov bl,byte[singleInput]
cmp bl,0xa
jz printInput
mov byte[allUserInput+rax],bl
inc word[bytTracker]


printInput:
mov rax,1
mov rdi,1
lea rsi,[singleInput]
mov rdx,1
; syscall
jnz getUserInput
xor rbx,rbx
mov r8,-1
mov rcx,-1
mov rdx,0
movzx rax ,byte[bytTracker]        
mov byte[allUserInput+rax],0; null terminating allUserInput

processInput:
        .getCmd:
        inc r8
        mov bl,byte[allUserInput+r8]
        movzx rax,word[bytTracker]
        cmp rax,r8
        jz  checkCmd
        cmp bl,0x20
        cmovz rbx,rdx
        mov byte[cmd+r8],bl
        jnz .getCmd
       

        .getOpt:
        inc r8
        inc rcx
        mov bl,byte[allUserInput+r8]
        cmp bl,0
        mov byte[opt+rcx],bl
        jnz .getOpt        
;break user input into cmd and options

checkCmd:
sub r8,rcx
mov byte[cmdLength],r8b
lea rax,[allUserInput]
call clearData
        .openUsrDir:
        mov rax,2
        lea rdi,[locCmd]
        mov rsi,0x10000
        syscall
        mov word[usrFd],ax; open and save fd of usr dir

        .getUsrContent:
        movzx rbx,word[usrFd]
        mov rax,217
        mov rdi,rbx
        lea rsi,[usrContent]
        mov rdx,1048576
        syscall
        xor r10,r10  ;will contain bytes read from usrContent during cmd search
        
        

        .checkCItemIfValid:
        cmp r10,1048576
        jge .closeUsrDir
        mov al,byte[usrContent+r10+19]
        cmp al,0
        jz .closeUsrDir
        xor rcx,rcx
        xor r11,r11
        mov r11,r10
        add r11,19

        .getCurrentCmdInDirent:
        mov al,byte[usrContent+r11]
        cmp al,0
        mov byte[currentCmdC+rcx],al
        jz .cmpCmds
        inc r11
        inc rcx
        jmp .getCurrentCmdInDirent

        .cmpCmds:
        cld
        movzx rcx,byte[cmdLength]
        lea rsi,[cmd]
        lea rdi,[currentCmdC]
        repe cmpsb
        mov rax,0  
        mov rbx,1            
        cmovz r13,rbx
        cmovnz r13,rax   ;using r13 to track if cmd was found or not bolean value
        jz .closeUsrDir

        .updateByteRead:
        movzx rax,word[usrContent+r10+16]
        add r10,rax
        jmp .checkCItemIfValid

        .closeUsrDir:
        movzx rcx,word[usrFd]
        mov rax,3
        mov rdi,rcx
        syscall  ; closing usr dir

cmp r13,0   ;checking if cmd was found or not
jnz creatFullPathToCmd
;check if cmd exist



printCmdNotFound:
mov rax,1
mov rdi,1
lea rsi,[cmdNotFoundErr]
mov rdx,22
syscall
jmp _start



creatFullPathToCmd:
mov r8,-1
mov rcx,-1
                    .addUsrPath:
                    inc r8
                    inc rcx
                    movzx rax,byte[locCmd+rcx]
                    mov rbx,"/"
                    cmp rax,0
                    cmovz rax,rbx
                    mov byte[fullPath+r8],al
                    jnz .addUsrPath
                    mov rcx,-1

                    .addCmd:
                    inc r8
                    inc rcx
                    movzx rax,byte[cmd+rcx]
                    mov rbx,0
                    cmp rax,0
                    cmovz rax,rbx
                    mov byte[fullPath+r8],al
                    jnz .addCmd
;if it exist create full path to cmd

createPip:
mov rax,22
lea rdi,[pipFd]
syscall

creatChildProc:
mov rax,57
syscall
cmp rax,0
jz childProc
jg parentCont
jl end





childProc:
xor rbx,rbx
mov ebx,dword[pipFd]
mov rax,3
mov rdi,rbx
syscall         ;close read fd on parent
mov ebx,dword[pipFd+4]
mov rax,33
mov rdi,rbx
mov rsi,1
syscall  ; dup write fd for the pip 
mov qword[addresOfExevArgs],fullPath
mov qword[addresOfExevArgs+8],opt
mov qword[addresOfExevArgs+16],0
mov rax ,59
lea rdi,[fullPath]
lea rsi,[addresOfExevArgs]
lea rdx,[envp]
syscall; syscall to execute the cmd command


parentCont:
xor rcx,rcx
mov ecx,dword[pipFd+4]
mov rax,3
mov rdi,rcx
syscall         ;close write fd on parent
mov rax,61
mov rdi,-1
xor rsi,rsi
syscall         ;wait for child process to finish

readDataFromChild:
mov ecx,dword[pipFd]
mov rax,0
mov rdi,rcx
lea rsi,[cmdOutput]
mov rdx,1048576
syscall
xor rbx,rbx



printOutPutFromChild:
mov al,byte[cmdOutput+rbx]
mov byte[singleInput],al
cmp al,0
jz _start
mov rax,1
mov rdi,1
lea rsi,[singleInput]
mov rdx,1
syscall  ;printing output char by char
inc rbx
jmp printOutPutFromChild



end:
xor rcx,rcx        
mov rax,60
mov rdi,0
syscall



clearData:
mov rcx,-1
    .start:
    inc rcx
    mov al,byte[rax+rcx]
    cmp al,0
    mov byte[rax+rcx],0
    jnz .start
ret  ; this procedure takes argument passed in rax

