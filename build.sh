rm kernel.bin
git pull
nasm kernel/boot.asm -f bin -o kernel.bin
export DISPLAY=:0.0
qemu-system-i386 -drive format=raw,file=helloos.img,index=0,if=floppy
