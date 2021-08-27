%define drive 0x00
%define kernel 0x1000
%define ksect 3
org 0x7C00   ; add 0x7C00 to label addresses
 bits 16      ; tell the assembler we want 16 bit code
 
   mov ax, 0  ; set up segments
   mov ds, ax
   mov es, ax
   mov ss, ax     ; setup stack
   mov sp, 0x7C00 ; stack grows downwards from 0x7C00
   
   
mov ax,kernel
mov es,ax
mov cl,ksect ; sector
mov al,4 ; number of sectors

call loadsector

jmp kernel:0000

  
loadsector:
	mov bx,0
	mov dl,drive ; drive
	mov dh,0 ; head
	mov ch,0 ; track
	mov ah,2
	int 0x13
	jc err
	ret
 
 err:
  jmp $

 .temp db 0
 
   times 510-($-$$) db 0
   dw 0AA55h ; some BIOSes require this signature






