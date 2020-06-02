;----------------------------------------------------------------------------------------------------------------------------------------------------------------
;   asm-x86-game
;   This is a modified code obtained at https://github.com/igormp/asm-x86-game
;   Author fbsouza
;   Created at Sep 6th 2018
;----------------------------------------------------------------------------------------------------------------------------------------------------------------

org 0x7E00
jmp 0x0000:_start

section .data

section .bss

section .text

%macro delay 1 
    push ax
    push cx                 ; safe used registers in stack
    push dx

    mov cx, 0               ; high value = 0
    mov dx, %1           ; low value = 10000
    mov ah, 86h             ; wait BIOS call
    int 15h                 ; BIOS call

    pop dx                  ; restore values to used registers
    pop cx
    pop ax
%endmacro

%macro draw_sprite 4                      ;This macro draws a sprite with x, y, rotation and image_memory_pointer parameters
    push ebx
    push word %1                          ; x postition parameter
    push word %2                          ; y postition parameter
    push word %3                          ; rotating sprite parameter
    mov  ebx, %4                          ; sprite memory pointer parameter
    call _draw_sprite;                    ; _draw_sprite fuction call
    sub esp, 6                            ; deleting parameters from stack 
    pop ebx
%endmacro

%macro print 3
    pushad
    mov ah, 2
    mov bh, 0
    mov dh, %1      ; move o curso pro meio da tela
    mov dl, %2
    int 10h
    mov si, %3      ; salva Text em si
    call _print
    popad
%endmacro

_start:
    mov al, 13h                           ; setting 320x200 resolution 
    mov ah, 0h                            ; setting video mode
    int 10h                               ; calling BIOS screen service
    mov ax, 200

_loop:
    
    delay 30000

    print 0, 0, msg
    draw_sprite 100, 100, 3, ptank
    draw_sprite 132, 100, 0, etank
    draw_sprite 164, 100, 0, uwall
    draw_sprite 196, 100, 0, dwall
    draw_sprite 228, 100, 0, eagle

    jmp _loop                             ; next loop iteration

;----------------------------------------------------------------------------------------------------------------------------------------------------------------
;   This macro draw a sprite
;   This is a modified code obtained at https://stackoverflow.com/questions/23723904/how-to-draw-a-square-int-10h-using-loops
;   Author Dusteh
;   Created at May 18th 2014
;----------------------------------------------------------------------------------------------------------------------------------------------------------------
_draw_sprite:
    mov  ebp, esp
    pushad

    mov cx, word [ebp + 6]                ; setting x position with first parameter
    mov dx, word [ebp + 4]                ; setting y position with first parameter
    mov ah, 0Ch                           ; setting write pixel mode

    mov si, cx                            ; copying x initial position to reset x draw counter
    add si, 16                            ; adding sprite width size to x initial position
    mov di, dx                            ; copying y initial position
    add di, 16                            ; adding sprite height size to y initial position

    mov dword [dir_offset], ebx           ; Moving ebx, which holds image memory address, to offset variable   
    cmp word [ebp + 2], 0                 ; Comparing postion parameter to 0 -> normal image
    je  _draw
    cmp word [ebp + 2], 3                 ; Comparing postion parameter to 3 -> left turned image
    je  _draw
    cmp word [ebp + 2], 2                 ; Comparing postion parameter to 2 -> right turned image
    je  _right

    add ebx, 255                          ; Adding 255 to image memory address if position parameter is 1 -> bottom turned image
    mov dword [dir_offset], ebx           ; Moving ebx, which holds image memory address, to offset variable 
    jmp _draw

    _right:
      add ebx, 240                        ; Adding 240 to image memory address if position parameter is 2
      mov dword [dir_offset], ebx         ; Moving ebx, which holds image memory address, to offset variable 

    _draw:
        push ebx                          ; Pushing ebx for not affecting it
        mov ebx, dword [dir_offset]       ; Seeting ebx value with offset variable 
        mov al, byte [ebx]                ; getting colors from sprite memory pointer
        pop ebx                           ; Poping ebx for not affecting it

        int 10h                           ; calling BIOS screen service 
        inc cx                            ; increasing x positon counter
        cmp word [ebp + 2], 1
        je  _decrease1
        cmp word [ebp + 2], 2
        je _decrease16
        cmp word [ebp + 2], 3
        je _increase16

        inc dword [dir_offset]            ; increasing sprite memory pointer to get the next color
        jmp _continue

        _decrease1: 
            dec dword [dir_offset]        ; decreasing sprite memory pointer to get the next color
            jmp _continue
        _decrease16:
            sub dword [dir_offset], 16    ; decreasing by 16 the sprite memory pointer to get the next color
            jmp _continue
        _increase16:
            add dword [dir_offset], 16    ; increasing by 16 the sprite memory pointer to get the next color

        _continue:
            cmp cx, si                    ; comparing if x postion reaches width sprite size

            jne _draw

            cmp word [ebp + 2], 0
            je  _subcontinue
            cmp word [ebp + 2], 1
            je  _subcontinue

            inc ebx                       ; increasing sprite memory pointer to get the next column of colors
            mov dword [dir_offset], ebx   ; Moving ebx, which holds image memory address, to offset variable 

            _subcontinue:
                mov cx, word [ebp + 6]    ; reseting x counter with initial x position
                inc dx                    ; increasing y positon counter
                cmp dx, di                ; comparing if y postion reaches height sprite size

                jne _draw

    popad
    mov esp, ebp
    
    ret

_print:
    lodsb           ; carrega si em al
    mov ah, 0Eh     ; Printa AL
    mov bh, 0       ; paǵina
    mov bl, 15      ; cor
    int 10h
    cmp al, 0       ; compara al e 0
    jne _print      ; repete pra prox caractere
    ret

; Enemy thank sprite
ptank db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
      db 00,00,00,00,00,00,10,10,10,10,00,00,00,00,00,00
      db 00,00,00,00,00,00,10,10,10,10,00,00,00,00,00,00
      db 00,10,10,10,00,00,00,10,10,00,00,00,10,10,10,00
      db 00,07,07,07,00,00,00,10,10,00,00,00,07,07,07,00
      db 00,10,10,10,00,00,00,10,10,00,00,00,10,10,10,00
      db 00,07,07,07,00,10,10,10,10,10,10,00,07,07,07,00
      db 00,10,10,10,10,10,10,10,10,10,10,10,10,10,10,00
      db 00,07,07,10,10,10,10,07,07,10,10,10,10,07,07,00
      db 00,10,10,10,10,10,07,07,07,07,10,10,10,10,10,00
      db 00,07,07,10,10,10,07,07,07,07,10,10,10,07,07,00
      db 00,10,10,10,10,10,07,07,07,07,10,10,10,10,10,00
      db 00,07,07,10,10,10,10,07,07,10,10,10,10,07,07,00
      db 00,10,10,10,10,10,10,10,10,10,10,10,10,10,10,00
      db 00,07,07,07,00,10,10,10,10,10,10,00,07,07,07,00
      db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00

; Enemy thank sprite
etank db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
      db 00,00,00,00,00,00,14,14,14,14,00,00,00,00,00,00
      db 00,00,00,00,00,00,14,14,14,14,00,00,00,00,00,00
      db 00,14,14,14,00,00,00,14,14,00,00,00,14,14,14,00
      db 00,07,07,07,00,00,00,14,14,00,00,00,07,07,07,00
      db 00,14,14,14,00,00,00,14,14,00,00,00,14,14,14,00
      db 00,07,07,07,00,14,14,14,14,14,14,00,07,07,07,00
      db 00,14,14,14,14,14,14,14,14,14,14,14,14,14,14,00
      db 00,07,07,14,14,14,14,07,07,14,14,14,14,07,07,00
      db 00,14,14,14,14,14,07,07,07,07,14,14,14,14,14,00
      db 00,07,07,14,14,14,07,07,07,07,14,14,14,07,07,00
      db 00,14,14,14,14,14,07,07,07,07,14,14,14,14,14,00
      db 00,07,07,14,14,14,14,07,07,14,14,14,14,07,07,00
      db 00,14,14,14,14,14,14,14,14,14,14,14,14,14,14,00
      db 00,07,07,07,00,14,14,14,14,14,14,00,07,07,07,00
      db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00

; Destroyable wall sprite
dwall db 07,07,07,07,07,07,07,07,07,07,07,07,07,07,07,07
      db 07,07,07,07,07,07,07,07,07,07,07,07,07,07,07,07
      db 06,06,06,07,07,06,06,06,06,06,06,07,07,06,06,06
      db 06,06,06,07,07,06,06,06,06,06,06,07,07,06,06,06
      db 07,07,07,07,07,07,07,07,07,07,07,07,07,07,07,07
      db 07,07,07,07,07,07,07,07,07,07,07,07,07,07,07,07
      db 07,06,06,06,06,06,06,07,07,06,06,06,06,06,06,07
      db 07,06,06,06,06,06,06,07,07,06,06,06,06,06,06,07
      db 07,07,07,07,07,07,07,07,07,07,07,07,07,07,07,07
      db 07,07,07,07,07,07,07,07,07,07,07,07,07,07,07,07
      db 06,06,06,07,07,06,06,06,06,06,06,07,07,06,06,06
      db 06,06,06,07,07,06,06,06,06,06,06,07,07,06,06,06
      db 07,07,07,07,07,07,07,07,07,07,07,07,07,07,07,07
      db 07,07,07,07,07,07,07,07,07,07,07,07,07,07,07,07
      db 07,06,06,06,06,06,06,07,07,06,06,06,06,06,06,07
      db 07,06,06,06,06,06,06,07,07,06,06,06,06,06,06,07


; Undestroyable wall sprite
uwall db 07,07,07,07,07,07,07,07,07,07,07,07,07,07,07,08
      db 07,07,07,07,07,07,07,07,07,07,07,07,07,07,08,08
      db 07,07,07,07,07,07,07,07,07,07,07,07,07,08,08,08
      db 07,07,07,07,07,07,07,07,07,07,07,07,08,08,08,08
      db 07,07,07,07,15,15,15,15,15,15,15,15,08,08,08,08
      db 07,07,07,07,15,15,15,15,15,15,15,15,08,08,08,08
      db 07,07,07,07,15,15,15,15,15,15,15,15,08,08,08,08
      db 07,07,07,07,15,15,15,15,15,15,15,15,08,08,08,08
      db 07,07,07,07,15,15,15,15,15,15,15,15,08,08,08,08
      db 07,07,07,07,15,15,15,15,15,15,15,15,08,08,08,08
      db 07,07,07,07,15,15,15,15,15,15,15,15,08,08,08,08
      db 07,07,07,07,15,15,15,15,15,15,15,15,08,08,08,08
      db 07,07,07,07,08,08,08,08,08,08,08,08,08,08,08,08
      db 07,07,07,08,08,08,08,08,08,08,08,08,08,08,08,08
      db 07,07,08,08,08,08,08,08,08,08,08,08,08,08,08,08
      db 07,08,08,08,08,08,08,08,08,08,08,08,08,08,08,08

; Eagle sprite
eagle db 07,00,00,00,00,00,07,07,07,00,00,00,00,00,00,07
      db 07,07,07,00,00,00,07,07,06,06,06,00,00,07,07,07
      db 07,07,07,07,00,00,07,07,06,06,06,00,07,07,07,07
      db 00,07,07,07,07,07,07,07,06,06,07,07,07,07,07,00
      db 00,07,07,07,07,07,07,07,07,07,07,07,07,07,07,00
      db 00,07,07,07,07,07,07,07,07,07,07,07,07,07,07,00
      db 00,00,07,07,07,07,07,07,07,07,07,07,07,07,00,00
      db 00,00,07,07,07,07,07,07,07,07,07,07,07,07,00,00
      db 00,00,00,07,07,07,07,07,07,07,07,07,07,00,00,00
      db 00,00,00,07,07,07,07,07,07,07,07,07,07,00,00,00
      db 00,00,00,00,07,07,06,07,07,06,07,07,00,00,00,00
      db 00,00,00,00,00,06,07,06,06,07,06,00,00,00,00,00
      db 00,00,00,00,00,07,07,07,07,07,07,00,00,00,00,00
      db 00,00,00,00,07,00,07,07,07,07,00,07,00,00,00,00
      db 00,00,00,07,00,07,00,07,07,00,07,00,07,00,00,00
      db 00,00,07,00,07,00,07,00,00,07,00,07,00,07,00,00

msg db "Level ",0h
dir_offset dd 0