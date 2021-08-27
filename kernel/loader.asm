
org 0x7C00   ; add 0x7C00 to label addresses
 bits 16      ; tell the assembler we want 16 bit code
 
   mov ax, 0  ; set up segments
   mov ds, ax
   mov es, ax
   mov ss, ax     ; setup stack
   mov sp, 0x7C00 ; stack grows downwards from 0x7C00
 

; TODO: Make code to load ~ 4K from disk and far jump to it.


  


 .temp db 0
 
   times 510-($-$$) db 0
   dw 0AA55h ; some BIOSes require this signature






