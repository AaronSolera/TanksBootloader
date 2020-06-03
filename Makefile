ASMFLAGS = -f bin
SOURCE = ./src/
BIN = ./bin/

bootdisk=disk.img
blocksize=512
disksize=100

BOOT1 = boot1

# bootloader 2nd stage params
BOOT2 = boot2
boot2pos= 1
boot2size= 1

# kernel params
KERNEL = kernel
kernelpos= 3
kernelsize= 6



file = $(bootdisk)

all: clean mydisk boot1 write_boot1 boot2 write_boot2 kernel write_kernel hexdump launchqemu

mydisk: 
	dd if=/dev/zero of=$(bootdisk) bs=$(blocksize) count=$(disksize) status=noxfer

boot1: 
	nasm $(ASMFLAGS) $(SOURCE)$(BOOT1).asm -o $(BIN)$(BOOT1).bin 

boot2:
	nasm $(ASMFLAGS) $(SOURCE)$(BOOT2).asm -o $(BIN)$(BOOT2).bin 

kernel:
	nasm $(ASMFLAGS) $(SOURCE)$(KERNEL).asm -o $(BIN)$(KERNEL).bin

write_boot1:
	dd if=$(BIN)$(BOOT1).bin of=$(bootdisk) bs=$(blocksize) count=1 conv=notrunc status=noxfer

write_boot2:
	dd if=$(BIN)$(BOOT2).bin of=$(bootdisk) bs=$(blocksize) seek=$(boot2pos) count=$(boot2size) conv=notrunc status=noxfer

write_kernel:
	dd if=$(BIN)$(KERNEL).bin of=$(bootdisk) bs=$(blocksize) seek=$(kernelpos) count=$(kernelsize) conv=notrunc

hexdump:
	hexdump $(file)

launchqemu:
	qemu-system-x86_64 -fda $(bootdisk)
	
clean:
	rm -f *.bin $(bootdisk) *~
