git pull
#nasm kernel/boot.asm -f bin -o boot.bin
nasm kernel/kernel.asm -f bin -o kernel.bin
qemu-system-i386 -drive format=raw,file=kernel.bin,index=0,if=floppy -curses

