;----------------------------------------------------------------------------------------------------------------------------------------------------------------
;   asm-x86-game
;   This is a modified code obtained at https://github.com/igormp/asm-x86-game
;   Author fbsouza
;   Created at Sep 6th 2018
;   Modified By: Aaron Solera
;	Modified By: Efren Carvajal
;----------------------------------------------------------------------------------------------------------------------------------------------------------------

BITS 16             ; tell the assembler that we're using 16 bit mode
org 0x500           ; Sets the start addres for boot2 code
jmp 0x0000:_start   ; charges the DS with 0 via a far jump

_start:
    xor ax, ax      ; zeroes the DS, because from it the processor seeks the data used in the program
    mov ds, ax

    mov ah, 0x00
    mov al, 0x12    ; set video mode
    int 0x10

    mov ah, 0xb
    mov bh, 0       ; Set color for background 
    mov bl, 0x3
    int 10h


    mov ah, 2
    mov bh, 0
    mov dh, 13      ; move the course to the middle of the screen
    mov dl, 20
    int 0x10

    mov si, msg     ; Loads the address of "msg" into SI register

_print:
	lodsb           ; Loads the current byte from SI into AL and increments the address in SI 
	cmp al, 0       ; compares AL to zero
	je _keypress	; if the message is displayed, wait for option pressing
	mov ah, 0Eh     ; Print AL
	mov bh, 0       
    mov bl, 0x8     
	int 10h
    call _delay     ; milliseconds delay to appreciate letter appearance effect
	jmp _print      ; jmp to write the next character

_keypress:
    mov ah, 01h     ; Call mode for Key Stroke
    int 16h
    mov ah, 00h
    int 16h
    cmp al, 79h     ; if "y" key is pressed, jump to _reset
    je  _reset      ; if AL = "y" jump to _reset
    cmp al, 6Eh     ; otherwise, if "n" key is pressed, jump to _back
    je  _back       ; if AL = "n" jump to _back
    jmp _keypress   ; if nothing repeat

_delay:
    push ax
    push cx         ; safe used registers in stack
    push dx

    mov cx, 0       ; high value = 0
    mov dx, 10000   ; low value = 10000
    mov ah, 86h     ; wait BIOS call
    int 15h         ; BIOS call

    pop dx          ; restore values to used registers
    pop cx
    pop ax
    ret

_reset:
    mov ah, 0       ; AH = 0, function code that resets the disk controller
    mov dl, 0       ; drive number to be reset
    int 13h
    jc _reset       ; in case of error retry

    mov ax, 0x7E0   ;  move to ax the address 0x7E0 (kernel(game) start address)
    mov es, ax      
    xor bx, bx

_read:
    mov ah, 0x02    ; Function code for read from disk
    mov al, 0x09    ; Number of sector to read
    mov ch, 0x00    ; Number of cilinder to read
    mov cl, 0x04    ; Sector Number
    mov dh, 0       ; Head Number
    mov dl, 0       ; Drive Number
    int 13h
    jc _read        ; in case of error retry

    jmp 0x7E0:0x0   ; Jump to address 0x7E0:0, go to Kernel (game)

_back:
    jmp 0x7C0:0x0   ; jump to previous memory section

msg db "Would you like to start Tanks? (y/n)"