    mov ah, 01h
    ; Lee pulsación de tecla
    mov ah, 00h 
    int 16h
    ; Si es L
    cmp al, 6Ch    
    je  _pause
    ; Si es R
    cmp al, 72h
    je _restart
    ; Si es espacio
    cmp ah, 39h
    je _shoot
    ; Si es flecha abajo
    cmp ah, 50h
    je _down
    ; Si es flecha arriba
    cmp ah, 48h
    je _up
    ; Si es flecha izquierda
    cmp ah, 4Bh
    je _left
    ; Si es flecha derecha
    cmp ah, 4Dh
    je _right

_pause:
	; Hacer algo
	;;,,,,,,,,,
	; 

_restart:
	; Hacer algo
	;;,,,,,,,,,
	; 

_shoot:
	; Hacer algo
	;;,,,,,,,,,
	; 

_down:
	; Hacer algo
	;;,,,,,,,,,
	; 

_up:
	; Hacer algo
	;;,,,,,,,,,
	; 

_left:
	; Hacer algo
	;;,,,,,,,,,
	; 

_right:
	; Hacer algo
	;;,,,,,,,,,
	; 





    
