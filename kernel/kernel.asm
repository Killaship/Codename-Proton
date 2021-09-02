[bits 16]
[org 0x7C00]


xor ax, ax
cli         ; disable interrupts to update ss:sp atomically (AFAICT, only required for <= 286)
mov ss, ax
mov sp, 0x7C00
sti

    jmp 0x0000:start_16 ; ensure cs == 0x0000

start_16:
    ; initialise essential segment registers
    xor ax, ax
    mov ds, ax
    mov es, ax


; read_sectors_16
;
; Reads sectors from disk into memory using BIOS services
;
; input:    dl      = drive
;           ch      = cylinder[7:0]
;           cl[7:6] = cylinder[9:8]
;           dh      = head
;           cl[5:0] = sector (1-63)
;           es:bx  -> destination
;           al      = number of sectors
;
; output:   cf (0 = success, 1 = failure)

read_sectors_16:
    pusha
    mov si, 0x02    ; maximum attempts - 1
.top:
    mov ah, 0x02    ; read sectors into memory (int 0x13, ah = 0x02)
    int 0x13
    jnc .end        ; exit if read succeeded
    dec sia          ; decrement remaining attempts
    jc  .end        ; exit if maximum attempts exceeded
    xor ah, ah      ; reset disk system (int 0x13, ah = 0x00)
    int 0x13
    jnc .top        ; retry if reset succeeded, otherwise exit
.end:
    popa
    retn
    


; print_string_16
;
; Prints a string using BIOS services
;
; input:    ds:si -> string

print_string_16:
    pusha
    mov  ah, 0x0E    ; teletype output (int 0x10, ah = 0x0E)
    mov  bx, 0x0007  ; bh = page number (0), bl = foreground colour (light grey)
.print_char:
    lodsb            ; al = [ds:si]++
    test al, al
    jz   .end        ; exit if null-terminator found
    int  0x10        ; print character
    jmp  .print_char ; repeat for next character
.end:
    popa
    retn


load_sector_2:
    mov  al, 0x02           
    mov  bx, 0x7E00         ; destination (might as well load it right after your bootloader)
    mov  cx, 0x0002         ; cylinder 0, sector 2
    mov  dl, [BootDrv]      ; boot drive
    xor  dh, dh             ; head 0
    call read_sectors_16
    jnc  .success           ; if carry flag is set, either the disk system wouldn't reset, or we exceeded our maximum attempts and the disk is probably shagged
    mov  si, read_failure_str
    call print_string_16
    jmp halt                ; jump to a hang routine to prevent further execution
.success:
    ; do whatever (maybe jmp 0x7E00?)
    jmp 0x7E00


read_failure_str db 'Boot disk read failure!', 13, 10, 0

halt:
    cli
    hlt
    jmp halt



times 510-($-$$) db 0
dw 0AA55h ; some BIOSes require this signature
