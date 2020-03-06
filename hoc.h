#ifndef SYMBOL_H
#define SYMBOL_H

typedef struct symbol {
    char *name;
    int type;
    union {
        double val;
        double (*ptr)(double);
    } u;
    struct symbol *next;
} symbol;

symbol *install(), *lookup();
void err(char *s);
#endif
