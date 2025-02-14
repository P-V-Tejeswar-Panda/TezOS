#ifndef _IDT_H_
#define _IDT_H_
#include <stdint.h>

struct IDT_Entry{
    uint16_t offset_1;
    uint16_t selector;
    uint8_t  zero;
    uint8_t  type_attributes;
    uint16_t offset_2;
}__attribute__((packed));

struct IDTR_Data{
    uint16_t  size;
    uint32_t  offset;
}__attribute__((packed));

void idt_init();

#endif