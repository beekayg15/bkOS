22 Feb 2026 — 9:57 PM

MOV dst, src — Moves from source to destination.
This is equivalent to this statement in C:  `dst  = src;`

Referencing a memory location:
`segment: [base + index * scale + displacement]`

segments: CS, DS, ES, FS, GS, SS
if unspecified, SS is used when base register is BP, otherwise DS is used.

### Loading rest of the Operating System

The disk can be partitioned into two modules: The Bootloader and the Kernel.

The bootloader,
- loads basic components into the memory
- puts the system in expected state
- collects information about the system

Why floppy disks?
- ease to use
- universal support
- FAT12 — one of the simplest file systems
