






    section .data
bytTracker          dw 0     
envp                dq 0 
symbol              db "@",0x20,0
startChar           db "my-bash:",0 
locCmd              db "/usr/bin",0
cmdNotFoundErr      db "Command Not Found 😞",0xa,0   ;13 bytes
cdCmdErr            db "mini-bash: cd: No such file or folder 😞",0xa,0
isAllCmdP           db 0                          ;boolean to know if /usr/content has been loaded
isCWDSet            db 0                          ;boolean to see if cwd is set
cdCmd               db "cd",0
lsCmd               db  "ls",0



    section .bss
usrContent             resq 131072   ;reserving 1mb space for content of usr directory
cmdOutput              resq 2621440    ;20mb space for output    
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
cWkDir                 resb 1024
oldCWkDir              resb 1024



    section .text
    global _start



_start:
movzx rax,byte[isCWDSet]
cmp rax,0
jnz resetMem
call getCwd

resetMem:
lea rax,[cmdOutput]
call clearData       
lea rax,[cmd]
call clearData
lea rax,[opt]
call clearData        
mov word[bytTracker],0


printDefs:
lea r14,[startChar]
mov r15,8
call print  ;print my-bash: on the screen 
lea rax,[cWkDir]
call countChar
lea r14,[cWkDir]
mov r15,rax
call print; print cwd
lea r14,[symbol]
mov r15,2
call print  ;print @ symbol

getBinContent:
movzx rax,byte[isAllCmdP]
cmp rax,0
jnz getUserInput
call getAllCmd


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
sub r8,rcx
mov byte[cmdLength],r8b
lea rsi,[cdCmd]
lea rdi,[cmd]
mov rcx,3
call compStringVal
cmp rax,0
jnz processCdCmd
;check if the cmd is cd 

checkCmd:
lea rax,[allUserInput]
call clearData              
xor r10,r10  ;will contain bytes read from usrContent during cmd search
        .checkCItemIfValid:
        cmp r10,1048576
        jge printCmdNotFound
        mov al,byte[usrContent+r10+19]
        cmp al,0
        jz printCmdNotFound
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
        movzx rcx,byte[cmdLength]
        lea rsi,[cmd]
        lea rdi,[currentCmdC]
        call compStringVal
        cmp rax,0
        jnz creatFullPathToCmd

        .updateByteRead:
        movzx rax,word[usrContent+r10+16]
        add r10,rax
        jmp .checkCItemIfValid
;check if cmd exist

printCmdNotFound:
lea r14,[cmdNotFoundErr]
mov r15,23
call print
jmp _start

printCdErr:
lea r14,[cdCmdErr]
mov r15,43
call print
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
lea r14,[singleInput]
mov r15,1
call print;printing output char by char
inc rbx
jmp printOutPutFromChild

processCdCmd:
mov rax,80
lea rdi,[opt]
syscall; chdir syscall
cmp rax,0
jl printCdErr
mov rcx,1
lea rax,[cWkDir]
call clearData
call getCwd
jmp _start


end:
xor rcx,rcx        
mov rax,60
mov rdi,0
syscall

getAllCmd:
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

         .closeUsrDir:
        movzx rcx,word[usrFd]
        mov rax,3
        mov rdi,rcx
        syscall  ; closing usr dir

mov byte[isAllCmdP],1        
ret       

getCwd:
mov rax,79
lea rdi,[cWkDir]
mov rsi,512
syscall
mov byte[isCWDSet],1
ret


compStringVal:
cld
repe cmpsb
mov r12,0
mov r13,1
cmovz rax,r13
cmovnz rax,r12
; pass start adresses of string into rsi and rdi
; pass len of the main string you are comparing in rcx
; if rax is 0 is not equal and if is 1 is true
ret

print:
mov rax,1
mov rdi,1
lea rsi,[r14]
mov rdx,r15
syscall
ret;load buffer address into r14 and num of bytes to print into r15



countChar:
mov rcx,-1
    .count:
    inc rcx
    movzx rdx,byte[rax+rcx]
    cmp rdx,0.
    jnz .count    
ret ;load buffer start address to rax

clearData:
mov rcx,-1
xor r13,r13
    .start:
    inc rcx
    mov r13b,byte[rax+rcx]
    cmp r13b,0
    mov byte[rax+rcx],0
    jnz .start
ret  ; this procedure takes argument passed in rax





;component for handling 0 options for ls and other cmds 

