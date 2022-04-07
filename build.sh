git pull


cd src
#nasm boot.asm -f bin -o boot.bin
nasm kernel.asm -f bin -o kernel.bin
cd ..
#cat src/boot.bin src/kernel.bin > os.bin
bash mOSbuild.sh
qemu-system-i386 -drive format=raw,file=os.flp,index=0,if=floppy -curses
