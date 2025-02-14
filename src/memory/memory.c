#include "memory.h"

void* memset(void* ptr, char ch, size_t sz){
    if(ptr){
        char *cptr = (char*) ptr;
        for(int i = 0; i < sz; i++)
            cptr[i] = ch;
    }
    return ptr;
}