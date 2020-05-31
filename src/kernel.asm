org 0x7E00
jmp 0x0000:_start

section .data

section .bss

section .text

%macro delay 1 
    push ax
    push cx                 ;guarda valores dos regs na pinha
    push dx

    mov cx, 0               ;high value = 0
    mov dx, %1              ;low value = 2000
    mov ah, 86h             ;modo da chamda
    int 15h

    pop dx                  ;retorna valores originais dos regs
    pop cx
    pop ax
%endmacro

;----------------------------------------------------------------------------------------------------------------------------------------------------------------
;   This macro draw a sprite
;   This is a modified code obtained at https://stackoverflow.com/questions/23723904/how-to-draw-a-square-int-10h-using-loops
;   Author Dusteh
;   Created at May 18th 2014
;----------------------------------------------------------------------------------------------------------------------------------------------------------------
%macro draw_sprite 3
    push ebx
    push word %1                    ; x postition parameter
    push word %2                    ; y postition parameter
    mov  ebx, %3                    ; sprite memory pointer parameter
    call _draw_sprite;              ; _draw_sprite fuction call
    sub esp, 4                      ; deleting parameters from stack 
    pop ebx
%endmacro

_start:
    mov al, 12h                     ; setting 320x200 resolution 
    mov ah, 0h                      ; setting video mode
    int 10h                         ; calling BIOS screen service

_loop:

    draw_sprite 50, 100, etank

    jmp _loop                       ; next loop iteration

_draw_sprite:
    mov  ebp, esp
    pushad

    mov cx, word [ebp + 4]          ; setting x position with first parameter
    mov dx, word [ebp + 2]          ; setting y position with first parameter
    mov ah, 0Ch                     ; setting write pixel mode

    mov si, cx                      ; copying x initial position to reset x draw counter
    add si, 16                      ; adding sprite width size to x initial position
    mov di, dx                      ; copying y initial position
    add di, 16                      ; adding sprite height size to y initial position

    _draw:
        mov al, byte [ebx]          ; getting colors from sprite memory pointer
        int 10h                     ; calling BIOS screen service 
        inc cx                      ; increasing x positon counter
        inc ebx                     ; increasing sprite memory pointer to get the next color
        cmp cx, si                  ; comparing if x postion reaches width sprite size

        JNE _draw

        mov cx, word [ebp + 4]      ; reseting x counter with initial x position
        inc dx                      ; increasing y positon counter
        cmp dx, di                  ; comparing if y postion reaches height sprite size

        JNE _draw

    popad
    mov esp, ebp
    ret

_clrscr:
    push ax
    mov ah, 06h                     ; This interrupt scrolls up the window
    mov al, 0x00                    ; AL = 0 clears the screen
    int 10h                         ; call BIOS Screen Service
    pop ax
    ret

    ; Enemy thank sprite
    ; Enemy thank sprite
    etank db 00,00,00,00,00,00,14,14,14,14,00,00,00,00,00,00
          db 00,00,00,00,00,00,14,14,14,14,00,00,00,00,00,00
          db 00,00,00,00,00,00,00,14,14,00,00,00,00,00,00,00
          db 14,14,14,00,00,00,00,14,14,00,00,00,00,14,14,14
          db 14,14,14,00,00,00,00,14,14,00,00,00,00,14,14,14
          db 14,14,14,00,00,00,00,14,14,00,00,00,00,14,14,14
          db 14,14,14,00,00,14,14,14,14,14,14,00,00,14,14,14
          db 14,14,14,00,14,14,14,14,14,14,14,14,00,14,14,14
          db 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
          db 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
          db 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
          db 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
          db 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
          db 14,14,14,00,14,14,14,14,14,14,14,14,00,14,14,14
          db 14,14,14,00,00,14,14,14,14,14,14,00,00,14,14,14
          db 14,14,14,00,00,00,14,14,14,14,00,00,00,14,14,14

    ; Player thank sprite
    ptank db 07,10,00,10,10,00,10,10
          db 10,10,00,10,10,00,10,07
          db 07,10,00,10,10,00,10,10
          db 10,10,07,10,10,07,10,07
          db 07,10,10,07,07,10,10,10
          db 10,10,10,07,07,10,10,07
          db 07,10,07,10,10,07,10,10
          db 10,10,00,00,00,00,10,07

    ; Wall sprite
    wall  db 06,06,06,07,06,06,06,07
          db 06,06,06,07,06,06,06,07
          db 07,07,07,07,07,07,07,07
          db 07,06,06,06,07,06,06,06
          db 07,06,06,06,07,06,06,06
          db 07,07,07,07,07,07,07,07
          db 06,06,06,07,06,06,06,07
          db 06,06,06,07,06,06,06,07

    ; Eagle thank sprite
    eagle db 07,00,00,07,07,00,00,07 
          db 07,07,07,07,08,07,07,07
          db 07,07,07,07,08,08,07,07
          db 00,07,07,07,07,07,07,00
          db 00,00,07,07,07,07,00,00
          db 00,00,08,07,07,08,00,00
          db 00,07,07,07,07,07,07,00
          db 07,00,07,00,00,07,00,07


