#include "kernel.h"
#include "string/display.h"
#include "idt/idt.h"
#include "io/io.h"

void kernel_main(){
    char *msg = "Hello World!\nBye World!\n";
    display_init(20, 80);
    prints(msg, CHAR_COLOR_GREEN);
    idt_init();
    outb(0x60, 0xff);
}