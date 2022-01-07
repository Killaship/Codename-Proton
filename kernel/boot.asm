org 0x7C00   ; add 0x7C00 to label addresses
 bits 16      ; tell the assembler we want 16 bit code
 
   mov ax, 0  ; set up segments
   mov ds, ax
   mov es, ax
   mov ss, ax     ; setup stack
   mov sp, 0x7C00 ; stack grows downwards from 0x7C00
   
 boot: ; this boot routine actually boots
     ; Load stage 2 to memory.
    mov ah, 0x02
    mov al, 0x06 ; amount of sectors to load
    ; This may not be necessary as many BIOS setup is as an initial state.
    mov dl, 0x00
    mov ch, 0
    mov dh, 0
    mov cl, 2
    mov bx, 0x1000 ; where the OS is location'ed
    int 0x13
    

    jmp 0x1000
 

 
   times 510-($-$$) db 0
   dw 0AA55h ; some BIOSes require this signature
