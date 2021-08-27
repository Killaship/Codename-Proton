git pull
nasm kernel/loader.asm -f bin -o loader.bin
nasm kernel/kernel.asm -f bin -o kernel.bin
cat loader.bin kernel.bin > image.bin
export DISPLAY=:0.0
qemu-system-i386 -fda image.bin
