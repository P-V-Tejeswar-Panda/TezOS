[BITS 32]
global _start
extern kernel_main

CODE_SEG equ 0x08
DATA_SEG equ 0x10

_start:
    MOV AX, DATA_SEG
    MOV DS, AX
    MOV ES, AX
    MOV FS, AX
    MOV GS, AX
    MOV SS, AX
    MOV EBP, 0x00200000
    MOV ESP, EBP

; Remap Master Programmable Interrupt Controller
    MOV AL, 00010001b
    OUT 0x20, AL ; put master PIC in innitialization mode

    MOV AL, 0x20
    OUT 0x21, AL

    MOV AL, 00000001b
    OUT 0x21, AL
; master PIC remapped

; enable A20 Line
    IN AL, 0x92
    OR AL, 2
    OUT 0x92, AL

    STI
    call kernel_main

    JMP $

times 512-($-$$) DB 0