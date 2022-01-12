# Codename-Proton
Proton is a small OS designed to be completely in 16-bit Real Mode assembly, both to see how close to bare metal I can get, and to see how hard it is to make something completely reliant on BIOS interrupts.


Be aware that I rarely update the README, so this may be outdated.

TODO (In order of priority):

Make it so you can "install" the OS to another drive. (read everything off the first ~8 sectors of the install media and copy it?)

Setup a way to reboot/shutdown the computer (Reboot done, shutdown in progress)

Get the time from the RTC

License keys and product activation (time for some dumb crap)

Think of more stuff to put on here

Check out options for networking drivers

Add a filesystem

Maybe make a GUI to run on top of this

Test on real hardware


# Credits:
https://wiki.osdev.org/Real_mode_assembly_I for almost all of the initial boot sector with strcmp, keyboard, and printf calls.

https://wiki.osdev.org/Real_Mode https://en.wikipedia.org/wiki/Real_mode for just some research on real mode.

Many, many visits to Stack Overflow and the OSDev wiki.
