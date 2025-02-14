section .asm

extern int21h_handler
global int21h

extern no_interrupt_handler
global no_interrupt

global idt_load
idt_load:
    PUSH EBP
    MOV  EBP, ESP
    MOV  EBX, [EBP+8]
    LIDT [EBX]
    POP  EBP
    RET

int21h:
    CLI
    PUSHAD
    call int21h_handler
    POPAD
    STI
    IRET

no_interrupt:
    CLI
    PUSHAD
    call no_interrupt_handler
    POPAD
    STI
    IRET