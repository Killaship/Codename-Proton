#!/bin/sh

# This script assembles the MikeOS bootloader, kernel and programs
# with NASM, and then creates floppy and CD images (on Linux)

# Only the root user can mount the floppy disk image as a virtual
# drive (loopback mounting), in order to copy across the files

# (If you need to blank the floppy image: 'mkdosfs disk_images/mikeos.flp')
rm -rf tmp-loop

if test "`whoami`" != "root" ; then
	echo "You must be logged in as root to build (for loopback mounting)"
	echo "Enter 'su' or 'sudo bash' to switch to root"
	exit
fi


if [ ! -e mikeos.flp ]
then
	echo ">>> Creating new MikeOS floppy image..."
	mkdosfs -C mikeos.flp 1440 || exit
fi


echo ">>> Assembling bootloader..."

nasm -O0 -w+orphan-labels -f bin -o src/boot.bin src/boot.asm || exit


echo ">>> Assembling MikeOS kernel..."

cd src
nasm -O0 -w+orphan-labels -f bin -o kernel.bin kernel.asm || exit
cd ..



echo ">>> Adding bootloader to floppy image..."

dd status=noxfer conv=notrunc if=src/boot.bin of=mikeos.flp || exit


echo ">>> Copying MikeOS kernel..."

rm -rf tmp-loop

mkdir tmp-loop && mount -o loop -t vfat mikeos.flp tmp-loop && cp src/kernel.bin tmp-loop/


echo ">>> Unmounting loopback floppy..."

umount tmp-loop || exit

