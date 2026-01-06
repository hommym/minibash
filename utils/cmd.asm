

        section .bss
currentUserInput    resb  1000
slaveFd             resd  1


        section .text
        global currentUserInput,resetcurrentUserInput
        extern masterFd



processCmd:

; creat a child 
; get slave fd 
; dup stin and stout
; make that process session 
; extract cmd and options and execute
ret




resetcurrentUserInput:
xor rcx,rcx
    .start:
    mov al,byte[currentUserInput+rcx]
    cmp al,0
    jz .end
    mov byte[currentUserInput+rcx],0
    inc rcx
    jmp .start

    .end:
    mov rax,0    
ret    