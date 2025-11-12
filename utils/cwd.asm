

    section .data
roug   db "a",0    

; this component is for handling cWkDir cmds and also getting cwds  
    section .bss
cWkDir   resb   1024    ;reserving 1KB for cWkDir storage




    section .text
    global setCwd,loadCwd,getCwd


setCwd:
sub rsp,0x8
mov rax,80 ;no need to pass data for rdi for the syscall due the calling convention
syscall; chdir syscall
cmp rax,0
jl .error
        .success:
         call loadCwd
         mov rax,0
         add rsp,0x8
         ret
         
        .error:
         mov rax,-1
         add rsp,0x8
         ret
; C funtion definition= int setCwd(char *path)


getCwd:
sub rsp,0x8
lea rax,[cWkDir]
add rsp,0x8
ret
;  C funtion definition= char *gerCwd()


loadCwd:
sub rsp,0x8
mov rax,79
lea rdi,[cWkDir]
mov rsi,512
syscall
add rsp,0x8
ret
;  C funtion definition= void loadCwd()