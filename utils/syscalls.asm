

  section .data




  section .text
  global readSysCall,writeSysCall  


readSysCall:
sub rsp,0x8
mov rax,0
mov rdx,1
syscall
add rsp,0x8
ret

writeSysCall:
sub rsp,0x8
mov rax,1
mov rdx,1
add rsp,0x8
ret