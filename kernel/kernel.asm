bits 16
org 0x7C00

    ; For greater portability you should
    ; do further initializations here like setup the stack and segments. 

    ; Load stage 2 to memory.
    mov ah, 0x02
    mov al, 0x04 ; amount of sectors to load
    ; This may not be necessary as many BIOS setup is as an initial state.
    mov dl, 0x00
    mov ch, 0
    mov dh, 0
    mov cl, 2
    mov bx, stage2
    int 0x13

    jmp stage2

    ; Magic bytes.    
    times ((0x200 - 2) - ($ - $$)) db 0x00
    dw 0xAA55

stage2:

   mov si, welcome
   call print_string
 
 mainloop:
   mov si, prompt
   call print_string
 
   mov di, buffer
   call get_string
 
   mov si, buffer
   cmp byte [si], 0  ; blank line?
   je mainloop       ; yes, ignore it
 
   mov si, buffer
   mov di, cmd_hi  ; "hi" command
   call strcmp
   jc .helloworld
 
   mov si, buffer
   mov di, cmd_help  ; "help" command
   call strcmp
   jc .help
 
   mov si, buffer
   mov di, cmd_phex  ; "phex" command
   call strcmp
   jc .phex
 
   mov si, buffer
   mov di, cmd_help2  ; "help_advanced" command
   call strcmp
   jc .help2
   
   mov si, buffer
   mov di, cmd_cls  ; "cls" command
   call strcmp
   jc .cls
   
   

   mov si,badcommand
   call print_string 
   jmp mainloop  
 
 .helloworld:
   mov si, msg_helloworld
   call print_string
 
   jmp mainloop
 
 
 .cls:
   call cls
 
   jmp mainloop
 
 .help:
   mov si, msg_help
   call print_string
 
   jmp mainloop
 
  .help2:
    mov si, msg_helpa1
    call print_string
    mov si, msg_helpa2
    call print_string
    mov si, msg_helpa3
    call print_string
    mov si, msg_helpa4
    call print_string
    mov si, msg_helpa5
    call print_string
    mov si, msg_helpa6
    call print_string
   
    jmp mainloop
 
  .phex:
  call print_hex_byte
  jmp mainloop
 
 

 
 welcome db 'Welcome to Codename Proton 0.0.1.', 0x0D, 0x0A, 0
 msg_helloworld db 'Hello, World!', 0x0D, 0x0A, 0
 badcommand db 'Bad command entered.', 0x0D, 0x0A, 0
 prompt db 'kernel@Proton:', 0
 cmd_hi db 'hi', 0
 cmd_help db 'help', 0
 cmd_phex db 'phex', 0
 cmd_cls db 'cls', 0
 cmd_help2 db 'help_advanced', 0
 msg_help db 'Commands: hi, help, phex, help_advanced, cls', 0x0D, 0x0A, 0
 msg_helpa1 db '||ADVANCED HELP||', 0x0D, 0x0A, 0
 msg_helpa2 db 'help: Displays a list of commands.', 0x0D, 0x0A, 0
 msg_helpa3 db 'help_advanced: Displays a list of commands with descriptions.', 0x0D, 0x0A, 0
 msg_helpa4 db 'hi: Prints a "hello, world" message.', 0x0D, 0x0A, 0
 msg_helpa5 db 'phex: Prints the contents of the register AL.', 0x0D, 0x0A, 0
 msg_helpa6 db 'cls: Clears the screen.', 0x0D, 0x0A, 0
 buffer times 64 db 0
 
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
 
   cmp cl, 0x3F  ; 63 chars inputted?
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
 
 

  cls:
    mov ah, 0
    int 0x10

  print_hex_byte: 
   mov [.temp],al
   shr al,4
   cmp al,10
   sbb al,69h
   das
 
   mov ah,0Eh
   int 10h
 
   mov al,[.temp]
   ror al,4
   shr al,4
   cmp al,10
   sbb al,69h
   das
 
   mov ah,0Eh
   int 10h
 
   mov ah, 0x0E
   mov al, 0x0D
   int 0x10
   mov al, 0x0A
   int 0x10		; newline
   
   ret

  .temp db 0
