git pull
nasm kernel/kernel.asm -f bin -o kernel.bin
export DISPLAY=:0.0
qemu-system-i386 -fda kernel.bin
