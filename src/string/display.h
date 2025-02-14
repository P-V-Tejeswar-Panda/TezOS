#ifndef _DISPLAY_H_
#define _DISPLAY_H_
#include <stdint.h>

#define CHAR_COLOR_WHITE 1
#define CHAR_COLOR_GREEN 2

void printc(char ch, uint16_t colour);
void refresh();
int ssizeof(char* str);
void prints(char* str, uint16_t colour);
void display_init(uint16_t R, uint16_t C);

#endif