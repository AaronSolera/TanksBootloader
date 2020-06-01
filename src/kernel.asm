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

%macro draw_sprite 3
    push ebx
    push word %1                    ; x postition parameter
    push word %2                    ; y postition parameter
    mov  ebx, %3                    ; sprite memory pointer parameter
    call _draw_sprite;              ; _draw_sprite fuction call
    sub esp, 4                      ; deleting parameters from stack 
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
    mov al, 13h                     ; setting 320x200 resolution 
    mov ah, 0h                      ; setting video mode
    int 10h                         ; calling BIOS screen service
    mov ax, 200

_loop:
    
    delay 30000

    print 0, 0, msg
    draw_sprite 100, ax, ptank
    draw_sprite 132, 100, etank
    draw_sprite 164, 100, uwall
    draw_sprite 196, 100, dwall
    draw_sprite 228, 100, eagle
    dec ax

    jmp _loop                       ; next loop iteration

;----------------------------------------------------------------------------------------------------------------------------------------------------------------
;   This macro draw a sprite
;   This is a modified code obtained at https://stackoverflow.com/questions/23723904/how-to-draw-a-square-int-10h-using-loops
;   Author Dusteh
;   Created at May 18th 2014
;----------------------------------------------------------------------------------------------------------------------------------------------------------------
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
        
        jne _draw

        mov cx, word [ebp + 4]      ; reseting x counter with initial x position
        inc dx                      ; increasing y positon counter
        cmp dx, di                  ; comparing if y postion reaches height sprite size

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