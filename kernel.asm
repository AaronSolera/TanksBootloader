;----------------------------------------------------------------------------------------------------------------------------------------------------------------
;   asm-x86-game
;   This is a modified code obtained at https://github.com/igormp/asm-x86-game
;   Author fbsouza
;   Created at Sep 6th 2018
;----------------------------------------------------------------------------------------------------------------------------------------------------------------

org 0x7E00
jmp 0x0000:_start

section .data

    ;---------------------------------------------------------------------------
    ; Game constants
    ;---------------------------------------------------------------------------
    MAP_HEIGHT  equ 12
    MAP_WIDTH   equ 19

    TANK_HEIGHT equ 16
    TANK_WIDTH  equ 16

    msg2 db "colision",0h
    info1 db "LEVEL: ", 0h
    info2 db "KILLS: ", 0h
    info3 db "COMMAND: ", 0h
    level db "BEGINNER", 0h, "MEDIUM", 0h, "ADVANCED", 0h
    defeated_tanks db 48, 0h  
    command db "UP", 0h, "DOWN", 0h, "RIGHT", 0h, "LEFT", 0h, "SPACE", 0h, "L", 0h, "R", 0h
    bar db "________________________________________", 0h

    ; Player thank sprite
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

    ; Bullet sprite
    bullet db 00,00,00,00,00,00,08,08,00,00,00,00,00,00,00,00
          db 00,00,00,00,00,08,06,06,06,00,00,00,00,00,00,00
          db 00,00,00,00,08,06,06,06,07,08,00,00,00,00,00,00
          db 00,00,00,00,08,06,06,07,07,08,00,00,00,00,00,00
          db 00,00,00,00,08,06,06,07,07,08,00,00,00,00,00,00
          db 00,00,00,00,08,06,06,07,07,08,00,00,00,00,00,00
          db 00,00,00,00,08,06,06,07,07,08,00,00,00,00,00,00
          db 00,00,00,00,08,06,08,08,07,08,00,00,00,00,00,00
          db 00,00,00,00,08,08,07,07,08,08,00,00,00,00,00,00
          db 00,00,00,00,08,07,07,07,07,08,00,00,00,00,00,00
          db 00,00,00,00,08,07,07,07,07,08,00,00,00,00,00,00
          db 00,00,00,00,00,08,07,07,08,00,00,00,00,00,00,00
          db 00,00,00,00,00,00,08,08,00,00,00,00,00,00,00,00
          db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
          db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
          db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00

    ; Win animation sprites
    win   db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
          db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
          db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
          db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
          db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
          db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
          db 00,00,00,00,00,00,10,10,11,11,00,00,00,00,00,00
          db 00,00,00,00,00,00,10,10,11,11,00,00,00,00,00,00
          db 00,00,00,00,00,00,12,12,14,14,00,00,00,00,00,00
          db 00,00,00,00,00,00,12,12,14,14,00,00,00,00,00,00
          db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
          db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
          db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
          db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
          db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
          db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
          db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
          db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
          db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
          db 00,00,00,10,10,00,00,00,00,00,00,11,11,00,00,00
          db 00,00,00,10,10,00,00,00,00,00,00,11,11,00,00,00
          db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
          db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
          db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
          db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
          db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
          db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
          db 00,00,00,12,12,00,00,00,00,00,00,14,14,00,00,00
          db 00,00,00,12,12,00,00,00,00,00,00,14,14,00,00,00
          db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
          db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
          db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
          db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
          db 00,10,10,00,00,10,10,00,00,11,11,00,00,11,11,00
          db 00,10,10,00,00,10,10,00,00,11,11,00,00,11,11,00
          db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
          db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
          db 00,10,10,00,00,10,10,00,00,11,11,00,00,11,11,00
          db 00,10,10,00,00,10,10,00,00,11,11,00,00,11,11,00
          db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
          db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
          db 00,12,12,00,00,12,12,00,00,14,14,00,00,14,14,00
          db 00,12,12,00,00,12,12,00,00,14,14,00,00,14,14,00
          db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
          db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
          db 00,12,12,00,00,12,12,00,00,14,14,00,00,14,14,00
          db 00,12,12,00,00,12,12,00,00,14,14,00,00,14,14,00
          db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00

    CURRENT_MAP db 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00
                db 00, 01, 00, 01, 00, 01, 00, 00, 01, 00, 01, 00, 00, 01, 00, 01, 00, 01, 00
                db 00, 00, 00, 00, 00, 00, 00, 00, 01, 02, 01, 00, 00, 00, 00, 00, 00, 00, 00
                db 00, 01, 00, 01, 00, 01, 00, 00, 01, 02, 01, 00, 00, 01, 00, 01, 00, 01, 00
                db 00, 01, 00, 01, 00, 01, 00, 00, 01, 02, 01, 00, 00, 01, 00, 01, 00, 01, 00
                db 00, 00, 00, 00, 00, 00, 00, 00, 01, 00, 01, 00, 00, 00, 00, 00, 00, 00, 00
                db 02, 02, 00, 01, 01, 01, 00, 00, 00, 00, 00, 00, 00, 01, 01, 01, 00, 02, 02
                db 00, 00, 00, 00, 00, 00, 00, 00, 01, 00, 01, 00, 00, 00, 00, 00, 00, 00, 00
                db 00, 01, 01, 00, 01, 01, 00, 00, 01, 01, 01, 00, 00, 01, 01, 00, 01, 01, 00
                db 00, 01, 01, 00, 01, 01, 00, 00, 00, 00, 00, 00, 00, 01, 01, 00, 01, 01, 00
                db 00, 01, 01, 00, 01, 01, 00, 00, 01, 01, 01, 00, 00, 01, 01, 00, 01, 01, 00
                db 00, 00, 00, 00, 00, 00, 00, 00, 01, 03, 01, 00, 00, 00, 00, 00, 00, 00, 00

    MAP_LVL_1 db 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00
              db 00, 01, 00, 01, 00, 01, 00, 00, 01, 00, 01, 00, 00, 01, 00, 01, 00, 01, 00
              db 00, 00, 00, 00, 00, 00, 00, 00, 01, 02, 01, 00, 00, 00, 00, 00, 00, 00, 00
              db 00, 01, 00, 01, 00, 01, 00, 00, 01, 02, 01, 00, 00, 01, 00, 01, 00, 01, 00
              db 00, 01, 00, 01, 00, 01, 00, 00, 01, 02, 01, 00, 00, 01, 00, 01, 00, 01, 00
              db 00, 00, 00, 00, 00, 00, 00, 00, 01, 00, 01, 00, 00, 00, 00, 00, 00, 00, 00
              db 02, 02, 00, 01, 01, 01, 00, 00, 00, 00, 00, 00, 00, 01, 01, 01, 00, 02, 02
              db 00, 00, 00, 00, 00, 00, 00, 00, 01, 00, 01, 00, 00, 00, 00, 00, 00, 00, 00
              db 00, 01, 01, 00, 01, 01, 00, 00, 01, 01, 01, 00, 00, 01, 01, 00, 01, 01, 00
              db 00, 01, 01, 00, 01, 01, 00, 00, 00, 00, 00, 00, 00, 01, 01, 00, 01, 01, 00
              db 00, 01, 01, 00, 01, 01, 00, 00, 01, 01, 01, 00, 00, 01, 01, 00, 01, 01, 00
              db 00, 00, 00, 00, 00, 00, 00, 00, 01, 03, 01, 00, 00, 00, 00, 00, 00, 00, 00

section .bss
    posX resd 2
    posY resd 2
    posX2 resd 2
    posY2 resd 2
    dir resb 1
    resultcollition resd 1

    dir_offset resd 1
    i resb 6
    j resb 6

section .text

%macro delay 2 
    push ax
    push cx                               ; safe used registers in stack
    push dx

    mov cx, %2                            ; high value equal to first macro parameter
    mov dx, %1                            ; low value equal to second macro parameter
    mov ah, 86h                           ; wait BIOS call
    int 15h                               ; BIOS call

    pop dx                                ; restore values to used registers
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
    pop ebx
%endmacro

%macro print 3                          ; The parameter order is x, y, string memory pointer
    push ebp
    mov  ebp, esp
    pusha

    mov ah, 2
    mov bh, 0
    mov dh, %1                           ; move cursor to the postion discribed in second parameter
    mov dl, %2
    int 10h
    mov si, %3                            ; move string to si register
    
    %%_print:
      lodsb                                 ; move si to al
      mov ah, 0Eh                           ; print al
      mov bh, 0                             ; set page to be used
      mov bl, 15                            ; font color
      int 10h
      cmp al, 0                             ; comparing if al is equal to zero, it means the string is over
      jne %%_print                            ; repeating it for next character
    
    popa
    mov esp, ebp
    pop ebp
%endmacro

%macro print_info 3                       ; The parameter order is level (1=beginner, 2=medium, 3=advanced), kills, keyboard command (0=up, 1=down, 2=right, 3=left)
    mov  ebp, esp
    pushad
    print 0,  0, info1
    mov ax, %1
    cmp ax, 1
    je  _print_beginner
    cmp ax, 2
    je  _print_medium
    print 7,  0, level + 16
    jmp _continue_print

    _print_beginner:
        print 7,  0, level
        jmp _continue_print
    _print_medium:
        print 7,  0, level + 9

    _continue_print:
        print 16, 0, info2
        add word [defeated_tanks], %2 
        print 23, 0, defeated_tanks
        sub word [defeated_tanks], %2 
        print 25, 0, info3
        mov ax, %3
        cmp ax, 0
        je  _print_up
        cmp ax, 1
        je  _print_down
        cmp ax, 2
        je  _print_right
        print 34, 0, command + 14
        jmp _finish

    _print_up:
        print 34, 0, command 
        jmp _finish
    _print_down:
        print 34, 0, command + 3
        jmp _finish
    _print_right:
        print 34, 0, command + 8

    _finish:
        print 0,  1, bar
    popad
    mov esp, ebp
%endmacro

%macro animation 5                       ; The parameter order is x, y, frames, speed, sprite
    mov  ebp, esp
    push eax
    push ecx
    mov eax, 0
    mov ecx, %5
    _draw_frame:
        draw_sprite %1, %2, 0, ecx
        add ecx, 256
        inc eax
        delay 0, %4
        cmp eax, %3
        jl  _draw_frame
    pop ecx
    pop eax
    mov esp, ebp
%endmacro

_start:
    mov al, 13h                           ; setting 320x200 resolution 
    mov ah, 0h                            ; setting video mode
    int 10h                               ; calling BIOS screen service

    xor eax,eax
    mov eax,190
    mov [posX],eax
    mov eax,20
    mov [posY],eax
    mov eax,16
    mov [posX2],eax
    mov [posY2],eax
    mov eax,0
    mov eax,3
    mov [dir],eax

_loop:
    
    delay 30000, 0

    ;print_info 1, 0, 0
    print 0, 0, info1
    ;mov eax,[posX]
    ;sub eax,1
    ;mov [posX],eax 

    draw_sprite [posX],[posY],0,ptank
    mov eax,3
    mov [dir],eax
    call movePos
    mov eax,1
    mov [dir],eax
    call movePos

    ; -This is an example, erase it-
    call draw_map
    draw_sprite [posX2],[posY2],1,etank
    ; ------------------------------

    jmp _loop                             ; next loop iteration

;----------------------------------------------------------------------------------------------------------------------------------------------------------------
;   This macro draw a sprite
;   This is a modified code obtained at https://stackoverflow.com/questions/23723904/how-to-draw-a-square-int-10h-using-loops
;   Author Dusteh
;   Created at May 18th 2014
;----------------------------------------------------------------------------------------------------------------------------------------------------------------
_draw_sprite:
    push ebp
    mov  ebp, esp

    push ax
    push cx
    push dx
    push si
    push di

    mov cx, word [ebp + 10]               ; setting x position with first parameter
    mov dx, word [ebp + 8]                ; setting y position with first parameter
    mov ah, 0Ch                           ; setting write pixel mode

    mov si, cx                            ; copying x initial position to reset x draw counter
    add si, 16                            ; adding sprite width size to x initial position
    mov di, dx                            ; copying y initial position
    add di, 16                            ; adding sprite height size to y initial position

    mov dword [dir_offset], ebx           ; Moving ebx, which holds image memory address, to offset variable  
    cmp word [ebp + 6], 0                 ; Comparing postion parameter to 0 -> normal image
    je  _draw
    cmp word [ebp + 6], 3                 ; Comparing postion parameter to 3 -> left turned image
    je  _draw
    cmp word [ebp + 6], 2                 ; Comparing postion parameter to 2 -> right turned image
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
        cmp word [ebp + 6], 1
        je  _decrease1
        cmp word [ebp + 6], 2
        je _decrease16
        cmp word [ebp + 6], 3
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

            cmp word [ebp + 6], 0
            je  _subcontinue
            cmp word [ebp + 6], 1
            je  _subcontinue

            inc ebx                       ; increasing sprite memory pointer to get the next column of colors
            mov dword [dir_offset], ebx   ; Moving ebx, which holds image memory address, to offset variable

            _subcontinue:
                mov cx, word [ebp + 10]   ; reseting x counter with initial x position
                inc dx                    ; increasing y positon counter
                cmp dx, di                ; comparing if y postion reaches height sprite size
                jne _draw

    pop di
    pop si
    pop dx
    pop cx
    pop ax

    mov esp, ebp
    pop ebp
    ret 6



draw_map:
    push ebp
    mov ebp, esp

    push si
    push di
    push eax
    push cx
    push dx

    mov si, 8
    mov di, 0
    mov eax, CURRENT_MAP

    mov cx, 0
    mov dx, 0

    _draw_map:  
        cmp  byte [eax], 1
        je   _dwall
        cmp  byte [eax], 2
        je   _uwall
        cmp  byte [eax], 3
        je   _eagle
        jmp  _next_column

        _dwall:
            mov ebx, dwall
            jmp _draw_tiled
        _uwall:
            mov ebx, uwall
            jmp _draw_tiled
        _eagle:
            mov ebx, eagle

        _draw_tiled:
            push si                        
            push di                        
            push word 0
            call _draw_sprite

        _next_column:
            inc eax
            inc cx
            add si, 16
            cmp cx, MAP_WIDTH
            je  _next_row
            jmp _draw_map

        _next_row:
            mov si, 8
            add di, 16
            mov cx, 0
            inc dx
            cmp dx, MAP_HEIGHT
            jne _draw_map

    pop dx
    pop cx
    pop eax
    pop di
    pop si

    mov esp, ebp
    pop ebp
    ret

    ;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%richard%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    choca:
    pushad
        mov eax,[posX]
        xor eax,eax
        xor ebx,ebx
        mov eax,[posX]          ;eax = 10
        mov ebx,[posX2]         ;ebx = 16
        add ebx,15              ;ebx = 16 + 16 = 32
        cmp eax,ebx             ;comparo 
        jg salida               ;salta si eax es mayor y aun así..... salta
          ;print 10, 10, msg2
          
          mov eax,[posX]
          add eax,15
          mov ebx,[posX2]
          cmp ebx,eax
          jg salida
            mov eax,[posY]
            mov ebx,[posY2]
            add ebx,15
            cmp eax,ebx
            jg salida
              mov eax,[posY]
              mov ebx,[posY2]
              add eax,15
              cmp ebx,eax
              jg salida
                print 5, 5, msg2
                mov ecx,1
                mov [resultcollition],ecx
          
            ;print 10, 10, msg2
        salida:
    popad
    ret
    ;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%richard%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    movePos:
    
    ;*************************code here******************************
    ;movements configured
    ;0 move up,1 move down, 2 mov right, 3 mov left
    mov eax,0
    mov [resultcollition],eax
    mov eax,[dir]
      cmp eax,0
      jne mov_down              ; if don't jump, it have to move up
        mov eax,[posY]
        cmp eax,0
        je mov_fin

        mov eax,[posY]
        sub eax,1
        mov [posY],eax
        call compColisionMapa
        mov eax,[resultcollition]
        cmp eax,0
        je mov_fin
        mov eax,[posY]
        add eax,1
        mov [posY],eax

      jmp mov_fin
      mov_down:
        cmp byte[dir],1
        jne mov_right
        mov eax,[posY]
        cmp eax,176
        je mov_fin

        add eax,1
        mov [posY],eax
        call compColisionMapa
        mov eax,[resultcollition]
        cmp eax,0
        je mov_fin
        mov eax,[posY]
        sub eax,1
        mov [posY],eax

        jmp mov_fin
        mov_right:
          cmp byte[dir],2
          jne mov_left
          mov eax,[posX]
          cmp eax,304
          je mov_fin
            add eax,1
            mov [posX],eax
            call compColisionMapa
            mov eax,[resultcollition]
            cmp eax,0
            je mov_fin
            mov eax,[posX]
            sub eax,1
            mov [posX],eax


          jmp mov_fin
          mov_left:
            cmp byte[dir],3
            jne mov_fin
            mov eax,[posX]
            cmp eax,0
            je mov_fin
            sub eax,1
            mov [posX],eax
            call compColisionMapa
            mov eax,[resultcollition]
            cmp eax,0
            je mov_fin
            mov eax,[posX]
            add eax,1
            mov [posX],eax


    mov_fin:


    
    ret 



compColisionMapa:
    push ebp
    mov ebp, esp

    push si
    push di
    push eax
    push cx
    push dx

    mov si, 8
    mov di, 0
    mov eax, CURRENT_MAP

    mov cx, 0
    mov dx, 0
    mov ebx,8
    mov [posX2],ebx
    mov ebx,0
    mov [posY2],ebx
    _draw_mapa:  
        cmp  byte [eax], 0
        je _next_columna
          call choca  
        _next_columna:
            mov ebx,[posX2]
            add ebx,16
            mov [posX2],ebx
            inc eax
            inc cx
            add si, 16
            cmp cx, MAP_WIDTH
            je  _next_rowa
            jmp _draw_mapa

        _next_rowa:
            mov ebx,[posY2]
            add ebx,16
            mov [posY2],ebx
            mov ebx,8
            mov [posX2],ebx
            mov si, 8
            add di, 16
            mov cx, 0
            inc dx
            cmp dx, MAP_HEIGHT
            jne _draw_mapa

    pop dx
    pop cx
    pop eax
    pop di
    pop si

    mov esp, ebp
    pop ebp
    ret





compareColli:
  pushad
    mov eax,0
    mov [posX],eax
    mov [posY],eax
    ;mov [posX2],eax
    ;mov [posY2],eax

    mov eax, CURRENT_MAP
    mov ebx,0
    mov [posY2],ebx
    mov edx,0
    mov [i],edx
    loopHeight:

        mov edx,[i]
        cmp edx,12
        je  noColision
        mov ebx,0
        mov [posX2],ebx
        mov ecx,0
        mov [j],ecx
        loopWidth:

            mov ecx,[j]
            cmp ecx,20
            je nextRow
            cmp  byte [eax], 0
            je nextPos
            
            ;****************************************************************************************
            jmp choca
            
            nextPos:  
              ;print [i], [j], msg2 
              mov ebx,[posX2]
              add ebx, 16
              mov [posX2],ebx
              inc eax
              mov ecx,[j]
              add ecx,1
              mov [j],ecx
              jmp loopWidth
            nextRow:
              ;print [i], [j], msg2 
              mov ebx,[posY2]
              add ebx, 16
              mov [posY2],ebx
              mov ecx,[i]
              add ecx, 1
              mov [i],ecx
              jmp loopHeight
    noColision:
    print [i], [j], msg2

  popad
ret