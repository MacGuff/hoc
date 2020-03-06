#include "hoc.h"
#include "y.tab.h"
#include <math.h>


static struct {
    char *name;
    double cval;
} consts[] = {
    {"PI", 3.1415926},
    {"E", 2.71828184},
    {0, 0}
};

static struct {
    char *name;
    double (*func)();
} builtins[] = {
    {"sin", sin},
    {0, 0}
};

void init()
{
    int i;
    symbol *s;

    for (i = 0; consts[i].name; i++)
        install(consts[i].name, VAR, consts[i].cval);
    for (i = 0; builtins[i].name; i++) {
        s = install(builtins[i].name, BLTIN, 0.0);
        s->u.ptr = builtins[i].func;
    }
}
