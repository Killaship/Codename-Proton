rm kernel.bin
git pull
nasm kernel/boot.asm -f bin -o boot.bin
nasm kernel/kernel.asm -f bin -o kernel.bin
export DISPLAY=:0.0
qemu-system-i386 -drive format=raw,file=boot.bin,index=0,if=floppy -fdb kernel.bin

