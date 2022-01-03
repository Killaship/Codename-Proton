org 0x7C00   ; add 0x7C00 to label addresses
 bits 16      ; tell the assembler we want 16 bit code
 
   mov ax, 0  ; set up segments
   mov ds, ax
   mov es, ax
   mov ss, ax     ; setup stack
   mov sp, 0x7C00 ; stack grows downwards from 0x7C00
   
   mov si, welcome
   call print_string
 drive db 0x00
 mainloop:
   mov si, prompt
   call print_string
 
   mov di, buffer
   call get_string
 
   mov si, buffer
   cmp byte [si], 0  ; blank line?
   je mainloop       ; yes, ignore it
 
   mov si, buffer
   mov di, cmd_boot  ; "boot" command
   call strcmp
   jc .boot
 
   mov si, buffer
   mov di, cmd_help  ; "help" command
   call strcmp
   jc .help
 
 
 
   mov si,badcommand
   call print_string 
   jmp mainloop  
 
 .boot:
   mov si, msg_bootm
   call print_string
   mov byte [drive], 0x00
      .bootloop: ; haha
         mov si, buffer
         cmp byte [si], 0  ; blank line?
         je .bootloop ; ignore it then, off to the bit bucket you go, blank line...
         
         
 
   
 .help:
    mov si, msg_help
    call print_string
 
   jmp mainloop
 
 welcome db 'ProtonBootShell', 0x0D, 0x0A, 0
 badcommand db 'Bad Cmd!', 0x0D, 0x0A, 0
 prompt db '>', 0
 cmd_boot db 'boot', 0
 cmd_help db 'help', 0
 msg_help db 'Commands: boot, help', 0x0D, 0x0A, 0
 msg_bootm db 'Enter 1 to boot from floppy A, 2 for floppy B, and 3 for hard drive 1.', 0x0D, 0x0A, 0 
 buffer times 16 db 0 ; why the hell do we need 64 bytes? we need to save precious memory!  
 
 ; ================
 ; calls start here
 ; ================
 
 print_string:
   lodsb        ; grab a byte from SI
 
   or al, al  ; logical or AL by itself
   jz .done   ; if the result is zero, get out
 
   mov ah, 0x0E
   int 0x10      ; otherwise, print out the character!
 
   jmp print_string
 
 .done:
   ret
 
 get_string:
   xor cl, cl
 
 .loop:
   mov ah, 0
   int 0x16   ; wait for keypress
 
   cmp al, 0x08    ; backspace pressed?
   je .backspace   ; yes, handle it
 
   cmp al, 0x0D  ; enter pressed?
   je .done      ; yes, we're done
 
   cmp cl, 0x0F  ; 15 chars inputted?
   je .loop      ; yes, only let in backspace and enter
 
   mov ah, 0x0E
   int 0x10      ; print out character
 
   stosb  ; put character in buffer
   inc cl
   jmp .loop
 
 .backspace:
   cmp cl, 0	; beginning of string?
   je .loop	; yes, ignore the key
 
   dec di
   mov byte [di], 0	; delete character
   dec cl		; decrement counter as well
 
   mov ah, 0x0E
   mov al, 0x08
   int 10h		; backspace on the screen
 
   mov al, ' '
   int 10h		; blank character out
 
   mov al, 0x08
   int 10h		; backspace again
 
   jmp .loop	; go to the main loop
 
 .done:
   mov al, 0	; null terminator
   stosb
 
   mov ah, 0x0E
   mov al, 0x0D
   int 0x10
   mov al, 0x0A
   int 0x10		; newline
 
   ret
 
 strcmp:
 .loop:
   mov al, [si]   ; grab a byte from SI
   mov bl, [di]   ; grab a byte from DI
   cmp al, bl     ; are they equal?
   jne .notequal  ; nope, we're done.
 
   cmp al, 0  ; are both bytes (they were equal before) null?
   je .done   ; yes, we're done.
 
   inc di     ; increment DI
   inc si     ; increment SI
   jmp .loop  ; loop!
 
 .notequal:
   clc  ; not equal, clear the carry flag
   ret
 
 .done: 	
   stc  ; equal, set the carry flag
   ret
 
 .boot2: ; this boot routine actually boots
     ; Load stage 2 to memory.
    mov ah, 0x02
    mov al, 0x06 ; amount of sectors to load
    ; This may not be necessary as many BIOS setup is as an initial state.
    mov dl, [drive]
    mov ch, 0
    mov dh, 0
    mov cl, 2
    mov bx, 0x1000 ; where the OS is location'ed
    int 0x13

    jmp 0x1000
 
 
   times 510-($-$$) db 0
   dw 0AA55h ; some BIOSes require this signature
