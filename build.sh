git pull
nasm kernel/kernel.asm -f bin -o kernel.bin
qemu-system-i386 -fda kernel.bin
