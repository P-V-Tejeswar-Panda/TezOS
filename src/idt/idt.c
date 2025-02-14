#include "idt.h"
#include "config.h"
#include "memory/memory.h"
#include "string/display.h"
#include "io/io.h"

struct IDT_Entry idt[TOTAL_INTERRUPTS];
struct IDTR_Data idtr;

extern void idt_load(struct IDTR_Data* ptr);
extern void int21h();
extern void no_interrupt();

void no_interrupt_handler(){
    outb(0x20, 0x20);
}

void int21h_handler(){
    prints("Keyboard Pressed!\n", CHAR_COLOR_GREEN);
    outb(0x20, 0x20);
}
void idt_zero_handler(){
    prints("Divide by zero error!\n", CHAR_COLOR_WHITE);
}

void idt_set(int interrupt_no, void* address){
    struct IDT_Entry *idt_entry = &idt[interrupt_no];
    idt_entry->offset_1         = (uint32_t) address & 0x0000FFFF;
    idt_entry->offset_2         = (uint32_t) address >> 16;
    idt_entry->selector         = KERNEL_CODE_SELECTOR;
    idt_entry->zero             = 0x0;
    idt_entry->type_attributes  = 0xEE; 
}
void idt_init(){
    memset(idt, 0, sizeof(idt));
    idtr.size = sizeof(idt) - 1;
    idtr.offset = (uint32_t)idt;

    for(int i = 0; i < TOTAL_INTERRUPTS; i++){
        idt_set(i, no_interrupt);
    }
    idt_set(0, idt_zero_handler);
    idt_set(0x21, int21h);
    idt_load(&idtr);
}