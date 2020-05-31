BITS 16 ; informa ao assembler que eh um codigo de 16 bits, ou seja, no modo real
org 0x500 ; endereco do bootsector area, apos utilizar a diretiva org deve-se carregar o CS e o DS com 0
jmp 0x0000:_start ; carrega o DS com 0 atraves de um far jump

_start:
    xor ax, ax ; zera o DS, pois a partir dele que o processador busca os dados utilizados no programa
    mov ds, ax

    mov ah, 00h
    mov al, 12h ; inicia o modo video
    int 10h

    mov ah, 0xb
    mov bh, 0   ;seta a cor de fundo pra cyan
    mov bl, 0x3
    int 10h


    mov ah, 2
    mov bh, 0
    mov dh, 13  ; move o curso pro meio da tela
    mov dl, 20
    int 10h

    mov si, msg     ; salva Text em si

_print:
	lodsb           ; carrega si em al
	cmp al, 0       ; compara al e 0
	je _keypress	        ; if the message is displayed, wait for option pressing
	mov ah, 0Eh     ; Printa AL
	mov bh, 0       ; paǵina
    mov bl, 0x8     ; cor
	int 10h
    call _delay             ; milliseconds delay to appreciate letter appearance effect
	jmp _print       ; repete pra prox caractere

_keypress:
    mov ah, 01h     ; modo da chamada para keystroke
    int 16h
    mov ah, 00h
    int 16h
    cmp al, 79h             ; if "y" key is pressed, jump to _reset
    je  _reset
    cmp al, 6Eh             ; otherwise, if "n" key is pressed, jump to _back
    je  _back
    jmp _keypress

_delay:
    push ax
    push cx                 ; safe used registers in stack
    push dx

    mov cx, 0               ; high value = 0
    mov dx, 10000           ; low value = 10000
    mov ah, 86h             ; wait BIOS call
    int 15h                 ; BIOS call

    pop dx                  ; restore values to used registers
    pop cx
    pop ax
    ret

_reset:
    mov ah, 0 ; AH = 0, codigo da funcao que reinicia o controlador de disco
    mov dl, 0 ; numero do drive a ser resetado
    int 13h
    jc _reset ; caso aconteca algum erro, tenta novamente

    mov ax, 0x7E0 ; ler o setor do endereco 0x7e0
    mov es, ax ; segmento com dados extra
    xor bx, bx

_read:
    mov ah, 0x02 ; codigo da funcao que le do disco
    mov al, 0x06 ; numero de setores a serem lidos
    mov ch, 0x00 ; numero do cilindro a ser lido
    mov cl, 0x04 ; numero do setor
    mov dh, 0 ; numero do cabecote
    mov dl, 0 ; numero do drive
    int 13h
    jc _read ; caso aconteca algum erro, tenta novamente


    jmp 0x7E0:0x0 ; executar o setor do endereco 0x7e0:0, vai para o kernel

_back:
    jmp 0x7C0:0x0           ; jump to previous memory section

msg db "Would you like to start Tanks? (y/n)"