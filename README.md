# Codename-Proton
Proton is a small OS designed to be completely in 16-bit Real Mode assembly, both to see how close to bare metal I can get, and to see how hard it is to make something completely reliant on BIOS interrupts.


Be aware that I rarely update the README, so this may be outdated.

TODO (In order of priority):

Setup a way to reboot/shutdown the computer

Get the time from the RTC

Think of more stuff to put on here

Add a filesystem

Maybe make a GUI to run on top of this

Test on real hardware


# Credits:
https://wiki.osdev.org/Real_mode_assembly_I for almost all of the initial boot sector with strcmp, keyboard, and printf calls.

https://wiki.osdev.org/Real_Mode https://en.wikipedia.org/wiki/Real_mode for just some research on real mode.
