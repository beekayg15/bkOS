19 Feb 2026 — 11:36 PM
#### Requirements 
-  A text editor, for which Visual Studio Code and NeoVim, are going to be the obvious choices
- Make, though I prefer Just
- NASM as the assembler
- qemu, or any other virtualization software

I will be building it for the x86 architecture. The CISC might be less efficient compared to the modern RISC instruction set. But I will be acknowledging the 40 year legacy of the x86.

#### How a computer starts up
1. BOS is copied from a ROM chip into a RAM
2. BIOS starts executing code 
	1. initializes hardware
	2. runs some tests, like the power-on self test
3. BIOS searches for an operating system to start
4. BIOS loads and starts the operating system
5. Operating system runs

#### How the BIOS finds an OS
##### Legacy booting
- NIOS loads first sector of each bootable device into the memory, at location 0x&C00
- BIOS checks for 0xAA55 signature
- If found, it starts executing the code
The two magic constants of the x86. 

0x7C00 — The Bootloader Load Address
```
When a PC powers on, the BIOS loads the first 512 bytes of a bootable disk (the Master Boot Record) into RAM at the physical address **0x7C00** and then jumps execution there. This is where your bootloader code begins running.

Why 0x7C00 specifically? It's historical — chosen in the early days of IBM PC design so the 512-byte bootloader sits near the top of the first 32KB of RAM, leaving space below it for the BIOS interrupt vector table and data, and space above for the loaded OS. The exact value (32KB − 1KB = 0x7C00) was a deliberate layout decision by IBM/Microsoft engineers in 1981.
```

0xAA55 — The Boot Signature
```
The last 2 bytes of the 512-byte MBR must be **0x55** followed by **0xAA** (stored little-endian, so it reads as 0xAA55 in a hex dump). The BIOS checks for this magic signature to confirm the disk is bootable. If it's missing, the BIOS skips that device and tries the next one.
```

##### EFI
- BIOS looks into special EFI partitions
- Operating system must be compiled a a EFI program

### Directives & Instructions

ORG (directive) — Tells assembler where we expect our code to be loaded. The assembler uses this information to calculate label addresses.

Directive — Gives a clue to the assembler that will affect how the program gets compiled. Not translated to machine code! Assembler specific - different assemblers might have different directives.

Instructions — Translated to a machine code instruction that the CPU will execute.

BITS (directive) — Tells assembler to emit 16/32/64-bit code

HLT — Stops CPU from executing; it will be resumed by an interrupt.

JMP location — Jumps to the given location, unconditionally; equivalent with goto instruction in C

DB byte1, byte2, byte3 ... (directive) — Stands for "define byte(s)". Writes given bytes to the assembled binary file

TIMES number instruction/data (directive) — Repeats given instruction or a piece of data a number of times

`$` — Special symbol which is equal to the memory offset of the current line

`$$` — Special symbol which is equal to the memry offset of the beginning of the current section, in our case, program

`$ - $$` — Gives the size of out program so far, in bytes

DW word1, word2, word3 ... (directive) — Stands for "define word(s)". Writes given word(s) (2 byte value, encoded in little endian) ot the assembled binary file

CLI — disables interrupts

LODSB, LODSW, LODSD — loads a byte, word, or a double word and moves to the next address

JZ — conditional jump, if the zero flag is set'

Interrupts — A signal which makes the processor stop what it's doing, in order to handle that signal. Can be triggered by:
1. An exception — Example, dividing by zero, segmentation fault, page fault
2. Hardware — Example, keyboard key press
3. Software — through the INT instruction