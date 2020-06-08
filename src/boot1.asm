;----------------------------------------------------------------------------------------------------------------------------------------------------------------
;   asm-x86-game
;   This is a modified code obtained at https://github.com/igormp/asm-x86-game
;   Author fbsouza
;   Created at Sep 6th 2018
;	Modified By: Aaron Solera
;	Modified By: Efren Carvajal
;----------------------------------------------------------------------------------------------------------------------------------------------------------------

BITS 16 			; tell the assembler that we're using 16 bit mode
;Code for make the USB Booteable
mov eax, cr0
or eax, 1
;mov cr0, eax 		; For Qemu test comment this line
; --------
org 0x7c00 			; Sets the start addres
jmp 0x0000:_start 	; charges the DS with 0 via a far jump

OEMLabel			db "TanksBootDrive "	; Disk label
BytesPerSector		dw 512		; Bytes per sector
SectorsPerCluster	db 1		; Sectors per cluster
ReservedForBoot		dw 1		; Reserved sectors for boot record
NumberOfFats		db 2		; Number of copies of the FAT
RootDirEntries		dw 224		; Number of entries in root dir
; (224 * 32 = 7168 = 14 sectors to read)
LogicalSectors		dw 2880		; Number of logical sectors
MediumByte			db 0F0h		; Medium descriptor byte
SectorsPerFat		dw 9		; Sectors per FAT
SectorsPerTrack		dw 18		; Sectors per track (36/cylinder)
Sides				dw 2		; Number of sides/heads
HiddenSectors		dd 0		; Number of hidden sectors
LargeSectors		dd 0		; Number of LBA sectors
; MikeOS's bootloader didn't mention this but the FAT12/FAT16 extension starts here
DriveNo				dw 0		; Drive No: 0
Signature			db 41		; Drive signature: 41 for floppy
VolumeID			dd 00000000h	; Volume ID: any number
VolumeLabel			db "TanksBootDrive    "; Volume Label: any 11 chars
FileSystem			db "FAT12   "	; File system type: don't change!

_start:
	mov ah, 0x00
	mov al, 0x03 	; start the text mode
	int 0x10

	xor ax, ax 		; zeroes the DS, because from it the processor seeks the data used in the program
	mov ds, ax

	mov si, msg     ; Loads the address of "msg" into SI register

_print:
	lodsb           ; Loads the current byte from SI into AL and increments the address in SI 
	cmp al, 0       ; compares AL to zero
	je  _keypress	; if AL == 0, jump to "_keypress"
	mov ah, 0x0E    ; Set function 0xE
	mov bx, 7
	int 0x10		; Set the interrupt 0x10
	jmp _print      ; Print next character

_keypress:
	mov ah, 0x01	; Call mode for Key Stroke
    int 0x16
	mov ah, 0x00
    int 0x16
    cmp al, ' '		; compares AL to ' ' , fist step ask for press space space = ' '
    je  _reset		; If AL ==  ' ' Jump to _reset
	jmp _keypress	; Jump tp _keypress


_reset:
	mov ah, 0x0 	; AH = 0, function code that resets the disk controller
	mov dl, 0 		; drive number to be reset
	int 0x13
	jc _reset 		; in case of error retry

	mov ax, 0x50 	; move the address 0x500 (boot2 start addres)
	mov es, ax 		
	xor bx, bx

_read:
	mov ah, 0x02 	; Function code for read from disk
	mov al, 1 		; Number of sector to read
	mov ch, 0 		; Number of cilinder to read
	mov dh, 0 		; Head Number
	mov cl, 2 		; Sector Number
	mov dl, 0 		; Drive Number
	int 0x13
	jc _read 		; in case of error retry

	jmp 0x50:0x0 	; Jump to address 0x500: 0, go to boot step two (boot2)

msg: db "Welcome to Tanks Bootloader",10,13,"Press space to continue!",10,13,10,13,0 ; Message to Write on the Screen

times 510-($-$$) db 0 ; Fill the output file with zeroes until 510 bytes are full 
; Put the magic number that tells the BIOS this is bootable in the last two bits
db 0x55				; byte 511 = 55
db 0xAA				; byte 512 0xAA
 			