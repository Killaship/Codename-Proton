  
%define loc 0x1000
%define drive 0x80
%define os_sect 3

[bits 16]
[org 0]

jmp 0x7c0:start

start:




	mov ax,loc
	mov es,ax
	mov cl,os_sect ; sector
	mov al,4 ; number of sectors

	call loadsector


	jmp loc:0000 ; jump to our os


done:
	jmp $

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


times 510 - ($-$$) db 0
dw 0xaa55
