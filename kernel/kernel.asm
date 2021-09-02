use16
org 0x7C00

    ; For greater portability you should
    ; do further initializations here like setup the stack and segments. 

    ; Load stage 2 to memory.
    mov ah, 0x02
    mov al, 1
    ; This may not be necessary as many BIOS setup is as an initial state.
    mov dl, 0x80
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

    ; Print 'a'.
    mov ax, 0x0E61
    int 0x10

    cli
    hlt

    ; Pad image to multiple of 512 bytes.
    times ((0x400) - ($ - $$)) db 0x00
