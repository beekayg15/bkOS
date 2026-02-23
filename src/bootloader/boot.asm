org 0x7C00
bits 16

%define ENDL 0x0D, 0x0A

;
; FAT12 Header
;
jmp short start 
nop

bdb_oem:                    db 'MSWIN4.1'           ; OEM identifier - name of the formatting OS (8 bytes, FAT12 spec requires this field)
bdb_bytes_per_sector:       dw 512                  ; bytes in each sector (512 is standard for floppy)
bdb_sectors_per_cluster:    db 1                    ; how many sectors make up one cluster (smallest unit of allocation)
bdb_reserved_sectors:       dw 1                    ; sectors reserved for the bootloader (sector 0 = this boot sector)
bdb_fat_count:              db 2                    ; number of FAT tables on disk (2 = one backup copy)
bdb_dir_entries_count:      dw 0E0h                 ; max number of entries in the root directory (224 for floppy)
bdb_total_sectors:          dw 2880                 ; total sectors on disk (2880 * 512 = 1.44MB floppy)
bdb_media_descriptor_type:  db 0F0h                 ; type of media (0xF0 = 3.5" 1.44MB floppy)
bdb_sectors_per_fat:        dw 9                    ; how many sectors each FAT table occupies
bdb_sectors_per_track:      dw 18                   ; sectors per track (floppy geometry)
bdb_heads:                  dw 2                    ; number of read/write heads (floppy has top and bottom = 2)
bdb_hidden_sectors:         dd 0                    ; sectors before this partition (0 for floppy, no partitioning)
bdb_large_sector_count:     dd 0                    ; used if total sectors > 65535, otherwise 0

; extended boot record
ebr_drive_number:           db 0                    ; BIOS drive number (0x00 = floppy, 0x80 = hard disk)
                            db 0                    ; reserved byte, must be 0
ebr_signature:              db 29h                  ; magic number (0x29) that marks a valid extended boot record
ebr_volume_id:              db 12h, 34h, 56h, 78h   ; unique serial number for this volume (can be arbitrary)
ebr_volume_label:           db 'BEEKAYG15OS'        ; volume name, 11 bytes, padded with spaces if shorter
ebr_system_id:              db 'FAT12   '           ; filesystem type identifier, 8 bytes (padded with spaces)

;
; Code
;

start:
    jmp main

;
; Prints a string to the screen
; Params:
;   - ds:si points to the string
;
puts: 
    ; save registers we will modify
    push si
    push ax

.loop:
    lodsb           ; loads next character in al
    or al, al       ; verify if next character is null
    jz .done

    mov ah, 0x0e    ; call bios interrupt
    mov bh, 0       ; sets the display page number to 0 (the default visible page)
    int 0x10

    jmp .loop

.done:
    pop ax
    pop si
    ret 

main:
    ; setup data segments
    mov ax, 0       ; can't write to ds/es directly
    mov ds, ax
    mov es, ax

    ; setup stack
    mov ss, ax
    mov sp, 0x7C00  ; stack grows downwards from where er are loaded in memory

    ; print message
    mov si, msg_hello
    call puts

    cli
    hlt

.halt:
    jmp .halt

msg_hello: db 'Hello world!', ENDL, 0

times 510-($-$$) db 0
dw 0xAA55