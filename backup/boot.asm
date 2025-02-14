ORG 0x7c00
BITS 16

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

; BIOS Block Start
_start:
    JMP SHORT start
    nop

times 33 DB 0
; BIOS Block End
; BootLoader Start
start:
    JMP 0:step2

step2:
    CLI ; clear inturrupts
    MOV AX, 0x00
    MOV DS, AX
    MOV ES, AX
    MOV SS, AX
    MOV SP, 0x7c00
    STI ; enable inturrupts

.load_protected:
    CLI             ; clear intrrupts
    LGDT[gdt_descriptor]
    MOV  EAX, CR0
    OR   EAX, 0x1
    MOV  CR0, EAX
    JMP  CODE_SEG:load32

; Important part of Bootloader end here. Rest of this sector is helper

; GDT
; each GDT entry is 64 Bytes in length

gdt_start:
gdt_null:
    DD 0x0
    DD 0x0
; at location 0x8
; gdt_code starts as 8th byte starting from gdt_start
gdt_code:        ; CS should point to this
    DW 0xffff    ;
    DW 0         ;
    DB 0         ;
    DB 0x9a      ;
    DB 11001111b ;
    DB 0         ;
; at location 0x10 (16th Byte)
gdt_data:        ; DS, SS, FS, GS
    DW 0xffff    ;
    DW 0         ;
    DB 0         ;
    DB 0x92      ;
    DB 11001111b ;
    DB 0         ;

; at location 0x18 (24th Byte)
gdt_end:         ; marks the end of the GDT

; this will be loaded to the GDT register, GDTR
gdt_descriptor:
    DW gdt_end - gdt_start - 1 ; 24 - 0 - 1 gdt is there in [0-23] byte
    DD gdt_start               ; this will point to the 0th byte of GDT 

[BITS 32]
load32:
    MOV EAX, 1
    MOV ECX, 100
    MOV EDI, 0x0100000
    CALL ata_lba_read
    JMP CODE_SEG:0x0100000

ata_lba_read:
    MOV EBX, EAX
    SHR EAX, 24
    OR  AL, 0xE0
    MOV DX, 0x1F6
    OUT DX, AL

    MOV EAX, ECX
    MOV DX, 0x1F2
    OUT DX, AL

    MOV EAX, EBX
    MOV DX, 0x1F3
    OUT DX, AL

    MOV EAX, EBX
    SHR EAX, 8
    MOV DX, 0x1F4
    OUT DX, AL

    MOV EAX, EBX
    SHR EAX, 16
    MOV DX, 0x1F5
    OUT DX, AL

    MOV DX, 0x1F7
    MOV AL, 0x20
    OUT DX, AL

.next_sector:
    push ECX

.try_again:
    MOV DX, 0x1F7
    IN AL, DX
    TEST AL, 8
    JZ .try_again

    MOV ECX, 256
    MOV DX, 0x1F0
    REP INSW
    POP ECX
    LOOP .next_sector
    RET

times 510-($-$$) DB 0
dw 0xAA55
; first sector ends here.