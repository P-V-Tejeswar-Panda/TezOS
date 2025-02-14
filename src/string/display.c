#include "display.h"

uint16_t* video_mem = (uint16_t*)(0xB8000);

uint16_t ROWS;
uint16_t COLS;

uint16_t CURR_ROW;
uint16_t CURR_COL;

void putc(int row, int col, char ch, uint16_t colour){
    uint16_t out_char = colour << 8 | (uint16_t)ch;
    uint16_t loc = row * COLS + col;
    video_mem[loc] = out_char;
}

void refresh(){
    CURR_COL = 0;
    CURR_ROW = 0;
    for(int i = 0; i < ROWS; i++)
    {
        for (int j = 0; j < COLS; j++)
        {
            putc(i, j, ' ', 0);
        }
    }
}

void printc(char ch, uint16_t colour){
    if(CURR_COL == COLS){
        CURR_ROW++;
        CURR_COL = 0;
    }
    if(CURR_ROW == ROWS){
        refresh();
    }
    if(ch != '\n'){
        putc(CURR_ROW, CURR_COL, ch, colour);
        CURR_COL++;
    }
    else{
        CURR_ROW++;
        CURR_COL = 0;
    }
}
int ssizeof(char* str){
    int sz = 0;
    while(str[sz] != '\0'){
        sz++;
    }
    return sz;
}
void prints(char* str, uint16_t colour){
    int str_sz = ssizeof(str);
    for(int i = 0; i < str_sz; i++){
        printc(str[i], colour);
    }
}
void display_init(uint16_t R, uint16_t C){
    ROWS = R;
    COLS = C;
    refresh();
}