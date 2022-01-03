rm kernel.bin
git pull
nasm kernel/boot.asm -f bin -o kernel.bin
export DISPLAY=:0.0
qemu-system-i386 -drive format=raw,file=kernel.bin,index=0,if=floppy
