global insb
global insw
global outb
global outw

insb:
    PUSH EBP
    MOV EBP, ESP
    XOR EAX, EAX
    MOV EDX, [EBP+8]
    IN  AL, DX
    POP EBP
    RET

insw:
    PUSH EBP
    MOV EBP, ESP
    XOR EAX, EAX
    MOV EDX, [EBP+8]
    IN  AX, DX
    POP EBP
    RET

outb:
    PUSH EBP
    MOV EBP, ESP
    XOR EAX, EAX
    MOV EAX, [EBP+12]
    MOV EDX, [EBP+8]
    OUT DX, AL
    POP EBP
    RET

outw:
    PUSH EBP
    MOV EBP, ESP
    XOR EAX, EAX
    MOV EAX, [EBP+12]
    MOV EDX, [EBP+8]
    OUT DX, AX
    POP EBP
    RET
