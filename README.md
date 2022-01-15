# Codename-Proton
Proton is a small OS designed to be completely in 16-bit Real Mode assembly, both to see how close to bare metal I can get, and to see how hard it is to make something completely reliant on BIOS interrupts.


Be aware that I rarely update the README, so this may be outdated.

TODO (In order of priority):

Add a filesystem (used mikeOS bootloader to put kernel on FAT12, and then loaded it, so kinda like 1/3 of the way there)

Make it so you can "install" the OS to another drive. (read everything off the first ~8 sectors of the install media and copy it?)
(not just the filesystem, we're copying this dd style)

Setup a way to reboot/shutdown the computer (Reboot done, shutdown in progress)

Get the time from the RTC

License keys and product activation (time for some dumb crap)

Think of more stuff to put on here

Check out options for networking drivers

Maybe make a GUI to run on top of this

Test on real hardware


# Credits:
https://wiki.osdev.org/Real_mode_assembly_I for almost all of the initial boot sector with strcmp, keyboard, and printf calls.

https://wiki.osdev.org/Real_Mode https://en.wikipedia.org/wiki/Real_mode for just some research on real mode.

https://github.com/mig-hub/mikeOS/tree/master/source The mikeOS project, for the bootloader, and probably some fat12 read file calls in the future

Many, many visits to Stack Overflow and the OSDev wiki.
