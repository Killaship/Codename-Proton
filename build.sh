git pull
rm boot
rm os.flp
#nasm kernel/boot.asm -f bin -o boot.bin
cd src
nasm src/kernel.asm -f bin -o kernel.bin
cd ..
#cat boot.bin kernel.bin > os.bin
bash mOSbuild.sh
qemu-system-i386 -drive format=raw,file=mikeos.flp,index=0,if=floppy -curses
