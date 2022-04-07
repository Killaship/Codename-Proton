git pull

nasm kernel/boot.asm -f bin -o boot.bin
cd src
nasm kernel.asm -f bin -o kernel.bin
cd ..
cat boot.bin kernel.bin > os.bin
#bash mOSbuild.sh
qemu-system-i386 -drive format=raw,file=os.bin,index=0,if=floppy -curses
